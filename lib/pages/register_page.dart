import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/pages/verify_page.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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

  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    String? _createAccountFeedback = await _createAccount();

    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const VerifyPage()));
    }
  }

  @override
  void initState() {
    _passwordFocus = FocusNode();
    _emailFocus = FocusNode();
    super.initState();
  }

  String _registerEmail = "";

  String _registerPassword = '';

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
        title: const Text("Register Page"),
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
                      _registerEmail = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      _registerPassword = value;
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
                            "Register",
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
                ],
              ),
              key: _formKey,
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Already Have an Account?',
              style: TextStyle(color: Theme.of(context).buttonColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
