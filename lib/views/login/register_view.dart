import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/utils/utils.dart';
import 'package:firetrip/global/utils/validators.dart';
import 'package:firetrip/global/styles/styles.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/services/firebase_services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = false;
  bool _obscureConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      Map userInfo = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "address": _addressController.text.trim(),
        "password": _passwordController.text.trim()
      };

      ref.read(firebaseAuthServiceProvider).register(userInfo).then((value) {
        Utils.showGreenSnackBar(context, "Account created successfully");
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
                "Register",
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
                      /// Name text field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: textInputDecorationBorder,
                          labelText: "Name",
                          prefixIcon: const Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

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

                      /// Phone number field
                      ///
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IN',
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // Address field
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          border: textInputDecorationBorder,
                          labelText: "Address",
                          prefixIcon: const Icon(Icons.person),
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

                      /// Confirm Password text field
                      TextFormField(
                        controller: _confirmPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => Validators.isConfirmPasswordValid(
                                _passwordController.text, value)
                            ? null
                            : "Password does not match",
                        decoration: InputDecoration(
                          border: textInputDecorationBorder,
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            child: _obscureConfirmPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),

                        /// Listening to [_obscurePassword] for hidding and showing the password
                        obscureText: _obscureConfirmPassword,
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      /// Signup Button
                      ElevatedButton.icon(
                          style: textButtonStyle,
                          onPressed: () {
                            register();
                          },
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Register",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )),

                      const SizedBox(
                        height: 20.0,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Alread have an account?"),
                          InkWell(
                            child: const Text(" Login",
                                style: TextStyle(color: primaryColor)),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RouteNames.login);
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
