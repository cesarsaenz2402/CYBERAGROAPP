import 'package:flutter/material.dart';
import '../viewmodel/login_viewmodel.dart';


class LoginView extends StatelessWidget {
  final LoginViewModel viewModel;

  LoginView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: viewModel.setUsername,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: viewModel.setPassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await viewModel.login(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
