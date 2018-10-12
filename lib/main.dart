import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:reduxexample/model.dart';
import 'package:reduxexample/redux/actions.dart';
import 'package:reduxexample/redux/reducers.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          ),
          secondaryHeaderColor: Colors.grey[600],
          buttonColor: Colors.black,
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
          accentColor: Colors.purpleAccent,
          canvasColor: Colors.grey[200]
        ),
        home: MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World")
      ),
      // accessing the store via the _ViewModel class
      body: StoreConnector <AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (context, _ViewModel viewModel) => Column(
          children: <Widget>[
            Text("${viewModel.count}"),
            AddItemWidget(viewModel),
            Expanded(
              child: ItemListWidget(viewModel)
            ),
            RemoveItemsButton(viewModel)
          ],
        )
      ),
      // accessing the store directly
      floatingActionButton: StoreConnector<AppState, dynamic>(
        converter: (store) => () => store.dispatch(Actions.Increment),
        builder: (context, add) => FloatingActionButton(
          child: Text("Add"),
          onPressed: () => add()
        ),
      )
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;
  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Remove All Items"),
      onPressed: () => model.onRemoveItems(),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;
  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items.map((Item item) => ListTile(
        title: Text("${item.body} ${item.id}"),
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => model.onRemoveItem(item),
        )
      )).toList()
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;
  AddItemWidget(this.model);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: "Add an item"),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        controller.text = '';
      },
    );
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;
  final Function() increment;
  final int count;

  _ViewModel({
    this.count,
    this.increment,
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    _onIncrement() {
      store.dispatch(Actions.Increment);
    }

    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
      count: store.state.count,
      increment: _onIncrement,
    );
  }
}
