import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchableDropdown extends StatefulWidget {
  final List<dynamic> items;
  final Function(Map<String, dynamic>) onItemSelect;

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
            onItemSelect(selectedItem);
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

      // Add new item when search keyword not found.
      if (results.isEmpty) {
        results.add({
          "id": enteredKeyword.toLowerCase().replaceAll(' ', '-'),
          "name": enteredKeyword,
          "muscles_worked": {
            "primary": "Undefined",
            "secondary": ["Undefined"]
          }
        });
      }
    }

    setState(() {
      _filteredItems = results;
    });
  }

  Future<void> _promptMuscleGroup(
      BuildContext context, Map<String, dynamic> item) async {
    // Implement your SelectMuscleGroupDialog return selected muscle group (primary and secondary should be List<String>)
    final muscles = await showDialog<Map<String, Object?>>(
        context: context, builder: (context) => SelectMuscleGroupDialog());

    if (muscles?["primary"] == null) {
      item["muscles_worked"]["primary"] = "Undefined";
    } else {
      item["muscles_worked"]["primary"] = muscles?["primary"];
    }

    if (muscles?["secondary"] == null) {
      item["muscles_worked"]["secondary"] = ["Undefined"];
    } else {
      item["muscles_worked"]["secondary"] = muscles?["secondary"];
    }
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
                onTap: () async {
                  if (_filteredItems[index]["muscles_worked"]["primary"] ==
                      "Undefined") {
                    await _promptMuscleGroup(context, _filteredItems[index]);
                  }
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

class SelectMuscleGroupDialog extends StatefulWidget {
  @override
  _SelectMuscleGroupDialogState createState() =>
      _SelectMuscleGroupDialogState();
}

class _SelectMuscleGroupDialogState extends State<SelectMuscleGroupDialog> {
  String? primaryMuscle;
  List<String> selectedSecondaryMuscles = [];
  List<String> muscles = [
    "shoulders",
    "traps",
    "chest",
    "forearms",
    "biceps",
    "triceps",
    "lats",
    "lower-back",
    "abs",
    "glutes",
    "quads",
    "hamstrings",
    "obliques",
    "adductors",
    "abductors",
    "calves"
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SimpleDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Muscles',
                  style: TextStyle(color: theme.primaryColor)),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.surface,
                ),
                onPressed: () {
                  Navigator.of(context).pop({
                    'primary': primaryMuscle,
                    'secondary': selectedSecondaryMuscles
                  });
                },
                child: Text('Done',
                    style: TextStyle(color: theme.colorScheme.onSurface)),
              ),
            ],
          ),
          Divider(color: Colors.black),
        ],
      ),
      children: [
        // Primary Muscle Picklist
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                style: TextStyle(color: theme.colorScheme.onSurface),
                dropdownColor: theme.colorScheme.surface,
                hint: Text('Choose Primary Muscle',
                    style: TextStyle(color: theme.colorScheme.onSurface)),
                value: primaryMuscle,
                items: List<DropdownMenuItem<String>>.generate(
                  muscles.length,
                  (int index) {
                    return DropdownMenuItem<String>(
                      value: muscles[index],
                      child: Text(muscles[index],
                          style: TextStyle(color: theme.colorScheme.onSurface)),
                    );
                  },
                ),
                onChanged: (newVal) {
                  setState(() {
                    primaryMuscle = newVal ?? "";
                  });
                },
              ),
            ),
          ],
        ),
        // Secondary Muscles Checkbox
        ...muscles.map<Widget>((e) {
          return CheckboxListTile(
            title:
                Text(e, style: TextStyle(color: theme.colorScheme.onSurface)),
            value: selectedSecondaryMuscles.contains(e),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedSecondaryMuscles.add(e);
                } else {
                  selectedSecondaryMuscles.remove(e);
                }
              });
            },
            fillColor: MaterialStateProperty.all(theme.colorScheme.surface),
            checkColor: theme.colorScheme.primary,
          );
        }).toList(),
      ],
    );
  }
}
