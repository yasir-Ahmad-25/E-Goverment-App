import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentUploader extends StatefulWidget {
  final Function(PlatformFile?) onFileSelected;

  const DocumentUploader({Key? key, required this.onFileSelected})
      : super(key: key);

  @override
  _DocumentUploaderState createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
      widget.onFileSelected(_selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: Icon(Icons.upload_file),
          label: Text('Upload Document'),
        ),
        if (_selectedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Selected: ${_selectedFile!.name}'),
          ),
      ],
    );
  }
}
