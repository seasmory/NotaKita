import 'package:firebase_database/firebase_database.dart';

class Events {
  String key;
  String name;
  String description;

  Events(this.name, this.description);

  Events.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    name = snapshot.value["name"],
    description = snapshot.value["description"];

  toJson() {
    return {
      "name": name,
      "description": description,
    };
  }
}