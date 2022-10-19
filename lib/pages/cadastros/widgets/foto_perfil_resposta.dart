import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/dialogs/selecionar_origem_foto.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/services/firebase.dart';

class RegistrarFotoPerfil extends StatefulWidget {
  final Pergunta pergunta;
  final String? autoPreencher;
  const RegistrarFotoPerfil(
      {required this.pergunta, this.autoPreencher, Key? key})
      : super(key: key);

  @override
  _RegistrarFotoPerfilState createState() => _RegistrarFotoPerfilState();
}

class _RegistrarFotoPerfilState extends State<RegistrarFotoPerfil> {
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  File? _imagemAutoPreenchida;
  bool autoPreencherDeletado = false;

  @override
  Widget build(BuildContext context) {
    void _selecionarFoto() async {
      try {
        ImageSource? origem = await selecionarOrigemFoto(context);
        if (origem != null) {
          var pickedFile = await _picker.pickImage(
            source: origem,
          );
          if (pickedFile != null) {
            CroppedFile? croppedFile =
                await ImageCropper().cropImage(sourcePath: pickedFile.path);
            pickedFile = XFile(croppedFile!.path);
          }
          setState(
            () {
              _imageFile = pickedFile ?? _imageFile;
            },
          );
        }
      } catch (e) {
        setState(
          () {},
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.2,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: false,
              child: TextFormField(
                onSaved: (value) {
                  widget.pergunta.setRespostaArquivo(
                    _imageFile != null
                        ? File(
                            _imageFile!.path,
                          )
                        : null,
                  );
                },
              ),
              maintainState: true,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.pergunta.enunciado,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Constantes.fontSizeEnunciados,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _selecionarFoto,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColorLight,
                              width: 2,
                            ),
                          ),
                          child: FutureBuilder(
                            future: () async {
                              if (!autoPreencherDeletado &&
                                  widget.autoPreencher != null) {
                                _imagemAutoPreenchida = await FirebaseService()
                                    .obterImagemDoFirebaseStorage(
                                  widget.autoPreencher!,
                                );
                                return true;
                              }
                              if (_imageFile != null) return true;
                            }(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: Constantes.alturaFotoDePerfil,
                                  width: Constantes.larguraFotoDePerfil,
                                  child: _imageFile == null
                                      ? Image.memory(
                                          _imagemAutoPreenchida!
                                              .readAsBytesSync(),
                                        )
                                      : Image.file(
                                          File(
                                            _imageFile!.path,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                );
                              } else {
                                return Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.userAlt,
                                    size: MediaQuery.of(context).size.width *
                                        0.23,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  maintainState: true,
                  maintainAnimation: true,
                  visible: _imageFile != null ||
                      (widget.autoPreencher != null &&
                          autoPreencherDeletado == false),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () => setState(
                        () {
                          if (_imageFile != null) {
                            _imageFile = null;
                          }
                          if (widget.autoPreencher != null) {
                            autoPreencherDeletado = true;
                            widget.pergunta.setRespostaArquivo(null);
                          }
                        },
                      ),
                      child: const Icon(
                        Icons.clear_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
