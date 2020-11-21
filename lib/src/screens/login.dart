import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/src/screens/home.dart';
import 'package:firebase_sample/src/screens/verify.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Sign in"),
                  onPressed: () async {
                    try {
                      var singInResponse =
                          await auth.signInWithEmailAndPassword(
                              email: _email, password: _password);
                      if (singInResponse.user != null) {
                        if (singInResponse.user.emailVerified) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Bilgi"),
                                    content: Text(
                                        "Mail adresinizi lütfen doğrulayın"),
                                  ));
                        }
                      }
                    } catch (e) {
                      if (e.code == "user-not-found") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Bilgi"),
                                  content: Text("Kullanıcı bulunamadı"),
                                ));
                      } else if (e.code == "wrong-password") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Bilgi"),
                                  content: Text("Şifre hatalı"),
                                ));
                      } else if (e.code == "invalid-email") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Bilgi"),
                                  content: Text("Email giriniz"),
                                ));
                      }
                    }
                  }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Sign up"),
                  onPressed: () {
                    auth
                        .createUserWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((value) => () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => VerifyScreen()));
                            });
                  })
            ],
          ),
        ],
      ),
    );
  }
}
