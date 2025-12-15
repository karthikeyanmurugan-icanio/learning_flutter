import '../models/user.dart';

// User loading
class LoadUserAction {}
class SetUserAction {
  final User user;
  SetUserAction(this.user);
}

// WebSocket related
class InitWsAction {} // optional explicit init
class SendWsMessageAction {
  final String message;
  SendWsMessageAction(this.message);
}
class AddWsMessageAction {
  final String message;
  AddWsMessageAction(this.message);
}
class ClearWsMessagesAction {}
