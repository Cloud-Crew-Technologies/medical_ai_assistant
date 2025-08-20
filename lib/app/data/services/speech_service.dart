import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  // Getters
  bool get speechEnabled => _speechEnabled;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;

  Future<void> initialize() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _speechEnabled = await _speechToText.initialize(
          onError: (error) {
            print('Speech recognition error: $error');
          },
          onStatus: (status) {
            print('Speech recognition status: $status');
          },
        );
      }

      // Initialize TTS
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        print('TTS error: $msg');
      });
    } catch (e) {
      print('Error initializing speech services: $e');
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onListeningComplete,
  }) async {
    if (!_speechEnabled) {
      print('Speech recognition not enabled');
      return;
    }

    try {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            onListeningComplete();
            _isListening = false;
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: "en_US",
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
      _isListening = false;
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
  }

  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}
