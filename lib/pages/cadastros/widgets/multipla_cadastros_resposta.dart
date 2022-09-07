import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaMultiplaCadastros extends StatefulWidget {
  final Pergunta pergunta;
  final List? autoPreencher;
  RespostaMultiplaCadastros(
      {Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key) {
    if (autoPreencher != null) {
      pergunta.setRespostaLista(autoPreencher!);
    }
  }

  @override
  State<RespostaMultiplaCadastros> createState() => _RespostaMultiplaCadastrosState();
}

class _RespostaMultiplaCadastrosState extends State<RespostaMultiplaCadastros> {
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
                  _AdicionarOpcao(
                    pergunta: widget.pergunta,
                    autoPreencher: comorbidade,
                    atualizarWidget: () => setState(() {}),
                  ),
                Visibility(
                  visible: !widget.pergunta.respostaLista.contains('Nenhuma'),
                  child: _AdicionarOpcao(
                    pergunta: widget.pergunta,
                    atualizarWidget: () => setState(() {}),
                  ),
                ),
                Visibility(
                  visible: !widget.pergunta.respostaLista.contains('Nenhuma'),
                  child: _Outras(
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

class _ListaDeOpcoes extends StatelessWidget {
  final Pergunta pergunta;
  final bool opcaoJaSelecionada;
  const _ListaDeOpcoes(
      {Key? key,
      required this.pergunta,
      required this.opcaoJaSelecionada})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> opcoesNaoSelecionadas = pergunta.opcoes!
        .where((element) => pergunta.respostaLista.contains(element) == false)
        .toList();
    return Center(
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Adicionar opção',
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
                    child: ListView.builder(
                      itemCount: opcoesNaoSelecionadas.length,
                      itemBuilder: (context, i) {
                        String opcao = opcoesNaoSelecionadas[i];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if ([
                                'Despertar para urinar',
                              ].contains(opcao)) {
                                String? complemento = await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const _ComplementoOpcao(
                                    texto: 'Número de vezes',
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
                              textAlign: TextAlign.center,
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
                  visible: opcaoJaSelecionada,
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
      ),
    );
  }
}

// ignore: must_be_immutable
class _AdicionarOpcao extends StatefulWidget {
  final Pergunta pergunta;
  final String? autoPreencher;
  final void Function() atualizarWidget;
  late String? opcaoSelecionada;
  _AdicionarOpcao(
      {Key? key,
      this.autoPreencher,
      required this.pergunta,
      required this.atualizarWidget})
      : super(key: key) {
    opcaoSelecionada = autoPreencher;
  }

  @override
  State<_AdicionarOpcao> createState() => _AdicionarOpcaoState();
}

class _AdicionarOpcaoState extends State<_AdicionarOpcao> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: ElevatedButton(
        onPressed: () async {
          dynamic selecao = await showDialog(
            context: context,
            builder: (context) => _ListaDeOpcoes(
              pergunta: widget.pergunta,
              opcaoJaSelecionada: widget.opcaoSelecionada != null,
            ),
          );

          if (selecao == 'Nenhuma') {
            widget.pergunta.respostaLista.clear();
            widget.pergunta.respostaLista.add('Nenhuma');
          } else {
            switch (selecao.runtimeType) {
              case bool:
                widget.pergunta.respostaLista.remove(widget.opcaoSelecionada);
                widget.opcaoSelecionada = null;
                break;
              case String:
                if (widget.opcaoSelecionada == null) {
                  widget.opcaoSelecionada = selecao;
                  widget.pergunta.respostaLista.add(widget.opcaoSelecionada);
                } else {
                  int indiceComorbidadeSelecionada = widget
                      .pergunta.respostaLista
                      .indexOf(widget.opcaoSelecionada);
                  widget.pergunta.respostaLista[indiceComorbidadeSelecionada] =
                      selecao;
                  widget.opcaoSelecionada = selecao;
                }
                break;
            }
          }

          widget.atualizarWidget();
        },
        child: widget.opcaoSelecionada == null
            ? Icon(
                Icons.add_circle,
                color: Theme.of(context).focusColor,
                size: 30,
              )
            : Text(
                widget.opcaoSelecionada!,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(42),
          primary: widget.opcaoSelecionada == null
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

class _ComplementoOpcao extends StatefulWidget {
  final String texto;
  const _ComplementoOpcao({Key? key, required this.texto})
      : super(key: key);

  @override
  State<_ComplementoOpcao> createState() => _ComplementoOpcaoState();
}

class _ComplementoOpcaoState extends State<_ComplementoOpcao> {
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

class _Outras extends StatefulWidget {
  final Pergunta pergunta;
  final List? autoPreencher;
  final TextEditingController _controller = TextEditingController();

  _Outras({Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key) {
    String? respostaOutros = autoPreencher?.firstWhere(
        (element) => element.contains("Outra(s) :"),
        orElse: () => '');

    _controller.text = respostaOutros?.replaceAll("Outra(s) : ", '') ?? '';
  }

  @override
  State<_Outras> createState() => _OutrasState();
}

class _OutrasState extends State<_Outras> {
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