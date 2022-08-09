import 'package:flutter/material.dart';

class Exame extends StatefulWidget {
  final TipoExame tipo;
  const Exame({Key? key, required this.tipo}) : super(key: key);

  @override
  State<Exame> createState() => _ExameState();
}

class _ExameState extends State<Exame> {
  bool exameRealizado = false;

  @override
  Widget build(BuildContext context) {
    String _obterNomeDoExame() {
      switch (widget.tipo) {
        case TipoExame.polissonografia:
          return 'Polissonografia';
        case TipoExame.dadosComplementares:
          return 'Dados Complementares';
        case TipoExame.espirometria:
          return 'Espirometria';
        case TipoExame.listagemDeSintomas:
          return 'Listagem de sintomas';
        case TipoExame.listagemDeSintomasDoUsoDoCPAP:
          return 'Listagem de sintomas do uso do CPAP';
        case TipoExame.manuvacuometria:
          return 'Manuvacuometria';
        case TipoExame.questionarios:
          return 'Questionários';
        case TipoExame.relatorioPAP:
          return 'RelatórioPAP';
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                _obterNomeDoExame(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          widget.tipo == TipoExame.dadosComplementares
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    minLines: 7,
                    maxLines: 7,
                    decoration: InputDecoration(
                      labelText: 'Digite aqui suas observações',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1.2),
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: exameRealizado
                      ? [
                          _AcaoExame(
                            tipo: 'ver',
                            modificarEstadoExame: () => setState(
                              () => exameRealizado = !exameRealizado,
                            ),
                          ),
                          _AcaoExame(
                            tipo: 'refazer',
                            modificarEstadoExame: () => setState(
                              () => exameRealizado = !exameRealizado,
                            ),
                          ),
                          _AcaoExame(
                            tipo: 'excluir',
                            modificarEstadoExame: () => setState(
                              () => exameRealizado = !exameRealizado,
                            ),
                          )
                        ]
                      : [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Última atualização',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '02/05/2022 (3 meses e 7 dias atrás)',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          _AcaoExame(
                            tipo: 'adicionar',
                            modificarEstadoExame: () => setState(
                              () {
                                exameRealizado = !exameRealizado;
                              },
                            ),
                          ),
                        ],
                )
        ],
      ),
    );
  }
}

class _AcaoExame extends StatelessWidget {
  final String tipo;
  final Function modificarEstadoExame;
  const _AcaoExame(
      {Key? key, required this.tipo, required this.modificarEstadoExame})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Icon icone;
    late String nome;
    late Color cor;

    switch (tipo) {
      case 'ver':
        icone = const Icon(Icons.menu, size: 36);
        nome = 'Ver exame';
        cor = Theme.of(context).primaryColorLight;
        break;
      case 'adicionar':
        icone = const Icon(Icons.add, size: 36);
        nome = '';
        cor = Theme.of(context).focusColor;
        break;
      case 'refazer':
        icone = const Icon(Icons.redo, size: 36);
        nome = 'Refazer exame';
        cor = Colors.yellow;
        break;
      case 'excluir':
        icone = const Icon(Icons.close, size: 36);
        nome = 'Excluir exame';
        cor = Colors.red;
        break;

      default:
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          //visible: nome.isNotEmpty,
          child: Text(nome),
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () => modificarEstadoExame(),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cor,
            ),
            child: icone,
          ),
        )
      ],
    );
  }
}

enum TipoExame {
  polissonografia,
  espirometria,
  manuvacuometria,
  listagemDeSintomas,
  listagemDeSintomasDoUsoDoCPAP,
  relatorioPAP,
  questionarios,
  dadosComplementares,
}
