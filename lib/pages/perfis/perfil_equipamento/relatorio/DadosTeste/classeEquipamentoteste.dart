class Equipamento{
  final String? id;
  final String nome;
  final String tipo;
  final String tamanho;
  final String status;
  final String descricao;
  final String foto;
  final String inicioStatus;
  final String? tipoPap;
  final String? medico;
  final String? paciente;
  final String? imagempaciente;
  final String? data;
  final String? empresa;
  final String? video;
  final String? manual;
  final String? fabricante;
  final String? observacao;



  const Equipamento({required this.nome,required this.tipo,required this.descricao,required this.tamanho,required this.foto,required this.status,required this.inicioStatus,this.tipoPap,this.data,this.medico,this.paciente,this.empresa,this.video,this.imagempaciente,this.manual,this.fabricante,this.observacao,this.id});

  
}