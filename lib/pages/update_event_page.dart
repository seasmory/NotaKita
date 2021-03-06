import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/services/authentication.dart';
import 'package:notakita/models/events.dart';
import 'dart:async';

class UpdateEventPage extends StatefulWidget {
  UpdateEventPage({Key key, this.auth, this.userId, this.eventId})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final String eventId;

  @override
  _UpdateEventPageState createState() => new _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  List<Events> _eventList;
  Events e;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;
  Query _eventQuery;


  @override
  void initState() {
    super.initState();

    _eventList = new List();
    _eventQuery = _database
        .reference()
        .child("event")
        .orderByKey()
        .equalTo(widget.eventId);
    _onEventAddedSubscription = _eventQuery.onChildAdded.listen(_onEntryAdded);
    _onEventChangedSubscription = _eventQuery.onChildChanged.listen(_onEntryChanged);
  }

  @override
  void dispose() {
    _onEventAddedSubscription.cancel();
    _onEventChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    setState(() {
      e = Events.fromSnapshot(event.snapshot);
    });
    _updateController();
  }

  _onEntryAdded(Event event) {
    setState((){e = Events.fromSnapshot(event.snapshot);});
    _updateController();
  }

  _updateController(){
    nameController.text = e.name;
     descController.text = e.description;
  }

  _updateEvent(String newName,String newDesc) {
    _database.reference().child("event").child(e.key).update({
      'name': newName.toString(),
      'description': newDesc.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change information'),
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
                  ),
                ),
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
                        _updateEvent(nameController.text.toString(),descController.text.toString());
                        Navigator.pop(context);
                      },
                      child: Text('Change'),
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