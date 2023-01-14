import 'dart:async';

class RestartablePeriodicTimer {
  Timer? _timer;
  Duration _duration;

  void Function() _timer_callback_function;

  RestartablePeriodicTimer(this._timer_callback_function, this._duration);

  void start() {
    if (_timer != null && _timer!.isActive) {
      _timer = null;
    }
    _timer ??= Timer.periodic(_duration, (timer) => _timer_callback_function());
  }

  void stop() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
