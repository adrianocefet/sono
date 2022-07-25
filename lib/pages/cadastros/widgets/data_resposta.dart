import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          TextFormField(
            readOnly: true,
            controller: _formController,
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.2),
              ),
              labelText: widget.pergunta.enunciado,
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
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
