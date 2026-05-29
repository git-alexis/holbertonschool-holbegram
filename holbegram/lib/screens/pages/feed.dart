import 'package:flutter/material.dart';
import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 38,
              ),
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.png',
              width: 35,
              height: 35,
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 28),
                Icon(Icons.chat_outlined),
              ],
            ),
          ),
        ],
      ),
      body: const Posts(),
    );
  }
}
