import 'dart:async';

import 'package:flutter/material.dart';

import 'src/widgets.dart';

import 'guest_book_message.dart';

class GuestBook extends StatefulWidget {
  // Modify the following line:
  const GuestBook({
    super.key, 
    required this.addMessage, 
    required this.messages,
  });

  final FutureOr<void> Function(String message, String color) addMessage;
  final List<GuestBookMessage> messages; // new
  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  final _colorController = TextEditingController();
  final List<String> colors = ["red", "green", "blue"];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownMenu<String>(
                  label: const Text("Colors"),
                  initialSelection: "red",
                  controller: _colorController,
                  dropdownMenuEntries: colors.map((String colorname) {
                        return DropdownMenuEntry(
                          value: colorname,
                          label: colorname,
                        );
                      }).toList()
                  ),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text, _colorController.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph(content: ('${message.name}: ${message.message}'), color : message.color),
        const SizedBox(height: 8),
      ]
    );
  }
}