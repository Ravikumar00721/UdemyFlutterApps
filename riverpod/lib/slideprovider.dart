import 'package:flutter_riverpod/flutter_riverpod.dart';

final SliderProvider = StateProvider<AppState>((ref) {
  return AppState(slider: 0.5, showPassword: false);
});

class AppState {
  final double slider;
  final bool showPassword;

  AppState({required this.slider, required this.showPassword});

  AppState copywith({double? slider, bool? showpaasword}) {
    return AppState(
        slider: slider ?? this.slider,
        showPassword: showpaasword ?? this.showPassword);
  }
}
