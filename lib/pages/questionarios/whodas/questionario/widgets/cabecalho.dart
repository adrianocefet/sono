// import 'package:ewhodas/constants/constants.dart';
// import 'package:ewhodas/screens/formulario/dialogs/lista_de_pacientes_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class Cabecalho extends StatelessWidget {
//   final String? autoPreencher;
//   const Cabecalho({this.autoPreencher, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _pacienteController = TextEditingController();
//     _pacienteController.text = autoPreencher ?? '';

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 20),
//             child: Text(
//               AppLocalizations.of(context)!.nomeDoEntrevistado,
//               style: TextStyle(
//                 color: Constants.corAzulEscuroPrincipal,
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20.0,
//           ),
//           TextFormField(
//             controller: _pacienteController,
//             readOnly: true,
//             validator: (value) => value != ''
//                 ? null
//                 : AppLocalizations.of(context)!.dadoObrigatorio,
//             minLines: 1,
//             maxLines: 4,
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelStyle: TextStyle(
//                 color: Constants.corAzulEscuroSecundario,
//                 fontSize: 14,
//               ),
//             ),
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return DialogListaDePacientes();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
