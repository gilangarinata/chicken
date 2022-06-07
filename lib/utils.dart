import 'package:flutter/material.dart';

class Utils {
  static int minutesToMillis(int minutes){
    return minutes * 60 * 1000;
  }

  static int millisToMinutes(int millis){
    return (millis / 1000) ~/ 60;
  }

  static String millisToMinutesSecon(int durationInMillis){
    int millis = durationInMillis % 1000;
    int second = ((durationInMillis / 1000) % 60).toInt();
    int minute = ((durationInMillis / (1000 * 60)) % 60).toInt();
    return minute.toString().padLeft(2, '0') + ":" + second.toString().padLeft(2, '0');
  }

  static String seconToMillisSecon(int durationInSecon){
    int durationInMillis = durationInSecon * 1000;
    int second = ((durationInMillis / 1000) % 60).toInt();
    int minute = ((durationInMillis / (1000 * 60)) % 60).toInt();
    int hour = ((durationInSecon / 3600) % 3600).toInt();
    return hour.toString().padLeft(2, '0') + ":" + minute.toString().padLeft(2, '0');
  }
}