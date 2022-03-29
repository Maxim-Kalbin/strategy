<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The package aims to improve a code organization and a visual clarity with Strategy Template.

## Features

#### StgContext
Container for dependencies, that must be provided to any Strategy, can contain a payload and can be created with timeout, after expiration of it Strategy will not be executed.
#### Strategy
Function, which will be executed after occurring event, that it can handle
#### StrategyMixin
Provides functionality to handle events with Strategies

## Usage

### 1. Setup controller
Add the mixin to your favorite state controller, specify type of an event which will trigger the state changing

```dart
class ContactsBloc extends Bloc<ContactsEvent, ContactsState>
    with StrategyMixin<ContactsEvent> {
  ContactsBloc() : super(InitialContactsState()) {
    on<ContactsEvent>((event, emit) async {
      final ctx = await invoke(event);
      emit(ctx.find<ContactsState>('state'));
    });
  }
```

Don't forget to include the 'invoke(event);' function, without it, the controller will not be able to understand what to do

### 2. Implement your Strategy, add a business logic to it

```dart
class SelectUser implements Strategy {
  const SelectUser();
  Future<StgContext> _(StgContext ctx) async {
    final user = ctx.find<SelectUserEvent>('event').selected;
    final prevState = ctx.find<ContactsState>('state');
    final prevSelected = [...prevState.selectedUsers];
    final newState = UsersSelectedState(
        users: prevState.users, selectedUsers: prevSelected..add(user));

    return Future.value(ctx..inject('state', newState));
  }

  @override
  Future<StgContext> call(StgContext ctx) async {
    if (!ctx.expired) {
      return await _(ctx);
    } else {
      throw Exception(
          '[$runtimeType Error] Tried to invoke the strategy after timeout, please handle this case');
    }
  }
}
```

### 3. Override 'strategies' property of the mixin

```dart
@override
  final Map<Type, Strategy> strategies = const <Type, Strategy>{
    LoadDataEvent: LoadTasksAndUsers(),
    SelectUserEvent: SelectUser(),
    DeselectUserEvent: DeselectUser(),
  };
```

For full example, go to the repo (`/example` folder).

## Additional information

repo: https://github.com/Maxim-Kalbin/strategy
