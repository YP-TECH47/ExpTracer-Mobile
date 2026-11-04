import 'package:expense_tracker_app/expenses.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var copyWith = ThemeData().copyWith(
    // ignore: deprecated_member_use
    useMaterial3: true,
    // cardColor: Color.fromARGB(225, 228, 245, 0),
    // cardTheme: const CardTheme(
    //   color: Color.fromARGB(255, 217, 22, 201)
    // )
  );
  runApp(
    MaterialApp(
      // ignore: deprecated_member_use
      theme: copyWith,
      debugShowCheckedModeBanner: true,

      home: const Expenses(),
    ),
  );
}
