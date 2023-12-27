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
  StreamController<String> _streamController = StreamController();
  final int _duration = 60;
  int _durationSec = 0;
  late String _minutesStr, _secondsStr;
  bool _canComplete = true;

  @override
  void initState() {
    _currentButtonState = ButtonState.initial;
    _minutesStr = ((_duration / 60) % 60).floor().toString().padLeft(2, '0');
    _secondsStr = (_duration % 60).floor().toString().padLeft(2, '0');
    _streamController.add(_secondsStr);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  _countSecond(int startNum) async {
    for (int i = startNum; i >= 0; i--) {
      await Future.delayed(Duration(seconds: _durationSec));
      if (!_streamController.isClosed) {
        _streamController.sink.add(i.toString().padLeft(2, '0'));
        _secondsStr = i.toString();
      }
      if (_canComplete) {
        if (i == 0) {
          setState(() {
            _currentButtonState = ButtonState.complete;
          });
        }
      }
    }
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
                    "$_minutesStr:${snapshot.data}",
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
                        _timerPlay();
                      }),
                ] else if (_currentButtonState ==
                    ButtonState.runInProgress) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.pause),
                      onPressed: () {
                        _timerPause();
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.restore),
                      onPressed: () {
                        _timerReset();
                      }),
                ] else if (_currentButtonState == ButtonState.pause) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _timerReplay();
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.restore),
                      onPressed: () {
                        _timerReset();
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

  _timerPlay() {
    _durationSec = 1;
    _countSecond(59);
    setState(() {
      _minutesStr = '00';
      _currentButtonState = ButtonState.runInProgress;
    });
  }

  _timerPause() {
    _canComplete = false;
    _durationSec = 0;
    _streamController.close();
    setState(() {
      _currentButtonState = ButtonState.pause;
    });
  }

  _timerReplay() {
    _canComplete = true;
    _durationSec = 1;
    _streamController = StreamController();
    _countSecond(int.parse(_secondsStr) - 1);
    setState(() {
      _currentButtonState = ButtonState.runInProgress;
    });
  }

  _timerReset() {
    _canComplete = false;
    _durationSec = 0;
    _streamController.close();
   /*  _streamController = StreamController();
    _streamController.add('00'); */
    setState(() {
      _minutesStr = ((_duration / 60) % 60).floor().toString().padLeft(2, '0');
      _currentButtonState = ButtonState.initial;
    });
  }
}
