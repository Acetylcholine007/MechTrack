import 'package:flutter/material.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/shared/decorations.dart';

class PartSearchBar extends StatefulWidget {
  const PartSearchBar({Key key,
    this.categoryHandler,
    this.searchHandler,
    this.catIndex,
    this.context, this.fields}) : super(key: key);

  final Function(int) categoryHandler;
  final Function(String) searchHandler;
  final int catIndex;
  final BuildContext context;
  final Field fields;

  @override
  State<PartSearchBar> createState() => _PartSearchBarState();
}

class _PartSearchBarState extends State<PartSearchBar> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(flex: 2, child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
            child: TextFormField(
              controller: controller,
              decoration: searchFieldDecoration.copyWith(
                suffixIcon: IconButton(onPressed: () {
                  controller.text = "";
                  widget.searchHandler("");
                }, icon: Icon(Icons.highlight_off_rounded))
              ),
              onChanged: widget.searchHandler,
            ),
          )),
          Expanded(flex: 1, child: Padding(
            padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
            child: DropdownButtonFormField(
              menuMaxHeight: 500,
              isExpanded: true,
              value: widget.catIndex,
              decoration: searchFieldDecoration,
              items: widget.fields.fields.values.toList().asMap().entries.map((category) => DropdownMenuItem(
                  value: category.key,
                  child: Text(category.value, overflow: TextOverflow.ellipsis)
              )).toList(),
              onChanged: (value) => widget.categoryHandler(value),
            ),
          )),
        ],
      ),
    );
  }
}
