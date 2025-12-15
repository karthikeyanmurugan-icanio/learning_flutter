import 'package:flutter/material.dart';
import 'package:todo_list_application/services/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  final LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RxDart Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // -------- Email Field --------
            StreamBuilder<String>(
              stream: bloc.email,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: bloc.changeEmail,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: snapshot.error?.toString(),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // -------- Password Field --------
            StreamBuilder<String>(
              stream: bloc.password,
              builder: (context, snapshot) {
                return TextField(
                  obscureText: true,
                  onChanged: bloc.changePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: snapshot.error?.toString(),
                  ),
                );
              },
            ),

            SizedBox(height: 30),

            // -------- Login Button --------
            StreamBuilder<bool>(
              stream: bloc.isValid,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: (snapshot.hasData)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Successful")),
                          );
                        }
                      : null,
                  child: Text("Login"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
