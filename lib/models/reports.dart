import 'package:firebase_database/firebase_database.dart';

class Reports {
  String key;
  String value;
  String userId;

  Reports(this.value, this.userId);

  Reports.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    value = snapshot.value["value"];

  toJson() {
    return {
      "userId": userId,
      "value": value,
    };
  }
}