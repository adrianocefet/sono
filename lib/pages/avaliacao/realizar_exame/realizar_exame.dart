import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import 'package:sono/pages/avaliacao/exame.dart';
import 'package:sono/pages/avaliacao/realizar_exame/dialogs/anexar_arquivo.dart';
import 'package:sono/pages/avaliacao/realizar_exame/dialogs/visualizar_deletar_arquivo.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

class RealizarExame extends StatefulWidget {
  final ControllerAvaliacao controllerAvaliacao;
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
            Visibility(
              visible: [
                    TipoExame.listagemDeSintomas,
                    TipoExame.listagemDeSintomasDoUsoDoCPAP
                  ].contains(widget.exame.tipo) ==
                  false,
              child: IconButton(
                onPressed: () async {
                  if (widget.exame.pdf == null) {
                    widget.exame.pdf = await mostrarDialogAnexarArquivoAoExame(
                        context, widget.exame.codigo);
                    setState(() {});
                  } else {
                    bool deletarArquivo =
                        await mostrarDialogVisualizarOuDeletarArquivo(
                            context, widget.exame.pdf!);
                    if (deletarArquivo) {
                      await File(widget.exame.pdf!.path).delete();
                      widget.exame.pdf = null;
                      setState(() {});
                    }
                  }
                },
                icon: Icon(
                  Icons.attach_file,
                  color: widget.exame.pdf == null
                      ? Colors.white
                      : Theme.of(context).focusColor,
                ),
              ),
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
              elevation: 5.0,
              backgroundColor: Theme.of(context).focusColor,
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
