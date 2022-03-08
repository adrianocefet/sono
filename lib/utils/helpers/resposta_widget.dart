import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/berlin/questionario/widgets/resposta_multipla_berlin.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/widgets/formulario/afirmativa_resposta.dart';
import 'package:sono/widgets/formulario/data_resposta.dart';
import 'package:sono/widgets/formulario/dropdown_resposta.dart';
import 'package:sono/widgets/formulario/extenso_resposta_cadastro.dart';
import 'package:sono/widgets/formulario/extenso_resposta.dart';
import 'package:sono/widgets/formulario/foto_perfil_resposta.dart';
import 'package:sono/widgets/formulario/marcar_resposta.dart';
import 'package:sono/widgets/formulario/multipla_resposta.dart';

class RespostaWidget extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final Function()? notifyParent;
  final Color corTexto;
  final dynamic autoPreencher;
  final bool formularioEWHODAS;

  const RespostaWidget(this.pergunta,
      {this.notifyParent,
      this.paciente,
      this.corTexto = Colors.black,
      this.autoPreencher,
      this.formularioEWHODAS = true,
      Key? key})
      : super(key: key);

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
          return RepostaMarcar(
            pergunta: pergunta,
            refreshParent: widget.notifyParent!,
            corDominio:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
          );
        }
      case TipoPergunta.afirmativa:
        {
          return RepostaAfirmativa(
            pergunta: pergunta,
            corDominio:
                Constantes.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constantes.corAzulEscuroSecundario,
            corTexto: widget.corTexto,
            oFormularioEWHODAS: widget.formularioEWHODAS,
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
