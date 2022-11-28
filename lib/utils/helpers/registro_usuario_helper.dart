import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sono/utils/bases_cadastros/base_cadastro_usuario.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/utils/services/firebase.dart';
import 'dart:math';

class RegistroUsuarioHelper {
  final List<Pergunta> perguntas =
      baseCadastroUsuario.map((e) => Pergunta.pelaBase(e)).toList();
  Map<String, dynamic> respostas = {};
  File? _fotoDePerfil;
  Usuario? usuarioPreexistente;
  String? emailDoUsuario;
  String? senhaGerada;

  Map<String, dynamic> _gerarMapaDeRespostas() {
    for (Pergunta p in perguntas) {
      switch (p.tipo) {
        case TipoPergunta.foto:
          _fotoDePerfil = p.respostaArquivo;
          break;
        default:
          respostas[p.codigo] = p.respostaExtenso;
      }
    }

    respostas['data_de_cadastro'] = FieldValue.serverTimestamp();
    if (usuarioPreexistente == null) {
      senhaGerada = "sonoufc1234"; //_gerarSenha();
    }

    emailDoUsuario = respostas['email'];

    return respostas;
  }

  Future<CondicaoUsuario> registrarUsuario() async {
    print(_gerarMapaDeRespostas());

    CondicaoUsuario status = await _checarSeUsuarioJaExiste();
    if (status == CondicaoUsuario.novo) {
      await _adicionarNovoUsuarioAoBancoDeDados();
    }

    return status;
  }

  Future<void> editarUsuario(Usuario usuario) async {
    usuarioPreexistente = usuario;
    print(_gerarMapaDeRespostas());
    respostas.remove('data_de_cadastro');
    await FirebaseService().atualizarDadosDoUsuario(
      respostas,
      usuario.id,
      fotoDePerfil: _fotoDePerfil,
    );
  }

  String _gerarSenha({
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    const length = 10;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  Future<CondicaoUsuario> _checarSeUsuarioJaExiste() async {
    bool jaPossuiPaciente = false;

    jaPossuiPaciente =
        await FirebaseService().procurarUsuarioNoBancoDeDados(respostas) !=
            null;

    if (jaPossuiPaciente) {
      return CondicaoUsuario.jaExistenteNoBancoDeDados;
    } else {
      return CondicaoUsuario.novo;
    }
  }

  Future<String> _adicionarNovoUsuarioAoBancoDeDados() async {
    UserCredential usuarioInfo = await FirebaseService()
        .cadastrarUsuarioComEmailESenha(respostas['email'], senhaGerada!);
    return await FirebaseService().uploadDadosDoUsuario(
      usuarioInfo.user!.uid,
      respostas,
      fotoDePerfil: _fotoDePerfil,
    );
  }
}

enum CondicaoUsuario {
  novo,
  jaExistenteNoBancoDeDados,
}
