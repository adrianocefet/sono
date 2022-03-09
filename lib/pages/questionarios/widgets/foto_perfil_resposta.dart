import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/widgets/dialogs/selecionar_origem_foto.dart';

class RegistrarFotoPerfil extends StatefulWidget {
  final Pergunta pergunta;
  final Uint8List? autoPreencher;
  const RegistrarFotoPerfil(
      {required this.pergunta, this.autoPreencher, Key? key})
      : super(key: key);

  @override
  _RegistrarFotoPerfilState createState() => _RegistrarFotoPerfilState();
}

class _RegistrarFotoPerfilState extends State<RegistrarFotoPerfil> {
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    void _selecionarFoto() async {
      try {
        ImageSource? origem = await selecionarOrigemFoto(context);
        if (origem != null) {
          final pickedFile = await _picker.pickImage(
            source: origem,
          );
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
        rethrow;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
              style: const TextStyle(
                fontSize: Constantes.fontSizeEnunciados,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
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
                              color: Colors.black87,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: _imageFile == null &&
                                    widget.autoPreencher == null
                                ? FaIcon(
                                    FontAwesomeIcons.userAlt,
                                    size: MediaQuery.of(context).size.width *
                                        0.23,
                                    color: Colors.grey[350],
                                  )
                                : SizedBox(
                                    height: Constantes.alturaFotoDePerfil,
                                    width: Constantes.larguraFotoDePerfil,
                                    child: _imageFile == null
                                        ? Image.memory(
                                            widget.autoPreencher!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(
                                              _imageFile!.path,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 24,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                visible: _imageFile != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => setState(
                      () => _imageFile = null,
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
    );
  }
}
