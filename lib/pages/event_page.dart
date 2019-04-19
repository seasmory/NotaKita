import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/services/authentication.dart';
import 'package:notakita/models/events.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  Query _eventQuery;

  void initState() {
    super.initState();

     _eventQuery = _database
      .reference()
      .child("event")
      .orderByChild("userId")
      .equalTo(widget.userId);
  }

  _addNewEvent(String eventName,String eventDesc) {
    if (eventName.length > 0) {

      Events event = new Events(eventName.toString(), widget.userId, eventDesc.toString());
      _database.reference().child("event").push().set(event.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Event'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Event Description',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return RaisedButton(
                      onPressed: (){
                        _addNewEvent(nameController.text.toString(),descController.text.toString());
                        Navigator.pop(context);
                      },
                      child: Text('Create event'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}