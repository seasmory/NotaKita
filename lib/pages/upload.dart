import 'package:flutter/material.dart';

class Upload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Text(
              'Income',
            ),
            UploadFieldI(),
            SizedBox(height:3.0),
            Text(
              'Outcome',
            ),
            UploadFieldO(),
          ],
        ),
    );
  }
}

/// Multi-line text field widget with a submit button
class UploadFieldI extends StatefulWidget {
  UploadFieldI({Key key}) : super(key: key);

  @override
  createState() => _TextFieldAndButtonStateI();
}

class _TextFieldAndButtonStateI
    extends State<UploadFieldI> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                ),
                onChanged: (str) => print('Multi-line text change: $str'),
              ),
              FlatButton(
                onPressed: () => _showInSnackBar(
                      context,
                      '${_controller.text}',
                    ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Displays text in a snackbar
_showInSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}
class UploadFieldO extends StatefulWidget {
  UploadFieldO({Key key}) : super(key: key);

  @override
  createState() => _TextFieldAndButtonStateO();
}

class _TextFieldAndButtonStateO
    extends State<UploadFieldO> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                ),
                onChanged: (str) => print('Multi-line text change: $str'),
              ),
              FlatButton(
                onPressed: () => _showInSnackBar(
                      context,
                      '${_controller.text}',
                    ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
