import 'package:redux/redux.dart';
import 'app_state.dart';
import 'reducers.dart';
import 'middleware.dart';
import '../services/websocket_service.dart';

Store<AppState> createAppStore({required WebSocketService wsService}) {
  return Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: createAppMiddleware(wsService: wsService),
  );
}
