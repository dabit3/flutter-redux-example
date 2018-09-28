import 'package:reduxexample/model.dart';
import 'package:reduxexample/redux/actions.dart';

enum Actions { Increment, Add }

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
