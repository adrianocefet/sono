import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/cadastros/widgets/afirmativa_resposta.dart';
import 'package:sono/pages/cadastros/widgets/comorbidades_resposta.dart';
import 'package:sono/pages/cadastros/widgets/data_resposta.dart';
import 'package:sono/pages/cadastros/widgets/dropdown_resposta_cadastro.dart';
import 'package:sono/pages/cadastros/widgets/extenso_resposta_cadastro.dart';
import 'package:sono/pages/cadastros/widgets/foto_perfil_resposta.dart';
import 'package:sono/pages/questionarios/berlin/questionario/widgets/resposta_multipla_berlin.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../pages/questionarios/widgets/afirmativa_resposta.dart';
import '../../pages/questionarios/widgets/dropdown_resposta.dart';
import '../../pages/questionarios/widgets/extenso_resposta.dart';
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
            autoPreencher:
                widget.autoPreencher ?? widget.pergunta.respostaExtenso,
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
            autoPreencher:
                widget.autoPreencher ?? widget.pergunta.respostaExtenso,
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
      case TipoPergunta.dropdownCadastros:
        {
          return RespostaDropdownCadastros(
            pergunta: pergunta,
            autoPreencher: widget.autoPreencher,
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
      case TipoPergunta.afirmativaCadastros:
        {
          return RespostaAfirmativaCadastro(
            pergunta: pergunta,
            autoPreencher: widget.autoPreencher ?? widget.pergunta.resposta,
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
            autoPreencher:
                widget.autoPreencher ?? widget.pergunta.respostaExtenso,
          );
        }
      case TipoPergunta.foto:
        return RegistrarFotoPerfil(
          pergunta: pergunta,
          autoPreencher:
              widget.autoPreencher ?? widget.pergunta.respostaArquivo,
        );
      case TipoPergunta.multiplaCondicionalBerlin:
        return RespostaMultiplaBerlin(
          pergunta: pergunta,
          passarPagina: widget.notifyParent as Future<void> Function(),
        );
      case TipoPergunta.comorbidades:
        return RespostaComorbidades(
          pergunta: pergunta,
          autoPreencher: widget.autoPreencher ?? widget.pergunta.respostaLista,
        );
      default:
        {
          return Container();
        }
    }
  }
}
