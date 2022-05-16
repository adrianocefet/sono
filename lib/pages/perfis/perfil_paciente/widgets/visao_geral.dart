import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sono/utils/services/firebase.dart';
import '../../../../constants/constants.dart';
import 'equipamentos_emprestados.dart';

class PacienteVisaoGeral extends StatefulWidget {
  final Paciente paciente;
  final UserModel model;
  const PacienteVisaoGeral(
      {required this.paciente, required this.model, Key? key})
      : super(key: key);

  @override
  State<PacienteVisaoGeral> createState() => _PacienteVisaoGeralState();
}

class _PacienteVisaoGeralState extends State<PacienteVisaoGeral> {
  String ticket = '';
  Equipamento? equipamento;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.paciente.urlFotoDePerfil ?? widget.model.semimagem,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.model.editar
                          ? FittedBox(
                              child: Text(
                                widget.paciente.nome,
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            )
                          : 
                          Visibility(
                            visible: widget.paciente.equipamentosEmprestados.isEmpty,
                            child: Column(
                              children: [
                                ticket != '' ?
                                  Column(
                                    children: [
                                      equipamento!=null ?
                                      Column(
                                        children: [
                                          equipamento!.idPacienteResponsavel==null ?
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical:10.0),
                                                child: Text('Nome Equipamento: ${equipamento!.nome}'),
                                              ),
                                              Image.network(
                                                equipamento!.urlFotoDePerfil ?? widget.model.semimagem,
                                                width: MediaQuery.of(context).size.width * 0.3,
                                                height: MediaQuery.of(context).size.width * 0.3,
                                                fit: BoxFit.cover,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('Deseja emprestar esse equipamento para ${widget.paciente.nome}?'),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                      child: ElevatedButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            ticket='';
                                                          });
                                                        },
                                                        child: Text('Cancelar'),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: ()async{
                                                        if(equipamento!=null){
                                                          equipamento!.status = StatusDoEquipamento.emprestado;
                                                          FirebaseService().emprestarEquipamento(equipamento!, widget.paciente);
                                                        }else{
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                          content: Text(
                                                            'Equipamento não encontrado',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          backgroundColor: Constantes.corAzulEscuroSecundario,
                                                          )
                                                        );}
                                                        setState(() {});
                                                      },
                                                      child: Text('Sim'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ) : Column(
                                            children: [
                                              Text('${equipamento!.nome} já emprestado, tente outro!'),
                                              Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                        child: ElevatedButton(
                                                          onPressed: (){
                                                            setState(() {
                                                              ticket='';
                                                            });
                                                          },
                                                          child: Text('Tente Novamente'),
                                                        ),
                                                      ),
                                            ],
                                          ),

                                        ],
                                      ) 
                                      :
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical:10.0),
                                            child: const Text('Equipamento não encontrado'),
                                          ),
                                          Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                                        child: ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              ticket='';
                                            });
                                          },
                                          child: Text('Tente Novamente'),
                                        ),
                                      ),       
                                        ],
                                      ),
                                                                     
                                    ],
                                  ) :
                                ElevatedButton.icon(
                                  onPressed: LerQRCode,
                                  icon: const Icon(Icons.qr_code),
                                  label: const Text('Validar equipamento'),
                                ),
                              ],
                            ),
                          ),
                      EquipamentosEmprestados(
                        listaDeEquipamentos:
                            widget.paciente.equipamentosEmprestados,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  LerQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    ticket = code != '-1' ? code : 'Não validado';
    equipamento = await FirebaseService().obterEquipamentoPorID(ticket);
    setState(() {});
}
}


