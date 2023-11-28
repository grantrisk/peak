import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchableDropdown extends StatefulWidget {
  final List<dynamic> items;
  final Function(Map<String, dynamic>) onItemSelect; // Updated type here

  SearchableDropdown({required this.items, required this.onItemSelect});

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();

  static void show(BuildContext context, List<dynamic> items,
      Function(Map<String, dynamic>) onItemSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFFFFFFFF),
      builder: (BuildContext context) {
        return SearchableDropdown(
          items: items,
          onItemSelect: (selectedItem) {
            HapticFeedback.heavyImpact();
            onItemSelect(selectedItem); // Ensure this matches the expected type
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  TextEditingController _controller = TextEditingController();
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = widget.items;
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            onChanged: _filterItems,
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
            autofocus: true,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                style: ListTileStyle.drawer,
                title: Text(
                  _filteredItems[index]['name'],
                ),
                onTap: () {
                  widget.onItemSelect(_filteredItems[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
