import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpo/searchProvider.dart';

class CenteredTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Centered TextField')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).search(value);
              },
            ),
            SizedBox(height: 10),
            Consumer(builder: (context, ref, child) {
              final search = ref.watch(searchProvider);
              return Text(search.search);
            })
          ],
        ),
      ),
    );
  }
}
