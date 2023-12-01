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
  String? _selectedPrimaryMuscle;
  List<dynamic> _filteredItems = [];
  List<String> primaryMuscles = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _initPrimaryMuscles();
  }

  void _initPrimaryMuscles() {
    primaryMuscles = widget.items
        .map<String>((item) => item['muscles_worked']['primary'].toString())
        .toSet()
        .toList();
    primaryMuscles.insert(0, 'All');
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

    if (_selectedPrimaryMuscle != null && _selectedPrimaryMuscle != 'All') {
      results = results
          .where((item) =>
              item['muscles_worked']['primary'] == _selectedPrimaryMuscle)
          .toList();
    }

    // Add new item if it doesn't exist in the list
    if (results.isEmpty && enteredKeyword.isNotEmpty) {
      results.add({
        "name": enteredKeyword,
        "muscles_worked": {
          "primary": "Undefined",
          "secondary": ["Undefined"]
        }
      });
    }

    setState(() {
      _filteredItems = results;
    });
  }

  void _onPrimaryMuscleChanged(String? newValue) {
    setState(() {
      _selectedPrimaryMuscle = newValue;
      _filterItems(_controller.text);
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedPrimaryMuscle,
                  hint: Text('Primary Muscle'),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  onChanged: _onPrimaryMuscleChanged,
                  items: primaryMuscles
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredItems[index]['name']),
                onTap: () async {
                  // Check if primary muscle is undefined and prompt for muscle groups
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

  Future<void> _promptMuscleGroup(
      BuildContext context, Map<String, dynamic> item) async {
    // Show your SelectMuscleGroupDialog and get the result
    final muscles = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) => SelectMuscleGroupDialog(),
    );

    // Update the item with the selected muscle groups
    if (muscles != null) {
      item["muscles_worked"] = muscles;
    }
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
      titlePadding: EdgeInsets.all(16.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text('Select Muscles',
          style:
              theme.textTheme.headline6?.copyWith(color: theme.primaryColor)),
      children: [
        _buildPrimaryMusclePicker(theme),
        Divider(color: Colors.grey.shade300, thickness: 1),
        _buildSecondaryMuscleCheckboxes(theme),
        _buildDoneButton(theme),
      ],
    );
  }

  Widget _buildPrimaryMusclePicker(ThemeData theme) {
    return DropdownButton<String>(
      isExpanded: true,
      style: theme.textTheme.subtitle1,
      dropdownColor: theme.colorScheme.surface,
      hint: Text('Choose Primary Muscle',
          style: TextStyle(color: theme.hintColor)),
      value: primaryMuscle,
      items: muscles.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(color: theme.textTheme.subtitle1?.color)),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          primaryMuscle = newVal ?? "";
        });
      },
    );
  }

  Widget _buildSecondaryMuscleCheckboxes(ThemeData theme) {
    return Column(
      children: muscles.map<Widget>((e) {
        return CheckboxListTile(
          title: Text(e, style: theme.textTheme.bodyText2),
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
          checkColor: theme.colorScheme.onSecondary,
          activeColor: theme.colorScheme.secondary,
        );
      }).toList(),
    );
  }

  Widget _buildDoneButton(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: theme.primaryColor),
          onPressed: () {
            Navigator.of(context).pop({
              'primary': primaryMuscle,
              'secondary': selectedSecondaryMuscles
            });
          },
          child: Text('Done',
              style: TextStyle(color: theme.colorScheme.onPrimary)),
        ),
      ),
    );
  }
}
