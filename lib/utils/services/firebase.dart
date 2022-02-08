import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sono/utils/models/paciente/paciente.dart';

class FirebaseService {
  static final FirebaseService _firebaseService = FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  FirebaseService._internal();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

//   String? get getUserEmail => _auth.currentUser?.email;
//   String? get getUserID => _auth.currentUser?.uid;
//   User? get getUser => _auth.currentUser;

  static const String PACIENTES = 'pacientes';
//   static const String USUARIOS = 'usuarios';

//   Future removeWhodasData(String whodasID, String pacienteID,
//       {String? dataUltimaSessao}) async {
//     try {
//       await _db.collection('whodas').doc(whodasID).delete();
//       await _db.collection(PACIENTES).doc(pacienteID).update(
//         {
//           'whodas.$whodasID': FieldValue.delete(),
//         },
//       );

//       await _db.collection(USUARIOS).doc(_auth.currentUser?.uid).update(
//         {
//           'pacientes.$pacienteID.ultima_sessao': dataUltimaSessao,
//         },
//       );

//       await Usuario().updateInfo();
//     } catch (e) {
//       throw e;
//     }
//   }

  Future removePatient(Map<String, dynamic> infoPaciente) async {
    print(infoPaciente);
    String idPaciente = infoPaciente['id'];

    await _db.collection(PACIENTES).doc(idPaciente).delete();
  }

  Future<String?> searchPatientOnDatabase(Map<String, dynamic> data) async {
    String? idPaciente;
    try {
      QuerySnapshot query = await _db
          .collection("pacientes")
          .where("nome_completo", isEqualTo: data['nome_completo'])
          .where('pais', isEqualTo: data['pais'])
          .where('data_de_nascimento', isEqualTo: data['data_de_nascimento'])
          .where('cid', isEqualTo: data['cid'])
          .get();

      if (query.docs.isNotEmpty) idPaciente = query.docs[0]['id'];
    } catch (e) {
      rethrow;
    }

    return idPaciente;
  }

  Future<String> uploadPatientData(Map<String, dynamic> data) async {
    String idPaciente = _db.collection(PACIENTES).doc().id;

    try {
      await _db.collection(PACIENTES).doc(idPaciente).set(data);
    } catch (e) {
      rethrow;
    }

    return idPaciente;
  }

  Future<String> updatePatientData(
      Map<String, dynamic> data, String idPaciente) async {
    try {
      await _db.collection(PACIENTES).doc(idPaciente).update(data);
    } catch (e) {
      print(e);
      rethrow;
    }

    return idPaciente;
  }

//   Future uploadWhodasData(Map<String, dynamic> data, String idPaciente) async {
//     String whodasID = _db.collection('whodas').doc().id;
//     try {
//       var dataDeRealizacao = FieldValue.serverTimestamp();
//       data['data'] = dataDeRealizacao;
//       await _db.collection('whodas').doc(whodasID).set(data);

//       await _db.collection(PACIENTES).doc(idPaciente).update(
//         {
//           'num_total_sessoes': FieldValue.increment(1),
//           'whodas.$whodasID': {
//             'data': dataDeRealizacao,
//             'dom_1': data['dom_1'],
//             'dom_2': data['dom_2'],
//             'dom_3': data['dom_3'],
//             'dom_4': data['dom_4'],
//             'dom_51': data['dom_51'],
//             'dom_52': data['dom_52'],
//             'dom_6': data['dom_6'],
//             'total': data['total']
//           }
//         },
//       );

//       DocumentSnapshot snapshot =
//           await _db.collection(PACIENTES).doc(idPaciente).get();
//       Map paciente = snapshot.data() as Map;
//       Map usuarios = paciente['usuarios'];

//       for (var usuario in usuarios.entries) {
//         await _db.collection(USUARIOS).doc(usuario.key).update(
//           {
//             'pacientes.$idPaciente.ultima_sessao': dataDeRealizacao,
//           },
//         );

//         if (usuario.key == _auth.currentUser?.uid)
//           await _db.collection(USUARIOS).doc(usuario.key).update(
//             {
//               'pacientes.$idPaciente.num_parcial_sessoes':
//                   FieldValue.increment(1),
//               'pacientes.$idPaciente.num_total_sessoes':
//                   FieldValue.increment(1),
//             },
//           );
//       }
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

  Future<Paciente> getPatient(String id) async {
    DocumentSnapshot snapshot = await _db.collection(PACIENTES).doc(id).get();
    Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
    dataMap['id'] = id;

    try {
      //dataMap['foto_perfil'] = await getProfileImageFromFirebaseStorage(id: id);
    } catch (e) {}

    return Paciente(dataMap);
  }

  Future<Map<String, dynamic>?> getWhodasData(String whodasID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('whodas').doc(whodasID).get();
      return snapshot.data();
    } catch (e) {
      throw e;
    }
  }

  Future uploadImageToFirebaseStorage({
    required File imageFile,
    String? idPaciente,
  }) async {
    Reference ref = _storage.ref(
      'fotos_de_perfil_pacientes/perfil_$idPaciente',
    );
    ref.putFile(imageFile);
  }

//   Future<Uint8List?> getProfileImageFromFirebaseStorage({
//     String? id,
//     bool fotoDePerfilDePaciente = true,
//   }) async {
//     Reference? ref;
//     try {
//       ref = _storage.ref(
//         '${fotoDePerfilDePaciente ? 'fotos_de_perfil_pacientes' : 'fotos_de_perfil_usuarios'}/perfil_${id ?? _auth.currentUser!.uid}',
//       );

//       return ref.getData();
//     } catch (e) {
//       return null;
//     }
//   }
}
