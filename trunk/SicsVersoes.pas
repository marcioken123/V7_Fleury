//************************************************************************************
//*  Esta é uma unit de listagem e histórico de versões de todos os módulos SICS.    *
//*  Este arquivo deve ser nomeado como .pas (e não .inc, por exemplo) para que      *
//*  a IDE aninhe as diretivas de $REGION                                            *
//************************************************************************************

const

{$REGION 'SICS Servidor'} {$IFDEF CompilarPara_SICS}
    VERSAO = 'ASPECT Mídia'#13'Versão 7.2.3.236 16/05/25';
            //1. - SICS-555 Ao utilizar o MultiPA o servidor trava - FLEURY

//    VERSAO = 'ASPECT Mídia'#13'Versão 7.2.2.236 26/01/24';
            //1. - Tratamento de erro no socket com impressora 10038

//    VERSAO = 'ASPECT Mídia'#13'Versão 7.2.1.241 04/12/23';
            //1. - SICS-35 Retirar a opção de Nenhuma (Finalizar atendimento) Fluxo consultórios

//    VERSAO = 'ASPECT Mídia'#13'Versão 7.2.1.240 23/10/23';
            //1. - SICS-58 Marcar mais de uma TAG por grupo

//    VERSAO = 'ASPECT Mídia'#13'Versão 7.2.1.239 23/10/23';
            //1. - HIAE-SICS-136 Ajuste nos comandos do teclado com servidor V7

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.1.236 18/10/23';
            //1. - Correção ChamarProximo quando marca fila prioritária estava vindo com horário errado.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.238 08/07/23';
            //1. - CARD SICS-66 SICS TV com as configurações salvas em um BD

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.237 23/06/23';
            //1. - SICS-8 Quando cria nova unidade no config não cria a nova no DB version
            //2. - SICS-9 Não cria atendentes na unidade nova
            //3. - SICS-10 No TGS na situação de espera o nome fica bugado
            //4. - SICS-11 No indicadores de performance aba Alarmes, o horário não aparece para configurar.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.236 01/06/23';
           // 1. FLRY-26 - Correçao no Login de atendente

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.2331 01/06/23';  //obs: versão intermediária feita diretamente na 7.2.0.233 para atender o cliente com urgencia, de madrugada. Necessário evoluir para a próxima 7.2.0.236.
           // 1. FLRY-26 - Correçao adicional na chamada de senha especifica

//VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.235 26/04/23';
            //1. - CARD 2996 - Parâmetro p/ Ajustar Online com muitos grupos de TAGs

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.234 05/04/23';
           // 1. - Jira Card 2400 - Criar Socket no Sics e APIs no SCC

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.233 05/04/23';
           // 1. - FLRY-26 - Bug nos endpoints de Indicadores estão com falha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.232 03/04/23';
           // 1. Ajuste Chamar Próxima Senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.231 31/03/23';
           // 1. Jira Card 2363 - Alterar SICS Config e Servidor para cadastro de 1 novo campo na tabela MODULOS_ONLINE

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.230 27/03/23';
           // 1. Ajuste para retornar o id do calculo do TEE direto na solicitação do mesmo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.229 24/03/23';
           // 1. Jira Card 2363 - Alterar SICS Config e Servidor para cadastro dos 4 novos campos nas tabelas MODULOS_PAS e MODULOS_MULTIPAS
           // 2. Banco de dados na versão 473

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.228 27/11/22';
           // 1. Jira Card 1522 - Bug quando marca uma TAG sem grupo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.227 11/09/22';
           // 1. Novos Indicadores de Performance para apresentar valor do banco de dados
           // 2. Banco de dados na versão 462

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.226 11/08/22';
           // 1. Ajuste para corrigir o funcionamento da function TGenerator.GetIDUnidade

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.225 18/07/22';
           // 1. Colocado conteudo do TCalculoPIs.GetValues_TempoEstimadoDeEspera em um Synchronize

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.224 15/07/22';
           // 1. Utilizada funcao frmSicsMain.CalculaTEE no indicador de performance

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.223 13/07/22';
           // 1. Inclusão do retorno dos parametros QTDEPAProdutiva e QTDEPessoasEspera na funcao frmSicsMain.CalculaTEE

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.222 13/07/22';
           // 1. Inclusão das stored Procedures pr_is_SICS_s_SenhasEspera e pr_is_SICS_s_Alarmes.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.221 20/06/22';
           // 1. Ajustes nos scripts para funcionar com SQLServer e com base já migrada. Banco de dados na versão 456 (atenção pois diminuiu com os ajustes!).

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.220 07/06/22';
           // 1. Nova funcionalidade: Gravação em banco de dados dos alarmes ativos por PA
           // 2. Nova funcionalidade: Gravação em banco de dados das quantidades de senhas em espera por PA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.219 30/05/22';
           // 1. Correção do Jira Card FLRY-1 - Parâmetro TMAPorFilaInicialEmMinutos não estava iniciando corretamente

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.218 29/03/22';
           // 1. Jira Card FLRY-1 - Criação do parâmetro TMAPorFilaInicialEmMinutos em Settings

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.217 29/03/22';
           // 1. Jira Card 919 - Criação de campo para marcar se no SicsPA e no SicsMPA marcara tag automaticamente quando encaminhar senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.216 07/03/22';
           // 1. Criação de campo para marcar se no SicsMPA exibirá o Painel de Grupos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.215 21/01/22';
           // 1. Ajuste na validação dos dados retornados nos dados adicionais no envio do whatsapp

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.214 30/12/21';
           // 1. Ajuste para setar campos MOSTRAR_BOTAO_SEGUIRATENDIMENTO e MOSTRAR_MENU_SEGUIRATENDIMENTO como defalut 'F'

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.213 17/12/21';
           // 1. Ajuste para gravar o id_unidade nas tags das senhas
           // 2. Ajuste na chave primária da tabela CALCULOS_TEE

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.1.212 16/12/21';
           // 1. Criados campo WHATSAPP na tabela PAS
           // 2. Criada coluna na tabela de PAs
           // 3. Criado parametro no INI para setar tempo em minutos para permitir avisar o chamado da senha pelo whatsapp


//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.211 09/12/21';
           // 1. Criados campos CODIGOS_UNIDADES, ID_UNIDADE_CLI e FILA_ESPERA_PROFISSIONAL nas tabelas MODULOS_MULTIPAS e MODULOS_PAS
           // 2. Criados os campos para setar os campos criados acima
           // 3. Criados campos ID_UNIDADE_CLI na tabela MODULOS_ONLINE
           // 4. Criado o campo para setar os campos criados acima

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.210 02/12/21';
           // 1. Criados campos MOSTRAR_BOTAO_SEGUIRATENDIMENTO e MOSTRAR_MENU_SEGUIRATENDIMENTO nas tabelas MODULOS_MULTIPAS e MODULOS_PAS
           // 2. Criados os botões para setar os campos criados acima

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.209 30/11/21';
           // 1. Criada Coluna Triagem na tabela de atendentes

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.208 14/09/21';
           // 1. Ajuste para não travar no robo de encaminhar da fila de espera para fila do médico
           // 2. Ajuste para não dar erro no metodo ImprimeSomenteCDB

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.207 31/08/21';
           // 1. Filtro no grid dos botões de tela para listar os botões da tela selecionada e gravar botões novos com o id da tela

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.206 27/08/21';
           // 1. Inclusão das tabelas da Pesquisa de satisfação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.205 12/08/21';
           // 1. Alteração do filtro do select do robo para filtrar pelo campo id_atd_cli

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1.0.204 12/08/21';
           // 1. Inclusão do campo ID_ATD_CLI na tabela ATENDENTES e Exibição na tela

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.1 14/07/21';
           // 1. Inclusão funcionalidade para gravar em banco de dados os parâmetros do TEE
           // 2. Unificação dos scripts do banco de dados para Servidor e Config (na unit uScriptUnidades, comum a ambos e que atua no banco centralizado de Unidades)

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 BETA XX/XX/XX';
           // 1. BT #1543 Correção do bug que impossibilitava adicionar um novo painel.
           // 2. BT #1544 Correção do bug que impossibilitava adicionar uma nova fila
           // 3. BT #1545 Correção do bug que impossibilitava adicionar uma nova PA
           // 4. Impressão de nome e campos adicionais no ticket de senha, conforme parâmetro "DadosAdicionaisAImprimirNaSenha" no INI

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 Rev.B 05/11/19';
           // 1. BT #1429 Criado comando no protocolo para retorna as telas de totem e os botoes das telas - "MultiTelas"
           // 2. BT #1434 Novo comando para o endpoint SCC que devolverá o TEE e TME de uma fila
           // 3. BT #1437 Novos comandos $EA e $EB do protocolo de retrocompatibiliade adicionar o timeout de PA no retorno do comando (para compatibilidade com DLL V1.6)
           // 4. BT #1416 Correção nos novos modelos de totens Slim Button e Slim Touch

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 Rev.A 09/10/19';
           // 1. BT #1377 Na geração de Alarmes no servidor estava gerando erro, problema com os Generators
           // 2. BT #1372 Na geração de senha quando Totem é zero não contar não contabilizar tempo de intervalor para impressão
           // 3. BT #1424 Replicação de alteração na Função dados adcionais feita na V5 para V6 "A respota da função trazia um JSON agora só nome e numero ficha"
           // 4. BT #1420 Alteração necessaria após alteração na consulta de dispositivos feita para o Fleury.
           // 5. BT #1416 Adicionar novos modelos de totens

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 16/08/19';
           // 1. BT #1271 Adicionado no ini opção de retrocompatibilidade para atender integração com SAD.
           // 2. BT #1273 Alteração para atender integração com SAD "Fleury" Dados Adcionais.
           // 3. BT #1305 Criação de novo modelo de totem no cadastro para cadastrar Modelo Multi Telas.
           // 4. BT #1305 Correções para homologação da consulta de tempo de atendimento via API
           // 5. BT #1345 Implementado no servidor um Timer que dispare a consulta à API e atualize o jornal eletrônico "Tempo Unidade HIAE".
           // 6. BT #1355 Replicação do BT #1354 da V5 para a V6 "Bloqueo login de atd na retrocimpatibilidade quando o AtdLogin vier em branco"

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.E 12/08/19';
           // 1. BT #1367 - Alterado a conversão do ID da PA pois estava errada para a conversão de Hexa para o comando $DC.
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.D 16/05/19';
           // 1. BT #1230 - Criado comando para listar totens
           // 2. BT #1232 - Preservado o horário ao inserir em uma fila, uma senha que já está em outra fila
           // 3. BT #1233 - Criado parâmetro permitindo informar se insere a senha no início ou final da fila

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.C 03/05/19';
           // 1. BT #1214 - Alterado a forma do metodo Buscar imagem Fila e Totem

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.B 23/04/19';
           // 1. BT #1205 e #1206 - colocados logs de DEBUG adicionais

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 22/04/19';
           // 1. BT #1205 - Porta TGS se fechava sozinha e não restabelecia, e às vezes não abria ao iniciar aplicação (colocado reopen no CheckConnectionsTimer, a cada 20seg).
           // 2. BT #1206 - Não resolvido porém colocado mensagens de DEBUG adicionais para logar a porta local (PA/MPA ou TGS/OnLine) e o endereço remoto (para ver se tem versão do SICS incompatível nesta máquina remota)

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1.  Adicionado Projeto Totem Slim
           // 2.  Alteração na forma de Redirecionamento de ticket quando está em atendimento
           // 3.  Foram retirados os comandos DA e DB do protocolo os mesmo servia para pedir e receber as informações de Totem, agora ficou no comando 8C padronizado como nos demais módulos.
           // 4.  Criado novo comando no protocolo para atender a solicitação de informações do Totem Slim.
           // 5.  Alteração das units ugenerator e uhttprequest que agora são as ASPGenerator e ASPHTTPRequest.
           // 6.  Alteração no método que retorna informação dos parâmetros do TGS pois antes o mesmo só devolvia o caminho do banco de dados Firebird e agora tem as opções Firebird ou SQLServer.
           // 7.  Alteração no método que retorna informação dos parâmetros do PA e MultiPA pois antes o mesmo só devolvia o caminho do banco de dados Firebird e agora tem as opções Firebird ou SQLServer.
           // 8.  Alteração no método que retorna informação dos parâmetros do OnLine pois agora o Online não acessa mais o banco de dados direto e sim recebe os parâmetros do modulo.
           // 9.  Modificação do arquivo TAGS.DAT sendo persistidas em banco.
           // 10. Implementação em banco de dados dos arquivos PSWD e PSWDIDS da pasta RT.
           // 11. Criação de log de erro caso ocorra erro na gravação dos indicadores no banco de dados.
           // 12. Implementação de Basic Authentication na classe THTTPRequest e organização de código por Regions na classe TPI.
           // 13. Migração DBExpress para Firedac
           // 14. Finalização Migração de DBExpress para Firedac
           // 15. Finalização Suporte ao Banco de Dados SQL Server 2008 RS2 SP2
           // 16. Migração dos arquivos .dat das RT para ficarem direo na base de dados
           // 17. Suporte a Host para conexão pelo servidor pois só era possivel pelo address
           // 18. Retiradas do arquivo .ini tanto leitura quando escrita as propriedades "TcpPort", "TGSTcpPort"
           // 19. Removida a tabela de unidades do Banco do Sics ficando somente no banco de dados do config "Unidades"
           // 20. Alterado todo o sistema para usar a propriedade Host dos componentes Socket ao invés da propriedade Address.onectar.
           // 21. BT #1130 alterado protocoloco para atender o endpoint "ListarPorPA" para atender pelo ID da PA pois estava atendendo pelo ID do Modulo

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.C 20/07/18';
           // 1. BT #1010 - Quando configurava o "Caminho de Update" estava sendo limitado em 50 caracteres.
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.B 20/07/18';
           // 1. BT #1008 - Retirada tela de comandos "MS-DOS" ao fazer o backup
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 16/07/18';
           // 1. BT #1004 - Alteração na configuração de módulos do SICS: Modulo Online novo tamanho de fonte extra grande
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo, ateração de todas as DLLs de xxxx_DX.dll para xxxx_DT.dll
           // 3. Novo módulo e funcionalidades "Call center"
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 29/03/18';
           // 1. BT #909 - A primeira vez que abria o server e não tinha os arquivos de atendente ou PA tava erro.
           // 2. BT #307 - Na configuração de módulos não indexa nem por ID nem nome do módulo no grid à esquerda
           // 2. BT #920 - A configuração realizada via config nos módulos do Sics não era atualizadas automaticamente para o servidor.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
		       // 2. Novas funcionalidades e comandos para funcionar com SCC e Checkin Mobile, incluindo CAMPOS ADICIONAIS e chamada por NOTIFICACAO PUSH]
           // 3. BT #856 - Impressão das senhas estava com modelo de totem Mecaf, mesmo configurado para Seiko.
		       // 4. BT #894 - Correção parcial: Criados layouts de grid clean e cartoes coloridos no OnLine
           // 5. BT #842 e #849 - Criação de um controle remoto para o SicsTV
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 Rev.A 14/12/17';
           // 1. BT #835 - Erro na conexão de Totens
           // 2. BT #838 - Erro na hora de cadastrar Totens não deixa gravar o ID
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificar e eliminar parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #311 - Correção Nas telas de seleção de grupos para cadastros de módulos, permitir seleção usando o teclado
           // 4. BT #314 - Correção TV não chama senha se o campo "Nome no Painel" da PA estiver em branco
           // 5. BT #89  - Correção Tirar menus de Habilitar/Desabilitar botões da impressora
           // 6. BT #326 - Correção Aumentar "String"  do Edit > Nome do Indicador
           // 7. BT #629 - Correção Adicionar um botão com a função de "copiar" do campo nome para o campo Login na tabela de atendentes.
           // 8. BT #633 - Correção Teclado SICS Expert 1200 não conecta no SRV - Erro TimeOut
           // 9. BT #546 - Correção Ao incluir um Atendente no TGS, a tela de "Situação do Atendimento" (menu visualizar) do servidor não exibe o novo atd
           //10. BT #679 - Correção Formatação de PIs Horários
           //11. BT #309 - Correção Tecla ESC não funciona nas telas de cadastro
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.F 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX).
           // 2. BT #595 - Correção
           // 3. BT #42  - Correção
           // 4. BT #582 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.E 02/06/17';
           // 1. Alteração do comando $70, para que retorno a senha gerada
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.D 01/06/17';
           // 1. BT #584 - Nova funcionalidade: criação de configurações na tela de Filas para alterar cor, estilo de fonte (negrito, itálico, sublinhado) e tamanho do nome da fila no online
           // 2. BT #580 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 19/05/17';
           // 1. Criado um novo parâmetro nas configurações do módulo Online para esconder a coluna de Horário/Tempo de Espera na tela de Situação de Espera
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 17/05/17';
           // 1. Correção da interpretação do comando 3A, que espera um ID de Fila em Hexadecimal e estava sendo considerado somente decimal. Alterado de "StrToInt(ProtData)" para "StrToInt('$' + ProtData)"
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. BT #535 - Nova funcionalidade: criação da configuração para exibir Tempo de Espera em forma de cronometro (não mais data/hora da emissão da senha)
           // 2. BT #536 - Nova funcionalidade: configuração dos limiares das filas (para colorir as filas baseado em faixas de tempo de espera)
           // 3. BT #565 - Nova funcionalidade: criada opção para esconder o menu lateral do on-line
           // 4. BT #565 - Nova funcionalidade: criada configuração (no servidor) para selecionar qual tela do módulo ON-lINE será aberta por padrão. Config. default é "NENHUMA".
           // 5. BT #566 - Nova funcionalidade: criada configuração (no servidor) para definir o tamanho da fonte do módulo ON-LINE, sendo possível "NORMAL", "MÉDIA" e "GRANDE".
           // 6. BT #554 - Correção (não estava respeitando a configuração de grupos de PA´s permitidas e opção de visualizar Grupos)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.F 03/04/17';
           // 1. Correção adicional do BT #523
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.E 01/04/17';
           // 1. Correção do BT #523 (inicial)
           // 2. Revisão e realinhamento de componentes nas telas de configuração dos módulos PA, MultiPA, OnLine e TGS
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.D 29/03/17';
           // 1. Correção do BT #512
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 28/03/17';
           // 1. Correção dos BT #299 (trazendo todas as correções da V4 para a V5) e #454
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 27/03/17';
           // 1. Correção dos BT #138 e #456
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.A 27/03/17';
           // 1. Correção do BT #497
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Versão 5.2 apenas para uniformizar versão com os clients. Sem alterações.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Correção do BT #411
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Correção do BT #399
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
           // 2. Implementadas correções que estavam no trunk e se perderam com a migração do 16620 por cima do trunk:
           //    a. Correção do BT #332
           //    b. Correção do BT #342
           //    c. Correção do BT #380
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.D 27/12/16';
           // 1. Nova funcionalidade para impressão do CDB ao encaminhar para uma fila (customização PizzaHut, BT #297)
           // 2. Nova funcionalidade para envio de mensagem de alarme às PAs (BT #303)
           // 3. Correção do bug #300 (não deixava selecionar IdsRelacionados ao selecionar tipos de PIs que se relacionavam a PAs)
           // 4. Correção dos bug #195, #300, #301, #303, #305
           // 5. Inclusão do campo de porta do LCDB nas configurações do módulo PA, possibilitando o uso do LCDB no módulo PA
           // 6. Correção dos bug #319, #310, #331
           // 7. Correção do bug #335
           // 8. Correção do bug #355
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.C 15/12/16';
           // 1. Correção do bug #253 (Inserido novo modelo de totem: TOTEM_MODELO_SILOUETE_RAPIDO, com impressora Seiko)
           // 2. Trazido da V4 - Se ocorrer erro ao decifrar protocolo e o erro for relacionado a dbexpint.dll a conexão será redefinida
           // 3. Trazido da V4 - Removida mensagem de "Erro ao obter titulo de PA" ao se tentar inserir no OutBuffer PAs sem painel atrelado
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.B 01/12/16';
           // 1. Correção do bug #252 (quando rodando como serviço, não inicia)
           // 2. Correção do bug #284 (ajustes de ShortDateFormat e LongTimeFormat)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 10/11/16';
           // 1. Correção do bug #248 (problema com o parâmetro UNINSTALL para desinstalar serviço)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 22/09/16';
           // 1. Versão liberada para produção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 - Em desenvolvimento';
           // 1. Novas funcionalidades para controle de pausas e respectivos relatórios
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.3 Rev.D 28/11/13';
           // 1. Corrigida impressão na LPT ou COM, que não estava funcionando devido a alteração em PrintPassword, feita na V4.3 Rev B - alterada procedure Imprime
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.3 Rev.C 31/07/13';
           // 1. Inserido novo modelo de totem: TOTEM_MODELO_ELGIN, com impressora Nitere Custom
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.3 Rev.B 19/07/13';
           // 1. Inserido novo modelo de totem: TOTEM_MODELO_SILOUETE_TOUCH, com impressora Seiko
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.3 Rev.A 24/04/13';
           // 1. Bug corrigido: inserido comando {{Fim de Bloco Code39}} para impressão de CDB de Atendentes, Filas e PAs
           // 2. Bug corrigido: dava erro quando TAG não tinha cor (campo Null) - agora TAG sem cor mostra "Preta" nos grids
           // 3. Bug corrigido: senhas novas eram inseridas "já com tag" - na realidade, quando inseria uma senha sem tag, o StringGrid mostrava nas colunas de TAGs a sujeira de células já deletadas, aparentando que a senha tinha uma tag
           // 4. Bug corrigido: impressão de gráficos de SLA PP não estava saindo - feita ligação correta com o QR
           // 5. Inserida configuração de opções por totem no BD ao invés do INI (PicoteEntreVias, CorteParcialAoFinal, ImprimirCodigoDeBarrasSenha, ImprimirDataEHoraNaSegundaVia)
           // 6. Inserida aba para gráficos de PP e SLA PP por PP (aba PP)
           // 7. Impressão dos PPs ok (update do KB da versão anterior ("Fazer QR dos PPs") - QR dos PPs feito)
           // 8. Impressão das TAGs ok (update do KB da versão anterior ("Inserir TAGs nos QR analíticos") - TAGs inseridas nos QR analíticos (eventos TE/TA e eventos PP))
           // 9. Alterada nomenclatura interna dos campos dos cds do SLA PP (update do KB da versão anterior ("Gráficos SLA PP ainda estão como ESP") - feito)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.3 12/03/13';
           // 1. Inserida visualização das TAGs de cada senha nas filas
           // 2. Inserido o envio de TAGs no CMD 6Dh
           // 3. Inserida funcionalidade de Processos Paralelos (script para DB, comandos via socket, etc)
           // 4. Bug corrigido: mostrar nome do cliente no relatório analítico (tabela)
           // KB = Gráficos SLA PP ainda estão como ESP, Fazer QR dos PPs, Inserir TAGs nos QR analíticos
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 Rev.E 04/12/12';
           // 1. Inserido novos gráficos (TME/TMA e SLA) por fila de espera
           // 2. Inserida opção de filtro por TAG "não classificado"
           // 3. Bug corrigido: relatórios de SLA impressos (QuickReport) agora apresentam o label da primeira coluna com o tipo do relatório e não genérico "Descrição"
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 Rev.D 09/11/12';
           // 1. Inserida compatibilidade com impressora Fujitsu (necessita atualização da DLL Asp1_D7)
           // 2. Modificação nos modelos dos totens, agora podem cadastrar juntos totens de quaisquer modelos, misturados no mesmo servidor - CustHead deve ser duplicado e renomeado para "CustHeadXX.dll" onde XX é o ID do totem que não utilizará a CustHead.dll
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 Rev.C 16/10/12';
           // 1. Corrigido bug ao setar uma mensagem institucional (pelo Servidor ou TGS) atualiza cdsPaineis, para estar atualizado quando módulo TV pede institucional
           // 2. Modificado comando $73, para envio do nome do cliente junto com a senha na chamada por TV
           // 3. Modificadas funções de obter tipos das impressoras, tiradas do SICS e passadas para a DLL Asp1_D7
           // 4. Incluida visualização do ID do PI, para cadastro de visualização pelo SICS TV
           // 5. Bug corrigido ao receber do TGS comando de ajuste do canal padrão envia para todos os painéis do modelo mpTV
           // 6. Bug corrigido ao enviar alguns comandos para painéis do modelo mpTV estava enviando o endereço do painel, e não o ID
           // 7. Modificado comando $89, incluído o ID da TV à qual o permissionamento se refere
           // 8. Corrigido label na tela de cadastro de grupos de atendentes (estava "atendentess")
           // 9. Atualização do servidor web, implementação de novas TAGs HTML para SenhaChamada (para o label e para o JavaScript)
           //10. Atualização do servidor web, com inclusão de IDs HTML para a tabela de filas de encaminhamento
           //11. Corrigido bug ao emitir relatório de uma Unidade estava mostrando nome dos atendentes (e PAs, Grupos, TAGs, etc) de outra Unidade - problema no LookUp
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 Rev.B 14/08/12';
           // 1. Corrigido bug ao marcar fila como prioritária quando havia filas não ativas
           // 2. Corrigido bug ao gerar nova senha estava colocando antes no grid e aparecia com o nome antigo, agora limpa o cdsTickets e depois coloca no grid e imprime
           // 3. Corrigido bug ao colocar o mouse sobre as barras dos gráficos de SLA estava mostrando o valor da barra tanto no HINT (ok) quanto no Caption do Form (bug corrigido)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 Rev.A 14/06/12';
           // 1. Corrigido impressão para impressora COM ou LPT, AINDA FALTA CHECAR COMENTÁRIOS //LBCTESTAR!!
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.2 02/06/12';
           // IMPORTANTE! VERSÕES ANTERIORES NÃO FUNCIONAM COM 4.2. TODOS OS MÓDULOS, PARA FUNCIONAREM EM CONJUNTO, DEVEM POSSUIR V4.2 OU ACIMA
           // 1. Adicionado nome do cliente
           // 2. Adicionado parâmetro no INI para bloquear configuração de atendentes, PIs e Prioridade de Atendimento
           // 3. Implementação de valor de um PI no alarme de outro
           // 4. Cadastro de mensagens de rodapé das impressoras no banco e por totem
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.1 Rev.C 28/11/11';
           // 1. Inserido modelo de painel 4120C, com funcionalidade de apresentar o nome da fila no painel, de acordo com o range da senha
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.1 Rev.B 28/11/11';
           // OBS - Pulou a "Rev.A" para ficar com mesma versão no server e em todos os clients.
           // 1. Bug corrigido - Proteção da rotina de recebimento de requisições WEB para não levantar duas threads e acabar derrubando o servidor (vide problema na OS 8159)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.1 06/05/11';
           // 1. Implementação de TAGs
           // 2. Implementação de Relatórios SLA
           // 3. Relatórios agora pode ir direto aos gráficos, rotina acelerada e via query em banco
           // 4. Implementação de Totem Touch e impressora Zebra
           // 5. Aprimoramento da tela de status das conexões TCP/IP, novo botão "Atualiza"
           // 6. Novo campo em banco: Nome da Fila no Totem
           // 7. Exclusão do generator no cadastro de totens (agora deve ser preenchido manualmente)
           // 8. Bug corrigido: Tela de configuração das mensagens institucionais não aparecia lista de comandos
           // 9. Bug corrigido: Na ASP1_D7.DLL => Inserção de parâmetro timeout de PING, para funcionar em Windows 2008 Server
           // => Em tentativas de log em pasta não autorizada, registra na pasta de instalação, e após tentativas reconfigura isto no INI
           // 10. Inserção de socket para retrocompatibilidade com V3, especialmente relacionado a projeto Branding Fleury
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.O 29/04/11';
           // Versão de testes para branding fleury
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.N 16/12/10';
           // 1. Remoção de um botão de testes que foi inadvertidamente deixado na tela principal
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.M 13/12/10';
           // 1. Cadastro de totens no banco
           // 2. Reposicionamento dos menus em "Configurações Avançadas"
           // 3. Funcionamento dos painéis BetaBrite e alpha220 (necessário update de AspEzPor_D7.dll)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.L 25/06/10';
           // 1. Indexação do relatório por faixa de senhas, para que não saia desordenado (OS 6277)
           // 2. Inclusão do modelo de painel 2411 e comandos do PrintPak português e inclusive BetaPrism
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.K 26/05/10';
           // 1. Não envia mais KEEPALIVE para clientes -> TESTAR, CASO NÃO SEJA ESTE O PROBLEMA, RETORNAR
           // 2. Não tem Delay dentro de PrintPswd
           // 3. Não tem mais ProcessMessages entre os comandos enviados aos teclados
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.J 25/05/10';
           // 1. Alteração na rotina de ChamaEspecifica e de AtualizaSenhaCountLabel, para tentar evitar loop infinito
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.I 24/05/10';
           // 1. Habilitados alguns ProcessMessages
           // 2. Incluidas opções de Debug, inclusive log em arquivo
           // 3. Nova tela de status das conexões TCP/IP
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.H 21/05/10';
           // 1. Ao fazer AutoLogin não faz SavePswds um a um e sim uma vez só, ao final
           // 2. Várias rotinas aceleradas, com cdsClones, cdsRegistraEvento e cdsRegistraTickets não fecham mais, etc
           // 3. Bug corrigido: ao imprimir senha não vem mais com horário da anterior
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.G 14/05/10';
           // 1. Aceleradas várias rotinas, dentre elas a LoadPswds (servidor sobe muito mais rápido)
           // 2. Consertado bug ao atualizar as senhas detalhadas para filas do OnLine (não enviava duas senhas na mesma fila caso estivessem com mesmo horário)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.F 03/05/10';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.E 28/04/10';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.D 31/03/10';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.C 27/01/10';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.B 14/12/09';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 Rev.A 24/11/09';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.0 BETA  10/11/09';
{$ENDREGION}  {$ENDIF CompilarPara_SICS}

{$REGION 'SICS Config'} {$IFDEF CompilarPara_CONFIG}
    VERSAO = 'ASPECT Mídia'#13'Versão 7.3.1.134 16/05/25';
            //1. - SICS-35 Retirar a opção de Nenhuma (Finalizar atendimento) Fluxo consultórios

//    VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.134 04/12/23';
            //1. - SICS-35 Retirar a opção de Nenhuma (Finalizar atendimento) Fluxo consultórios

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.133 08/07/23';
            //1. - CARD SICS-66 SICS TV com as configurações salvas em um BD

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.132 23/06/23';
            //1. - SICS-8 Quando cria nova unidade no config não cria a nova no DB version
            //2. - SICS-9 Não cria atendentes na unidade nova
            //3. - SICS-10 No TGS na situação de espera o nome fica bugado
            //4. - SICS-11 No indicadores de performance aba Alarmes, o horário não aparece para configurar.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.131 26/05/23';
            //1. - CARD 2996 - Parâmetro p/ Ajustar Online com muitos grupos de TAGs

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.130 06/04/23';
           // 1. Compatibilidade Sics Versão 7.2.0.234

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.129 31/03/23';
           // 1. Jira Card 2363 - Alterar SICS Config e Servidor para cadastro de 1 novo campo na tabela MODULOS_ONLINE

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0.128 24/03/23';
           // 1. Jira Card 2363 - Alterar SICS Config e Servidor para cadastro dos 4 novos campos nas tabelas MODULOS_PAS e MODULOS_MULTIPAS
           // 2. Banco de dados na versão 473

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.3.1 20/10/22';
           // 1. Correção de bug que estava travando o SCC quando o pacote do protocolo SICS vinha "incompleto" ou dividido em pacotes menores

//VERSAO = 'ASPECT Mídia'#13'Versão 7.3.0 11/09/22';
           // 1. Novos Indicadores de Performance para apresentar valor do banco de dados
           // 2. Banco de dados na versão 462

//VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0 07/06/22';
           // 1. Novas stored procedures para devolver a quantidade de senhas e os alarmes ativos por PA
           // 2. Banco de dados na versão 458

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0.123 20/06/22';
           // 1. Ajustes nos scripts para funcionar com SQLServer e com base já migrada. Banco de dados na versão 456 (atenção pois diminuiu com os ajustes!).

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.2.0 07/06/22';
           // 1. Banco de dados na versão 460

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.118 29/03/22';
           // 1. Jira Card 919 - Criação de campo para marcar se no SicsPA e no SicsMPA marcara tag automaticamente quando encaminhar senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.117 07/03/22';
           // 1. Criação de campo para marcar se no SicsMPA exibirá o Painel de Grupos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.116 30/12/21';
           // 1. Banco de dados na versão 371

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.114 17/12/21';
           // 1. Banco de dados na versão 367

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.113 16/12/21';
           // 1. Banco de dados na versão 357

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.112 09/12/21';
           // 1. Banco de dados na versão 356

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.107 31/08/21';
           // 1. Filtro no grid dos botões de tela para listar os botões da tela selecionada e gravar botões novos com o id da tela
           // 2. Banco de dados na versão 352

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0 14/07/21';
           // 1. Unificação dos scripts do banco de dados para Servidor e Config (na unit uScriptUnidades, comum a ambos e que atua no banco centralizado de Unidades)

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.B 21/10/19';
           // 1. BT #1432 Existia Linhas Repetidas no Script.

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 09/10/19';
           // 1. BT #1420 Alteração necessaria após alteração na consulta de dispositivos feita para o Fleury.
           // 2. Adição da DataHora da ultima vez que um dispositivo foi visto online pelo monitor
           // 3. Adição dos regions nos métodos do servidor que monitoram os devices
           // 4. Adicionada validação no método que registra um device para o TGS Mobile, evitando gravar sem id/nome
           // 5. Alterações no Config para Filtrar unidades e reposicionar botão Devices

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1.  Alteração no Config para ter seleção do Tipo do Banco SQL ou Firebird
           // 2.  Migração DBExpress para Firedac
           // 3.  Finalização Migração de DBExpress para Firedac
           // 4.  Finalização Suporte ao Banco de Dados SQL Server 2008 RS2 SP2
           // 5.  Alterado a estrutura do Banco de Dados as propriedades retirada do .ini do Servidor agora são atribuidas e modificadas por campos da tabela unidades
           // 6.  Tabelas do PlaylistManager agora estão no banco de dados do config "Unidades" sendo assim eliminado o banco de dados do PlaylistManager
           // 7.  Criada Tabela de Devices para contem informações do projeto SmartSurvey
           // 8.  Criada Tabela de Generators para os Generators funciona tanto no Banco de dados Firebird quanto no SQLServer
           // 9.  Criação do cadastro de grupos
           // 10. Alterado todo o sistema para usar a propriedade Host dos componentes Socket ao invés da propriedade Address.

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.B 20/07/18';
           // 1. BT #1007 - Adicionado a opção de configuração para o módulo Call Center
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 16/07/18';
           // 1. BT #1004 - Alteração na configuração de módulos do SICS: Modulo Online novo tamanho de fonte extra grande
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo, ateração de todas as DLLs de xxxx_DX.dll para xxxx_DT.dll
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.B 03/05/18';
           // 1. BT #327 - Correção adicional colocando aumento do campo via script no BD
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 29/03/18';
           // 1. BT #307 - Na configuração de módulos não indexa nem por ID nem nome do módulo no grid à esquerda
           // 2. BT #920 - A configuração realizada via config nos módulos do Sics não era atualizadas automaticamente para o servidor.
           // 3. BT #923 - Quando criava um novo atendente ou renomeaiva o login via Config ele não assumia as novas nomenclaturas.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build da versão 5.5 para compatibilizar com 5.5 do Servidor. Houve alteração na versão do banco (inclusão de novos scripts).
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificar e eliminar parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #309 - Correção Tecla ESC não funciona nas telas de cadastro
           // 4. BT #311 - Correção Nas telas de seleção de grupos para cadastros de módulos, permitir seleção usando o teclado
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.E 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX). Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.D 01/06/17';
           // 1. BT #584 - Nova funcionalidade: criação de configurações na tela de Filas para alterar cor, estilo de fonte (negrito, itálico, sublinhado) e tamanho do nome da fila no online
           // 2. BT #580 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 19/05/17';
           // 1. Criado um novo parâmetro nas configurações do módulo Online para esconder a coluna de Horário/Tempo de Espera na tela de Situação de Espera
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 18/05/17';
           // 1. Adicionado a coluna ID na grid de Unidades, para facilitar a configuração do INI do TGS Multi-unidades (BT #561)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. Build da versão 5.3.1 para compatibilizar com 5.3.1 Servidor.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.4 04/04/17';
           // 1. Build da versão 5.2.4 para compatibilizar com 5.2.6 Servidor. Houve alteração no data module para última versão do banco.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 01/04/17';
           // 1. Build da versão 5.2.3 para compatibilizar com 5.2.5 Servidor. Houve alteração na versão do banco (inclusão de novos scripts).
           // 2. Revisão e realinhamento de componentes nas telas de configuração dos módulos PA, MultiPA, OnLine e TGS
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 27/03/17';  //propositadamente "pulou" a Rev.A
           // 1. Build da versão 5.2.2 para compatibilizar com 5.2.2 Servidor. Houve alteração na versão do banco (inclusão de novos scripts).
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Versão 5.2 apenas para uniformizar versão com os clients. Sem alterações.
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Build da versão 5.1.2 para compatibilizar com 5.1.2 do Servidor. Houve alteração na versão do banco (inclusão de novos scripts)
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Apenas build da versão 5.1.1, para compatibilizar com 5.1.1 do Servidor
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.0 Rev.A 08/12/2016';
           // 1. Correção do Midas (estava com "Midas" no uses, ao invés de "Midaslib")
{$ENDREGION}  {$ENDIF CompilarPara_CONFIG}

{$REGION 'SICS PA'} {$IFDEF CompilarPara_PA}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.22 05/01/24';
           // HIAE-5244 Melhoria no campo de observação nos módulos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.21 04/12/23';
           // SICS-35 Retirar a opção de Nenhuma (Finalizar atendimento) Fluxo consultórios

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.20 25/10/23';
           // 1. SICS-58 Marcar mais de uma TAG por grupo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.19 08/09/23';
           // 1. HIAE-4232 Adicionar na PA, MultiPA e OnLine o campo de Observações nos dados adicionais da senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.18 08/09/23';
           // 1. HIAE-4124 Permitir copiar os textos dos módulos.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.17 04/07/23';
           // 1. Jira Card HIAE-2869 Criar backend para consumir APIs do SIAF - Módulos SICS.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.16 29/03/23';
           // 1. Jira Card 2367 - Melhoria na visualização das TAGs módulo PA.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.15 16/02/23';
           // 1. Aparecer prontuário do paciente Módulo PA e Online.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.3.14 30/01/23';
           // 1. Jira Card 1823 - Implementar alerta sonoro ao enviar pop-up com os PIs.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.14 22/09/22';
           // 1. Jira Card 1485 - Compilar Api ObterDados enviando convênio modular.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.13 13/09/22';
           // 1. Jira Card 1315 - Opção de colocar em pausa a PA e conseguir utilizar o Botão de "Seguir o Atendimento"

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.12 05/05/22';
           // 1. Jira Card 919 - Ajuste memorizar senha e idunidade antes de iniciar o processo de encaminhar

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.11 29/03/22';
           // 1. Jira Card 919 - Marcar Tag Automatica quando Senha for encaminhada.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.10 23/02/22';
           // 1. Ajuste gravar IdTrakCare nos dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.9 21/02/22';
           // 1. Ajuste gravar CodEpisodio nos dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.8 09/12/21';
           // 1. Banco de dados na versão 356

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.5 06/12/2021';
           // 1. Inclusão de APIs de Fila, PA, Atendente.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.5 06/12/2021';
           // 1. Ajuste para gravar os dados adicionais na senha e encaminhar para a Triagem/Consultório/Fila de espera

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.4 06/10/2021';
           // 1. Ajuste para a conexão acontecer rapidamente utilizando o sleep de 1 segundo apenas no COMPILAPARA_TGS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.1 23/08/2021';
           // 1. Card 277 - Criação de Parâmetro para que o Módulo PA inicie no canto superior esquerdo da tela ou na ultima posição deixada.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 Rev.A 13/08/20';
           // 1. BT #1555 - Ao fechar e abrir módulo PA, estava saindo para fora da tela
           // 2. BT #1556 - Lentidão na operação do SICS PA (estava solicitando N vezes as senhas em espara para o grid Visualizar Pessoas Na Fila)
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.B 26/09/19';
           // 1. BT #1414 Adicionado opção de Closed Caption no Controle Remoto da PA
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 16/08/19';
           // 1. BT #1342 Mudança na apresentação de TAGS para apresentar TAG ativa na tela
           // 2. BT #1367 Alteração no metodo que carregava Lista de Cliente em espera pois quando o ID do modulo era 2 casas decimais não carregava.
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1. Migração DBExpress para Firedac
           // 2. BT #1071 Solucionado problema quando era atribuida uma TAG para a senha travava.
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.C 09/04/18';
           // 1. BT #855 - Evitar duplo clique nos botões, principalmente botão próximo
           // 2. BT #552 - Evitar a perda de comandos caso cheguem concatenados via socket
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.B 29/03/18';
           // 1. BT #539 - Quando abria a tela de motivos de pausa o botão fica laranja porém, se fechasse a telas sem por a pausa permanecia laranja.
           // 2. BT #472 - Controlar limite de dias do LOG.
           // 3. BT #942 - Deixar o hint das TAGS de uma unica cor.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 05/03/18';
           // 1. BT #910 - Ao abrir 2 módulos diferentes na mesma máquina, o 2o módulo não conseguia abrir a porta 6030 e não respeitava o INI
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
           // 2. BT #807 - Colocado no INI a linha "TCPSelfPort=6030" como Default
           // 3. BT #821 - APK - SICSPA 5.4 não sobe
           // 4. BT #842 e #849 - Criação de um controle remoto para o SicsTV
           // 5. BT #873 - Controle remoto estava operando porém, quando temos configurado no painel mais de um IP apresentava erro de Socket.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificar e eliminar parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #628 - Correção Tela de configuração de Módulo, Porta, IDMódulo e IP não aparece mais quando abre o módulo pela primeira vez.
           // 4. BT #42  - Correção Alterar o tipo de mensagem para Alerta - Um processo do aplicativo...
           // 5. BT #501 - Correção Ajustar (ou remover de vez) a função "CarregarParametrosViaDB" do dmConnection
           // 6. BT #500 - Correção PA fica cinza ao estar em modo terminal server
           // 7. BT #83  - Correção Liberar escolha de PA quando for usar a opção de Terminal Server
           // 8. BT #538 - Correção Duplo clique nas telas de pausa e encaminhamento para atribuir a pausa ou encaminhar a senha sem a necessidade do OK
           // 9. BT #69  - Correção Não é possível finalizar os processos paralelos
           //10. BT #665 - Correção Tratar abertura do módulo em outro usuário ou no mesmo
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX).
           // 2. BT #598 - Correção
           // 3. BT #599 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 01/06/17';
           // 1. Alterado o protocolo que fornece o nome das filas por conta do BT #584
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. Compatibilização com a alteração do protocolo com relação a cor das filas (por limiar/tempo de espera)
           // 2. Correção dos BT #85, #539, #544 e #551
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 29/03/17';
           // 1. Correção dos BT #351, #513 e #514
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 28/03/17';
           // 1. Correção dos BT #299 (trazendo todas as correções da V4 para a V5) e #389
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.A 27/03/17';
           // 1. Correção dos BT #352, #475, #474, #482, #483, #485, #461 e #497
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Primeira versão com skins
           // 2. Correção dos BT #463, #343 e #470
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Correção dos BT #373, #374 e #405
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Correção do BT #369
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 11/11/16';
           // 1. Correção do bug #211 (mensagem de erro de socket que não deveria aparecer)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 22/09/16';
{$ENDREGION}  {$ENDIF CompilarPara_PA}

{$REGION 'SICS MultiPA'} {$IFDEF CompilarPara_MULTIPA}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.11 04/12/2023';
           // SICS-35 Retirar a opção de Nenhuma (Finalizar atendimento) Fluxo consultórios

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.10 01/12/2023';
           // 1. HIAE SICS-58 Marcar mais de uma TAG por grupo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.9 08/09/2023';
           // 1. HIAE-4232 Adicionar na PA, MultiPA e OnLine o campo de Observações nos dados adicionais da senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.8 08/09/2023';
           // 1. HIAE-4124 Permitir copiar os textos dos módulos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.7 04/07/2023';
           // 1. Card Jira HIAE-2869 Criar backend para consumir APIs do SIAF - Módulos SICS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.6 24/03/2023';
           // 1. Card Jira 2812 - Melhoria na visualização das TAGs módulo PA.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.5 21/03/2023';
           // 1. Card Jira 1160 - Correção grupo de PAs limpando seleção.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.2.4 30/01/2023';
           // 1. Jira Card 1823 - Implementar alerta sonoro ao enviar pop-up com os PIs.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.4 22/11/2022';
           // 1. Jira Card 1485 - Compilar Api ObterDados enviando convênio modular.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.3 05/05/2022';
           // 1. Jira Card 919 - Ajuste memorizar senha e idunidade antes de iniciar o processo de encaminhar

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.2 29/03/2022';
           // 1. Jira Card 919 - Marcar Tag Automatica quando Senha for encaminhada.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.1.1 08/03/2022';
           // 1. Jira Card 795 - Criação do painel de grupos de PAs

//  VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 16/08/19';
           // 1. BT #1342 Mudança na apresentação de TAGS para apresentar TAG ativa na tela

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1.  Migração DBExpress para Firedac
           // 2.  BT #1071 Solucionado problema quando era atribuida uma TAG para a senha travava.

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.B 29/03/18';
           // 1. BT #539 - Quando abria a tela de motivos de pausa o botão fica laranja porém, se fechasse a telas sem por a pausa permanecia laranja.
           // 2. BT #472 - Controlar limite de dias do LOG.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 05/03/18';
           // 1. BT #910 - Ao abrir 2 módulos diferentes na mesma máquina, o 2o módulo não conseguia abrir a porta 6030 e não respeitava o INI
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
           // 2. BT #807 - Colocado no INI a linha "TCPSelfPort=6030" como Default
           // 3. BT #907 - Opção de encaminhamento de senha não estava OK via LCDB.
           // 4. BT #908 - Ao passar o leitor no cod do atendente abria a opção de login e não selecionava a PA para chamar a senha, mesmo a PA logada
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificar e eliminar parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #628 - Correção Tela de configuração de Módulo, Porta, IDMódulo e IP não aparece mais quando abre o módulo pela primeira vez.
           // 4. BT #42  - Correção Alterar o tipo de mensagem para Alerta - Um processo do aplicativo...
           // 5. BT #501 - Correção Ajustar (ou remover de vez) a função "CarregarParametrosViaDB" do dmConnection
           // 6. BT #538 - Correção Duplo clique nas telas de pausa e encaminhamento para atribuir a pausa ou encaminhar a senha sem a necessidade do OK
           // 7. BT #69  - Correção Não é possível finalizar os processos paralelos
           // 8. BT #495 - Correção Colocar o tempo limpar PA em segundos ( hoje esta em ms)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.D 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX).
           // 2. BT #598 - Correção
           // 3. BT #599 - Correção
           // 3. BT #368 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 01/06/17';
           // 1. Alterado o protocolo que fornece o nome das filas por conta do BT #584
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 18/05/17';
           // 1. Remoção do AniIndicator da tela principal e do Application.ProcessMessages que havia na procedure que cria os PAs
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. Compatibilização com a versão do servidor, 5.3.1
           // 2. Correção dos BT #85, #539 e #551
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 29/03/17';
           // 1. Correção dos BT #351, #513 e #514
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 28/03/17';
           // 1. Correção dos BT #299 (trazendo todas as correções da V4 para a V5) e #389
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.A 27/03/17';
           // 1. Correção dos BT #352, #475, #474, #482, #483, #485, #461 e #497
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Primeira versão com skins
           // 2. Correção dos BT #463 e #470
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Correção do BT #405
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Build de versão 5.1.1 para uniformizar versões entre os módulos
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 11/11/16';
           // 1. Correção do bug #211 (mensagem de erro de socket que não deveria aparecer)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 22/09/16';
{$ENDREGION}  {$ENDIF CompilarPara_MULTIPA}

{$REGION 'SICS TGS'} {$IFDEF CompilarPara_TGS}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.130 23/06/2023';
            //1. - SICS-8 Quando cria nova unidade no config não cria a nova no DB version
            //2. - SICS-9 Não cria atendentes na unidade nova
            //3. - SICS-10 No TGS na situação de espera o nome fica bugado
            //4. - SICS-11 No indicadores de performance aba Alarmes, o horário não aparece para configurar.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.129 28/04/2023';
           // 1. .

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.128 17/04/2023';
           // 1. .

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.127 13/02/2023';
           // 1. Novo tipo de Indicador de Performance TEE_CSC.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.126 22/11/2022';
           // 1. Jira Card 1485 - Compilar Api ObterDados enviando convênio modular.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.125 03/05/22';
           // 1.  Correção na abertura dos Datasets que alimentam os NestedDataset de cada unidade o uso do qryAux.Params.ParamByName não funcionou, incluido o id da unidade na instrucao sql

//VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1.  Adicionado TML(Tempo Médio Login) nos relatórios e gráficos do TGS.
           // 2.  BT #1016 Quando configurado como Call Center não estava respeitando os filtros de coordenadores e atendentes.
           // 3.  BT #1017 Alteração no tamanho da apresentação do campo Ativo.
           // 4.  BT #1018 Por alteração no Stile não era possivel ver em qual celular estava o focu do mouse no grid.
           // 5.  BT #1019 Quando incluia um novo usuário não apresenta a opção do grupo.
           // 6.  Migração DBExpress para Firedac
           // 7.  BT #1036 Mudança no protocolo para integração da DLL com o SAD.
           // 7.  BT #1040 Na exportação não estava vindo o campo unidade, quando o mesmo era multiunidades.
           // 8.  BT #1041 Os filtros para o relatório de login não estava respeitando a seleção problema na montagem do SQL.
           // 9.  BT #1048 Não estava aparecendo a opção de adcionar o grupo na inclusão de atendente ou colaborador.
           // 10. Alteração no TGS no Dashboard gerado pela maneira nova de trabalhar com os indicadores
           // 11. Finalização Migração de DBExpress para Firedac
           // 12. Finalização Suporte ao Banco de Dados SQL Server 2008 RS2 SP2

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.A 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
           // 2. Adicionada nova aba no Relatório de Gráficos no TGS quando Call Center
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo
           // 3. Novos relatórios para o Call Center
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.C 23/04/18';
           // 1. BT #945 Colocado na prioridade de atendimento as teclas de atalho "PageUp" e "PageDown" para alternar entre as PA´s.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.B 29/03/18';
           // 1. BT #508 - Removida do udmSicsMain as tabelas não usadas no TGS
           // 2. BT #472 - Controlar limite de dias do LOG.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 05/03/18';
           // 1. BT #910 - Ao abrir 2 módulos diferentes na mesma máquina, o 2o módulo não conseguia abrir a porta 6030 e não respeitava o INI
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
           // 2. BT #704 - Quando selecionava o indicador de "Tempo Estimado de Espera" pelo TGS, não apareciam as filas
           // 3. BT #705 - Ao selecionar o indicador "Combinação de indicadores" e cancelar, as opções de seleção do indicador não estavam se alterando
           // 4. BT #728 - Indicador de performance de TMA (Novo Indicador), apresentava valor muito alto.
           // 5. BT #807 - Colocado no INI a linha "TCPSelfPort=6030" como Default.
           // 6. BT #813 - Colocado no INI do TGS as Opções de MultiUnidades como default
           // 7. BT #904 - Ao emitir relatórios em TABELA o campo de TAGs ficava em branco.
           // 8. BT #905 - Nas configurações, atendentes não era possível saber qual atendente esta selecionado no Grid.
           // 9. BT #906 - Estava sendo possível manipular os dados do relatório TME/TMA nas seguintes abas do Grid: Atendete/PA/Fila Espera/Faixa Senhas/TAG.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificar e eliminar parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #628 - Correção Tela de configuração de Módulo, Porta, IDMódulo e IP não aparece mais quando abre o módulo pela primeira vez.
           // 4. BT #326 - Correção Aumentar "String"  do Edit > Nome do Indicador
           // 5. BT #546 - Correção Ao incluir um Atendente no TGS, a tela de "Situação do Atendimento" (menu visualizar) do servidor não exibe o novo atd
           // 6. BT #42  - Correção Alterar o tipo de mensagem para Alerta - Um processo do aplicativo...
           // 7. BT #520 - Correção Ocultar a barra lateral para ampliar o espaço das telas
           // 8. BT #501 - Correção Ajustar (ou remover de vez) a função "CarregarParametrosViaDB" do dmConnection
           // 9. BT #547 - Correção Atualização dos dados ao abrir telas de configuração
           //10. BT #627 - Correção Opção "Senhas", do relatório de Processos Paralelos, permite inserir valores de 0 a 100, nos campos "De" e "Até"
           //11. BT #625 - Correção CheckBox do "Período (de início)" do relatório de Processo Paralelo se "desabilita" ao marcar e desmarcar o campo
           //12. BT #622 - Correção Não exporta Relatório de Processos Paralelos (Relatório Tabela)
           //13. BT #623 - Correção Apresenta relatório de Processos Paralelos com dados errados
           //14. BT #660 - Correção Relatórios apresentam resultados errados
           //15. BT #662 - Correção Ao acessar pela segunda vez a tela de relatório SLA, apresenta a mensagem  Name not Unique in this context
           //16. BT #663 - Correção Retirar borda preta, deixar igual ao Online
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX).
           // 2. Nova funcionalidade - TGS MultiUnidades com Dashboards entre Unidades
           // 3. BT #607 - Nova funcionalidade - totalizador de PAs e ATDs por tipo de status (Em atendimento, Disponível, Em pausa, etc)
           // 4. BT #591 - Nova funcionalidade
           // 5. BT #540 - Correção
           // 6. BT #555 - Correção
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 01/06/17';
           // 1. Correção do bug #571
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. Corrigido problema com apresentação dos grupos de PAs, que apresentava "???" BT #554
           // 2. Ao alterar a unidade selecionada, caso esteja em alguma tela do menu "Tempo Real", a tela é atualizada automaticamente #BT560
           // 3. Correção dos BT #19, #534 e #540
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.G 06/04/17';
           // 1. Correção dos BT #528, #509 e #519
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.F 04/04/17';
           // 1. Correção dos BT #523
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.E 29/03/17';
           // 1. Correção dos BT #453
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.D 28/03/17';
           // 1. Correção dos BT #299 (trazendo todas as correções da V4 para a V5), #489 e #496
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 27/03/17';
           // 1. Correção dos BT #138 e #456
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 27/03/17';
           // 1. Correção dos BT #452, #416, #474, #453, #459, #476 e #477
           // 2. Alteração nos layouts das telas de gráfico (TMA/TME, Pausas e PPs)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.A 20/03/17';
           // 1. Correção do BT #488
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Primeira versão com skins
           // 2. Correção dos BT #463 e #470
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Correção dos BT #410, #411, #416 e #418
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Correção do BT #412
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 11/11/16';
           // 1. Correção do bug #211 (mensagem de erro de socket que não deveria aparecer)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 22/09/16';
{$ENDREGION}  {$ENDIF CompilarPara_TGS}

{$REGION 'SICS OnLine'} {$IFDEF CompilarPara_ONLINE}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.185 25/10/2023';
           // 1. HIAE-SICS-58 Marcar mais de uma TAG por grupo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.184 08/09/2023';
           // 1. HIAE-4232 Adicionar na PA, MultiPA e OnLine o campo de Observações nos dados adicionais da senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.183 08/09/2023';
           // 1. HIAE-4124 Permitir copiar os textos dos módulos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.182 04/07/2023';
           // 1. Card Jira HIAE-2869 Criar backend para consumir APIs do SIAF - Módulos SICS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.181 17/05/2023';
           // 1. Card 2996 - Ajustar Online com muitos grupos de TAGs.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.180 29/03/2023';
           // 1. Jira Card 2366 - Melhoria na visualização das TAGs módulo OnLine.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.179 16/02/2023';
           // 1. Jira Card 1485 - Compilar Api ObterDados enviando convênio modular.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.178 22/11/2022';
           // 1. Jira Card 1485 - Compilar Api ObterDados enviando convênio modular.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.177 23/02/2022';
           // 1. Ajuste gravar idTrakCare nos dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.176 21/02/2022';
           // 1. Ajuste gravar CodEpisodio nos dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.175 16/10/19';
           // 1. Banco de dados na versão 356
           // 2. Criaçde itens de menu para encaminhas para as filas da triagem e impressão da etiqueta

//  VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 16/10/19';
           // 1. BT #1430 - Correção no Modulo Online para quando tinha mais de uma pagina de filas os Edits de inserir senha são desenhado o da pagina 2 por cima do da pagina 1

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1. Mudança no Modulo Online para o mesmo receber seus parâmetros não mais ir buscar no banco de dados.

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.B 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 16/07/18';
           // 1. BT #1004 - Nova fonte extra grande
           // 2. BT #1005 - Inclusão da rotina de update para ficar genérica e poder atender todos os projetos
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.B 29/03/18';
           // 1. BT #913 - O popup do click com o botão direito para excluir uma ou todas as senhas não estava sendo ativado
           // 2. BT #914 - Foi eleminida as linhas brancas nas laterais dos grids e nos cartões
           // 3. BT #915 - Colocado a linha no final dos retângulos das filas
           // 4. BT #901 - Quando não informado a impressora comandada gerava senha para o totem de ID 1.
           // 5. BT #472 - Controlar limite de dias do LOG.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 05/03/18';
           // 1. BT #910 - Ao abrir 2 módulos diferentes na mesma máquina, o 2o módulo não conseguia abrir a porta 6030 e não respeitava o INI
           // 2. BT #911 - Não estava aparecendo o horário de cada senha na situação da espera
           // 3. BT #912 - Tinha um ListBox de debug "sobrando" na tela da situação da espera
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
           // 2. BT #807 - Colocado no INI a linha "TCPSelfPort=6030" como Default.
		       // 3. BT #894 - Correção parcial: Criados layouts de grid clean e cartoes coloridos
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #524 - Verificado e eliminado parametros não utilizados dos vgParametrosDoModulo
           // 3. BT #628 - Correção: Tela de configuração de Módulo, Porta, IDMódulo e IP não estavam aparendo quando abre o módulo pela primeira vez.
           // 4. BT #624 - Correção: Tela "Visualizar | Processos Paralelos" ficava em branco após abrir módulo OnLine
           // 5. BT #42  - Correção: Alterado tipo de mensagem para Alerta - Um processo do aplicativo...
           // 6. BT #520 - Correção: Ocultada a barra lateral para ampliar o espaço das telas
           // 7. BT #455 - Correção: Impressora Comandada não respeitava o ID da impressora e sim a ordem da tabela.
           // 8. BT #666 - Correção: Quando o computador estava sem rede o Online não desconectava
           // 9. BT #667 - Correção: O Online ocasionava um erro de Decifra Protocolo - Item not found
           //10. BT #608 - Correção: Online travava no Delboni Jardim Sul
           //11. BT #501 - Correção: Ajustada a função "CarregarParametrosViaDB" do dmConnection
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.F 25/08/17';
           // 1. Correção dos BTs #608, #666, #667, para atender HCOR (necessário criar campo manualmente no banco)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.E 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX).
           // 2. BT #607 - Nova funcionalidade - totalizador de PAs e ATDs por tipo de status (Em atendimento, Disponível, Em pausa, etc)
           // 3. Correção dos BTs #558, #592, #596 e #606
           // 4. Correção parcial do BT #590 (implementada uma solução temporária somente para o HCor, na tela de situação de Espera)
           // 5. Correção parcial do BT #608 (implementada uma solução temporária, necessário aprimorar para solução definitiva)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.D 02/06/17';
           // 1. Adicionado os comandos C6, B8 e B9 no protocolo, para que não sejam interpretados como "desconhecidos"
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 01/06/17';
           // 1. Criado novos parametros na configurações de fila no servidor para alterar a fonte do nome da fila (BT #584)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 19/05/17';
           // 1. Criado um parâmetro no servidor para esconder a coluna de Horário/Tempo de Espera
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. BT #535 - Nova funcionalidade: Criada configuração para apresentar o tempo de espera no formato cronometro (não mais data/hora de emissão)
           // 2. BT #536 - Nova funcionalidade: Criado limiar para colorir filas baseado no tempo de espera
           // 3. BT #520 - Nova funcionalidade: Criada opção para ocultar o menu lateral
           // 4. BT #554 - Correção: Corrigido problema com apresentação dos grupos de PAs, que apresentava "???"
           // 5. Criada configuração para definir qual tela será aberta por padrão ao iniciar o módulo
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.F 04/04/17';
           // 1. Correção dos BT #526 e #529
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.E 01/04/17';
           // 1. Correção dos BT #521, #525 e #511
           // 2. KB #529 - não funciona modo touch - NÃO USAR ESTA VERSÃO!
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.D 29/03/17';
           // 1. Correção do BT #479
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.C 28/03/17';
           // 1. Correção dos BT #299 (trazendo todas as correções da V4 para a V5) e #478
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.B 27/03/17';
           // 1. Correção do BT #474
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 Rev.A 17/03/17';
           // 1. Correção dos BT #473 (comentado o Enable do animate do Form Touch)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Primeira versão com skins
           // 2. Correção dos BT #463 e #470
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Build de versão 5.1.2 para uniformizar versões entre os módulos
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Correção do BT #399
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 11/11/16';
           // 1. Correção do bug #211 (mensagem de erro de socket que não deveria aparecer)
           // 2. Correção do bug #215 (trava servidor ao clicar nos check boxes de bloquear e prioritaria
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 22/09/16';
{$ENDREGION}  {$ENDIF CompilarPara_ONLINE}

{$REGION 'SICS TV'} {$IFDEF CompilarPara_TV}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.0.152 Rev.A 28/07/2023';
            //1. - CARD SICS-66 SICS TV com as configurações salvas em um BD

//  VERSAO = 'ASPECT Mídia'#13'Versão 6.2 Rev.A 09/10/19';
           // 1. BT #1407 Adicionado novo software de captura de tv SICSLIVETV

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 16/08/19';
           // 1. BT #877 Tamanho do Form Fixo do "Controle Remoto".
           // 2. BT #1262 Adicionado Opção nova em softwares padrões - TBS
           // 3. BT #1345 Implementado no servidor um Timer que dispare a consulta à API e atualize o jornal eletrônico "Tempo Unidade HIAE".

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1. Alterado todo o sistema para usar a propriedade Host dos componentes Socket ao invés da propriedade Address.
           // 2. BT #1095 alteração feita para gravação correta do volume quando o software homolagado é o VisioForge

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo, ateração de todas as DLLs de xxxx_DX.dll para xxxx_DT.dll
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.D 24/04/18';
           // 1. BT #943 Ajuste de Volume via PA para a entrada HDMI (conversor NET HDMI)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.C 23/04/18';
           // 1. BT #943 Apresentação de sinal de video via entrada HDMI (conversor NET HDMI)
           // 2. BT #947 Tela do SICsTV piscava a cada 30 segundos por causa de um timer das PIS
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 Rev.A 03/04/18';
           // 1. BT #836 - Tratamento para logar erro - "Erro ao Decifrar Protocolo TCP IP"
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
           // 2. BT #842 e #849 - Criação de um controle remoto para o SicsTV
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 Rev.A 14/12/17';
           // 1. BT #836 - Erro ao Decifrar Protocolo TCP IP
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. BT #314 - Correção TV não chama senha se o campo "Nome no Painel" da PA estiver em branco
           // 3. BT #42  - Correção Alterar o tipo de mensagem para Alerta - Um processo do aplicativo...
           // 4. BT #636 - Correção Ao excluir os videos da lista de reprodução e clicar em aplicar, os videos voltam para lista.
           // 5. BT #682 - Correção Ao excluir o quadro de tv depois de algum tempo o avermedia é aberto sem o quadro de tv.
           // 6. BT #683 - Correção Na playlist de video, a execução começa pelo segundo video.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.D 16/10/17';
           // 1. Bug corrigido: #693 (minimizar AverTV quando alterna para video institucional para evitar tela azul)
           // 2. Bug corrigido: #694 (alguns videos não estavam detectam automaticamente sua duracao)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.C 05/09/17';
           // 1. Implementação do BT #684 (alternar TV e video institucional)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.B 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX). Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 17/05/17';
           // 1. Versão 5.3 apenas para uniformizar versão com os clients. Sem alterações.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Versão 5.2 apenas para uniformizar versão com os clients. Sem alterações.
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.C 17/02/17';
           // 1. SicsTV agora monitora o AverTV e o reabre caso o guardião o feche por detectar que o mesmo travou
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Alteração do código que fecha AverTV e traz SicsTV para frente
           // 2. Correção dos BT #387, #423 e #424
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Implementação do guardião (BT #385)
           // 2. Implementação do monitoramento da resolução da tela (BT #387)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.1 31/01/17';
           // 1. Primeira versão migrando o branch do projeto 16620 para o trunk
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 Rev.A 15/12/16';
           //1. Inserido visualização de KPIs (BT #298)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.0 23/09/16';
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. H 08/07/16';
           //1. Bug corrigido: atualização automática dos Indicadores de Performance no Jornal Eletrônico (somente funcionava ao reenviar a mensagem institucional)
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. G 07/04/16';
           //1. Implementado múltiplos Indicadores de Performance no Jornal Eletrônico
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. F 31/03/16';
           //1. Implementado Indicador de Performance no Jornal Eletrônico
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. E 15/02/16';
           //1. Alterado modo de alerta no indicador de performance
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. D 21/01/16';
           //1. Implementado som de alerta no indicador de performance
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. C 28/05/15';
           //1. Implementado label 'BuscaCanais'
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. B 29/04/14';
           //1. Implementando parâmetro "LogSocket" na seção DEBUG do Ini
  //VERSAO = 'ASPECT Mídia'#13'Versão 4.4 rev. A 25/04/14';
           //1. Ajustes das novas funcionalidades para controle de pausas
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 4.4 13/03/14';
           // 1. Implementação de leitura da senha por voz (text to speach)
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 4.3 24/04/13';
           // 1. Não houve absolutamente nenhuma mudança, apenas mudança na versão pois é compatível com o servidor V4.3
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 4.2 Rev.B 21/02/13';
           // 1. Permitir AutoLoad quando selecionado Composite ou S-Video e não houver canal padrão configurado
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 4.2 Rev.A 07/12/12';
           // 1. Imagens para os estados dos indicadores de performance em extensão ".PNG"
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 4.2 16/10/12';
           // 1. Novo funcionamento - últimas chamadas não apresenta mais a chamada atual
           // 2. Bug corrigido: ao clicar no botão de alinhamento da senha em quadros de últimas chamadas não estava gravando o correto
           // 3. Bug corrigido: ao clicar para não aparecer um label (Senha, PA ou NomeCliente), fica invisivel
           // 4. Modificado comando $89, incluído o ID da TV à qual o permissionamento se refere
           // 5. Modificado comando $73, para envio do nome do cliente junto com a senha na chamada por TV
           // 6. Reposicionados os componentes do formulário frmSicsProperties, para ajuste correto na tela
           // 7. Excluída a opção de se selecionar o tipo "Gradiente" como plano de fundo para os quadros
           // 8. Excluída a opção de se selecionar que o tamanho do quadro acompanhe a imagem de fundo. Tamanho agora deve ser fixado digitando-se Largura e Altura. Com isto, os quadros não podem mais ser redimensionáveis com o mouse (Sizeable sempre false) e não aparecem mais as listinhas características de TPanel dimentionável em seu canto inferior direito
           // 9. Controle de Preview da TV e StartPreview a cada 7 segundos para evitar que não entre o Preview caso receba o comando $89 antes de criar o componente de TV
           //10. Bug corrigido: não estava mudando de canal por falha no recebimento do comando $8B
           //11. Corração do título da aplicação e do Caption do form principal, de "SICS Video" para "SICS TV"
  //VERSAO = 'ASPECT Mídia'#13'SicsTV'#13#13'Versão 1.0 24/02/12';
  //VERSAO = 'ASPECT Mídia'#13'SicsVideo'#13#13'Versão 1.0 Rev.A 29/06/09';
  //VERSAO = 'ASPECT Mídia'#13'SicsVideo'#13#13'Versão 1.0  25/05/09';
{$ENDREGION}  {$ENDIF CompilarPara_TV}

{$REGION 'TVGuardian'} {$IFDEF CompilarPara_TVGuardian}
  VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo, ateração de todas as DLLs de xxxx_DX.dll para xxxx_DT.dll
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX). Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.2 17/03/17';
           // 1. Versão 5.2 apenas para uniformizar versão com os clients. Sem alterações.
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 Rev.C 17/02/17';
           // 1. Ao detectar WerFault.exe (Windows Error Reporting) quando o AverTV trava, fecha apenas o AverTV e não mais o SicsTV (somente fecha o SicsTV caso o mesmo pare de responder)
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 Rev.B 14/02/17';
           // 1. Alterações no SicsTVGuardian para detectar WerFault.exe (Windows Error Reporting) quando o AverTV trava
  //VERSAO = 'SICS Config'#13#13'ASPECT Mídia'#13#13'Versão 5.1 Rev.A 06/02/17';
           // 1. Build inicial, já em 5.1.1 para compatibilizar com 5.1.1 do SicsTV
{$ENDREGION}  {$ENDIF CompilarPara_TVGuardian}

{$REGION 'SCC'} {$IFDEF CompilarPara_SCC}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.27.0 26/02/24';
    // HIAE-5610 Melhoria no SCC - validar status da senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.26.0 26/02/24';
    // SICS-144 Remover do SCC a conexão com a porte de um servidor no INI

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.25.0 29/07/23';
    // HIAE-4000 Rever o processo de deploy

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.22.0 27/07/23';
    // 1. - Jira Card HIAE-3691 Ajustar SCC Horse - Deploy - Verificar se o exe é o mesmo já em memória

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.21.0 28/06/23';
    // 1. - Jira Card HIAE-2839 Erro SCC versão: 7.0.17.0 Data: 06/04/2023 Maximum number of concurrent connections exceeded.  Please try again later

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.20.0 30/05/23';
    // 1. - Jira Card HIAE-3008 - Criação de novo endpoint no SCC - Atendentes & Criação de novo endpoint no SCC - Filas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.19.0 27/04/23';
    // 1. - Jira Card HIAE-1616 - SCC travando em algumas situações esporádicas e aleatórias. Tentativa de correção com semáforos nas functions GetConnection da Unit uConexaoDB (atenção: unit compartilhada com outros projetos)

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.18.0 21/04/23';
    // 1. - Jira Card 2596 - Aumento de consumo de memória do SCC DeployVersões

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.17.0 05/04/23';
    // 1. - Jira Card 2400 - Criar Socket no Sics e APIs no SCC

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.16.0 05/04/23';
    // 1. - FLRY-26 - Bug nos endpoints de Indicadores estão com falha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.15.0 30/03/23';
    // 1. - Informações de fila nos EndPoints ChamarProximo e ChamarEspecifica

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.14.0 27/03/23';
    // 1. - Ajuste para retornar o id do calculo do TEE direto na solicitação do mesmo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.11.0 13/02/23';
    // 1. - Ajuste no retorno da API aspect/rest/PA/Listar para se a PA não tiver Grupo retornar GrupoId = 0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.10.0 31/01/23';
    // 1. - Verificar método de conexão da aplicação com o BD

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.9.0 24/01/23';
    // 1. - Ajuste no retorno do parametro Triagem na api Atendente/ObterDados

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.8.0 19/01/23';
    // 1. - Inclusão do item NomeAtendente na Api /aspect/rest/PA/Listar/

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.7.0 10/01/23';
    // 1. - Inclusão dos itens IDAtendente, Horario, Senha, IDMotivoPausa, NomePaciente na Api /aspect/rest/PA/Listar/

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.6.0 28/11/22';
    // 1. - Adição de limpeza de memória no timer de limpeza dos tokens
    // 2. - Remoção dos logs de DEBUG no CoInitialize e no CoUninitialize

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.31 22/11/22';
    // 1. - Adição de logs DEBUG e 2 pontos de saída de loop (repeat) por timeout

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.29 16/11/22';
    // 1. - Melhoria na requisição do ObterTempoEspera (FLRY-21)

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.28 08/11/22';
    // 1. - Inclusão de parâmetro ConvenioModular no endpoint Atendente/obterdados

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.27 21/10/22';
    // 1. - Inclusão de parâmetro IdFluxo no EndPoint AA/IniciarAtendimento

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.26 20/10/22';
    // 1. - Retorno do EndPoint ObterFoto 200 quando atendente não possui foto

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.25 05/10/22';
    // 1. - Melhoria na instrução SQL retornando o Id somente da Fila e Unidade

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.24 05/10/22';
    // 1. - Adicionar o ID do Calculo TEE no retorno do JSON

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.23 03/10/22';
    // 1. - Tratamento p/ limpar objetos da memória

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.22 16/08/22';
    // 1. - Incluídos retornos nas apis de IniciarAtendimento, AtualizarAtendimento  e FinalizarAtendimento

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.21 14/07/22';
    // 1. - Incluidos parametros QTDEPAProdutiva e QTDEPessoasEspera na api /fila/ObterTempoEspera

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.20 13/07/22';
    // 1. - Implementados Endpoints AA/IniciarAtendimento, AA/AtualizarAtendimento, AA/FinalizarAtendimento e AA/ConsultarRegistro

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.19 22/06/22';
    // 1. - Remoção do nome do totem do nome da unidade no retorno dos parâmetros do totem

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.18 06/06/22';
    // 1. - Ajustes para verificar disponibilidade de update e download

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.17 18/05/22';
    // 1. - Implementado Servidor HORSE

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.16 06/05/22';
    // 1. - Retorno do nome do setor no concatenado no campo nomeunidade na api totem/parametros

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.15 29/04/22';
    // 1. - Implementação das apis de checar update e download via horse

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.14 26/04/22';
    // 1. - Implementação da api aspect/rest/totem/parametros

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.13 17/02/22';
    // 1. - Correção para considerar o retorno do socket o protocolo do Sics Servidor se IdCategoriaFila e o IdGrupoFila vem com valores numéricos,
    //      para compatibilidade com versões anteriores do SICS Servidor. Endpoint Fila/ListarQuaisGeramSenhas.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.12 05/02/22';
    // 1. - A meia noite o SCC começava um novo arquivo/objeto de log para o dia, mas sem antes destruir o objeto do dia anterior. Corrigido

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.11 22/12/21';
    // 1. - Ajuste para a API aspect/rest/senha/ReimprimirSenha passar o numero do totem em HEXA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.10 06/12/21';
    // 1. - Criação do campo localizado no retorno da api ObterDados

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.8 07/10/21';
    // 1. - Card 268 - Criação do endpoint /aspect/rest/Unidade/Listar

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5.7 31/08/21';
    // 1. - Criação do endpoint /aspect/rest/totem/EnviarRespostaPesquisaSatisfacao

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.5 14/07/21';
           // 1. Alteração no endpoint ObterAtendentesPorGrupo para retornar o campo IdAtendenteNoCliente
           // 2. Inclusão das linhas perdidas no build 3229 na unit uConsts.pas,
           // 3. Inclusão do endpoint updateImprimirMensagem perdida no build 3229 na unit uSMTotem.pas,
           // 4. Inclusão das functions ListarGrupos e ListarCategorias perdida no build 3229 na unit uSMFila.pas,

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.0.4 12/07/21';
           // 1. Alteração no endpoint ObterAtendentesPorGrupo para retornar o campo ID_ATD_CLI
           // 2. Alteração no endpoint ObterDados para buscar pelo ID_ATD_CLI além de pelo NOME

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 Rev.C 09/06/21';
           // 1. Log de API REST gera um arquivo por dia as 00:00
           // 2. Removido o limite de 5MB dos arquivos de LOG

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 Rev.B 25/05/21';
           // 1. Novo EndPoint "GravaRelatSitef" para gravar os dados das transações TEF

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 Rev.A 09/03/21';
           // 1. Obter lista de atendente por grupo
           // 2. Log do SCC abaixo nivel
           // 3. Monitoramento do Totem

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.3 Rev.B 22/02/21';
           // 1. BT #1429 Dois novos EndPoints para retornar as telas de um TOTEM e a imagem de fundo de cada tela

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.3 Rev.A 05/11/19';
           // 1. BT #1429 Dois novos EndPoints para retornar as telas de um TOTEM e a imagem de fundo de cada tela
           // 2. BT #1436 Novo EndPoint que retorna o tempo de espera e tempo medio na Fila
           // 3. BT #1435 Adicionado geração de log em endpoints do SCC

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.3 24/09/19';
           // 1. BT #1392 Criado novo EndPoint na API do SCC que retorna o status dos dispositivos do SICS

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 Rev.A 16/08/19';
           // 1. BT #1249 Alterado o Comando de inserir senha para ficar igual a documentação.

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 21/06/19';
           // 1. BT #1292 - Criado endpoint para Remover da Espera uma Senha

  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.B 22/05/19';
           // 1. Endpoint InserirSenha possibilita parâmetro "unidade" ao invés de "idunidade", para compatibilidade com clientes já em produção
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 Rev.A 16/05/19';
           // 1. BT #1230 - Criado endpoint para listar totens
           // 2. BT #1231 - Criado endpoint para listar senhas de uma fila
           // 3. BT #1233 - Criado parâmetro permitindo informar se insere a senha no início ou final da fila
           // 4. BT #1241 - Criado EndPoint para inserir nova senha em um fila sem imprimí-la
           // 5. BT #1243 - Criado EndPoint para reimprimir uma senha
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.1 18/03/19';
           // 1. Finalização Migração de DBExpress para Firedac
           // 2. Finalização Suporte ao Banco de Dados SQL Server 2008 RS2 SP2
           // 3 - Adicionado MidasLib no DPR, para evitar problemas com a carga da Midas.DLL
           // 4 - Alterado o nome do Generator de Indicadores, para ficar no padrão dos demais
           // 5 - Modificação para o SCC funcionar respondendo as chamadas dos endpoint como multiunidades
           // 6 - Alterado todo o sistema para usar a propriedade Host dos componentes Socket ao invés da propriedade Address.
           // 7 - BT #1130 alterado protocoloco para atender o endpoint "ListarPorPA" para atender pelo ID da PA pois estava atendendo pelo ID do Modulo
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 24/07/18';
           // 1. BT #1011 - Alteração no serviço do SCC para criar dependência do Firebird e timer para reconectar ao banco caso não consiga
           // 2. Correção: Alguns erros eram gerados no "ErrorLog" da pasta da aplicação, sem respeitar o caminho do arquivo de LOG configurado no .ini
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo, ateração de todas as DLLs de xxxx_DX.dll para xxxx_DT.dll
           // 3. SCC funcionando como Serviço
           // 4. SCC com API REST/JSON multiunidades
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.5 04/03/18';
           // 1. Build e release da V5.5 de todos os módulos SICS (VCL e FMX).
		       // 2. Novas funcionalidades e comandos para funcionar com Checkin Mobile, incluindo CAMPOS ADICIONAIS e chamada por NOTIFICACAO PUSH]
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4.1 23/11/17';
           // 1. Inclusão de novo tipo de interface: tiFlatFilesV5, que seria o tiFlatFiles evoluido para funcionamento com o Servidor V5 (incluindo campo de VersaoProtocolo no protocolo)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.4 14/11/17';
           // 1. Build e release da V5.4 de todos os módulos SICS (VCL e FMX).
           // 2. Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'ASPECT Mídia'#13'Versão 5.3 Rev.A 07/07/17';
           // 1. Build e release da V5.3 de todos os módulos SICS (VCL e FMX). Revisão apenas para uniformizar versão entre os módulos. Sem alterações neste módulo (porém houve alterações em outros módulos neste build)
  //VERSAO = 'SICS Customização de chamadas'#13#13'Versão 5.3 16/06/17';
           // 1. Mudança de versão da 5.1 para 5.3 para compatibilizar com Servidor SICS V5.3
           // 2. Correção do encoding UTF8 no post para devolver ao WS de terceiros uma senha que foi chamada para uma PA (e, em UTF8, o respectivo nome do cliente, com acentuação)
  //VERSAO = 'SICS Customização de chamadas'#13#13'Versão 5.1 Rev.B  02/06/17';
           // 1. Alteração do retorno do método GerarSenha, que agora devolve também a senha gerada
  //VERSAO = 'SICS Customização de chamadas'#13#13'Versão 5.1 Rev.A  24/05/17';
           // 1. Alteração do envio de senhas para o webservices do cliente, adicionando o NOME da senha enviada.
  //VERSAO = 'SICS Customização de chamadas'#13#13'Versão 5.1  24/05/17';
           // 1. Liberação oficial do SCC com integração via REST/WebService (Dentalis)
  //VERSAO = 'SICS Customização de chamadas'#13#13'Versão 5.0  28/07/16';
           // 1. Primeira versão em DXE Seattle
           // 2. Inserida integração com o Silab
{$ENDREGION}  {$ENDIF CompilarPara_SCC}

{$REGION 'SICS CallCenter'} {$IFDEF CompilarPara_CALLCENTER}
  VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.B 20/07/18';
           // 1. BT #1005 - Modificação na rotina de update para atender todos projetos VCL ou FMX
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 Rev.A 16/07/18';
           // 1. BT #1005 - Inclusão da rotina de update para ficar genérica e poder atender todos os projetos
           // 2. Não é mais necessária a Midas.dll
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.0 12/07/18';
           // 1. Primeiro release da V6
           // 2. Gerado no Delphi Tokyo
           // 3. Novo módulo e funcionalidades "Call center" a partir desta versão
{$ENDREGION}  {$ENDIF}

{$REGION 'SICS Totem Touch'} {$IFDEF CompilarPara_TOTEMTOUCH}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.1 07/11/2022';
           // 1. Funcionamento com impressora USB (ainda com ToDo para obter status da impressora sem papel, pouco papel, offline, etc)
  //VERSAO = 'ASPECT Mídia'#13'Versão 6.2 18/03/19';
           // 1. BT #1294 Criação do Modulo Totem Touch.
{$ENDREGION}  {$ENDIF CompilarPara_TOTEMTOUCH}

{$REGION 'SICS Totem AA'} {$IFDEF CompilarPara_TOTEMAA}
  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.18 11/10/21';
    //1 - Card 454 - Traduzir telas para digitar CPF

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.17 11/10/21';
    //1 - Card 446 - Refino das telas do totem #3
    //2 - Card 397 - Ajuste no refino das telas #1

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.16 08/10/21';
    //1 - Card 315 - 1 - Pesquisa do médico deve iniciar após digitar a terceira letra

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.15 08/10/21';
    //1 - Card 431 - 1 - Alteração na gravação do log do OCR

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.14 08/10/21';
    //1 - Card 436 - 1 - Utilizei a tabGuiaTISS como base para criar uma tabAssinaturaDocumento, mais abstrata e que pode ser utilizada para diferentes fins. Se/quando a UPA for reescrita, a tabGuiaTISS pode dar lugar a tabAssinaturaDocumento e ser apagada. Ambas as janelas ainda precisam passar por avaliação do Luiz, pois não estão boas em usabilidade.
    //               2 - O fluxo UPA introduziu um AssinaPDF. Criei um método TotemAssinaPDF mais abstrato para assinar qualquer PDF para diferentes fins. Tenham especial atenção ao comentário que coloquei no fonte sobre como configurar as coordenadas da assinatura.
    //               3 - Introduzi uma API que consulta um dado documento em uma passagem. Na reunião de hoje (08/10/2021) descobri que não precisarei mais desta API na internação e ela será retirada deste fluxo em breve. Ainda assim, podemos mantê-la para futuro uso em outro s fluxos.
    //               4 - Introduzi um TStrings ArquivosParaApagar. Ao salvar um arquivo temporário em disco, adicionar nesta lista para que ao término do atendimento e ao encerrar a aplicação estes arquivos sejam apagados. Isto é cálido para qualquer fluxo.
    //               5 - O HIAEInserirConsentimento agora tem controle de passos para erro e concluído. Percebi que se você acionar esta API duas vezes no mesmo dia para um prontuário (ou em minutos, não faço idéia) levanta erro. Agora com o controle de passos você tem poder de decisão do que fazer quando há erros (como levar pro guichê ou seguir com o fluxo). Ainda é necessário criar um APIs.Einstein.InserirConsentimento para não usar o LoadFromAPIs, pois este último chama um ErroNoProcesso.
    //               6 - O HIAEConsultarElegibilidadeConvenio agora tem um passo para quando o convênio não é passível de consulta. Isto por que na Internação há o cenário de pré-admissão e o convênio já foi validado. O totem só faz uma segunda checagem. Quando não conseguir fazer esta checagem, pode-se seguir com o fluxo da internação.
    //               7 - Diversas adaptações no fluxo de internação em linha com as últimas reuniões com o cliente.
    //2 - Card 465 - Fluxo de Consultórios não mostra foto do médico.
    //3 - Card 464 - 1 - Os novos métodos introduzidos através do fluxo de internação trabalham com threads concorrentes. Quando 2 threads fazem log simultaneamente, um erro de "[FireDAC][Phys][SQLite]-326. Cannot perform the action, because the previous action is in progress" é apresentado e logado na pasta LogSQLiteExceptions.
    //               2 - Devemos introduzir um TMonitor no LogSQLite.pas para que somente seja gravado um log por vez, além de um TCriticalSection na untLog. Este último ainda falta.


//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.13 07/10/21';
    // 1. - Card 443 - Traduzir telas Aeroporto.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.12 06/10/21';
    // 1. - Card 452 - Calcular o tempo de preenchimento do formulário da Anvisa.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.11 06/10/21';
    // 1. - Card 450 - Alteração para registrar o tempo de uso do totem para em Segundos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.10 06/10/21';
    // 1. - Card 445 - refino das telas #2

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.9 06/10/21';
    // 1. - Card 433 - Ajuste para remover o uso do método GeraSenha_Encaminha_MarcaTag e não dar erros de Travar telas e duplicar senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.8 05/10/21';
    // 1. - Card 397 - refino das telas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.7 05/10/21';
		// 1. - Card 442 - Ajuste da ordenação do campo Nacionalidade e verificação dos campos da tela 2 do cadastro
		// 2. - Card 433 - Ajuste para remover o uso do método GeraSenha_Encaminha_MarcaTag e não dar erros de Travar telas e duplicar senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.6 05/10/21';
		// 1. - Card 442 - Tradução dos campos de DDI e Nacionalidades

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.5 04/10/21';
		// 1. - Card 441 - Ajuste para validar a segunda tela de cadastro do paciente

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.4 04/10/21';
		// 1. - Card 439 - Unificar Fluxos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.3 04/10/21';
		// 1. - Card 431 - Ajustes para realizar log no kibana e no log local as operações de OCR

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.2 04/10/21';
		// 1. - Card 438 - Não está inserindo o telefone nos dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.1 04/10/21';
		// 1. - Card 440 - OCR não reconhece dados do passaporte

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.13.0 01/10/21';
		// 1. - Release 7.7.13.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.6 01/10/21';
		// 1. - Card 433 - Ajuste para remover o uso do método GeraSenha_Encaminha_MarcaTag e não dar erros de Travar telas e duplicar senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.5 30/09/21';
		// 1. - Card 432 - Ajuste para manter as seleções durante a navegação pelo formulário ANVISA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.4 28/09/21';
		// 1. - Card 415 - Retirar seta da tela inicial fluxo mda

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.3 28/09/21';
		// 1. - Card 413 - AJustar alinhamento campo ultima refeição tela informações adicionais mda.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.2 28/09/21';
		// 1. - Card 414 - Campo de peso na tela de informações adicionais Mda ajustado para 3 caracter

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.1 28/09/21';
		// 1. - Card 300 - Corrigir linha na tela de buscar Paciente.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.12.0 24/09/21';
		// 1. - Release 7.7.12.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.20 24/09/21';
		// 1. - Card 407 - Correção nos Logs e Kibana ao calcular e reportar o TempoDeUso

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.19 24/09/21';
		// 1. - Card 406 - Inserido botão "Outros Atendimentos" na tela inicial 1

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.18 23/09/21';
		// 1. - Card 405 - Ajuste para REimprimir a senha depois que marcar tags no fluxo pa digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.17 23/09/21';
		// 1. - Card 404 - Ajuste para marcar corretamente as TAGs Adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.16 23/09/21';
		// 1. - Card 403 - Ajuste para marcar corretamente a TAG de Doencas Infectocontagiosas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.15 23/09/21';
		// 1. - Card 402 - Botões Outros atendimentos da UPA imprime duas senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.14 23/09/21';
		// 1. - Card 401 - Não gera senha no fluxo PA Digital quando quando o tipo do agendamento = E e já foi gerada passagem

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.13 23/09/21';
		// 1. - Card 400 - Botões Outros atendimentos da UPA não imprime senha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.12 23/09/21';
		// 1. - Card 399 - Ajuste não está indo para tela inicial quando não encontra agendamento na tela inicial 7

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.11 23/09/21';
		// 1. - Card 398 - Ajuste não está indo para tela inicial quando não encontra agendamento na tela inicial 1

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.10 22/09/21';
		// 1. - Card 395 - Ajuste Impressão Pulseiras PA Digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.9 21/09/21';
		// 1. - Card 394 - Ajustado para ocultar frase superior na tela de erro no fluxo de PA Digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.9 21/09/21';
		// 1. - Card 392 - Ajuste saindo duas senhas no fluxo oncologia

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.8 21/09/21';
		// 1. - Card 390 - Alteração de Texto de Mensagem na tela de erro no fluxo de PA Digital para "OK, estamos gerando senha para triagem."

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.7 20/09/21';
		// 1. - Card 388 - Oncologia saindo duas senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.6 20/09/21';
		// 1. - Card 387 - Oncologia saindo duas senhas e duas pulseiras.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.5 20/09/21';
		// 1. - Card 386 - Alteração para respeitar a opção de Imprimir Senha SIM/NÃO do PA Digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.4 20/09/21';
		// 1. - Card 385 - Alteração para ir para tela inicial quando der erro na PA Digital e texto enviar para Triagem

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.3 20/09/21';
		// 1. - Card 348 - Trazer o nome do exame na lista de exames agendados. fluxo mda.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.2 19/09/21';
		// 1. - Card 345 - fix botão tela inicial

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.1 19/09/21';
		// 1. - Card 345 - Alteração no preenchimento do campo altura, fluxo mda

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.11.0 17/09/21';
		// 1. - Release 7.7.11.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.28 17/09/21';
		// 1. - Descomentado preenchimento de nacionalidades

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.27 17/09/21';
		// 1. - Card 381 - Fluxo PA Digital sem agendamento não encaminha senha para recepção

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.26 16/09/21';
		// 1. - Card 380 - Ajuste Na exibição de tela inicial quando não tem consulta agendada.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.25 16/09/21';
		// 1. - Card 379 - Ajuste Pesquisa de satisfação fluxo UPA Digital.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.24 15/09/21';
		// 1. - Card 378 - Ajuste Leitura QrCode UPA Digital.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.23 15/09/21';
		// 1. - Card 377 - Ajuste na exibição da pesquisa de satisfação no fluxo PA Digital
    // 2. - Ajuste na exibição da senha de outros atendimentos perdizes e klabin

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.22 15/09/21';
		// 1. - Card 377 - Ajuste na exibição da pesquisa de satisfação no fluxo PA Digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.21 15/09/21';
		// 1. - Card 375 - Ajuste para não obrigar preencher campo Documento de Estrangeiros

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.20 15/09/21';
		// 1. - Card 374 - Ajuste na impressão da senha quando não gera passagem no PA Digital.
		// 2. - Card 375 - Alteração para não obrigar preencher campo Documento de pessoas com nacionalidade <> BRASILEIRA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.19 15/09/21';
		// 1. - Card 371 - Impressão da Senha e Pulseira depois da pesquisa de satisfação na Oncologia.
		// 1. - Card 371 - Ajuste Inclusão de Pesquisa de satisfação no fluxo PA Digital

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.18 15/09/21';
		// 1. - Card 370 - Ajuste para Atualizar episodio na atualização do Status do Clinicweb

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.17 14/09/21';
		// 1. - Ajuste Clinicweb.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.16 14/09/21';
		// 1. - Ajuste na fila da reabilitação.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.15 14/09/21';
		// 1. - Card 367 - Fluxo Reab Imprimir pulseira Depois da Pesquisa.
    // 2. - Card 368 - Ajuste na abertura da tela de consulta de paciente Brasileiro
    // 3. - Card 369 - Senha da Reabilitação gerada na fila da recepção quando não imprime pulseira.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.14 14/09/21';
		// 1. - Card 365 - Outros Atendimentos Reab retirar pesquisa de satisfação.
    // 2. - Card 366 - Quando é a primeira ou ultima passagem da Reab imprime duas senhas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.13 14/09/21';
		// 1. - Card 360 - Alterar para sempre iniciar a consulta Paciente com apenas os botões do Tipo do Documento na tela
    // 2. - Card 361 - Não apresentar pesquisa na tela Outros atendimentos no fluxo Reabilitação
    // 3. - Card 363 - Alteração na validação do retorno da troca de status do clinicweb.Imprimir a senha ao clicar no botão oculto da tela de idiomas(AEROPORTO)
    // 4. - Card 364 - Alteração na validação do retorno da troca de status do clinicweb.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.12 13/09/21';
		// 1. - Card 359 - Correção no campo passaporte.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.11 13/09/21';
		// 1. - Junção com alterações de tela do Ricardo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.10 13/09/21';
		// 1. - Card - 358 - Criação de parametro no ini para salvar imagem ao enviar no método sendImageFromAPI

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.9 13/09/21';
		// 1. - Card - 355 - Ajuste na abertura da tela de consulta paciente
		// 2. - Card - 357 -  Ajuste nas traduções da tela de sintomas e de Pesquisa de satisfação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.8 13/09/21';
		// 1. - Card - 355 - Criado bloqueio para não permitir passar cadastro na edição sem numero do documento(comentado)

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.7 13/09/21';
		// 1. - Card - 353 - Tela Consulta Paciente Estrangeiro vir com CPF Selecionado

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.6 13/09/21';
		// 1. - Componente Winsoft versão paga.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.5 13/09/21';
		// 1. - Card - 352 - Alterando CKECKIN APS Removendo clausula Primeira Consulta

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.4 13/09/21';
		// 1. - Card - 351 - Acessando Pesquisa de Satisfação no Outros Atendimentos do Fluxo Consultórios

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.3 13/09/21';
		// 1. - Card - 350 - Acessando Pesquisa de Satisfação no Outros Atendimentos do Fluxo APS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.2 12/09/21';
		// 1. - Card - 349 - Botão "Voltar" na tela de sintomas não está funcionando.
    // 2. - Card - 347 - Excluir ícone do médico tela de pedidos.
    // 3. - Card - 343 - Alterar posição de uso de medicamentos
    // 4. - Card - 337 - Alterar instruções para digitalizar pedido médico
    // 5. - Card - 338 - Alterar botões "Adicionais mais pedidos médicos"

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.1 10/09/21';
		// 1. - Ajuste para não imprimir duas senhas em questionário da vacina com algum sim.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.10.0 10/09/21';
		// 1. - Release 7.7.10.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.13 10/09/21';
		// 1. - Card - 323 - Ajuste na impressão de senha para dor no peito

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.12 10/09/21';
		// 1. - Card 319 - Tela de Whastapp aparecer no fluxo de consultórios

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.11 10/09/21';
		// 1. - Card 335 - Preencher campo celular da tela whatsapp com o dado do Menor
		// 2. - Card 328 - Vacina - Quando seleciono "Sim" no questionário da gripe, não aparece a tela exibindo a senha.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.10 09/09/21';
		// 1. - Card 330 - Imprimindo e reimprimindo em todos os cenários no fluxo de vacinas
		// 2. - Card 331 - Tela de selecionar o reponsável quando tem apenas o menor, layout antigo
		// 3. - Card 332 - Travando em pacientes agurpados
		// 4. - Card 333 - Ajsutes layout tela de sintomas
		// 5. - Card 334 - Divergencia quetionário não imprime senha



//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.9 09/09/21';
		// 1. - Alteração para a Tela Seleção Fluxo abrir Imagem local e mapear areas clicaveis

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.8 09/09/21';
		// 1. - Ajuste na validação do tipo do documento na busca

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.7 09/09/21';
		// 1. - Card 323 - Correção na leitura/gravação do parametro TipoCamera no INI (estava sempre gravando WINSOFT)

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.6 09/09/21';
		// 1. - Card 323 - Voltando modo de espelhamento da imagem

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.5 08/09/21';
		// 1. - Card 323 - ajustes autofocus configurável de acordo com o ini ( winsoft )

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.4 08/09/21';
		// 1. - Correção para puxar os dados do telefone direto no formato string para gravar nos dados adicionais e gravar log ao gravar dados adicionais
    // 2. - Gravando no log a tentativa de gravar os dados adicionais

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.3 06/09/21';
		// 1. - Correção para não gravar 2 senhas no fluxo de Consultas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.2 06/09/21';
		// 1. - Gravação da TAG de Doenças Infectocontagiosas

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.1 04/09/21';
		// 1. - Card 323 - Criação de Foco parametrizado para camera Logitec

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.9.0 03/09/21';
		// 1. - Release 7.7.9.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.9 03/09/21';
		// 1. - Card 322 - DDI - Deixar Brasil como primeiro país na lista de países e também no conteudo da lista de DDIS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.8 03/09/21';
		// 1. - Card 314 - Pesquisa de satisfação - Imprimir a senha após o preenchimento da pesquisa de satisfação.
		// 2. - Card 321 - DDI - Ao clicar na seta, lista todos os DDIs

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.7 03/09/21';
		// 1. - Card 269 - Trocar botão "Adicionar consulta" de lugar com o botão "Cancelar" na tela de profissionais selecionados

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.6 03/09/21';
		// 1. - Card 313 - Toda vez que o campo DDI vier vazio, inserir o DDI +55 para os prontuários
		// 2. - Card 317 - DDI - Deixar Brasil como primeiro país na lista de países
		// 3. - Card 318 - Retirar a pesquisa de satisfação dos fluxos de "Outros atendimentos"
    // 4. - Card 320 - Criar na tela 2 botão de check-up para unidade Jardins, com opções de configuração no INI
    // 5. - Card 315 - Pesquisa do médico deve iniciar após digitar a terceira letra

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.5 02/09/21';
		// 1. - Card 312 e 316 - Validar Campos em cada tela do cadastro do paciente

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.4 02/09/21';
		// 1. - Card 301 - Alterados textos dos botões dos sintomas, alterados em ingles e espanhol
    // 2. - Criadas traduções para textos do formulário de pesquisa de satisfação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.3 01/09/21';
		// 1. - Card 304 - criação de tag "TAGSemExameAgendado" e rotação layout camera quando for carteirinha

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.2 01/09/21';
		// 1. - Ajustes nas inclusões do formulário da pesquisa de satisfação nos fluxos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.1 31/08/21';
		// 1. - Finalização da pesquisa de Satisfação
    // 2. - Criação da unit API.ASPECT.SICS.SmartSurveyResposta

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.8.0 27/08/21';
		// 1. - Release 7.7.8.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.11 27/08/21';
		// 1. - Card 284 - Ajuste na tela da consulta do paciente Iniciar sem seleção e teclado oculto

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.10 27/08/21';
		// 1. - Card 284 - Formulario Anvisa - Alteração das frases: Pretende viajar nos próximos 10 dias?
		// 2. - Card 280 - Ajuste na tela da consulta do paciente


//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.9 26/08/21';
		// 1. - Card 285 - escondendo botão tela inicial klabim

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.8 26/08/21';
		// 1. - Card 284 - Ajuste fluxo Mda
    // 2. - Card 285 - Migração tela inicial Klabin
    // 3. - Card 287 - finalização cenário 1° mda

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.7 26/08/21';
		// 1. - Ajuste para logar a hora do termino no log LOG
    // 2. - Ajuste dos Status dos logs de Processo_Finalizado

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.6 26/08/21';
		// 1. - Ajuste na gravação do DDI
		// 2. - Ajuste no tamanho do retangulo de captura de documentos e OCR
		// 3. - Ajuste na Inicialização do tipo do documento da consulta do paciente

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.5 25/08/21';
		// 1. - Card 274 - Ajustes da entrega 1, 2 e 3 do mda

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.4 24/08/21';
		// 1. - Remoção das telas adicionais do 2º Fator de Validação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.3 24/08/21';
		// 1. - Card 279 - Exibição do segundo fator de validação em apenas uma tela
		// 2. - Inclusão das imagens na tela de pesquisa de satisfação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.2 24/08/21';
		// 1. - Ajuste no salvamento do parametro FilaUpaAtendimentoExclusivo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.1 23/08/21';
		// 1. - Card 275 - Não preencher data no cadastro se o OCR não trouxer data.
		// 2. - Ajuste para criação dinâmica de botões na tela inicial

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.7.0 20/08/21';
		// 1. - Release 7.7.7.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.14 20/08/21';
		// 1. - Card 260 - Ajustado o Salvando o nome da Tag no log

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.13 20/08/21';
		// 1. - Card 260 - Salvando o nome da Tag no log

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.12 20/08/21';
		// 1. - Card 231 - Criação do parametro PortaTcp no ini para o endereco da porta do socket
		// 2. - Criação do parâmetro para mostrar a mensagem pertinente a escolha de sintomas na UPA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.11 20/08/21';
		// 1. - Inclusão da tela de Pesquisa de satisfação(Falta as figuras e programação)
		// 2. - Inclusão da tela de Mensagem Genérica e criação de parametro para seu texto
		// 3. - Alteração no fluxo da UPA para mostrar a tela de mensagem generica

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.10 20/08/21';
		// 1. - Card 273 - adicionar ao ini as configurações de qualidade de rosto, nitidez, e contraste
    // 2. - Card 244 - continuação fluxo mda #2

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.9 19/08/21';
		// 1. - Card 240 - Padronizar logs de início e término dos fluxos
		// 2. - Alteração para gravar corretamente os dados de telefone após a seleção do whatsapp
		// 3. - Card 261 - Colocar tempo de uso do totem no log

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.8 19/08/21';
		// 1. - Card 244 - Entrega 2 Mda ( fluxo incompleto )

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.7 17/08/21';
		// 1. - Card 267 - Melhoria no log ao tentar reconhecer pessoa pela api facial ( safr )

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.6 17/08/21';
		// 1. - Card 266 -  Gravação e Recuperação do DDI no formato novo e das Apis do Einteins. Uso na tela de confirmação do WhatsApp

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.5 16/08/21';
		// 1. - Card 237 -  Não está imprimindo nome e prontuário na senha do fluixo da Reab

//VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.4 16/08/21';
		// 1. - Card 259 -  Correção na Criação de filas prioritárias para atendimento de pessoas com Sintomas  de doenças infectocontagiosas no fluxo das UPA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.3 16/08/21';
		// 1. - Card 259 -  Criação de filas prioritárias para atendimento de pessoas com Sintomas  de doenças infectocontagiosas no fluxo das UPA

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.2 16/08/21';
		// 1. Criação de parametros para setar a resolução e o foco da digitalização de documentos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.1 14/08/21';
		// 1. Alteração do consumo do endpoint 'atendente/ObterAtendentesPorGrupo/' para usar o campo IdAtendenteNoCliente.

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.6.0 13/08/21';
		// 1. Release 7.7.6.0

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.45 13/08/21';
		// 1. correção ao reconhecer pessoa na safr

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.44 13/08/21';
		// 1. Correção do steploading da seleção de convenio no Fluxo VacinaGripe / APS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.43 13/08/21';
		// 1. Correção label camera quando é facial, e modo de stretch da camera facial

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.42 12/08/21';
		// 1. Corrigida imprimindo duas senhas para o fluxo APS Outros Atendimentos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.41 12/08/21';
		// 1. Corrigido imprimindo duas senhas para o fluxo APS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.40 12/08/21';
		// 1. Parametros para SETAR resolução e foco do QRCode
		// 2. Ajuste no tamanho do Quadro da Captura do QRCode

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.39 12/08/21';
		// 1. Flag para ativar/desativar a busca pelo id profissional no ini BuscarAtendendePorCodigo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.37 11/08/21';
		// 1. Hint de COVID no campo passaporte na tela de cadastro aparecer só para aeroporto

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.36 11/08/21';
		// 1. Alteração no fluxo de oncologia para acatar opção do médico de ter Triagem S/N


//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.35 11/08/21';
		// 1. Inclusão da tela de sintomas no PA Digital
		// 2. Aumento do tamanho do quadro do QRCODE na tela de Captura

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.34 10/08/21';
		// 1. Ajuste para não soltar 2 senhas nos fluxos Consultorio e APS - Parte 2

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.33 10/08/21';
		// 1. Ajuste para não soltar 2 senhas nos fluxos Consultorio e APS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.32 10/08/21';
		// 1. Ajuste 2º fator de validação na tela de consulta paciente
    // 2. Inverter botão confirmar e cancelar em tabProfissionaisSelecionados

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.31 10/08/21';
		// 1. Ajuste Algulo camera Facial, ajuste ocr caso não consiga buscar o documento (fluxo aps)

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.30 09/08/21';
		// 1. Ajuste para campos Não Permitidos não receberem foco no cadastro de clientes

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.29 09/08/21';
		// 1. Ajuste Log Camera

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.28 09/08/21';
		// 1. Ajuste Fluxo Aps Paciente Convenio abrir tela Whatsapp

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.27 09/08/21';
		// 1. Ajuste Biometria Facial Fluxo Aps

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.26 09/08/21';
		// 1. Ajustes Gravação do OCR e salvamento do doc digitalizado no Siaf

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.25 08/08/21';
		// 1. 1° parte do mda, entrega parcial

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.24 06/08/21';
		// 1. Ajuste na gravação dos dados adicionais na confirmação do whatsapp
    // 2. Gravando em log o Sintoma escolhido

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.23 05/08/21';
		// 1. Ajuste Na busca por CPF/Passaporte

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.22 05/08/21';
		// 1. Ajustes no fluxo APS

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.21 03/08/21';
		// 1. Ajuste para Bloquear setar menor como responsavel pagamento
		// 2. Ajuste no Preenchimento e leitura do FPassagens
		// 3. Ajuste para Gravar o OCR
    // 4. Limpeza do vgpessoa no ClearProperties

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.20 03/08/21';
		// 1. Correção ao validar o cpf

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.19 03/08/21';
		// 1. Correção ao validar o cpf, agora obrigado o usuário a selecionar cpf ou passaporte

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.18 03/08/21';
		// 1. Ajuste endpoint Reconhecimento facial Safr

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.17 02/08/21';
		// 1. Armazenamento interno de sintoma para cada paciente do pagamento
    // 2. Ajuste para geração da senha e sintoma selecionado
    // 3. Ajuste para exibição das listas da data na tela de 2º fator de validação

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.16 02/08/21';
		// 1. Correção no envio de imagens pro Siaf

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.15 02/08/21';
		// 1. Correção no envio de imagens pro Siaf

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.14 30/07/21';
		// 1. Validação de CPF pelo 2º Fator Data da Nascimento

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.13 30/07/21';
		// 1. Respeitando envio para Fila Fluxo Exclusivo em outros Fluxos
		// 2. Chamando o ObterDados do atendente pelo codigo

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.12 29/07/21';
		// 1. Ajuste para pesquisar CEP na tela de cadastro do cliente se tiver sido alterado

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.11 28/07/21';
		// 1. correção fluxo aps, adição rec facial aps

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.10 27/07/21';
		// 1. correção tela checkin varios agendamentos

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.9 27/07/21';
		// 1. correção fluxo oncologia quando não aceita enviar mensagem pro whatsapp

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.8 27/07/21';
		// 1. migração layout tela checkinvariosagendamentos, nova correção webcam

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.7 27/07/21';
		// 1. correção digitalização de documentos quando menor

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.6 27/07/21';
		// 1. Busca de profissional pelo IDTabela
    // 2. Parametro PermiteProfissionalSemID no INI para preencher lista
    // 3. correção abertura webcam

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.5 26/07/21';
		// 1. Paciente Menor todas opções de documento menos CNH
    // 2. adição fila pronto atendimento oncologia, correção abertura webcam

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.4 24/07/21';
		// 1. novo ajuste na camera, problema encontrado apenas na nova webcam

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.3 24/07/21';
		// 1. Ajuste de preenchimento do Celular/NumFoneEstrangeiro

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.2 22/07/21';
         //nova correção na abertura da camera

//  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5.1 22/07/21';
         //ajuste corte da imagem tirada pro reconhecimento facial

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.X 22/07/21';
          // 1. Ajustes nos nomes dos Estados na função GETUF
          // 2. Ajuste para iniciar parametro SintomasInfectoContagiosos em Branco
          // 3. Ajuste para não dar raise quando o paciente não tem convenio cadastrado na consulta elegibilidade
          // 4. Criado no ini Seção 'APS' Parâmetro 'MinutosToleranciaAPS' para setar tolerancia de atraso na consulta APS em minutos
          // 5. Ajuste para gerar senha e mandar para recepção cliente que achou o CPF mas sem prontuario

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.5 21/07/21';
          // 1. Ajustes de traduções de idiomas
          // 2. Ajuste do fluxo de Reab estava abrindo agendamentos de outras unidades
          // 3. Gravando paciente como Responsável do pagamento em fluxo Oncologia
          // 4. Ajuste para gravar a Senha e Data nas passagens do Reab
          // 5. Ajuste para não aceitar CEP não localizado
          // 6. Criação da Fila diferenciada para Sintomas de doenças infectocontagiosas
          // 7. Ajuste para Gravar o DDI - COMENTADO POIS NÃO ESTA ATIVO NA API
          // 8. Ajuste para atualizar o VGPESSOA quando atualiza os dados cadastrais
          // 9. Ajuste para traduzir a tela de autorizar o WhatsApp
          // 10. Ajuste para não ir para tela inicial no timeout do sitef
          // 11. Ajuste para corrigir o travamento da Camera
          // 12. Ajuste para telas de listas não aparecer manha no nome dos itens
          // 13. Inclusão de pontos de log no Sitef
          // 14. Ajustes para busca de cep e preenchimento dos campos

  // VERSAO = 'ASPECT Mídia'#13'Versão 7.7.4.3 21/07/21';
           // 1. correção busca por passaporte


  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.3 15/07/21';
          // 1. Ajuste no fluxo do Reab
          // 2. Ajuste na label Check-in consultas agendadas para Check-ins disponíveis
          // 3. Ajuste no conteudo do arquivo E-mail_Orientativo

  //  VERSAO = 'ASPECT Mídia'#13'Versão 7.7.2 14/07/21';
          // 1. Ajuste no fluxo do Reab
          // 2. Correção na Leitura de Cep Genérico

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.1 09/07/21';
          // 1. Correção no FullScreen
          // 2. Correção no tamanho do botão Fechar (que fica escondido)
          // 3. Alteração de fechar com clique simples ao invés de duplo-clique no botão Fechar (que fica escondido)
          // 4. Correção no tamanho da tela principal
          // 5. Correções de traduções

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.0 08/07/21';
          // 1. Alteração de 7.6 para 7.7 devido a mudança no layout das telas
          // 2. Correções nos logs SQLite e Kibana

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.41 01/07/21';
          // 1. Migração de todos os logs para o SQLite (Kibana)
    		  // 2. Alteração na tela inicial do Fluxo Reab - Tela inicial 3
          // 3. Alteração no fluxo do Aero removendo segunda tela (COLETA/RECEPÇAO)
          // 4. Ajustes na tela de  Cadastro de Cliente
          // 5. Ajuste nas listas da data de visita pais restrito ultima aba Anvisa
          // 6. Geração da senha clicando na tela inicial do Aero por 3 seg.
          // 7. Permissão de alteração de DDI e Passaporte

  // VERSAO = 'ASPECT Mídia'#13'Versão 7.6.40 24/06/21';
          // 1. Gravação de cada passagem no pagamento sitef
          // 2. Ajuste de foco locked da camera
          // 3. Ajuste para não imprimir 2 senhas se não tiver agendamento
          // 4. Corrigido erro consultorio Klabin e Perdizes e
          // 5. Corrigido erro Seleção Profissional Acess Violation
          // 6. Ajuste para corrigir o botão dor no peito criado biAVC_DorPeito6
          // 7. Ajustes para gravação dos parametros do envio da consulta da UPA Digital no INI
          // 8. Correção no click do não localizei médico na tela de escolha do profissional
          // 9. Inclusão da tela de aviso de QRCode inválido no flçuxo da UPA

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.39 16/06/21';
          // 1. Correções no fluxo de APS - incluir steploading em thread
          // 2. Inicío de Logs no Kibana, apenas alguns logs iniciais
          // 3. Ajustes para o uso do OCR dos documentos
    		  // 4. Ajuste para fluxo  PA Digital e leitura de QRDCODE

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.38 11/06/21';
          // 1. Inclusão do item Esteve em Paises Restritos no relatório Anvisa
          // 2. Inclusão de funcionalidade para parametrização dos 3 campos dos convênios (CodigoConvenio, CodigoEscritorio e CodigoPlano)
          // 3. Correções gerais de idiomas
          // 4. Inclusão de funcionalidade para pular a tela de seleção do tipo do pagamento (e todo o processo de pagamento, portanto) caso o convênio seja para faturamento posterior via boleto

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.37 08/06/21';
           // 1. Parametrizacao no INI do SubTipoEpisodioDR para Fluxo de Consultas

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.36 02/06/21';
           // 1. Gravação de cada operação SITEF no arquivo de Relatório SITEF;
           // 2. Criação de método para compactação de arquivos em formato ZIP
           // 3. Backup do arquivo de relatório SITEF do dia anterior em formato ZIP
           // 4. Criação da propriedade NomeTotem no Sistema e gravação do valor no arquivo .INI
           // 5. Geração e envio do arquivo PDF do questionario da gripe.
           // 6. Ajuste na ordem de envio da Passagem/Agendamento no CheckInAPS
           // 7. Ajuste na atualizaçao da Nacionalidade, somente permite alteração se estiver vazio.
           // 8. Nova funcionalidade: Parametrização no INI para o botão "Dor no peito / AVC" ficar visível ou não

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.35 31/05/21';
           // 1. Inclusão de CheckIn quando o cliente seleciona a opção CONVENIO na Consulta Agendada APS

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.34 27/05/21';
           // 1. Inclusão de duas novas telas para selecionar se o paciente é maior ou menor de idade e, se for menos, se a busca é pelo CPF do próprio menor pelo do seu responsável
           // 2. Modificação para pular a etapa de pagamento caso o valor seja zero (não aparecer tela de seleção de pagamento e nem efetuar o pagamento)

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.33 26/05/21';
           // 1. APS - Ajuste do processo de Atualização do Agendamento para nova API
           // 2. Vacina - Inclusão do código de impressão do questionário. Não estava no Trunk. Obtido no Branch

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.32 25/05/21';
           // 1.Fluxo APS com Vacina

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.35 20/05/21';
           // 1. Correção no mecanismo de salvar o responsável do pagamento do episodio
           // 2. Ajustes na quantidade de tentativas de acessar alguns endpoints

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.34 20/05/21';
           // 1. Gravação de cada operação SITEF no arquivo de Relatório SITEF;
           // 2. Criação de método para compactação de arquivos em formato ZIP
           // 3. Backup do arquivo de relatório SITEF do dia anterior em formato ZIP
           // 4. Criação da propriedade NomeTotem no Sistema e gravação do valor no arquivo .INI
           // 5. Alteração no NomearCliente, trocado a API do SICS (ao inves de nomear cliente, incluir Dados Adicionais), para fazer refresh automático nos SicsOnLine

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.33 18/05/21';
           // 1. Retorno em tela do valor salvo no campo passaporte do paciente, responsável 1 e responsável 2. Mascarando últimos 4 caracteres com *.
           // 2. Tratativa de salvamento do campo passaporte para ignorar se estiver em branco ou contendo * (asterisco).
           // 3. Inclusão da tela de seleção de convênio institucional
           // 4. Separação em unit à parte da API Convenio.Incluir
           // 5. Alteração no mecanismo de salvar o responsável do pagamento do episodio
           // 6. Correções em travamentos de câmera
           // 7. Alteração para encode UTF8 em todos os Gets/Posts
           // 8. Correções no fluxo reab

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.32 13/05/21';
           // 1. Alteração para não buscar a foto do profissional
           // 2. Incluido idioma PT para chamada por whatsapp
           // 3. Incluido delay antes do episodiosalvar e episodioresponsavel
           // 4. Inclusão busca do menor pelo CPF do responsável
           // 5. Correção do formato float para envio do valor do pagamento (ponto ao invés de vírgula - tinha sido corrigido no commit 2960 e quebrou novamente no commit 2973)
           // 6. Separação em unit à parte da API EpisodioResponsavel.Salvar
           // 7. Separação em unit à parte da API StatusAgendamento.Alterar
           // 8. Incluído mecanismo de buscar reponsável do pagamento caso tenha apenas menores de idade na lista
           // 9. Inclusão da funcionalidade de impressão do questionário de vacina da gripe em caso de alguma resposta "SIM"
           //10. Correção ao ir para tela de seleção do profissional estava ficando em branco às vezes
           //11. Correção para enviar para a Triagem de acordo com a configuração de cada médico no CheckinConsultaOutros
           //12. Parametrizacao no INI para o botão "Dor no peito / AVC"

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.31 05/05/21';
           // 1. Inclusão das filas para o consultório do 3Andar Morumbi(Outros e Dor no Peito/AVC)

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.30 03/05/21';
           // 1. Ajuste no fluxo dos consultorios(Telas 1, 2, 8 e 9) quando a opção de digitalização estiver ativada
           // 2. Ajuste no fluxo do consultorio(Tela 1) quando digitaliza documento. Não estava mostrando CheckIn do médico
           // 3. SelecaoFila_OutrosAtendimentos_Perdizes - Vacinas agendadas: Visible = False por solicitação do Caio-HIAE em 30/04
           // 4. Inclusão das filas para o consultório do 4Andar Morumbi(Outros e Dor no Peito/AVC)

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.29 29/04/21';
           // 1. Ajuste no carregamento e pesquisa de profissional

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.28 28/04/21';
           // 1. Ajuste na validação de CPF quando o cliente escolher o Passaporte para pesquisa
           // 2. Correção do fluxo de consulta agendada. Enviava diretamente para a recepção
           // 3. Incluida busca id idTrakCare para geração da etiqueta no fluxo de consulta agendada
           // 4. Correções parciais em threads e memory leaks
           // 5. Inclusão de tradução EN/ES na tela de cadastro de cliente
           // 6. Atualização do status da passagem no fluxo do consultório
           // 7. Ordem alfabética dos médicos no fluxo do consultório
           // 8. Correções em hints e warnings
           // 9. Correção na tela de outros atendimentos Unid. Parque Ibirapuera
           // 10. Inclusão da tela de outros atendimentos Unid. Analia Franco
           // 11. Inclusão da tela de outros atendimentos generica
           // 12. Inclusão preliminar do endpoint de desconto para o corpo clínico
           // 13. Correção na impressão de várias senhas no fluxo do consultório
           // 14. Inclusão de log do TEF no log da aplicação
           // 15. Inclusão do parametro INI.Settings.GravarLogApp(Default=True) para geração do log TEF
           // 16. Retirada do botão Vacina na tela 8
           // 17. Mudança do prazo de sintomas Covid de 30 para 20 dias em PT/EN/ES
           // 18. Remoção do Override do StepLoading, gera Steps em ordem incorreta
           // 19. Inclusão do envio do email. Parametros: EnviarEmailExame(0,1), AssuntoEmailExame, CaminhoAnexosEmailExame(com "\" no final)
           // 20. Inclusão de tratamento de erro no retorno dos EndPoints nos fluxos CheckInColeta e CheckInVacinaGripe
           // 21. Correção da busca de agendamentos no fluxo Klabin
           // 22. Melhoria na performance de seleção de profissionais
           // 23. Melhoria no carregamento de profissionais na inicialização do sistema
           // 24. Correção de bug ao cadastrar cliente estava dando access violation (removido o LArrayObjeto.Free no FormShow principal)
           // 25. Inserção preliminar de 2 APIs de forma segregada, cada uma numa Unit. Gradativamente, substituirão a LoadFromAPIs. Ainda, preliminarmente, uma como class e outra não.
           // 26. Criação da procedure IntegracaoAPI_Post para ir gradativamente substituindo a GetFromAPI.
           // 27. Remoção do resource "Nacionalidades.txt". Agora, caso não obtenha a lista de nacionalidades via API, encerra o programa.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.27 09/04/21';
           // 1. Inclusão de ShowLoading no pagamento em dinheiro para não travar a tela
           // 2. Não executar SICS_PDF quando o parametro FormularioAnvisa = FALSE
           // 3. Ajuste no fluxo de Perdizes, quando não tem agendamento, imprime apenas uma senha
           // 4. Ajuste no fluxo de Perdizes, quando tem agendamento, mostra as telas na ordem correta
           // 5. Ajuste na teça de cadastro, quando seleciona "não reconheço essa informação", imprime a senha e volta para a tela inicial


  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.26 09/04/21';
           // 1. Correção no cadastro de clientes ao enviar CPF/Passporte

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.25 08/04/21';
           // 1. Correção de threads: StopLoading colocado dentro de uma TTthread.Syncronize
           // 2. Ajuste no cadastro de estrangeiro quando informa somente o Passaporte

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.24 07/04/21';
           // 1. Correção no fluxo das vacinas no momento da inclusão de novas pessoas

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.23 07/04/21';
           // 1. Alteração no Botão das Vacinas em Santana

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.22 07/04/21';
           // 1. Inclusão das validações detalhadas em todos os campos obrigatórios no cadastro de clientes
           // 2. Checagem do parametro ID_GRUPO_MEDICO na busca de medicos. Só busca se for > 0
           // 3. Validação da data de nascimento para não dar erro de "'' is not a valid integer"

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.21 06/04/21';
           // 1. Alteração no Botão das Vacinas em Alto de Pinheiros

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.20 06/04/21';
           // 1. Correção erro na tela Parque da cidade as TAG estavam puxando no lugar errado

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.18 06/04/21';
           // 1. Alteração tela Parque da cidade, e retirada de telas antigas para padronizar os nomes

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.17 06/04/21';
           // 1. Formulário Anvisa: Inclusão dos campos obrigatórios de Exame/Resultado do Exame

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.16 05/04/21';
           // 1. Formulário Anvisa: Inclusão dos campos obrigatórios Cia Aerea, Origem, Destino e Data
           // 2. Formulário Anvisa: Inclusão de obrigatoriedade de seleção da opção SIM/NÃO
           // 3. Tela Outros Atentimentos Santana

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.15 05/04/21';
           // 1. Formulário Anvisa: Inclusão da informação "Não reside no Brasil" quando o campo ResideBrasil = False
           // 2. Formulário Anvisa: Tradução do questionário para linguagens separadas(PT/EN/ES)
           // 3. Commit PRELIMINAR da função ValidaRespostaEndPoint para validação e mapeamento de erros dos EndPoints
           // 4. Formulário Anvisa: Inserida tela de carregamento para os passos de geração do DAT e PDF

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.14 04/04/21';
           // 1. Correção de erro de mostrar dados do cliente anterior no formulário da Anvisa
           // 2. Correção de erro no Formulário Anvisa: Perda de Olfato e Dor de Garganta não estavam apresentando corretamente no PDF

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.13 01/04/21';
           // 1. Alteração para tratar o 5808 "ERRO #5808: Chave nÃƒÂ£o ÃƒÂ©️ ÃƒÂºnica: siaf.data.siaf.Episodio:XAK16EPSO:^siaf.data.siaf.EpisodioI(XAK16EPSO, 25128414)"

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.12 01/04/21';
           // 1. Fluxo de Consulta Agendada
           // 2. Configuração de 2 impressoras diferente consultorios e vacinas de etiqueta
           // 3. Configuração de 2 Filas de Recepção diferente consultorios e vacinas de etiqueta
           // 4. Ajuste Fluxo de Vacina

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.11 31/03/21';
           // 1. Unificação de fontes Maquina Ricardo com fontes do SVN

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.10 30/03/21';
           // 1. Alterações nas Filas de Outros atendimentos Alto de Pinheiros e Clinica Ibirapuera

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.8 26/03/21';
           // 1. Adicionado tela Selecao de Fila Outros Atendimentos Alto de Pinheiros

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.7 26/03/21';
           // 1. Alteração nas filas da tela Selecao de Fila Outros Atendimentos Clinica Ibirapuera

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.6 25/03/21';
           // 1. Alteração para quando de uma passagem em pré admissão em outra unidade

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.5 25/03/21';
           // 1. Alteração para quando não achar o agendamento criar

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.4 25/03/21';
           // 1. Alteração o valor que sobe para o SAP tem que ser ponto nas casas decimais
           // 2. Alteração para dar o Chegou no agendamento

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.3 22/03/21';
           // 1. Alteração o valor da vacina que estava indo para o pin pad era de uma unica pessoa

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.2 22/03/21';
           // 1. Alteração na questão 5 do questionário são 14 dias e não 15 dias

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.1 22/03/21';
           // 1. Alteração no questionário da vacina da gripe

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.6.0 22/03/21';
           // 1. Correção na rotina de tentar 3x ao fazer Get de APIs, estava entrando em loop infinito
           // 2. Adicionada funcionalidade de carregar do INI o valor da vacina da gripe
           // 3. Correção na data e hora do episódio para usar hora e data atuais do check-in. Estava mudando para a data e hora da passagem mais antiga do prontuario.
           // 4. Correção para mudar o status do agendamento para "Chegou" no check-in da vacina da gripe.
           // 5. Correçao nas telas do Klabin e Perdizes para funcionarem AA de vacina da gripe.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.12 20/03/21';
           // 1. Ajuste no fechamento da câmera, que às vezes travava quando usuário cancelava a operação

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.11 19/03/21';
           // 1. Correção no envio do DDI+telefone para chamada de senhas via whatsapp

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.10 16/03/21';
           // 1. Geração de novos Logs na captura da camera.
           // 2. Fluxo de vacina encorporado nos fontes.
           // 3. Alteração de codigo do Plano Funcionário.
           // 4. Alteração das filas Tela Parque Cidade.
           // 5. Alteração no Agedamento para Unidades Vacinas.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.9 14/03/21';
           // 1. Criação de um aguarde, avisando o usuário o inicio da câmera.
           // 2. Adição de logs nas telas de câmera para captura de documentos.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.8 13/03/21';
           // 1. Alteração na rotina de captura de documentos.
           // 2. Retirada das units de camera do form principal.
           // 3. Inserção de logs adicionais para debug de travamento ao voltar para a tela inicial.
           // 4. Adicionado nova tela de tipo de exame e retirada tela de empresa aérea.
           // 5. Desenvolvimento inicial da inclusão de passaporte para cliente existente no Siaf.
           // 6. Criação de novas filas para reabilitação
           // 7. Envio de Autorização de SMS e Email.
           // 8. Adicionado controle de instâncias para evitar abrir 2x
           // 9. Adicionado tentar 3x em integrações de APIs que sejam de consulta de dados (e não de manipulação/insert/update de dados)

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5.7 26/02/21';
           // 1. Ajustes no arquivo de tradução.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.5 19/02/21';
           // 1. Ajustes no log.
           // 2. Inclusão log para gerar email de monitoramento.
           // 3. Alterações para solução do travamento da camera feitas pelo gabriel.
           // 4. Alterações para tratar erros no consumo dos endpoints.
           // 5. Ajustes no TEF.
           // 6. Ajustes no LOG do TEF.

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.2 08/09/20';
           // 1. Gerar Etiqueta somente se o medico pede triagem
           // 2 - Informação da TAG de Medico não Encontrado no Sics

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.1 23/07/20';
           // 1. Gerar Etiqueta somente se o medico pede triagem
           // 2 - Informação da TAG de Medico não Encontrado no Sics
           // 3 - Informação da TAG de Sem Agendamento
           // 4 - Tratamento de Falha ao buscar dados Siaf
           // 5 - Informação da TAG de Falha ao buscar dados Siaf

  //VERSAO = 'ASPECT Mídia'#13'Versão 7.0 26/05/20';
           // 1. BT #1294 Criação do Modulo Totem AA.
  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.4.1 21/07/20';
           // 1. correção na camera GRU
  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.4.2 21/07/20';
           // 1. correção tela embaçada seleção empresas aéreas, lista dependentes
  //VERSAO = 'ASPECT Mídia'#13'Versão 7.7.4.3 21/07/20';
           // 1. correção busca por passaporte
{$ENDREGION}  {$ENDIF CompilarPara_TOTEMAA}



