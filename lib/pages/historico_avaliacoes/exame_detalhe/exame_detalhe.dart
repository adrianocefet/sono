import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/exame.dart';
import 'package:sono/pdf/tela_pdf.dart';
import 'package:sono/utils/models/pergunta.dart';

class ExameEmDetalhe extends StatelessWidget {
  final Exame exame;
  const ExameEmDetalhe({Key? key, required this.exame}) : super(key: key);

  String obterRespostaFormatada(dynamic resposta) {
    if (resposta.runtimeType == bool) {
      return resposta ? "Sim" : "Não";
    } else {
      return resposta.toString();
    }
  }

  String obterResultadoFormatado() {
    dynamic resultado = exame.respostas['resultado'];
    if (resultado.runtimeType == Map &&
        exame.respostas['tipo'] == exame.codigo) {
      List<String> resultadosPorCategoria = (resultado as Map)
          .entries
          .map((p) =>
              '${Constantes.nomesDominiosWHODASMap[p.key]}: ${p.value < 0 ? "Não aplicável" : p.value}')
          .toList();

      resultadosPorCategoria.insert(0, "Total: ${resultado['total']}");
      return resultadosPorCategoria.join('\n\n');
    } else {
      return resultado.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(exame.tipo == TipoExame.questionario
            ? exame.nomeDoQuestionario!
            : exame.nome),
        centerTitle: true,
        actions: [
          Visibility(
            visible: [
                      TipoExame.listagemDeSintomas,
                      TipoExame.listagemDeSintomasDoUsoDoCPAP
                    ].contains(exame.tipo) ==
                    false &&
                exame.urlPdf != null,
            child: IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaPDF.network(
                      urlPdf: exame.urlPdf,
                      nome: exame.nome,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.attach_file,
                color: Theme.of(context).focusColor,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: exame.tipo == TipoExame.questionario
                    ? (exame.perguntas.length + 1)
                    : exame.perguntas.length,
                itemBuilder: (context, index) {
                  if (index == exame.perguntas.length) {
                    return ListTile(
                      title: const Text(
                        "Resultado",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          obterResultadoFormatado(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  Pergunta p = exame.perguntas[index];
                  return ListTile(
                    title: Text(
                      p.enunciado,
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        obterRespostaFormatada(exame.respostas[p.codigo]) +
                            ' ${p.unidade ?? ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).primaryColorLight,
                  endIndent: 30,
                  indent: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
