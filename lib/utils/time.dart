String secondsStringToFormatString(String seconds) {
  final secs = int.parse(seconds);
  return secondsToFormatString(secs);
}

String secondsToFormatString(int seconds) {
  if (seconds == 0) {
    return '00:00';
  }
  return '${'${seconds ~/ 60}'.padLeft(2, '0')}:'
      '${'${seconds % 60}'.padLeft(2, '0')}';
}
