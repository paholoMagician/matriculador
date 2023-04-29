import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuariosRegistrados extends StatefulWidget {
  const UsuariosRegistrados({Key? key}) : super(key: key);

  @override
  State<UsuariosRegistrados> createState() => _UsuariosRegistradosState();
}

class _UsuariosRegistradosState extends State<UsuariosRegistrados> {
  List<dynamic> usuarios = [];
  final String url =
      'https://ead5-2800-bf0-814b-1074-d5a8-dfe5-fb0-6eb8.ngrok-free.app';
  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
    //--------------------------
    obtenerOpciones('CPAD');
    obtenerOpciones('PRV00');
    // obtenerOpciones('R02');
    obtenerOpciones('C04');
    //--------------------------
  }

  Future<void> obtenerUsuarios() async {
    final response = await http.get(
        Uri.parse('$url/api/AlumnoVinculacion/ObtenerAlumnos/UG-2023-Vinc'));
    if (response.statusCode == 200) {
      setState(() {
        usuarios = json.decode(response.body);
      });
    } else {
      throw Exception('Fallo al obtener los usuarios');
    }
  }

  List<dynamic> opciones = [];
  List<dynamic> provincias = [];
  List<dynamic> cantones = [];
  List<dynamic> estadoCivil = [];
  List<dynamic> sexo = [];

  Future<void> obtenerOpciones(String opt) async {
    var response =
        await http.get(Uri.parse('$url/api/Master/GetDataMaster/$opt'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        switch (opt) {
          case 'CPAD':
            //capacidades
            opciones = data;
            break;
          case 'PRV00':
            provincias = data;
            break;
          // case 'R02':
          //   estadoCivil = data;
          //   break;
          case 'C04':
            sexo = data;
            break;
        }
      });
    } else {
      throw Exception('Error al obtener las opciones de la API');
    }
  }

  Future<void> obtenerCantones(String codProvincias, estudiante) async {
    var response = await http
        .get(Uri.parse('$url/api/Master/GetDataMaster/$codProvincias'));
    if (response.statusCode == 200) {
      setState(
        () {
          var data = jsonDecode(response.body);
          cantones = data;
          provinciasWidget(cantonesw: cantones, estudiantew: estudiante);
          print(cantones);
        },
      );
    } else {
      throw Exception('Fallo al obtener los cantones');
    }
  }

  late final int cantidadAlumnos = usuarios.length;

  final nombreController = TextEditingController();
  final codigoController = TextEditingController();
  final correoController = TextEditingController();
  final cedulaController = TextEditingController();
  final edadController = TextEditingController();
  var provincia = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios registrados'),
        backgroundColor: const Color.fromARGB(246, 52, 55, 50),
        foregroundColor: const Color.fromARGB(255, 26, 244, 11),
      ),
      body: usuarios.isNotEmpty
          ? ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(usuarios[index]['alumnoNombre']),
                      // ignore: prefer_interpolation_to_compose_strings
                      subtitle: Text(
                          '${'Cédula:' + usuarios[index]['cedula']} Email:' +
                              usuarios[index]['correoInstitucional']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            // Acción para editar
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // Encuentra el estudiante seleccionado en la lista
                                final estudiante = usuarios[index];

                                // Establece los valores iniciales de los campos de texto
                                nombreController.text =
                                    estudiante['alumnoNombre'];
                                codigoController.text = estudiante['codAlumno'];
                                correoController.text =
                                    estudiante['correoInstitucional'];
                                edadController.text =
                                    estudiante['edad'].toString();
                                cedulaController.text = estudiante['cedula'];

                                return AlertDialog(
                                  title: const Text('Editar usuario'),
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: codigoController,
                                            decoration: const InputDecoration(
                                              labelText: 'Código de alumno',
                                            ),
                                          ),
                                          TextField(
                                            controller: nombreController,
                                            decoration: const InputDecoration(
                                              labelText: 'Nombre',
                                            ),
                                          ),
                                          TextField(
                                            controller: cedulaController,
                                            decoration: const InputDecoration(
                                              labelText: 'Cédula',
                                            ),
                                          ),
                                          TextField(
                                            controller: edadController,
                                            decoration: const InputDecoration(
                                              labelText: 'Edad',
                                            ),
                                          ),
                                          TextField(
                                            controller: correoController,
                                            decoration: const InputDecoration(
                                              labelText: 'Correo electrónico',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Capacidad del estudiante',
                                              border: OutlineInputBorder(),
                                            ),
                                            isDense: true,
                                            value: opciones.firstWhere(
                                                (opcion) =>
                                                    estudiante[
                                                        'codCapacidades'] ==
                                                    opcion['codigo'],
                                                orElse: () => null),
                                            onChanged: (value) async {
                                              // Acciones para la opción seleccionada
                                            },
                                            items: opciones
                                                .map<DropdownMenuItem<dynamic>>(
                                                  (opcion) => DropdownMenuItem(
                                                    value: opcion,
                                                    child: SizedBox(
                                                      width:
                                                          200, // ajusta el ancho del contenedor del dropdown
                                                      child: Text(
                                                        opcion['nombre'],
                                                        overflow: TextOverflow
                                                            .ellipsis, // agrega puntos suspensivos
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Sexo',
                                              border: OutlineInputBorder(),
                                            ),
                                            isDense: true,
                                            value: sexo.firstWhere(
                                                (sx) =>
                                                    estudiante['codSexo'] ==
                                                    sx['codigo'],
                                                orElse: () => null),
                                            onChanged: (value) {
                                              // Acciones para la opción seleccionada
                                            },
                                            items: sexo
                                                .map<DropdownMenuItem<dynamic>>(
                                                  (sx) => DropdownMenuItem(
                                                    value: sx,
                                                    child: SizedBox(
                                                      width:
                                                          200, // ajusta el ancho del contenedor del dropdown
                                                      child: Text(
                                                        sx['nombre'],
                                                        overflow: TextOverflow
                                                            .ellipsis, // agrega puntos suspensivos
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          DropdownButtonFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Provincia',
                                              border: OutlineInputBorder(),
                                            ),
                                            isDense: true,
                                            value: provincias.firstWhere(
                                                (pr) =>
                                                    estudiante['idProvincia'] ==
                                                    pr['codigo'],
                                                orElse: () => null),
                                            onChanged: (value) async {
                                              // Acciones para la opción seleccionada
                                              setState(() async {
                                                estudiante['idProvincia'] =
                                                    value['codigo'];
                                                await obtenerCantones(
                                                    value['codigo'],
                                                    estudiante);
                                              });
                                            },
                                            items: provincias
                                                .map<DropdownMenuItem<dynamic>>(
                                                  (pr) => DropdownMenuItem(
                                                    value: pr,
                                                    child: SizedBox(
                                                      width:
                                                          200, // ajusta el ancho del contenedor del dropdown
                                                      child: Text(
                                                        pr['nombre'],
                                                        overflow: TextOverflow
                                                            .ellipsis, // agrega puntos suspensivos
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final nuevoNombre =
                                            nombreController.text;
                                        final nuevoCodigo =
                                            codigoController.text;
                                        final nuevoCorreo =
                                            correoController.text;
                                        final nuevoEdad = edadController.text;
                                        final nuevoCedula =
                                            cedulaController.text;

                                        // Actualiza el estudiante en la lista de usuarios con los nuevos valores
                                        usuarios[index]['codAlumno'] =
                                            nuevoCodigo;
                                        usuarios[index]['alumnoNombre'] =
                                            nuevoNombre;
                                        usuarios[index]['correoInstitucional'] =
                                            nuevoCorreo;
                                        usuarios[index]['edad'] = nuevoEdad;
                                        usuarios[index]['cedula'] = nuevoCedula;

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Editar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (value == 'delete') {
                            // Acción para eliminar
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Editar'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Eliminar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class provinciasWidget extends StatelessWidget {
  const provinciasWidget({
    super.key,
    required this.cantonesw,
    required this.estudiantew,
  });

  final List cantonesw;
  final estudiantew;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: 'Cantones',
        border: OutlineInputBorder(),
      ),
      isDense: true,
      value: cantonesw.firstWhere(
          (ct) => estudiantew['idCanton'] == ct['codigo'],
          orElse: () => null),
      onChanged: (value) {
        // Acciones para la opción seleccionada
      },
      items: cantonesw
          .map<DropdownMenuItem<dynamic>>(
            (ct) => DropdownMenuItem(
              value: ct,
              child: SizedBox(
                width: 200, // ajusta el ancho del contenedor del dropdown
                child: Text(
                  ct['nombre'],
                  overflow: TextOverflow.ellipsis, // agrega puntos suspensivos
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
