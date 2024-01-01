import 'dart:async';

import 'package:flutter/material.dart';

enum ButtonState { initial, runInProgress, pause, complete }

class TimerPage2 extends StatefulWidget {
  const TimerPage2({super.key});

  @override
  State<TimerPage2> createState() => _TimerPage2State();
}

class _TimerPage2State extends State<TimerPage2> {
  final _streamController = StreamController<int>();
  final int _startDurationSec = 60;
  late int _durationSec;
  late Timer _timer;
  dynamic _currentButtonState = ButtonState.initial;

  @override
  void initState() {
    _durationSec = _startDurationSec;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ephemeral Timer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  dynamic _secondsStr;
                  if (snapshot.hasData) {
                    _secondsStr = (snapshot.data! % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    if (snapshot.data == 0) {
                      _timer.cancel();
                    }
                  } else {
                    _secondsStr =
                        (_durationSec % 60).floor().toString().padLeft(2, '0');
                  }
                  return Text(
                    _secondsStr,
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                  /*  if (snapshot.hasData) {
                    var secondsStr = (snapshot.data! % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    if (snapshot.data == 0) {
                      _timer.cancel();
                    }
                    return Text(
                      secondsStr,
                      style: Theme.of(context).textTheme.displayLarge,
                    );
                  } else {
                    return Text(
                      _durationSec.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    );
                  } */
                }),
            const Padding(padding: EdgeInsets.all(30.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentButtonState == ButtonState.initial) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _startTimer(_durationSec);
                        setState(() {
                          _currentButtonState = ButtonState.runInProgress;
                        });
                      }),
                ] else if (_currentButtonState ==
                    ButtonState.runInProgress) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.pause),
                      onPressed: () {
                        _pauseTimer();
                        setState(() {
                          _currentButtonState = ButtonState.pause;
                        });
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.refresh),
                      onPressed: () {
                        _timer.cancel();
                        _durationSec = _startDurationSec;
                        _streamController.sink.add(_startDurationSec);
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      }),
                ] else if (_currentButtonState == ButtonState.pause) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _startTimer(_durationSec);
                        setState(() {
                          _currentButtonState = ButtonState.runInProgress;
                        });
                      }),
                  FloatingActionButton(
                      child: const Icon(Icons.refresh),
                      onPressed: () {
                        _timer.cancel();
                        _durationSec = _startDurationSec;
                        _streamController.sink.add(_startDurationSec);
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      }),
                ] else if (_currentButtonState == ButtonState.complete) ...[
                  FloatingActionButton(
                      child: const Icon(Icons.restart_alt),
                      onPressed: () {
                        _durationSec = _startDurationSec;
                        _streamController.sink.add(_startDurationSec);
                        setState(() {
                          _currentButtonState = ButtonState.initial;
                        });
                      }),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  _startTimer(int start) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSec = start--;
      _streamController.sink.add(_durationSec);
      if (_durationSec == 0) {
        setState(() {
          _currentButtonState = ButtonState.complete;
        });
      }
    });
  }

  _pauseTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }
}
