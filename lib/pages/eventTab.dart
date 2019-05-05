import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/services/authentication.dart';
import 'upload.dart';
import 'report.dart';
import 'package:notakita/models/events.dart';
import 'update_event_page.dart';
import 'dart:async';

class EventTab extends StatefulWidget {
  EventTab({Key key, this.auth, this.userId, this.index})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final int index;

  @override
  State<StatefulWidget> createState() => new EventTabState();
}

class EventTabState extends State<EventTab> {
  List<Events> _eventList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
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
        .orderByChild("userId")
        .equalTo(widget.userId);
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

 Future _showEventForm() async {
    // push a new route like you did in the last section
      Events newEvent = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return UpdateEventPage(userId: widget.userId, auth: widget.auth,index: widget.index,);
          },
        ),
      );
    }

  Widget get profile {
      return new Container(
        padding: new EdgeInsets.symmetric(vertical: 32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              _eventList[widget.index].name,
              style: new TextStyle(fontSize: 32.0),
            ),
            new Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: new Text(
                _eventList[widget.index].description,
              ),
            ),
            new RaisedButton(
              onPressed: _showEventForm,
              child: const Text('Change'),
            ),
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context) ,
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Profile"),
                Tab(text: "Upload"),
                Tab(text: "Report"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              profile,
              Upload(),
              Report(),
            ],
          ),
        ),
      ),
    );
  }
}

