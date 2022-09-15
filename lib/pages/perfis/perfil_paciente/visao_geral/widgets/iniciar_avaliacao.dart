import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/selecao_exame/selecao_exame.dart';
import 'package:sono/pages/historico_avaliacoes/historico_avaliacoes.dart';
import 'package:sono/utils/models/paciente.dart';

class IniciarAvaliacao extends StatelessWidget {
  final Paciente paciente;
  const IniciarAvaliacao({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
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
            paciente.dataDaUltimaAvaliacaoEmString == null
                ? 'Paciente nunca avaliado!'
                : paciente.ultimaAvaliacaoFoiHoje
                    ? "Paciente foi avaliado hoje às ${paciente.dataDaUltimaAvaliacao!.hour}:${paciente.dataDaUltimaAvaliacao!.minute}"
                    : 'Última avaliação realizada em ${paciente.dataDaUltimaAvaliacaoEmString}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).focusColor,
              minimumSize: const Size(200, 40),
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
            child: const Text(
              "Iniciar avaliação",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              minimumSize: const Size(200, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HistoricoDeAvaliacoes(paciente: paciente),
                ),
              );
            },
            child: const Text(
              'Ver histórico de avaliações',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
