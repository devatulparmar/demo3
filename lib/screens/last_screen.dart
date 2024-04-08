import 'package:flutter/material.dart';

class LastScreen extends StatefulWidget {
  final String email;
  final String password;
  final Map arg;

  const LastScreen({
    super.key,
    required this.email,
    required this.password,
    required this.arg,
  });

  @override
  State<LastScreen> createState() => _LastScreenState();
}

class _LastScreenState extends State<LastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last screen'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Text('Email: ${widget.email}'),
          Text('Password: ${widget.password}'),
        ],
      ),
    );
  }
}
