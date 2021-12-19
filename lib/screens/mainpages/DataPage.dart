import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logoFull.png'),
              width: 200,
              fit: BoxFit.cover
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => {}, child: Text('Import From Local Storage'),
                  style: buttonDecoration,
                ),
                ElevatedButton(
                  onPressed: () => {}, child: Text('Existing File'),
                  style: buttonDecoration,
                ),
              ]
            )
          ],
        ),
      )
    );
  }
}
