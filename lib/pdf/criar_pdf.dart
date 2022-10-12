import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sono/utils/models/solicitacao.dart';
import '../utils/models/paciente.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sono/pdf/salvar_pdf.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../utils/models/usuario.dart';

class PdfInvoiceApi {
  final Timestamp dataAtual = Timestamp.now();
  String get dataAtualFormatada {
    return DateFormat('dd/MM/yyyy kk:mm').format(dataAtual.toDate());
  }

  static Future<File> gerarTermoDeResponsabilidade(
      Solicitacao solicitacao,
      Paciente pacienteEmprestado,
      Equipamento equipamentoEmprestado,
      Usuario usuario) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
        build: (context) => [
              titulo(TipoSolicitacao.emprestimo, equipamentoEmprestado),
              solicitante(pacienteEmprestado, equipamentoEmprestado,
                  TipoSolicitacao.emprestimo),
              equipamento(equipamentoEmprestado, solicitacao, usuario),
              paciente(pacienteEmprestado),
            ]));

    return PdfApii.saveDocument(
        name:
            equipamentoEmprestado.tipo.emStringSnakeCase.contains('mascara') ||
                    equipamentoEmprestado.tipo.emStringSnakeCase.contains('ap')
                ? 'TermoDeResponsabilidade.pdf'
                : 'ReciboDeItens.pdf',
        pdf: pdf);
  }

  static Future<File> gerarTermoDeDevolucao(
      Solicitacao solicitacao,
      String integridadeDoEquipamento,
      Paciente pacienteEmprestado,
      Equipamento equipamentoEmprestado,
      Usuario usuario) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
        build: (context) => [
              titulo(TipoSolicitacao.devolucao, equipamentoEmprestado),
              solicitante(pacienteEmprestado, equipamentoEmprestado,
                  TipoSolicitacao.devolucao),
              equipamento(equipamentoEmprestado, solicitacao, usuario,
                  integridadeDoEquipamento: integridadeDoEquipamento),
              paciente(pacienteEmprestado),
            ]));

    return PdfApii.saveDocument(name: 'TermoDeDevolucao.pdf', pdf: pdf);
  }
}

paciente(Paciente pacienteEmprestado) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    pacienteEmprestado.idade >= 18
        ? Text('Assinatura: ${pacienteEmprestado.nomeCompleto}',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal))
        : Text('Nome do responsável: ${pacienteEmprestado.nomeDaMae}',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    SizedBox(height: 0.8 * PdfPageFormat.cm),
  ]);
}

Widget equipamento(Equipamento equipamentoEmprestado, Solicitacao solicitacao,
    Usuario dispensacao,
    {String? integridadeDoEquipamento}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Descrição do item',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    Text(
      'Tipo: ${equipamentoEmprestado.tipo.emString}',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
    ),
    Text(
      'Nome: ${equipamentoEmprestado.nome}',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
    ),
    Text('Marca: ${equipamentoEmprestado.fabricante}',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    if (equipamentoEmprestado.tipo.emStringSnakeCase.contains('mascara'))
      Text('Tamanho: ${equipamentoEmprestado.tamanho}',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    if (equipamentoEmprestado.tipo.emStringSnakeCase.contains('ap') ||
        equipamentoEmprestado.tipo.emStringSnakeCase.contains('bilevel'))
      Text(
          'Número de série: ${equipamentoEmprestado.numeroSerie ?? 'Sem número de série'}',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    SizedBox(height: 0.8 * PdfPageFormat.cm),
    Text(
        'Fortaleza, CE, ${solicitacao.tipo != TipoSolicitacao.concessao ? PdfInvoiceApi().dataAtualFormatada : solicitacao.dataDeResposta}',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    SizedBox(height: 0.8 * PdfPageFormat.cm),
    if (solicitacao.tipo == TipoSolicitacao.devolucao)
      Text(
          'Razão para devolução do item: ${solicitacao.justificativaDevolucao}',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    if (solicitacao.tipo == TipoSolicitacao.devolucao)
      Text('Integridade do item: ${integridadeDoEquipamento}',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    if (solicitacao.tipo == TipoSolicitacao.devolucao)
      Text('Recebido por: ${dispensacao.id}',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
  ]);
}

Widget solicitante(Paciente pacienteEmprestado, Equipamento equipamento,
    TipoSolicitacao tipoSolicitacao) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 0.5 * PdfPageFormat.cm),
    Text('IDENTIFICAÇÃO DO SOLICITANTE',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    Text(
        'Nome: ${pacienteEmprestado.nomeCompleto}, Profissão: ${pacienteEmprestado.profissao ?? 'Não informado'}, CPF: ${pacienteEmprestado.cpf ?? 'Não informado'}, Telefone: ${pacienteEmprestado.telefonePrincipal ?? 'Não informado'}, Endereço: ${pacienteEmprestado.endereco}',
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    equipamento.tipo.emStringSnakeCase.contains('mascara') ||
            equipamento.tipo.emStringSnakeCase.contains('ap')
        ? Text(
            tipoSolicitacao == TipoSolicitacao.emprestimo
                ? 'Recebi na Unidade de Dispensação do ${equipamento.hospital}, em perfeito estado de conservação e funcionamento, e para uso próprio, o bem abaixo especificado, que será utilizado para tratamento da apneia obstrutiva do sono que tenho como diagnóstico. Comprometo-me a mantê-lo em perfeito estado de conservação e uso, ficando ciente de que: \n1- Havendo interrupção do tratamento identificado pelo médico ou fisioterapeuta especialista em sono, deverei entregar o bem constante nesse termo de responsabilidade, no prazo máximo de 7 dias, ao Ambulatório do Sono do Ambulatório do ${equipamento.hospital}. \n2- Em caso de dano, inutilização ou extravio do bem, deverei comunicar imediatamente o ocorrido a unidade dispensadora localizada no ${equipamento.hospital}. \n3- Em caso de extravio por furto/roubo, é de minha responsabilidade a abertura de boletim de ocorrência (BO) cujo comprovante deverá ser apresentado à unidade dispensadora localizada no ${equipamento.hospital}.\n4- Caso o equipamento seja danificado ou inutilizado por mau uso, negligência ou dolo, poderei ser responsabilizado civil e criminalmente, nos termos da lei. \n5- É dever notificar, sempre que questionado em consulta ambulatorial, mensagem eletrônica ou ligação telefônica, informações a respeito do bem entregue para seu tratamento.'
                : 'Entreguei no Ambulatório do Sono ${equipamento.hospital} o bem abaixo especificado, que foi utilizado para tratamento da apneia obstrutiva do sono que tenho como diagnóstico. ',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal))
        : Text(
            tipoSolicitacao == TipoSolicitacao.emprestimo
                ? 'Recebi na Unidade de Dispensação do ${equipamento.hospital}, em perfeito estado e para uso próprio, o bem abaixo especificado, que será utilizado para tratamento da apneia obstrutiva do sono que tenho como diagnóstico.'
                : 'Entreguei no Ambulatório do Sono ${equipamento.hospital} o bem abaixo especificado, que foi utilizado para tratamento da apneia obstrutiva do sono que tenho como diagnóstico.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
    SizedBox(height: 0.8 * PdfPageFormat.cm),
  ]);
}

Widget titulo(TipoSolicitacao tipoSolicitacao, Equipamento equipamento) {
  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Text(
        equipamento.tipo.emStringSnakeCase.contains('mascara') ||
                equipamento.tipo.emStringSnakeCase.contains('ap')
            ? 'Termo de Responsabilidade Pela Guarda e Uso de Materiais e Equipamentos'
            : 'RECIBO DE ITENS PARA TRATAMENTO DA TERAPIA PRESSÓRICA',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    SizedBox(height: 0.5 * PdfPageFormat.cm),
    Text(
        tipoSolicitacao == TipoSolicitacao.emprestimo
            ? 'DOCUMENTO DE COMPROVAÇÃO DE ENTREGA'
            : 'DOCUMENTO DE DEVOLUÇÃO DE ITENS',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
        )),
  ]);
}
