import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpo/slideprovider.dart';

class HomeScreen2 extends ConsumerWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StateProvider"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final colors = ref.watch(SliderProvider);
              return Container(
                width: 200,
                height: 200,
                color: Colors.red.withOpacity(colors.slider),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final slider =
                  ref.watch(SliderProvider.select((state) => state.slider));
              return Slider(
                  value: slider,
                  onChanged: (value) {
                    final stateprovider = ref.read(SliderProvider.notifier);
                    stateprovider.state =
                        stateprovider.state.copywith(slider: value);
                  });
            },
          )
        ],
      ),
    );
  }
}
