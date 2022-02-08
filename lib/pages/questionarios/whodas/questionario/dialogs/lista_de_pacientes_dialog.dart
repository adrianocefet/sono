// import 'package:ewhodas/constants/constants.dart';
// import 'package:ewhodas/screens/registro_paciente/registro_paciente.dart';
// import 'package:ewhodas/utils/models/paciente/paciente_reduzido.dart';
// import 'package:ewhodas/utils/services/usuario.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../formulario.dart';

// class DialogListaDePacientes extends StatefulWidget {
//   late final List<PacienteReduzido> listaDePacientes;
//   DialogListaDePacientes({Key? key}) : super(key: key) {
//     this.listaDePacientes = Usuario().pacientes;
//   }

//   @override
//   _DialogListaDePacientesState createState() => _DialogListaDePacientesState();
// }

// class _DialogListaDePacientesState extends State<DialogListaDePacientes> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         widget.listaDePacientes.isNotEmpty
//             ? AppLocalizations.of(context)!.seusPacientes
//             : AppLocalizations.of(context)!.voceAindaNaoCadastrouNenhumPaciente,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Constants.corAzulEscuroPrincipal,
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () async {
//             PacienteReduzido info = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => RegistroPaciente(),
//               ),
//             );

//             Navigator.of(context).popUntil(
//               ModalRoute.withName(
//                 Constants.paginaInicialNavigate,
//               ),
//             );

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) {
//                   return PacienteFormulario(
//                     paciente: info,
//                   );
//                 },
//               ),
//             );
//           },
//           child: Text(
//             AppLocalizations.of(context)!.adicionarNovoPaciente,
//           ),
//         ),
//       ],
//       content: Container(
//         child: ListView.separated(
//           shrinkWrap: true,
//           itemCount: widget.listaDePacientes.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(
//                 widget.listaDePacientes[index].nomeCompleto,
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) {
//                       return PacienteFormulario(
//                         paciente: widget.listaDePacientes[index],
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//           separatorBuilder: (context, i) => Divider(
//             height: 1,
//           ),
//         ),
//       ),
//     );
//   }
// }
