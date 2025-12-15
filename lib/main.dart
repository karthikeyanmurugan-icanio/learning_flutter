import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/store.dart';
import 'services/websocket_service.dart';
import 'redux/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; // keep your existing login screen

void main() {
  // Create single WebSocketService instance and store
  final wsService = WebSocketService(url: 'ws://echo.websocket.org'); // change to your WS URL
  final store = createAppStore(wsService: wsService);

  runApp(MyApp(store: store, wsService: wsService));
}

class MyApp extends StatelessWidget {
  final store;
  final WebSocketService wsService;
  const MyApp({required this.store, required this.wsService, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux WebSocket Demo',
        home: LoginScreen(), // or HomeScreen() if you want to skip login
        routes: {
          '/home': (_) => HomeScreen(),
        },
      ),
    );
  }
}
