import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/questionarios/widgets/enunciado_respostas.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaHorarioPittsburg extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;

  const RespostaHorarioPittsburg(this.pergunta,
      {required this.passarPagina, Key? key})
      : super(key: key);

  @override
  State<RespostaHorarioPittsburg> createState() =>
      _RespostaHorarioPittsburgState();
}

class _RespostaHorarioPittsburgState extends State<RespostaHorarioPittsburg> {
  TimeOfDay? _horarioEscolhido;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: false,
          child: TextFormField(
            validator: (indice) => widget.pergunta.respostaExtenso == null
                ? "Pergunta obrigatória."
                : null,
          ),
          maintainState: true,
        ),
        EnunciadoRespostasDeQuestionarios(
          enunciado: widget.pergunta.enunciado,
        ),
        const SizedBox(
          height: 30,
        ),
        IconButton(
          onPressed: () async => _escolherHorario(),
          icon: const FaIcon(FontAwesomeIcons.clock),
          iconSize: MediaQuery.of(context).size.width * 0.25,
          color: Constantes.corAzulEscuroPrincipal,
        ),
        Text(
          widget.pergunta.respostaExtenso ??
              _horarioEscolhido?.format(context) ??
              "Pressione o icone para selecionar um horário.",
          style: const TextStyle(
            fontSize: 25,
            color: Constantes.corAzulEscuroPrincipal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  _escolherHorario() async {
    _horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: widget.pergunta.respostaExtenso == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateFormat("hh:mm").parse(
                widget.pergunta.respostaExtenso!,
              ),
            ),
    );

    setState(() {
      widget.pergunta.setRespostaExtenso(_horarioEscolhido?.format(context));
    });

    if (_horarioEscolhido != null) {
      await widget.passarPagina();
    }
  }
}
