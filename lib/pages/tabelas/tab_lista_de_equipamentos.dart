import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/constants/constants.dart';

import '../perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import '../perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import '../perfis/perfil_equipamento/widgets/item_equipamento.dart';

class ListaDeEquipamentos extends StatefulWidget {
  final String tipo;
  final int status;
  const ListaDeEquipamentos({required this.tipo,required this.status,Key? key}) : super(key: key);

  @override
  State<ListaDeEquipamentos> createState() => _ListaDeEquipamentosState();
}

class _ListaDeEquipamentosState extends State<ListaDeEquipamentos> {
  late List<Equipamento> equipamentos;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.equipamentos = List.of(todosEquipamentos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child:ListView(
            children:itensEquipamento(equipamentos), /* [
              ItemEquipamento(nome: widget.tipo + " iVolve N4",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/520x520/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_nasal_ivolve_n4_-_bmc_1_.png",tamanho: "GG",status: widget.status,paciente: "Jesualdo Valufrido Pintonha",data:"12/06/2022",empresa: "Empresa X",medico: "Dr Camila",imagempaciente: "https://us.123rf.com/450wm/mimagephotography/mimagephotography1511/mimagephotography151100059/48581711-close-up-portrait-of-a-smiling-man-with-beard-posing-against-isolated-white-background.jpg?ver=6",),
              ItemEquipamento(nome: widget.tipo + " AirFit N10",foto: "https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTgvMTVfMDZfMjhfOTk2X1RydWVCbHVlXzEuanBnIl1d/TrueBlue-1.jpg",tamanho: "M",status: widget.status,paciente: "Maria Paula Ximenes",empresa: "Empresa X",data:"20/05/2022"),
              ItemEquipamento(nome: widget.tipo + " DreamWear",foto: "https://images.tcdn.com.br/img/img_prod/580963/dreamwear_nasal_philips_respironics_59_1_27c337d6ce4ad0138a351aa1b5f17496_20210408153002.jpg",tamanho: "P",status: widget.status,empresa: "Empresa X",data:"03/04/2022"),
              ItemEquipamento(nome: widget.tipo + " DreamPhilips",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/d/r/dreamwisp-philips-respironics-10-min_1.jpg",tamanho: "G",status: widget.status,paciente: "José Pedro Silva",data:"12/02/2022",empresa: "Empresa X")
            ], */
            
          ),
        ),
    );
  }
  
  List<Widget> itensEquipamento(List<Equipamento> equipamentos)=> equipamentos.map((Equipamento equipamento) {
      return widget.tipo==equipamento.tipo&&widget.status==Constantes.status2.indexOf(equipamento.status)?Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: ItemEquipamento(equipamento: equipamento),
      ):Container();
    }).toList();
}