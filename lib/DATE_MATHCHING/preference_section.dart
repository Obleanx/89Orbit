import 'package:flutter/material.dart';

class PreferenceSection extends StatefulWidget {
  final String title;
  final List<String> items;
  final int maxSelection;
  final int? minSelection;
  final Function(List<String>) onSelectionChanged;

  const PreferenceSection({
    Key? key,
    required this.title,
    required this.items,
    required this.maxSelection,
    this.minSelection,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _PreferenceSectionState createState() => _PreferenceSectionState();
}

class _PreferenceSectionState extends State<PreferenceSection> {
  List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: widget.items.map((item) {
            final isSelected = _selectedItems.contains(item);
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (_selectedItems.length < widget.maxSelection) {
                      _selectedItems.add(item);
                    }
                  } else {
                    _selectedItems.remove(item);
                  }
                  widget.onSelectionChanged(
                      _selectedItems); // Ensure this is called after setState
                  // Debugging: Print selected items after each change
                  print(
                      'Current selection for ${widget.title}: $_selectedItems');
                });
              },
              selectedColor: Colors.blueAccent,
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        if (widget.minSelection != null &&
            _selectedItems.length < widget.minSelection!)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Select at least ${widget.minSelection} item(s).',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
