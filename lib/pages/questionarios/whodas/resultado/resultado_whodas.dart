import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_controller.dart';
import 'package:sono/widgets/dialogs/error_message.dart';
import '../../../../utils/models/paciente.dart';

class ResultadoWHODASView extends StatefulWidget {
  final ResultadoWHODAS resultado;
  final Paciente paciente;

  const ResultadoWHODASView(
      {Key? key, required this.resultado, required this.paciente})
      : super(key: key);
  @override
  ResultadoWHODASViewState createState() => ResultadoWHODASViewState();
}

class ResultadoWHODASViewState extends State<ResultadoWHODASView> {
  bool isLoading = false;

  Future<void> salvarFormulario() async {
    setState(() {
      isLoading = true;
    });

    try {
      // await FirebaseService()
      //     .uploadWhodasData(widget.resultado, widget.resultado['id_paciente']);
      // await Usuario().updateInfo();
      // Navigator.popUntil(
      //   context,
      //   ModalRoute.withName(Constants.paginaInicialNavigate),
      // );

      // Navigator.pushNamed(context, Constants.paginaInicialNavigate);
      // Navigator.pushNamed(context, Constants.buscaPacienteNavigate);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) {
      //     return PerfilPaciente(widget.resultado['id_paciente']);
      //   }),
      // );
      Navigator.pop(context);
      Navigator.pop(context);
    } on Exception catch (e) {
      mostrarMensagemErro(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.resultado);
    isLoading = false;

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constantes.corAzulEscuroPrincipal,
            title: const Text('Resultados'),
            centerTitle: true,
            actions: <Widget>[],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constantes.corAzulEscuroSecundario),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constantes.domTotalColor,
                              ),
                              child: Center(
                                child: Text(
                                  "",//widget.resultado['total'].toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Divider(
                          color: Constantes.corAzulEscuroSecundario,
                          thickness: 2.5,
                          indent: 30,
                          endIndent: 30,
                          height: 0,
                        ),
                      ),
                      // Pontuacao('dom_1', widget.resultado['dom_1']),
                      // Pontuacao('dom_2', widget.resultado['dom_2']),
                      // Pontuacao('dom_3', widget.resultado['dom_3']),
                      // Pontuacao('dom_4', widget.resultado['dom_4']),
                      // Pontuacao('dom_51', widget.resultado['dom_51']),
                      // Pontuacao('dom_52', widget.resultado['dom_52']),
                      // Pontuacao('dom_6', widget.resultado['dom_6']),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 15),
                        child: Divider(
                          color: Constantes.corAzulEscuroPrincipal,
                          thickness: 2.5,
                          indent: 30,
                          endIndent: 30,
                          height: 0,
                        ),
                      ),
                      //SizedBox(height: 15,),
                      isLoading == true
                          ? const CircularProgressIndicator()
                          : Container(
                              height: 50.0,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                color: Constantes.corAzulEscuroPrincipal,
                              ),
                              child: FlatButton(
                                onPressed: () async => salvarFormulario(),
                                child: const Text(
                                  "Salvar respostas",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);

          return Future.value(false);
        });
  }
}

class Pontuacao extends StatelessWidget {
  final String dominio;
  final num pontuacao;
  const Pontuacao(this.dominio, this.pontuacao, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //contentPadding: EdgeInsets.all(2),
      //dense: true,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pontuacao < 0
              ? Colors.grey
              : Constantes.coresDominiosWHODASMap[dominio],
        ),
        child: Center(
          child: Text(
            pontuacao < 0 ? 'X' : pontuacao.toString(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
          'Domínio de ' + (Constantes.nomesDominiosWHODASMap[dominio] ?? ''),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Constantes.coresDominiosWHODASMap[dominio],
            fontWeight: FontWeight.bold,
            decoration: pontuacao < 0
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          )),
    );
  }
}
