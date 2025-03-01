import 'package:flutter_riverpod/flutter_riverpod.dart';

final FutureItemProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  // throw "Internet Not WOrking";
  return 3;
});
