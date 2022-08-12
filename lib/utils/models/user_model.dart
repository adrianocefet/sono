import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  String id = 'IDGENERICO';
  String texto = 'adriano';
  String hospital = 'HUWC';
  String equipamento = 'Equipamento';
  String semimagem =
      'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png';
  bool editar = false;
  String tipo='';
  int status=0;

  void fazHome() async {
    equipamento = 'Equipamento';
    notifyListeners();
  }

  void teste(String vai) async {
    texto = 'José';
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    texto = vai;
    notifyListeners();
  }
}
