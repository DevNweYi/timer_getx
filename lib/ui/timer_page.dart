import 'dart:async';

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

enum ButtonState { initial, runInProgress, pause, complete }

class _TimerPageState extends State<TimerPage> {
  dynamic _currentButtonState;
  String _minute = '01', _second = '00';
  StreamController<String> _streamController = StreamController();

  @override
  void initState() {
    _currentButtonState = ButtonState.initial;
    _streamController.add(_second);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  _countSecond() async {
    for (int i = 59; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      String value = '';
      if (i.toString().length == 1) {
        value = '0$i';
      } else {
        value = i.toString();
      }
      _streamController.sink.add(value);
      if (i == 0) {
        setState(() {
           _minute = '01';
          _currentButtonState = ButtonState.complete;
        });
      }
    }
  }

  _play() {
    setState(() {
      _minute = '00';
    });
  }

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
            StreamBuilder<String>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  return Text(
                    "$_minute:${snapshot.data}",
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                }),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentButtonState == ButtonState.initial) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _play();
                        _countSecond();
                        setState(() {
                          _currentButtonState = ButtonState.runInProgress;
                        });
                      }),
                ] else if (_currentButtonState ==
                    ButtonState.runInProgress) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.pause),
                      onPressed: () {
                        setState(() {
                          _currentButtonState = ButtonState.pause;
                        });
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () {
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      }),
                ] else if (_currentButtonState == ButtonState.pause) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _currentButtonState = ButtonState.runInProgress;
                        });
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () {
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      }),
                ] else if (_currentButtonState == ButtonState.complete) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.replay),
                      onPressed: () {
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      })
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
