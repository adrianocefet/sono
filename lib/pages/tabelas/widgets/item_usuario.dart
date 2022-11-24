import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/cadastros/cadastro_usuario/cadastro_usuario.dart';
import 'package:sono/utils/models/usuario.dart';

class ItemUsuario extends StatelessWidget {
  final Usuario usuario;
  const ItemUsuario({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.2,
          color: Theme.of(context).primaryColor,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: FotoDoUsuarioThumbnail(
            usuario.urlFotoDePerfil,
          ),
          title: Text(
            usuario.nomeCompleto,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CadastroDeUsuario(usuario: usuario),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Text("Instituição: "),
                          Text(
                            usuario.instituicao.emString,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'Perfil: ${usuario.perfil.emString}'
                      '\nData de Cadastro: ${usuario.dataDeCadastroFormatada}'
                      '\nProfissão: ${usuario.profissao}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FotoDoUsuarioThumbnail extends StatelessWidget {
  final String? urlImagem;
  const FotoDoUsuarioThumbnail(
    this.urlImagem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return urlImagem == null
        ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                strokeAlign: StrokeAlign.outside,
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(
                strokeAlign: StrokeAlign.outside,
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(urlImagem!),
            ),
          );
  }
}
