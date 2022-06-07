// To parse this JSON data, do
//
//     final dataResponse = dataResponseFromJson(jsonString);

import 'dart:convert';

DataResponse dataResponseFromJson(String str) => DataResponse.fromJson(json.decode(str));

String dataResponseToJson(DataResponse data) => json.encode(data.toJson());

class DataResponse {
  DataResponse({
    this.ip,
    this.hour,
    this.temperature,
    this.humidity,
    this.amonia,
    this.fanA,
    this.cellDeck,
    this.lamp,
    this.fan1,
    this.fan2,
    this.fan3,
    this.fan4,
    this.heater,
    this.counter,
    this.amonia_thr
  });

  String ip;
  int hour;
  double temperature;
  double humidity;
  FanA fanA;
  CellDeck cellDeck;
  Lamp lamp;
  Fan1 fan1;
  Fan1 fan2;
  Fan1 fan3;
  Fan1 fan4;
  Fan1 heater;
  int counter;
  int amonia;
  int amonia_thr;

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
    ip: json["ip"],
    hour: json["hour"],
    temperature: json["temperature"] == null ? -1.0 : json["temperature"].toDouble(),
    humidity: json["humidity"] == null ? -1.0 : json["humidity"].toDouble(),
    fanA: FanA.fromJson(json["fanA"]),
    cellDeck: CellDeck.fromJson(json["cellDeck"]),
    lamp: Lamp.fromJson(json["lamp"]),
    fan1: Fan1.fromJson(json["fan1"]),
    fan2: Fan1.fromJson(json["fan2"]),
    fan3: Fan1.fromJson(json["fan3"]),
    fan4: Fan1.fromJson(json["fan4"]),
    heater: Fan1.fromJson(json["heater"]),
    counter: json["counter"],
    amonia: json["amonia"] == null ? -1 : json["amonia"],
    amonia_thr: json["amonia_thr"] == null ? -1 : json["amonia_thr"],
  );

  Map<String, dynamic> toJson() => {
    "ip": ip,
    "hour": hour,
    "temperature": temperature,
    "humidity": humidity,
    "fanA": fanA.toJson(),
    "cellDeck": cellDeck.toJson(),
    "lamp": lamp.toJson(),
    "fan1": fan1.toJson(),
    "fan2": fan2.toJson(),
    "fan3": fan3.toJson(),
    "fan4": fan4.toJson(),
    "heater": heater.toJson(),
    "counter": counter,
  };
}

class CellDeck {
  CellDeck({
    this.onDuration,
    this.offDuration,
    this.onLeftDuration,
    this.offLeftDuration,
    this.statusRelay
  });

  int onDuration;
  int offDuration;
  int onLeftDuration;
  int offLeftDuration;
  bool statusRelay;

  factory CellDeck.fromJson(Map<String, dynamic> json) => CellDeck(
    onDuration: json["onDuration"],
    offDuration: json["offDuration"],
    onLeftDuration: json["onLeftDuration"],
    offLeftDuration: json["offLeftDuration"],
    statusRelay: json["statusRelay"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "onDuration": onDuration,
    "offDuration": offDuration,
    "onLeftDuration": onLeftDuration,
    "offLeftDuration": offLeftDuration,
    "statusRelay": statusRelay,
  };
}

class FanA {
  FanA({
    this.onDuration,
    this.offDuration,
    this.onLeftDuration,
    this.offLeftDuration,
    this.statusRelay
  });

  int onDuration;
  int offDuration;
  int onLeftDuration;
  int offLeftDuration;
  bool statusRelay;

  factory FanA.fromJson(Map<String, dynamic> json) => FanA(
    onDuration: json["onDuration"],
    offDuration: json["offDuration"],
    onLeftDuration: json["onLeftDuration"],
    offLeftDuration: json["offLeftDuration"],
    statusRelay: json["statusRelay"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "onDuration": onDuration,
    "offDuration": offDuration,
    "onLeftDuration": onLeftDuration,
    "offLeftDuration": offLeftDuration,
    "statusRelay": statusRelay ,
  };
}

class Fan1 {
  Fan1({
    this.minTemp,
    this.maxTemp,
    this.statusRelay,
  });

  int minTemp;
  int maxTemp;
  bool statusRelay;

  factory Fan1.fromJson(Map<String, dynamic> json) => Fan1(
    minTemp: json["minTemp"],
    maxTemp: json["maxTemp"],
    statusRelay: json["statusRelay"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "minTemp": minTemp,
    "maxTemp": maxTemp,
    "statusRelay": statusRelay,
  };
}

class Lamp {
  Lamp({
    this.lampOnHour,
    this.lampOnMinutes,
    this.lampOffHour,
    this.lampOffMinutes,
    this.statusRelay
  });

  int lampOnHour;
  int lampOnMinutes;
  int lampOffHour;
  int lampOffMinutes;
  bool statusRelay;

  factory Lamp.fromJson(Map<String, dynamic> json) => Lamp(
    lampOnHour: json["lampOnHour"],
    lampOnMinutes: json["lampOnMinutes"],
    lampOffHour: json["lampOffHour"],
    lampOffMinutes: json["lampOffMinutes"],
    statusRelay: json["statusRelay"] == 1 ? true : false,
  );

  Map<String, dynamic> toJson() => {
    "lampOnHour": lampOnHour,
    "lampOnMinutes": lampOnMinutes,
    "lampOffHour": lampOffHour,
    "lampOffMinutes": lampOffMinutes,
    "statusRelay": statusRelay,
  };
}
