import 'dart:convert';
import 'dart:developer';
import 'package:akyam/models/user.dart';
import 'package:akyam/services/database.dart';
import 'package:akyam/models/server_response.dart';
import 'package:akyam/services/validator.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'homepage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPage createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  bool agreed = false;
  bool pressed = false;
  bool isLogin = false;

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController usernameTEC = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: const AssetImage('assets/cat_bg.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.srcOver))),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFF343A40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 64.0),
                    child: isLogin ? getLogin() : getRegister(),
                  )),
            ],
          ),
          Positioned(
              right: 1,
              top: 1,
              child:
                  SizedBox(height: 40, width: 40, child: CloseWindowButton())),
        ],
      ),
    );
  }

  handleLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        pressed = true;
      });
      try {
        await Auth.login(emailTEC.text, passwordTEC.text)
            .then((ServerResponse sr) async {
          if (sr.type == ServerResponseType.serverResponseSuccess) {
            await windowManager.hide().then((value) async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => Homepage(user: sr.data as User))));
              await windowManager.setResizable(true);
              await windowManager.setSize(const Size(1280, 720));
              await windowManager.center();
              await windowManager.show();
            });
            // await windowManager.setSize(const Size(400, 600));
            // await windowManager.center();
            // await windowManager.show();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text((jsonDecode(sr.data.toString()) as Map)["msg"])));
          }
        });
      } catch (_, e) {
        log(e.toString());
        setState(() {
          pressed = false;
        });
      }
    }
    setState(() {
      pressed = false;
    });
  }

  getLogin() {
    return Form(
      key: formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Join over thousands of people from around the world!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32.0),
            TextFormField(
              controller: emailTEC,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              validator: (val) => Validators.email(val),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white)),
                  hintText: "Email",
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
            const SizedBox(height: 32.0),
            TextFormField(
              controller: passwordTEC,
              obscureText: true,
              validator: (val) => Validators.password(val),
              onFieldSubmitted: (val) => handleLogin(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white)),
                  hintText: "Password",
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
            const SizedBox(height: 32.0),
            MaterialButton(
              height: 80,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21)),
              minWidth: double.infinity,
              color: const Color(0xFF6930C3),
              onPressed: pressed ? null : () => handleLogin(),
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isLogin = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  "Already have an account? Login here.",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]),
    );
  }

  getRegister() {
    return Form(
      key: formKey,
      child: ListView(children: [
        const Text(
          "Join over thousands of people from around the world!",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32.0),
        TextFormField(
          controller: usernameTEC,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          validator: (val) => Validators.username(val),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white)),
              hintText: "Username",
              focusColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
        ),
        const SizedBox(height: 32.0),
        TextFormField(
          controller: emailTEC,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          validator: (val) => Validators.email(val),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white)),
              hintText: "Email",
              focusColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
        ),
        const SizedBox(
          height: 32.0,
        ),
        TextFormField(
          controller: passwordTEC,
          obscureText: true,
          validator: (val) => Validators.password(val),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white)),
              hintText: "Password",
              focusColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
        ),
        const SizedBox(height: 32.0),
        Row(
          children: [
            Checkbox(
                value: agreed,
                onChanged: (val) {
                  setState(() {
                    agreed = val!;
                  });
                }),
            InkWell(
              onTap: () {
                setState(() {
                  agreed = !agreed;
                });
              },
              child: const Text(
                "I agree to all the statements in Terms of use.",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        MaterialButton(
          height: 80,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          minWidth: double.infinity,
          color: const Color(0xFF6930C3),
          disabledColor: const Color(0xFF6930C3).withOpacity(0.4),
          onPressed: pressed || !agreed
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      pressed = true;
                    });
                    try {
                      await Auth.register(
                              username: usernameTEC.text,
                              email: emailTEC.text,
                              password: passwordTEC.text)
                          .then((ServerResponse sr) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text((jsonDecode(sr.data.toString())
                                as Map)["msg"])));
                      });
                    } catch (_, e) {
                      log(e.toString());
                      setState(() {
                        pressed = false;
                      });
                    }
                  }
                  setState(() {
                    pressed = false;
                  });
                },
          child: const Text(
            "Register",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isLogin = true;
            });
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Already have an account? Login here.",
              textAlign: TextAlign.center,
            ),
          ),
        )
      ]),
    );
  }
}
