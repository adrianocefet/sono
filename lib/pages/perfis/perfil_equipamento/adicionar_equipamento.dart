import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/helpers/registro_equipamento_helper.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/utils/dialogs/aviso_ja_possui_equipamento.dart';
import 'package:sono/utils/dialogs/error_message.dart';

import '../../../utils/models/pergunta.dart';

class AdicionarEquipamento extends StatefulWidget {
  final Equipamento? equipamentoJaCadastrado;
  final TipoEquipamento? tipo;
  const AdicionarEquipamento(
      {Key? key, this.tipo, this.equipamentoJaCadastrado})
      : super(key: key);

  @override
  State<AdicionarEquipamento> createState() => _AdicionarEquipamentoState();
}

class _AdicionarEquipamentoState extends State<AdicionarEquipamento> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroEquipamentoHelper helper = RegistroEquipamentoHelper();

  @override
  Widget build(BuildContext context) {
    final tipo = widget.equipamentoJaCadastrado == null
        ? widget.tipo!
        : widget.equipamentoJaCadastrado!.tipo;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.equipamentoJaCadastrado == null
              ? 'Cadastrar equipamento'
              : 'Editar equipamento'),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<Usuario>(builder: (context, child, model) {
          return ListView(children: [
            Column(children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      for (Pergunta pergunta in helper.perguntas.getRange(0, 9))
                        RespostaWidget(pergunta,
                            autoPreencher:
                                widget.equipamentoJaCadastrado != null
                                    ? widget.equipamentoJaCadastrado!
                                        .infoMap[pergunta.codigo]
                                    : null),
                      if (tipo.emStringSnakeCase.contains('ap'))
                        RespostaWidget(helper.perguntas[9],
                            autoPreencher:
                                widget.equipamentoJaCadastrado != null
                                    ? widget.equipamentoJaCadastrado!
                                        .infoMap[helper.perguntas[9].codigo]
                                    : null),
                      if (tipo.emStringSnakeCase.contains('mascara'))
                        RespostaWidget(helper.perguntas.last,
                            autoPreencher:
                                widget.equipamentoJaCadastrado != null
                                    ? widget.equipamentoJaCadastrado!
                                        .infoMap[helper.perguntas.last.codigo]
                                    : null),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      mostrarDialogCarregando(context);
                      if (widget.equipamentoJaCadastrado == null) {
                        try {
                          switch (await helper.registrarEquipamento(
                              model.instituicao.emString,
                              tipo.emStringSnakeCase)) {
                            case StatusCadastroEquipamento
                                .jaExistenteNoBancoDeDados:
                              Navigator.pop(context);
                              mostrarAvisoJaPossuiEquipamento(context);
                              break;
                            default:
                              Navigator.pop(context);
                              Navigator.pop(context);
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          mostrarMensagemErro(context, e.toString());
                        }
                      } else {
                        try {
                          await helper.editarEquipamento(
                              widget.equipamentoJaCadastrado!);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor:
                                  Constantes.corAzulEscuroPrincipal,
                              content:
                                  Text("Alterações realizadas com sucesso!"),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          mostrarMensagemErro(context, e.toString());
                        }
                      }
                    }
                  },
                  child: Text(
                    widget.equipamentoJaCadastrado == null
                        ? 'Adicionar equipamento'
                        : 'Salvar alterações',
                    style: const TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Theme.of(context).focusColor,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ]);
        }));
  }
}
