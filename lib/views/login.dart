import 'package:flutter/material.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

/// The login page of the application
class LoginView extends StatefulWidget {
  LoginView({super.key});

  /// Instance of [UserService]
  final UserService userService = UserService();

  @override
  State<StatefulWidget> createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  /// Stores the username field text
  TextEditingController username = TextEditingController();

  /// Stores the password field text
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in to ListEverywhere"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableFormField(
                  controller: username,
                  hint: 'Username',
                  minLength: 5,
                  maxLength: 20,
                ),
                ReusableFormField(
                  controller: password,
                  hint: 'Password',
                  isPassword: true,
                  minLength: 8,
                  maxLength: 32,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // check if form fields are valid
                    if (_formKey.currentState!.validate()) {
                      // save the form fields
                      _formKey.currentState?.save();
                      dynamic response;
                      try {
                        // use user service to login using form credentials
                        response = await widget.userService
                            .login(username.text, password.text)
                            .then((value) {
                          Navigator.popAndPushNamed(context, '/lists');
                        });
                      } catch (e) {
                        // an error has occurred
                        response = e.toString();
                        // display dialog with error
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
