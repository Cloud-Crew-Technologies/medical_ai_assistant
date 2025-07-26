import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription> cameras = [];

  final isCameraInitialized = false.obs;
  final isVoiceRecognitionActive = false.obs;
  final isCameraActive = false.obs;
  final isRecording = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
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
            orElse: () => cameras
                .first, // Fallback to first camera if no front camera found
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
    }
  }

  void stopCamera() {
    isCameraActive.value = false;
  }

  void toggleVoiceRecognition() {
    isVoiceRecognitionActive.value = !isVoiceRecognitionActive.value;
  }

  void cancelAction() {
    isCameraActive.value = false;
    isVoiceRecognitionActive.value = false;
    isRecording.value = false;
  }

  void confirmAction() {
    // Handle confirmation action
    if (isRecording.value) {
      // Stop recording and process
      isRecording.value = false;
    } else {
      // Start recording or process current state
      isRecording.value = true;
    }
  }

  void startRecording() {
    if (isCameraActive.value) {
      isRecording.value = true;
    }
  }

  void stopRecording() {
    isRecording.value = false;
  }
}
