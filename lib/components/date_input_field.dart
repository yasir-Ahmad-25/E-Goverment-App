import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl: ^0.17.0 to pubspec.yaml

class DateInputField extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onChanged;
  final String labelText;
  final bool enabled;

  const DateInputField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.labelText = 'Date of Birth', required this.enabled,
  });

  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  late DateTime? _selectedDate;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(covariant DateInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.labelText),
        const SizedBox(height: 8),
        GestureDetector(
          // onTap: () => _selectDate(context),
          onTap:  widget.enabled ? () => _selectDate(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              border: Border.all(color: widget.enabled ? Colors.grey : Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? _dateFormatter.format(_selectedDate!)
                      : 'Select Birth Date',
                  // style: TextStyle(
                  //   color: _selectedDate != null ? Colors.black : Colors.grey,
                  // ),
                  style: TextStyle(
                    color: widget.enabled 
                        ? (_selectedDate != null ? Colors.black : Colors.grey)
                        : Colors.grey, // Disabled text color
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  // color: Theme.of(context).primaryColor,
                  color: widget.enabled 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey, // Disabled icon color
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
