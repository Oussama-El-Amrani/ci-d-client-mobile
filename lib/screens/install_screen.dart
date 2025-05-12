import 'package:flutter/material.dart';
import '../utils/git_service.dart';

class Technology {
  final String name;
  final IconData icon;
  final List<String> versions;
  String selectedVersion;

  Technology({
    required this.name,
    required this.icon,
    required this.versions,
  }) : selectedVersion = versions.isNotEmpty ? versions[0] : '';
}

class InstallAppsScreen extends StatefulWidget {
  @override
  _InstallAppsScreenState createState() => _InstallAppsScreenState();
}

class _InstallAppsScreenState extends State<InstallAppsScreen> {
  final List<Technology> technologies = [
    Technology(
      name: 'Docker',
      icon: Icons.dns,
      versions: ['20.10.24', '24.0.6', '25.0.0'],
    ),
    Technology(
      name: 'Node.js',
      icon: Icons.code,
      versions: ['16.20.1 LTS', '18.17.1 LTS', '20.9.0 LTS', '22.0.0'],
    ),
    Technology(
      name: 'Nginx',
      icon: Icons.web,
      versions: ['1.22.1', '1.24.0', '1.25.3'],
    ),
    Technology(
      name: 'PostgreSQL',
      icon: Icons.storage,
      versions: ['13.12', '14.10', '15.5', '16.1'],
    ),
    Technology(
      name: 'MongoDB',
      icon: Icons.storage,
      versions: ['5.0.21', '6.0.12', '7.0.4'],
    ),
    Technology(
      name: 'Redis',
      icon: Icons.storage,
      versions: ['6.2.13', '7.0.14', '7.2.3'],
    ),
  ];

  void _updateLogs(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showVersionPicker(BuildContext context, Technology technology) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select ${technology.name} Version',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: technology.versions.length,
                itemBuilder: (context, index) {
                  final version = technology.versions[index];
                  return ListTile(
                    title: Text(version),
                    leading: Radio<String>(
                      value: version,
                      groupValue: technology.selectedVersion,
                      onChanged: (value) {
                        setState(() {
                          technology.selectedVersion = value!;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Commits history button
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommitHistoryButton(
                    files: ['lib/screens/install_screen.dart'],
                    title: 'Install Screen Commits',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: technologies.length,
                itemBuilder: (context, index) {
            final tech = technologies[index];
            return Card(
              margin: EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(tech.icon),
                title: Text(tech.name),
                subtitle: Text('Version: ${tech.selectedVersion}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => _showVersionPicker(context, tech),
                      child: Text('Change Version'),
                    ),
                    IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () => _updateLogs(
                        context,
                        'Installing ${tech.name} ${tech.selectedVersion}...',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
