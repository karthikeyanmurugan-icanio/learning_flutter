import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/app_state.dart';
import '../redux/actions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController wsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dispatch load user after first frame so store is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(LoadUserAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
      converter: (store) => _VM(
        user: store.state.user,
        wsMessages: store.state.wsMessages,
        sendMessage: (msg) => store.dispatch(SendWsMessageAction(msg)),
        clearMessages: () => store.dispatch(ClearWsMessagesAction()),
      ),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text('JSON + WebSocket Demo'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello KK!', style: TextStyle(fontSize: 22)),
                SizedBox(height: 20),
                Text('➡ JSON → Dart Object', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                vm.user == null
                    ? Text('Loading...')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${vm.user!.name}', style: TextStyle(fontSize: 16)),
                          Text('Age: ${vm.user!.age}', style: TextStyle(fontSize: 16)),
                          Text('Email: ${vm.user!.email}', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                SizedBox(height: 20),
                Text('📡 WebSocket Messages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: ListView.builder(
                    itemCount: vm.wsMessages.length,
                    itemBuilder: (ctx, i) => Text(vm.wsMessages[i]),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: wsController,
                        decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter message'),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final text = wsController.text.trim();
                        if (text.isNotEmpty) {
                          vm.sendMessage(text);
                          wsController.clear();
                        }
                      },
                      child: Text('Send'),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextButton(onPressed: vm.clearMessages, child: Text('Clear messages')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VM {
  final user;
  final List<String> wsMessages;
  final void Function(String) sendMessage;
  final VoidCallback clearMessages;

  _VM({this.user, required this.wsMessages, required this.sendMessage, required this.clearMessages});
}
