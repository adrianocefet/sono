class Equipamento{
  final String nome;
  final String tipo;
  final String tamanho;
  final String status;
  final String descricao;
  final String foto;
  final String? tipoPap;
  final String? medico;
  final String? paciente;
  final String? imagempaciente;
  final String? data;
  final String? empresa;
  final String? video;
  final String? manual;
  final String? fabricante;


  const Equipamento({required this.nome,required this.tipo,required this.descricao,required this.tamanho,required this.foto,required this.status,this.tipoPap,this.data,this.medico,this.paciente,this.empresa,this.video,this.imagempaciente,this.manual,this.fabricante});

  
}