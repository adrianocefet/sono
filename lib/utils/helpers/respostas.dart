import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/widgets/formulario/afirmativa_resposta.dart';
import 'package:sono/widgets/formulario/data_resposta.dart';
import 'package:sono/widgets/formulario/dropdown_resposta.dart';
import 'package:sono/widgets/formulario/extenso_resposta.dart';
import 'package:sono/widgets/formulario/foto_perfil_resposta.dart';
import 'package:sono/widgets/formulario/marcar_resposta.dart';
import 'package:sono/widgets/formulario/multipla_resposta.dart';

class Resposta extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final Function()? notifyParent;
  final Color corTexto;
  final dynamic autoPreencher;
  final bool formularioEWHODAS;

  const Resposta(this.pergunta,
      {this.notifyParent,
      this.paciente,
      this.corTexto = Colors.black,
      this.autoPreencher,
      this.formularioEWHODAS = true,
      Key? key})
      : super(key: key);

  @override
  _RespostaState createState() => _RespostaState();
}

class _RespostaState extends State<Resposta> {
  @override
  Widget build(BuildContext context) {
    return resposta(widget.pergunta);
  }

  Widget resposta(Pergunta pergunta) {
    switch (pergunta.tipo) {
      case TipoPergunta.extenso:
        {
          return RespostaExtenso(
            pergunta: pergunta,
            paciente: widget.paciente,
            corTexto: widget.corTexto,
            corDominio:
                Constants.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constants.corAzulEscuroSecundario,
            autoPreencher: widget.autoPreencher ?? '',
          );
        }
      case TipoPergunta.extensoNumerico:
        {
          return RespostaExtenso(
            pergunta: pergunta,
            paciente: widget.paciente,
            numerico: true,
            corTexto: widget.corTexto,
            corDominio:
                Constants.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constants.corAzulEscuroSecundario,
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
                Constants.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constants.corAzulEscuroSecundario,
          );
        }
      case TipoPergunta.afirmativa:
        {
          return RepostaAfirmativa(
            pergunta: pergunta,
            corDominio:
                Constants.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constants.corAzulEscuroSecundario,
            corTexto: widget.corTexto,
            oFormularioEWHODAS: widget.formularioEWHODAS,
          );
        }
      case TipoPergunta.multipla:
        {
          return RepostaMultipla(
            pergunta: pergunta,
            corDominio:
                Constants.coresDominiosWHODASMap[widget.pergunta.dominio] ??
                    Constants.corAzulEscuroSecundario,
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

      default:
        {
          return Container();
        }
    }
  }
}
