import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang_controller.dart';
import 'package:sono/pages/questionarios/stop_bang/resultado/resultado_stop_bang.dart';
import 'package:sono/utils/models/pergunta.dart';

class StopBang extends StatefulWidget {
  const StopBang({Key? key}) : super(key: key);

  @override
  _StopBangState createState() => _StopBangState();
}

class _StopBangState extends State<StopBang> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _controller = StopBangController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("STOP-BANG"),
        backgroundColor: Constants.corPrincipalQuestionarios,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: _controller.listaDeRespostas,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FlatButton(
            color: Constants.corPrincipalQuestionarios,
            onPressed: () async {
              for (Pergunta p in _controller.listaDePerguntas) {
                print("${p.codigo} : ${p.resposta}");
              }

              ResultadoStopBang? resultadoQuestionario =
                  _controller.validarFormulario(_formKey);

              if (resultadoQuestionario != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    builder: (_) {
                      return TelaResultadoStopBang(
                        resultadoQuestionario,
                      );
                    },
                  ),
                );
              } else {
                print('DEU RUIM');
              }
            },
            child: const Text(
              "Confirmar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
