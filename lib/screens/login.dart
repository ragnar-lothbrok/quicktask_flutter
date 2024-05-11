import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class User {
  String username;
  String email;
  String password;

  String displayName;

  User(
      {required this.username,
      required this.email,
      required this.password,
      required this.displayName});
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _rePasswordController =
      TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _displayNameController =
      TextEditingController(text: '');
  bool login1 = true;

  //login
  Future<bool> login(String username, String password) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(username, password, null);
      final result = await parseUser.login();
      return result.success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //signup
  Future<bool> signup(User user) async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      final parseUser = ParseUser(user.username, user.password, user.email);
      final result = await parseUser.signUp();
      return result.success;
    } catch (e) {
      // Handle error
      print(e);
      return false;
    }
  }

  //show message
  void _showMessage(String message, {bool? error}) {
    const double height = 50;
    const EdgeInsets padding = EdgeInsets.fromLTRB(50, 0, 50, 0);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        padding: padding,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: padding,
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1000,
      behavior: SnackBarBehavior.floating,
    ));
  }

  List<Widget> signupForm() {
    const double height = 60;
    const EdgeInsets padding = EdgeInsets.fromLTRB(50, 0, 50, 0);
    return [
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Username',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _rePasswordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password Again',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Email',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _displayNameController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            labelText: 'Enter Display Name',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            String username = _usernameController.text.trim().toLowerCase();
            String password = _passwordController.text;
            String rePassword = _rePasswordController.text;
            String email = _emailController.text.trim().toLowerCase();
            String displayName = _displayNameController.text.trim();
            if (password != rePassword) {
              _showMessage('Password and Re-password do not match.',
                  error: true);
              return;
            }

            User user = User(
                username: username,
                email: email,
                password: password,
                displayName: displayName);
            signup(user).then((success) {
              if (success) {
                _passwordController.clear();
                _rePasswordController.clear();
                _emailController.clear();
                _displayNameController.clear();
                setState(() {
                  login1 = true;
                });
                _showMessage('Signup successful, please login.');
              } else {
                _showMessage(
                    'Username or email already exists, please try again.',
                    error: true);
              }
            });
          },
          child: const Text('Signup'),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            login1 = true;
          });
        },
        child: const Text('Already user!'),
      ),
    ];
  }

  List<Widget> loginForm() {
    const double height = 100;
    const EdgeInsets padding = EdgeInsets.fromLTRB(80, 0, 80, 0);
    return [
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Enter Username',
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        child: TextFormField(
          obscureText: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Enter Password',
            suffixIcon: Icon(Icons.visibility_off),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(200, 50)),
          ),
          onPressed: () async {
            String username = _usernameController.text.trim().toLowerCase();
            String password = _passwordController.text;
            login(username, password).then((success) {
              if (success) {
                Navigator.of(context).pushReplacementNamed("/");
              } else {
                _showMessage(
                    'Incorrect username or password, please try again.',
                    error: true);
              }
            });
          },
          child: const Text('Login'),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            login1 = false;
          });
        },
        child: const Text('Signup?'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            ...login1 ? loginForm() : signupForm(),
          ],
        ),
      ),
    );
  }
}
