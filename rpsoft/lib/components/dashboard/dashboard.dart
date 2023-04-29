import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class Module {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String codec;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.codec,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      name: json['nombre'],
      description: json['descripcion'],
      icon: _getIconData(json['icon']),
      color: _getColor(json['color']),
      codec: json['codec'],
    );
  }

  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      default:
        return Icons.help;
    }
  }

  static Color _getColor(String colorCode) {
    final colorValues =
        colorCode.substring(5, colorCode.length - 1).split(', ');
    final red = int.parse(colorValues[0]);
    final green = int.parse(colorValues[1]);
    final blue = int.parse(colorValues[2]);
    final alpha = double.parse(colorValues[3]);
    return Color.fromRGBO(red, green, blue, alpha);
  }
}

class _DashboardState extends State<Dashboard> {
  late final Future<List<Module>> _fetchData = _getData();
  final String url =
      'https://ead5-2800-bf0-814b-1074-d5a8-dfe5-fb0-6eb8.ngrok-free.app';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulos'),
        // leading: const Icon(Icons.dashboard),
        backgroundColor: Color.fromARGB(255, 45, 58, 48),
        foregroundColor: Color.fromARGB(255, 27, 240, 15),
      ),
      body: FutureBuilder<List<Module>>(
        future: _fetchData,
        builder: (BuildContext context, AsyncSnapshot<List<Module>> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final module = data[index];
                return Card(
                  color: module.color,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(module.icon),
                        title: Text(module.name),
                        subtitle: Text(module.description),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            print(module.name);
                            Navigator.pushNamed(context, module.name);
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Module>> _getData() async {
    final response =
        await http.get(Uri.parse('$url/api/mobileModule/ObtenerModuleMobile'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List;
      return jsonData.map((item) => Module.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
