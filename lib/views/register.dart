import 'package:flutter/material.dart';
import 'package:listeverywhere_app/models/user_model.dart';
import 'package:listeverywhere_app/services/user_service.dart';
import 'package:listeverywhere_app/widgets/reusable_field.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

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
    TextEditingController firstName = TextEditingController();
    TextEditingController lastName = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController dateOfBirth = TextEditingController();
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableFormField(controller: firstName, hint: "First Name"),
                  ReusableFormField(controller: lastName, hint: "Last Name"),
                  ReusableFormField(controller: email, hint: "Email Address"),
                  ReusableFormDateField(
                      controller: dateOfBirth, hint: "Date of birth"),
                  ReusableFormField(controller: username, hint: "Username"),
                  ReusableFormField(
                    controller: password,
                    hint: "Password",
                    isPassword: true,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
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
                          var response =
                              await widget.userService.sendRegisterData(user);
                          print("success");
                          showDialog(
                              context: context,
                              builder: (ctxt) => AlertDialog(
                                  content: Text(response.toString())));
                          AlertDialog(
                            content: Text(response.toString()),
                          );
                        } on Exception catch (e) {
                          print("error");
                          showDialog(
                              context: context,
                              builder: (ctxt) => AlertDialog(
                                    content: Text(e.toString()),
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
    );
  }
}
