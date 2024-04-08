
import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location Screen'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/next');
                // Navigator.popAndPushNamed(context, '/next');
              },
              child: const Text('Goto next Screen'),
            ),
          ),
        ],
      ),
    );
  }
}
