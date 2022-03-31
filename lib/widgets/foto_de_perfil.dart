import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/screen_equipamentos.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/dialogs/deletar_equipamento.dart';
import 'package:sono/utils/dialogs/deletar_paciente.dart';

//usado somento para void opcaoLongPress
import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoElemento {
  equipamento,
  paciente,
}

class FotoDePerfil extends StatefulWidget {
  final String nome;
  final String urlImagem;
  final String id;
  final Function()? recarregarParent;

  late final TipoElemento _tipo;

  FotoDePerfil.equipamento(this.urlImagem, this.nome, this.id,
      {Key? key, this.recarregarParent})
      : super(key: key) {
    _tipo = TipoElemento.equipamento;
  }

  FotoDePerfil.paciente(this.urlImagem, this.nome, this.id,
      {Key? key, this.recarregarParent})
      : super(key: key) {
    _tipo = TipoElemento.paciente;
  }

  @override
  _FotoDePerfilState createState() => _FotoDePerfilState();
}

class _FotoDePerfilState extends State<FotoDePerfil> {
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return GestureDetector(
          onLongPress: (){
            opcaoLongPress(context, "id");
          },
          /*onLongPress: () async {
            setState(() {
              opacity = 0.1;
            });
            print(widget._tipo);

            if (widget._tipo == TipoElemento.paciente
                ? await mostrarDialogDeletarPaciente(context, widget.id)
                : model.equipamento != 'Equipamento'
                    ? await mostrarDialogDeletarEquipmaneto(context, widget.id)
                    : false) {
            } else {
              setState(() {
                opacity = 0;
              });
            }
          },*/
          onTap: () {
            if (widget._tipo == TipoElemento.equipamento) {
              model.equipamento == 'Equipamento'
                  ? () {
                      model.equipamento = widget.nome;
                      widget.recarregarParent!();
                    }()
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreenEquipamento(widget.id),
                      ),
                    );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilDoPaciente(widget.id),
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.urlImagem,
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    color: Color.fromRGBO(100, 100, 100, opacity),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.nome,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


void opcaoLongPress(context, String editarID) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Escolha uma opção:'),
      content: SizedBox(
          width: 100,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenEquipamento(editarID),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    Text('Editar'),
                  ],
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('Equipamento')
                      .doc(editarID)
                      .delete();
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.highlight_remove,
                      color: Colors.black,
                    ),
                    Text('Remover'),
                  ],
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                    Text('Cancelar'),
                  ],
                ),
              ),
            ],
          )),
    ),
  );
}