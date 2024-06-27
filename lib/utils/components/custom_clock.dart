class CustomTimer {
  int hours;
  int minutes;
  int seconds;

  CustomTimer({this.hours = 0, this.minutes = 0, this.seconds = 0});

  void incrementTime() {
    seconds++;
    if (seconds >= 60) {
      seconds = 0;
      minutes++;
      if (minutes >= 60) {
        minutes = 0;
        hours++;
        if (hours >= 24) {
          hours = 0;
        }
      }
    }
  }

  String formattedTime() {
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
