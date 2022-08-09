import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> selecionarOrigemFoto(BuildContext context) async {
  return await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Center(
                  child: Text(
                    'Selecione a origem da foto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).focusColor,
                        minimumSize: const Size(250, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          ImageSource.camera,
                        );
                      },
                      child: const Text(
                        'Câmera',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).focusColor,
                        minimumSize: const Size(250, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          ImageSource.gallery,
                        );
                      },
                      child: const Text(
                        'Galeria',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

// AlertDialog(
//         title: const Text(
//           "Selecione a origem da foto",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Constantes.corAzulEscuroPrincipal,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: ListView(
//           shrinkWrap: true,
//           children: [
//             const Divider(),
//             ListTile(
//               title: const Text(
//                 "Galeria",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Constantes.corAzulEscuroSecundario,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pop(
//                   context,
//                   ImageSource.gallery,
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: const Text(
//                 "Câmera",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Constantes.corAzulEscuroSecundario,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pop(
//                   context,
//                   ImageSource.camera,
//                 );
//               },
//             ),
//             const Divider(),
//           ],
//         ),
//       );
//     },
//   );
