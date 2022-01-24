import 'package:flutter/material.dart';
//execute "flutter pub add image_picker"
import 'package:image_picker/image_picker.dart';



class TextComposer extends StatefulWidget {
  TextComposer(this.sendMenssage);
  final Function({String? text, XFile? imgFile}) sendMenssage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;
  void _reset(){
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget> [
          IconButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                //final XFile? imgFile = await _picker.pickImage(source: ImageSource.gallery);
                // Capture a photo
                final XFile? imgFile = await _picker.pickImage(source: ImageSource.camera);
                //final File imgFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (imgFile == null) return;
                //print(imgFile);
                widget.sendMenssage(imgFile: imgFile);
              },
              icon: Icon(Icons.photo_camera)
          ),
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(hintText: 'enviar uma mensagem'),
                onChanged: (text){
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: (text){
                  widget.sendMenssage(text: text);
                  _reset();
                },
              )
          ),
          IconButton(
              onPressed: _isComposing ? (){
                widget.sendMenssage(text: _controller.text);
                _reset();
              }:null,
              icon: Icon(Icons.send)
          )

        ],
      ),
    );
  }
}
