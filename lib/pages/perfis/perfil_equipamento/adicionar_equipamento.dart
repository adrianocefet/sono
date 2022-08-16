import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/form_tamanho.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/helpers/registro_equipamento_helper.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/dialogs/aviso_ja_possui_equipamento.dart';
import 'package:sono/utils/dialogs/error_message.dart';

import '../../../utils/models/pergunta.dart';


class AdicionarEquipamento extends StatefulWidget {
  final Equipamento? equipamentoJaCadastrado;
  final String? tipo;
  const AdicionarEquipamento({Key? key,this.tipo,this.equipamentoJaCadastrado}) : super(key: key);

  @override
  State<AdicionarEquipamento> createState() => _AdicionarEquipamentoState();
}

class _AdicionarEquipamentoState extends State<AdicionarEquipamento> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroEquipamentoHelper helper = RegistroEquipamentoHelper();

  @override
  Widget build(BuildContext context) {
    final tipo=widget.equipamentoJaCadastrado==null?Constantes.tipoSnakeCase[Constantes.tipo.indexOf(widget.tipo!)]:widget.equipamentoJaCadastrado!.tipo.emStringSnakeCase;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.equipamentoJaCadastrado==null?'Cadastrar equipamento': 'Editar equipamento'),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
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
                      for(Pergunta pergunta in helper.perguntas.getRange(0, 6))
                        RespostaWidget(pergunta,autoPreencher: widget.equipamentoJaCadastrado!=null?widget.equipamentoJaCadastrado!.infoMap[pergunta.codigo]:null),
                      if(tipo==Constantes.tipoSnakeCase[0] || tipo==Constantes.tipoSnakeCase[1] || tipo==Constantes.tipoSnakeCase[2] || tipo==Constantes.tipoSnakeCase[3])
                        RespostaWidget(helper.perguntas.last,autoPreencher: widget.equipamentoJaCadastrado!=null?widget.equipamentoJaCadastrado!.infoMap[helper.perguntas.last.codigo]:null),
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
                      if(widget.equipamentoJaCadastrado==null){
                        try {
                        switch (await helper.registrarEquipamento(
                            model.hospital, tipo)) {
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
                    }else{
                      try {
                         await helper.editarEquipamento(widget.equipamentoJaCadastrado!);
                         Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Constantes.corAzulEscuroPrincipal,
                              content: Text(
                                "Alterações realizadas com sucesso!"
                              ),
                            ),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        mostrarMensagemErro(context, e.toString());
                      }
                    }
                      
                    }
                  },
                  child: Text(widget.equipamentoJaCadastrado==null?'Adicionar equipamento':'Salvar alterações'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        50),
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
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

/* void mostrarDialogAdicionarEquipamento(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroEquipamentoHelper helper = RegistroEquipamentoHelper();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => AlertDialog(
          title: const Text('Adicionar equipamento'),
          contentPadding: EdgeInsets.zero,
          content: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  RespostaWidget(helper.perguntas.first),
                  RespostaWidget(helper.perguntas.last),
                  formTamanhos(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Adicionar"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  mostrarDialogCarregando(context);
                  try {
                    switch (await helper.registrarEquipamento(
                        model.hospital, model.equipamento)) {
                      case StatusCadastroEquipamento.jaExistenteNoBancoDeDados:
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
                }
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
} */
