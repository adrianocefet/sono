import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/avaliacao/selecao_exame/selecao_exame.dart';
import 'package:sono/utils/models/paciente.dart';

class IniciarAvaliacao extends StatelessWidget {
  final Paciente paciente;
  const IniciarAvaliacao({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: const Center(
              child: Text(
                'Avaliação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            paciente.dataDaProximaAvaliacaoEmString == null
                ? 'Não há avaliações agendadas'
                : 'Próxima avaliação será em ${paciente.dataDaProximaAvaliacaoEmString}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FaIcon(
              paciente.proximaAvaliacaoEHoje
                  ? FontAwesomeIcons.checkCircle
                  : FontAwesomeIcons.clock,
              size: 55,
              color: paciente.proximaAvaliacaoEHoje
                  ? Theme.of(context).focusColor
                  : Theme.of(context).primaryColor,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).focusColor,
              minimumSize: const Size(60, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelecaoDeExames(paciente: paciente),
                ),
              );
            },
            child: Text(
              paciente.dataDaProximaAvaliacaoEmString == null
                  ? 'Fazer avaliação'
                  : 'Fazer avaliação antecipada',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).focusColor,
              minimumSize: const Size(60, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Ver histórico de avaliações',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
