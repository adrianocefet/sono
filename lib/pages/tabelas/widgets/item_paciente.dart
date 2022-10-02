import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
import 'package:sono/utils/models/paciente.dart';

class ItemPaciente extends StatelessWidget {
  final Paciente paciente;
  const ItemPaciente({Key? key, required this.paciente}) : super(key: key);

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
          leading: FotoDoPacienteThumbnail(
            paciente.urlFotoDePerfil,
            statusPaciente: paciente.status,
          ),
          title: Text(
            paciente.nomeCompleto,
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
                      const Text("Status: "),
                      Text(
                        paciente.statusFormatado,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Última avaliação: ${paciente.dataDaUltimaAvaliacaoEmString ?? "Nunca"}',
                ),
              ],
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerfilClinicoPaciente(paciente.id),
            ),
          ),
        ),
      ),
    );
  }
}

class FotoDoPacienteThumbnail extends StatelessWidget {
  final String? urlImagem;
  final String statusPaciente;
  const FotoDoPacienteThumbnail(
    this.urlImagem, {
    Key? key,
    required this.statusPaciente,
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
                backgroundImage: urlImagem == null
                    ? const NetworkImage(
                        'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png',
                      )
                    : NetworkImage(urlImagem!),
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
