import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  final UserService userService = UserService();

  @override
  State<StatefulWidget> createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableFormField(controller: username, hint: 'Username'),
                ReusableFormField(
                  controller: password,
                  hint: 'Password',
                  isPassword: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      dynamic response;
                      try {
                        response = await widget.userService
                            .login(username.text, password.text);
                        Navigator.popAndPushNamed(context, '/lists');
                      } catch (e) {
                        response = e.toString();
                        showDialog(
                          context: context,
                          builder: (ctxt) =>
                              AlertDialog(content: Text(response)),
                        );
                      }
                    }
                  },
                  child: const Text('Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
