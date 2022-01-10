import 'package:flutter/material.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/shared/decorations.dart';

class PartSearchBar extends StatefulWidget {
  const PartSearchBar({Key key,
    this.categoryHandler,
    this.searchHandler,
    this.category,
    this.context, this.fields}) : super(key: key);

  final Function(String) categoryHandler;
  final Function(String) searchHandler;
  final String category;
  final BuildContext context;
  final Field fields;

  @override
  State<PartSearchBar> createState() => _PartSearchBarState();
}

class _PartSearchBarState extends State<PartSearchBar> {
  TextEditingController controller = TextEditingController();

  void filterHandler() {
    String newCat = widget.category;

    showDialog(
        context: widget.context,
        builder: (context) => AlertDialog(
          title: Text('Search Selector'),
          content: DropdownButtonFormField(
            value: newCat,
            items: widget.fields.fields.keys.map((String category) => DropdownMenuItem(
                value: category,
                child: Text(widget.fields.fields[category])
            )).toList(),
            onChanged: (value) => newCat = value,
            decoration: formFieldDecoration,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  widget.categoryHandler(newCat);
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
