import 'package:flutter/material.dart';

class LogsScreen extends StatefulWidget {
  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  // Filter options
  final List<String> _logLevels = ['All', 'Info', 'Warning', 'Error', 'Debug'];
  String _selectedLogLevel = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();

  // Mock log data for demonstration
  final List<Map<String, dynamic>> _mockLogs = [
    {
      'level': 'Info',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
      'message': 'Application started',
    },
    {
      'level': 'Debug',
      'timestamp': DateTime.now().subtract(Duration(minutes: 45)),
      'message': 'Connected to database',
    },
    {
      'level': 'Warning',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
      'message': 'Slow query detected',
    },
    {
      'level': 'Error',
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
      'message': 'Failed to connect to API',
    },
    {
      'level': 'Info',
      'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
      'message': 'User logged in',
    },
  ];

  // Filtered logs based on selected filters
  List<Map<String, dynamic>> get _filteredLogs {
    return _mockLogs.where((log) {
      // Filter by log level
      if (_selectedLogLevel != 'All' && log['level'] != _selectedLogLevel) {
        return false;
      }

      // Filter by date range
      if (_startDate != null && log['timestamp'].isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null &&
          log['timestamp'].isAfter(_endDate!.add(Duration(days: 1)))) {
        return false;
      }

      // Filter by search text
      if (_searchController.text.isNotEmpty &&
          !log['message'].toString().toLowerCase().contains(
            _searchController.text.toLowerCase(),
          )) {
        return false;
      }

      return true;
    }).toList();
  }

  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedLogLevel = 'All';
      _startDate = null;
      _endDate = null;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Search field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search logs',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16),

                    // Log level dropdown
                    Row(
                      children: [
                        Text('Log Level:'),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedLogLevel,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            items:
                                _logLevels.map((String level) {
                                  return DropdownMenuItem<String>(
                                    value: level,
                                    child: Text(level),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedLogLevel = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Date range pickers
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectStartDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                _startDate != null
                                    ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                    : 'Select',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: _selectEndDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                _endDate != null
                                    ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                                    : 'Select',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Clear filters button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _clearFilters,
                        icon: Icon(Icons.clear),
                        label: Text('Clear Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Logs section
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('${_filteredLogs.length} entries'),
                        ],
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      Expanded(
                        child:
                            _filteredLogs.isEmpty
                                ? Center(
                                  child: Text(
                                    'No logs match the selected filters',
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: _filteredLogs.length,
                                  separatorBuilder:
                                      (context, index) => Divider(),
                                  itemBuilder: (context, index) {
                                    final log = _filteredLogs[index];
                                    return ListTile(
                                      dense: true,
                                      title: Text(log['message']),
                                      subtitle: Text(
                                        _formatTimestamp(log['timestamp']),
                                      ),
                                      leading: _getLogLevelIcon(log['level']),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  // Get appropriate icon for log level
  Widget _getLogLevelIcon(String level) {
    IconData iconData;
    Color color;

    switch (level) {
      case 'Info':
        iconData = Icons.info;
        color = Colors.blue;
        break;
      case 'Warning':
        iconData = Icons.warning;
        color = Colors.orange;
        break;
      case 'Error':
        iconData = Icons.error;
        color = Colors.red;
        break;
      case 'Debug':
        iconData = Icons.code;
        color = Colors.green;
        break;
      default:
        iconData = Icons.text_snippet;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(iconData, size: 18, color: color),
    );
  }
}
