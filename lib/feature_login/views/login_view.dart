import 'package:firetrip/common/auth/auth.dart';
import 'package:firetrip/common/constants/colors.dart';
import 'package:firetrip/feature_login/services/firebase_auth_service.dart';
import 'package:firetrip/common/utils/utils.dart';
import 'package:firetrip/feature_login/utils/validators.dart';
import 'package:firetrip/feature_login/views/styles.dart';
import 'package:firetrip/common/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      Map userInfo = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim()
      };

      ref.read(firebaseAuthServiceProvider).login(userInfo).then((value) {
        Utils.showGreenSnackBar(context, "You are successfully logged in");
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }).catchError((error) {
        Utils.showRedSnackBar(context, "Some error occured: $error");
      });
    } else {
      Utils.showRedSnackBar(context, "Please enter the required data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Image.asset("assets/images/register_login.jpg"),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10, 20.0),
          child: Column(
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Email text field
                      TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => Validators.isEmailFormatValid(
                                value)
                            ? null
                            : "Please enter valid email: Example@domain.com",
                        decoration: InputDecoration(
                          border: textInputDecorationBorder,
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      /// Password text field
                      TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => Validators.isPasswordValid(value)
                            ? null
                            : "Password shoud contain more than 6 characters",
                        decoration: InputDecoration(
                          border: textInputDecorationBorder,
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: _obscurePassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),

                        /// Listening to [_obscurePassword] for hidding and showing the password
                        obscureText: _obscurePassword,
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      /// Signup Button
                      ElevatedButton.icon(
                          style: textButtonStyle,
                          onPressed: () {
                            login();
                          },
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )),

                      const SizedBox(
                        height: 20.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Do not have an account?"),
                          InkWell(
                            child: const Text(" Register",
                                style: TextStyle(color: primaryColor)),
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.register);
                            },
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
