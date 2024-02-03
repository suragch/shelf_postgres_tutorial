import 'package:flutter/material.dart';

import '../models/score.dart';
import 'home_page_manager.dart';

class ShelfPostgresDemo extends StatefulWidget {
  const ShelfPostgresDemo({super.key});

  @override
  State<ShelfPostgresDemo> createState() => _ShelfPostgresDemoState();
}

class _ShelfPostgresDemoState extends State<ShelfPostgresDemo> {
  final manager = HomePageManager();

  @override
  void initState() {
    super.initState();
    manager.snackbarCallback = _showSnackbar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.topLeft,
              child: ValueListenableBuilder<Score?>(
                valueListenable: manager.selectedScoreNotifier,
                builder: (context, score, _) {
                  final text = (score == null) ? '' : 'ID: ${score.id}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: manager.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: manager.scoreController,
                    decoration: const InputDecoration(
                      labelText: 'Score',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            TaskButton(title: 'Create', onPressed: manager.create),
            TaskButton(title: 'Read', onPressed: manager.read),
            TaskButton(title: 'Update', onPressed: manager.update),
            TaskButton(title: 'Delete', onPressed: manager.delete),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<List<Score>>(
                valueListenable: manager.listNotifier,
                builder: (context, rows, child) {
                  return ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Card(
                        child: ListTile(
                          leading: Text(
                            row.score.toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                          title: Text(row.userId),
                          subtitle: Text(
                            row.updated.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                          onTap: () => manager.onScoreTapped(row),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class TaskButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const TaskButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: 150,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}
