import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../../../data/services/ai_service.dart';
import '../../../data/services/speech_service.dart';
import '../../../data/services/firebase_service.dart';

class HomeController extends GetxController {
  // Services
  final AIService _aiService = AIService();
  final SpeechService _speechService = SpeechService();
  final FirebaseService _firebaseService = FirebaseService();

  // Camera
  CameraController? cameraController;
  List<CameraDescription> cameras = [];

  // Observable variables
  final isCameraInitialized = false.obs;
  final isVoiceRecognitionActive = false.obs;
  final isCameraActive = false.obs;
  final isRecording = false.obs;
  final isProcessing = false.obs;
  final isSpeaking = false.obs;
  final userQuestion = ''.obs;
  final aiResponse = ''.obs;
  final isListening = false.obs;

  // Timer for periodic image capture
  Timer? _captureTimer;

  @override
  void onInit() {
    super.onInit();
    initializeServices();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _captureTimer?.cancel();
    _speechService.dispose();
    super.onClose();
  }

  Future<void> initializeServices() async {
    try {
      // Initialize speech service
      await _speechService.initialize();

      // Initialize camera
      await initializeCamera();
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  Future<void> initializeCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status.isGranted) {
        cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // Find front camera (selfie camera)
          final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

          cameraController = CameraController(
            frontCamera,
            ResolutionPreset.high,
            enableAudio: false,
          );
          await cameraController!.initialize();
          isCameraInitialized.value = true;
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void toggleCamera() {
    if (isCameraActive.value) {
      stopCamera();
    } else {
      startCamera();
    }
  }

  void startCamera() {
    if (isCameraInitialized.value && cameraController != null) {
      isCameraActive.value = true;
      startPeriodicCapture();
    }
  }

  void stopCamera() {
    isCameraActive.value = false;
    stopPeriodicCapture();
  }

  void startPeriodicCapture() {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isCameraActive.value && !isProcessing.value) {
        captureAndProcessImage();
      }
    });
  }

  void stopPeriodicCapture() {
    _captureTimer?.cancel();
  }

  Future<void> captureAndProcessImage() async {
    if (cameraController == null || !isCameraInitialized.value) return;

    try {
      isProcessing.value = true;

      // Capture image
      final XFile image = await cameraController!.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      // Process with AI if there's a user question
      if (userQuestion.value.isNotEmpty) {
        final response = await _aiService.processImageAndText(
          imageBytes: imageBytes,
          userQuestion: userQuestion.value,
        );

        aiResponse.value = response;

        // Speak the response
        await _speechService.speak(response);

        // Log interaction
        await _firebaseService.logInteraction(
          userQuestion: userQuestion.value,
          aiResponse: response,
          hasImage: true,
        );

        // Clear user question after processing
        userQuestion.value = '';
      }
    } catch (e) {
      print('Error capturing and processing image: $e');
      await _firebaseService.logError(
        error: e.toString(),
        context: 'captureAndProcessImage',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void toggleVoiceRecognition() {
    if (isVoiceRecognitionActive.value) {
      stopVoiceRecognition();
    } else {
      startVoiceRecognition();
    }
  }

  void startVoiceRecognition() {
    isVoiceRecognitionActive.value = true;
    _speechService.startListening(
      onResult: (text) {
        userQuestion.value = text;
        isListening.value = false;

        // Process with AI immediately
        processUserQuestion();
      },
      onListeningComplete: () {
        isListening.value = false;
        isVoiceRecognitionActive.value = false;
      },
    );
    isListening.value = true;
  }

  void stopVoiceRecognition() {
    _speechService.stopListening();
    isVoiceRecognitionActive.value = false;
    isListening.value = false;
  }

  Future<void> processUserQuestion() async {
    if (userQuestion.value.isEmpty) return;

    try {
      isProcessing.value = true;

      String response;
      if (isCameraActive.value && cameraController != null) {
        // Capture current image and process with vision
        final XFile image = await cameraController!.takePicture();
        final Uint8List imageBytes = await image.readAsBytes();

        response = await _aiService.processImageAndText(
          imageBytes: imageBytes,
          userQuestion: userQuestion.value,
        );
      } else {
        // Process text only
        response = await _aiService.processTextOnly(userQuestion.value);
      }

      aiResponse.value = response;

      // Speak the response
      await _speechService.speak(response);

      // Log interaction
      await _firebaseService.logInteraction(
        userQuestion: userQuestion.value,
        aiResponse: response,
        hasImage: isCameraActive.value,
      );
    } catch (e) {
      print('Error processing user question: $e');
      aiResponse.value = 'Sorry, there was an error processing your request.';
      await _firebaseService.logError(
        error: e.toString(),
        context: 'processUserQuestion',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void cancelAction() {
    isCameraActive.value = false;
    isVoiceRecognitionActive.value = false;
    isRecording.value = false;
    stopVoiceRecognition();
    _speechService.stopSpeaking();
    userQuestion.value = '';
    aiResponse.value = '';
  }

  void confirmAction() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  void startRecording() {
    if (isCameraActive.value) {
      isRecording.value = true;
      startVoiceRecognition();
    }
  }

  void stopRecording() {
    isRecording.value = false;
    stopVoiceRecognition();
  }

  // Getters for UI
  bool get speechEnabled => _speechService.speechEnabled;
}
