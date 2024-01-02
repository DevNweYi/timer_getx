import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_getx/controller/timer_controller.dart';

import '../button_state.dart';

class TimerPage3 extends StatelessWidget {
  const TimerPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = Get.put(TimerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ephemeral Timer"),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: timerController.streamController.stream,
                builder: (context, snapshot) {
                  dynamic minutesStr, secondsStr;
                  if (snapshot.hasData) {
                    minutesStr = ((snapshot.data! / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    secondsStr = (snapshot.data! % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    if (snapshot.data == 0) {
                      timerController.cancelTimer();
                    }
                  } else {
                    minutesStr = ((timerController.durationSec / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    secondsStr = (timerController.durationSec % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                  }
                  return Text(
                    minutesStr + ":" + secondsStr,
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                }),
            const Padding(padding: EdgeInsets.all(30.0)),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (timerController.currentButtonState.value ==
                      ButtonState.initial) ...[
                    FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () {
                          timerController
                              .startTimer(timerController.durationSec);
                          timerController
                              .changeButtonState(ButtonState.runInProgress);
                        }),
                  ] else if (timerController.currentButtonState.value ==
                      ButtonState.runInProgress) ...[
                    FloatingActionButton(
                        child: const Icon(Icons.pause),
                        onPressed: () {
                          timerController.cancelTimer();
                          timerController.changeButtonState(ButtonState.pause);
                        }),
                    FloatingActionButton(
                        child: const Icon(Icons.refresh),
                        onPressed: () {
                          timerController.cancelTimer();
                          timerController
                              .changeButtonState(ButtonState.initial);
                        }),
                  ] else if (timerController.currentButtonState.value ==
                      ButtonState.pause) ...[
                    FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () {
                          timerController
                              .startTimer(timerController.durationSec);
                          timerController
                              .changeButtonState(ButtonState.runInProgress);
                        }),
                    FloatingActionButton(
                        child: const Icon(Icons.refresh),
                        onPressed: () {
                          timerController.cancelTimer();
                          timerController
                              .changeButtonState(ButtonState.initial);
                        }),
                  ] else if (timerController.currentButtonState.value ==
                      ButtonState.complete) ...[
                    FloatingActionButton(
                        child: const Icon(Icons.restart_alt),
                        onPressed: () {
                          timerController
                              .changeButtonState(ButtonState.initial);
                        }),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
