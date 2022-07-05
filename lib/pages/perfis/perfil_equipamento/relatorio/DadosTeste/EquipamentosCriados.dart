import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';

final todosEquipamentos = <Equipamento>[
  Equipamento(nome:"iVolve N5A",video: "https://www.youtube.com/watch?v=kIs6Go2rQic",fabricante:"BMC",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_nasal_ivolve_n5a_-_bmc_1_.png",tamanho: "G",status: 'Disponível',descricao: '',tipo: 'Máscara Nasal', manual:'https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual-mascara-n5a-bmc.pdf'),
  Equipamento(nome:"DreamWear",video:"https://www.youtube.com/watch?v=8SnRSVeJeAY&t=3s",fabricante: "Philips Respironics",foto: "https://a3.vnda.com.br/1000x/espacoquallys/2019/09/13/17_46_37_374_m_scara_nasal_dreamwear.jpg?v=1651064452",tamanho: "P",status:'Disponível',descricao: '',tipo: 'Máscara Nasal',manual:"https://www.cpaps.com.br/media/mconnect_uploadfiles/p/h/philips_respironics_m_scara_nasal_dreamwear_-_guia_de_ajuste.pdf"),
  Equipamento(nome:"iVolve N5A",video: "https://www.youtube.com/watch?v=kIs6Go2rQic",fabricante:"BMC",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_nasal_ivolve_n5a_-_bmc_1_.png",tamanho: "GG",status: 'Disponível',descricao: '',tipo: 'Máscara Nasal', manual:'https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual-mascara-n5a-bmc.pdf'),
  Equipamento(nome:"DreamWear",video:"https://www.youtube.com/watch?v=8SnRSVeJeAY&t=3s",fabricante: "Philips Respironics",foto: "https://a3.vnda.com.br/1000x/espacoquallys/2019/09/13/17_46_37_374_m_scara_nasal_dreamwear.jpg?v=1651064452",tamanho: "M",status:'Disponível',descricao: '',tipo: 'Máscara Nasal',manual:"https://www.cpaps.com.br/media/mconnect_uploadfiles/p/h/philips_respironics_m_scara_nasal_dreamwear_-_guia_de_ajuste.pdf"),
  Equipamento(nome:"iVolve N5",video: "https://www.youtube.com/watch?v=hIkWfWbODZ4",fabricante:"BMC",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/520x520/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_nasal_ivolve_n5_-_bmc_1_.png",tamanho: "P",status:'Desinfecção',descricao: '',tipo: 'Máscara Nasal',manual:"https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual-mascara-n5-bmc.pdf",empresa: "LimpaBom",data: "03/05/22"),
  Equipamento(nome:"DreamWisp",video: "https://www.youtube.com/watch?v=on2USieUYKc",fabricante: "Philips Respironics",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara-dreamwisp-bob-01_1.jpg",tamanho: "G",status:'Emprestado',paciente: "José Pereira Barbosa",medico: "Dra Marcela Lins",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",data: "10/10/2022",descricao: '',tipo: 'Máscara Nasal',manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/p/h/philips_respironics_m_scara_nasal_dreamwisp_-_manual_do_usu_rio.pdf"),
  Equipamento(nome:"Mirage FX",video: "https://www.youtube.com/watch?v=ZwXC25ClOLw",fabricante: "ResMed",foto: "https://www.ichospitalar.com.br/wp-content/uploads/2020/02/mascara-nasal-mirage-fx-resmed-min.jpg",tamanho: "G",status:'Emprestado',descricao: '',tipo: 'Máscara Nasal'),
  Equipamento(nome:"AirFit N30i",video: "https://www.youtube.com/watch?v=vZCXfRvna9g",fabricante: "ResMed",foto: "https://a-static.mlcdn.com.br/800x560/mascara-nasal-para-cpap-airfit-n30i-medio-resmed/cpapscombr/2124/c36bd14ab6d0d3a9682cac2e32a1fe78.jpg",tamanho: "P",status:'Desinfecção',descricao: '',tipo: 'Máscara Nasal',manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/r/e/resmed_m_scara_nasal_airfit_n30i_-_manual_do_usu_rio.pdf",empresa: "LimpaBom",data: "03/05/22"),
  Equipamento(nome:"Wisp",fabricante: "Philips Respironics",foto: "https://vitalfisiocare.com.br/loja/wp-content/uploads/2020/06/M%C3%A1scara-nasal-Wisp-Philips-Respironics1.jpg",tamanho: "M",status:'Manutenção',descricao: '',tipo: 'Máscara Nasal',manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/g/u/guia_ajuste_wisp_philips.pdf",video: "https://www.youtube.com/watch?v=R3mBFVOlKZ0",empresa: "ConsertaBom",data: "10/05/22"),
  Equipamento(nome:"Pico",video: "https://www.youtube.com/watch?v=undvL4LaBHA",fabricante: "Philips Respironics",foto: "https://images.tcdn.com.br/img/img_prod/580963/pico_nasal_philips_respironics_41_1_96c6bd55872311212cfc891f38525c69_20210408152958.jpg",tamanho: "GG",status:'Manutenção',descricao: '',tipo: 'Máscara Nasal',manual: "http://painel.cpaps.com.br/media/mconnect_uploadfiles/g/u/guia_ajuste_mascara_nasal_pico_philips_respironics.pdf",empresa: "ConsertaBom",data: "10/05/22"),

  Equipamento(nome:"Total FitMax",fabricante: "Besmed",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/2/_/2_3_3.jpg",tamanho: "GG",status: 'Manutenção',descricao: '',tipo:"Máscara Facial",empresa: "ConsertaBom",data: "10/05/22"),
  Equipamento(nome:"Total FitLife SE (Sem Exalação)",fabricante: "Philips Respironics",foto: "https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/mascara-facial-total-fitlife-se-sem-exalacao-philips-respironics-1323.jpg",tamanho: "M",status:'Emprestado',paciente: "José Pereira Barbosa",medico: "Dra Marcela Lins",data: "10/10/2022",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",descricao: '',tipo:"Máscara Facial"),
  Equipamento(nome:"Total FitLife",fabricante:"Philips Respironics",foto: "https://drogariaspacheco.vteximg.com.br/arquivos/ids/824992-1000-1000/image-0b537b2f2b7f4f2d92e1940f6e0e2308.jpg?v=637854600364900000",tamanho: "P",status:'Disponível',descricao: '',tipo:"Máscara Facial"),
  Equipamento(nome:"Total PerforMax EE/SE",fabricante: "Philips Respironics",foto: "https://www.cpapmed.com.br/media/W1siZiIsIjIwMTkvMDQvMTEvMTJfMTVfMTBfNTAxX21fc2NhcmFfZmFpY2FsX3RvdGFsX2ZpdGxpZmVfc2VfcGhpbGlwc19yZXNwaXJvbmljc18yXzQuanBnIl1d/m_scara-faical-total-fitlife-se-philips-respironics-2_4.jpg",tamanho: "G",status:'Desinfecção',descricao: '',tipo:"Máscara Facial",empresa: "LimpaBom",data: "03/05/22"),

  Equipamento(nome:"Wizard 230",fabricante:"Apex",foto: "https://www.apexmedicalcorp.com/proimages/Respiratory-Therapy/Mask/Nasal-Pillow-Mask/WiZARD-230/WiZARD-230_P_3.jpg",tamanho: "GG",status: 'Manutenção',descricao: '',tipo: 'Máscara Pillow',empresa: "ConsertaBom",data: "10/05/22"),
  Equipamento(nome:"iVolve F2",fabricante:"BMC",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/520x520/0dc2d03fe217f8c83829496872af24a0/2/-/2-removebg-preview_1_.png",tamanho: "PP",status: 'Disponível',descricao: '',tipo: 'Máscara Oronasal'),
  Equipamento(nome:"Pillow YP-01",fabricante:"Yuwell",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/2/_/2_3_1.jpg",tamanho: "M",status: 'Emprestado',paciente: "José Pereira Barbosa",medico: "Dra Marcela Lins",data: "10/10/2022",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",descricao: '',tipo: 'Máscara Pillow'),
  Equipamento(nome:"Pillow 3100 SP",fabricante: "Philips Respironics",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_nasal_pillow_sp_3100.png",tamanho: "M",status: 'Disponível',descricao: '',tipo: 'Máscara Pillow'),
  Equipamento(nome:"Wizard 230",fabricante:"Apex",foto: "https://www.apexmedicalcorp.com/proimages/sp/Respiratory-Therapy/Mask/Nasal-Pillow-Mask/WiZARD-230/WiZARD-230_P_3.jpg",tamanho: "G",status: 'Desinfecção',descricao: '',tipo: 'Máscara Pillow',empresa: "LimpaBom",data: "03/05/22"),
  Equipamento(nome:"Dreamwear Pillow",fabricante: "Philips Respironics",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/d/r/dream_02.jpg",tamanho: "PP",status: 'Disponível',descricao: '',tipo: 'Máscara Pillow'),
  Equipamento(nome:"Total FitMax",fabricante:"Besmed",foto: "https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTgvMTVfMDZfMjhfOTk2X1RydWVCbHVlXzEuanBnIl1d/TrueBlue-1.jpg",tamanho: "M",status:'Emprestado',paciente: "José Pereira Barbosa",medico: "Dra Marcela Lins",data: "10/10/2022",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",descricao: '',tipo: 'Máscara Facial'),
  Equipamento(nome:"Ivolve F3 NV",fabricante:"BMC",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/520x520/0dc2d03fe217f8c83829496872af24a0/m/_/m_scara_facial_ivolve_f3_nv_-_bmc_1__1.png",tamanho: "P",status:'Disponível',descricao: '',tipo: 'Máscara Facial'),

  Equipamento(nome:"DreamStar Duo ST Evolve",fabricante:"Sefam",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/b/p/bpap-dreamstar1.png",tamanho: "GG",status: 'Manutenção',descricao: '',tipoPap: 'BPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_do_usuario_bpap_duo_st_evolve_cpaps_1.pdf",empresa: "ConsertaBom",data: "10/05/22"),
  Equipamento(nome:"Dreamstar Duo Evolve",fabricante:"Sefam",foto: "https://www.cpaps.com.br/media/catalog/product/cache/1/image/0dc2d03fe217f8c83829496872af24a0/d/r/dreamstar_evolve_1.jpg",tamanho: "M",status:'Emprestado',paciente: "José Pereira Barbosa",data: "10/10/2022",medico: "Dra Marcela Lins",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",descricao: '',tipoPap: 'BPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_do_usuario_bpap_duo_st_evolve_cpaps_1.pdf"),
  Equipamento(nome:"Multi",fabricante:"Yuwell",foto: "https://www.marcamedica.com.br/media/catalog/product/cache/1/image/380x380/9df78eab33525d08d6e5fb8d27136e95/v/e/ventilador_mec_nico_bpap_multi_yh730_com_umidificador_-_yuwell_1_.jpg",tamanho: "P",status:'Disponível',descricao: '',tipoPap: 'BPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/b/p/bpap-multi-com-umidificador-yh-730-manual-do-usuario.pdf"),
  Equipamento(nome:"RESmart T-25A G2",fabricante:"BMC",foto: "https://cdn.awsli.com.br/300x300/782/782478/produto/8967834699c796ef95.jpg",tamanho: "G",status:'Desinfecção',descricao: '',tipoPap: 'BPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_bipap_gii.pdf",empresa: "LimpaBom",data: "03/05/22"),

  Equipamento(nome:"AirCurve 10 ST-A",fabricante: "ResMed",foto: "https://www.resmed.com.br/hubfs/resmed-front/assets/images/aircurve-10-03.jpg",tamanho: "GG",status: 'Manutenção',descricao: '',tipoPap: 'VPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_vpap_aircurve_10_st-a_com_umidificador_resmed.pdf",empresa: "ConsertaBom",data: "10/05/22"),
  Equipamento(nome:"AirCurve 10 ASV",fabricante: "ResMed",foto: "https://images.tcdn.com.br/img/img_prod/932050/vpap_aircurve_10_asv_com_umidificador_resmed_7_1_3fd408feeafebf11f42cc8ac2cd499a3.jpg",tamanho: "M",status:'Emprestado',paciente: "José Pereira Barbosa",data: "10/10/2022",medico: "Dra Marcela Lins",imagempaciente: "https://i.pinimg.com/736x/b9/45/50/b945501e60f4ebcfc4a9f9ba201b017c.jpg",descricao: '',tipoPap: 'VPAP',tipo:"Aparelho PAP"),
  Equipamento(nome:"AirCurve 10 S",fabricante: "ResMed",foto: "https://respirecare.com.br/wp-content/uploads/2017/12/produto-7-1.jpg",tamanho: "P",status:'Disponível',descricao: '',tipoPap: 'VPAP',tipo:"Aparelho PAP",manual: "https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_vpap_aircurve_10_s_resmed.pdf"),
  Equipamento(nome:"AirCurve 10 VAuto",fabricante: "ResMed",foto: "https://www.resmed.com.br/hubfs/ResMed-BR-B2B-2020/Product-Page/AirCurve-10-ASV_KF_02_B2B_B2C.png",tamanho: "G",status:'Desinfecção',descricao: '',tipoPap: 'VPAP',tipo:"Aparelho PAP",empresa: "LimpaBom",data: "03/05/22"),
];