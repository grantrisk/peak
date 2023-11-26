import 'package:flutter/material.dart';

// Custom Searchable Dropdown Widget
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
      // If the search field is empty, keep the _filteredItems list empty
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

    return Container(
      height: MediaQuery.of(context)
          .size
          .height, // Set a fixed height for the container
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _filterItems,
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(color: theme.colorScheme.onSurface),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: theme.colorScheme.secondary, width: 2.0),
              ),
              fillColor: theme.colorScheme.surface,
              filled: true,
              suffixIcon: Icon(Icons.search),
            ),
            cursorColor: theme.colorScheme.secondary,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredItems[index]['name']),
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
      ),
    );
  }
}
