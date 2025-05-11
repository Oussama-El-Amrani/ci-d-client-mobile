import 'package:flutter/material.dart';

/// A model class representing a Git commit
class GitCommit {
  final String id;
  final String message;
  final String author;
  final DateTime date;
  final List<String> files;

  GitCommit({
    required this.id,
    required this.message,
    required this.author,
    required this.date,
    required this.files,
  });
}

/// A service class to handle Git operations
class GitService {
  static final List<GitCommit> _commits = [];

  /// Get all commits for all features
  static List<GitCommit> getAllCommits() {
    return List.from(_commits.reversed); // Most recent first
  }

  /// Get commits for specific files
  static List<GitCommit> getCommitsForFiles(List<String> filePaths) {
    return _commits
        .where(
          (commit) => commit.files.any(
            (file) => filePaths.any((path) => file.contains(path)),
          ),
        )
        .toList()
        .reversed
        .toList(); // Most recent first
  }

  /// Add a new commit
  static void addCommit({
    required String message,
    required String author,
    required List<String> files,
  }) {
    // Generate a simple commit ID (in a real app, this would come from Git)
    final id =
        'commit_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    _commits.add(
      GitCommit(
        id: id,
        message: message,
        author: author,
        date: DateTime.now(),
        files: files,
      ),
    );
  }

  /// Initialize with some sample commits for each feature
  static void initializeWithSampleData() {
    // Clear any existing commits first
    _commits.clear();

    // Install Screen Commits
    addCommit(
      message: 'Initial implementation of technologies installation',
      author: 'Developer',
      files: ['lib/screens/install_screen.dart'],
    );

    addCommit(
      message: 'Add version selection for Docker and Node.js',
      author: 'Developer',
      files: ['lib/screens/install_screen.dart'],
    );

    addCommit(
      message: 'Add version selection for remaining technologies',
      author: 'Developer',
      files: ['lib/screens/install_screen.dart'],
    );

    // Deploy Screen Commits
    addCommit(
      message: 'Create basic deployment form',
      author: 'Developer',
      files: ['lib/screens/deploy_screen.dart'],
    );

    addCommit(
      message: 'Implement SSH authentication options',
      author: 'Developer',
      files: ['lib/screens/deploy_screen.dart', 'pubspec.yaml'],
    );

    addCommit(
      message: 'Add private key authentication',
      author: 'Developer',
      files: ['lib/screens/deploy_screen.dart'],
    );

    // Rollback Screen Commits
    addCommit(
      message: 'Initial implementation of rollback feature',
      author: 'Developer',
      files: ['lib/screens/rollback_screen.dart'],
    );

    addCommit(
      message: 'Add version history and rollback confirmation',
      author: 'Developer',
      files: ['lib/screens/rollback_screen.dart'],
    );

    // Logs Screen Commits
    addCommit(
      message: 'Create basic logs viewer',
      author: 'Developer',
      files: ['lib/screens/logs_screen.dart'],
    );

    addCommit(
      message: 'Add log filtering functionality',
      author: 'Developer',
      files: ['lib/screens/logs_screen.dart'],
    );

    // Main App Commits
    addCommit(
      message: 'Initial setup of the app with bottom navigation',
      author: 'Developer',
      files: ['lib/main.dart', 'lib/router.dart'],
    );

    addCommit(
      message: 'Refactor to use tab-based navigation',
      author: 'Developer',
      files: ['lib/main.dart', 'lib/router.dart'],
    );

    addCommit(
      message: 'UI improvements for better user experience',
      author: 'Developer',
      files: [
        'lib/main.dart',
        'lib/screens/install_screen.dart',
        'lib/screens/deploy_screen.dart',
      ],
    );
  }
}

/// A widget to display Git commit history
class CommitHistoryDialog extends StatelessWidget {
  final List<GitCommit> commits;
  final String title;

  const CommitHistoryDialog({
    Key? key,
    required this.commits,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: commits.length,
          itemBuilder: (context, index) {
            final commit = commits[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.commit, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          commit.id,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      commit.message,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Author: ${commit.author} - ${_formatDate(commit.date)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Files:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...commit.files.map(
                      (file) => Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Text(
                          '• $file',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Show commit history for a specific feature
void showCommitHistory(
  BuildContext context, {
  required List<String> files,
  String? title,
}) {
  final commits = GitService.getCommitsForFiles(files);
  showDialog(
    context: context,
    builder:
        (context) => CommitHistoryDialog(
          commits: commits,
          title: title ?? 'Commit History',
        ),
  );
}

/// Show all commits
void showAllCommits(BuildContext context) {
  final commits = GitService.getAllCommits();
  showDialog(
    context: context,
    builder:
        (context) =>
            CommitHistoryDialog(commits: commits, title: 'All Commits'),
  );
}

/// A button to show commit history for a feature
class CommitHistoryButton extends StatelessWidget {
  final List<String> files;
  final String title;
  final IconData icon;

  const CommitHistoryButton({
    Key? key,
    required this.files,
    required this.title,
    this.icon = Icons.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text('View Commits'),
      onPressed: () => showCommitHistory(context, files: files, title: title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
    );
  }
}
