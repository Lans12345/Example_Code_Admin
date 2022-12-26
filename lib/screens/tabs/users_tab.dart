import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldText(label: 'List of Users', fontSize: 18, color: Colors.blue),
        ],
      ),
    );
  }
}
