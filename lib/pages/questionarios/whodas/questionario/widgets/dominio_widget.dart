import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_controller.dart';
import 'package:sono/utils/models/pergunta.dart';

import 'enunciado_dominio.dart.dart';

class Dominio extends StatefulWidget {
  final String codigoDominio;
  late final List<Pergunta> perguntas;
  final WHODASController whodas;
  Dominio({
    required this.whodas,
    required this.codigoDominio,
    required List<Pergunta> perguntas,
    Key? key,
  }) : super(key: key) {
    this.perguntas =
        perguntas.where((element) => element.dominio == codigoDominio).toList();
  }

  @override
  _DominioState createState() => _DominioState();
}

class _DominioState extends State<Dominio> {
  bool _valorAnteriorHabilitado501 = false;
  bool _valorAnteriorHabilitado502 = false;
  bool _dominioAplicavel = true;
  List<Widget> elementos = [];

  void habilitarPerguntasCondicionais(habilitado501, habilitado502) {
    if (habilitado501 != _valorAnteriorHabilitado501) {
      setState(() {
        _valorAnteriorHabilitado501 = habilitado501;
      });
    }
    if (habilitado502 != _valorAnteriorHabilitado502) {
      setState(() {
        _valorAnteriorHabilitado502 = habilitado502;
      });
    }
  }

  void _mudarEstadoDominio(bool value) {
    setState(() {
      _dominioAplicavel = _dominioAplicavel == true ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    WHODASController whodas = widget.whodas;

    elementos = [
      //EnunDominio(dominio: widget.codigoDominio),
      ListTile(
        leading: Switch(
          activeColor: Constantes.coresDominiosWHODASMap[widget.codigoDominio],
          value: _dominioAplicavel,
          onChanged: _mudarEstadoDominio,
        ),
        title: Text(
          _dominioAplicavel ? "Domínio aplicável" : "Domínio não aplicável",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      Divider(
        color: Constantes.coresDominiosWHODASMap[widget.codigoDominio],
        endIndent: 30,
        indent: 30,
        thickness: 2,
      )
    ];

    if (_dominioAplicavel == true) {
      for (int i = 0; i < widget.perguntas.length; i++) {
        Pergunta pergunta = widget.perguntas[i];
        dynamic codigo = pergunta.codigo;

        RespostaWidget respostaWidget = RespostaWidget(
          pergunta,
          notifyParent: () => habilitarPerguntasCondicionais(
            whodas.habilitar501,
            whodas.habilitar502,
          ),
        );

        if (pergunta.dominio == widget.codigoDominio) {
          ['D5.01', 'D5.02'].contains(pergunta.codigo)
              ? elementos.add(
                  Visibility(
                    visible: codigo == 'D5.01'
                        ? whodas.habilitar501
                        : whodas.habilitar502,
                    child: respostaWidget,
                  ),
                )
              : elementos.add(respostaWidget);
        }
      }
    } else {
      widget.perguntas.forEach((pergunta) {
        pergunta.tipo == TipoPergunta.afirmativa
            ? pergunta.setResposta(3) // Índice da opção "vazia"
            : pergunta.setResposta(5); // Índice da opção "6 - Não se aplica"
      });
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: elementos.length,
      itemBuilder: (context, i) {
        return elementos[i];
      },
    );
  }
}
