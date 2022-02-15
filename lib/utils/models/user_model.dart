import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  String texto = 'adriano';
  String hospital = 'HUWC';
  String Equipamento = 'Equipamento';
  String semimagem =
      'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png';
  bool editar = false;

  void fazHome() async {
    Equipamento = 'Equipamento';
    notifyListeners();
  }

  void adicionarEquipamento() async {
    FirebaseFirestore.instance.collection('Equipamento').add(
      {'Hospital': hospital, 'Equipamento': Equipamento},
    );
    //notifyListeners();
  }

  void teste(String vai) async {
    texto = 'José';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    texto = vai;
    notifyListeners();
  }
}
