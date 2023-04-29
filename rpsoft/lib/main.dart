import 'package:flutter/material.dart';
import 'package:rpsoft/components/dashboard/dashboard.dart';

import 'components/login/login.dart';
import 'components/usuarios_registrados/usuarios_registrados.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Estudiante App',
        // home: Login(),
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => const Login(),
          'Estudiantes': (BuildContext context) => const UsuariosRegistrados(),
          'dashboard': (BuildContext context) => const Dashboard()
        });
  }
}
