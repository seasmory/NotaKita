import 'package:flutter/material.dart';
import 'package:notakita/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/models/events.dart';
import 'event_page.dart';
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

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;

  Query _eventQuery;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();

    _eventList = new List();
    _eventQuery = _database
        .reference()
        .child("event")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onEventAddedSubscription = _eventQuery.onChildAdded.listen(_onEntryAdded);
    _onEventChangedSubscription = _eventQuery.onChildChanged.listen(_onEntryChanged);

    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    setState(() {
      _eventList.add(Events.fromSnapshot(event.snapshot));
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
            return Dismissible(
              key: Key(eventId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteEvent(eventId, index);
              },
              child: FlatButton(
                child: new Text(name),
                onPressed: (){},
                ),
            );
          });
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
          title: new Text('Flutter login demo'),
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
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }
}