// To parse this JSON data, do
//
//     final statusResponse = statusResponseFromJson(jsonString);

import 'dart:convert';

StatusResponse statusResponseFromJson(String str) => StatusResponse.fromJson(json.decode(str));

String statusResponseToJson(StatusResponse data) => json.encode(data.toJson());

class StatusResponse {
  StatusResponse({
    this.status,
  });

  String status;

  factory StatusResponse.fromJson(Map<String, dynamic> json) => StatusResponse(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
