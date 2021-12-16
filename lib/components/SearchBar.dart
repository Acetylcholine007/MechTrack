import 'package:flutter/material.dart';
import 'package:mech_track/shared/decorations.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key, this.controller, this.filterHandler}) : super(key: key);
  final TextEditingController controller;
  final Function() filterHandler;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: ListTile(
          title: TextFormField(
            controller: controller,
            decoration: searchFieldDecoration
              .copyWith(
              suffixIcon: IconButton(
                icon: Icon(Icons.highlight_off), onPressed: () => controller.clear()
              )
            )
          ),
          trailing: IconButton(
            icon: Icon(Icons.filter_list_rounded), onPressed: filterHandler
          ),
        ),
      ),
    );
  }
}
