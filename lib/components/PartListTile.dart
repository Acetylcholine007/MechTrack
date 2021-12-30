import 'package:flutter/material.dart';

class PartListTile extends StatelessWidget {
  const PartListTile({Key key, this.index, this.name, this.caption}) : super(key: key);
  final String name;
  final caption;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(caption),
    );
  }
}
