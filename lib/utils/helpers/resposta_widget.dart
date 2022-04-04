import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/berlin/questionario/widgets/resposta_multipla_berlin.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../pages/questionarios/widgets/afirmativa_resposta.dart';
import '../../pages/questionarios/widgets/data_resposta.dart';
import '../../pages/questionarios/widgets/dropdown_resposta.dart';
import '../../pages/questionarios/widgets/extenso_resposta.dart';
import '../../pages/questionarios/widgets/extenso_resposta_cadastro.dart';
import '../../pages/questionarios/widgets/foto_perfil_resposta.dart';
import '../../pages/questionarios/widgets/multipla_resposta.dart';

class RespostaWidget extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final Function()? notifyParent;
  final Color corTexto;
  final dynamic autoPreencher;

  const RespostaWidget(
    this.pergunta, {
    this.notifyParent,
    this.paciente,
    this.corTexto = Colors.black,
    this.autoPreencher,
    Key? key,
  }) : super(key: key);

  @override
  _RespostaWidgetState createState() => _RespostaWidgetState();
}

class _RespostaWidgetState<T extends RespostaWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return resposta(widget.pergunta);
  }

  Widget resposta(Pergunta pergunta) {
    switch (pergunta.tipo) {
      case TipoPergunta.extenso:
        {
          return RespostaExtensoQuestionario(
            pergunta: pergunta,
            paciente: widget.paciente,
            corDominio:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
            autoPreencher: widget.autoPreencher,
          );
        }
      case TipoPergunta.extensoNumerico:
        {
          return RespostaExtensoQuestionario(
            pergunta: pergunta,
            paciente: widget.paciente,
            numerico: true,
            corDominio:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
            autoPreencher: widget.autoPreencher,
          );
        }
      case TipoPergunta.extensoCadastros:
        {
          return RespostaExtensoCadastro(
            pergunta: pergunta,
            paciente: widget.paciente,
            corTexto: widget.corTexto,
            autoPreencher: widget.autoPreencher ?? '',
          );
        }
      case TipoPergunta.extensoNumericoCadastros:
        {
          return RespostaExtensoCadastro(
            pergunta: pergunta,
            paciente: widget.paciente,
            numerico: true,
            corTexto: widget.corTexto,
            corDominio:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
            autoPreencher: widget.autoPreencher ?? '',
          );
        }
      case TipoPergunta.dropdown:
        {
          return RespostaDropdown(
            pergunta: pergunta,
            autoPreencher: widget.autoPreencher,
            notificarParent: widget.notifyParent,
          );
        }
      case TipoPergunta.marcar:
        {
          return RespostaMultipla(
            pergunta: pergunta,
            passarPagina: widget.notifyParent as Future<void> Function(),
            corSelecionado:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
          );
        }
      case TipoPergunta.afirmativa:
        {
          return RespostaAfirmativa(
            pergunta: pergunta,
            passarPagina: widget.notifyParent as Future<void> Function(),
          );
        }
      case TipoPergunta.multipla:
        {
          return RespostaMultipla(
            pergunta: pergunta,
            passarPagina: widget.notifyParent as Future<void> Function(),
          );
        }
      case TipoPergunta.data:
        {
          return RespostaData(
            pergunta: pergunta,
            autoPreencher: widget.autoPreencher,
          );
        }
      case TipoPergunta.foto:
        return RegistrarFotoPerfil(
          pergunta: pergunta,
          autoPreencher: widget.autoPreencher,
        );
      case TipoPergunta.multiplaCondicionalBerlin:
        return RespostaMultiplaBerlin(
          pergunta: pergunta,
          passarPagina: widget.notifyParent as Future<void> Function(),
        );
      default:
        {
          return Container();
        }
    }
  }
}
