import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/solicitacao.dart';

import '../../../constants/constants.dart';
import '../../../utils/dialogs/carregando.dart';
import '../../../utils/dialogs/error_message.dart';
import '../../../utils/models/usuario.dart';

class ItemPaciente extends StatelessWidget {
  final Paciente paciente;
  final Equipamento? equipamentoPreEscolhido;
  final TipoSolicitacao? tipoSolicitacao;
  const ItemPaciente(
      {Key? key,
      required this.paciente,
      this.equipamentoPreEscolhido,
      this.tipoSolicitacao})
      : super(key: key);

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
          child: ScopedModelDescendant<Usuario>(
            builder: (context, child, model) => ListTile(
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
              onTap: equipamentoPreEscolhido == null
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PerfilClinicoPaciente(paciente.id),
                        ),
                      )
                  : () async {
                      mostrarDialogCarregando(context);
                      try {
                        tipoSolicitacao == TipoSolicitacao.emprestimo
                            ? await equipamentoPreEscolhido!
                                .solicitarEmprestimo(paciente, model)
                            : await equipamentoPreEscolhido!
                                .conceder(paciente, model);
                      } catch (erro) {
                        equipamentoPreEscolhido!.status =
                            StatusDoEquipamento.disponivel;
                        mostrarMensagemErro(context, erro.toString());
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Constantes.corAzulEscuroPrincipal,
                          content: Text(tipoSolicitacao ==
                                  TipoSolicitacao.emprestimo
                              ? "Solicitação enviada à dispensação!"
                              : 'Equipamento concedido ao paciente selecionado!'),
                        ),
                      );
                    },
            ),
          ),
        ));
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
