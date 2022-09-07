import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> basePolissonografia = [
  {
    'enunciado': "Data de realização",
    'tipo': TipoPergunta.data,
    'codigo': 'data',
    'validador': (value) {
      return value.isEmpty ? 'Dado obrigatório' : null;
    },
  },
  {
    'enunciado': "IAH",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'IAH',
    'unidade': 'eventos/h',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "SpO₂ mínima",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'spo2_minima',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "SpO₂ basal",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'spo2_basal',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "SpO₂ média",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'spo2_media',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Tempo de SpO2<90%",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'tempo_spo2<90%',
    'unidade': 'min',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Índice de despertar",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'indice_de_despertar',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Latência para o sono",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'latencia_para_o_sono',
    'unidade': 'min',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Latência para o sono REM",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'latencia_para_o_sono_rem',
    'unidade': 'min',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Tempo total de sono",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'tempo_total_de_sono',
    'unidade': 'min',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Tempo acordado após início do sono (WASO)",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'tempo_acordado_apos_incio_do_sono',
    'unidade': 'min',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Eficiência do Sono",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'eficiencia_do_sono',
    'unidade': '%',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Estágio N1",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'estagio_n1',
    'unidade': '% TST/PTS',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Estágio N2",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'estagio_n2',
    'unidade': '% TST/PTS',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Estágio N3",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'estagio_n3',
    'unidade': '% TST/PTS',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Sono REM",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'sono_rem',
    'unidade': '% TST/PTS',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Índice de movimentos periódicos de extremidades (PLM)",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'indice_movimentos_periodicos_extremidades',
    'unidade': 'eventos/h',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Índice de movimentos periódicos de extremidades (PLM)",
    'tipo': TipoPergunta.dropdownCadastros,
    'codigo': 'indice_movimentos_periodicos_extremidades',
    'opcoes': ['Obstrutivos', 'Centrais', 'Mistos'],
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Existe registro realizado em posição supina?",
    'tipo': TipoPergunta.afirmativaCadastros,
    'codigo': 'existe_registro_em_posicao_supina',
  },
  {
    'enunciado': "Há predomínio de eventos em posição supina?",
    'tipo': TipoPergunta.afirmativaCadastros,
    'codigo': 'ha_predominio_de_eventos_posicao_supina',
  },
  {
    'enunciado': "Houve Cheyne-Stokes?",
    'tipo': TipoPergunta.afirmativaCadastros,
    'codigo': 'houve_cheyne_stokes',
  },
  {
    'enunciado': "Observações",
    'tipo': TipoPergunta.multiLinhasCadastros,
    'codigo': 'observacoes',
  },
];
