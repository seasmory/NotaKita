import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notakita/services/authentication.dart';
import 'package:notakita/models/events.dart';
import 'package:notakita/models/reports.dart';
import 'update_event_page.dart';
import 'dart:async';

class EventTab extends StatefulWidget {
  EventTab({Key key, this.auth, this.userId, this.eventId})
      : super(key: key);
  final BaseAuth auth;
  final String userId;
  final String eventId;

  @override
  State<StatefulWidget> createState() => new EventTabState();
}

class EventTabState extends State<EventTab> {
  Events e;
  List<Reports> _reportList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final incomeController = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onEventAddedSubscription;
  StreamSubscription<Event> _onEventChangedSubscription;
  Query _eventQuery;
  Query _reportQuery;
  String _name = "";
  String _desc = "";

  @override
  void initState() {

    super.initState();

    _reportList = new List();
    _eventQuery = _database
        .reference()
        .child("event")
        .orderByKey()
        .equalTo(widget.eventId);
    _reportQuery = _database
        .reference()
        .child("event")
        .child(widget.eventId)
        .child("reports");
    _onEventAddedSubscription = _eventQuery.onChildAdded.listen(_onEntryAdded);
    _onEventChangedSubscription = _eventQuery.onChildChanged.listen(_onEntryChanged);
    _onEventAddedSubscription = _reportQuery.onChildAdded.listen(_onEntryAddedR);
    _onEventChangedSubscription = _reportQuery.onChildChanged.listen(_onEntryChangedR);
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
      _name = e.name;
      _desc = e.description;
    });
  }

  _onEntryAdded(Event event) {
    setState((){
      e = Events.fromSnapshot(event.snapshot);
      _name = e.name;
      _desc = e.description;
    });
  }

  _onEntryChangedR(Event event) {
    var oldEntry = _reportList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _reportList[_reportList.indexOf(oldEntry)] = Reports.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAddedR(Event event) {
    setState((){
      _reportList.add(Reports.fromSnapshot(event.snapshot));
    });
  }

 Future _showEventForm() async {
      Events newEvent = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return UpdateEventPage(userId: widget.userId, auth: widget.auth,eventId: widget.eventId,);
          },
        ),
      );
    }

  _addNewReport(String value) {
    if (value.length > 0) {

      Reports report = new Reports(value, widget.userId);
      _database.reference().child("event").child(widget.eventId).child("reports").push().set(report.toJson());
    }
  }

  _deleteReport(String reportId, int index) {
    _database.reference().child("event").child(widget.eventId).child("reports").child(reportId).remove().then((_) {
      print("Delete $reportId successful");
      setState(() {
        _reportList.removeAt(index);
      });
    });
  }

  Widget get profile {
      return new Container(
        padding: new EdgeInsets.symmetric(vertical: 32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              _name,
              style: new TextStyle(fontSize: 32.0),
            ),
            new Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child:
                  new Text(_desc),
            ),
            new RaisedButton(
              onPressed: _showEventForm,
              child: const Text('Change'),
            ),
          ],
        ),
      );
    }

  Widget get upload {
    return Scaffold(
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
                  controller: incomeController,
                  decoration: InputDecoration(
                    labelText: 'Income',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return RaisedButton(
                      onPressed: (){
                        _addNewReport(incomeController.text.toString());
                      },
                      child: Text('Submit'),
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

  Widget get report {
    if (_reportList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _reportList.length,
          itemBuilder: (BuildContext context, int index) {
            String reportId = _reportList[index].key;
            String value = _reportList[index].value;
            return Dismissible(
              key: Key(reportId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                _deleteReport(reportId, index);
              },
              child: new Text(value),
            );
          },
        );
    } else {
      return Center(child: Text("List is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
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
              upload,
              report,
            ],
          ),
        ),
      ),
    );
  }
}

