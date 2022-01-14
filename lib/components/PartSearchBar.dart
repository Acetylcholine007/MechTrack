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

  void filterHandler() {
    int newCatIndex = widget.catIndex;

    showDialog(
        context: widget.context,
        builder: (context) => AlertDialog(
          title: Text('Search Selector'),
          content: DropdownButtonFormField(
            value: newCatIndex,
            items: widget.fields.fields.values.toList().asMap().entries.map((category) => DropdownMenuItem(
                value: category.key,
                child: Text(category.value)
            )).toList(),
            onChanged: (value) => newCatIndex = value,
            decoration: formFieldDecoration,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  widget.categoryHandler(newCatIndex);
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: ListTile(
          title: TextFormField(
            controller: controller,
            decoration: searchFieldDecoration.copyWith(
              suffixIcon: IconButton(onPressed: () {
                controller.text = "";
                widget.searchHandler("");
              }, icon: Icon(Icons.highlight_off_rounded))
            ),
            onChanged: widget.searchHandler,
          ),
          trailing: IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Colors.white), onPressed: filterHandler
          ),
        ),
      ),
    );
  }
}
