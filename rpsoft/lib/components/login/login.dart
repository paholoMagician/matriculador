import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String urlLog =
      'https://ead5-2800-bf0-814b-1074-d5a8-dfe5-fb0-6eb8.ngrok-free.app';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 101, 71),
      appBar: AppBar(
        elevation: 2,
        title: const Text('LOGIN'),
        backgroundColor: const Color.fromARGB(255, 49, 53, 49),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 54, 54, 54).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 25, right: 25),
        margin: const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 50),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/rpsoft.png',
                  height: 75,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "User email", icon: Icon(Icons.email_outlined)),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: "*******",
                      icon: Icon(Icons.lock_open_outlined)),
                  obscureText: true,
                ),
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(top: 50),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse('$urlLog/api/User/login');
                      final headers = {'Content-Type': 'application/json'};
                      final body = jsonEncode({
                        'email': emailController.text,
                        'password': passwordController.text
                      });
                      ;

                      final response =
                          await http.post(url, headers: headers, body: body);

                      if (response.statusCode == 200) {
                        final jsonResponse = jsonDecode(response.body);
                        Navigator.pushNamed(context, 'dashboard');

                        // hacer algo con la respuesta
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login exitoso'),
                              content: Text(
                                  'Te has logeado con éxito, y el nombre es ${jsonResponse['name']}'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // print('Error: ${response.statusCode}');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error de login'),
                              content: const Text('No se ha podido logear.'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 35, 38, 37)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 72, 232,
                              94)), // Aquí se cambia el color a rojo
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text('Nuevo Usuario?, cree una cuenta')
                // ElevatedButton(onPressed: onPressed, child: child)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
