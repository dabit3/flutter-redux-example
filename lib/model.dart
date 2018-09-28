import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;

  Item({
    @required this.id,
    @required this.body
  });

  Item copyWith({ int id, String body }) {
    return Item(
      id: id ?? this.id,
      body: body ?? this.body
    );
  }
}

class AppState {
  final List<Item> items;
  final int count;

  AppState({
    @required this.items,
    @required this.count,
  });

  AppState.initialState()
  : items = List.unmodifiable(<Item>[]),
    count = 0;
}