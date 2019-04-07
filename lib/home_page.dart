import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
        actions: <Widget>[],
      ),
      body: new Container(
          child: Align(
        alignment: Alignment.center,
        child: new Text(
          'Center',
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
              child: new Text(
                'Log out',
                style: new TextStyle(fontSize: 17.0, color: Colors.white),
              ),
              onPressed: _signOut,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: Text('Create new event'),
        onPressed: () {},
        shape: new BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(0.0)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
