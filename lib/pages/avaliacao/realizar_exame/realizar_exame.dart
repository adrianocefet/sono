import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao.dart';
import 'package:sono/pages/avaliacao/exame.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

class RealizarExame extends StatefulWidget {
  final Avaliacao controllerAvaliacao;
  final Exame exame;
  final bool refazerExame;
  const RealizarExame({
    Key? key,
    required this.controllerAvaliacao,
    required this.exame,
    this.refazerExame = false,
  }) : super(key: key);

  @override
  State<RealizarExame> createState() => _RealizarExameState();
}

class _RealizarExameState extends State<RealizarExame> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool _perguntaCondicionalDaPolissonografiaHabilitada = () {
      return widget.exame.tipo == TipoExame.polissonografia
          ? widget.exame.perguntas
                  .firstWhere(
                      (p) => p.codigo == 'existe_registro_em_posicao_supina')
                  .respostaPadrao ??
              false
          : false;
    }();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            widget.exame.nome,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
              stops: [0, 0.2],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: widget.exame.perguntas
                    .map(
                      (pergunta) => pergunta.codigo ==
                                  'ha_predominio_de_eventos_posicao_supina' &&
                              _perguntaCondicionalDaPolissonografiaHabilitada ==
                                  false
                          ? const SizedBox.shrink()
                          : RespostaWidget(
                              pergunta,
                              autoPreencher: widget.refazerExame
                                  ? pergunta.tipo ==
                                          TipoPergunta
                                              .multiplaCadastrosComExtensoESeletor
                                      ? []
                                      : ''
                                  : pergunta.respostaPadrao,
                              notifyParent: () => setState(() {}),
                            ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.exame.salvarRespostas();
                widget.refazerExame
                    ? widget.controllerAvaliacao.modificarExame(widget.exame)
                    : widget.controllerAvaliacao.salvarExame(widget.exame);
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Exame salvo!'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }
            },
            child: const Text(
              'Finalizar exame',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 5.0, backgroundColor: Theme.of(context).focusColor,
              maximumSize: const Size(350, 50),
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
