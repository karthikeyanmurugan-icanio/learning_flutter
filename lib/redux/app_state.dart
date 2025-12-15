import '../models/user.dart';

class AppState {
  final User? user;
  final List<String> wsMessages;

  AppState({this.user, required this.wsMessages});

  factory AppState.initial() => AppState(user: null, wsMessages: []);

  AppState copyWith({User? user, List<String>? wsMessages}) {
    return AppState(
      user: user ?? this.user,
      wsMessages: wsMessages ?? List.from(this.wsMessages),
    );
  }

  @override
  String toString() => 'AppState(user: $user, wsMessages: $wsMessages)';
}
