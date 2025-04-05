import 'package:flutter/material.dart';

class MaritalStatusDropdown extends StatefulWidget {
  final String selectedStatus;
  final Function(String?) onChanged;

  const MaritalStatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  _MaritalStatusDropdownState createState() => _MaritalStatusDropdownState();
}

class _MaritalStatusDropdownState extends State<MaritalStatusDropdown> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
  }

  @override
  void didUpdateWidget(covariant MaritalStatusDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedStatus != widget.selectedStatus) {
      _selectedStatus = widget.selectedStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Marital Status'),
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedStatus,
          onChanged: (value) {
            setState(() => _selectedStatus = value!);
            widget.onChanged(value);
          },
          items: const [
            DropdownMenuItem(value: 'Single', child: Text('Single')),
            DropdownMenuItem(value: 'Married', child: Text('Married')),
            DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
            // DropdownMenuItem(value: 'Armal', child: Text('Widowed')),
          ],
        ),
      ],
    );
  }
}
