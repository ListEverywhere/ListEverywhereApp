import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

/// The registration page of the application
class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  /// Instance of [UserService]
  final UserService userService = UserService();

  @override
  State<StatefulWidget> createState() {
    return RegisterViewState();
  }
}

class RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// Stores first name text
    TextEditingController firstName = TextEditingController();

    /// Stores last name text
    TextEditingController lastName = TextEditingController();

    /// Stores email text
    TextEditingController email = TextEditingController();

    /// Stores date of birth
    TextEditingController dateOfBirth = TextEditingController();

    /// Stores username text
    TextEditingController username = TextEditingController();

    /// Stores password text
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up for ListEverywhere"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReusableFormField(
                      controller: firstName,
                      hint: "First Name",
                      minLength: 5,
                      maxLength: 25,
                    ),
                    ReusableFormField(
                      controller: lastName,
                      hint: "Last Name",
                      minLength: 5,
                      maxLength: 25,
                    ),
                    ReusableFormField(
                      controller: email,
                      hint: "Email Address",
                      minLength: 4,
                      maxLength: 50,
                    ),
                    ReusableFormDateField(
                      controller: dateOfBirth,
                      hint: "Date of birth",
                    ),
                    ReusableFormField(
                      controller: username,
                      hint: "Username",
                      minLength: 5,
                      maxLength: 20,
                    ),
                    ReusableFormField(
                      controller: password,
                      hint: "Password",
                      isPassword: true,
                      minLength: 8,
                      maxLength: 32,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // check if form fields are valid
                        if (_formKey.currentState!.validate()) {
                          // save form fields
                          _formKey.currentState?.save();
                          // create user object
                          UserModel user = UserModel(
                              firstName: firstName.text,
                              lastName: lastName.text,
                              email: email.text,
                              dateOfBirth: DateTime.parse(dateOfBirth.text),
                              username: username.text,
                              password: password.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing...')),
                          );
                          try {
                            // use users service to send register form data
                            var response =
                                await widget.userService.sendRegisterData(user);
                            print("success");

                            // only show dialog if the widget is rendered
                            if (!context.mounted) return;

                            // display register success dialog
                            // and provide link to login
                            showDialog(
                                context: context,
                                builder: (ctxt) => AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator
                                                .pushNamedAndRemoveUntil(
                                                    context,
                                                    '/login',
                                                    ModalRoute.withName(
                                                        '/welcome')),
                                            child: const Text('Go to Login'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    '/welcome')),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                        content: const Text(
                                            'Successfully registered account!')));
                          } on Exception catch (e) {
                            // failed to register
                            print(e);
                            showDialog(
                                context: context,
                                builder: (ctxt) => const AlertDialog(
                                      content: Text(
                                          "There was an error registering the account."),
                                    ));
                          }
                        }
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
