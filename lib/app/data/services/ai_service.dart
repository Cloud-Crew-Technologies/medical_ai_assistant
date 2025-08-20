import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _apiKey =
      'AIzaSyAK556VAaX1AZ_USE7FYZuvGbFzfAMkgfY'; // Replace with your actual API key
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent';

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-pro-vision',
    apiKey: _apiKey,
  );

  Future<String> processImageAndText({
    required Uint8List imageBytes,
    required String userQuestion,
  }) async {
    try {
      // Create the content parts
      final content = [
        Content.text(userQuestion),
        Content.data(
          'image/jpeg',
          imageBytes,
        ),
      ];

      // Generate content using Gemini
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return 'Sorry, I couldn\'t process your request. Please try again.';
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'Sorry, there was an error processing your request. Please check your internet connection and try again.';
    }
  }

  Future<String> processTextOnly(String userQuestion) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _apiKey,
      );

      final response =
          await model.generateContent([Content.text(userQuestion)]);

      if (response.text != null) {
        return response.text!;
      } else {
        return 'Sorry, I couldn\'t process your request. Please try again.';
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'Sorry, there was an error processing your request. Please check your internet connection and try again.';
    }
  }
}
