import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ContributeView();
  }
}

class _ContributeView extends StatefulWidget {
  const _ContributeView();

  @override
  State<_ContributeView> createState() => _ContributeViewState();
}

class _ContributeViewState extends State<_ContributeView> {
  String? _selectedFileName;
  String _selectedType = 'Slides';
  PlatformFile? _selectedFile;
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _writerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _selectedType == 'PDF' ? ['pdf'] : ['ppt', 'pptx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _selectedFileName = _selectedFile!.name;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    // Check if user is authenticated with Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to upload files'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_writerController.text.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the writer name'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    if (_categoryController.text.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the category'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Get file bytes
      final bytes = _selectedFile!.bytes;
      if (bytes == null) {
        throw Exception('No file data available');
      }

      // Generate a unique filename
      final fileExtension = _selectedFile!.extension?.toLowerCase() ?? '';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp-${_selectedFile!.name}';
      final folderPath = _selectedType.toLowerCase(); // 'pdf' or 'slides'

      // Upload to Supabase storage
      final storageResponse = await Supabase.instance.client
          .storage
          .from('documents')
          .uploadBinary(
            '$folderPath/$fileName',
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
            ),
          );

      if (storageResponse.error != null) {
        throw Exception(storageResponse.error!.message);
      }

      // Get the public URL as a string
      final fileUrl = Supabase.instance.client
          .storage
          .from('documents')
          .getPublicUrl('$folderPath/$fileName');

      // Store metadata in Firestore
      await FirebaseFirestore.instance.collection('documents').add({
        'name': _selectedFile!.name,
        'type': _selectedType,
        'writer': _writerController.text.trim(),
        'category': _categoryController.text.trim(),
        'url': fileUrl.toString(), // Convert URL to string
        'userId': user.uid,
        'created_at': FieldValue.serverTimestamp(),
        'size': _selectedFile!.size,
        'extension': fileExtension,
        'path': '$folderPath/$fileName', // Store the storage path
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear the form
        _writerController.clear();
        _categoryController.clear();
        setState(() {
          _selectedFileName = null;
          _selectedFile = null;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Get current Firebase user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (user == null) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please sign in to upload files',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to your existing sign-in page
                        Navigator.pushNamed(context, '/signin');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Upload Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTypeButton(
                              'Slides',
                              Icons.slideshow,
                              _selectedType == 'Slides',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTypeButton(
                              'PDF',
                              Icons.picture_as_pdf,
                              _selectedType == 'PDF',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload $_selectedType',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _writerController,
                        decoration: InputDecoration(
                          labelText: 'Writer Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.category),
                          hintText: 'e.g., Mathematics, Physics, Programming',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              _selectedType == 'Slides' 
                                  ? Icons.slideshow 
                                  : Icons.picture_as_pdf,
                              size: 48,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 16),
                            if (_isUploading)
                              const CircularProgressIndicator()
                            else if (_selectedFileName != null) ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _selectedFileName!,
                                        style: const TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _uploadFile,
                                icon: const Icon(Icons.cloud_upload),
                                label: const Text('Upload File'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ] else
                              Text(
                                'No file selected',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _pickFile,
                              icon: const Icon(Icons.upload_file),
                              label: Text(_selectedFileName == null 
                                  ? 'Choose File' 
                                  : 'Choose Different File'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedFileName = null; // Reset file selection when type changes
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
