import 'dart:io';
import '../utils/models/paciente.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sono/pdf/salvar_pdf.dart';
import 'package:sono/utils/models/equipamento.dart';

class PdfInvoiceApi{
  static Future<File> generate(Paciente pacienteEmprestado, Equipamento equipamentoEmprestado)async{
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        titulo(),
        solicitante(pacienteEmprestado, equipamentoEmprestado),
        equipamento(equipamentoEmprestado),
        paciente(pacienteEmprestado),
      ]
      ));

    return PdfApii.saveDocument(name: 'TermoDeResponsabilidade.pdf',pdf: pdf);
  }

}

paciente(Paciente pacienteEmprestado) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pacienteEmprestado.idade>=18?
      Text('Assinatura: ${pacienteEmprestado.nomeCompleto}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ):
      Text('Nome do responsável: ${pacienteEmprestado.nomeDaMae}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      SizedBox(height: 0.8* PdfPageFormat.cm),
    ]
  );
}

Widget equipamento(Equipamento equipamentoEmprestado) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Descrição do item',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold
        )
      ),
      Text('Tipo: ${equipamentoEmprestado.tipo.emString}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ,),
      Text('Nome: ${equipamentoEmprestado.nome}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ,),
      Text('Marca: ${equipamentoEmprestado.fabricante}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      if(equipamentoEmprestado.tipo.emStringSnakeCase.contains('mascara'))
      Text('Tamanho: ${equipamentoEmprestado.tamanho}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      if(equipamentoEmprestado.tipo.emStringSnakeCase.contains('ap')||equipamentoEmprestado.tipo.emStringSnakeCase.contains('bilevel'))
      Text('Número de série: ${equipamentoEmprestado.numeroSerie??'Sem número de série'}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      SizedBox(height: 0.8*PdfPageFormat.cm),
      Text('Fortaleza, CE, ${equipamentoEmprestado.dataDeExpedicaoEmStringFormatada}',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      SizedBox(height: 0.8*PdfPageFormat.cm),
    ]
  );
}

Widget solicitante(Paciente pacienteEmprestado, Equipamento equipamento) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 0.5* PdfPageFormat.cm),
      Text('IDENTIFICAÇÃO DO SOLICITANTE',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold
        )
      ),
      Text('Nome: ${pacienteEmprestado.nomeCompleto}, Profissão: ${pacienteEmprestado.profissao??'Não informado'}, CPF: ${pacienteEmprestado.cpf??'Não informado'}, Telefone: ${pacienteEmprestado.telefonePrincipal??'Não informado'}, Endereço: ${pacienteEmprestado.endereco}',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal
        )
      ),
      Text('Recebi na Unidade de Dispensação do ${equipamento.hospital}, em perfeito estado de conservação e funcionamento, e para uso próprio, os bens abaixo especificados, que serão utilizados para tratamento da apneia obstrutiva do sono que tenho como diagnóstico. Comprometo-me a mantê-los em perfeito estado de conservação e uso, ficando ciente de que: \n1- Havendo interrupção do tratamento identificado pelo médico ou fisioterapeuta especialista em sono, deverei entregar os bens constantes nesse termo de responsabilidade, no prazo máximo de 7 dias, ao Ambulatório do Sono do Ambulatório do ${equipamento.hospital}. \n2- Em caso de dano, inutilização ou extravio do bem, deverei comunicar imediatamente o ocorrido a unidade dispensadora localizada no ${equipamento.hospital}. \n3- Em caso de extravio por furto/roubo, é de minha responsabilidade a abertura de boletim de ocorrência (BO) cujo comprovante deverá ser apresentado à unidade dispensadora localizada no ${equipamento.hospital}.\n4- Caso o equipamento seja danificado ou inutilizado por mau uso, negligência ou dolo, poderei ser responsabilizado civil e criminalmente, nos termos da lei. \n5- É dever notificar, sempre que questionado em consulta ambulatorial, mensagem eletrônica ou ligação telefônica, informações a respeito do bens entregues para seu tratamento.',
      textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal)
      ),
      SizedBox(height: 0.8* PdfPageFormat.cm),
    ]
  );
}

Widget titulo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('Termo de Responsabilidade Pela Guarda e Uso de Materiais e Equipamentos',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold
        )
      ),
      SizedBox(height: 0.5*PdfPageFormat.cm),
      Text('DOCUMENTO DE COMPROVAÇÃO DE ENTREGA',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.normal,
        )
      ),
    ]
  );
}

  