import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/widget/input_decoration.dart';
import 'package:flutter_18_firebase/widget/text_button_class.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password Recovery',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: inputDecorationForm(const Text('E-mail'),
                            prefixIcon: const Icon(Icons.mail)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Registration Email';
                          } else if (EmailValidator.validate(value) == false) {
                            return 'Not a valid email';
                          }
                          return null;
                        },
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Enter your Registration Email',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButtonClass(
                      title: 'Send Mail',
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text;
                          await FirebaseHelper.resetPassword(email, context);

                          emailController.clear();
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an Account?',
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: const Text(
                          '  Login',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

Future _showDialog(context) => showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        return AlertDialog(
            title: const Text('Successful!'),
            content: TextButton(
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
              child: const Text('L O G I N'),
            ));
      },
    );
