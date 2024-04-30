import 'package:easymedhelp_app/screens/doctor_chat.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<ChatPreview> chatPreviews = [
      ChatPreview(
          doctorName: "Ковальчук Мар'яна",
          lastMessage: "Як Ви себе почуваєте сьогодні?",
          timestamp: "10:30",
          imagePath: "assets/female_doctor_1.jpg"),
      ChatPreview(
          doctorName: "Довбуш Вадим",
          lastMessage: "Не забувайте про прийом медикаментів",
          timestamp: "Вчора",
          imagePath: "assets/male_doctor_3.jpg"),

      // Add more chat previews here
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Чати',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: chatPreviews.length,
                itemBuilder: (context, index) {
                  return ChatPreviewItem(chatPreview: chatPreviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPreview {
  final String doctorName;
  final String lastMessage;
  final String timestamp;
  final String? imagePath;

  ChatPreview({
    required this.doctorName,
    required this.lastMessage,
    required this.timestamp,
    required this.imagePath,
  });
}

class ChatPreviewItem extends StatelessWidget {
  final ChatPreview chatPreview;

  const ChatPreviewItem({super.key, required this.chatPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: EasyMedHelpConfiguration.secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          width: 48.0,
          height: 48.0,
          decoration: const BoxDecoration(
            color: EasyMedHelpConfiguration.primaryColor,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              chatPreview.imagePath!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          chatPreview.doctorName,
          style: const TextStyle(
            color: EasyMedHelpConfiguration.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          chatPreview.lastMessage,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Text(
          chatPreview.timestamp,
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(doctorName: chatPreview.doctorName),
            ),
          );
        },
      ),
    );
  }
}
