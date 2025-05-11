import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class DeployAppScreen extends StatefulWidget {
  @override
  _DeployAppScreenState createState() => _DeployAppScreenState();
}

class _DeployAppScreenState extends State<DeployAppScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverAddressController = TextEditingController();
  final _sshUsernameController = TextEditingController();
  final _sshPasswordController = TextEditingController();
  final _repoUrlController = TextEditingController();

  // For SSH authentication
  bool _usePrivateKey = false;
  String? _selectedPrivateKeyPath;
  String? _privateKeyFileName;

  // For SSH authentication method selection
  Future<void> _pickPrivateKeyFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pem', 'ppk', 'key'],
    );

    if (result != null) {
      setState(() {
        _selectedPrivateKeyPath = result.files.single.path;
        _privateKeyFileName = result.files.single.name;
      });
    }
  }

  void _deployApp() {
    if (_formKey.currentState!.validate()) {
      // Additional validation for private key when using it
      if (_usePrivateKey && _selectedPrivateKeyPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a private key file')),
        );
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deploying app...')));

      // Here you would handle the deployment with either password or key
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _serverAddressController,
                        decoration: InputDecoration(
                          labelText: 'Server Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter server address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _sshUsernameController,
                        decoration: InputDecoration(
                          labelText: 'SSH Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter SSH username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('SSH Authentication Method:'),
                          Spacer(),
                          ToggleButtons(
                            isSelected: [!_usePrivateKey, _usePrivateKey],
                            onPressed: (index) {
                              setState(() {
                                _usePrivateKey = index == 1;
                              });
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text('Password'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text('Private Key'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Conditional SSH authentication based on selected method
                      if (!_usePrivateKey)
                        TextFormField(
                          controller: _sshPasswordController,
                          decoration: InputDecoration(
                            labelText: 'SSH Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (!_usePrivateKey &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter SSH password';
                            }
                            return null;
                          },
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SSH Private Key:',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _privateKeyFileName ?? 'No file selected',
                                      style: TextStyle(
                                        color:
                                            _privateKeyFileName == null
                                                ? Colors.grey
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _pickPrivateKeyFile,
                                  child: Text('Select File'),
                                ),
                              ],
                            ),
                          ],
                        ),

                      SizedBox(height: 16),
                      TextFormField(
                        controller: _repoUrlController,
                        decoration: InputDecoration(
                          labelText: 'Repository URL',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter repository URL';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _deployApp, child: Text('Deploy App')),
            ],
          ),
        ),
      ),
    );
  }
}
