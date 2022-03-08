import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaData extends StatefulWidget {
  final Pergunta pergunta;
  final String? autoPreencher;
  const RespostaData({required this.pergunta, this.autoPreencher, Key? key})
      : super(key: key);

  @override
  _RespostaDataState createState() => _RespostaDataState();
}

class _RespostaDataState extends State<RespostaData> {
  dynamic selectedDate;
  final TextEditingController _formController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale('pt'),
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 18),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _formController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autoPreencher != null && selectedDate == null) {
      _formController.text = widget.autoPreencher!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.pergunta.enunciado,
            style: const TextStyle(
              fontSize: Constantes.fontSizeEnunciados,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            readOnly: true,
            controller: _formController,
            minLines: 1,
            maxLines: 4,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.calendar_today,
              ),
              border: OutlineInputBorder(),
              labelStyle: TextStyle(
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
            onTap: () => _selectDate(context),
            onSaved: (value) => widget.pergunta.setRespostaExtenso(value!),
            validator: (value) => value != '' ? null : 'Dado obrigatório.',
          ),
        ],
      ),
    );
  }
}
