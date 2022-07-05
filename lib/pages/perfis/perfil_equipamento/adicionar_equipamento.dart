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


class AdicionarEquipamento extends StatefulWidget {
  const AdicionarEquipamento({Key? key}) : super(key: key);

  @override
  State<AdicionarEquipamento> createState() => _AdicionarEquipamentoState();
}

class _AdicionarEquipamentoState extends State<AdicionarEquipamento> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroEquipamentoHelper helper = RegistroEquipamentoHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criar Equipamento'),
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
                      RespostaWidget(helper.perguntas.first),
                      RespostaWidget(helper.perguntas.last),
                      formTamanhos(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    "Adicionar",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    mostrarDialogCarregando(context);
                    try {
                      switch (await helper.registrarEquipamento(
                          model.hospital, model.equipamento)) {
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
                  }
                },
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
