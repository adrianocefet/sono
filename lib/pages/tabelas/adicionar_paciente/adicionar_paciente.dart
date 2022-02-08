import 'package:flutter/material.dart';
import 'package:sono/utils/base_perguntas/base_registro_pacientes.dart';
import 'package:sono/utils/helpers/respostas.dart';
import 'package:sono/utils/models/pergunta.dart';

class AdicionarPaciente extends StatefulWidget {
  const AdicionarPaciente({Key? key}) : super(key: key);

  @override
  _AdicionarPacienteState createState() => _AdicionarPacienteState();
}

class _AdicionarPacienteState extends State<AdicionarPaciente> {
  final GlobalKey _formKey = GlobalKey();

  final _listaDePerguntas = baseRegistroPaciente
      .map(
        (pergunta) => Pergunta(
          pergunta['enunciado'],
          pergunta['tipo'],
          [],
          '',
          pergunta['codigo'],
          opcoes: pergunta['opcoes'] ?? [],
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Adicionar paciente'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: ListView.builder(
              itemCount: _listaDePerguntas.length,
              itemBuilder: (context, i) {
                return Resposta(
                  _listaDePerguntas[i],
                  notifyParent: () {},
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
