import 'package:flutter/material.dart';
import 'package:notakita/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/models/events.dart';
import 'add_event_page.dart';
import 'eventTab.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Events> _eventList;
  String _userId = "";
  String check;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;

  Query _eventQuery;
  Query _eventQuery2;

  DataSnapshot e;
  @override
  void initState() {
    super.initState();

    _eventList = new List();
    _eventQuery = _database
        .reference()
        .child("event");
    _eventQuery2 = _database
        .reference()
        .child("eventUser")
        .orderByChild(widget.userId)
        .equalTo("true");
    _onEventAddedSubscription = _eventQuery2.onChildAdded.listen(_onEntryAdded);
    _onEventChangedSubscription = _eventQuery.onChildChanged.listen(_onEntryChanged);

    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
  }

  @override
  void dispose() {
    _onEventAddedSubscription.cancel();
    _onEventChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _eventList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _eventList[_eventList.indexOf(oldEntry)] = Events.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    _database.reference().child("event").child(event.snapshot.key).once().then((DataSnapshot data){
      setState(() {
        _eventList.add(Events.fromSnapshot(data));
      });
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

/*
  _updateEvent(Events event){
    Toggle completed
    event.completed = !event.completed;
    if (event != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }
*/
  _deleteEvent(String eventId, int index) {
    _database.reference().child("event").child(eventId).remove().then((_) {
      print("Delete $eventId successful");
      setState(() {
        _eventList.removeAt(index);
      });
    });
  }

  Future _showEventForm() async {
    // push a new route like you did in the last section
      Events newEvent = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return AddEvent(userId: _userId, auth: widget.auth,);
          },
        ),
      );
    }

  Widget _showEventList() {
    if (_eventList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _eventList.length,
          itemBuilder: (BuildContext context, int index) {
            String eventId = _eventList[index].key;
            String name = _eventList[index].name;
            return FlatButton(
              key: Key(eventId),
              child: new Text(name),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventTab(userId: _userId, auth: widget.auth, eventId: eventId)
                ));
              },
            );
          },
        );
    } else {
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('NotaKita'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        body: _showEventList(),
        floatingActionButton: FloatingActionButton(
          onPressed: _showEventForm,
          tooltip: 'Add a new event',
          child: Icon(Icons.add),
        )
    );
  }
}