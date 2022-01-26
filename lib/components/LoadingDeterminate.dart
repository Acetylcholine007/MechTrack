import 'package:flutter/material.dart';
import 'package:mech_track/models/AppTask.dart';

class LoadingDeterminate extends StatelessWidget {
  final AppTask task;
  final int index;
  final int total;
  const LoadingDeterminate({Key key, this.task, this.index, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: (index + 1) / total,
                strokeWidth: 10
              ),
            ),
            SizedBox(height: 50),
            Text(task.heading, style: theme.textTheme.headline5),
            Text(task.content, style: theme.textTheme.bodyText1)
          ],
        ),
      )
    );
  }
}
