import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpo/future/futureprovider.dart';

class FutureScreen extends ConsumerWidget {
  const FutureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(FutureItemProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("FutureProvider"),
      ),
      body: Center(
        child: provider.when(
            skipLoadingOnRefresh: false,
            data: (value) => Text(value.toString()),
            error: (error, stack) => Text(error.toString()),
            loading: () => const CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        ref.invalidate(FutureItemProvider);
      }),
    );
  }
}
