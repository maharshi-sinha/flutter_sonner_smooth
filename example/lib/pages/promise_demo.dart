import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

/// Demonstrates the promise toast API.
class PromiseDemo extends StatelessWidget {
  /// Creates a promise demo page.
  const PromiseDemo({super.key});

  Future<String> _simulateUpload() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) {
      return 'https://cdn.example.com/file.pdf';
    }
    throw Exception('Network timeout');
  }

  Future<Map<String, dynamic>> _simulateSave() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    return {'id': 42, 'status': 'saved'};
  }

  Future<int> _simulateDelete() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Promise API',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Loading → Success or Error automatically',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File (50/50)'),
              onPressed: () => toast.promise(
                _simulateUpload(),
                loading: 'Uploading file...',
                success: (url) => 'Uploaded to $url',
                error: (e) => 'Upload failed: $e',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.save),
              label: const Text('Save Document'),
              onPressed: () => toast.promise(
                _simulateSave(),
                loading: 'Saving document...',
                success: (data) => 'Saved (id: ${data['id']})',
                error: (e) => 'Save failed: $e',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Items'),
              onPressed: () => toast.promise(
                _simulateDelete(),
                loading: 'Deleting items...',
                success: (count) => 'Deleted $count items',
                error: (e) => 'Delete failed: $e',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
