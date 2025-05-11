import 'package:flutter/material.dart';

class RollbackScreen extends StatelessWidget {
  final List<String> appVersions = ['v1.0.0', 'v1.1.0', 'v1.2.0'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: appVersions.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.history),
              title: Text(appVersions[index]),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Rolling back to ${appVersions[index]}...'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
