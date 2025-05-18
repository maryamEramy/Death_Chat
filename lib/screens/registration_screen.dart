import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var auth = FirebaseAuth.instance;
  String errorMessage = '';
  bool errorOccurred = false, showSpinner = false;

  bool obscureText = true;
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 200, child: Image.asset('images/logo.png')),
              SizedBox(height: 48.0),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) {
                        return email != null && EmailValidator.validate(email)
                            ? null
                            : 'Please enter a valid email';
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        labelText: 'password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            togglePasswordVisibility();
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      controller: _passwordController,
                      //pass security
                      obscureText: obscureText,
                      //pas validation
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        return password != null && password.length > 5
                            ? null
                            : 'The password should be at of 6 character at least.';
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Visibility(
                visible: errorOccurred,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
              SizedBox(height: 24.0),
              RoundedButton(
                title: 'Register',
                color: Colors.orangeAccent[200]!,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        errorOccurred = false;
                        showSpinner = true;
                      });
                      await auth
                          .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          )
                          .then((Value) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, ChatScreen.id);
                          });
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                        errorOccurred = true;
                        errorMessage = e.toString().split('] ')[1];
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
