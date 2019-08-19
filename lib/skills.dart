import 'package:flutter/material.dart';

class Skills extends StatelessWidget {
  Widget iconText(String title) {
    return Container(
      padding: new EdgeInsets.only(left: 20),
      child: Column(
        children: <Widget>[
          Text(title),
          Image.asset(
            'assets/$title.png',
            height: 70,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Skills',
              style: TextStyle(fontSize: 40),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                iconText('react'),
                iconText('vue'),
                iconText('dart'),
              ],
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
