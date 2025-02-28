import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
    StateNotifierProvider<SearchNotifier, searchState>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<searchState> {
  SearchNotifier() : super(searchState(search: '', isChange: false));

  void search(String query) {
    state = state.copywith(search: query);
  }

  void onChange(bool isChange) {
    state = state.copywith(isChange: isChange);
  }
}

class searchState {
  final String search;
  final bool isChange;
  searchState({required this.search, required this.isChange});

  searchState copywith({String? search, bool? isChange}) {
    return searchState(
        search: search ?? this.search, isChange: isChange ?? this.isChange);
  }
}
