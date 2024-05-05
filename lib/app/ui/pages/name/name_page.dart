import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_6/app/ui/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Namepage extends StatelessWidget{
 Namepage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
 TextEditingController FirstController = TextEditingController();
  TextEditingController LastController = TextEditingController();
Future<void> addData(BuildContext context) async {
    var url = Uri.parse("http://192.168.0.174:8080/location");

    var response = await http.post(url, body: jsonEncode( {
      "FirstName": FirstController.text,
      "LastName": LastController.text,
    }));


      final Data = jsonDecode(response.body.toString());
      final id = Data['ID'];
      // Guardar el ID en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.clear();
      await prefs.setInt('id', id);
       Navigator.pushReplacementNamed(context, Routes.HOME);
      // Redirigir al usuario a la página principal

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your name"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: FirstController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Firstname"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Firstname';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: LastController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Lastname"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Lastname';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                       addData(context);
                      
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
