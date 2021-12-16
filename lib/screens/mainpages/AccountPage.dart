import 'package:flutter/material.dart';
import 'package:mech_track/components/PartListTile.dart';
import 'package:mech_track/components/SearchBar.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController _controller = TextEditingController();
    final items = [
      ["Item 1", "lorem ipsum"],
      ["Item 2", "lorem ipsum"],
      ["Item 3", "lorem ipsum"],
      ["Item 4", "lorem ipsum"],
      ["Item 5", "lorem ipsum"],
      ["Item 6", "lorem ipsum"],
      ["Item 7", "lorem ipsum"],
    ];

    return Container(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(controller: _controller, filterHandler: (){}),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => {},
                        child: PartListTile(
                            key: Key(index.toString()),
                            name: items[index][0], caption:
                        items[index][1],
                            index: index
                        ),
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
