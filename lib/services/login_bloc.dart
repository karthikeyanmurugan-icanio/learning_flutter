import 'dart:async';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  // Controllers
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Input
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Validators
  Stream<String> get email =>
      _emailController.stream.transform(_emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(_passwordValidator);

  // Combine latest → enable login when both valid
  Stream<bool> get isValid => Rx.combineLatest2(email, password, (e, p) => true);

  // Validation Logic
  final _emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Enter a valid Email");
    }
  });

  final _passwordValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length >= 6) {
      sink.add(pass);
    } else {
      sink.addError("Password must be 6+ chars");
    }
  });

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
