import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  String texto = 'adriano';
  String hospital = '';
  String Equipamento = 'Equipamento';
  String semimagem = 'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png';
  bool editar = true;
  void teste(String vai) async{
    texto = 'José';
    notifyListeners();
    await Future.delayed(Duration(seconds: 3));
    texto = vai;
    notifyListeners();
  }

}