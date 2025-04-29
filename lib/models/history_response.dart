// To parse this JSON data, do
//
//     final historyResponse = historyResponseFromJson(jsonString);

import 'dart:convert';

HistoryResponse historyResponseFromJson(String str) =>
    HistoryResponse.fromJson(json.decode(str));

String historyResponseToJson(HistoryResponse data) =>
    json.encode(data.toJson());

class HistoryResponse {
  final String? message;
  final List<dynamic>? data;

  HistoryResponse({this.message, this.data});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<dynamic>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
