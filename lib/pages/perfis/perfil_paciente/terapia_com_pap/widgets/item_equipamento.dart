import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/utils/models/equipamento.dart';

class ItemEquipamentoEmprestado extends StatelessWidget {
  final Equipamento equipamento;
  const ItemEquipamentoEmprestado({Key? key, required this.equipamento})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).primaryColor),
                bottom: BorderSide(color: Theme.of(context).primaryColor),
              ),
              color: Theme.of(context).primaryColorLight,
            ),
            child: Center(
              child: Text(
                equipamento.tipo.emString,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FotoDoEquipamento(
                equipamento.urlFotoDePerfil,
              ),
              Column(
                children: [
                  Text(
                    equipamento.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      children: [
                        _AtributoEquipamento(
                          "Expedição",
                          equipamento.dataDeExpedicaoEmStringFormatada!,
                        ),
                        const Spacer(),
                        _AtributoEquipamento(
                          "Devolução",
                          equipamento.dataDeDevolucaoEmStringFormatada!,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Ver equipamento em detalhe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            minimumSize: const Size(200, 30),
                            maximumSize: const Size(300, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _AtributoEquipamento extends StatelessWidget {
  final String label;
  final String valor;
  const _AtributoEquipamento(this.label, this.valor, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColorLight,
            width: 1.5,
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _FotoDoEquipamento extends StatelessWidget {
  final String? urlImagem;
  const _FotoDoEquipamento(
    this.urlImagem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return urlImagem == null
        ? Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.mask,
                color: Colors.white,
                size: 60,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                strokeAlign: StrokeAlign.outside,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Theme.of(context).primaryColorLight,
            ),
            width: 75,
            height: 75,
            clipBehavior: Clip.hardEdge,
            child: Image(
              image: NetworkImage(urlImagem!, scale: 1),
              fit: BoxFit.fill,
            ),
          );
  }
}
