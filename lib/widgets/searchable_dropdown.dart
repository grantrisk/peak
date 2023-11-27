import 'package:flutter/material.dart';

class SearchableDropdown extends StatefulWidget {
  final List<dynamic> items;
  final Function(dynamic) onItemSelect;

  SearchableDropdown({required this.items, required this.onItemSelect});

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = [];
  }

  void _filterItems(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = [];
    } else {
      results = widget.items
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          onChanged: _filterItems,
          decoration: InputDecoration(
            labelText: 'Search',
            labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: theme.colorScheme.secondary, width: 2.0),
            ),
            fillColor: theme.colorScheme.primary,
            filled: true,
            suffixIcon: Icon(Icons.search),
          ),
          style: TextStyle(
              color: theme.colorScheme.onSecondary), // Text color when typing
          cursorColor: theme.colorScheme.onPrimary, // Cursor color
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredItems[index]['name'],
                    style: TextStyle(color: theme.colorScheme.onPrimary)),
                onTap: () {
                  widget.onItemSelect(_filteredItems[index]);
                  _controller.clear();
                  _filterItems('');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
