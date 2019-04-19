import 'package:flutter/material.dart';
import 'package:notakita/models/events.dart';

class EventDetailPage extends StatefulWidget {
  final Events event;

  EventDetailPage(this.event);

  @override
  _EventDetailPageState createState() => new _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  double _sliderValue = 10.0;

  Widget get eventProfile {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 32.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            widget.event.name,
            style: new TextStyle(fontSize: 32.0),
          ),
          new Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: new Text(widget.event.description),
          ),
        ],
      ),
    );
  }

  void updateSlider(double newRating) {
    setState(() => _sliderValue = newRating);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${widget.event.name}'),
      ),
      body: new ListView(
        children: <Widget>[eventProfile],
      ),
    );
  }
}
