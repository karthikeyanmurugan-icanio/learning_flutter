import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:redux/redux.dart';
import '../models/user.dart';
import 'app_state.dart';
import 'actions.dart';
import '../services/websocket_service.dart';

List<Middleware<AppState>> createAppMiddleware({required WebSocketService wsService}) {
  bool wsInitialized = false;

  // load user from assets when LoadUserAction dispatched
  Middleware<AppState> loadUser = (Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is LoadUserAction) {
      try {
        final jsonString = await rootBundle.loadString('assets/data/user.json');
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final user = User.fromJson(jsonMap);
        store.dispatch(SetUserAction(user));
      } catch (e) {
        store.dispatch(AddWsMessageAction('Error loading user.json: $e'));
      }
    }
  };

  // send message to ws when SendWsMessageAction dispatched
  Middleware<AppState> sendWs = (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);
    if (action is SendWsMessageAction) {
      wsService.send(action.message);
      store.dispatch(AddWsMessageAction('You: ${action.message}'));
    }
  };

  // initialize WS listener once
  Middleware<AppState> initWs = (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);
    if (!wsInitialized) {
      wsInitialized = true;
      wsService.stream.listen((msg) {
        store.dispatch(AddWsMessageAction('Server: $msg'));
      }, onError: (err) {
        store.dispatch(AddWsMessageAction('WebSocket error: $err'));
      }, onDone: () {
        store.dispatch(AddWsMessageAction('WebSocket closed'));
      });
    }
  };

  return [TypedMiddleware<AppState, LoadUserAction>(loadUser), TypedMiddleware<AppState, SendWsMessageAction>(sendWs), TypedMiddleware<AppState, dynamic>(initWs)];
}
