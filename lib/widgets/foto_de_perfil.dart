import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/screen_equipamentos.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/widgets/dialogs/deletar_equipamento.dart';
import 'package:sono/widgets/dialogs/deletar_paciente.dart';

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
          onLongPress: () async {
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
          },
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