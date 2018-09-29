# Flutter Redux Example

Flutter example project using redux with multiple reducers & combineReducers.

## Getting Started

To get started, clone the project:

```sh
git clone https://github.com/dabit3/flutter-redux-example.git
```

## Redux files

### model.dart

```dart
import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;

  Item({
    @required this.id,
    @required this.body
  });
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
```

### reducers.dart

```dart
import 'package:reduxexample/model.dart';
import 'package:reduxexample/redux/actions.dart';

enum Actions { Increment }

AppState appStateReducer(AppState state, action) {
  return AppState(
    items: itemReducer(state.items, action),
    count: incrementReducer(state.count, action),
  );
}

int incrementReducer(int state, action) {
  if (action == Actions.Increment) {
    return state + 1;
  }
  return state;
}

List <Item> itemReducer(List<Item> state, action) {
  if (action is AddItemAction) {
    return []
      ..addAll(state)
      ..add(Item(id: action.id, body: action.item));
  }

  if (action is RemoveItemAction) {
    return List.unmodifiable(List.from(state)..remove(action.item));
  }

  if (action is RemoveItemsAction) {
    return List.unmodifiable([]);
  }

  return state;
}

```

### Creating the store

```dart
final Store store = Store<AppState>(
  appStateReducer,
  initialState: AppState.initialState(),
);

return StoreProvider<AppState>(
  store: store,
  child: new MaterialApp(
    title: 'Flutter App',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyHomePage()
  ),
);
```