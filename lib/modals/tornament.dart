import 'package:cloud_firestore/cloud_firestore.dart';

class Tournament {
  String id;
  String type;
  String title;
  DateTime fromDate;
  DateTime toDate;
  String venue;
  String? subType;

  Tournament({
    required this.id,
    required this.type,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.venue,
    this.subType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'fromDate': fromDate.millisecondsSinceEpoch,
      'toDate': toDate.millisecondsSinceEpoch,
      'venue': venue,
      'subType': subType,
    };
  }

  factory Tournament.fromJson(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      fromDate: (map['fromDate'] as Timestamp).toDate(),
      toDate: (map['toDate'] as Timestamp).toDate(),
      venue: map['venue'] ?? '',
      subType: map['subType'],
    );
  }
}
