import 'app_state.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetUserAction) {
    return state.copyWith(user: action.user);
  }

  if (action is AddWsMessageAction) {
    final newList = List<String>.from(state.wsMessages)..add(action.message);
    return state.copyWith(wsMessages: newList);
  }

  if (action is ClearWsMessagesAction) {
    return state.copyWith(wsMessages: []);
  }

  // default
  return state;
}
