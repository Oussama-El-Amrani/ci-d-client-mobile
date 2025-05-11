import 'package:flutter/material.dart';
import 'router.dart';
import 'screens/install_screen.dart';
import 'screens/deploy_screen.dart';
import 'screens/rollback_screen.dart';
import 'screens/logs_screen.dart';
import 'utils/git_service.dart';

void main() {
  // Initialize Git service with sample data
  GitService.initializeWithSampleData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Deployment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false, // Remove debug banner for a cleaner UI
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showScrollToTopButton = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AppRouter.tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Add scroll listener to show/hide scroll-to-top button (like WhatsApp)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300 && !_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else if (_scrollController.position.pixels <= 300 &&
          _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {}); // Rebuild for FAB changes
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Deployment'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            tooltip: 'View All Commits',
            onPressed: () => showAllCommits(context),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Search feature coming soon')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Selected: $value')));
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'settings', child: Text('Settings')),
                  PopupMenuItem(value: 'help', child: Text('Help')),
                  PopupMenuItem(value: 'about', child: Text('About')),
                ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: AppRouter.tabs,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
        ),
      ),
      body: TabBarView(controller: _tabController, children: AppRouter.screens),
      floatingActionButton: Stack(
        children: [
          if (_showScrollToTopButton)
            Positioned(
              bottom: 80,
              right: 0,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.grey[300],
                onPressed: _scrollToTop,
                child: Icon(Icons.arrow_upward, color: Colors.black54),
              ),
            ),
          _buildFloatingActionButton() ?? Container(),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    // Different FAB for different tabs, similar to WhatsApp
    switch (_tabController.index) {
      case 0: // Install tab
        return FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Install new app')));
          },
          child: Icon(Icons.add),
        );
      case 1: // Deploy tab
        return FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Quick deploy')));
          },
          child: Icon(Icons.rocket_launch),
        );
      default:
        return null;
    }
  }
}
