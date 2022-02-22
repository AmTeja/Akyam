import 'dart:developer';

import 'package:akyam/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class LoadingScreen extends StatefulWidget {
  final User user;

  const LoadingScreen({Key? key, required this.user}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final storage = const FlutterSecureStorage();
  String authToken = "";
  @override
  void initState() {
    completeBGprocesses();
    super.initState();
  }

  completeBGprocesses() async {
    authToken = (await storage.read(key: "authToken"))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {}),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: const Color(0xFF343A40),
              child: const Text(
                "Akyam",
                style: TextStyle(fontSize: 32.0, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.center,
              color: const Color(0xFF343A40),
              child: const CircularProgressIndicator(
                color: Color(0xFF6930C3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
