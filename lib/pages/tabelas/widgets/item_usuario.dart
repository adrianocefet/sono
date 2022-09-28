import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
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
          leading: _FotoDoUsuarioThumbnail(
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
            child: Column(
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
                  'Perfil: ${usuario.perfil.emString}',
                ),
                Text(
                  'Data de Cadastro: ${usuario.perfil.emString}',
                ),
              ],
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerfilClinicoPaciente(usuario.id),
            ),
          ),
        ),
      ),
    );
  }
}

class _FotoDoUsuarioThumbnail extends StatelessWidget {
  final String? urlImagem;
  const _FotoDoUsuarioThumbnail(
    this.urlImagem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        urlImagem == null
            ? Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
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
            : CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(urlImagem!),
              ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: const FaIcon(
            FontAwesomeIcons.smile,
            color: Colors.white,
            size: 15,
          ),
        )
      ],
    );
  }
}
