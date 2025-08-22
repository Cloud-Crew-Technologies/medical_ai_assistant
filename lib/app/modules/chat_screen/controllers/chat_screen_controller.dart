import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_ai_assistant/app/modules/chat_screen/models/message_model.dart';

class ChatController extends GetxController {
  // Observable list of messages
  final RxList<Message> messages = <Message>[].obs;
  
  // Text controller for input field
  final TextEditingController textController = TextEditingController();
  
  // Scroll controller for chat list
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadDummyMessages();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Load dummy messages
  void loadDummyMessages() {
    final dummyMessages = [
      Message(
        id: '1',
        text: 'Hi 👋, I am your medical support assistant. Could you tell me what symptoms you are experiencing?',
        senderId: 'user1',
        senderName: 'Doctor AI ',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
        avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
      ),
      Message(
        id: '2',
        text: 'Hello, I need some help regarding my health. I have a headache and mild fever since yesterday.',
        senderId: 'me',
        senderName: 'Me',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isMe: true,
      ),
      Message(
        id: '3',
        text: 'Thanks for sharing. Do you also have symptoms like cough, sore throat, or body pain?',
        senderId: 'user1',
        senderName: 'Doctor AI ',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isMe: false,
        avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
      ),
      Message(
        id: '4',
        text: 'Yes, I have body pain but no cough.',
        senderId: 'me',
        senderName: 'Me',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        isMe: true,
      ),
      Message(
        id: '5',
        text: 'Understood. Based on your symptoms, it could be a common viral infection. Please note, I am not a doctor. For proper diagnosis, consult a healthcare professional.',
        senderId: 'user1',
        senderName: 'Doctor AI ',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
        avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
      ),
      Message(
        id: '6',
        text: 'Okay, thanks. Can you suggest something I can do now?',
        senderId: 'me',
        senderName: 'Me',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isMe: true,
      ),
      Message(
        id: '7',
        text: 'You can stay hydrated 💧, take adequate rest 🛌, and monitor your temperature. If the fever goes above 101°F or symptoms worsen, please visit a doctor immediately.',
        senderId: 'user1',
        senderName: 'Doctor AI ',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
        avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
      ),
      Message(
        id: '8',
        text: 'Got it, thank you. I will follow your advice.',
        senderId: 'me',
        senderName: 'Me',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isMe: true,
      ),
      Message(
        id: '9',
        text: 'You are welcome! If you have any more questions, feel free to ask. Take care! 😊',
        senderId: 'user1',
        senderName: 'Doctor AI ',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isMe: false,
        avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
      ),
    ];

    messages.addAll(dummyMessages);
    scrollToBottom();
  }

  // Send a new message
  void sendMessage() {
    if (textController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: textController.text.trim(),
      senderId: 'me',
      senderName: 'Me',
      timestamp: DateTime.now(),
      isMe: true,
    );

    messages.add(newMessage);
    textController.clear();
    scrollToBottom();

    // Simulate response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      simulateResponse();
    });
  }

  // Simulate an automatic response
  void simulateResponse() {
    final responses = [
      "Can you describe your symptoms more clearly?",
    "How long have you been feeling this way?",
    "Do you have any other health conditions?",
    "Have you taken any medication for this?",
    "I understand. Please remember, I can only provide general guidance.",
    "It might be a mild issue, but if it worsens, you should consult a doctor.",
    "Staying hydrated and resting could help.",
    "Could you rate your pain or discomfort from 1 to 10?",
    "Noted. Are you experiencing fever or fatigue?",
    "Thanks for sharing. I recommend monitoring your symptoms closely."
    ];

    final randomResponse = responses[DateTime.now().millisecond % responses.length];

    final responseMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: randomResponse,
      senderId: 'user1',
      senderName: 'Doctor AI ',
      timestamp: DateTime.now(),
      isMe: false,
      avatarUrl: 'https://cdn.dribbble.com/userupload/2798815/file/original-d8b75e59492e979ad996c39eac216499.png?resize=752x&vertical=center',
    );

    messages.add(responseMessage);
    scrollToBottom();
  }

  // Scroll to bottom of chat
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Format timestamp
  String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}