import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/whodas/resultado/resultado_whodas.dart';
import 'package:sono/utils/base_perguntas/base_whodas.dart';
import 'package:sono/utils/helpers/respostas.dart';
import 'package:sono/utils/helpers/whodas.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/widgets/dialogs/error_message.dart';
import 'widgets/dominio_widget.dart';

class WHODASView extends StatefulWidget {
  final Paciente? paciente;

  const WHODASView({Key? key, this.paciente}) : super(key: key);

  @override
  _WHODASViewState createState() => _WHODASViewState();
}

class _WHODASViewState extends State<WHODASView> {
  WHODAS whodas = WHODAS();

  late final _formKey = GlobalKey<FormState>();

  late final List<Pergunta> perguntas = montarListaPerguntas();

  List<Pergunta> montarListaPerguntas() {
    return baseWHODAS.map((e) {
      return Pergunta(
          e['enunciado'], e['tipo'], e['pesos'], e['dominio'], e['codigo'],
          whodas: whodas, opcoes: e['opcoes'], validador: e['validador']);
    }).toList();
  }

  String? autoPreencher(Pergunta pergunta) {
    switch (pergunta.codigo) {
      case "":
        return widget.paciente?.nome;
      case 'F4':
        return DateFormat('dd/MM/yyyy').format(DateTime.now());
      default:
        return '';
    }
  }

  List<Widget> montarListaRespostas() {
    List<Widget> respostas = [];

    for (var i = 0; i < perguntas.length; i++) {
      if (perguntas[i].dominio == '') {
        respostas.add(
          Resposta(
            perguntas[i],
            paciente: widget.paciente,
            notifyParent: () {},
            autoPreencher: autoPreencher(perguntas[i]),
          ),
        );
      }
    }

    respostas.insertAll(
      respostas.indexWhere(
        (resposta) =>
            resposta.runtimeType == Resposta &&
            (resposta as Resposta).pergunta.codigo == 'H1',
      ),
      [
        for (int i = 1; i < Constants.codigosDominiosWHODAS.length; i++)
          Dominio(
            whodas: whodas,
            codigoDominio: Constants.codigosDominiosWHODAS[i],
            perguntas: perguntas,
          )
      ],
    );

    return respostas;
  }

  Future<void> validarFormulario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> resultado = await whodas.gerarResultadoDoFormulario(
          perguntas, "" //widget.paciente!.id,
          );

      resultado.values.where((element) {
                if (element.runtimeType == int) {
                  return element < 0;
                } else {
                  return false;
                }
              }).length ==
              7
          ? mostrarMensagemErro(
              context,
              "Pelo menos um domínio deve ser aplicável",
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                maintainState: true,
                builder: (_) {
                  return PaginaResultado(resultado: resultado);
                },
              ),
            );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Dados inválidos foram inseridos, por favor cheque suas respostas",
          ),
        ),
      );
    }
  }

  List<Widget>? listaRespostas;

  @override
  Widget build(BuildContext context) {
    listaRespostas = listaRespostas ?? montarListaRespostas();

    List<Widget> _formulario = [
      const Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Divider(
          color: Constants.corAzulEscuroSecundario,
          thickness: 2.5,
          indent: 30,
          endIndent: 30,
          height: 0,
        ),
      ),
      Form(
        key: _formKey,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: listaRespostas!,
        ),
      )
    ];

    return WillPopScope(
      onWillPop: () {
        whodas.limparDadosAnteriores();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.corAzulEscuroPrincipal,
          title: const Text('WHODAS'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: _formulario,
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FlatButton(
              color: Constants.corAzulEscuroPrincipal,
              onPressed: () async {
                for (var p in perguntas) print("${p.codigo} : ${p.resposta}");
                await validarFormulario();
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
