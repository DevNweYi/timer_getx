import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

enum ButtonState { initial, play, pause }

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Ephemeral Timer"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "01:00",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                    child: const Icon(Icons.play_arrow), onPressed: () {}),
                FloatingActionButton(
                    child: const Icon(Icons.pause), onPressed: () {}),
                FloatingActionButton(
                    child: const Icon(Icons.refresh), onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
