import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/utils/models/equipamento.dart';

class AtributosEquipamento extends StatefulWidget {
  final Equipamento equipamento;
  const AtributosEquipamento({Key? key,required this.equipamento}) : super(key: key);

  @override
  State<AtributosEquipamento> createState() => _AtributosEquipamentoState();
}

class _AtributosEquipamentoState extends State<AtributosEquipamento> {
  @override
  Widget build(BuildContext context) {
    Equipamento equipamento = widget.equipamento;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fabricante",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 171, 171, 171)),
                ),
                const Divider(),
                Text(
                  equipamento.fabricante,
                  style: const TextStyle(fontSize: 12),
                ),
                  Visibility(
                    visible: equipamento.tipo==TipoEquipamento.nasal||equipamento.tipo==TipoEquipamento.oronasal||equipamento.tipo==TipoEquipamento.facial||equipamento.tipo==TipoEquipamento.pillow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                      const Text(
                      "Tamanho",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 171, 171, 171)),
                                            ),
                      const Divider(),
                      Text(
                        equipamento.tamanho??'N/A',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 12),
                      ),
                    ],
                                          ),
                  ),
                Visibility(
                    visible: equipamento.tipo==TipoEquipamento.cpap||equipamento.tipo==TipoEquipamento.autocpap||equipamento.tipo==TipoEquipamento.avap||equipamento.tipo==TipoEquipamento.bilevel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                      const Text(
                      "Número de série",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 171, 171, 171)),
                                            ),
                      const Divider(),
                      Text(
                        equipamento.numeroSerie??'N/A',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 12),
                      ),
                    ],
                                          ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 171, 171, 171)),
                ),
                const Divider(),
                Text(
                  equipamento.descricao??'Sem descrição',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
  }
}