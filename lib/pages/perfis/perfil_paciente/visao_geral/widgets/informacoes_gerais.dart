import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente.dart';
import 'package:sono/pages/perfis/perfil_paciente/dialogs/selecionar_telefone.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InformacoesGerais extends StatefulWidget {
  final Paciente paciente;
  const InformacoesGerais({Key? key, required this.paciente}) : super(key: key);

  @override
  State<InformacoesGerais> createState() => _InformacoesGeraisState();
}

class _InformacoesGeraisState extends State<InformacoesGerais> {
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, _, usuario) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _AtributoPaciente('Nome completo', widget.paciente.nomeCompleto),
            Row(
              children: [
                _AtributoPacienteFlex('Sexo', widget.paciente.sexo),
                const Spacer(flex: 1),
                _AtributoPacienteFlex('Data de Nascimento',
                    '${widget.paciente.dataDeNascimentoEmString} (${widget.paciente.idade.toString()})'),
              ],
            ),
            Row(
              children: [
                _AtributoPacienteFlex('Altura',
                    '${widget.paciente.altura.toString().replaceAll('.', ',')} m'),
                const Spacer(flex: 1),
                _AtributoPacienteFlex('Peso',
                    '${widget.paciente.peso.toString().replaceAll('.', ',')} kg'),
                const Spacer(flex: 1),
                _AtributoPacienteFlex(
                    'IMC', widget.paciente.imc.toStringAsFixed(2)),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
              child: Visibility(
                visible: expandido,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Comorbidades(paciente: widget.paciente),
                    Row(
                      children: [
                        _AtributoPacienteFlex(
                          'Mallampati',
                          widget.paciente.mallampati.toString(),
                        ),
                        const Spacer(flex: 1),
                        _AtributoPacienteFlex(
                          'Circ. do pescoço',
                          '${widget.paciente.circunferenciaDoPescoco} cm',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _AtributoPacienteFlex(
                          'CPF',
                          widget.paciente.cpf ?? 'Não cadastrado',
                        ),
                        const Spacer(flex: 1),
                        _AtributoPacienteFlex(
                          'Profissão',
                          widget.paciente.profissao ?? 'Não cadastrado',
                        ),
                      ],
                    ),
                    _AtributoPaciente(
                      'Endereço',
                      widget.paciente.endereco,
                    ),
                    _AtributoPaciente(
                      'Nome da mãe',
                      widget.paciente.nomeDaMae ?? 'Não cadastrado',
                    ),
                    _AtributoPaciente(
                      widget.paciente.hospitaisVinculados.length > 1
                          ? 'Hospitais vinculados'
                          : 'Hospital vinculado',
                      widget.paciente.hospitaisVinculados.join(','),
                    ),
                    Row(
                      children: [
                        _AtributoPacienteFlex(
                          'Num. do prontuário',
                          widget.paciente.numeroProntuario,
                        ),
                        const Spacer(flex: 1),
                        _AtributoPacienteFlex(
                          'Data de Cadastro',
                          widget.paciente.dataDeCadastroEmString,
                        ),
                      ],
                    ),
                    _AtributoPaciente(
                      'Possui sinal telefônico estável na residência',
                      widget.paciente.sinalTelefonicoEstavelEmString,
                    ),
                    _AtributoPaciente(
                      'Tem acesso a internet',
                      widget.paciente.temAcessoAInternetEmString,
                    ),
                    _AtributoPaciente(
                      'Trabalhador de turno',
                      widget.paciente.trabalhadorDeTurnoEmString,
                    ),
                  ],
                ),
              ),
            ),
            _Contatos(paciente: widget.paciente),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).focusColor,
                    minimumSize: const Size(60, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScopedModel<Usuario>(
                          model: usuario,
                          child: CadastroPaciente(
                            pacienteJaCadastrado: widget.paciente,
                          )),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Editar informações ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    minimumSize: const Size(60, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => setState(() {
                    expandido = !expandido;
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        expandido ? 'Colapsar ' : 'Expandir ',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        expandido ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AtributoPaciente extends StatelessWidget {
  final String label;
  final String valor;
  const _AtributoPaciente(this.label, this.valor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          Divider(
            color: Theme.of(context).primaryColorLight,
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}

class _AtributoPacienteFlex extends StatelessWidget {
  final String label;
  final String valor;
  const _AtributoPacienteFlex(this.label, this.valor, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: SizedBox(
        height: null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColorLight,
              thickness: 1.5,
            )
          ],
        ),
      ),
    );
  }
}

class _Contatos extends StatelessWidget {
  final Paciente paciente;
  const _Contatos({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (paciente.email ??
              paciente.telefonePrincipal ??
              paciente.telefoneSecundario) !=
          null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Contatos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColorLight,
                          width: 1.5,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Visibility(
                          visible: (paciente.telefonePrincipal ??
                                  paciente.telefoneSecundario) !=
                              null,
                          child: IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Theme.of(context).primaryColor,
                                size: 40,
                              ),
                              onPressed: () async {
                                String? telefone = await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        DialogSelecionarTelefone(
                                          paciente: paciente,
                                        ));
                                if (telefone != null) {
                                  if (!await launchUrlString(
                                    "tel://$telefone",
                                  )) {
                                    throw "Could not launch $telefone";
                                  }
                                }
                              }),
                        ),
                        Visibility(
                          visible: paciente.email != null,
                          child: IconButton(
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: 40,
                              ),
                              onPressed: () async {
                                if (!await launchUrlString(
                                  "mailto:<${paciente.email}>?",
                                )) throw "Could not launch ${paciente.email}";
                              }),
                        ),
                        Visibility(
                          visible: (paciente.telefonePrincipal ??
                                  paciente.telefoneSecundario) !=
                              null,
                          child: IconButton(
                            icon: Icon(
                              Icons.whatsapp,
                              color: Theme.of(context).primaryColor,
                              size: 40,
                            ),
                            onPressed: () async {
                              String? telefone = await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      DialogSelecionarTelefone(
                                        paciente: paciente,
                                      ));
                              if (telefone != null) {
                                if (!await launchUrlString(
                                  "https://wa.me/$telefone",
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw "Could not launch $telefone";
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Comorbidades extends StatelessWidget {
  final Paciente paciente;
  const _Comorbidades({Key? key, required this.paciente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              'Comorbidades',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          () {
            if (paciente.comorbidades == null) {
              return const Text(
                'Não cadastrado',
                style: TextStyle(
                  fontSize: 15,
                ),
              );
            } else {
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ...paciente.comorbidades!.map(
                    (e) => ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      minLeadingWidth: 25,
                      leading: Icon(
                        Icons.circle,
                        size: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        e.replaceAll('Outra(s) : ', ''),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }(),
          Divider(
            color: Theme.of(context).primaryColorLight,
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}
