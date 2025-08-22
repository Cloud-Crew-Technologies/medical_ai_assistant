import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:medical_ai_assistant/app/theme/theme_data.dart';

import '../controllers/chat_screen_controller.dart';
import 'package:medical_ai_assistant/app/modules/chat_screen/models/message_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreenView extends GetView<ChatController> {
  const ChatScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
          child: AppBar(
            backgroundColor:
                isDark ? const Color(0xFF1E293A) : kLightPrimaryColor,
            elevation: 5,
            toolbarHeight: 100,
            titleSpacing: 0,
            centerTitle: false,
            leadingWidth: 100, // Make room for text + chevron
            leading: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF384050) : kButtonColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dr. John Doe AI",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.7), // solid color
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      "${controller.messages.length} Conversations • Online",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    )),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF384050) : kButtonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.message,
                      color: isDark ? Colors.white : Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return ChatBubble(
                      message: message,
                      formatTime: controller.formatTime,
                    );
                  },
                )),
          ),
          // Message input area
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color:
                  isDark ? const Color(0xFF1E293A) : kLightPrimaryColor,
              border: Border(
                top: BorderSide(color: const Color(0xFF384050)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isDark ? 16 : 12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF020617) : kLightSecondaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 20,
                      ),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF384050) : kLightCardColor,
                    borderRadius: BorderRadius.circular(isDark ? 16 : 12),
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: kDarkSlateButtonColor.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(Icons.send,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: controller.sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final Message message;
  final String Function(DateTime) formatTime;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.formatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: message.avatarUrl != null
                  ? NetworkImage(message.avatarUrl!)
                  : null,
              backgroundColor: Colors.grey[400],
              child: message.avatarUrl == null
                  ? Text(
                      message.senderName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? const Color(0xFF13B7A5)
                    : (isDark ? const Color(0xFF1E293B) : kLightCardColor),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft:
                      message.isMe ? const Radius.circular(16) : Radius.zero,
                  bottomRight:
                      message.isMe ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe
                          ? Colors.white
                          : (isDark ? Colors.grey[300] : Colors.black),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isMe
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: isDark ? kPrimaryColor : kButtonColor,
              child: Text(
                message.senderName[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
