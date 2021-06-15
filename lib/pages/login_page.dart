import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weight_tracker/pages/home_page.dart';
import 'package:weight_tracker/pages/landing_page.dart';
import 'package:weight_tracker/pages/register_page.dart';
import 'package:weight_tracker/pages/verify_page.dart';
import 'package:weight_tracker/utils/auth.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Auth auth = Auth();

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            TextButton(
              child: const Text("Close Dialog"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    String? _createAccountFeedback =
        await auth.signInWithEmailAndPassword(_loginEmail, _loginPassword);

    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
    }
  }

  @override
  void initState() {
    _passwordFocus = FocusNode();
    _emailFocus = FocusNode();
    super.initState();
  }

  String _loginEmail = "";

  String _loginPassword = '';

  late FocusNode _passwordFocus;

  late FocusNode _emailFocus;

  @override
  void dispose() {
    _passwordFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) {
                      _passwordFocus.requestFocus();
                    },
                    onChanged: (value) {
                      _loginEmail = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      _loginPassword = value;
                    },
                    onFieldSubmitted: (_) {
                      _submitForm();
                    },
                    focusNode: _passwordFocus,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Stack(
                      children: [
                        Visibility(
                          visible: !_isLoading,
                          child: Text(
                            "Login",
                            style:
                                TextStyle(color: Theme.of(context).buttonColor),
                          ),
                        ),
                        Visibility(
                          visible: _isLoading,
                          child: const Center(
                            child: SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  SignInButtonBuilder(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      auth.signInWithGoogle();
                      debugPrint('shfkad');
                    },
                    text: "Sign In With Google",
                    textColor: Colors.white,
                    icon: FontAwesomeIcons.google,
                    iconColor: Colors.white,
                  )
                ],
              ),
              key: _formKey,
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Create New Accounts',
              style: TextStyle(color: Theme.of(context).buttonColor),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          )
        ],
      ),
    );
  }
}
