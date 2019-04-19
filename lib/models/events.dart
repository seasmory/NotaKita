import 'package:firebase_database/firebase_database.dart';

class Events {
  String key;
  String name;
  String description;
  String userId;

  Events(this.name, this.userId, this.description);

  Events.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    name = snapshot.value["name"],
    description = snapshot.value["description"];

  toJson() {
    return {
      "userId": userId,
      "name": name,
      "description": description,
    };
  }
}