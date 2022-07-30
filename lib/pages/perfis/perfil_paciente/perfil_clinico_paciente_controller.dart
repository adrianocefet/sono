import 'package:flutter/cupertino.dart';
import 'package:sono/utils/models/paciente.dart';

class ControllerPerfilClinicoPaciente {
  late Paciente paciente;
  ValueNotifier<int> paginaAtual = ValueNotifier<int>(1);
  PageController pageController = PageController(initialPage: 1);
}
