import 'dart:async';

import 'package:get/get.dart';

import '../button_state.dart';

class TimerController extends GetxController {
  final streamController = StreamController<int>();
  final int _startDurationSec = 60;
  late int _durationSec;
  late Timer _timer;
  final Rx<dynamic> _currentButtonState = ButtonState.initial.obs;

  TimerController() {
    _durationSec = _startDurationSec;
  }

  int get durationSec => _durationSec;

  dynamic get currentButtonState => _currentButtonState;

  startTimer(int start) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSec = start--;
      streamController.sink.add(_durationSec);
      if (_durationSec == 0) {
        _currentButtonState.value = ButtonState.complete;
      }
    });
  }

  cancelTimer() {
    _timer.cancel();
  }

  changeButtonState(ButtonState state) {
    _currentButtonState.value = state;
    if (state == ButtonState.initial) {
      _durationSec = _startDurationSec;
      streamController.sink.add(_startDurationSec);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    streamController.close();
    super.dispose();
  }
}
