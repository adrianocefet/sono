// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ewhodas/utils/models/paciente/paciente_reduzido.dart';
// import 'package:ewhodas/utils/services/firebase.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class Usuario {
//   Map<String, dynamic> infoMap = {};
//   String? cidade;
//   String? estado;
//   String? pais;
//   String? dataDeNascimento;
//   String? email;
//   String? idioma;
//   String? nomeCompleto;
//   int? profissao;
//   int? sexo;
//   String? telefone;
//   String? numIdentidade;
//   Uint8List? fotoDePerfil;
//   String? languageCode;

//   static final Usuario _usuario = Usuario._internal();

//   factory Usuario() {
//     return _usuario;
//   }

//   Usuario._internal();

//   Future<void> removeInfo() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     await _prefs.clear();
//   }

//   List<PacienteReduzido> get pacientes {
//     List<PacienteReduzido> listaPacientes = [];

//     if (infoMap['pacientes'] != null) {
//       for (MapEntry<String, dynamic> pacienteInfo
//           in (infoMap['pacientes'] as Map<String, dynamic>).entries.toList()) {
//         Map informacoesReduzidas = pacienteInfo.value;
//         informacoesReduzidas['id'] = pacienteInfo.key;

//         listaPacientes.add(
//           PacienteReduzido(informacoesReduzidas as Map<String, dynamic>),
//         );
//       }
//     }

//     return listaPacientes;
//   }

//   Future<void> updateInfo({Map<String, dynamic>? infoUsuario}) async {
//     try {
//       SharedPreferences _prefs = await SharedPreferences.getInstance();
//       var info;
//       infoUsuario == null
//           ? info = await FirebaseService().getUserData()
//           : info = infoUsuario;

//       if (info['pacientes'] != null) {
//         for (MapEntry<String, dynamic> paciente
//             in (info['pacientes'] as Map<String, dynamic>).entries.toList()) {
//           paciente.value['ultima_sessao'] =
//               paciente.value['ultima_sessao'].runtimeType != String
//                   ? DateFormat('yyyy-MM-dd hh:mm:ss').format(
//                       (paciente.value['ultima_sessao'] as Timestamp).toDate(),
//                     )
//                   : "";
//         }
//       }

//       info['foto_perfil'] =
//           await FirebaseService().getProfileImageFromFirebaseStorage(
//         fotoDePerfilDePaciente: false,
//       );
//       await _setAttributes(info);
//       _prefs.setString(
//         'info',
//         json.encode(info),
//       );
//     } catch (e) {
//       throw e;
//     }
//   }

//   Future<Map<String, dynamic>> getInfo() async {
//     String? infoString;

//     try {
//       SharedPreferences _prefs = await SharedPreferences.getInstance();
//       await updateInfo();

//       infoString = _prefs.getString('info');
//       infoMap = json.decode(infoString!);
//       infoMap['foto_perfil'] = await FirebaseService()
//           .getProfileImageFromFirebaseStorage(fotoDePerfilDePaciente: false);
//       await _setAttributes(infoMap);
//     } catch (e) {
//       infoMap = {};
//     }

//     return infoMap;
//   }

//   Future<void> setLogInStatus(bool status) async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     _prefs.setBool('LoggedIn', status);
//   }

//   Future<bool> getLogInStatus() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     bool? status = _prefs.getBool('LoggedIn');
//     return status != null ? status : false;
//   }

//   Future<bool> checkIfAlreadyHasPatient(idPacientePreexistente) async {
//     for (PacienteReduzido paciente in pacientes) {
//       if (paciente.id == idPacientePreexistente) {
//         return true;
//       }
//     }

//     return false;
//   }

//   Future<void> addCompressedPatientProfilePicToLocalFiles(
//       String patientID, File file) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     File compressedFile = await FlutterNativeImage.compressImage(
//       file.path,
//       quality: 50,
//     );

//     prefs.setString(
//       'thumb_$patientID',
//       base64Encode(compressedFile.readAsBytesSync()),
//     );
//   }

//   Future<String> _getLocaleFromSharedPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String codigoLocale;

//     codigoLocale = prefs.getString('codigoLocale') ?? "en";

//     return codigoLocale;
//   }

//   Future<void> _setAttributes(Map<String, dynamic> infoMap) async {
//     this.cidade = infoMap['cidade'];
//     this.estado = infoMap['estado'];
//     this.pais = infoMap['pais'];
//     this.dataDeNascimento = infoMap['data_de_nascimento'];
//     this.email = infoMap['email'];
//     this.idioma = infoMap['idioma'];
//     this.nomeCompleto = ['null', null].contains(infoMap['nome_completo'])
//         ? FirebaseService().getUser?.displayName
//         : infoMap['nome_completo'];
//     this.fotoDePerfil = infoMap['foto_perfil'];
//     this.profissao = infoMap['profissao'];
//     this.sexo = infoMap['sexo'];
//     this.telefone = infoMap['telefone'];
//     this.numIdentidade = infoMap['num_identidade'];
//     this.languageCode = await _getLocaleFromSharedPrefs();
//   }

//   Future<void> setUserLanguageCode(String languageCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('codigoLocale', languageCode);
//     this.languageCode = languageCode;
//   }
// }
