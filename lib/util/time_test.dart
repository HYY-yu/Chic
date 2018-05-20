
DateTime start;
DateTime end;

void startReport() {
  start = DateTime.now();
}

void printDuration() {
  end = DateTime.now();
  Duration du = end.difference(start);
  print(" Spand : " + du.inMilliseconds.toString());
}
