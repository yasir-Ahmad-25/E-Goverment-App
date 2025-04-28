import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final String selectedGender;
  final Function(String?) onChanged;

  const GenderDropdown({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  @override
  void didUpdateWidget(covariant GenderDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGender != widget.selectedGender) {
      _selectedGender = widget.selectedGender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender'),
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedGender,
          onChanged: (value) {
            setState(() => _selectedGender = value!);
            widget.onChanged(value);
          },
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
        ),
      ],
    );
  
  }
}
