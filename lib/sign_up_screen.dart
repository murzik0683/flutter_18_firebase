import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/firebase_helper.dart';
import 'package:flutter_18_firebase/login_screen.dart';
import 'package:flutter_18_firebase/profile_screen.dart';
import 'package:flutter_18_firebase/widget/input_decoration.dart';
import 'package:flutter_18_firebase/widget/text_button_class.dart';
import 'package:get/get.dart';

// class SignUpScreen extends StatelessWidget {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _passwordAgainController = TextEditingController();

//   SignUpScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(hintText: 'Email'),
//             textInputAction: TextInputAction.next,
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: const InputDecoration(hintText: 'Password'),
//             obscureText: true,
//             textInputAction: TextInputAction.done,
//           ),
//           TextField(
//             controller: _passwordAgainController,
//             decoration: const InputDecoration(hintText: 'Password again'),
//             obscureText: true,
//             textInputAction: TextInputAction.done,
//           ),
// ElevatedButton(
//   onPressed: () async {
//     final email = _emailController.text;
//     final password = _passwordController.text;
//     final passwordAgain = _passwordAgainController.text;
//     if (password == passwordAgain) {
//       final success = await FirebaseHelper.signUp(email, password);
//       if (success) {
//         Navigator.pop(context);
//       } else {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(
//         //     backgroundColor: Colors.red,
//         //     content: Text('Something went wrong'),
//         //   ),
//         // );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Passwords are not the same'),
//         ),
//       );
//     }
//   },
//   child: const Text('Sign Up'),
// ),
//         ],
//       ),
//     );
//   }
// }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKeyKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String eMail = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKeyKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              _buildSpacer(20),
              _buildAvatar(),
              _buildSpacer(10),
              _buildTextFiledName(),
              // _buildSpacer(10),
              // _buildTextFiledNumber(),
              _buildSpacer(10),
              _buildTextFiledEmail(),
              _buildSpacer(10),
              _buildTextFiledPassword(),
              _buildTextButton(),
              _buildSpacer(20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return const Center(
      child: CircleAvatar(
        radius: 55,
        child: Icon(
          Icons.person_outline,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildTextFiledName() {
    return TextFormField(
      controller: nameController,
      decoration: inputDecorationForm(
        const Text('Your name'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your name';
        return null;
      },
      onChanged: (value) {
        username = value;
      },
    );
  }

  Widget _buildTextFiledNumber() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: numberController,
      decoration: inputDecorationForm(
        const Text('Your phone'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your phone';
        return null;
      },
      onChanged: (value) {
        username = value;
      },
    );
  }

  Widget _buildTextFiledEmail() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecorationForm(
        const Text('E-mail'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your E-mail';
        if (EmailValidator.validate(value) == false) {
          return 'Enter a valid E-mail';
        }
        return null;
      },
      onChanged: (value) {
        eMail = value;
      },
    );
  }

  Widget _buildTextFiledPassword() {
    final passwordFieldKey = GlobalKey<FormFieldState<String>>();
    return Column(
      children: [
        TextFormField(
          controller: passwordController,
          obscureText: true,
          key: passwordFieldKey,
          decoration: inputDecorationForm(
            const Text('Password'),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Enter your password';
            if (value.length < 2) return 'The password is too short';
            return null;
          },
          onChanged: (value) {
            password = value;
          },
        ),
        _buildSpacer(10),
        TextFormField(
          obscureText: true,
          decoration: inputDecorationForm(
            const Text('Repeat password'),
          ),
          validator: (value) {
            if (value != passwordFieldKey.currentState!.value) {
              return 'Password does not match';
            }
            return null;
          },
        ),
        _buildSpacer(20),
      ],
    );
  }

  Widget _buildTextButton() {
    return TextButtonClass(
        title: 'Register',
        function: () async {
          if (_formKeyKey.currentState!.validate()) {
            final email = emailController.text;
            final password = passwordController.text;
            final name = nameController.text;
            final number = numberController.text.toString().trim();

            final success =
                await FirebaseHelper.signUp(email, password, name, number);
            if (success) {
              Get.offAll(() => const LoginScreen());
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     backgroundColor: Colors.red,
              //     content: Text('Something went wrong'),
              //   ),
              // );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Passwords are not the same'),
              ),
            );
            FocusScope.of(context).requestFocus(FocusNode());
          }
        });
  }
}

Widget _buildSpacer(double space) {
  return SizedBox(
    height: space,
  );
}
