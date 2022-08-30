import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaComorbidades extends StatefulWidget {
  final Pergunta pergunta;
  final List? autoPreencher;
  RespostaComorbidades(
      {Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key) {
    if (autoPreencher != null) {
      pergunta.setRespostaLista(autoPreencher!);
    }
  }

  @override
  State<RespostaComorbidades> createState() => _RespostaComorbidadesState();
}

class _RespostaComorbidadesState extends State<RespostaComorbidades> {
  bool valido = true;

  @override
  Widget build(BuildContext context) {
    List comorbidadesSelecionadas = widget.pergunta.respostaLista
        .where(
          (element) => (element as String).contains('Outra(s) :') == false,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            maintainState: true,
            child: TextFormField(
              onSaved: (value) {
                setState(
                  () {
                    valido =
                        widget.pergunta.respostaLista.isNotEmpty ? true : false;
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: valido ? Theme.of(context).primaryColor : Colors.red,
                width: 1.2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    widget.pergunta.enunciado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                for (String comorbidade in comorbidadesSelecionadas)
                  _AdicionarComorbidade(
                    pergunta: widget.pergunta,
                    autoPreencher: comorbidade,
                    atualizarWidget: () => setState(() {}),
                  ),
                Visibility(
                  visible: !widget.pergunta.respostaLista.contains('Nenhuma'),
                  child: _AdicionarComorbidade(
                    pergunta: widget.pergunta,
                    atualizarWidget: () => setState(() {}),
                  ),
                ),
                Visibility(
                  visible: !widget.pergunta.respostaLista.contains('Nenhuma'),
                  child: _OutrasComorbidades(
                    pergunta: widget.pergunta,
                    autoPreencher: widget.autoPreencher,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !valido,
            child: const Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text(
                'Dado obrigatório.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaDeComorbidades extends StatelessWidget {
  final Pergunta pergunta;
  final bool comorbidadeJaSelecionada;
  const _ListaDeComorbidades(
      {Key? key,
      required this.pergunta,
      required this.comorbidadeJaSelecionada})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> comorbidadesNaoSelecionadas = pergunta.opcoes!
        .where((element) => pergunta.respostaLista.contains(element) == false)
        .toList();
    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                'Adicionar comorbidade',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 1.2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Scrollbar(
                  child: ListView.separated(
                    itemCount: comorbidadesNaoSelecionadas.length,
                    separatorBuilder: (context, i) {
                      return i == 0
                          ? Divider(
                              color: Theme.of(context).primaryColor,
                              thickness: 1.5,
                            )
                          : const SizedBox.shrink();
                    },
                    itemBuilder: (context, i) {
                      String opcao = comorbidadesNaoSelecionadas[i];
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if ([
                              'Transplante',
                              'Tumor não metastático',
                              'Cirurgia otorrinolaringológica prévia'
                            ].contains(opcao)) {
                              String? complemento = await showDialog(
                                context: context,
                                builder: (context) => _ComplementoComorbidade(
                                  texto: opcao == "Transplante"
                                      ? "Qual órgão?"
                                      : "Qual?",
                                ),
                              );

                              if (complemento != null) {
                                Navigator.pop(context, '$opcao : $complemento');
                              }
                            } else {
                              Navigator.pop(context, opcao);
                            }
                          },
                          child: Text(
                            opcao,
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(42),
                            primary: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: comorbidadeJaSelecionada,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Remover seleção',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _AdicionarComorbidade extends StatefulWidget {
  final Pergunta pergunta;
  final String? autoPreencher;
  final void Function() atualizarWidget;
  late String? comorbidadeSelecionada;
  _AdicionarComorbidade(
      {Key? key,
      this.autoPreencher,
      required this.pergunta,
      required this.atualizarWidget})
      : super(key: key) {
    comorbidadeSelecionada = autoPreencher;
  }

  @override
  State<_AdicionarComorbidade> createState() => _AdicionarComorbidadeState();
}

class _AdicionarComorbidadeState extends State<_AdicionarComorbidade> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: ElevatedButton(
        onPressed: () async {
          dynamic selecao = await showDialog(
            context: context,
            builder: (context) => _ListaDeComorbidades(
              pergunta: widget.pergunta,
              comorbidadeJaSelecionada: widget.comorbidadeSelecionada != null,
            ),
          );

          if (selecao == 'Nenhuma') {
            widget.pergunta.respostaLista.clear();
            widget.pergunta.respostaLista.add('Nenhuma');
          } else {
            switch (selecao.runtimeType) {
              case bool:
                widget.pergunta.respostaLista
                    .remove(widget.comorbidadeSelecionada);
                widget.comorbidadeSelecionada = null;
                break;
              case String:
                if (widget.comorbidadeSelecionada == null) {
                  widget.comorbidadeSelecionada = selecao;
                  widget.pergunta.respostaLista
                      .add(widget.comorbidadeSelecionada);
                } else {
                  int indiceComorbidadeSelecionada = widget
                      .pergunta.respostaLista
                      .indexOf(widget.comorbidadeSelecionada);
                  widget.pergunta.respostaLista[indiceComorbidadeSelecionada] =
                      selecao;
                  widget.comorbidadeSelecionada = selecao;
                }
                break;
              default:
                break;
            }
          }

          widget.atualizarWidget();
        },
        child: widget.comorbidadeSelecionada == null
            ? Icon(
                Icons.add_circle,
                color: Theme.of(context).focusColor,
                size: 30,
              )
            : Text(
                widget.comorbidadeSelecionada!,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(42),
          primary: widget.comorbidadeSelecionada == null
              ? Colors.white
              : Theme.of(context).primaryColorLight,
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _ComplementoComorbidade extends StatefulWidget {
  final String texto;
  const _ComplementoComorbidade({Key? key, required this.texto})
      : super(key: key);

  @override
  State<_ComplementoComorbidade> createState() => _ComplementoComorbidadeState();
}

class _ComplementoComorbidadeState extends State<_ComplementoComorbidade> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Complemento',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: widget.texto,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1.2),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _controller.text),
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).focusColor,
                side: BorderSide(
                  color: Theme.of(context).focusColor,
                  width: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutrasComorbidades extends StatefulWidget {
  final Pergunta pergunta;
  final List? autoPreencher;
  final TextEditingController _controller = TextEditingController();

  _OutrasComorbidades(
      {Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key) {
    String? respostaOutros = autoPreencher?.firstWhere(
        (element) => element.contains("Outra(s) :"),
        orElse: () => '');

    _controller.text = respostaOutros?.replaceAll("Outra(s) : ", '') ?? '';
  }

  @override
  State<_OutrasComorbidades> createState() => _OutrasComorbidadesState();
}

class _OutrasComorbidadesState extends State<_OutrasComorbidades> {
  get nenhumaComorbidade => widget.pergunta.respostaLista.contains('Nenhuma');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        readOnly: nenhumaComorbidade,
        controller: widget._controller,
        minLines: 5,
        maxLines: 5,
        onChanged: (value) {
          int indiceOutras = widget.pergunta.respostaLista.indexWhere(
              (element) => (element as String).contains('Outra(s) :'));

          if (indiceOutras == -1) {
            widget.pergunta.respostaLista.add("Outra(s) : $value");
          } else {
            widget.pergunta.respostaLista[indiceOutras] = "Outra(s) : $value";
          }

          if (value.trim() == '') {
            widget.pergunta.respostaLista.removeAt(indiceOutras);
          }
        },
        decoration: InputDecoration(
          labelText: 'Outra(s)',
          filled: true,
          fillColor: nenhumaComorbidade ? Colors.grey[200] : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
