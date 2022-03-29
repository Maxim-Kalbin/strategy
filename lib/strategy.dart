library strategy;

import 'dart:collection';

/// Can be provided to strategies, contain payload and the duration of a operation to execute
class StgContext {
  /// Use this to create an empty container and set execution timeout to all Strategies
  StgContext.withTimeout(Duration timeout)
      : _timeout = timeout,
        _expires = DateTime.now().add(timeout);

  /// Use this to create an empty container
  StgContext.background() : _timeout = Duration.zero;

  final Duration _timeout;

  final HashMap<String, dynamic> _payload = HashMap<String, dynamic>();

  bool containsKey(String key) => _payload.containsKey(key);

  /// Use it to provide a new dependency to a Strategy through the container
  DateTime? _expires;
  void inject(String key, dynamic data, {bool replace = true}) {
    if (data != null) {
      if (_payload.containsKey(key) && !replace) {
        _payload.putIfAbsent(key, () => data);
      } else {
        _payload[key] = data;
      }
    } else {
      throw Exception(
          '[$runtimeType Error] The injected data ($key) must not be null');
    }
  }

  /// Use it to retrieve a dependency
  T find<T>(String key) {
    if (_payload.containsKey(key)) {
      final result = _payload[key];
      if (result is T) {
        return result;
      } else {
        throw Exception(
            '[$runtimeType Error] Unexpected return, should be: $T, got: ${result.runtimeType}, make sure you use right type');
      }
    } else {
      throw Exception(
          '[$runtimeType Error] Was requested a key ("$key") for a value that has not yet been injected.');
    }
  }

  /// Use it to remove an unused dependency
  void delete(String key) {
    _payload.remove(key);
  }

  /// Will return true if a timeout has been set and the function is expired
  bool get expired =>
      _expires != null ? _expires!.isBefore(DateTime.now()) : false;

  /// After calling the method, the timeout will start counting from the beginning
  void resetExpiration() {
    if (_expires != null) {
      _expires = DateTime.now().add(_timeout);
    }
  }
}

/// Simple interface to implement a strategy
///
/// Example:
/// ```
/// class SelectUser implements Strategy {
///   const SelectUser();
///   Future<StgContext> _(StgContext ctx) async {
///     final user = ctx.find<SelectUserEvent>('event').selected;
///     final prevState = ctx.find<HomeState>('state');
///     final prevSelected = [...prevState.selectedUsers];
///     final newState = UsersSelectedState(
///         users: prevState.users, selectedUsers: prevSelected..add(user));
///
///     return Future.value(ctx..inject('state', newState));
///   }
///
///   @override
///   Future<StgContext> call(StgContext ctx) async {
///     if (!ctx.expired) {
///       return await _(ctx);
///     } else {
///       throw Exception(
///           '[$runtimeType Error] Tried to invoke the strategy after timeout, please handle this case');
///     }
///   }
/// }
/// ```

abstract class Strategy {
  const Strategy();

  Future<StgContext> _(StgContext ctx) async {
    return Future.error(UnimplementedError());
  }

  Future<StgContext> call(StgContext ctx) async {
    if (!ctx.expired) {
      return await _(ctx);
    } else {
      throw Exception(
          '[$runtimeType Error] Tried to invoke the strategy after timeout, please handle this case');
    }
  }
}

/// Use this to add a strategy invocation functionality to a controller
mixin StrategyMixin<EventType> {
  /// Execution context of all Strategies, passed from one to another as it is called
  StgContext context = StgContext.background();

  final SplayTreeMap<int, Type> _history = SplayTreeMap<int, Type>();

  /// The consistent history of the events that was handled, contains their types
  UnmodifiableMapView get history => UnmodifiableMapView(_history);

  /// Compares the passed type with the type of the last event
  bool isNotAfter(Type event) => !isAfter(event);

  /// Compares the passed type with the type of the last event
  bool isAfter(Type event) {
    if (_history.isNotEmpty) {
      return _history[_history.length - 1] == event;
    } else {
      return false;
    }
  }

  /// Dictionary of Strategies, that possibly can handle an occurred event
  final Map<Type, Strategy> strategies = const <Type, Strategy>{};

  /// The method will execute Strategies that agree to handle the event
  Future<StgContext> invoke(EventType event) async {
    final Type eventType = event.runtimeType;
    if (strategies.containsKey(eventType)) {
      final newKey = (_history.lastKey() ?? -1) + 1;
      _history[newKey] = eventType;
      context
        ..inject("event", event)
        ..resetExpiration();

      await strategies[eventType]!(context);
    } else {
      throw Exception(
          '[$runtimeType Error] Event $eventType does not exist, please add it to the strategies list!');
    }
    return context;
  }
}
