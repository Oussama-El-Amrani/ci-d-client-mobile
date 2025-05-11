import 'package:flutter/material.dart';

// Screen imports
import 'screens/install_screen.dart';
import 'screens/deploy_screen.dart';
import 'screens/rollback_screen.dart';
import 'screens/logs_screen.dart';

// Tab controller for WhatsApp-like navigation
class AppRouter {
  static final screens = [
    InstallAppsScreen(),
    DeployAppScreen(),
    RollbackScreen(),
    LogsScreen(),
  ];

  static const tabs = [
    Tab(icon: Icon(Icons.install_desktop), text: 'Install'),
    Tab(icon: Icon(Icons.cloud_upload), text: 'Deploy'),
    Tab(icon: Icon(Icons.history), text: 'Rollback'),
    Tab(icon: Icon(Icons.list), text: 'Logs'),
  ];
}
