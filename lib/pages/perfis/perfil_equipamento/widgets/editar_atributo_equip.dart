import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento/equipamento.dart';

class EditarAtributoEquipamento extends StatelessWidget {
  final String atributo;
  final Equipamento equipamento;

  const EditarAtributoEquipamento(this.equipamento, this.atributo, {Key? key})
      : super(key: key);

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
              initialValue: equipamento.infoMap[atributo] ?? '',
              decoration: InputDecoration(
                hintText: equipamento.infoMap[atributo] ?? '',
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
              onSaved: (value) => equipamento.infoMap[atributo] = value,
              onChanged: (value) => equipamento.infoMap[atributo] = value,
              //validator: (value) => value != '' ? null : 'Dado obrigatório.',
            ),
          ),
        ],
      ),
    );
  }
}
