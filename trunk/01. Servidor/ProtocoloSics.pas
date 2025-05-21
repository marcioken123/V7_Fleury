unit ProtocoloSics;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
function FormatarProtocolo(const aProtocolo: string): String;
function DecifraProtocolo(s: string; DebugLocalPort : integer; DebugRemoteIP : string): string;
function DecifraProtocoloRetrocompatibilidade(s: string): string;

implementation

uses
  sics_dm, Forms, WinTypes, SysUtils, Controls, StdCtrls, Buttons, Dialogs,
  System.DateUtils, System.Classes, IniFiles, MyAspFuncoesUteis_VCL, MyDlls_DR,
  ufrmDebugParameters, AspJson, System.JSON, Sics_94, Sics_91, Sics_2, Sics_5,
  uFuncoes, Sics_m, DB, untLog, Types, StrUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  UConexaoBD, Sics_92, uTempoUnidade, uDataSetHelper, Winapi.Windows,
  System.Variants;

Type
  TDadosAtenderChamado   = (dacLogin, dacSenha, dacPosicao);
  TDadosSolicitarChamado = (dscPosicao, dscFila, dscID, dscNome);
  TDadosAlterarSenha     = (dasLogin, dasSenhaA, dasSenhaN);
  TDadosAtendenteLogin   = (dalLogin, dalSenha, dalPosicao);

  TDadosStatusTV         = (dstIP, dstTunerPresent, dstVideoState, dstVideoError, dstCurrentUI, dstLegenda);

const
  STX = Chr(2);
  ETX = Chr(3);
  TAB = Chr(9);
  ACK = Chr(6);
  NAK = Chr(21);
  CR = Chr(13);
  LF = Chr(10);
  cSELECT_ALL_COM_MODULO =
    'SELECT C.*, M.NOME FROM %s C INNER JOIN MODULOS M ON M.ID = C.ID AND M.ID_UNIDADE = C.ID_UNIDADE WHERE M.ID_UNIDADE = %d AND C.ID = %d';

  cSELECT_TOTEM_TOUCH =
    'SELECT C.* FROM %s C WHERE ID_UNIDADE = %d AND C.ID = %d';

  cSELECT_TOTEM_SLIM =
    ' SELECT FILAS_PERMITIDAS, BOTOES_COLUNAS, BOTOES_TRANSPARENTES, BOTOES_MARGEM_SUPERIOR, '+
    ' BOTOES_MARGEM_INFERIOR, BOTOES_MARGEM_DIREITA, BOTOES_MARGEM_ESQUERDA, '+
    ' BOTOES_ESPACO_COLUNAS, BOTOES_ESPACO_LINHAS, PORTA_TCP, IMAGEM_FUNDO, '+
    ' PORTA_SERIAL_IMPRESSORA, MOSTRAR_BOTAO_FECHAR, BOTAO_FECHAR_TAM_MAIOR, PODE_FECHAR_PROGRAMA, '+
    ' ST_HABILITA, ST_BOTOES_COLUNAS, ST_BOTOES_MARGEM_SUPERIOR, '+
    ' ST_BOTOES_MARGEM_INFERIOR, ST_BOTOES_MARGEM_ESQUERDA, ST_BOTOES_MARGEM_DIREITA, '+
    ' ST_BOTOES_ESPACO_COLUNAS, ST_BOTOES_ESPACO_LINHAS '+
    ' FROM %s WHERE ID_UNIDADE = %d AND ID = %d';

  cSELECT_TOTEM_TOUCH_TELAS = 'SELECT                                           ' + sLineBreak +
                              '  TE.*,                                          ' + sLineBreak +
                              '  CASE                                           ' + sLineBreak +
                              '    WHEN TT.ID > 0 THEN ''S''                    ' + sLineBreak +
                              '    ELSE ''N''                                   ' + sLineBreak +
                              '  END AS PRINCIPAL                               ' + sLineBreak +
                              'FROM                                             ' + sLineBreak +
                              '  MULTITELAS TE                                  ' + sLineBreak +
                              '  LEFT JOIN TOTENS TT ON (TT.ID_UNIDADE = TE.ID_UNIDADE AND' + sLineBreak +
                              '                          TT.ID_TELA    = TE.ID         AND' + sLineBreak +
                              '                          TT.ID      = %d)       ' + sLineBreak +
                              'WHERE                                                      ' + sLineBreak +
                              '  TE.ID_UNIDADE = %d                                       ' + sLineBreak +
                              'ORDER BY                                         ' + sLineBreak +
                              '  TE.ID';

  cSELECT_TOTEM_TOUCH_BOTOES = 'SELECT                ' + sLineBreak +
                               '  B.ID,               ' + sLineBreak +
                               '  B.NOME,             ' + sLineBreak +
                               '  B.POS_LEFT,         ' + sLineBreak +
                               '  B.POS_TOP,          ' + sLineBreak +
                               '  B.TAM_WIDTH,        ' + sLineBreak +
                               '  B.TAM_HEIGHT,       ' + sLineBreak +
                               '  B.ID_TELA,          ' + sLineBreak +
                               '  B.ID_PROXIMATELA,   ' + sLineBreak +
                               '  B.ID_FILA,          ' + sLineBreak +
                               '  B.ID_TAG            ' + sLineBreak +
                               'FROM                  ' + sLineBreak +
                               '  MULTITELAS_BOTOES B ' + sLineBreak +
                               'WHERE                 ' + sLineBreak +
                               '  B.ID_UNIDADE = %d   ' + sLineBreak +
                               'ORDER BY              ' + sLineBreak +
                               '  B.ID_TELA';

  // -----------------
  // AJUSTES DE PROTOCOLO  (Exemplo com o comando $78)
  //
  // ERRADO                 => #02 + '0003' + '0005' + #$78 + 'A' + #03
  //
  // MENOS ERRADO, QUASE OK => #02 + '0003' + '0000' + #$78 + 'A' + '0005' #03
  //
  // CORRETO                => #02 + '0003' + '0000' + #$78 + 'P' + '0005' + 'A' + #03
  //
  // CORRETO (TGS / ONLINE) => #02 + '0003' + 'FFFF' + #$78 + 'P' + '0005' + 'A' + #03
  // -----------------

  { Protocolo TCP/IP
    {
    {  <STX> <VERSAO> <ADR> <CMD> <DATA> <ETX>
    {
    { 	<STX> = 1 Byte = 02h
    {
    {   <VERSAO>  = 4 bytes = versão do protocolo, em hexadecimal
    {
    { 	<ADR> = string de 4 caracteres representando o endereco em hexadecimal ('0000' = <30h><30h><30h><30h> a 'FFFF' = <46h><46h><46h><46h>)
    { 	        este endereço pode ser o Id de uma PA ou ou Id de um módulo, dependendo do comando
    {
    {   <CMD> = 1 byte
    {     0Ah = Solita configuração gerais path update
    {     0Bh = Re: Configuração gerais path update
    {     0Ch = Re: Versão protocolo diferente
    {     0Dh = Solicita dados SQL
    {     0Eh = Re: Dados SQL
    {     20h = Chamar proxima senha
    {     21h = Chamar senha especifica
    {     22h = Rechamar ultima senha
    {     23h = RE: Chamou senha especifica
    {     24h = RE: Nao chamou nenhuma senha
    {     25h = Finalizar atendimento
    {     26h = RE: Prioridades de atendimento redefinidas. Faça Refresh.
    {     27h = Solicitar mensagem institucional (paineis)
    {     28h = Solicitar início ou término de pausa
    {     29h = Solicitar situacao do atendimento por PAs
    {     2Ah = Solicitar lista dos status das PAs
    {     2Bh = RE: Mensagem institucional (paineis)
    {     2Ch = RE: Mensagem dos bilhetes (rodape impressora de senha)
    {     2Dh = RE: Lista dos status das PAs
    {     2Eh = Redirecionar senha atendida para outra fila (pela PA que está atendendo)
    {     2Fh = Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar próximo cliente
    {     30h = Chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)
    {     31h = Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar senha especifica, se estiver dentro das prioridades do ADR
    {     32h = Redirecionar senha atendida para outra fila (pela PA que está atendendo) e chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)
    {     33h = RE: Comando nao suportado pela versao
    {     34h = Solicitar situacao de filas
    {     35h = RE: Situacao das filas
    {     36h = Solicitar numero de pessoas em espera, de acordo com as prioridades das PAs
    {     37h = RE: Totem touch está sem papel ou com impressora offline (informa ao totem touch que o mesmo deve apresentar mensagem de "sem papel" na tela)
    {     38h = Chamar proxima senha + Horario de retirada da senha
    {     39h = RE: Senha chamada + Horario de retirada da senha
    {     3Ah = Solicitar exclusão de todas as senhas de uma fila
    {     3Bh = RE: Numero de senhas em espera, por PA
    {     3Ch = RE: Situacao do atendimento, por PAs
    **SERV OK, FALTA CLIENTS    {     3Dh = Solicitar nomes das PAs
    **SERV OK, FALTA CLIENTS    {     3Eh = RE: Nomes das PAs
    **    {     3Fh = Solicitar tabela de PPs
    **    {     40h = RE: Tabela de PPs
    **    {     41h = Solicitar tabela de Motivos de Pausa
    **    {     42h = RE: Tabela de Motivos de Pausa
    {     50h = RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA EM NENHUMA FILA
    {     51h = RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA NAS PRIORIDADES DO ATENDENTE
    {     52h = Envio de texto
    {     53h = Finalizar atendimento de uma determinada senha
    {     54h = Solicitar login de atendente - NOVO FORMATO NA V5, COM ID_MODULO, LOGIN_ATD E HASH DA SENHA_LOGIN
    {     55h = Solicitar logout de atendente especifico
    {     56h = Solicitar nome de cliente para uma senha
    {     57h = RE: Definir nome de cliente para uma senha
    {     58h = Solicitar situação dos processos paralelos de uma senha ou de todas
    {     59h = RE: Situação dos processos paralelos
    {     5Ah = Solicitar finalização de processos paralelos
    {     5Bh = Solicita login de atendente e conferencia da senha  <= APENAS PARA TECLADO, POIS NÃO ENCRIPTA A SENHA !!!!
    {     5Ch = RE: Nome do atendente logado
    {     5Dh = Solicitar logout do atendente que estiver na PA
    {     5Eh = Solicitar situacao total da PA                      <= APENAS PARA TECLADO, POIS NÃO ENCRIPTA A SENHA E DEVOLVE O ID DA PA (ADR) COM DOIS DÍGITOS APENAS E NÃO 4!!!!
    {     5Fh = RE: Situacao total de uma PA
    {     60h = RE: Teclado serial 1100 - Apaga Flash
    {     61h = RE: Teclado serial 1100 - Grava Bloco em Flash
    {     62h = RE: Teclado serial 1100 - Gravacao Completa de Bloco em Flash
    {     63h = Teclado serial - Erro de Gravacao de Bloco em Flash
    **    {     64h = Solicitar nomes dos PIs
    **    {     65h = RE: Nomes dos PIs
    {     66h = Solicitar situacao dos PIs
    {     67h = RE: Situacao dos PIs
    {     68h = Solicitar início de PP
    {     69h = Solicitar evento de marcar/desmarcar uma checkbox de fila prioritária ou bloqueada
    {     6Ah = Solicitar exclusão de uma senha
    {     6Bh = Solicitar inclusão de uma senha numa fila
    {     6Ch = Solicitar situação detalhada de uma fila
    {     6Dh = RE: Situação detalhada das senhas de uma ou mais filas
    **??    {     6Eh = Solicitar situação detalhada dos status "prioritária" e "bloqueada" das filas
    **??    {     6Fh = RE: Situação detalhada dos status "prioritária" e "bloqueada" das filas
    {     70h = Solicitar evento de clique de um botão de retirada de senha, informando em qual impressora imprimir a senha  (NOVO)
    **TALVEZ REDESENHAR PARA APENAS NOME E CRIAR NOVO PARA ALTERAÇÃO DE SENHA    {     71h = Solicitar nome, login, grupo, senha e ativo dos atendentes
    **TALVEZ REDESENHAR PARA APENAS NOME E CRIAR NOVO PARA ALTERAÇÃO DE SENHA    {     72h = RE: Nome, login, grupo, senha e ativo de atendentes, também utilizado para solicitar alteração de dados para um atendente => OBS: Servidor sempre envia somente os ativos
    {     73h = RE: Chamada de senhas em "painel" do tipo SicsTV
    {     74h = Solicitar inserção de atendente
    {     75h = RE: Novo atendente inserido
    {     76h = Solicitar impressão de código de barras de atendente, PA ou Fila
    {     77h = Redirecionar senha para outra fila, pela senha
    **    {     78h = Solicitar nomes dos Grupos (PAs, Atds, Filas, Tags, PPs, etc)
    **    {     79h = RE: Nomes das Grupos (PAs, Atds, Filas, Tags, PPs, etc)
    {     7Ah = Tabela reconfigurada, solicitar Refresh
    **    {     7Bh = Solicitar nomes e cor das filas  (NOVO)
    **    {     7Ch = RE: Nomes e cores das filas      (NOVO)
    {     7Dh = Definir TAG para uma determinada senha
    {     7Eh = Re: TAG para uma determinada senha
    **    {     7Fh = Solicitar nomes das TAGs

    {  *** 80 a 9F seriam os evitáveis devido a problemas com o UNICODE dos mesmos

    **??    {***  86h = RE: Nomes no totem e cores das filas ****REMOVIDO****
    **??    {     88h = Solicitar lista de canais permissionados e canal padrão
    **??    {     89h = RE: Lista de canais permissionados
    {     8Ah = Setar canal padrão
    {     8Bh = RE: Canal padrão setado
    **OK    {     8Ch = Solicitar parâmetros do módulo SICS
    {     8Dh = --- (vago)
    {     8Eh = --- (vago)
    {     8Fh = --- (vago)

    {     A0h = Solicitar configurações de envio de e-mail ou SMS
    {     A1h = RE: Configurações de envio de e-mail ou SMS
    {     A2h = Solicitar envio de e-mail ou SMS de teste
    {     A3h = RE: Envio de mensagem para PA com alarme de PI
    {     A4h = Ajuste de volume e canal (para o AverTV)


    {     A7h = Solicita Status TV(para o LiveTV)
    {     A8h = RE: Solicita Status TV(para o LiveTV)




    **    {     AAh = Re: Nomes das TAGs
    {     ABh = Solicitar TAGs de uma senha específica
    {     ACh = Re: TAGs de uma senha específica
    {     ADh = Solicitar Desassociacao de TAGs
    {     AEh = Re: Desassociacao de TAGs
    **    {     AFh = Solicitar nomes no totem e cores das filas

    {     B1h = Solicitar reimpressão de uma senha específica, informando em qual impressora imprimir a senha
    **OK    {     B2h = RE: Parâmetros do módulo SICS
    {     B3h = Obter lista de conexões TCP/IP
    {     B4h = RE: Login efetuado ou acesso negado
    {     B5h = Informa que o servidor deverá solicitar lista de canais ao painel (TV)
    {     B6h = Envia canais permissionados
    {     B7h = RE: Lista de conexões TCP/IP
    {     B8h = RE: Logout efetuado ou falha no logout
    {     B9h = RE: pausa iniciada/finalizada ou falha ao iniciar/finalizar pausa
    {
    {     C1h = Solicitar login de um atendente numa PA, e cadastrar o ATD caso ele não exista, cadastrando também o Grupo do Atendente caso não exista (Forçar Login)
    {     C2h = Solicitar lista de agendamentos por fila para uma senha
    {     C3h = RE: lista de agendamentos por fila para uma senha
    {     C4h = Solicitar Prioridades de Atendimento por PA
    {     C5h = RE: Lista de prioridades por PA
    {     C6h = RE: Senha gerada via solicitação do comando $70
    {     C7h = Solicitar lista de filas que geram senhas (range definido)
    {     C8h = RE: lista de filas que geram senhas (range definido)
    {     C9h = Solicitar status de uma senha
    {     CAh = RE: Status de uma senha
    {     CBh = Atualizar Dados Adicionais de uma senha
    {     CCh = RE: Status da atualização dos dados adicionais
    {     CDh = Obter Dados Adicionais de uma senha
    {     CEh = RE: Dados adicionais de uma senha
    {     CFh = Solicitar Paineis do Tipo TV
    {     D0h = RE: Obter Paineis do Tipo TV

    {     D1h = Obter Alarmes da PA //LM Protocolo de Retrocomps
    {     D2h = RE: Obter Alarmes da PA //LM
    {     D3h = Login Gestor CallCenter //LM
    {     D4h = RE: Login Gestor CallCenter //LM
    {     D5h = Gerar Senha Fila Operador CallCenter //LM
    {     D6h = RE: Gerar Senha Fila Operador CallCenter //KM
    {     D7h = Alterar Senha Cliente CallCenter //LM
    {     D8h = RE: Senha Alterada Call Center //LM
    {     D9h = Notifica Módulo Online quando nova senha for gerada para Call Center //KM
    {     DAh = Solicita Lista de Filas para as quais cada PA pode encaminhar
    {     DBh = RE: Lista de Filas para as quais cada PA pode encaminhar
    {     DCh = Solicitar Pessoas nas Filas de Espera //AG
    {     DDh = RE: Solicitar Pessoas nas Filas de Espera //AG
    {     DEh = Solicitar evento de clique de um botão de retirada de senha com lista de TAGs a atribuir para a senha
    {     DFh = RE: Senha gerada via solicitação do comando $DE
    {     E0h = Login Cliente CallCenter //LM
    {     E1h = RE: Login Cliente CallCenter //LM
    {     E2h = Logout Cliente CallCenter //LM
    {     E3h = RE: Logout Cliente CallCenter //LM
    {     E4h = Lista de Totem //LM
    {     E5h = RE: Lista de Totem //LM
    {     E6h = Lista Telas do Totem, com respectivos botões //LM
    {     E7h = RE: Lista Telas do Totem, com respectivos botões //LM
    {     E8h = Obter Tempo de Espera de uma fila//LM
    {     E9h = RE: Obter Tempo de Espera de uma fila //LM
    {     EAh= Solicitar login de atendente //LM protocolo de retrocompatibilidade
    {     EBh= RE: Login efetuado ou acesso negado //LM protocolo de retrocompatibilidade
    {     ECh = Solicitar nomes das filas //LM
    {     EDh = RE: Nomes das filas //LM
    {     EEh = Obter TME de todas as Filas de uma Unidade //LM
    {     EFh = RE: Obter TME de todas as Filas de uma Unidade //LM
    {     F0h = Obter TEE de todas as Filas de uma Unidade //LM
    {     F1h = RE: Obter TEE de todas as Filas de uma Unidade **Ver Luciano //LM
    {     F2h = Obter TMA de todas as Filas de uma Unidade //LM
    {     F3h = RE: Obter TMA de todas as Filas de uma Unidade //LM
    {     F3h = Obter o grupo de filas
    {     F5h = Obter a categorias de filas
    {     F7h = Imprimir um texto livre num totem
    {     F8h = RE: Texto livre impresso num totem ou não
	

    {     F1h = Teclado serial - ERRO Timeout **Ver Luciano
    {
    {	<DATA> = N Bytes:
    {		Se CMD = 21h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha chamada (ex: ‘345’)
    {		Se CMD = 23h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha chamada (ex: ‘345’)
    {   Se CMD = 24h entao
    {     <DATA> = <REA> <PSWD>
    {       onde: <REA> = 1 byte = razão pela qual não chamou nenhuma senha, que pode ser:
    {                              '0' = 30h = nao ha mais senhas a serem chamadas
    {                              'N' = 4Eh = senha solicitada nao se encontra em nenhuma fila
    {                              'P' = 50h = senha solicitada se encontra numa fila nao inclusa nas prioridades de atendimento do ADR
    {                              'L' = 4Ch = nao tem atendente logado na PA
    {                              'M' = 4Dh = número de atendimentos ultrapassa magazine
    {                              'I' = 49h = senha inválida (fora do range)
    {                              'p' = 70h = PA está em pausa
    {             <PWD> = string = senha solicitada (ex: ‘345’) (no caso de <REA> = 00h, <PSWD> = '')
    { 	Se CMD = 26h então
    {			<DATA> = '' (nil)
    { 	Se CMD = 27h então
    {			<DATA> = <PNL>
    {				onde: <PNL> = string 4 caracteres representando o id do painel para o qual se solicita a mensagem
    { 	Se CMD = 28h então
    {			<DATA> = <MP><Fx>
    {				onde: <MP> = string 4 caracteres representando o id do motivo de pausa que está iniciando, ou '----' caso seja para finalizar a pausa
    {             <Fx> = string 4 caracteres representando o id da fila que será redirecionada a senha em atendimento caso seja para iniciar a pausa
    {		Se CMD = 2A entao
    {			<DATA> = '' (nil)
    {		Se CMD = 2Bh entao
    {			<DATA> = <PNL> <MSG>
    {				onde: <PNL> = string 4 caracteres representando o id do painel para ser mudada a mensagem
    {             <MSG> = string com a mensagem (institucional ou bilhete)
    {		Se CMD = 2Ch entao
    {			<DATA> = <MSG>
    {				onde <MSG> = string com a mensagem (institucional ou bilhete)
    {		Se CMD = 2Dh entao
    {			<DATA> = <NSTATUS> <STATUS1> <NOME1> <TAB> ... <STATUSn> <NOMEn> <TAB>
    {       onde: <NSTATUS> = string de 4 caracteres representando o numero de STATUS DE PAs em hexadecimal
    {             <STATUSx> = string de 4 caracteres representando o ID do x-ésimo STATUS em hexadecimal
    {				      <NOMEx>   = string de tamanho variavel com o nome do x-ésimo STATUS
    {				      <TAB>     = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 2Eh entao
    {     <DATA> = <Fx>
    {       onde: <Fx> = string de 4 caracteres representando a x-esima fila em hexadecimal (número da fila em a senha deve ser inserida) (V4.0: 2chars -> 4 chars)
    {   Se CMD = 2Fh entao
    {     <DATA> = <Fx>
    {       onde: <Fx> = string de 4 caracteres representando a x-esima fila em hexadecimal (número da fila em a senha deve ser inserida) (V4.0: 2chars -> 4 chars)
    {		Se CMD = 30h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha chamada (ex: ‘345’)
    {   Se CMD = 31h entao
    {     <DATA> = <Fx> <PSWD>
    {       onde: <Fx>   = string de 4 caracteres representando a x-esima fila em hexadecimal (número da fila em a senha deve ser inserida) (V4.0: 2chars -> 4 chars)
    {             <PSWD> = string = senha solicitada (ex: ‘345’)
    {   Se CMD = 32h entao
    {     <DATA> = <Fx> <PSWD>
    {       onde: <Fx>   = string de 4 caracteres representando a x-esima fila em hexadecimal (número da fila em a senha deve ser inserida) (V4.0: 2chars -> 4 chars)
    {             <PSWD> = string = senha solicitada (ex: ‘345’)
    {   Se CMD = 35h entao
    {     <DATA> = <NF> <F1> <N1> <TIME1> <TAB>... <Fn> <Nn> <TIMEn> <TAB>
    {	  			onde: <NF> = string de 4 caracteres representando o numero de filas em hexadecimal
    {               <Fx> = string de 4 caracteres representando a x-esima fila em hexadecimal
    {               <Nx> = string de 4 caracteres representando o numero de pessoas na x-ésima fila em hexadecimal
    {               <TIMEx> = string de 14 caracteres representando o horario de retirada da senha mais antiga da x-ésima fila = 'ddmmyyyyhhnnss'
    {               <TAB> = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 37h entao
    {     <DATA> = <STATUS>
    {	  			onde: <STATUS> = 1 caractere =
    {                         '0' = 30h = impressora offline ou sem papel
    {                         '1' = 31h = impressora online
    {   Se CMD = 3Ah então
    {    <DATA> = <Fx>
    {    onde: <Fx> = string de 4 caracteres representando a fila da qual se deseja excluir todas as senhas, em hexadecimal
    {   Se CMD = 3Bh entao
    {     <DATA> = <NATD> <PA1> <NPSWD1> <TAB> <PA2> <NPSWD2> <TAB> ... <PAn> <NPSWDn> <TAB>
    {			  onde: <NATD> = string de 4 caracteres representando o numero de PAs em hexadecimal
    {				      <PAx> = string de 4 caracteres representando a x-ésima PA em hexadecimal
    {				      <NPWDx> = string de 3 caracteres representando, em hexadecimal, o numero de senhas em espera para a x-ésima PA, de acordo com suas prioridades de atendimento
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 3Ch entao
    {			<DATA> = <NPA> <PA1> <TIME1> <STAT1> <ATD1> <FILA1> <MP1> <PWD1> <PV> <NOME1> <TAB> ... <PAn> <TIMEn> <STATn> <ATDn> <FILAn> <MPn> <PWDn> <PV> <NOMEn> <TAB>
    {				onde: <NPA>   = string de 4 caracteres representando o numero de PAs em hexadecimal
    {             <PAx>   = string de 4 caracteres representando a x-ésima PA em hexadecimal
    {				      <TIMEx> = string de 14 caracteres = 'ddmmyyyyhhnnss'
    {             <STATx> = string de 4 caracteres representando o status da x-ésima PA em hexadecimal
    {				      <ATDx>  = string de 4 caracteres representando o atendente logado na PA em hexadecimal (ou '----' se não houver atendente logado)
    {				      <FILAx> = string de 4 caracteres representando a fila proveniente da senha na PA em hexadecimal (ou '----' se não tiver fila proveniente)
    {             <MPx>   = string de 4 caracteres representando o motivo da pausa da x-ésima PA em hexadecimal (ou '----' se não estiver em pausa)
    {				      <PWDx>  = string = senha nesta PA (ex: ‘345’, '21', '1327', ‘---‘)
    {				      <NOMEx> = string de tamanho variavel com o nome do cliente nesta PA
    {				      <PV>    = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB>   = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 3D entao
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {		Se CMD = 3Eh entao
    {			<DATA> = <ID_MODULO> <NPA> <PA1> <NOME1> <PV> <GRUPO1> <TAB> ... <PAn> <NOMEn> <PV> <GRUPOn> <TAB>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal
    {             <PAx>       = string de 4 caracteres representando o ID da x-ésima PA em hexadecimal
    {				      <NOMEx>     = string de tamanho variavel com o nome da x-ésima PA
    {				      <PV>        = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <GRUPOx>    = string de tamanho variavel com o ID do GRUPO DE PAS ao qual esta x-ésima PA pertence
    {				      <TAB>       = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 3Fh entao
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {		Se CMD = 40h entao
    {			<DATA> = <ID_MODULO> <NPA> <NPP> <PP1> <COR1> <GR1> <PV> <NOME1> <TAB> ... <PPn> <CORn> <GRn> <PV> <NOMEn> <TAB>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <NPP> = string de 4 caracteres representando o numero de PPs em hexadecimal
    {             <PPx> = string de 4 caracteres representando o ID do x-ésimo PP em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor do x-ésimo PP, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {             <GRx> = string de tamanho variavel com o ID do GRUPO DE PPS ao qual este x-ésimo PP pertence
    {				      <NOMEx> = string de tamanho variavel com o nome do x-ésimo PP
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 41h entao
    {			<DATA> = '' (nil)
    {		Se CMD = 42h entao
    {			<DATA> = <NMP> <MP1> <COR1> <GR1> <PV> <NOME1> <TAB> ... <PPn> <CORn> <GRn> <PV> <NOMEn> <TAB>
    {				onde: <NMP> = string de 4 caracteres representando o numero de Motivos de Pausa em hexadecimal
    {             <MPx> = string de 4 caracteres representando o ID do x-ésimo Motivo de Pausa em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor do x-ésimo Motivo de Pausa, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {             <GRx> = string de tamanho variavel com o ID do GRUPO DE MOTIVOS DE PAUSA ao qual este x-ésimo Motivo de Pausa pertence
    {				      <NOMEx> = string de tamanho variavel com o nome do x-ésimo Motivo de Pausa
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 50h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha que não estava em nenhuma fila (ex: ‘345’)
    {		Se CMD = 51h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha que não estava nas prioridades da PA (ex: ‘345’)
    {		Se CMD = 53h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha cujo atendimento deseja-se finalizar (ex: ‘345’)
    {		Se CMD = 54h entao
    {			<DATA> = <MODULO> <TAB> <LOGIN> <TAB> <HASH>
    {				onde: <MODULO> = string de 4 caracteres com o id do módulo, em hexadecimal
    {             <LOGIN> = string de tamanho variavel representando o login OU o id (em decimal) do atendente a ser logado na PA
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {				      <HASH> = string de tamanho variavel com o hash da senha do atendente para conferência pelo servidor
    {		Se CMD = 55h entao
    {			<DATA> = <ATD>
    {				onde: <ATD> = string de tamanho variavel representando o numero do atendente a ser feito logout, em hexadecimal
    {		Se CMD = 56h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha cujo nome do cliente deseja-se saber (ex: ‘345’)
    {		Se CMD = 57h entao
    {			<DATA> = <SENHA> <TAB> <NOME>
    {				onde: <SENHA> = string de tamanho variavel com o numero da senha que recebera o nome do cliente
    {				      <TAB>   = 1 caracter = tabulacao = ASCII 09h
    {             <NOME>  = string de tamanho variavel com o nome do cliente
    {		Se CMD = 58h entao
    {			<DATA> = <PWD>
    {				onde: <PWD> = string de tamanho variável com a senha cujos PPs deseja-se saber (ex: ‘345’), ou '' (nil) caso se deseje todos os PPs, de todas as senhas
    {   Se CMD = 59h entao
    {     <DATA> = <ID_EVENTOPP1> <PV> <PP1> <PA1> <ATD1> <TIME1> <PWD1> <PV> <NOME1> <TAB> ... <ID_EVENTOPPn> <PV> <PPn> <PAn> <ATDn> <TIMEn> <PWDn> <PV> <NOMEn> <TAB>
    {				onde: <ID_EVENTOPPn> = string de tamanho variável com o ID do evento do PP em decimal
    {             <PPx>          = string de 4 caracteres com o ID do PP (tipo do PP)
    {             <PAx>          = string de 4 caracteres com o ID da PA onde se iniciou o x-ésimo PP, em hexadecimal (ou '----' se não houver PA)
    {				      <ATDx>         = string de 4 caracteres com o ID do atendente que iniciou o x-ésimo PP, em hexadecimal (ou '----' se não houver atendente)
    {				      <TIMEx>        = string de 14 caracteres = 'ddmmyyyyhhnnss'
    {				      <PWDx>         = string = senha deste PP (ex: ‘345’, '21', '1327')
    {				      <NOMEx>        = string de tamanho variavel com o nome do cliente deste PP
    {				      <PV>           = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB>          = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 5Ah entao
    {     <DATA> = <ATD> <PWD> <V> <ID_EVENTOPP1> <PV> <ID_EVENTOPP2> <PV> ... <ID_EVENTOPPn>
    {				onde: <ATD>          = string de 4 caracteres com o ID do atendente que deseja finalizar este PP, em hexadecimal (ou '----' se não houver atendente)
    {				      <PWD>          = string de tamanho variável com a senha a que se referem estes IDs de Evento de PP. Presume-se que todos os eventos
    {                              referem se à mesma senha, a qual é necessária indicar no protocolo, para que o servidor monte a lista dos PPs
    {                              que restaram em andamento para tal senha, após a finalização de PPs solicitada por este comando
    {             <ID_EVENTOPPx> = string de tamanho variável com o ID do evento do x-ésimo PP que deseja-se finalizar, em decimal
    {             <V>            = 1 caractere = vírgula = "," = ASCII 2Ch
    {				      <TAB>          = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 5Bh entao
    {			<DATA> = <NATD> <SENHA>
    {				onde: <NATD>  = string de 4 caracteres representando o numero do atendente tentando fazer login, em hexadecimal
    {				      <SENHA> = string de tamanho variavel com a senha de login deste atendente, para conferência pelo servidor (NÃO CRIPTOGRAFADA POIS USADA PELO TECLADO)
    {		Se CMD = 5Ch entao
    {			<DATA> = <NOME>
    {				onde: <NOME> = string de tamanho variavel com o nome do atendente logado na PA
    { 	Se CMD = 5Eh então
    {			<DATA> = '' (nil)
    {		Se CMD = 5Fh então
    {			<DATA> = <NPWD><NOME><TAB><PWD><TAB><TIME>
    {				onde: <NPWD> = string de 4 caracteres representando, em hexa, o No. de senhas em espera
    {                      para tal PA, de acordo com suas prioridades de atendimento
    {             <NOME> = string de tamanho variável com o nome do atendente logado na PA
    {                      (ou '---' se não tiver atendente logado)
    {             <PWD>  = string de tamanho variável com a senha sendo atendida nesta PA
    {                      (ex: '345', '21', '1327', '---')
    {				      <TIME> = string de 14 caracteres = 'ddmmyyyyhhnnss', com horário desde qual a
    {                      senha está sendo atendida ou a PA esta disponível
    {				      <TAB>  = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 64h então
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {		Se CMD = 65h então
    {			<DATA> = <ID_MODULO> <NPA> <NPI> <PI1> <NOME1> <TAB> ... <PIx> <NOMEx> <TAB>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PIs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <PIx>       = string de 4 caracteres representando o ID do x-ésimo PI em hexadecimal
    {				      <NOMEx>     = string de tamanho variavel com o NOME do x-ésimo PI
    {				      <TAB>       = 1 caracter = tabulacao = ASCII 09h
    { 	Se CMD = 66h então
    {			<DATA> = '' (nil)
    {		Se CMD = 67h então
    {			<DATA> = <NPI> <PI1> <EST1> <VAL1> <PV> <VAL_NUM1> <PV> <FLAG1> <TAB> ... <PIn> <ESTn> <VALn> <PV> <VAL_NUMn> <PV> <FLAGn> <TAB>
    {				onde: <NPI> = string de 4 caracteres representando o numero de PIs em uso no momento em hexadecimal
    {				      <PIx> = string de 4 caracteres com o ID do x-ésimo ATENDENTE
    {				      <ESTx> = string de 1 caracter com o estado do x-ésimo PI, que pode ser:
    {                        'N' = 4Eh = estado NORMAL
    {                        'A' = 41h = estado ATENÇÃO
    {                        'C' = 43h = estado CRÍTICO
    {                        '?' = 3Fh = estado INDEFINIDO
    {             <VALx> = string de tamanho variavel com o VALOR do x-ésimo PI (já formatado como string, ou seja, o horário pode vir '1h05' e uma qtd pode vir '5')
    {             <VAL_NUMx> = string de tamanho variavel com o VALOR NUMÉRICO do x-ésimo PI  (sempre em formato numerico integer, ou seja, o horário virá em qtd total de segundos '3900' e uma qtd pode vir '5')
    {             <FLAGx> = 1 caracter = '0' informando que trata-se de uma quantidade (integer) ou '1' informando que trata-se de um TDateTime expresso em segundos
    {				      <PV>  = 1 caracter = ponto-e-virgula = ";" = ASCII 3Bh
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 68h entao
    {     <DATA> = <ATD> <ID_EVENTOPP1> <PWD>
    {				onde: <ATD>          = string de 4 caracteres com o ID do atendente que deseja iniciar este PP, em hexadecimal (ou '----' se não houver atendente)
    {             <ID_EVENTOPPx> = string de 4 caracteres com com o ID do PP que deseja-se iniciar, em decimal
    {             <PWD>          = string de tamanho variável com a senha para a qual deseja-se iniciar um PP (ex: '345', '21', '1327', etc)
    {   Se CMD = 69h então
    {     <DATA> = <NF> <TCB> <ONOFF>
    {       onde: <NF>    = string de 4 caracteres representando o número da fila cujo checkbox foi pressionado
    {             <TCB>   = string de 1 caracter representando o checkbox pressionado, que pode ser:
    {                         'P' = 50h = checkbox 'prioritária'
    {                         'B' = 42h = checkbox 'bloqueada'
    {             <ONOFF> = string de 1 caractere representando o estado do checkbox, que pode ser:
    {                         '0' = 30h = não checado, desligado
    {                         '1' = 31h = checado, ligado
    {   Se CMD = 6Ah então
    {			<DATA> = <SENHA>
    {				onde: <SENHA> = string de tamanho variavel com a senha a ser excluída
    {   Se CMD = 6Bh então
    {			<DATA> = <NF> <SENHA>
    {				onde: <NF>    = string de 4 caracteres representando a fila no início da qual a senha deve ser inserida, em hexadecimal
    {             <SENHA> = string de tamanho variavel com a senha a ser inserida
    {   Se CMD = 6Ch então
    {			<DATA> = <F1>
    {				onde: <F1> = string de 4 caracteres representando a fila para a qual se deseja a situação, em hexadecimal
    {   Se CMD = 6Dh então
    {	    V4.2-> <DATA> = <F1> <S1> <V> <N1> <TAB> <T1> <PV> <S2> <V> <N2> <TAB> <D2> <PV> ... <Sn> <V> <Nn> <TAB> <Dn> <PV>
    {			V4.3-> <DATA> = <F1> <S1> <TAB> <N1> <TAB> <TAG1> <TAB> <T1> <TAB> <S2> <TAB> <N2> <TAB> <TAG2> <TAB> <D2> <TAB> ... <Sn> <TAB> <Nn> <TAB> <TAGn> <TAB> <Dn> <TAB>
    {				onde: <F1>     = string de 4 caracteres representando a fila que será detalhada, em hexadecimal
    {             <Sn>   = string de tamanho variavel com a n-ésima senha da fila
    {             <Nn>   = string de tamanho variavel com o n-ésimo nome da fila
    {             <TAGn> = string de tamanho variavel com as TAGs da n-ésima senha da fila, separadas por vírgula, com uma vírgula ao final,
    {                      por exemplo: "1,15,3,"
    {             <T1>   = string de 14 caracteres com horário da primeira senha da fila, no formato "ssnnhhddmmyyyy"
    {             <Dn>   = string de tamanho variável com a diferença no horário da n-ésima senha,
    {                      em relação à senha anterior. Se a string tiver 2 caracteres, estes representam
    {                      "ss", ou seja, os segundos, ou seja, o horário desta n-ésima senha é idêntico ao da senha anterior,
    {                      exceto pelos segundos, que são, nesta n-ésima, iguais à string formada pelo parâmetro <F1SnDn> ("ss").
    {                      Se tiver 4 caracteres, estes representam "ssnn", ou seja, os minutos e segundos da n-ésima senha
    {                      (o resto do horário da senha, idêntico ao da senha anterior). Se tiver 6 caracteres, "ssnnhh". Se
    {                      forem 8 caracteres, "ssnnhhdd". Se 10, "ssnnhhddmm" e, se 14, "ssnnhhddmmyyyy". Se 0, o horário é o mesmo da anterior.
    {             <V>      = 1 caractere = vírgula         = "," = ASCII 2Ch
    {             <PV>     = 1 caractere = ponto-e-vírgula = ";" = ASCII 3Bh
    {				      <TAB>    = 1 caracter = tabulacao = ASCII 09h
    {   Se CMD = 6Eh então
    {			<DATA> = '' (nil)
    {   Se CMD = 6Fh então
    {			<DATA> = <F1> <BL1> <PR1> <TAB> <F2> <BL2> <PR2> <TAB> ... <Fx> <BLx> <PRx> <TAB>
    {				onde: <Fx>  = string de 4 caracteres representando a x-ésima fila, em hexadecimal
    {             <BLx> = string de 1 caractere representando o estado "bloqueada" da x-ésima fila, que pode ser:
    {                              '0' = 30h = não bloqueada
    {                              '1' = 31h = bloqueada
    {             <PRx> = string de 1 caractere representando o estado "prioritária" da x-ésima fila, que pode ser:
    {                              '0' = 30h = não prioritária
    {                              '1' = 31h = prioritária
    {				      <TAB> = 1 caractere = tabulação = ASCII 09h
    {		Se CMD = 70h então
    {			<DATA> = <NF> <NPRN>
    {				onde: <NF>   = string 4 caracteres representando o número do botão (fila) que foi pressionado em hexadecimal
    {				      <NPRN> = string 4 caracteres representando o número da impressora para a qual direcionar a impressão da senha (0 = paralela ou serial ou totem1, 1 = totem1, 2 = totem2, etc)
    {		Se CMD = 72h entao
    {			<DATA> = <NATD> <ATD1> <NOME1> <PV> <REGFUNC1> <PV> <GR1> <PV> <PWD1> <TAB> ... <ATDn> <NOMEn> <PV> <REGFUNCn> <PV> <GRn> <PV> <PWDn> <TAB>
    {				onde: <NATD> = string de 4 caracteres representando o numero de ATENDENTES em hexadecimal
    {				      <ATDx> = string de 4 caracteres representando o ID do x-ésimo ATENDENTE em hexadecimal
    {             <NOMEx> = string de tamanho variavel com o nome do x-ésimo ATENDENTE
    {             <REGFUNCx> = string de tamanho variavel com o registro funcional do x-ésimo ATENDENTE
    {             <GRx> = string de tamanho variavel com o ID do GRUPO DE ATENDENTES ao qual este x-ésimo ATENDENTE pertence
    {             <PWDx> = string de tamanho variavel com a SENHA deste x-ésimo ATENDENTE (CRIPTOGRAFADA)
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 73h entao
    {			<DATA> = '' (nil)   (neste caso o painel deve ser apagado)
    {     ou
    {			<DATA> = <PA> <NOME_PA_PAINEL> <PV> <TCK> <PV> <NOME_CLIENTE> <PV> <NOME_PA_VOZ>
    {				onde: <PA>             = string de 4 caracteres representando a PA em hexadecimal que está chamando a senha
    {				      <NOME_PA_PAINEL> = string de tamanho variavel com o texto desta PA a ser apresentado como texto na TV
    {				      <PV>             = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <TCK>            = string de tamanho variavel com a senha a ser chamada
    {				      <NOME_CLIENTE>   = string de tamanho variavel com o nome do cliente a ser apresentado no painel
    {				      <NOME_PA_VOZ>    = string de tamanho variavel com o texto desta PA a ser lido por voz (text-to-speach) na TV
    {		Se CMD = 74h entao
    {			<DATA> = <NOME> <PV> <LOGIN> <PV> <GR> <PV> <PWD>
    {				onde: <NOME> = string de tamanho variavel com o nome do ATENDENTE a ser inserido
    {             <LOGIN> = string de tamanho variavel com o login do ATENDENTE a ser inserido
    {             <GR> = string de tamanho variavel com o ID do GRUPO DE ATENDENTES ao qual este ATENDENTE deve pertencer
    {             <PWD> = string de tamanho variavel com a SENHA deste ATENDENTE a ser inserido
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {		Se CMD = 75h entao
    {			<DATA> = <ATD>
    {				onde: <ATD> = string de 4 caracteres representando o ID do ATENDENTE inserido, em hexadecimal
    {		Se CMD = 76h entao
    {			<DATA> = <TABELA> <ID>
    {       onde: <TABELA> = 1 byte = tabela que foi reconfigurada:
    {                                 'A' = 41h = Atendentes
    {                                 'P' = 50h = PAs
    {                                 'F' = 46h = Filas
    {				      <ID> = string de 4 caracteres representando o ID do ATENDENTE cujo código de barras deve ser impresso, em hexadecimal
    {		Se CMD = 77h entao
    {     <DATA> = <NF> <PSWD>
    {       onde: <NF>   = string de 4 caracteres representando a fila em hexadecimal (número da fila para a qual a senha deve ser redirecionada) (V4.0: 2chars -> 4 chars)
    {             <PSWD> = string de tamanho variável = senha que deve ser redirecionada para esta fila (ex: ‘345’)
    {   Se CMD = 78h entao
    {     <DATA> = <TIPO> <ID_MODULO>
    {       onde: <TIPO> = 1 byte = tipo de grupos solicitados:
    {                               'A' = 41h = Grupos de Atendentes
    {                               'F' = 46h = Grupos de Filas
    {                               'P' = 50h = Grupos de PAs
    {                               'T' = 54h = Grupos de TAGs
    {                               'p' = 70h = Grupos de PPs
    {                               'M' = 70h = Grupos de Motivos de Pausa
    {				      <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {		Se CMD = 79h entao
    {			<DATA> = <ID_MODULO> <NPA> <TIPO> <NGR> <GR1> <NOME1> <TAB> ... <GRn> <NOMEn> <TAB>
    {       onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <TIPO>   = 1 byte = tipo de grupos solicitados:
    {                                 'A' = 41h = Grupos de Atendentes
    {                                 'F' = 46h = Grupos de Filas
    {                                 'P' = 50h = Grupos de PAs
    {                                 'T' = 54h = Grupos de TAGs
    {                                 'p' = 70h = Grupos de PPs
    {				      <NGR>    = string de 4 caracteres representando o numero de GRUPOs em hexadecimal
    {             <GRx>    = string de 4 caracteres representando o ID do x-ésimo GRUPO em hexadecimal
    {				      <NOMEx>  = string de tamanho variavel com o nome do x-ésimo GRUPO
    {				      <TAB>    = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 7Ah entao
    {			<DATA> = <TABELA>
    {       onde: <TABELA> = 1 byte = tabela que foi reconfigurada:
    {                                 'A' = 41h = Atendentes
    {                                 'K' = 46h = PIs (qualquer tabela referente a PI)
    {                                 'C' = 43h = Configurações gerais (PATHUPDATE, por exemplo)
    {                                 'L' = 4Ch = Clientes
    {		Se CMD = 7Bh entao
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {		Se CMD = 7Ch entao
    {			<DATA> = <NPA> <NF> <F1> <COR1> <NOME1> <PV> <NOMENOTOTEM1> <TAB> ... <Fn> <CORn> <NOMEn> <PV> <NOMENOTOTEMn> <TAB>
    {				onde: <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <NF> = string de 4 caracteres representando o numero de FILAs em hexadecimal
    {             <Fx> = string de 4 caracteres representando o ID da x-ésima FILA em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor da x-ésima FILA, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {				      <NOMEx> = string de tamanho variavel com o nome da x-ésima FILA
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <NOMENOTOTEMx> = string de tamanho variavel com o nome da x-ésima FILA no totem (tela do totem touch)
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {		Se CMD = 7Dh entao
    {			<DATA> = <NTAG> <SENHA>
    {				onde: <NTAG>  = string de 4 caracteres representando o id da tag, em hexadecimal
    {				      <SENHA> = string de tamanho variavel com o numero da senha que recebera a tag
    {		Se CMD = 7Eh entao
    {			<DATA> = <RESULT>
    {				onde: <RESULT> = 1byte = Resultado da operação
    {                                '0' = 30h = Sucesso
    {                                '1' = 31h = Erro
    {		Se CMD = 7Fh entao
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {
    {		Se CMD = AAh entao
    {			<DATA> = <ID_MODULO> <NPA> <NT> <T1> <COR1> <GR1> <PV> <NOME1> <TAB> ... <Tn> <CORn> <GRn> <PV> <NOMEn> <TAB>
    {			onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <NT> = string de 4 caracteres representando o numero de Tags em hexadecimal
    {             <Tx> = string de 4 caracteres representando o ID da x-ésima TAG em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor da x-ésima TAG, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {             <GRx> = string de tamanho variavel com o ID do GRUPO DE TAGS ao qual esta x-ésima TAG pertence
    {				      <NOMEx> = string de tamanho variavel com o nome da x-ésima TAG
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {
    {
    {		Se CMD = ABh entao
    {			<DATA> = <SENHA>
    {				onde: <SENHA> = string de tamanho variavel com a senha para a qual se solicita as TAGs
    {
    {
    {		Se CMD = ACh entao
    {			<DATA> = <SENHA> <PV> <TAGs>
    {				onde: <SENHA> = string de tamanho variavel com a senha para a qual se solicita as TAGs
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <TAGs> = string de tamanho variável com as TAGs da referida senha, no formato "A;C;D;G-J;P", onde cada letra é um ID de TAG, sendo que IDs não consecutivos são separados por ";" e intervalo de IDs são identificados por "-" (inclusive os extremos do intervalo)
    {
    {
    {		Se CMD = AFh entao
    {			<DATA> = <ID_MODULO>
    {				onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {
    {		Se CMD = C1h entao
    {			<DATA> = <ATDLOGIN> <PV> <ATDNOME> <PV> <ATDGRUPO> <PV> <ATDGRPNOME>
    {				onde: <ATDLOGIN>   = string de tamanho variavel com o login do atendente
    {             <ATDNOME>    = string de tamanho variavel com o nome do atendente
    {             <ATDGRUPO>   = string de tamanho variavel com o grupo do atendente, em decimal
    {             <ATDGRPNOME> = string de tamanho variavel com o nome do grupo do atendente
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {
    {		Se CMD = C2h entao
    {			<DATA> = <SENHA>
    {       onde: <SENHA> = string = senha solicitada (ex: ‘345’)
    {
    {		Se CMD = C3h entao
    {			<DATA> = <SENHA> <PV> <NF> <F1> <HORA1> <TAB> ... <Fn> <HORAn> <TAB>
    {       onde: <SENHA> = string = senha solicitada (ex: ‘345’)
    {             <NF> = string de 4 caracteres representando o numero de FILAs em hexadecimal
    {             <Fx> = string de 4 caracteres representando o ID da xésima FILA em hexadecimal
    {             <HORAx> = string de 4 ou 12 caracteres representando o horário agendado para o exame relacionado com esta fila, em formato:
    {                 "hhnn"         => caso o agendamento seja para o dia de hoje
    {                 "ddmmyyyyhhmm" => caso o agendamento seja para outro dia que não hoje
    {             <PV> = 1 caractere = ponto-e-virgula = ; = ASCII 3Bh
    {             <TAB> = 1 caractere = tabulação = ASCII 09h
    {
    {   Se CMD = C4h entao
    {     <DATA> = <ID_PA>
    {     onde: <ID_PA> = string de 4 caracteres respresentando o ID da PA que deseja saber as prioridades de atendimento, em hexadecimal. Para receber de todas os PAs, deve-se passar 0000;
    {
    {   Se CMD = C5h entao
    {     <DATA> = <ID_PA1> <LISTA_DE_FILAS1> <TAB> ... <ID_PAn> <LISTA_DE_FILASn>
    {     onde: <ID_PAn>          = string de 4 caracteres respresentando o ID do PA, em hexadecimal
    {           <LISTA_DE_FILASn> = string de tamanho variável contendo a relação de IDs das filas que a PA atende, sendo:
    {                               <ID_FILA1> <PV> <ID_FILAn>, onde:
    {                                    <ID_FILAn> = string de 4 caracteres representando o ID da Fila, em hexadecimal
    {                                    <PV>       = 1 caractere = ponto-e-virgula = ; = ASCII 3Bh
    {           <TAB>             = 1 caracter = tabulacao = ASCII 09h
    {
    {   Se CMD = C6h entao
    {     <DATA> = <ID_FILA> <SENHA> <TAB> <DTHR>
    {     onde: <ID_FILA> = string de 4 caracteres respresentando o ID da fila em que senha foi gerada, em hexadecimal
    {           <SENHA>   = numero inteiro representando a senha gerada. Caso ocorra falha na geração da senha, seu valor será "-1"
    {           <TAB>     = 1 caracter = tabulacao = ASCII 09h
    {           <DTHR>    = string de 19 caracteres, contendo a Data e a Hora em que a senha foi emitida, no formato 'MM/dd/yyyy HH:nn:ss' (FormatSettings.Invariant.ShortDateFormat + ' ' + FormatSettings.Invariant.LongTimeFormat)
    {
    {   Se CMD = C7h entao
    {     <DATA> = '' (nil)
    {
    {   Se CMD = C8h entao
    {     <DATA> = <NFILAS> <ID_FILA1> <COR_FILAn> <NOME_FILA1> <TAB> ... <ID_FILAn> <COR_FILAn> <NOME_FILAn> <TAB>
    {     onde: <NFILAS>     = string de 4 caracteres representando o número de filas retornadas
    {           <ID_FILAn>   = string de 4 caracteres representando o ID da n-ésima Fila, em hexadecimal
    {           <COR_FILAn>  = string de 6 caracteres representando a cor da n-ésima Fila, em hexadecimal
    {           <NOME_FILAn> = string de tamanho variável representando o NOME da n-ésima Fila
    {           <TAB>        = 1 caracter = tabulacao = ASCII 09h
    {
    {   Se CMD = C9h entao
    {     <DATA> = <PWD>
    {     onde: <PWD> = string de tamanho variável com a senha para verificar o status
    {
    {   Se CMD = CAh entao
    {     <DATA> = <PWD> <TAB> <STATUS> <ID_LOCAL> <NOME_LOCAL> <TAB> <DTHR>
    {     onde: <PWD>        = string de tamanho variável com a senha ao qual solicitou-se o status
    {           <TAB>        = 1 caracter = tabulacao = ASCII 09h
    {           <STATUS>     = Um caracter, podendo ser:
    {                             "A" = senha em Atendimento = ASCII 41h
    {                             "E" = senha em Espera      = ASCII 45h
    {                             "I" = senha Inválida       = ASCII 49h
    {           <ID_LOCAL>   = string de 4 caracteres, respresentando o ID da Fila (se <STATUS>="E") ou PA (se <STATUS>="A")
    {           <NOME_LOCAL> = string de tamanho variável, representando o nome da Fila ou PA (dependendo do status, assim como <ID_LOCAL>)
    {           <TAB>        = 1 caracter = tabulacao = ASCII 09h
    {           <DTHR>       = string de 19 caracteres, contendo a Data e a Hora em que a senha foi emitida, no formato 'MM/dd/yyyy HH:nn:ss' (FormatSettings.Invariant.ShortDateFormat + ' ' + FormatSettings.Invariant.LongTimeFormat)
    {
    {   Se CMD = CBh então  //Atualizar Dados Adicionais de uma senha
    {     <DATA> = <PWD> <TAB> <DADOS_ADIC>
    {     onde: <PWD>        = string de tamanho variável com a senha em que os dados adicionais serão vinculados
    {           <TAB>        = 1 caracter = tabulacao = ASCII 09h
    {           <DADOS_ADIC> = string de tamanho variável contendo um JSON com os dados adicionais a serem atualizados naquela senha
    {
    {   Se CMD = CCh então  //RE: Status da atualização dos dados adicionais
    {     <DATA> = <PWD> <TAB> <STATUS> <MSG>
    {     onde: <PWD>    = string de tamanho variável ao qual pertencem os dados adicionais
    {           <TAB>    = 1 caracter = tabulacao = ASCII 09h
    {           <STATUS> = 1 caracter, podendo ser:
    {                        "1" - atualizado com sucesso
    {                        "0" - não foi possível atualizar
    {           <MSG>    = mensagem de tamanho variável contendo o motivo de não ter atualizado os dados adicionais, quando STATUS=0
    {
    {   Se CMD = CDh então  //Obter Dados Adicionais de uma senha
    {     <DATA> = <PWD>
    {     onde: <PWD> = string de tamanho variável contendo a senha ao qual se deseja obter os dados adicionais
    {
    {   Se CMD = CEh então  //RE: Dados adicionais de uma senha
    {     <DATA> = <PWD> <TAB> <STATUS> <MSG>
    {     onde: <PWD>    = string de tamanho variável ao qual pertencem os dados adicionais
    {           <TAB>    = 1 caracter = tabulacao = ASCII 09h
    {           <STATUS> = 1 caracter, podendo ser:
    {                        "2" - dados adicionais recuperados com sucesso
    {                        "1" - nenhum dado adicional existente para a senha
    {                        "0" - não foi possível recuperar os dados adicionais
    {           <MSG>    = string de tamanho varíavel, preenchida quando STATUS = "2" ou "0", sendo:
    {                             STATUS=2, MSG = json com os dados adicionais da senha solicitada
    {                             STATUS=0, MSG = possível mensagem de erro justificando porque os dados não puderam ser recuperados
    {
    {		Se CMD = 86h entao
    {			<DATA> = <ID_MODULO> <NPA> <NF> <F1> <COR1> <NOME1> <TAB> ... <Fn> <CORn> <NOMEn> <TAB>
    {			onde: <ID_MODULO> = string de 4 caracteres representando o ID do módulo ao qual esta lista se destina, em hexadecimal
    {             <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <NF> = string de 4 caracteres representando o numero de FILAs em hexadecimal
    {             <Fx> = string de 4 caracteres representando o ID da x-ésima FILA em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor da x-ésima FILA, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {             <NOMEx> = string de tamanho variavel com o nome (no totem) da x-ésima FILA
    {             <TAB>   = 1 caracter = tabulacao = ASCII 09h
    {
    {		Se CMD = B1h então
    {			<DATA> = <TCK> <PV> <NPRN>
    {				onde: <TCK>  = string de tamanho variável = senha que deve ser reimpressa
    {				      <PV>   = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <NPRN> = string 4 caracteres representando o número da impressora para a qual direcionar a impressão da senha (0 = paralela ou serial ou totem1, 1 = totem1, 2 = totem2, etc)
    {
    {
    {		Se CMD = 88h então
    {			<DATA> = <IDTV>
    {				onde: <IDTV>  = string de 4 caracteres representando o ID da TV para a qual se deseja a lista de canais permissionados
    {
    {
    {		Se CMD = 89h então
    {			<DATA> = <IDTV> <ID1> <NOME1> <PV> <FREQ1> <PADRAO1> <TAB> ... <IDn> <NOMEn> <PV> <FREQn> <PADRAOn> <TAB>
    {				onde: <IDTV>    = string de 4 caracteres representando o ID da TV para a qual se deseja a lista de canais permissionados
    {				      <IDx>     = string 4 caracteres representando o id do x-ésimo canal
    {				      <NOMEx>   = string de tamanho variável = nome do x-ésimo canal
    {				      <PV>      = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <FREQx>   = string de tamanho variável = freqüência do x-ésimo canal
    {             <PADRAOx> = 1 caracter = "1" ou "0" = ASCII 31h ou 30h = representando o canal ser padrão ou não, respectivamente
    {             <TAB>     = 1 caracter = tabulacao = ASCII 09h
    {
    {
    {		Se CMD = 8Ah então
    {			<DATA> = <PNL> <CANAL>
    {				onde: <PNL>   = string 4 caracteres representando o id do painel para ser mudado o canal
    {             <CANAL> = string 4 caracteres representando o id do canal padrão
    {
    {
    {		Se CMD = 8Bh então
    {			<DATA> = <CANAL>
    {				onde: <CANAL> = string 4 caracteres representando o id do canal padrão
    {
    {
    {   Se CMD = 8Ch então
    {     <DATA> = <TIPO> <ID_MODULO> <VERSAO>
    {       onde: <TIPO>   = 1 byte = tipo de módulo do SICS
    {                                 'P' = 50h = Módulo PA
    {                                 'M' = 4Dh = Módulo MultiPA
    {                                 'O' = 4Fh = Módulo OnLine
    {                                 'T' = 54h = Módulo TGS
    {                                 'V' = 56h = Módulo TV
    {                                 'C' = 43h = Módulo Call Center
    {                                 'S' = 53h = Módulo Totem Slim
    {                                 'H' = 48h = Módulo Totem Slim
    {             <ID_MODULO> = 4 bytes = ID do módulo do SICS a que se refere esta configuração
    {             <VERSAO> = 4 bytes = versão do protocolo
    {
    {
    {   Se CMD = A0h então
    {     <DATA> = <TIPO>
    {       onde: <TIPO>   = 1 byte = tipo de configuração desejada
    {                                 'E' = 45h = E-mail
    {                                 'S' = 53h = SMS
    {
    {   Se CMD = A1h então
    {     <DATA> = <TIPO> <SECAO> <CR> <PARAMETRO1> <IGUAL> <VALOR1> <CR> ... <PARAMETROn> <IGUAL> <VALORn> <CR>
    {       onde: <TIPO>       = 1 byte = tipo de configuração desejada
    {                                     'E' = 45h = E-mail
    {                                     'S' = 53h = SMS
    {             <SECAO>      = seção do INI na qual estes parâmetros devem ser armazenados
    {             <PARAMETROn> = string de tamanho variável com o nome do parâmetro n
    {             <VALOR1>     = string de tamanho variável com o valor do parâmetro n
    {             <IGUAL>      = 1 caracter = sinal de 'igual' = '=' = ASCII 3Dh
    {             <CR>         = 1 ou 2 bytes = CR ou CR/LF = (0Dh) ou (0Dh e 0Ah)
    {
    {   Se CMD = A2h então
    {     <DATA> = <TIPO> <DESTINATARIO>
    {       onde: <TIPO>   = 1 byte = tipo de configuração desejada
    {                                 'E' = 45h = E-mail
    {                                 'S' = 53h = SMS
    {             <DESTINATARIO> = string de tamanho variavel com o destinatario do e-mail ou SMS de teste
    {
    {   Se CMD = A3h então
    {     <DATA> = <GRUPOS_PAS> <TAB> <NomePI> <TAB> <NomeNivel> <TAB> <CorNivel> <TAB> <Mensagem>
    {       onde: <GRUPOS_PAS> = string de tamanho variável com a lista de grupos de PAs que devem processar/exibir esta mensagem (Ex: Grupos 1-3;5;8-11)
    {             <NomePI>     = string de tamanho variável com o nome do Indicador de Performance sobre o qual se refere o alarme
    {             <NomeNivel>  = string de tamanho variável com o nome do nível de alarme (Ex: Atenção, Crítico, etc)
    {             <CorNivel>   = string de tamanho variável com a cor deste alarme, em decimal
    {             <Mensagem>   = string de tamanho variável com a mensagem do alarme
    {             <TAB>        = 1 caracter = tabulacao = ASCII 09h
    {
    {   Se CMD = A4h então
    {     <DATA> = <TIPO> <AJU>
    {       onde: <TIPO>   = 1 byte = tipo de ajuste desejado
    {                                 'C' = 43h = Canal
    {                                 'V' = 56h = Volume
    {             <AJU>    = 1 byte = valor de ajuste desejado
    {                                 '+' = 2Bh = Aumentar canal ou volume
    {                                 '-' = 2Dh = Diminuir canal ou volume
    {
    {   Se CMD = B2h então
    {     <DATA> = <TIPO> <ID_MODULO> <VERSAO> <CONFIG>
    {       onde: <TIPO>   = 1 byte = tipo de módulo do SICS
    {                                 'P' = 50h = Módulo PA
    {                                 'M' = 4Dh = Módulo MultiPA
    {                                 'O' = 4Fh = Módulo OnLine
    {                                 'T' = 54h = Módulo TGS
    {                                 'V' = 56h = Módulo TV
    {             <ID_MODULO> = 4 bytes = ID do módulo do SICS a que se refere esta configuração
    {             <VERSAO> = 4 bytes = versão do protocolo
    {             <CONFIG> = string de tamanho variavel com as configurações específicas deste módulo, que são:
    {                  <<MODULO PA>>
    {                      <<VERSAO 1>>
    {                          caracter  1 a 4 = string de 4 bytes representando em hexadecimal = ID_PA
    {
    {                          caracter  5 = "T" ou "F" = MostrarNomeCliente
    {                          caracter  6 = "T" ou "F" = MostrarPA
    {                          caracter  7 = "T" ou "F" = MostrarBotaoLogin
    {                          caracter  8 = "T" ou "F" = MostrarBotaoLogout
    {                          caracter  9 = "T" ou "F" = MostrarBotaoProximo
    {                          caracter 10 = "T" ou "F" = MostrarBotaoRechama
    {                          caracter 11 = "T" ou "F" = MostrarBotaoEncaminha
    {                          caracter 12 = "T" ou "F" = MostrarBotaoFinaliza
    {                          caracter 13 = "T" ou "F" = MostrarBotaoEspecifica
    {                          caracter 14 = "T" ou "F" = MostrarMenuLogin
    {                          caracter 15 = "T" ou "F" = MostrarMenuLogout
    {                          caracter 16 = "T" ou "F" = MostrarMenuAlteraSenha
    {                          caracter 17 = "T" ou "F" = MostrarMenuProximo
    {                          caracter 18 = "T" ou "F" = MostrarMenuRechama
    {                          caracter 19 = "T" ou "F" = MostrarMenuEspecifica
    {                          caracter 20 = "T" ou "F" = MostrarMenuEncaminha
    {                          caracter 21 = "T" ou "F" = MostrarMenuFinaliza
    {
    {                          caracter 22 = "T" ou "F" = ConfirmarProximo
    {                          caracter 23 = "T" ou "F" = ConfirmarEncaminha
    {                          caracter 24 = "T" ou "F" = ConfirmarFinaliza
    {                          caracter 25 = "T" ou "F" = ConfirmarSenhaOutraFila
    {
    {                          caracter 26 = "T" ou "F" = VisualizarProcessosParalelos
    {                          caracter 27 = "T" ou "F" = ModoLoginLogout
    {                          caracter 28 = "T" ou "F" = ModoTerminalServer
    {                          caracter 29 = "T" ou "F" = PodeFecharPrograma
    {                          caracter 30 = "T" ou "F" = TagsObrigatorias
    {                          caracter 31 = "T" ou "F" = ManualRedirect
    {                          caracter 32 = "T" ou "F" = UseCodeBar
    {                          caracter 33 = "T" ou "F" = MinimizarParaBandeja
    {
    {                          caracter 34 a 35 = string de 2 bytes representando em hexadecimal = SecsOnRecall
    {
    {                          caracter 36 a N (tamanho variável) = NomeModulo: string;
    {                          <TAB>
    {                          próximo caracter a N (tamanho variável) = CodeBarPort: string;
    {
    {
    {   Se CMD = B3h entao
    {     <DATA> = '' (nil)
    {
    {
    {   Se CMD = B7h entao
    {       <DATA> = <TIPO1> <STATUS1> <IP1> <TAB> <TIPO2> <STATUS2> <IP2> <TAB> ... <TIPOn> <STATUSn> <IPn> <TAB>
    {       onde:
    {             <TIPOx> = 1 caracter com o tipo da x-ésima conexão TCP/IP, sendo:
    {                         '1' = 31h = PAs e MultiPAs
    {                         '2' = 32h = OnLines e TGSs
    {                         '3' = 33h = Painéis
    {                         '4' = 34h = Totens
    {                         '5' = 35h = Teclados
    {             <STATUSx> = 1 caracter com o status da x-ésima conexão TCP/IP, sendo:
    {                         '0' = 30h = desconectado (vermelho)
    {                         '1' = 31h = conectado (verde)
    {             <IPx> = string de tamanho variavel com o IP da x-ésima conexão TCP/IP
    {             <TAB> = 1 caracter = tabulacao = ASCII 09h
    {
    {
    {   Se CMD = B5h entao
    {     <DATA> = <PNL>
    {				onde: <PNL> = string 4 caracteres representando o id do painel (TV) que recerá a solicitação de canais
    {
    {
    {   Se CMD = B6h entao
    {     <DATA> = '' (nil)
    {   Se CMD = B8h entao
    {     <DATA> = <RES>
    {       onde: <RES>    = 1 para sucesso ou 0 para falha
    {   Se CMD = B9h entao
    {     <DATA> = <RES>
    {       onde: <RES>    = 1 para sucesso ou 0 para falha
    {   Se CMD = 0Bh entao
    {     <DATA> = <LISTA><ID>;<NOME></LISTA> (nil)
    {       onde: <ID>    = inteiro com o ID da configuração geral separado por virgula
    {             <NOME>    = string com o Nome da configuração geral
    {
    {   Se CMD = 0Ch entao
    {     <DATA> = <VERSAO_PROTOCOLO> (nil)
    {       Onde: <VERSAO_PROTOCOLO> = inteiro 4 dígitos com a versão do SICS Server
    {   Se CMD = D1h entao
    {     <DATA> = '' (nil)
    {   Se CMD = D2h entao
    {     <DATA> = <QTD> <NOME1> <PV> <NIV1> <PV> <COR1> <PV> <MSG1> <TAB> ... <NOMEn> <PV> <NIVn> <PV> <CORn> <PV> <MSGn> <TAB>
    {       onde: <QTD> = string de 4 caracteres representando a quantidade de alarmes ativos em hexadecimal
    {             <NOMEx> = string de tamanho variável com o nome do Indicador de Performance sobre o qual se refere o alarme
    {             <NIVx> = string de tamanho variável com o nome do nível de alarme (Ex: Atenção, Crítico, etc)
    {             <CORx> = string de 6 caracteres com a cor deste alarme, no formato RRGGBB, sendo que
    {                      cada 2 caracteres formam a intensidade da cor (Red, Green e Blue, respectivamente),
    {                      em escala hexadecimal de 00 a FF.
    {             <MSGx> = string de tamanho variável com a mensagem do alarme
    {             <TAB> = 1 caracter = tabulacao = ASCII 0x0009
    {             <PV> = 1 caracter = ponto-e-virgula = ASCII 0x003B
    {
    {		Senao <DATA> = ‘’ (nil)
    {
    { 	<ETX> = 1Byte = 03h

    {   Se CMD = E0h entao
    {     <DATA> = <LOGIN> <TAB> <SENHA>
    {       onde: <LOGIN>   = string com o login do Cliente separado por TAB
    {             <TAB>     = 1 caracter = tabulacao = ASCII 09h
    {             <SENHA>   = string com a senha do Cliente
    {

    {   Se CMD = E2h entao
    {     <DATA> = <ID> <TAB> <POSICAO>
    {       onde: <ID>      = string com o ID do Cliente separado por TAB
    {             <TAB>     = 1 caracter = tabulacao = ASCII 09h
    {             <POSICAO> = string com a posição do Cliente
    {

    {		Se CMD = E4 entao
    {			<DATA> = '' (nil)

    {		Se CMD = E5 entao
    {     <DATA> = <QTD> <PV> <ID> <PV> <NOME> <PV> <IP> <PV> <ID_MODELOTOTEM>
    {       onde: <QTD>            = Quantidade de itens retornados
    {				      <PV>             = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <ID>             = string com o ID do Totem
    {				      <PV>             = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <NOME>           = string com o nome do Totem
    {				      <PV>             = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <IP>             = string com o IP do Totem
    {				      <PV>             = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <ID_MODELOTOTEM> = string com o Id do modelo Totem

    {   Se CMD = D5h entao
    {     <DATA> = <POSICAO> <TAB> <FILA> <TAB> <ID> <TAB> <NOME>
    {       onde: <POSICAO>   = string com a posição do operador "Senha" separado por TAB
    {             <TAB>       = 1 caracter = tabulacao = ASCII 09h
    {             <FILA>      = string com a fila aoende vai ser inserida a senha
    {             <TAB>       = 1 caracter = tabulacao = ASCII 09h
    {             <ID>        = string com o ID do Cliente "Operador" que pediu apoio
    {             <TAB>       = 1 caracter = tabulacao = ASCII 09h
    {             <Nome>      = string com o Nome do Cliente "Operador"
    {
    {   Se CMD = D6h entao
    {     <DATA> = <RESULTADO>
    {       onde: <RESULTADO> = string de 1 caracter, sendo T para sucesso ou F para falha
    {
    {
    {
    {   Se CMD = D9h entao
    {     <DATA> = <MESA> <TAB> <FILA> <TAB> <IDCLIENTE> <TAB> <NOMECLIENTE>
    {       onde: <MESA>        = string com a "Mesa" ou "Senha" separado por TAB
    {             <TAB>         = 1 caracter = tabulacao = ASCII 09h
    {             <FILA>        = string com a fila aoende vai ser inserida a senha ou mesa
    {             <TAB>         = 1 caracter = tabulacao = ASCII 09h
    {             <IDCLIENTE>   = string com o ID do Cliente "Operador" que pediu apoio
    {             <TAB>         = 1 caracter = tabulacao = ASCII 09h
    {             <NOMECLIENTE> = string com o Nome do Cliente "Operador"
    {
    {
    {
    {		Se CMD = DAh entao
    {			<DATA> = <ID_PA>
    {				onde: <ID_PA> = string de 4 caracteres representando o ID da PA ao qual esta lista se destina, em hexadecimal
    {		Se CMD = DBh entao
    {			<DATA> = <NPA> <NF> <F1> <COR1> <NOME1> <PV> <NOMENOTOTEM1> <TAB> ... <Fn> <CORn> <NOMEn> <PV> <NOMENOTOTEMn> <TAB>
    {				onde: <NPA>       = string de 4 caracteres representando o numero de PAs em hexadecimal<NPI> = string de 4 caracteres representando o numero de PIs em hexadecimal
    {             <NF> = string de 4 caracteres representando o numero de FILAs em hexadecimal
    {             <Fx> = string de 4 caracteres representando o ID da x-ésima FILA em hexadecimal
    {             <CORx> = string de 6 caracteres representando o RGB da cor da x-ésima FILA, sendo cada componente da cor (R, G e B) composto por dois bytes, em hexadecimal
    {				      <NOMEx> = string de tamanho variavel com o nome da x-ésima FILA
    {				      <PV> = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {				      <NOMENOTOTEMx> = string de tamanho variavel com o nome da x-ésima FILA no totem (tela do totem touch)
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {
    {
    {		Se CMD = DEh então
    {			<DATA> = <NF><NT><NB>
    {				onde: <NF> = string 4 caracteres representando o número do botão (fila) que foi pressionado em hexadecimal
    {				      <NT> = string 4 caracteres representando o número do Totem
    {				      <NBx> = string de tamanho variável com a lista de IDs de TAG a ser atribuída a senha, separados por ;
    {
    {
    {		Se CMD = E6h então
    {			<DATA> = <TT>
    {				onde: <TT>   = string 4 caracteres representando o id do totem em hexadecimal
    {
    {
    {		Se CMD = E7h então
    {     <DATA> = <RESULTADO>
    {       onde: <RESULTADO> = string de tamanho variavel com json com as telas do totem e os botoes das telas
    {
    {
    {		Se CMD = E8h então
    {			<DATA> = <FL>
    {				onde: <FL> = string 4 caracteres representando o id da fila em hexadecimal
    {
    {
    {		Se CMD = E9h então
    {     <DATA> = <RESULTADO>
    {       onde: <TEE> = string com o Tempo Estimado de Espera
    {             <PV>  = 1 caracter = ponto-e-virgula = ; = ASCII 3Bh
    {             <TME> = string com o Tempo Médio de Espera (últimas 20 senhas que estiveram em espera na fila)
    {
    {
    {		Se CMD = EAh entao
    {			<DATA> = <MODULO> <TAB> <LOGIN> <TAB> <HASH>
    {				onde: <MODULO> = string de 4 caracteres com o id do módulo, em hexadecimal
    {             <LOGIN> = string de tamanho variavel representando o login OU o id (em decimal) do atendente a ser logado na PA
    {				      <TAB> = 1 caracter = tabulacao = ASCII 09h
    {				      <HASH> = string de tamanho variavel com o hash da senha do atendente para conferência pelo servidor
    {
    {
    {   Se CMD = EBh entao
    {     <DATA> = <RES> <MOT> <PV> <TIMEOUT>
    {         onde: <RES> = 1 byte = resultado do login, que pode ser:
    {                                   '0' = não logou
    {                                   '1' = logou com sucesso
    {               <MOT> = string de N bytes representando os motivos de não ter sucesso no login, separados por vírgula
    {                                   0 = login efetuado com sucesso
    {                                   1 = erro diverso, não listado
    {                                   2 = outro atendente já está logado nesta PA
    {                                   3 = este atendente já está logado em outra PA
    {                                   4 = este atendente não está cadastrado no SICS
    {                                   5 = este atendente está desativado no SICS
    {                                   6 = este atendente não tem perfil para logar nesta PA
    {  	            <PV> = 1 caracter = ponto-e-virgula = ASCII 0x003B
    {  	            <TIMEOUT> = string de N bytes representando os tempo em minutos para o SICS proceder logout por inatividade do atendente
    {
    {
    {		Se CMD = EE entao
    {			<DATA> = '' (nil)
    {		Se CMD = EF entao
    {     <DATA> = <FL><NF> <PV> <TME> <TAB>
    {       onde: <FL>            = String de 4 caracteres representando o ID da Fila
    {				      <NF>            = String de N caracteres representando o Nome da Fila
    {             <|>             = 1 caracter = pipe = | = ASCII 7Ch
    {				      <TME>           = string com o TME da Fila
    {             <TAB>           = 1 caracter = tabulacao = ASCII 09h
    {
    {
    {		Se CMD = F3 entao
    {			<DATA> = <ID_UNIDADE>
    {         onde: <ID_UNIDADE> = String de 4 caracteres representando o ID da unidade em hexadecimal
    {
    {
    {		Se CMD = F5 entao
    {			<DATA> = <ID_UNIDADE>
    {         onde: <ID_UNIDADE> = String de 4 caracteres representando o ID da unidade em hexadecimal
    {
    {
    {		Se CMD = F7 entao
    {			<DATA> = <CAB> <ROD> <IDTOTEM> <TEXTO>
    {         onde: <CAB>     = 1 caracter = 'S' para manter o cabeçalho ou 'N' para não manter
    {               <ROD>     = 1 caracter = 'S' para manter o rodapé ou 'N' para não manter
    {               <IDTOTEM> = String de 4 caracteres representando o ID do Totem em hexadecimal
    {               <TEXTO>   = String de N caracteres com o texto que será enviado para impressora

    {		Se CMD = F8 entao
    {			<DATA> = <STAT>
    {         onde: <STAT>     = 1 caracter = '0' para falha ou '1' para sucesso

    {		Se CMD = F9 entao
    {     		<DATA> = <JSON>
    {       	onde: <JSON>          = String no formato JSON com os campos abaixo
    {                                 'PERGUNTA_ID' = ID da Pergunta
    {                                 'DEVICE_ID' = ID do Totem
    {                                 'UNIDADE_ID' = ID da Unidade
    {                                 'ALTERNATIVA_ID' = ID da Alternativa
    {                                 'GUID' = Código GUID
    {                                 'SENHA' = Senha do Atendimento

    }
function GetIDPAInternal(const aIDModulo: Integer): Integer;
begin
  if aIDModulo > 0 then
    Result := GetIdPA(dmSicsMain.connOnLine, aIDModulo)
  else
    Result := 0;
end;

function GetTipoDeGrupo(Const aPrefixo: Char): TTipoDeGrupo;
begin
  case UpperCase(aPrefixo)[1] of
    'A':
      Result := tgAtd;
    'B':
      Result := tgMtrBloq;
    'F':
      Result := tgFila;
    'I', 'K':
      Result := tgPI;
    'M':
      Result := tgPausa;
    'N':
      Result := tgMtrPermInc;
    'P':
      Result := tgPA;
    'O':
      Result := tgMtrPriori;
    'S':
      Result := tgMtrBotao;
    'T':
      Result := tgTAG;
    'p', 'R':
      Result := tgPP;
    'V':
      Result := tgVisTAG;
  else
    Result := tgNenhum;
  end;
end;

function SolicitarParametrosModuloSICS(const ProtData: String): String;
var
  vParametros: string;
  vIdModulo: Integer;
  vNomeTabela: string;
  vModuloChar: Char;

  procedure SolicitarParametrosModuloSICSTGS(aDataSetModulo: TFDQuery);
  var
    lJSONObjec: TJSONObject;
  begin
    lJSONObjec := TConexaoBD.ToJSON;
    try
      vParametros := vParametros + lJSONObjec.ToJSON;
    finally
      lJSONObjec.Free;
    end;
  end;

  procedure SolicitarParametrosModuloSICSPAMULTIPA(aDataSetModulo: TFDQuery);
  var
    LPAsComChamadaAutomaticaStr: String;
    ArrayJSon: TJSONArray;
    ObjJSon, lConexaoBDJSon: TJSONObject;
  begin
    LPAsComChamadaAutomaticaStr := '';
    IntArrayToStr(dmSicsServidor.PAsComChamadaAutomatica, LPAsComChamadaAutomaticaStr);
    ArrayJSon := TJSONArray.Create;
    try
      ObjJSon := TJSONObject.Create;
      try
        TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
        ObjJSon.AddPair('PAsComChamadaAutomatica', TJSONString.Create(LPAsComChamadaAutomaticaStr));

        if (aDataSetModulo.FieldByName('CONECTAR_VIA_DB').AsString = 'T') then
        begin
          lConexaoBDJSon := TConexaoBD.ToJSON;
          ObjJSon.AddPair('ConexaoBD', lConexaoBDJSon);
        end;
      except
        ObjJSon.Free;
        raise;
      end;
      ArrayJSon.AddElement(ObjJSon);
      vParametros := vParametros + ArrayJSon.ToJSON;
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloSICSPA(aDataSetModulo: TFDQuery);
  begin
    SolicitarParametrosModuloSICSPAMULTIPA(aDataSetModulo);
  end;

  procedure SolicitarParametrosModuloSICSMULTIPA(aDataSetModulo: TFDQuery);
  begin
    SolicitarParametrosModuloSICSPAMULTIPA(aDataSetModulo);
  end;

  procedure SolicitarParametrosModuloSICSTV(aDataSetModulo: TFDQuery);
  var
    ArrayJSon: TJSONArray;
    ObjJSon: TJSONObject;
  begin
    ArrayJSon := TJSONArray.Create;
    try
      ObjJSon := TJSONObject.Create;
      try
        TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
      except
        ObjJSon.Free;
        raise;
      end;
      ArrayJSon.AddElement(ObjJSon);
      vParametros := vParametros + ArrayJSon.ToJSON;

      Winapi.Windows.Beep(400, 700);
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloSICSONLINE(aDataSetModulo: TFDQuery);
  var
    ArrayJSon: TJSONArray;
    ObjJSon: TJSONObject;
    ObjCustomJson: TJSONObject;
  begin
    ArrayJSon := TJSONArray.Create;
    try
      ObjJSon := TJSONObject.Create;
      try
        TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
      except
        ObjJSon.Free;
        raise;
      end;
      ArrayJSon.AddElement(ObjJSon);

      ObjCustomJson := TJSONObject.Create;
      ObjCustomJson.AddPair('FileServerPort', TJSONNumber.Create(vgParametrosModulo.FilePorta) );
      ArrayJSon.AddElement(ObjCustomJson);

      vParametros := vParametros + ArrayJSon.ToJSON;
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloSICSTVPaineis(aDataSetModulo: TFDQuery);
  var
    ArrayJSon: TJSONArray;
    ObjJSon: TJSONObject;
  begin
    ArrayJSon := TJSONArray.Create;
    try
      try
        aDataSetModulo.First;
        while not aDataSetModulo.Eof do
        begin
          ObjJSon := TJSONObject.Create;
          ObjJSon.Owned := True;

          TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
          ArrayJSon.AddElement(ObjJSon);

          aDataSetModulo.Next;
        end;
      except
        ObjJSon.Free;
        raise;
      end;

      vParametros := vParametros + ArrayJSon.ToJSON;
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SalvarParametrosModuloSICSTV;
  var
    ObjJSon: TJSONObject;
    StrJson: string;
    LCont, LIDModulo, LIdPainel: Integer;
    LFieldValue: String;
  begin
    StrJson := Copy(ProtData, 6, Length(ProtData));

    ObjJSon := TJSONObject.ParseJSONValue(UpperCase(StrJson)) as TJSONObject;
    try
      if LIDModulo = 0 then
        ObjJSon.TryGetValue('ID_MODULO_TV', LIDModulo);

      ObjJSon.TryGetValue('ID', LIdPainel);

      dmSicsMain.cdsAddModulos.Open;
      if not dmSicsMain.cdsAddModulos.Locate('ID;TIPO;ID_UNIDADE', VarArrayOf([LIDModulo, 5, vgParametrosModulo.IdUnidade]), []) then
      begin
        dmSicsMain.cdsAddModulos.Append;
        dmSicsMain.cdsAddModulosID.AsInteger         := NGetNextGenerator('GEN_ID_MODULOS', dmSicsMain.connOnLine);
        dmSicsMain.cdsAddModulosNOME.AsString        := 'Novo Módulo TV';
        dmSicsMain.cdsAddModulosTIPO.AsInteger       := 5;
        dmSicsMain.cdsAddModulosID_UNIDADE.AsInteger := vgParametrosModulo.IdUnidade;
        dmSicsMain.cdsAddModulos.Post;
        dmSicsMain.cdsAddModulos.ApplyUpdates(0);

        LIDModulo := dmSicsMain.cdsAddModulosID.AsInteger;
        Winapi.Windows.Beep(400, 300);
      end;

      dmSicsMain.cdsModuloTV.Open;
      if not dmSicsMain.cdsModuloTV.Locate('ID;ID_UNIDADE', VarArrayOf([LIDModulo, vgParametrosModulo.IdUnidade]), []) then
        dmSicsMain.cdsModuloTV.Append
      else
        dmSicsMain.cdsModuloTV.Edit;

      for LCont := 0 to Pred(dmSicsMain.cdsModuloTV.Fields.Count) do
        if ObjJSon.TryGetValue(dmSicsMain.cdsModuloTV.Fields[LCont].FieldName, LFieldValue) then
          dmSicsMain.cdsModuloTV.Fields[LCont].Value := LFieldValue;

      dmSicsMain.cdsModuloTVID.AsInteger         := dmSicsMain.cdsAddModulosID.AsInteger;
      dmSicsMain.cdsModuloTVID_UNIDADE.AsInteger := vgParametrosModulo.IdUnidade;
      dmSicsMain.cdsModuloTV.Post;
      dmSicsMain.cdsModuloTV.ApplyUpdates(0);

      vNomeTabela := 'MODULOS_TV'; // E
      vIdModulo   := dmSicsMain.cdsAddModulosID.AsInteger;
      vModuloChar := Chr($56);

      dmSicsMain.connOnLine.Close;
    finally
      //ArrayJSon.Free;
    end;
  end;

  procedure SalvarParametrosModuloSICSTVPaineis;
  var
    LJSONArray: TJSONArray;
    ObjJSon: TJSONObject;
    StrJson: string;
    LCont, LCont2, LIDModulo, LIdPainel: Integer;
    LFieldValue: String;
  begin
    StrJson := Copy(ProtData, 6, Length(ProtData));

    //ObjJSon := TJSONObject.ParseJSONValue(UpperCase(StrJson)) as TJSONObject;
    try
      LJSONArray := TJSONObject.ParseJSONValue(UpperCase(StrJson)) as TJSONArray;

      for LCont := 0 to Pred(LJSONArray.Count) do
      begin
        ObjJSon := (LJSONArray.Items[LCont] as TJSONObject);

        if LIDModulo = 0 then
          ObjJSon.TryGetValue('ID_MODULO_TV', LIDModulo);

        ObjJSon.TryGetValue('ID', LIdPainel);

        dmSicsMain.cdsAddModulos.Open;
        if not dmSicsMain.cdsAddModulos.Locate('ID;TIPO;ID_UNIDADE', VarArrayOf([LIDModulo, 5, vgParametrosModulo.IdUnidade]), []) then
        begin
          dmSicsMain.cdsAddModulos.Append;
          dmSicsMain.cdsAddModulosID.AsInteger         := NGetNextGenerator('GEN_ID_MODULOS', dmSicsMain.connOnLine);
          dmSicsMain.cdsAddModulosNOME.AsString        := 'Novo Módulo TV';
          dmSicsMain.cdsAddModulosTIPO.AsInteger       := 5;
          dmSicsMain.cdsAddModulosID_UNIDADE.AsInteger := vgParametrosModulo.IdUnidade;
          dmSicsMain.cdsAddModulos.Post;
          dmSicsMain.cdsAddModulos.ApplyUpdates(0);

          LIDModulo := dmSicsMain.cdsAddModulosID.AsInteger;
          Winapi.Windows.Beep(400, 300);
        end;

        dmSicsMain.cdsModuloTV.Open;
        if not dmSicsMain.cdsModuloTV.Locate('ID;ID_UNIDADE', VarArrayOf([LIDModulo, vgParametrosModulo.IdUnidade]), []) then
        begin
          dmSicsMain.cdsModuloTV.Append;
          dmSicsMain.cdsModuloTVID.AsInteger         := dmSicsMain.cdsAddModulosID.AsInteger;
          dmSicsMain.cdsModuloTVID_UNIDADE.AsInteger := vgParametrosModulo.IdUnidade;
          dmSicsMain.cdsModuloTV.Post;
          dmSicsMain.cdsModuloTV.ApplyUpdates(0);
          Winapi.Windows.Beep(400, 200);
        end;

        dmSicsMain.qryAddPaineis.Close;
        dmSicsMain.qryAddPaineis.Params[0].Value := dmSicsMain.cdsAddModulosID.AsInteger;
        dmSicsMain.qryAddPaineis.Params[1].Value := vgParametrosModulo.IdUnidade;
        dmSicsMain.cdsAddPaineis.Open;

        if (not dmSicsMain.cdsAddPaineis.Locate('ID', LIdPainel, [])) then
          dmSicsMain.cdsAddPaineis.Append
        else
          dmSicsMain.cdsAddPaineis.Edit;

        for LCont2 := 0 to Pred(dmSicsMain.cdsAddPaineis.Fields.Count)  do
          if ObjJSon.TryGetValue(dmSicsMain.cdsAddPaineis.Fields[LCont2].FieldName, LFieldValue) then
            dmSicsMain.cdsAddPaineis.Fields[LCont2].Value := LFieldValue;

        if LIdPainel = 0 then
          dmSicsMain.cdsAddPaineisID.AsInteger           := NGetNextGenerator('GEN_MODULOS_TV_PAINEIS_ID', dmSicsMain.connOnLine);

        if dmSicsMain.cdsAddPaineisID_MODULO_TV.AsInteger = 0 then
          dmSicsMain.cdsAddPaineisID_MODULO_TV.AsInteger := dmSicsMain.cdsAddModulosID.AsInteger;

        dmSicsMain.cdsAddPaineisID_UNIDADE.AsInteger := vgParametrosModulo.IdUnidade;
        dmSicsMain.cdsAddPaineis.Post;
        dmSicsMain.cdsAddPaineis.ApplyUpdates(0);
      end;

      vIdModulo := dmSicsMain.cdsAddModulosID.AsInteger;
      vModuloChar := Chr($4E);
      vNomeTabela := 'MODULOS_TV_PAINEIS';
      dmSicsMain.connOnLine.Close;
    finally
      //ArrayJSon.Free;
    end;
  end;

  procedure ExcluirParametrosModuloSICSTVPaineis;
  var
    LJSONArray: TJSONArray;
    ObjJSon: TJSONObject;
    StrJson: string;
    LIDModulo, LIdPainel: Integer;
    LFieldValue: String;
  begin
    StrJson := Copy(ProtData, 6, Length(ProtData));

    ObjJSon := TJSONObject.ParseJSONValue(UpperCase(StrJson)) as TJSONObject;
    try
      ObjJSon.TryGetValue('ID_MODULO_TV', LIDModulo);
      ObjJSon.TryGetValue('ID', LIdPainel);

      dmSicsMain.qryAddPaineis.Close;
      dmSicsMain.qryAddPaineis.Params[0].Value := LIDModulo;
      dmSicsMain.cdsAddPaineis.Open;

      if (dmSicsMain.cdsAddPaineis.Locate('ID_MODULO_TV;ID', VarArrayOf([LIDModulo, LIdPainel]), [])) then
        dmSicsMain.cdsAddPaineis.Delete;

      dmSicsMain.cdsAddPaineis.ApplyUpdates(0);

      vIdModulo := LIDModulo;
      vModuloChar := Chr($4E);
      vNomeTabela := 'MODULOS_TV_PAINEIS';
      dmSicsMain.connOnLine.Close;
    finally
      //ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloSICSCALLCENTER(aDataSetModulo: TFDQuery);
  var
    ArrayJSon: TJSONArray;
    ObjJSon: TJSONObject;
  begin
    ArrayJSon := TJSONArray.Create;
    try
      ObjJSon := TJSONObject.Create;
      try
        TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
      except
        ObjJSon.Free;
        raise;
      end;
      ArrayJSon.AddElement(ObjJSon);
      vParametros := vParametros + ArrayJSon.ToJSON;
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloTOTENSSLIM(aDataSetModulo: TFDQuery);
  var
    ArrayJSon: TJSONArray;
    ObjJSon: TJSONObject;
  begin
    ArrayJSon := TJSONArray.Create;
    try
      ObjJSon := TJSONObject.Create;
      try
        TAspJson.DataSetRegToJsonObj(ObjJSon, aDataSetModulo);
      except
        ObjJSon.Free;
        raise;
      end;
      ArrayJSon.AddElement(ObjJSon);
      vParametros := vParametros + ArrayJSon.ToJSON;
    finally
      ArrayJSon.Free;
    end;
  end;

  procedure SolicitarParametrosModuloTOTENSTOUCH(aDataSetModulo: TFDQuery);
  var
    LJSONTotem : TJSONObject;
    LArrayTela : TJSONArray;
    LJSONTela  : TJSONObject;
    LArrayBotao: TJSONArray;
    LJSONBotao : TJSONObject;
    LDSTela    : TDataSet;
    LDSBotao   : TDataSet;
  begin
    LJSONTotem := TJSONObject.Create;

    try
      {$REGION 'Totem'}
      LJSONTotem.AddPair('id'                     , aDataSetModulo.FieldByName('id'                     ).AsString);
      LJSONTotem.AddPair('ip'                     , aDataSetModulo.FieldByName('ip'                     ).AsString);
      LJSONTotem.AddPair('nome'                   , aDataSetModulo.FieldByName('nome'                   ).AsString);
      LJSONTotem.AddPair('id_modelototem'         , aDataSetModulo.FieldByName('id_modelototem'         ).AsString);
      LJSONTotem.AddPair('id_tela'                , aDataSetModulo.FieldByName('id_tela'                ).AsString);
      LJSONTotem.AddPair('tempo_inatividade'      , aDataSetModulo.FieldByName('tempo_inatividade'      ).AsString);
      LJSONTotem.AddPair('porta_tcp'              , aDataSetModulo.FieldByName('porta_tcp'              ).AsString);
      LJSONTotem.AddPair('porta_serial_impressora', aDataSetModulo.FieldByName('porta_serial_impressora').AsString);
      LJSONTotem.AddPair('botoes_transparentes'   , aDataSetModulo.FieldByName('botoes_transparentes'   ).AsString);
      LJSONTotem.AddPair('file_port'              , vgParametrosModulo.FilePorta.ToString);
      {$ENDREGION}

      {$REGION 'Telas'}
      LArrayTela := TJSONArray.Create;

      dmSicsMain.connOnLine.ExecSQL(Format(cSELECT_TOTEM_TOUCH_TELAS,
                                           [aDataSetModulo.FieldByName('id').AsInteger,
                                            vgParametrosModulo.IdUnidade]), LDSTela);

      try
        while not LDSTela.Eof do
        begin
          LJSONTela := TJSONObject.Create;

          LJSONTela.AddPair('id'           , LDSTela.FieldByName('id'               ).AsString);
          LJSONTela.AddPair('nome'         , LDSTela.FieldByName('nome'             ).AsString);
          LJSONTela.AddPair('fechar'       , LDSTela.FieldByName('fechar'           ).AsString);
          LJSONTela.AddPair('intervalo'    , LDSTela.FieldByName('intervalo'        ).AsString);
          LJSONTela.AddPair('modoimpressao', LDSTela.FieldByName('momento_impressao').AsString);
          LJSONTela.AddPair('imagem'       , '');
          LJSONTela.AddPair('principal'    , LDSTela.FieldByName('principal'        ).AsString);

          LArrayTela.AddElement(LJSONTela);

          LDSTela.Next;
        end;
      finally
        LDSTela.Free;
      end;

      LJSONTotem.AddPair('telas', LArrayTela);
      {$ENDREGION}

      {$REGION 'Botões'}
      LArrayBotao := TJSONArray.Create;

      dmSicsMain.connOnLine.ExecSQL(Format(cSELECT_TOTEM_TOUCH_BOTOES, [vgParametrosModulo.IdUnidade]), LDSBotao);

      try
        while not LDSBotao.Eof do
        begin
          LJSONBotao := TJSONObject.Create;

          LJSONBotao.AddPair('id'            , LDSBotao.FieldByName('id'            ).AsString);
          LJSONBotao.AddPair('nome'          , LDSBotao.FieldByName('nome'          ).AsString);
          LJSONBotao.AddPair('pos_left'      , LDSBotao.FieldByName('pos_left'      ).AsString);
          LJSONBotao.AddPair('pos_top'       , LDSBotao.FieldByName('pos_top'       ).AsString);
          LJSONBotao.AddPair('tam_width'     , LDSBotao.FieldByName('tam_width'     ).AsString);
          LJSONBotao.AddPair('tam_height'    , LDSBotao.FieldByName('tam_height'    ).AsString);
          LJSONBotao.AddPair('id_tela'       , LDSBotao.FieldByName('id_tela'       ).AsString);
          LJSONBotao.AddPair('id_proximatela', LDSBotao.FieldByName('id_proximatela').AsString);
          LJSONBotao.AddPair('id_fila'       , LDSBotao.FieldByName('id_fila'       ).AsString);
          LJSONBotao.AddPair('id_tag'        , LDSBotao.FieldByName('id_tag'        ).AsString);

          LArrayBotao.AddElement(LJSONBotao);

          LDSBotao.Next;
        end;
      finally
        LDSBotao.Free;
      end;

      LJSONTotem.AddPair('botoes', LArrayBotao);
      {$ENDREGION}

      vParametros := vParametros + LJSONTotem.ToJSON;
    finally
      LJSONTotem.Free;
    end;
  end;

var
  aDataSetModulo: TFDQuery;

begin
  vModuloChar := ProtData[1];
  vIdModulo   := StrToInt('$' + Copy(ProtData, 2, 4));

  case vModuloChar of
    Chr($50): vNomeTabela := 'MODULOS_PAS'; // P
    Chr($4D): vNomeTabela := 'MODULOS_MULTIPAS'; // M
    Chr($56): vNomeTabela := 'MODULOS_TV'; // V
    Chr($57): SalvarParametrosModuloSICSTV;
    Chr($58): ExcluirParametrosModuloSICSTVPaineis;
    Chr($4E): vNomeTabela := 'MODULOS_TV_PAINEIS'; // N
    Chr($45): vNomeTabela := 'MODULOS_TV_PAINEIS'; // E
    Chr($46): SalvarParametrosModuloSICSTVPaineis; // E
    Chr($4F): vNomeTabela := 'MODULOS_ONLINE'; // O
    Chr($54): vNomeTabela := 'MODULOS_TGS'; // T
    Chr($43): vNomeTabela := 'MODULOS_CALLCENTER'; // C
    Chr($53): vNomeTabela := 'TOTENS'; // S
    Chr($48): vNomeTabela := 'TOTENS'; // H
  else
    Exit;
  end;

  aDataSetModulo := TFDQuery.Create(Application);
  try
    with aDataSetModulo do
    begin
      Connection := dmSicsMain.connOnLine;

      if vModuloChar = Chr($53) then
      begin
        SQL.Text := Format(cSELECT_TOTEM_SLIM, [vNomeTabela, vgParametrosModulo.IdUnidade, vIdModulo]);
      end
      else if vModuloChar = Chr($4E) then
      begin
        SQL.Text := Format('SELECT * FROM %s WHERE ID_MODULO_TV = %d AND ID_UNIDADE=%u', [vNomeTabela, vIdModulo, vgParametrosModulo.IdUnidade]);
      end
      else if vModuloChar <> Chr($48) then
      begin
        SQL.Text := Format(cSELECT_TOTEM_TOUCH, [vNomeTabela, vgParametrosModulo.IdUnidade, vIdModulo]);
      end
      else
      begin
        SQL.Text := Format(cSELECT_ALL_COM_MODULO, [vNomeTabela, vgParametrosModulo.IdUnidade, vIdModulo]);
      end;

      Open;

      vParametros := vModuloChar + TAspEncode.AspIntToHex(vIdModulo, 4);
      if not IsEmpty then
      begin
        case vModuloChar of
          Chr($50): SolicitarParametrosModuloSICSPA(aDataSetModulo); //P
          Chr($4D): SolicitarParametrosModuloSICSMULTIPA(aDataSetModulo);  //M
          Chr($56): SolicitarParametrosModuloSICSTV(aDataSetModulo); //V
          Chr($4E): SolicitarParametrosModuloSICSTVPaineis(aDataSetModulo); //N
          Chr($4F): SolicitarParametrosModuloSICSONLINE(aDataSetModulo);
          Chr($54): SolicitarParametrosModuloSICSTGS(aDataSetModulo);
          Chr($43): SolicitarParametrosModuloSICSCALLCENTER(aDataSetModulo);
          Chr($53): SolicitarParametrosModuloTOTENSSLIM(aDataSetModulo);
          Chr($48): SolicitarParametrosModuloTOTENSTOUCH(aDataSetModulo);
        end;
      end;
      Result := vParametros;
    end;
  finally
    FreeAndNil(aDataSetModulo);
  end;
end; { case 8C }

function FormatarProtocolo(const aProtocolo: string): String;
begin
  Result := STX + TAspEncode.AspIntToHex(VERSAO_PROTOCOLO, 4) +
    aProtocolo + ETX;
end;

function DecifraProtocolo(s: string; DebugLocalPort : integer; DebugRemoteIP : string): string;
const
  EXCLUIR_DADOS_ATUAIS = True;
var
  Adr: Integer;
  AdrStr: string;
  ATD: Integer;
  AtdAtivo: Boolean;
  AtdLogin: string;
  AtdTipoAlteracao: string;
  AtdNome: string;
  AtdGrupoIdStr: string;
  AtdGrupoNome: string;
  AtdRegFunc: string;
  AtdSenhaLogin: string;
  AtdSenhaLogin2: string;
  AtdStr: string;
  Aux: string;
  Aux2: string;
  Aux3: string;
  AuxI: Integer;
  Comando: Char;
  DataHora: TDateTime;
  dd, mm, yy, hh, nn: Integer;
  FilaProveniente: Integer;
  FREQ: string;
  Fx: Integer;
  I: Integer;
  Id: Integer;
  IdCanal: Integer;
  IdGrupoAtd: Integer;
  IdModeloPainel: Integer;
  IdPainel: Integer;
  IdPP: Integer;
  IdPrinter: Integer;
  IdTag: Integer;
  IdTicket: Integer;
  IdTV: Integer;
  IniTime: TDateTime;
  MotivoPausa: Integer;
  NF: Integer;
  Nome: string;
  NomeCli: string;
  PA: Integer;
  PainelEndereco: string;
  PainelEnderecoIP: string;
  PainelManterUltimaSenha: Boolean;
  PainelMonitoramento: Boolean;
  PainelNome: string;
  ProtData: string;
  Senha: Integer;
  lOrdem: Integer;
  SenhaStr: string;
  StatusPA: TStatusPA;
  Tags: TIntArray;
  TipoDeGrupo: TTipoDeGrupo;
  vIdModulo: Integer;
  vIdPA: Integer;
  vlDest: string;
  vTipoModulo: TModuloSics;
  vVersaoProtocolo: Integer;
  vTipoGroupoPorModulo: TTipoGrupoPorModulo;
  vCharTipoGrupo: Char;
  MyStringList: TStringList;
  IniFile: TIniFile;
  vTipoConfiguracao: Char;
  vSecaoIni: string;
  vDestinatario: string;
  JSONObj: TJSONObject;
  LLoginCliente: string;
  LSenhaCliente: string;
  LSenhaClienteNova: string;
  LProtDataSeparado: TStringDynArray;
  LTicketCallCenter: Integer;
  LTotem: Integer;
  LFila: Integer;
  LAtribuiTag: String;
  LIDCliente: string;
  LPosicaoCliente: string;

  LListaTempoUnidade: TListaTempoUnidade;

  function GetIDModuloPorAdr: Integer;
  begin
    Result := Adr; // StrToIntDef('$' + Copy(ProtData, 1, 4), 0);
  end;
  function GetIDModuloPorProtData: Integer;
  begin
    Result := StrToIntDef('$' + Copy(ProtData, 1, 4), 0);
  end;

begin
  Result := '';
//   TLog.MyLog('Ansi: ' + TEncoding.Default.ClassName + ' | Evento: DecifrarProtocolo | Protocolo: ' + S, nil);
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou DecifraProtocolo (' + inttostr(length(s)) + ' caracteres): ' + s);

  if ((Length(s) > 6) and (s[1] = STX) and (s[Length(s)] = ETX)) then
    try
      vVersaoProtocolo := StrToIntDef('$' + ExtractStr(s, 2, 4), 0);
      AdrStr := s[2] + s[3] + s[4] + s[5];
      Adr := StrToInt('$' + AdrStr);
      Comando := Chr(TEncoding.Default.GetBytes(s[6])[0]);
      ProtData := Copy(s, 7, Length(s) - 7);

      // TLog.MyLog('Comando: ' + Comando + ' | Hex comando: ' + TAspEncode.AspIntToHex(Ord(Comando), 4) + ' | StrComando: ' + s[6] + ' | Adr: ' + IntToStr(Adr) + ' | ProtData: ' + ProtData);

      if ((vVersaoProtocolo <> VERSAO_PROTOCOLO) and (Comando <> Chr($0A))) then
      begin
        Result := AdrStr + Chr($0C) + TAspEncode.AspIntToHex(VERSAO_PROTOCOLO);
        Exit;
      end;

{$REGION 'Comandos'}
      case Comando of
        Chr($0D):
          begin
            frmSicsMain.GetJSONBySQLText(Result, ProtData);
            Result := AdrStr + Chr($0E) + Result;
          end;
        Chr($0A):
          begin
            if Pos('TV', ProtData) > 0 then
            begin
              vTipoModulo := msTV;
              vIdModulo   := 0;
            end
            else
            begin
              vIdModulo := GetIDModuloPorProtData;
              vTipoModulo := GetModuleTypeByID(dmSicsMain.connOnLine, vIdModulo);
            end;

            case vTipoModulo of
              msPA:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_PA, false);
              msMPA:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_MULTIPA, false);
              msOnLine:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_ONLINE, false);
              msTGS:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_TGS, false);
              msTV:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_TV, false);
              msCallCenter:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_CALLCENTER, false);
              msTotemTouch:
                frmSicsMain.GetSendConfiguracoesGeraisText(Result, CONFIG_KEY_PATHUPDATE_TOTEMTOUCH, false);
            else
              Exit;
            end;

            Result := AdrStr + Chr($0B) + Result;
            //corrigir em versões futuras, está enviando com endereço 0000 para
            //poder validar no client, porém deveria validar com o ID do módulo,
            //ou com um novo parâmetro do tipo de módulo dentro do ProtData
          end;
        Chr($20):
          begin
            Senha := frmSicsMain.Proximo(Adr,IniTime);
            case Senha of
              - 1:
                Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
              -2:
                Result := ''; { Esta na fila para chamar alguem }
              -5:
                Result := AdrStr + Chr($24) + 'L';
              -7:
                Result := AdrStr + Chr($24) + 'p';
            else
              begin
                frmSicsMain.GetFilaProximaSenha(LFila, Nome, Aux);
                Result := AdrStr + Chr($23) + IntToStr(Senha) + TAB + IntToStr(LFila) + TAB + Nome + TAB + FormatDateTime('dd/mm/yyyy hh:nn:ss', IniTime);
                { Chamou uma senha }
              end;
            end; { case }
          end; { case Chr($20) }
        Chr($21):
          begin
            Aux := ProtData; // Faz essa checagem porque se a senha for ''
            if Aux = '' then // ele tem que primeiro verificar
              Senha := -1
              // se tem Atd logado na PA (dentro da "ChamaEspecifica).
            else // Se nao tiver, vai devolver -5 e, se tiver,
              Senha := StrToInt(Aux);
            // vai devolver -6 (senha invalida, por isso o senha := -1)

            Senha := frmSicsMain.ChamaEspecifica(Adr, Senha, IniTime);
            { -6  -> senha inválida (out of range) }
            { -5  -> não tem atendente logado na PA }
            { -4  -> não chamou ninguém porque numero de atendimentos ultrapassa magazine }
            { -3  -> a senha está numa fila não contida nas prioridades de atendimento }
            { -2  -> o atendente está aguardando para ser anunciado na painel }
            { -1  -> a senha não está em nenhuma fila }
            case Senha of
              - 1:
                Result := AdrStr + Chr($50) + ProtData;
              -2:
                Result := ''; { Esta na fila para chamar alguem }
              -3:
                Result := AdrStr + Chr($51) + ProtData;
              -4:
                Result := AdrStr + Chr($24) + 'M';
              -5:
                Result := AdrStr + Chr($24) + 'L';
              -6:
                Result := AdrStr + Chr($24) + 'I';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($21) }
        Chr($22):
          begin
            Senha := frmSicsMain.Rechama(Adr);
            case Senha of
              - 1:
                Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
              -2:
                Result := ''; { Esta na fila para chamar alguem }
              -5:
                Result := AdrStr + Chr($24) + 'L';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($22) }
        Chr($25):
          begin
            Senha := frmSicsMain.Finaliza(Adr);

            case Senha of
              -1: Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
              -2: Result := ''; { Esta na fila para chamar alguem }
              -5: Result := AdrStr + Chr($24) + 'L';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($25) }
        Chr($26):
          begin
            dmSicsMain.CarregaTabelasPAsEFilas;
            // Result := ???;
          end;

        Chr($27):
          begin
            IdPainel := StrToInt('$' + Copy(ProtData, 1, 4));
            dmSicsMain.AtualizarJornalTV(IdPainel);
          end;

        Chr($28):
          begin
            Result := EmptyStr;

            if ProtData = '----' then
            begin
              if frmSicsMain.FinalizarPausa(Adr) then
                Result := 'ok';
            end
            else
            begin
              SomenteRedirecionar := True;
              MotivoPausa := StrToInt('$' + Copy(ProtData, 1, 4));
              //JLS - Adicionei esta verificação através da função "CheckMotivoPausaPermitidoNaPA",
              //      que só deixa pausar uma PA se o motivo estiver permissionado para a mesma.
              if (frmSicsMain.CheckMotivoPausaPermitidoNaPA(Adr,MotivoPausa)) then
              begin
                Fx := StrToInt('$' + Copy(ProtData, 5, 4));
                frmSicsMain.Redireciona(Adr, Fx);

                if frmSicsMain.IniciarPausa(Adr, MotivoPausa) then
                  Result := 'ok';

                SomenteRedirecionar := false;
              end;
            end;

            if Result = 'ok' then
              Result := AdrStr + Chr($B9) + '1'
            else
              Result := AdrStr + Chr($B9) + '0';

            // frmSicsMain.GetSendPAsSituationText(Adr, Aux);
            // Result := AdrStr + Chr($3C) + Aux;
          end; { case Chr($28) }
        Chr($29):
          begin
            frmSicsMain.GetSendPAsSituationText(Adr, Aux);
            Result := AdrStr + Chr($3C) + Aux;
          end;
        Chr($2A):
          begin
            // BAH 09/08/2016
            // BAH PROT ALTERADO
            { vIdModulo := GetIDModuloPorAdr;
              vIdPA := GetIDPAInternal(vIdModulo); }
            frmSicsMain.GetSendStatusDasPAsTableText(Aux);
            Result := AdrStr + Chr($2D) + Aux;
            // Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($2D) + Aux;
          end;
        Chr($2B):
          begin
            IdPainel := StrToInt('$' + Copy(ProtData, 1, 4));
            Aux := Copy(ProtData, 5, Length(ProtData) - 4);

            NSetPainelMsg(IdPainel, Aux);

            frmSicsMain.SubstituirTagsDePIs(Aux);
            frmSicsMain.ConstroiXMLDaIntegracaoWebService(IdPainel, Aux);
            frmSicsMain.SendMessageToPanel(IdPainel, Aux);

            Result := AdrStr + ACK;
          end; { case Chr($2B) }
        Chr($2C):
          begin
            IdPrinter := StrToInt('$' + Copy(ProtData, 1, 4));
            Aux := Copy(ProtData, 5, Length(ProtData) - 4);

            NSetPrinterMsg(IdPrinter, Aux);

            Result := AdrStr + ACK;
          end; { case Chr($2C) }
        Chr($2E):
          begin
            if Length(ProtData) = 4 then
              NF := StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] + ProtData[4])
            else
              NF := 0;
            Senha := frmSicsMain.Redireciona(Adr, NF);
            case Senha of
              -1: Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
              -2: Result := ''; { Esta na fila para chamar alguem }
              -5: Result := AdrStr + Chr($24) + 'L';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($2E) }
        Chr($2F):
          begin
            if Length(ProtData) = 4 then
              NF := StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] + ProtData[4])
            else
              NF := 0;
            Senha := frmSicsMain.RedirecionaEProximo(Adr, NF);
            case Senha of
              - 1:
                Result := AdrStr + Chr($24) + '0';
              -2:
                ; { Esta na fila para chamar alguem }
              -5:
                Result := AdrStr + Chr($24) + 'L';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($2F) }
        Chr($30):
          begin
            var IdFila : integer;
            var NomeFila : string;

            Senha := frmSicsMain.ForcaChamada(Adr, StrToInt(ProtData), IniTime, IdFila, NomeFila);
            case Senha of
              -1: Result := AdrStr + Chr($50) + ProtData;
              -2: Result := ''; { Esta na fila para chamar alguem }
              -3: Result := AdrStr + Chr($51) + ProtData;
              -4: Result := AdrStr + Chr($24) + 'M';
              -5: Result := AdrStr + Chr($24) + 'L';
              -6: Result := AdrStr + Chr($24) + 'I';
              else
                Result := AdrStr + Chr($23) + IntToStr(Senha) + TAB + IntToStr(IdFila) + TAB + NomeFila + TAB + DateTimeToStr(IniTime);
            end; { case }
          end; { case Chr($30) }
        Chr($31):
          begin
            NF := StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] + ProtData[4]);
            Senha := frmSicsMain.RedirecionaEEspecifica(Adr, NF, StrToInt(Copy(ProtData, 5, Length(ProtData) - 4)));
            case Senha of
              -1: Result := AdrStr + Chr($50) + Copy(ProtData, 5, Length(ProtData) - 4);
              -2: Result := ''; { Esta na fila para chamar alguem }
              -3: Result := AdrStr + Chr($51) + Copy(ProtData, 5, Length(ProtData) - 4);
              -4: Result := AdrStr + Chr($24) + 'M';
              -5: Result := AdrStr + Chr($24) + 'L';
              -6: Result := AdrStr + Chr($24) + 'I';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($31) }
        Chr($32):
          begin
            NF := StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] + ProtData[4]);
            Senha := frmSicsMain.RedirecionaEForca(Adr, NF, StrToInt(Copy(ProtData, 5, Length(ProtData) - 4)));

            case Senha of
              - 1:
                Result := AdrStr + Chr($50) + Copy(ProtData, 5,
                  Length(ProtData) - 4);
              -2:
                Result := ''; { Esta na fila para chamar alguem }
              -3:
                Result := AdrStr + Chr($51) + Copy(ProtData, 5,
                  Length(ProtData) - 4);
              -4:
                Result := AdrStr + Chr($24) + 'M';
              -5:
                Result := AdrStr + Chr($24) + 'L';
              -6:
                Result := AdrStr + Chr($24) + 'I';
            else
              Result := AdrStr + Chr($23) + IntToStr(Senha);
              { Chamou uma senha }
            end; { case }
          end; { case Chr($32) }
        Chr($34):
          begin
            frmSicsMain.GetSendFilasText(Aux);
            Result := AdrStr + Chr($35) + Aux;
          end;
        Chr($36):
          begin
            frmSicsMain.GetSendWaitingPswdsText(Aux);
            Result := AdrStr + Chr($3B) + Aux;
          end;
        Chr($38):
          begin
            Senha := frmSicsMain.Proximo(Adr, IniTime);
            case Senha of
              - 1:
                Result := AdrStr + Chr($24); { Nao chamou ninguem }
              -2:
                ; { Esta na fila para chamar alguem }
              -5:
                Result := AdrStr + Chr($24) + 'L';
              -7:
                Result := AdrStr + Chr($24) + 'p';
            else
              begin
                if IniTime <> EncodeDate(1, 1, 1) then
                  Result := AdrStr + Chr($39) + IntToStr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime)
                  { Chamou uma senha }
                else
                  Result := AdrStr + Chr($23) + IntToStr(Senha);
                { Esta na fila outbuffer pra aparecer no painel }
              end; { else }
            end; { case }
          end; { case Chr($38) }

        Chr($3A):
          begin
            frmSicsMain.ExcluirSenhasPelaFila(StrToInt('$' + ProtData));
            Result := '';
          end;

        Chr($3D):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendPAsListText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($3E) + TAspEncode.AspIntToHex(vIdModulo, 4) + Aux;
          end; { case Chr($3D) }
        Chr($3F):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendPPsTableText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($40) + TAspEncode.AspIntToHex(vIdModulo, 4) + Aux;
          end;
        Chr($41):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);

            frmSicsMain.GetSendMotivosDePausaTableText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($42) + Aux;
          end;
        Chr($53):
          begin
            frmSicsMain.FinalizaPelaSenha(StrToInt(ProtData));
            Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
          end; { case Chr($53) }
        Chr($54):
          begin
            vIdModulo := StrToInt('$' + Copy(ProtData, 1, 4));
            ProtData := Copy(ProtData, 5);
            SeparaStrings(ProtData, TAB, AtdLogin, AtdSenhaLogin);

            if frmSicsMain.Login(vIdModulo, Adr, AtdLogin, AtdSenhaLogin) then
              Result := AdrStr + Chr($B4) + '1'
            else
              Result := AdrStr + Chr($B4) + '0';
          end; { case Chr($54) }
        Chr($55):
          begin
            ATD := StrToInt('$' + Copy(ProtData, 1, 4));
            PA := Adr;
            if PA = 0 then
            begin
              PA := StrToInt('$' + Copy(ProtData, 9, 4));
            end;
            Fx := StrToInt('$' + Copy(ProtData, 5, 4));

            SomenteRedirecionar := True;
            frmSicsMain.Redireciona(PA, Fx);
            SomenteRedirecionar := false;

            frmSicsMain.Logout(ATD);

            Result := '';
            // frmSicsMain.GetSendPAsSituationText(PA, Aux);
            // Result := AdrStr + Chr($3C) + Aux;
          end; { case Chr($55) }
        Chr($56):
          begin
            Aux := frmSicsMain.GetNomeParaSenha(StrToInt(ProtData));
            Result := AdrStr + Chr($57) + ProtData + TAB + Aux;
          end; { case 56 }
        Chr($57):
          begin
            // INÍCIO - verificação se junto com o NOME da senha veio o
            // ID de PUSH do dispositivo que vai receber notificações
            // quando a senha for chamada. Este ID, se detectado, é
            // removido do ProtData, para seguir o fluxo normal (quando
            // não vem ID)
            Aux3 := '';
            I := Pos('|<', ProtData);
            Id := Pos('>|', ProtData);
            if (I > 0) and (Id > I) then
            begin
              Aux3 := Copy(ProtData, I + 2, Id - (I + 2));
              Delete(ProtData, I, Length(ProtData));
            end;
            // FIM - verif. do ID de PUSH do Disp. que recebe Notificação

            SeparaStrings(ProtData, TAB, SenhaStr, NomeCli);

            NomeCli := StringReplace(NomeCli, #13, '', [rfReplaceAll]);
            NomeCli := StringReplace(NomeCli, #10, '', [rfReplaceAll]);
            NomeCli := StringReplace(NomeCli, #9, '', [rfReplaceAll]);

            if SenhaStr <> '---' then
            begin
              // se recebeu o ID de PUSH e conseguiu localizar a senha,
              // então faz o vínculo de um com o outro
              if (Aux3 <> EmptyStr) then
              begin
                Id := frmSicsMain.GetIdTicketIfPwdExists(StrToInt(SenhaStr));
                if (Id > 0) then
                  dmSicsMain.SetDeviceIdSenha(Id, Aux3);
              end;

              if frmSicsMain.DefinirNomeParaSenha(StrToInt(SenhaStr), NomeCli)
              then
              begin
                frmSicsMain.EnviaParaTodosOsClients
                  (frmSicsMain.ServerSocket1.Socket,
                  '0000' + Chr($57) + ProtData);
                frmSicsMain.EnviaParaTodosOsClients
                  (frmSicsMain.TGSServerSocket.Socket,
                  '0000' + Chr($57) + ProtData);
              end
              else
              begin
                Aux := frmSicsMain.GetNomeParaSenha(StrToInt(SenhaStr));
                frmSicsMain.EnviaParaTodosOsClients
                  (frmSicsMain.ServerSocket1.Socket,
                  '0000' + Chr($57) + SenhaStr + TAB + Aux);
                frmSicsMain.EnviaParaTodosOsClients
                  (frmSicsMain.TGSServerSocket.Socket,
                  '0000' + Chr($57) + SenhaStr + TAB + Aux);
              end;
            end;
          end; { case 57 }
        Chr($58):
          begin
            Aux := ProtData;
            if Aux = '' then
              Senha := -1
            else
              Senha := StrToInt(Aux);

            frmSicsMain.GetSendPPsSituationText(Senha, Aux);
            Result := AdrStr + Chr($59) + Aux;
          end;
        Chr($5A):
          begin
            if ((AdrStr = 'FFFF') or (AdrStr = '0000')) then
              PA := -1
            else
              PA := StrToInt('$' + AdrStr);

            AtdStr := Copy(ProtData, 1, 4);
            if AtdStr = '----' then
              ATD := -1
            else
              ATD := StrToInt('$' + AtdStr);

            Senha := StrToInt(Copy(ProtData, 5, Pos(',', ProtData) - 5));

            Aux := Copy(ProtData, Pos(',', ProtData) + 1,
              Length(ProtData) - Pos(',', ProtData));
            while Aux <> '' do
            begin
              SeparaStrings(Aux, ';', Aux2, Aux);
              frmSicsProcessosParalelos.FinalizaPP(StrToInt(Aux2), PA, ATD);
            end;

            frmSicsMain.GetSendPPsSituationText(Senha, Aux);
            Result := AdrStr + Chr($59) + Aux;
          end;
        Chr($5B):
          begin
            ATD := StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] +
              ProtData[4]);
            PA := Adr;
            AtdSenhaLogin := TextHash(Copy(ProtData, 5, Length(ProtData) - 4));

            frmSicsMain.Login(0, PA, IntToStr(ATD), AtdSenhaLogin);

            frmSicsSituacaoAtendimento.GetPASituation(PA, StatusPA, ATD, Aux,
              FilaProveniente, MotivoPausa, IniTime);
            if ATD = -1 then
              Result := AdrStr + Chr($5C)
            else
            begin
              if (ATD <> StrToInt('$' + ProtData[1] + ProtData[2] + ProtData[3] + ProtData[4])) or
                (Pos('(socket de teclado TCP/IP)', DebugRemoteIP) > 0) then
                NGetAtdData(ATD, AtdAtivo, IdGrupoAtd, AtdNome, AtdLogin, AtdSenhaLogin2, AtdRegFunc);
              Result := AdrStr + Chr($5C) + AtdNome;
            end;
          end;
        Chr($5D):
          begin
            Fx := StrToInt('$' + Copy(ProtData, 1, 4));

            SomenteRedirecionar := True;
            frmSicsMain.Redireciona(Adr, Fx);
            SomenteRedirecionar := false;

            if frmSicsMain.LogoutPA(Adr) then
              Result := AdrStr + Chr($B8) + '1'
            else
              Result := AdrStr + Chr($B8) + '0';

            // frmSicsMain.GetSendPAsSituationText(Adr, Aux);
            // Result := AdrStr + Chr($3C) + Aux;
          end; { case Chr($5D) }
        Chr($5E):
          begin
            frmSicsMain.GetSendOnePASituationText(Adr, Aux);
            Result := AdrStr + Chr($5F) + Aux;
          end; { case Chr($5E) }
        Chr($64):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendPIsNamesText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($65) +
              TAspEncode.AspIntToHex(vIdModulo, 4) + Aux;
          end;
        Chr($66):
          begin
            frmSicsMain.GetSendPIsSituationText(Aux);
            Result := AdrStr + Chr($67) + Aux;
          end; { case Chr($66) }
        Chr($68):
          begin
            if ((AdrStr = 'FFFF') or (AdrStr = '0000')) then
              PA := -1
            else
              PA := StrToInt('$' + AdrStr);

            AtdStr := Copy(ProtData, 1, 4);
            if AtdStr = '----' then
              ATD := -1
            else
              ATD := StrToInt('$' + AtdStr);

            IdPP := StrToInt('$' + Copy(ProtData, 5, 4));
            Senha := StrToInt(Copy(ProtData, 9, Length(ProtData) - 8));
            frmSicsProcessosParalelos.IniciaPP(IdPP, PA, ATD, Senha, now);

            frmSicsMain.GetSendPPsSituationText(Senha, Aux);
            Result := AdrStr + Chr($59) + Aux;
          end; { case Chr($68) }
        Chr($69):
          begin
            if ProtData[5] = 'P' then
            begin
              if frmSicsMain.FindComponent('PrioritaryList' + IntToStr(StrToInt('$' + Copy(ProtData, 1, 4)))) <> nil then
                (frmSicsMain.FindComponent('PrioritaryList' + IntToStr(StrToInt('$' + Copy(ProtData, 1, 4)))) as TCheckBox).Checked := (ProtData[6] = '1');
            end
            else
            begin
              if frmSicsMain.FindComponent('ListBlocked' + IntToStr(StrToInt('$' + Copy(ProtData, 1, 4)))) <> nil then
                (frmSicsMain.FindComponent('ListBlocked' + IntToStr(StrToInt('$' + Copy(ProtData, 1, 4)))) as TCheckBox).Checked := (ProtData[6] = '1');
            end;
            Result := '';
          end; { case Chr($69) }
        Chr($6A):
          begin
            SeparaStrings(ProtData, TAB , Aux, Aux2);
            Id := frmSicsMain.GetIdTicketIfPwdExists(StrToInt(Aux), NF, PA);

            if Id >= 0 then
            begin
              frmSicsMain.FinalizaPelaSenha(StrToInt(Aux));

              if Aux2 <> EmptyStr then
              begin
                JSONObj := TJSONObject(TJSONObject.ParseJSONValue(Aux2));
                try
                  if Assigned(JSONObj) then
                  begin
                    if NF <> -1 then
                    begin
                      JSONObj.AddPair('delfila', TJSONNumber.Create(NF));
                    end
                    else
                    begin
                      if PA <> -1 then
                        JSONObj.AddPair('delpa', TJSONNumber.Create(PA));
                    end;

                    JSONObj.AddPair('deldatahora', DateTimeToStr(Now));
                    dmSicsMain.SalvarDadosAdicionais(Id, JSONObj, not EXCLUIR_DADOS_ATUAIS);
                  end;
                finally
                  JSONObj.Free;
                end;
              end;
            end;

            Result := AdrStr + ACK;
          end; { case Chr($6A) }
        Chr($6B):
          begin
            Fx := StrToInt('$' + Copy(ProtData, 1, 4));
            if frmSicsMain.FindComponent('SenhasList' + IntToStr(Fx)) <> nil then
              frmSicsMain.InsertPswd(Fx, StrToInt(Copy(ProtData, 5, Length(ProtData) - 4)), now, -1);
          end; { case Chr($6B) }
        Chr($6C):
          begin
            Fx := StrToInt('$' + Copy(ProtData, 1, 4));
            frmSicsMain.GetSendOneFilaDetailedSituationText(Fx, Aux, False);
            Result := '0000' + Chr($6D) + Aux;
          end; { case Chr($6C) }
        Chr($4A):
          begin
            Fx := StrToInt('$' + Copy(ProtData, 1, 4));
            frmSicsMain.GetSendOneFilaDetailedSituationText(Fx, Aux, True);
            Result := '0000' + Chr($6D) + Aux;
          end; { case Chr($4A) }
        Chr($6E):
          begin
            frmSicsMain.GetSendSituacaoPrioritariasBloqueadasText(Aux);
            Result := AdrStr + Chr($6F) + Aux;
          end; { case Chr($6E) }
        Chr($70):
          begin
            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Entrei no Comando %s | Horario Inicial: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));

            Fx := StrToInt('$' + Copy(ProtData, 1, 4));
            Senha := -1;
            frmSicsMain.GeraSenhaEImprime(Fx, StrToInt('$' + Copy(ProtData, 5, 4)), Senha, IniTime);
            with FormatSettings.Invariant do
              Aux := ShortDateFormat + ' ' + LongTimeFormat;
            Result := AdrStr + Chr($C6) + IntToHex(Fx, 4) + IntToStr(Senha) + TAB + FormatDateTime(Aux, IniTime);

            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Sai do Comando %s | Horario Final: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));
          end; { case Chr($70) }
        Chr($71):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);

            frmSicsMain.GetSendAtdsListText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($72) + Aux;
          end; { case Chr($71) }
        Chr($72):
          begin
            Aux := ProtData;
            Aux := Copy(Aux, 5, Length(Aux) - 4); // NATD = 0001

            ATD := StrToInt('$' + Copy(Aux, 1, 4));
            Aux := Copy(Aux, 5, Length(Aux) - 4);

            while Aux[Length(Aux)] = TAB do
              Aux := Copy(Aux, 1, Length(Aux) - 1);

            SeparaStrings(Aux, ';', AtdNome, Aux);
            SeparaStrings(Aux, ';', AtdRegFunc, Aux);
            SeparaStrings(Aux, ';', Aux2, Aux);
            IdGrupoAtd := StrToInt(Aux2);
            SeparaStrings(Aux, ';', AtdSenhaLogin, Aux);
            SeparaStrings(Aux, ';', AtdLogin, Aux);
            SeparaStrings(Aux, ';', AtdTipoAlteracao, Aux);
            SeparaStrings(Aux, ';', Aux2, Aux);
            AtdAtivo := Aux2 = '1';
            // AtdSenhaLogin := DecriptLegivel(AtdSenhaLogin);

            case StrToIntDef(AtdTipoAlteracao, 0) of
              0: frmSicsMain.AtualizaAtendente(ATD, AtdAtivo, AtdNome, AtdLogin, AtdSenhaLogin, AtdRegFunc, IdGrupoAtd);
              1: frmSicsMain.AtualizaSenhaAtendente(ATD, AtdSenhaLogin);
            end;

            Result := '';
          end; { case Chr($72) }
        Chr($74):
          begin
            Aux := ProtData;

            while Aux[Length(Aux)] = TAB do
              Aux := Copy(Aux, 1, Length(Aux) - 1);
            SeparaStrings(Aux, ';', AtdNome, Aux);
            SeparaStrings(Aux, ';', AtdLogin, Aux);
            SeparaStrings(Aux, ';', Aux2, Aux);
            IdGrupoAtd := StrToInt(Aux2);
            SeparaStrings(Aux, ';', AtdSenhaLogin, Aux2);

            ATD := frmSicsMain.InsereAtendente(AtdNome, AtdLogin, AtdSenhaLogin, IdGrupoAtd);

            if ATD <> -1 then
              Result := AdrStr + Chr($75) + TAspEncode.AspIntToHex(ATD, 4);
          end; { case Chr($74) }
        Chr($76):
          begin
            vCharTipoGrupo := ProtData[1];
            Id := StrToInt('$' + Copy(ProtData, 2));

            case vCharTipoGrupo of
              'A':
                begin
                  Nome := NGetAtdName(Id);
                  Aux := 'SICS - ATENDENTE ' + IntToStr(Id) + ' (' + Nome + '){{Quebra de Linha}}';
                  Aux2 := '{{CDB Code39}}' + FormatLeftString(10,
                    '%ATD' + IntToStr(Id) + '$') +
                    '{{Fim de Bloco CDB Code39}}{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                end;
              'P':
                begin
                  Nome := NGetPAName(Id);
                  Aux := 'SICS - PA ' + IntToStr(Id) + ' (' + Nome +
                    '){{Quebra de Linha}}';
                  Aux2 := '{{CDB Code39}}' + FormatLeftString(10,
                    '%PA' + IntToStr(Id) + '$') +
                    '{{Fim de Bloco CDB Code39}}{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                end;
              'F':
                begin
                  Nome := NGetFilaName(Id);
                  Aux := 'SICS - FILA ' + IntToStr(Id) + ' (' + Nome + '){{Quebra de Linha}}';
                  Aux2 := '{{CDB Code39}}' + FormatLeftString(10,'%FILA' + IntToStr(Id) + '$') +
                    '{{Fim de Bloco CDB Code39}}{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                end;
            end;

            if frmSicsMain.GetModeloImpressoraZero = tiBematech then
            begin
              frmSicsMain.ConfiguraCDBBematech(0);
              Delay(250);
            end;

            ConverteProtocoloImpressora(Aux3, Aux, frmSicsMain.GetModeloImpressoraZero);
            frmSicsMain.Imprime(0, Aux3);
            Delay(500);
            ConverteProtocoloImpressora(Aux3, Aux2, frmSicsMain.GetModeloImpressoraZero);
            frmSicsMain.Imprime(0, Aux3);

            Result := ACK;
          end; { case Chr($76) }
        Chr($77):
          begin
            Fx := StrToInt('$' + Copy(ProtData, 1, 4));
            if frmSicsMain.FindComponent('SenhasList' + IntToStr(Fx)) <> nil then
            begin
              frmSicsMain.InserirSenhaNaFila(Fx, StrToInt(Copy(ProtData, 5, Length(ProtData) - 4)), -2, isNova);

              //frmSicsMain.InsertPswd(Fx,
              //  StrToInt(Copy(ProtData, 5, Length(ProtData) - 4)), now, -2);
              Result := AdrStr + Chr($24) + '0'; { Nao chamou ninguem }
            end;
          end; { case Chr($77) }
        Chr($78):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            vTipoGroupoPorModulo.IdModulo := vIdModulo;
            vTipoGroupoPorModulo.FModuloSics := GetModuleTypeByID(dmSicsMain.connOnLine, vIdModulo);
            vTipoGroupoPorModulo.TipoDeGrupo := GetTipoDeGrupo(ProtData[1]);
            frmSicsMain.GetSendGruposNamesText(vTipoGroupoPorModulo, Aux);

            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($79) + ProtData[1] + Aux;
          end;
        Chr($7A):
          begin
            vCharTipoGrupo := ProtData[1];

            case vCharTipoGrupo of
              'A':
                begin
                  dmSicsMain.CarregaTabelaAtendentes;
                  frmSicsSituacaoAtendimento.AtualizarCdsAtendentes(dmSicsMain.cdsAtendentes);
                  frmSicsMain.SalvaSituacao_Atendimento;
                  frmSicsMain.BroadcastListaDeAtendentes;
                end;
              'K':
                begin
                  dmSicsMain.AtualizarTabelasPis;
                end;
              'C':
                begin
                  dmSicsMain.AtualizarTabelaConfiguracoesGerais;
                end;
              'L':
                begin
                  dmSicsMain.AtualizarTabelaClientes;
                end;
              'P':
                begin
                  dmSicsMain.CarregaTabelasPAsEFilas;
                  frmSicsSituacaoAtendimento.AtualizarCdsPAs(dmSicsMain.cdsPAs);
                  frmSicsMain.SalvaSituacao_Atendimento;
                end;
              'T':
                begin
                  dmSicsMain.CarregaTabelaTags;
                end;
              'S':
                begin
                  dmSicsMain.CarregaPPs;
                end;
              'M':
                begin
                  dmSicsMain.CarregaMotivoPausas;
                end;
              'E':
                begin
                  dmSicsMain.CarregaTotens;
                end;
              'W':
                begin
                  dmSicsMain.CarregaCelulares;
                end;
              'O':
                begin
                  dmSicsMain.CarregaEmails;
                end;
              'H':
                begin
                  dmSicsMain.CarregaModulos;
                end;
              'G':
                begin
                  dmSicsMain.CarregaGrupoFilas;
                end;
              'B':
                begin
                  dmSicsMain.CarregaCategoriaFilas;
                end;
            else
              vCharTipoGrupo := ' ';
            end;

            if vCharTipoGrupo = 'C' then
              Result := AdrStr + ACK
            else
            begin
              vTipoGroupoPorModulo.IdModulo := 0;
              vTipoGroupoPorModulo.FModuloSics := GetModuleTypeByID(dmSicsMain.connOnLine, 0);
              vTipoGroupoPorModulo.TipoDeGrupo := GetTipoDeGrupo(vCharTipoGrupo);
              frmSicsMain.GetSendGruposNamesText(vTipoGroupoPorModulo, Aux);

              Result := TAspEncode.AspIntToHex(0, 4) + Chr($79) + vCharTipoGrupo + Aux;
            end;
          end;

        Chr($7B):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendFilasNamesText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($7C) + Aux;
          end;

        Chr($7D):
          begin
            IdTag := StrToInt('$' + Copy(ProtData, 1, 4));
            Senha := StrToInt(Copy(ProtData, 5, Length(ProtData) - 4));
            Aux := IntToStr(frmSicsMain.DefinirTagParaSenha(Senha, IdTag));
            Result := AdrStr + Chr($7E) + Aux;

            Tags := frmSicsMain.GetTagsTicket(Senha);
            IntArrayToStr(Tags, Aux);
            frmSicsMain.EnviaParaTodosOsClients(frmSicsMain.ServerSocket1.Socket, AdrStr + Chr($82) + IntToStr(Senha) + ';' + Aux);
          end; { case Chr($7D) }
        // comando alterado a partir daqui
        Chr($7F):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendTagsNamesText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($AA) + TAspEncode.AspIntToHex(vIdModulo, 4) + Aux;
          end;
        Chr($A0):
          begin
            vTipoConfiguracao := ProtData[1];
            IniFile := TIniFile.Create(GetIniFileName);
            try
              MyStringList := TStringList.Create;
              try
                case vTipoConfiguracao of
                  'E':
                    begin
                      IniFile.ReadSectionValues('SMTP', MyStringList);
                      Result := AdrStr + Chr($A1) + vTipoConfiguracao + 'SMTP' + CR + LF + MyStringList.Text;
                    end;
                  'S':
                    begin
                      IniFile.ReadSectionValues('SMS', MyStringList);
                      Result := AdrStr + Chr($A1) + vTipoConfiguracao + 'SMS' + CR + LF + MyStringList.Text;
                    end;
                end;

              finally
                MyStringList.Free;
              end;
            finally
              IniFile.Free;
            end;
          end; { case A0 }
        Chr($A1):
          begin
            vTipoConfiguracao := ProtData[1];
            IniFile := TIniFile.Create(GetIniFileName);
            try
              MyStringList := TStringList.Create;
              try
                MyStringList.Text := Copy(ProtData, 2);

                if MyStringList.Count > 0 then
                begin
                  vSecaoIni := MyStringList.Strings[0];

                  IniFile.EraseSection(vSecaoIni);

                  for I := 1 to MyStringList.Count - 1 do
                    IniFile.WriteString(vSecaoIni, MyStringList.Names[I], MyStringList.ValueFromIndex[I]);

                  Result := ACK;
                end;
              finally
                MyStringList.Free;
              end;
            finally
              IniFile.Free;
            end;
          end; { case A1 }
        Chr($A2):
          begin
            vTipoConfiguracao := ProtData[1];
            vDestinatario := Copy(ProtData, 2);

            case vTipoConfiguracao of
              'E':
                begin
                  if AspEnviaEmail(vDestinatario,
                    '*** SICS - Teste de envio de e-mail ***',
                    '*********************************************************************'#13#10
                    + '*  Unidade: ' + FormatLeftString(54,
                    vgParametrosModulo.NomeUnidade) + '  *'#13#10 +
                    '*  Horário: ' + FormatLeftString(54,
                    FormatDateTime('dd/mm/yyyy hh:nn:ss', now)) + '  *'#13#10 +
                    '*  Status:  ' + FormatLeftString(54,
                    'Teste de sistema para envio de e-mail.') + '  *'#13#10 +
                    '*********************************************************************')
                  then
                    Result := ACK
                  else
                    Result := NAK;
                end;
              'S':
                begin
                  if AspEnviaSMS(vDestinatario,
                    '*** SICS - Teste de envio de SMS ***') then
                    Result := ACK
                  else
                    Result := NAK;
                end;
            end;
          end; { case A1 }
        Chr($AB):
          begin
            Tags := frmSicsMain.GetTagsTicket(StrToInt(ProtData));
            IntArrayToStr(Tags, Aux);
            Result := AdrStr + Chr($AC) + ProtData + ';' + Aux;
          end; { case 81 }
        Chr($AD):
          begin
            IdTag := StrToInt('$' + Copy(ProtData, 1, 4));
            Senha := StrToInt(Copy(ProtData, 5, Length(ProtData) - 4));
            Aux := IntToStr(frmSicsMain.DesassociarTagParaSenha(Senha, IdTag));
            Result := AdrStr + Chr($AE) + Aux;

            Tags := frmSicsMain.GetTagsTicket(Senha);
            IntArrayToStr(Tags, Aux);
            frmSicsMain.EnviaParaTodosOsClients(frmSicsMain.ServerSocket1.Socket, AdrStr + Chr($82) + IntToStr(Senha) + ';' + Aux);
          end; { case 83) }
        Chr($AF):
          begin
            vIdModulo := GetIDModuloPorAdr;
            vIdPA := GetIDPAInternal(vIdModulo);
            frmSicsMain.GetSendFilasNamesText(vIdModulo, Aux);
            Result := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($86) + TAspEncode.AspIntToHex(vIdModulo, 4) + Aux;
          end;
        Chr($C1):
          begin
            SeparaStrings(ProtData, ';', AtdLogin, AtdNome);
            SeparaStrings(AtdNome, ';', AtdNome, AtdGrupoIdStr);
            SeparaStrings(AtdGrupoIdStr, ';', AtdGrupoIdStr, AtdGrupoNome);
            IdGrupoAtd := StrToIntDef(AtdGrupoIdStr, -1);

            if frmSicsMain.ForcaLogin(Adr, AtdLogin, AtdNome, IdGrupoAtd, AtdGrupoNome) then
              Result := AdrStr + Chr($B4) + '1'
            else
              Result := AdrStr + Chr($B4) + '0';
          end;
        Chr($C2):
          begin
            Senha := StrToInt(ProtData);
            frmSicsMain.GetSendAgendamentosFilasText(Senha, Aux);
            Result := AdrStr + Chr($C3) + Aux;
          end;
        Chr($C3):
          begin
            Senha := StrToIntDef(Copy(ProtData, 1, Pos(';', ProtData) - 1), -1);
            IdTicket := frmSicsMain.GetIdTicket(Senha);

            if IdTicket <> -1 then
            begin
              DesRegistraTicketAgendamentosFilas(IdTicket);

              Aux := Copy(ProtData, Pos(';', ProtData) + 1);
              { NF := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]); }
              Aux := Copy(Aux, 5);

              Aux2 := '';
              for I := 1 to Length(Aux) do
              begin
                if Aux[I] = TAB then
                begin
                  Fx := StrToIntDef('$' + Copy(Aux2, 1, 4), -1);
                  Aux2 := Copy(Aux2, 5, Length(Aux2) - 4);

                  if Length(Aux2) = 4 then
                  begin
                    hh := StrToInt(Copy(Aux2, 1, 2));
                    nn := StrToInt(Copy(Aux2, 3, 2));
                    DataHora := Today + EncodeTime(hh, nn, 0, 0);
                  end
                  else if Length(Aux2) = 12 then
                  begin
                    dd := StrToInt(Copy(Aux2, 1, 2));
                    mm := StrToInt(Copy(Aux2, 3, 2));
                    yy := StrToInt(Copy(Aux2, 5, 4));
                    hh := StrToInt(Copy(Aux2, 9, 2));
                    nn := StrToInt(Copy(Aux2, 11, 2));
                    DataHora := EncodeDate(dd, mm, yy) + EncodeTime(hh, nn, 0, 0);
                  end
                  else
                    DataHora := 0;

                  frmSicsMain.InsereAgendamentoFila(IdTicket, Fx, DataHora);

                  Aux2 := '';
                end
                else if Aux[I] <> ETX then
                  Aux2 := Aux2 + Aux[I];
              end;

              frmSicsMain.BroadcastAgendamentosPorFila(Senha);

              Result := AdrStr + ACK;
            end;
          end;
        Chr($C4):
          begin
            PA := StrToInt('$' + ProtData);
            frmSicsMain.GetSendPrioridadesAtendimentoPAText(PA, Aux);
            Result := AdrStr + Chr($C5) + Aux;
          end;
        Chr($C7):
          begin
            frmSicsMain.GetSendFilasComRange(Aux);
            Result := AdrStr + Chr($C8) + Aux;
          end;
        Chr($C9):
          begin
            Senha := StrToInt(ProtData);
            frmSicsMain.GetStatusSenha(Senha, Aux);
            Result := AdrStr + Chr($CA) + Aux;
          end;
        Chr($CB):
          begin // Atualizar Dados Adicionais de uma senha <DATA>=<PWD><TAB><DADOS_ADIC>
            SenhaStr := Copy(ProtData, 1, Pos(TAB, ProtData) - 1);
            Aux := Copy(ProtData, Length(SenhaStr) + 1);

            if not TryStrToInt(SenhaStr, Senha) then
            begin
              Result := AdrStr + Chr($CC) + SenhaStr + TAB + '0' + 'Senha inválida';
              Exit;
            end;

            Id := frmSicsMain.GetIdTicketIfPwdExists(Senha);

            if Id < 0 then
            begin
              Result := AdrStr + Chr($CC) + SenhaStr + TAB + '0' + 'Senha inexistente';
              Exit;
            end;

            JSONObj := TJSONObject(TJSONObject.ParseJSONValue(Aux));
            try
              if not Assigned(JSONObj) then
              begin
                Result := AdrStr + Chr($CC) + SenhaStr + TAB + '0' + 'Formato de dados inválido';
                Exit;
              end;

              if dmSicsMain.SalvarDadosAdicionais(Id, JSONObj) then
                Result := AdrStr + Chr($CC) + SenhaStr + TAB + '1'
              else
                Result := AdrStr + Chr($CC) + SenhaStr + TAB + '0';
            finally
              JSONObj.Free;
            end;
          end; { case $CB }
        Chr($CD):
          begin // Obter Dados Adicionais de uma senha
            SenhaStr := ProtData;

            if not TryStrToInt(SenhaStr, Senha) then
            begin
              Result := AdrStr + Chr($CE) + SenhaStr + TAB + '0' + 'Senha inválida';
              Exit;
            end;

            Id := frmSicsMain.GetIdTicketIfPwdExists(Senha);
            if Id < 0 then
            begin
              Result := AdrStr + Chr($CE) + SenhaStr + TAB + '0' + 'Senha inexistente';
              Exit;
            end;

            JSONObj := dmSicsMain.GetDadosAdicionais(Id);
            try
              if Assigned(JSONObj) then
                Result := AdrStr + Chr($CE) + SenhaStr + TAB + '2' + JSONObj.ToJSON
              else
                Result := AdrStr + Chr($CE) + SenhaStr + TAB + '1';
            finally
              if Assigned(JSONObj) then
                JSONObj.Free;
            end;
          end; { case $CD }

        Chr($CF):
          begin // Obter Paineis do Tipo TV //LM
            frmSicsMain.GetPaineisTV(Aux);
            Result := AdrStr + Chr($D0) + Aux;
          end; { case $CF }

        Chr($B1):
          begin
            SeparaStrings(ProtData, ';', Aux, Aux2);
            frmSicsMain.Reimprime(StrToInt(Aux), StrToInt('$' + Aux2));
            Result := AdrStr + ACK;
          end; { case 87 }
        Chr($88):
          begin
            frmSicsMain.GetSendCanaisNamesText(StrToInt('$' + ProtData), Aux);
            Result := AdrStr + Chr($89) + Aux;
          end; { case 88 }
        Chr($89):
          begin
            Beep;
            // alimenta apenas o cdsCanaisCapturados com as frequencias, depois chama dois metodos
            // para sincronizar este cds com o cds dos canais mesmo (com as frequencias, ids e nomes)

            // BAH retirado bug #173
            { with dmSicsCanaisTV.cdsCanaisCapturados do
              begin
              if not Active then
              CreateDataSet
              else
              EmptyDataSet;
              end;

              Aux := Copy(ProtData, 5, Length(ProtData) - 4);
              // despreza os 4 primeiros caracteres (IdTV) pois não importa já que este comando ao ser recebido pelo servidor serve apenas para cadastramento dos canais capturados
              Aux2  := '';
              for I := 1 to Length(Aux) do
              begin
              if Aux[I] = TAB then
              begin
              SeparaStrings(Aux2, ';', Aux2, FREQ);
              FREQ := Copy(FREQ, 1, Length(FREQ) - 1); // cortar ultimo caracter = canal padrao

              with dmSicsCanaisTV.cdsCanaisCapturados do
              begin
              Append;
              FieldByName('ID').AsInteger        := StrToInt('$' + Aux2);
              FieldByName('FREQUENCIA').AsString := FREQ;
              Post;
              end;

              Aux2 := '';
              end
              else if Aux[I] <> ETX then
              Aux2 := Aux2 + Aux[I];
              end;

              dmSicsCanaisTV.AtualizarCdsCanaisTV;
              dmSicsCanaisTV.FinalizarCapturarCanais; }
          end; { case 89 }
        Chr($8A):
          begin
            IdTV := StrToInt('$' + Copy(ProtData, 1, 4));
            IdCanal := StrToInt('$' + Copy(ProtData, 5, 4));

            dmSicsMain.cdsTVsCanais.Refresh;

            frmSicsMain.AjustaCanalDasTVs(IdTV, IdCanal);

            Result := AdrStr + ACK;
          end; { case 8A }
        Chr($8B):
          begin
            IdTV := StrToInt('$' + Copy(ProtData, 1, 4));
            IdCanal := StrToInt('$' + Copy(ProtData, 5, 4));
            dmSicsMain.DefinirCanalPadraoTV(IdTV, IdCanal);
            dmSicsMain.cdsTVsCanais.Refresh;
          end; { case 8B }
        Chr($8C), Chr($8D), Chr($8F):
          begin
            Result := '0000' + Chr($B2) + SolicitarParametrosModuloSICS(ProtData);
          end;
        Chr($B3):
          begin
            frmSicsMain.CarregarConexoes(Aux);
            Result := AdrStr + Chr($B7) + Aux;
          end; { case B3 }
        Chr($B5):
          begin
            // BAH retirado #173
            { IdPainel := StrToInt('$' + Copy(ProtData, 1, 4));

              vdmSicsCanaisTV := TdmSicsCanaisTV.Create(Application);
              try
              dmSicsCanaisTV.IniciarCapturaCanais(IdPainel);
              finally
              FreeAndNil(vdmSicsCanaisTV);
              end; }
          end; { case B5 }
        Chr($B6):
          begin
            // BAH retirado correção bug #173
            { dmSicsMain.cdsTVsCanais.Refresh;

              vdmSicsTVCanais := TdmSicsTvsCanais.Create(Application);
              try
              with vdmSicsTVCanais.cdsTVs do
              begin
              First;
              while not eof do
              begin
              frmSicsMain.EnviaCanaisPermissionados(FieldByName('ID').AsInteger);
              Next;
              end;
              end;
              finally
              FreeAndNil(vdmSicsTVCanais);
              end; }
          end; { case B6 }
        Chr($D1): begin
                    PA     := StrToInt('$'+s[2]+s[3]);
                    frmSicsMain.GetSendPIsPossiveis(PA, Aux);
                    Result := AdrStr + Chr($D2) + Aux;
                  end;
        Chr($D3):
          begin
            LProtDataSeparado := SplitString(ProtData, TAB);
            // Login, Senha, Posição
            Result := AdrStr + Chr($D4) + frmSicsMain.AtenderChamadoCallcenter
              (LProtDataSeparado[Integer(TDadosAtenderChamado.dacLogin)],
              LProtDataSeparado[Integer(TDadosAtenderChamado.dacSenha)],
              LProtDataSeparado[Integer(TDadosAtenderChamado.dacPosicao)]);
          end; { case D3 }

        Chr($D5):
          begin
            // Posição, Fila, ID, Nome
            try
              LProtDataSeparado := SplitString(ProtData, TAB);

              LTicketCallCenter := frmSicsMain.InserirSenhaCallcenter
                (StrToInt(LProtDataSeparado
                [Integer(TDadosSolicitarChamado.dscFila)]),
                StrToInt(LProtDataSeparado
                [Integer(TDadosSolicitarChamado.dscPosicao)]));

              frmSicsMain.DefinirNomeParaSenha
                (StrToInt(LProtDataSeparado
                [Integer(TDadosSolicitarChamado.dscPosicao)]),
                LProtDataSeparado[Integer(TDadosSolicitarChamado.dscNome)]);

              frmSicsMain.SetIdClienteSenha(LTicketCallCenter, StrToInt(LProtDataSeparado[Integer(TDadosSolicitarChamado.dscID)]));

              ProtData := LProtDataSeparado
                [Integer(TDadosSolicitarChamado.dscPosicao)] + TAB +
                LProtDataSeparado[Integer(TDadosSolicitarChamado.dscFila)] + TAB
                + LProtDataSeparado[Integer(TDadosSolicitarChamado.dscID)] + TAB
                + LProtDataSeparado[Integer(TDadosSolicitarChamado.dscNome)];

              frmSicsMain.EnviaParaTodosOsClients(frmSicsMain.ServerSocket1.Socket, '0000' + Chr($D9) + ProtData);

              frmSicsMain.EnviaParaTodosOsClients(frmSicsMain.TGSServerSocket.Socket, '0000' + Chr($D9) + ProtData);

              Result := AdrStr + Chr($D6) + 'T';
            except
              Result := AdrStr + Chr($D6) + 'F';
            end;
          end; { case D5 }

        Chr($D7):
          begin
            // Nome,Senha
            try
              LProtDataSeparado := SplitString(ProtData, TAB);
              Result := AdrStr + Chr($D8) + frmSicsMain.AlterarSenhaCliente
                (LProtDataSeparado[Integer(TDadosAlterarSenha.dasLogin)],
                LProtDataSeparado[Integer(TDadosAlterarSenha.dasSenhaA)],
                LProtDataSeparado[Integer(TDadosAlterarSenha.dasSenhaN)]);
            except
              Result := AdrStr + Chr($D8) + 'F';
            end;
          end; { case D7 }

        Chr($DA):
          begin
            vIdPA     := GetIDModuloPorAdr; //ID_PA
            vIdModulo := GetIdModulo(dmSicsMain.connOnLine, vIdPA);
            frmSicsMain.GetSendFilasNamesText(vIdModulo, Aux);
            Result    := TAspEncode.AspIntToHex(vIdPA, 4) + Chr($DB) + Aux;
          end; { case DA }

        Chr($DC):
          begin
            Result := AdrStr + Chr($DD) + frmSicsMain.PessoasNasFilasEsperaPA(Adr);
          end; { case DC }

        Chr($4B):
          begin
            Result := AdrStr + Chr($DD) + frmSicsMain.PessoasNasFilasEsperaPA(Adr, True);
          end; { case DC }

        Chr($DE):
          begin
            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Entrei no Comando %s | Horario Inicial: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));

            LFila       := StrToInt('$' + Copy(ProtData, 1, 4));
            LTotem      := StrToInt('$' + Copy(ProtData, 5, 4));

            LAtribuiTag := Copy(ProtData, 9);
            Senha   := -1;

            frmSicsMain.GeraSenhaEImprime(LFila, LTotem, LAtribuiTag, Senha, IniTime);

            with FormatSettings.Invariant do
              Aux := ShortDateFormat + ' ' + LongTimeFormat;

            Result := AdrStr + Chr($DF) + IntToHex(LFila, 4) + IntToStr(Senha) + TAB + FormatDateTime(Aux, IniTime);

            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Sai do Comando %s | Horario Final: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));
          end; { case Chr($DE) }

        Chr($E0):
          begin
            //SeparaStrings(ProtData, TAB, LLoginCliente, LSenhaCliente);
            //Result := AdrStr + Chr($E1) + frmSicsMain.VerificaLoginCliente(LLoginCliente, LSenhaCliente);

            LProtDataSeparado := SplitString(ProtData, TAB);
            Result := AdrStr + Chr($E1) + frmSicsMain.VerificaLoginCliente
              (LProtDataSeparado[Integer(TDadosAtendenteLogin.dalLogin)],
               LProtDataSeparado[Integer(TDadosAtendenteLogin.dalSenha)],
               LProtDataSeparado[Integer(TDadosAtendenteLogin.dalPosicao)]);
          end; { case E0 }

        Chr($E2):
          begin
            SeparaStrings(ProtData, TAB, LIDCliente, LPosicaoCliente);
            Result := AdrStr + Chr($E3) + frmSicsMain.LogoutCliente(StrToInt(LIDCliente), LPosicaoCliente);
          end; { case E2 }

        Chr($E4):
          begin
            Result := AdrStr + Chr($E5) + frmSicsMain.GetSendListaDeTotens;
          end; { case E4 }

        Chr($E6):
          begin
            AuxI   := StrToIntDef('$' + ProtData,0);
            Result := AdrStr + Chr($E7) + frmSicsMain.GetSendListaDeBotoesPorTotem(AuxI);
          end; { case E6 }

        Chr($E8):
          begin
            var LQTDEPAProdutiva  :integer;
            var LQTDEPessoasEspera:integer;
            var LIDTEE            :integer;
            NF     := StrToIntDef('$' + ProtData,0);
            if not vgParametrosModulo.ParametrosTEE.InverterEnvioDeTEE_TME then  //LM Provisório a pedido da patricia Fleury - Luciano aprovou provisoriamente
              Result := AdrStr + Chr($E9) + FormatDateTime('hh:nn:ss', frmSicsMain.CalculaTEE(NF,LQTDEPAProdutiva,LQTDEPessoasEspera,LIDTEE)) + ';' + FormatDateTime('hh:nn:ss', frmSicsMain.GetTempoEsperaUltimosN(NF))
            else
              Result := AdrStr + Chr($E9) + FormatDateTime('hh:nn:ss', frmSicsMain.GetTempoEsperaUltimosN(NF)) + ';' + FormatDateTime('hh:nn:ss', frmSicsMain.CalculaTEE(NF,LQTDEPAProdutiva,LQTDEPessoasEspera,LIDTEE));
            Result := Result + ';' + LQTDEPAProdutiva.ToString + ';' + LQTDEPessoasEspera.ToString + ';' + LIDTEE.ToString;
          end; { case E8 }

        Chr($A8):
          begin
            //LM
            (*
            LProtDataSeparado := SplitString(ProtData, TAB);

            frmSicsMain.AtualizaStatusTV(
               LProtDataSeparado[Integer(TDadosStatusTV.dstIP)],
               LProtDataSeparado[Integer(TDadosStatusTV.dstTunerPresent)],
               LProtDataSeparado[Integer(TDadosStatusTV.dstVideoState)],
               LProtDataSeparado[Integer(TDadosStatusTV.dstVideoError)],
               LProtDataSeparado[Integer(TDadosStatusTV.dstCurrentUI)],
               LProtDataSeparado[Integer(TDadosStatusTV.dstLegenda)]);
            *)

          end; { case A7 }

        Chr($EC):
          begin
            vIdModulo := GetIDModuloPorAdr;
            Result    := TAspEncode.AspIntToHex(vIdModulo, 4) + Chr($ED) + frmSicsMain.GetNomeFilas(vIdModulo);
          end;

        Chr($EE):
          begin
            Result    := AdrStr + Chr($EF) + frmSicsMain.GetTempoEsperaUltimosN;
          end; { case EE }


        Chr($F0):
          begin
            Result    := AdrStr + Chr($F1) + frmSicsMain.CalculaTEE;
          end; { case F0 }

        Chr($F2):
          begin
            Result    := AdrStr + Chr($F3) + frmSicsMain.GetTMAFilas;
          end; { case F2 }

        Chr($F3):
          begin
            frmSicsMain.GetGrupoFilas(Aux);
            Result := AdrStr + Chr($F4) + Aux;
          end; { case F3 }

        Chr($F5):
          begin
            frmSicsMain.GetCategoriaFilas(Aux);
            Result := AdrStr + Chr($F6) + Aux;
          end; { case F5 }

        Chr($F7):
          begin
            var LManterCabecalho  : boolean;
            var LManterRodape     : boolean;
            var LIdTotem          : integer;
            var LMensagem         : string;
            var LTipoDaImpressora : TTipoDeImpressora;
            var LRodapeImpressao  : string;
            var s1, s2            : string;

            LManterCabecalho := ((Length(ProtData) > 0) and (ProtData[1] = 'S'));
            LManterRodape    := ((Length(ProtData) > 1) and (ProtData[2] = 'S'));

            if length(ProtData) >= 6 then
              LIdTotem := strtoint('$' + Copy(ProtData, 3, 4))
            else
              LIdTotem := 0;

            LMensagem := Copy(ProtData, 7);

            LTipoDaImpressora := frmSicsMain.vlTotens[LIdTotem].TipoImpressora;

            if LTipoDaImpressora = tiFujitsu then
            begin
              frmSicsMain.InicializaImpressoraFujitsu(LIdTotem);
              Delay(80);
            end
            else if LTipoDaImpressora = tiSeiko then
            begin
              frmSicsMain.InicializaImpressoraSeiko(LIdTotem);
              Delay(80);
            end
            else if LTipoDaImpressora = tiCustom then
            begin
              frmSicsMain.InicializaImpressoraCustom(LIdTotem);
              Delay(80);
            end;

            s1 := '';

            if frmSicsMain.vlTotens[LIdTotem].Opcoes.CorteParcialAoFinal then
              s1 := s1 + '{{Quebra de Linha}}';

            if LManterCabecalho then
              s1 := s1 + frmSicsMain.LoadCabecalhoTicket(LIdTotem);

            s1 := s1 + LMensagem;

            if LManterRodape then
            begin
              NGetPrinterMsg(LIdTotem, LRodapeImpressao);

              if LRodapeImpressao <> '' then
                s1 := s1 + '{{Liga Condensado}}' + LRodapeImpressao + '{{Desliga Condensado}}{{Quebra de Linha}}{{Quebra de Linha}}';
            end;

            if frmSicsMain.vlTotens[LIdTotem].Opcoes.CorteParcialAoFinal then
              s1 := s1 + '{{Corte Parcial}}'
            else
              s1 := s1 + '{{Corte Total}}';

            ConverteProtocoloImpressora(s2, s1, LTipoDaImpressora);

            if frmSicsMain.Imprime(LIdTotem, s2) then
              Result := AdrStr + Chr($F8) + '1'
            else
              Result := AdrStr + Chr($F8) + '0';
          end; { case F7 }

        Chr($F9):
          begin // Gravar resposta da pesquisa de atendimento
            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Entrei no Comando %s | Horario Inicial: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));
            JSONObj := TJSONObject(TJSONObject.ParseJSONValue(ProtData));
            if frmSicsMain.GravaRespostaPesquisaSatisfacao(JSONObj) then
            begin
              Result    := AdrStr + Chr($F8) + '1';
            end
            else
            begin
              Result    := AdrStr + Chr($F8) + '0';
            end;
            TfrmDebugParameters.Debugar (tbProtocoloSics, Format('Sai do Comando %s | Horario Final: %s',[TAspEncode.AspIntToHex(Ord(Comando), 4), DateTimeToStr(Now)]));
          end; { case $F9 }

        Chr($FA):
          begin // Busca resposta da pesquisa de atendimento por prontuario e fluxo
            TLog.MyLog(Format('Entrei no Comando | Hexa: %s | Str: %s.', [Comando, TAspEncode.AspIntToHex(Ord(Comando), 4), Comando]), nil);

            JSONObj := TJSONObject(TJSONObject.ParseJSONValue(ProtData));
            Result    := AdrStr + Chr($FB) + frmSicsMain.BuscaRespostaPesquisaSatisfacaoFluxo(JSONObj).ToJson;

            TLog.MyLog(Format('Retorno: %s .', [Result]), nil);
            TLog.MyLog(Format('Sai do Comando | Hexa: %s | Str: %s.', [Comando, TAspEncode.AspIntToHex(Ord(Comando), 4), Comando]), nil);
          end;

      else
        begin
          Result := AdrStr + Chr($33);
          TLog.MyLog(Format('Comando inválido %s | Hexa: %s | Str: %s.', [Comando, TAspEncode.AspIntToHex(Ord(Comando), 4), Comando]), nil);
        end;
      end; { case }
{$ENDREGION}
    except
      on E: Exception do
      begin
        // *********************************************************************************************************
        // GOT 05/03/2015 16:45
        // Se o erro for relacionado a dll dbexpint.dll a conexão será redefinida. Rotina em teste.
        if Pos('in module ''dbexpint.dll''', E.Message) > 0 then
        begin
          try
            Result := '';
            MyLogException(Exception.Create('KB DBEXPINT - Erro ao decifrar endereço no protocolo TCP/IP: "' + s + '" / ' + E.Message));
            dmSicsMain.connOnLine.Close;
            dmSicsMain.connOnLine.Open;
          except
            on E2: Exception do
            begin
              Result := '';
              MyLogException(Exception.Create('KB DBEXPINT - Erro ao reabrir conexão - ' + E2.Message));
            end;
          end;
        end
        // *********************************************************************************************************
        else
        begin
          Result := '';
          MyLogException(Exception.Create('Erro ao decifrar protocolo TCP/IP (' + inttostr(length(s)) + ' caracteres): "' + s + '", LocalPort: ' + inttostr(DebugLocalPort) + ', RemoteIP: ' + DebugRemoteIP + ' / ' + E.Message));
        end;
      end;
    end { if s <> '' }
  else
    Result := '';

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu   DecifraProtocolo (' + inttostr(length(s)) + ' caracteres): ' + s);
end; { proc DecifraProtocolo }

{ Protocolo TCP/IP - Retrocompatibilidade
  {
  {  <STX> <ADR> <CMD> <DATA> <ETX>
  {
  { 	<STX> = 1 Byte = 02h
  {
  { 	<ADR> = string de 2 caracteres representando o endereco em hexadecimal ('00' = <30h><30h> a 'FF' = <46h><46h>)
  {
  {   <CMD> = 1 byte
  {    20h = Chamar proxima senha
  {    21h = Chamar senha especifica
  {    22h = Rechamar ultima senha
  {    23h = RE: Chamou senha especifica (contendo o tipo da senha)
  {    24h = RE: Nao chamou nenhuma senha
  {    25h = Finalizar atendimento
  {    29h = Solicitar situacao do atendimento por PAs
  {    30h = Chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)
  {    33h = RE: Comando nao suportado pela versao
  {    36h = Solicitar numero de senhas em espera
  {    38h = Chamar proxima senha + Horario de retirada da senha
  {    39h = RE: Senha chamada + Horario de retirada da senha + Tipo Senha
  {    3Bh = RE: Quantidade de senhas em espera no SICS
  {    3Ch = RE: Situacao do atendimento, por PAs
  {    41h = Solicita Lista de motivos de pausas configurados para uma PA
  {    42h = RE: Tabela de Motivos de Pausa
  {    54h = Fazer login de atendente, com opção de forçar login (sem checagem da senha do atendente)
  {    5Dh = Fazer logout de qualquer atendente que esteja na PA
  {    B4h = RE: Login efetuado ou acesso negado
  {    D1h = Solicitar Alarmes Ativos por PAs
  {    D2h = RE: Alarmes Ativos por PAs
  {
  {	  <DATA> = N Bytes:
  {
  {   Se CMD = 21h entao
  {     <DATA> = <PWD>
  {				onde: <PWD> = string de tamanho variável com a senha chamada (ex: ‘345’)
  {
  {   Se CMD = 23h entao
  {     <DATA> = <PWD> <PV> <TIPOFILA> <PV> <DADOS_ADIC>
  {				onde: <PWD>        = string de tamanho variável com a senha chamada (ex: ‘345’)
  {             <PV>         = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {             <TIPOFILA>   = string de tamanho variável com o Tipo da Fila da senha (ex: 'ECG')
  {             <DADOS_ADIC> = string de tamanho variável contendo um JSON com os dados adicionais a serem atualizados naquela senha
  {
  {   Se CMD = 24h entao
  {     <DATA> = <REA> <PSWD>
  {      onde: <REA> = 1 byte = razão pela qual não chamou nenhuma senha, que pode ser:
  {                             '0' = 31h = nao ha mais senhas a serem chamadas
  {                             'N' = 4Eh = senha solicitada nao se encontra em nenhuma fila
  {                             'P' = 50h = senha solicitada se encontra numa fila nao inclusa nas prioridades de atendimento do ADR
  {                             'L' = 4Ch = nao tem atendente logado na PA
  {                             'M' = 4Dh = número de atendimentos ultrapassa magazine
  {                             'I' = 49h = senha inválida (fora do range)
  {                             'p' = 70h = PA está em pausa
  {                             'B' = 4Fh = PA não pode chamar outra senha pois está no Buffer de saída aguardando para chamar uma senha no painel
  {            <PWD> = string = senha solicitada (ex: ‘345’) (no caso de <REA> = 00h, <PSWD> = '')
  {
  {   Se CMD = 28h então
  {     <DATA> = <MP><Fx>
  {				onde: <MP> = string 4 caracteres representando:
  {                       a. o id do motivo de pausa que está iniciando, ou
  {                       b. '----' caso seja para finalizar a pausa
  {             <Fx> = string 4 caracteres representando o id da fila que será redirecionada a senha em atendimento caso seja para iniciar a pausa
  {
  {   Se CMD = 29h entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = 30h entao
  {     <DATA> = <PWD>
  {				onde: <PWD> = string de tamanho variável com a senha chamada (ex: ‘345’)
  {
  {   Se CMD = 38h entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = 36h entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = 39h entao
  {     <DATA> = <PWD> <TIMEx> <PV> <TIPOFILA> <PV> <DADOS_ADIC>
  {				onde: <PWD>      = string de tamanho variável com a senha chamada (ex: ‘345’)
  {				      <TIMEx>    = string de 14 caracteres = 'ddmmyyyyhhnnss'
  {             <PV>       = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {             <TIPOFILA> = string de tamanho variável com o Tipo da Fila da senha (ex: 'ECG')
  {             <DADOS_ADIC> = string de tamanho variável contendo um JSON com os dados adicionais a serem atualizados naquela senha
  {
  {   Se CMD = 3Bh entao
  {     <DATA> = <NATD> <PA1> <NPSWD1> <TAB> <PA2> <NPSWD2> <TAB> ... <PAn> <NPSWDn> <TAB>
  {	 	 		  onde: <NATD>  = string de 4 caracteres representando o numero de PAs em hexadecimal
  {	 	 			      <PAx>   = string de 4 caracteres representando a x-ésima PA em hexadecimal
  {	 	 			      <NPWDx> = string de 4 caracteres representando, em hexadecimal, o numero de senhas em espera para a x-ésima PA, de acordo com suas prioridades de atendimento
  {	 	 			      <TAB>   = 1 caracter = tabulacao = ASCII 09h
  {
  {   Se CMD = 3Ch entao
  {     <DATA> = <STAT> <PV> <ATD> <PV> <SENHA> <PV> <MP>
  {	 	 			onde: <STAT> = string de tamanho variavel com um dos seguintes status:
  {	 	                        "Deslogado" (sem atendente logado),
  {	 	                        "Disponivel" (com atendente logado aguardando cliente),
  {	 	                        "Em atendimento" (com atendente logado e atendendo uma senha) ou
  {	 	                        "Em pausa" (com atendente logado e em pausa)
  {	 	            <ATD> = string de tamanho variavel com o login do atendente logado na PA (se houver), ou
  {	 	                    em branco caso o status seja "Deslogado"
  {	 	            <SENHA> = string de tamanho variavel com a senha em atendimento na PA caso o status seja
  {	 	                      "Em atendimento", ou em branco nos demais status
  {	 	            <MP> = string de tamanho variável com o motivo da pausa, caso o status seja "Em pausa",
  {	 	                   ou em branco nos demais status
  {	 	            <PV> = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {
  {   Se CMD = 41h entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = 42h entao
  {     <DATA> = <NMP> <MP1> <NOME1> <TAB> ... <MPn> <NOMEn> <TAB>
  {	 	 			onde: <NMP>   = string de 4 caracteres representando o numero de Motivos de Pausa em hexadecimal
  {  	            <MPx>   = string de 4 caracteres representando o ID do x-ésimo Motivo de Pausa em hexadecimal
  {	 	 			      <NOMEx> = string de tamanho variavel com o nome do x-ésimo Motivo de Pausa
  {	 	 			      <TAB>   = 1 caracter = tabulacao = ASCII 09h
  {
  {   Se CMD = 54h entao
  {     <DATA> = <FORCAR> <LOGIN>
  {         onde: <FORCAR> = 1 byte = forcar login caso haja outro atendente logado ou em atendimento ('0' = Não forçar, '1' = Forçar)
  {               <LOGIN>  = N bytes = login do atendente cadastrado no SICS
  {
  {   Se CMD = 5Dh entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = B4h entao
  {     <DATA> = <RES> <MOT> <PV> <TIMEOUT>
  {         onde: <RES> = 1 byte = resultado do login, que pode ser:
  {                                   '0' = não logou
  {                                   '1' = logou com sucesso
  {               <MOT> = string de N bytes representando os motivos de não ter sucesso no login, separados por vírgula
  {                                   0 = login efetuado com sucesso
  {                                   1 = erro diverso, não listado
  {                                   2 = outro atendente já está logado nesta PA
  {                                   3 = este atendente já está logado em outra PA
  {                                   4 = este atendente não está cadastrado no SICS
  {                                   5 = este atendente está desativado no SICS
  {                                   6 = este atendente não tem perfil para logar nesta PA
  {
  {   Se CMD = D1h entao
  {     <DATA> = '' (nil)
  {
  {   Se CMD = D2h entao
  {     <DATA> = <QTD> <NOME1> <PV> <NIV1> <PV> <COR1> <PV> <MSG1> <TAB> ... <NOMEn> <PV> <NIVn> <PV> <CORn> <PV> <MSGn> <TAB>
  {  	     onde:  <QTD> = string de 4 caracteres representando a quantidade de alarmes ativos em hexadecimal
  {  	            <NOMEx> = string de tamanho variável com o nome do Indicador de Performance sobre o qual se refere o alarme
  {  	            <NIVx> = string de tamanho variável com o nome do nível de alarme (Ex: Atenção, Crítico,etc)
  {  	            <CORx> = string de 6 caracteres com a cor deste alarme, no formato RRGGBB, sendo que cada 2 caracteres formam a intensidade da cor
  {  	                     (Red, Green e Blue, respectivamente), em escala hexadecimal de 00 a FF.
  {  	            <MSGx> = string de tamanho variável com a mensagem do alarme
  {  	            <TAB> = 1 caracter = tabulacao = ASCII 0x0009
  {  	            <PV> = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {
  {   Se CMD = CDh então  //Obter Dados Adicionais de uma senha
  {     <DATA> = <PWD>
  {     onde: <PWD> = string de tamanho variável contendo a senha ao qual se deseja obter os dados adicionais
  {
  {   Se CMD = CEh então  //RE: Dados adicionais de uma senha
  {     <DATA> = <PWD> <PV> <STATUS> <PV> <MSG>
  {     onde: <PWD>    = string de tamanho variável ao qual pertencem os dados adicionais
  {	 	        <PV>     = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {           <STATUS> = 1 caracter, podendo ser:
  {                        "2" - dados adicionais recuperados com sucesso
  {                        "1" - nenhum dado adicional existente para a senha
  {                        "0" - não foi possível recuperar os dados adicionais
  {	 	        <PV>     = 1 caracter = ponto-e-virgula = ASCII 0x003B
  {           <MSG>    = string de tamanho varíavel, preenchida quando STATUS = "2" ou "0", sendo:
  {                             STATUS=2, MSG = json com os dados adicionais da senha solicitada
  {                             STATUS=0, MSG = possível mensagem de erro justificando porque os dados não puderam ser recuperados
  {
  {
  {   Senao <DATA> = ‘’ (nil)
  {
  { <ETX> = 1Byte = 03h
}

function DecifraProtocoloRetrocompatibilidade(s: string): string;
var
  aux, AtdLogin, ProtData : string;
  Senha, PA               : integer;
  IniTime                 : TDateTime;
  MotivoPausa             : integer;
  Fila                    : integer;
  Forcar                  : Boolean;
  TipoSenha               : String;
  MotivoErro              : String;
  SenhaStr                : String;
  LID                     : Integer;
  LJSONObj                : TJSONObject;
begin
  if ((length(s) > 4) and (s[1] = STX) and (s[length(s)] = ETX)) then
  begin
    ProtData := Copy(s,5,length(s)-5);

    case s[4] of
       Chr($20) : begin
                     Senha := frmSicsMain.Proximo(StrToInt('$'+s[2]+s[3]),IniTime);
                     case senha of
                        -1 : Result := STX + s[2] + s[3] + Chr($24) + '0' + ETX; { Nao chamou ninguem }
                        -2 : Result := STX + s[2] + s[3] + Chr($24) + 'B' + ETX; { Esta na fila para chamar alguem }
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        -7 : Result := STX + s[2] + s[3] + Chr($24) + 'p' + ETX;
                        else
                        begin
                          if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                          begin
                            Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ETX;  { Chamou uma senha}
                          end
                          else
                          begin
                            TipoSenha := NGetFilaName(NGetFilaFromRange(Senha));
                            Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX;  { Chamou uma senha}
                          end;
                        end;
                     end;  { case }
                  end;  { case Chr($20) }

       Chr($21) : begin
                     aux := Copy(s,5,length(s)-5);  //Faz essa checagem porque se a senha for ''
                     if aux = '' then               //ele tem que primeiro verificar
                       senha := -1                  //se tem Atd logado na PA (dentro da "ChamaEspecifica).
                     else                           //Se nao tiver, vai devolver -5 e, se tiver,
                       senha := strtoint(aux);      //vai devolver -6 (senha invalida, por isso o senha := -1)

                     senha := frmSicsMain.ChamaEspecifica(StrToInt('$'+s[2]+s[3]),senha, IniTime);

                     { -6  -> senha inválida (out of range)                                         }
                     { -5  -> não tem atendente logado na PA                                        }
                     { -4  -> não chamou ninguém porque numero de atendimentos ultrapassa magazine  }
                     { -3  -> a senha está numa fila não contida nas prioridades de atendimento     }
                     { -2  -> o atendente está aguardando para ser anunciado na painel              }
                     { -1  -> a senha não está em nenhuma fila                                      }
                     case senha of
                        -1 : begin
                               if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                                 Result := STX + s[2] + s[3] + Chr($50) + Copy(s,5,length(s)-5) + ETX
                               else
                                 Result := STX + s[2] + s[3] + Chr($24) + 'N' + ETX;
                             end;
                        -2 : Result := STX + s[2] + s[3] + Chr($24) + 'B' + ETX; { Esta na fila para chamar alguem }
                        -3 : begin
                               if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                                 Result := STX + s[2] + s[3] + Chr($51) + Copy(s,5,length(s)-5) + ETX
                               else
                                 Result := STX + s[2] + s[3] + Chr($24) + 'P' + ETX;
                             end;
                        -4 : Result := STX + s[2] + s[3] + Chr($24) + 'M' + ETX;
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        -6 : Result := STX + s[2] + s[3] + Chr($24) + 'I' + ETX;
                        else  { Chamou uma senha }
                        begin
                          if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                          begin
                            Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ETX;  { Chamou uma senha}
                          end
                          else
                          begin
                            TipoSenha := NGetFilaName(NGetFilaFromRange(Senha));
                            if IniTime <> 0 then
                              Result := STX + s[2] + s[3] + Chr($39) + inttostr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX
                            else
                              Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX;
                          end;
                        end;
                     end;  { case }
                  end;  { case Chr($21) }

       Chr($22) : begin
                     senha := frmSicsMain.Rechama(StrToInt('$'+s[2]+s[3]));
                     case senha of
                        -1 : Result := STX + s[2] + s[3] + Chr($24) + '0' + ETX; { Nao chamou ninguem }
                        -2 : Result := STX + s[2] + s[3] + Chr($24) + 'B' + ETX; { Esta na fila para chamar alguem }
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        else
                        begin
                          if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                          begin
                            Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ETX;  { Chamou uma senha }
                          end
                          else
                          begin
                            TipoSenha := NGetFilaName(NGetFilaFromRange(Senha));
                            Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX;  { Chamou uma senha }
                          end;
                        end;
                     end;  { case }
                  end;  { case Chr($22) }

       Chr($25) : begin
                     senha := frmSicsMain.Finaliza (StrToInt('$'+s[2]+s[3]));
                     case senha of
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        else Result := STX + s[2] + s[3] + Chr($24) + '0' + ETX; { Nao chamou ninguem }
                     end;  { case }
                  end;  { case Chr($25) }

       Chr($28) : begin
                    PA     := StrToInt('$'+s[2]+s[3]);
                    Result := EmptyStr;

                    if ProtData = '----' then
                    begin
                      if frmSicsMain.FinalizarPausa(PA) then
                        Result := 'ok';
                    end
                    else
                    begin
                      MotivoPausa := StrToInt('$' + Copy(ProtData, 1, 4));

                      //JLS - 05/02/2019 - Adicionei esta verificação através da função "CheckMotivoPausaPermitidoNaPA",
                      //                   que só deixa pausar uma PA se o motivo estiver permissionado para a mesma.
                      if (frmSicsMain.CheckMotivoPausaPermitidoNaPA(PA,MotivoPausa)) then
                      begin
                        SomenteRedirecionar := True;
                        Fila        := StrToInt('$' + Copy(ProtData, 5, 4));
                        frmSicsMain.Redireciona(PA, Fila);
                        if frmSicsMain.IniciarPausa(PA, MotivoPausa) then
                          Result := 'ok';
                        SomenteRedirecionar := False;
                      end;
                    end;

                    if Result = 'ok' then
                      Result := STX + s[2] + s[3] + Chr($B9) + '1' + ETX
                    else
                      Result := STX + s[2] + s[3] + Chr($B9) + '0' + ETX;
                  end; { case Chr($28) }

       Chr($29) : begin
                    PA     := StrToInt('$'+s[2]+s[3]);
                    frmSicsMain.GetSendOnePAStatus(PA,Aux);
                    Result := STX + s[2] + s[3] + Chr($3C) + Aux + ETX;
                  end;

       Chr($30) : begin
                     aux := Copy(s,5,length(s)-5);  //Faz essa checagem porque se a senha for ''
                     if aux = '' then               //ele tem que primeiro verificar
                       senha := -1                  //se tem Atd logado na PA (dentro da "ChamaEspecifica).
                     else                           //Se nao tiver, vai devolver -5 e, se tiver,
                       senha := strtoint(aux);      //vai devolver -6 (senha invalida, por isso o senha := -1)

                     var IdFila : integer;
                     var NomeFila : string;
                     senha := frmSicsMain.ForcaChamada   (StrToInt('$'+s[2]+s[3]), senha, IniTime, IdFila, NomeFila);

                     { -6  -> senha inválida (out of range)                                         }
                     { -5  -> não tem atendente logado na PA                                        }
                     { -4  -> não chamou ninguém porque numero de atendimentos ultrapassa magazine  }
                     { -3  -> a senha está numa fila não contida nas prioridades de atendimento     }
                     { -2  -> o atendente está aguardando para ser anunciado na painel              }
                     { -1  -> a senha não está em nenhuma fila                                      }
                     case senha of
                        -1 : Result := STX + s[2] + s[3] + Chr($24) + 'N' + ETX;
                        -2 : Result := STX + s[2] + s[3] + Chr($24) + 'B' + ETX;
                        -3 : Result := STX + s[2] + s[3] + Chr($24) + 'P' + ETX;
                        -4 : Result := STX + s[2] + s[3] + Chr($24) + 'M' + ETX;
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        -6 : Result := STX + s[2] + s[3] + Chr($24) + 'I' + ETX;
                        else  { Chamou uma senha }
                        begin
                          if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                          begin
                            if IniTime <> 0 then
                              Result := STX + s[2] + s[3] + Chr($39) + inttostr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime) + ETX
                            else
                              Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ETX;
                          end
                          else
                          begin
                            TipoSenha := NGetFilaName(NGetFilaFromRange(Senha));
                            if IniTime <> 0 then
                              Result := STX + s[2] + s[3] + Chr($39) + inttostr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX
                            else
                              Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX;
                          end;
                        end;
                     end;  { case }
                  end; { case Chr($30) }

       Chr($36) : begin
                    frmSicsMain.GetSendWaitingPswdsText(Aux);
                    Result := STX + s[2] + s[3] + Chr($3B) + Aux + ETX;
                  end;

       Chr($38) : begin
                     Senha := frmSicsMain.Proximo (StrToInt('$'+s[2]+s[3]), IniTime);
                     case senha of
                        -1 : Result := STX + s[2] + s[3] + Chr($24) + '0' + ETX; { Nao chamou ninguem }
                        -2 : Result := STX + s[2] + s[3] + Chr($24) + 'B' + ETX; { Esta na fila para chamar alguem }
                        -5 : Result := STX + s[2] + s[3] + Chr($24) + 'L' + ETX;
                        -7 : Result := STX + s[2] + s[3] + Chr($24) + 'p' + ETX;
                        else { Chamou uma senha }
                        begin
                           if vgParametrosModulo.RetrocompatibilidadeDeProtocolo then
                           begin
                             if IniTime <> EncodeDate(1,1,1) then
                                Result := STX + s[2] + s[3] + Chr($39) + inttostr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime) + ETX  { Chamou uma senha }
                             else
                                Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ETX;  { Esta na fila outbuffer pra aparecer no painel }
                           end
                           else
                           begin
                              TipoSenha := NGetFilaName(NGetFilaFromRange(Senha));
                              if IniTime <> EncodeDate(1,1,1) then
                                Result := STX + s[2] + s[3] + Chr($39) + inttostr(Senha) + FormatDateTime('ddmmyyyyhhnnss', IniTime) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX
                              else
                                Result := STX + s[2] + s[3] + Chr($23) + inttostr(Senha) + ';' + TipoSenha + ';' + frmSicsMain.GetNome_NumeroFicha(Senha) + ETX;
                           end;  { else }
                        end;  { else }
                     end;  { case }
                  end;  { case Chr($38) }

        Chr($41): begin
                    PA     := StrToInt('$'+s[2]+s[3]);
                    Aux    := frmSicsMain.GetSendMotivosDePausaTableTextPA(PA);
                    Result := STX + s[2] + s[3] + Chr($42) + Aux + ETX;
                  end;


       Chr($54) : begin
                    PA       := StrToInt('$'+s[2]+s[3]);
                    Forcar   := (ProtData[1] = '1');
                    AtdLogin := Copy(ProtData, 2);

                    if frmSicsMain.Login(PA, AtdLogin, Forcar, MotivoErro) then
                      Result := STX + s[2] + s[3] + Chr($B4) + '1' + MotivoErro + ETX
                    else
                      Result := STX + s[2] + s[3] + Chr($B4) + '0' + MotivoErro + ETX;
                  end;  { case Chr($54) }

       Chr($EA) : begin
                    PA       := StrToInt('$'+s[2]+s[3]);
                    Forcar   := (ProtData[1] = '1');
                    AtdLogin := Copy(ProtData, 2);

                    if frmSicsMain.Login(PA, AtdLogin, Forcar, MotivoErro) then
                      Result := STX + s[2] + s[3] + Chr($EB) + '1' + MotivoErro + ';' + IntToStr(vgParametrosModulo.TimeOutPA) + ETX
                    else
                      Result := STX + s[2] + s[3] + Chr($EB) + '0' + MotivoErro + ';' + IntToStr(vgParametrosModulo.TimeOutPA) + ETX;
                  end;  { case Chr($XX) }

       Chr($5D):  begin
                    PA       := StrToInt('$'+s[2]+s[3]);
                    if frmSicsMain.LogoutPA(PA) then
                      Result := STX + s[2] + s[3] + Chr($B8) + '1' + ETX
                    else
                      Result := STX + s[2] + s[3] + Chr($B8) + '0' + ETX;
                  end; { case Chr($5D) }

        Chr($D1): begin
                    PA     := StrToInt('$'+s[2]+s[3]);
                    frmSicsMain.GetSendAlarmesAtivosText(PA, Aux);
                    Result := STX + s[2] + s[3] + Chr($D2) + Aux + ETX;
                  end;

        Chr($CD):
          begin // Obter Dados Adicionais de uma senha
            SenhaStr := ProtData;

            if not TryStrToInt(SenhaStr, Senha) then
            begin
              Aux    := SenhaStr + ';' + '0' + ';' + 'Senha inválida';
              Result := STX + s[2] + s[3] + Chr($CE) + aux + ETX;
              Exit;
            end;

            LID := frmSicsMain.GetIdTicketIfPwdExists(Senha);
            if LID < 0 then
            begin
              Aux    := SenhaStr + ';' + '0' + ';' + 'Senha inexistente';
              Result := STX + s[2] + s[3] + Chr($CE) + aux + ETX;
              Exit;
            end;

            LJSONObj := dmSicsMain.GetDadosAdicionais(LID);
            try
              if Assigned(LJSONObj) then
              begin
                Aux    := SenhaStr + ';' + '2' + ';' + LJSONObj.ToJSON;
                Result := STX + s[2] + s[3] + Chr($CE) + aux + ETX;
              end
              else
              begin
                Aux    := SenhaStr + ';' + '1';
                Result := STX + s[2] + s[3] + Chr($CE) + aux + ETX;
              end;
            finally
              if Assigned(LJSONObj) then
                LJSONObj.Free;
            end;
          end; { case $CD }

       else begin
              Result := STX + s[2] + s[3] + Chr($33) + ETX;
            end;
    end;  { case }
  end  { if s <> '' }
  else
    Result := '';
end; { proc DecifraProtocoloRetrocompatibilidade }

end.

