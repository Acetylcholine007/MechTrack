import 'package:flutter/material.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/shared/decorations.dart';

class TwoPartSearchBar extends StatefulWidget {
  const TwoPartSearchBar({Key key,
    this.categoryHandler1,
    this.searchHandler1,
    this.category1,
    this.categoryHandler2,
    this.searchHandler2,
    this.category2,
    this.context,
  this.fields}) : super(key: key);

  final Function(String) categoryHandler1;
  final Function(String) searchHandler1;
  final String category1;
  final Function(String) categoryHandler2;
  final Function(String) searchHandler2;
  final String category2;
  final BuildContext context;
  final Field fields;

  @override
  State<TwoPartSearchBar> createState() => _TwoPartSearchBarState();
}

class _TwoPartSearchBarState extends State<TwoPartSearchBar> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  void filterHandler1() {
    String newCat = widget.category1;

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
                  widget.categoryHandler1(newCat);
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
          ],
        )
    );
  }

  void filterHandler2() {
    String newCat = widget.category2;

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
                  widget.categoryHandler2(newCat);
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
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: TextFormField(
                controller: controller1,
                decoration: searchFieldDecoration.copyWith(
                    suffixIcon: IconButton(onPressed: () {
                      controller1.text = "";
                      widget.searchHandler1("");
                    }, icon: Icon(Icons.highlight_off_rounded))
                ),
                onChanged: widget.searchHandler1,
              ),
              trailing: IconButton(
                  icon: Icon(Icons.filter_list_rounded, color: Colors.white), onPressed: filterHandler1
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: controller2,
                decoration: searchFieldDecoration.copyWith(
                    suffixIcon: IconButton(onPressed: () {
                      controller2.text = "";
                      widget.searchHandler2("");
                    }, icon: Icon(Icons.highlight_off_rounded))
                ),
                onChanged: widget.searchHandler2,
              ),
              trailing: IconButton(
                  icon: Icon(Icons.filter_list_rounded, color: Colors.white), onPressed: filterHandler2
              ),
            ),
          ],
        ),
      ),
    );
  }
}
