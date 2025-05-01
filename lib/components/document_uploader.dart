import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentUploader extends StatefulWidget {
  final Function(PlatformFile?) onFileSelected;
  
  final String initialPlaceholderText;
  const DocumentUploader({super.key, required this.onFileSelected, required this.initialPlaceholderText});

  @override
  _DocumentUploaderState createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  PlatformFile? _selectedFile;
  late String _placeholderText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placeholderText = widget.initialPlaceholderText;
  }

  void _updatePlaceholderText(String newText) {
    setState(() {
      _placeholderText = newText;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        if (_selectedFile != null) {
          // widget.placeholderText = _selectedFile!.name;
          _updatePlaceholderText(_selectedFile!.name);
        }
      });
      widget.onFileSelected(_selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file),
              label: Text(_placeholderText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Background color (primary blue)
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 8px border radius
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ), // Optional: Adjust padding
              ),
            ),
          ),
        ),
      ],
    );
  }
}
