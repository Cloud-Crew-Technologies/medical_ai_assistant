# Medical AI Assistant

A Flutter AI assistant app that uses camera, speech-to-text, and Gemini API to provide intelligent responses.

## Features

- **Camera Integration**: Captures images periodically and processes them with AI
- **Speech-to-Text**: Converts spoken input to text using device microphone
- **Gemini AI Integration**: Uses Google's Gemini Pro Vision model for image and text processing
- **Text-to-Speech**: Speaks AI responses aloud using flutter_tts
- **Firebase Integration**: Logs interactions and user authentication
- **Modern UI**: Beautiful dark theme with glowing effects

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.4.3 or higher)
- Android Studio / VS Code
- Android device or emulator
- Google Cloud Project with Gemini API enabled

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Gemini API

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Open `lib/app/data/services/ai_service.dart`
4. Replace `YOUR_GEMINI_API_KEY` with your actual API key:

```dart
static const String _apiKey = 'your_actual_api_key_here';
```

### 4. Firebase Setup (Optional)

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android app to the project
3. Download `google-services.json` and place it in `android/app/`
4. Enable Firestore Database in your Firebase project

### 5. Permissions

The app requires the following permissions:
- Camera access for image capture
- Microphone access for speech recognition
- Internet access for API calls

These are already configured in `android/app/src/main/AndroidManifest.xml`.

### 6. Run the App

```bash
flutter run
```

## Usage

1. **Voice Recognition**: Tap the microphone button to start voice recognition
2. **Camera Mode**: Tap the camera button to activate camera mode
3. **Ask Questions**: Speak your question while the camera is active
4. **AI Response**: The app will process your question with the captured image and respond both visually and audibly

## Architecture

### Services

- **AIService**: Handles Gemini API integration
- **SpeechService**: Manages speech-to-text and text-to-speech
- **FirebaseService**: Handles authentication and logging

### Controllers

- **HomeController**: Main controller managing app state and interactions

### Views

- **HomeView**: Main UI with camera preview, voice controls, and response display

## Dependencies

- `google_generative_ai`: Gemini API integration
- `speech_to_text`: Speech recognition
- `flutter_tts`: Text-to-speech
- `camera`: Camera functionality
- `firebase_core`, `cloud_firestore`, `firebase_auth`: Firebase services
- `permission_handler`: Permission management
- `get`: State management

## Troubleshooting

### Common Issues

1. **Camera not working**: Ensure camera permissions are granted
2. **Speech recognition not working**: Check microphone permissions
3. **API errors**: Verify your Gemini API key is correct
4. **Firebase errors**: Ensure Firebase is properly configured

### Debug Mode

Run with verbose logging:
```bash
flutter run --verbose
```

## Security Notes

- Never commit your API keys to version control
- Use environment variables or secure storage for production
- Implement proper error handling for API failures

## License

This project is for educational purposes. Please ensure compliance with Google's API terms of service.
