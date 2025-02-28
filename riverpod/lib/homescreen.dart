import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final switchProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Center(
        // ✅ Wrapping with Center to properly align content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Using Consumer to rebuild only this Text widget when the counter changes
            Consumer(
              builder: (context, ref, child) {
                final counter = ref.watch(counterProvider);
                return Text(
                  counter.toString(),
                  style: const TextStyle(fontSize: 50),
                );
              },
            ),
            const SizedBox(height: 20),
            // ✅ Using Consumer for the switch so only it rebuilds
            Consumer(
              builder: (context, ref, child) {
                final switchValue = ref.watch(switchProvider);
                return Switch(
                  value: switchValue,
                  onChanged: (value) {
                    ref.read(switchProvider.notifier).state = value;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(counterProvider.notifier).state++;
              },
              child: const Text(
                "+",
                style: TextStyle(fontSize: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
