import 'package:easymedhelp_app/components/custom_appbar.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String doctorName;

  const ChatScreen({super.key, required this.doctorName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = []; // List to store messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: widget.doctorName,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 80,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Розпочніть чат з лікарем',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        // Determine if the message is from the user or the doctor
                        bool isUserMessage = _messages[index].sender == 'You';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Align(
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 336), // Limit width to 360 pixels

                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: isUserMessage
                                    ? EasyMedHelpConfiguration.primaryColor
                                    : Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    _messages[index].text,
                                    style: TextStyle(
                                      color: isUserMessage
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                        hintText: 'Почніть друкувати повідомлення...',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: EasyMedHelpConfiguration.primaryColor,
                  ),
                  onPressed: () {
                    sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) {
    // Add user's message to the list
    setState(() {
      _messages.add(Message(sender: 'You', text: text));
    });

    // Simulate automated response
    String response = getAutomatedResponse(text);

    // Add automated response to the list
    setState(() {
      _messages.add(Message(sender: widget.doctorName, text: response));
    });

    // Clear the message input field
    _messageController.clear();
  }

  String getAutomatedResponse(String message) {
    // Here you can implement your logic to generate automated responses
    // For demonstration purposes, we'll return a simple response
    return "Вітаю! \nЯк ви себе почуваєте сьогодні?";
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}
