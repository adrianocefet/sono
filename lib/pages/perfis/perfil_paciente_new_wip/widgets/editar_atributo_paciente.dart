import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';

class EditarAtributoPaciente extends StatelessWidget {
  final Paciente paciente;
  final String atributo;
  const EditarAtributoPaciente({
    Key? key,
    required this.paciente,
    required this.atributo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$atributo : ',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .65,
            child: TextFormField(
              minLines: 1,
              maxLines: 4,
              initialValue: paciente.infoMap[atributo] ?? '',
              decoration: InputDecoration(
                hintText: paciente.infoMap[atributo] ?? '',
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(88, 98, 143, 1),
                  fontSize: 14,
                ),
              ),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              onSaved: (value) => paciente.infoMap[atributo] = value,
              onChanged: (value) => paciente.infoMap[atributo] = value,
            ),
          ),
        ],
      ),
    );
  }
}
