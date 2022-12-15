import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_18_firebase/forgot_password.dart';
import 'package:flutter_18_firebase/profile_screen.dart';
import 'package:flutter_18_firebase/profile_screen_storage.dart';
import 'package:flutter_18_firebase/sign_up_screen.dart';
import 'package:flutter_18_firebase/widget/input_decoration.dart';
import 'package:flutter_18_firebase/widget/text_button_class.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

import 'firebase_helper.dart';

// class LoginScreen extends StatelessWidget {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   LoginScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(hintText: 'email'),
//             textInputAction: TextInputAction.next,
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: const InputDecoration(hintText: 'password'),
//             obscureText: true,
//             textInputAction: TextInputAction.done,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               showDialog(
//                   context: context,
//                   builder: (context) => Center(
//                         child: CircularProgressIndicator.adaptive(),
//                       ));
//               final email = _emailController.text;
//               final password = _passwordController.text;
//               final success = await FirebaseHelper.login(email, password);
//               if (success) {
//                 Navigator.pushReplacementNamed(context, '/profile');
//               } else {
//                 // ScaffoldMessenger.of(context).showSnackBar(
//                 //   const SnackBar(
//                 //     backgroundColor: Colors.red,
//                 //     content: Text('Wrong email or password'),
//                 //   ),
//                 // );
//               }
//             },
//             child: const Text('Login'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/sign_up');
//             },
//             child: const Text('Firstly here? Sign up!'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final email = _emailController.text;
//               await FirebaseHelper.resetPassword(email);
//             },
//             child: const Text('Recover password'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String e_mail = '';
  String password = '';

  bool _obscureText = true;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextHello(),
                _buildSpacer(50),
                _buildLoginForm(),
                _buildSpacer(1),
                _buildRememberMeCheckBox(),
                _buildSpacer(50),
                _buildTextButton(),
                _buildSpacer(25),
                _buildTextRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextHello() {
    return Column(
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hello',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Sign in to your account',
            style: TextStyle(fontSize: 20, color: Colors.black45),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: inputDecorationForm(const Text('E-mail'),
              prefixIcon: const Icon(Icons.mail)),
          onChanged: (value) {
            e_mail = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your E-mail';
            } else if (EmailValidator.validate(value) == false) {
              return 'Not a valid email';
            }
            return null;
          },
        ),
        _buildSpacer(15),
        TextFormField(
          controller: passwordController,
          obscureText: _obscureText,
          decoration: inputDecorationForm(
            const Text('Password'),
            prefixIcon: const Icon(Icons.vpn_key),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          onChanged: (value) {
            password = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter your password';
            return null;
          },
        ),
        _buildSpacer(15),
      ],
    );
  }

  Widget _buildRememberMeCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Remember password'),
        Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
            }),
        const SizedBox(width: 40),
        GestureDetector(
          onTap: () {
            Get.offAll(() => ForgotPassword());
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget _buildTextButton() {
    return TextButtonClass(
      title: 'Login',
      function: () async {
        if (_formKey.currentState!.validate()) {
          // showDialog(
          //     context: context,
          //     builder: (context) =>
          //         const Center(child: CircularProgressIndicator.adaptive()));

          final email = emailController.text;
          final password = passwordController.text;
          final success = await FirebaseHelper.login(email, password);

          if (success) {
            Get.offAll(() => const ProfileScreen());

            FocusScope.of(context).requestFocus(FocusNode());
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     backgroundColor: Colors.green,
            //     content: Text('Login Successful'),
            //   ),
            // );
          }
        }
      },
    );
  }

  Widget _buildTextRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Do not have an Account?',
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Get.offAll(() => const SignUpScreen());
          },
          child: const Text(
            '  Register Here',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }
}

Widget _buildSpacer(double space) {
  return SizedBox(
    height: space,
  );
}
