import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item.dart';

final itemProvider = StateNotifierProvider<ItemNotifier, List<Item>>((ref) {
  return ItemNotifier();
});

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super([]);

  void addItem(String name) {
    final item = Item(id: DateTime.now().toString(), name: name);
    state.add(item);
    state = state.toList();
  }

  void updateItem(String id, String name) {
    int itemIndex = state.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      state[itemIndex] = Item(id: id, name: name); // ✅ Modify item directly
      state = List.from(
          state); // ✅ Assign a new reference so Riverpod detects change
    }
  }

  void deleteItem(String id) {
    state.removeWhere((item) => item.id == id);
    state = state.toList();
  }
}
