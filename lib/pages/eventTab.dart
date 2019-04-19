import 'package:flutter/material.dart';
import 'profile.dart';
import 'upload.dart';
import 'report.dart';
import 'package:notakita/models/events.dart';

class EventTab extends StatefulWidget {
  final Events event;

  EventTab(this.event);

  @override
  EventTabState createState() { return new EventTabState(event); }
}

class EventTabState extends State<EventTab> {
  Events event;

  EventTabState(this.event);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
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
              EventDetailPage(event),
              Upload(),
              Report(),
            ],
          ),
        ),
      ),
    );
  }
}