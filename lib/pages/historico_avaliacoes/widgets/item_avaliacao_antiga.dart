import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/avaliacao/relatorio/widgets/exames_realizados.dart';
import 'package:sono/pages/historico_avaliacoes/avaliacao_detalhe/avaliacao_detalhe.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/services/firebase.dart';

class ItemAvaliacaoAntiga extends StatefulWidget {
  final Avaliacao avaliacaoSemExames;
  final String idPaciente;
  const ItemAvaliacaoAntiga({
    Key? key,
    required this.avaliacaoSemExames,
    required this.idPaciente,
  }) : super(key: key);

  @override
  State<ItemAvaliacaoAntiga> createState() => _ItemAvaliacaoAntigaState();
}

class _ItemAvaliacaoAntigaState extends State<ItemAvaliacaoAntiga> {
  bool expandido = false;
  Avaliacao? avaliacaoComExames;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  widget.avaliacaoSemExames.dataDaAvaliacaoFormatada,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Avaliador:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: FutureBuilder<Avaliacao>(
                          future: FirebaseService().obterAvaliacaoPorID(
                              widget.idPaciente, widget.avaliacaoSemExames.id),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              Avaliacao avaliacaoComExames = snap.data!;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.2,
                                          ),
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                        child: const Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.userMd,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Dra. Camila',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .primaryColorLight,
                                          minimumSize: const Size(60, 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        onPressed: () => setState(() {
                                          expandido = !expandido;
                                        }),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              expandido
                                                  ? 'Colapsar '
                                                  : 'Expandir ',
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Icon(
                                              expandido
                                                  ? Icons.arrow_upward
                                                  : Icons.arrow_downward,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: expandido,
                                    child: Column(
                                      children: [
                                        Divider(
                                          thickness: 1.5,
                                          color: Theme.of(context).primaryColor,
                                          indent: 30,
                                          endIndent: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ExamesRealizados(
                                            listaDeExamesRealizados:
                                                avaliacaoComExames
                                                    .examesRealizados,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(context).focusColor,
                                              minimumSize: const Size(60, 40),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AvaliacaoEmDetalhe(
                                                    avaliacao:
                                                        avaliacaoComExames,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Ver avaliação em detalhe',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        width: 1.2,
                                      ),
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: SizedBox.square(
                                        dimension: 25,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          backgroundColor: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: LinearProgressIndicator(
                                      minHeight: 16,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                      backgroundColor: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
