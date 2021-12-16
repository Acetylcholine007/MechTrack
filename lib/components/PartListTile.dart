import 'package:flutter/material.dart';

class PartListTile extends StatelessWidget {
  const PartListTile({Key key, this.index, this.name, this.caption}) : super(key: key);
  final String name;
  final String caption;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        child: Text((index + 1).toString()),
        radius: 20,
      ),
      title: Text(name),
      subtitle: Text(caption),
    );
  }
}
