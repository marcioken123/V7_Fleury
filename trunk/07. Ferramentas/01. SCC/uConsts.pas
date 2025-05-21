unit uConsts;

interface

uses uTypes;

const
  cgVERSAOPROTOCOLO = 3;

  StrTipoDaInterface : array[TTipoDaInterface] of string = (
                         'Desconfigurado',
                         'ArquivosTexto',
                         'TabelaSQL',
                         'MV',
                         'Silab',
                         'REST',
                         'HORSE');

  STX = Chr(02);
  ETX = Chr(03);
  TAB = Chr(09);
  ACK = $6;

  CMD_LOGIN     = $C1;
  CMD_LOGIN_RES = $B4;

  CMD_LOGOUT     = $5D;
  CMD_LOGOUT_RES = $B8;

  CMD_PAUSA     = $28;
  CMD_PAUSA_RES = $B9;

  CMD_SENHA_ESPECIFICA     = $21;
  CMD_SENHA_ESPECIFICA_RES = $21;

  CMD_GERAR_NOVA_SENHA_NA_FILA = $6B;
  CMD_GERAR_NOVA_SENHA_NA_FILA_RES = $3B;

  CMD_ENCAMINHAR_SENHA_PARA_FILA = $77;
  CMD_ENCAMINHAR_SENHA_PARA_FILA_RES = $24;

  CMD_QTD_SENHA_EM_ESPERA = $34;
  CMD_QTD_SENHA_EM_ESPERA_RES = $35;

  CMD_SITUACAO_FILA = $6C;
  CMD_SITUACAO_FILA_RES = $6D;

  CMD_LISTAR_FILAS_PA     = $DA;
  CMD_LISTAR_FILAS_PA_RES = $DB;

  CMD_LISTAR_FILAS_GERAM_SENHAS    = $C7;
  CMD_LISTAR_FILAS_GERAM_SENHAS_RES = $C8;

  CMD_LISTAR_MOTIVOS_PAUSA     = $41;
  CMD_LISTAR_MOTIVOS_PAUSA_RES = $42;

  CMD_LISTAR_PAS     = $3D;
  CMD_LISTAR_PAS_RES = $3E;

  CMD_STATUS_PAS = $29;
  CMD_STATUS_PAS_RES = $3C;

  CMD_LISTAR_GRUPOSPAS     = $78;
  CMD_LISTAR_GRUPOSPAS_RES = $79;

  CMD_LISTAR_GRUPOSTAGS     = $78;
  CMD_LISTAR_GRUPOSTAGS_RES = $79;

  CMD_LISTAR_TAGS     = $7F;
  CMD_LISTAR_TAGS_RES = $AA;

  CMD_NOMEAR_SENHA     = $57;
  CMD_NOMEAR_SENHA_RES = CMD_NOMEAR_SENHA;

  CMD_CHAMAR_PROXIMO            = $20;
  CMD_CHAMAR_ESPECIFICA         = $21;
  CMD_FORCAR_CHAMADA_ESPECIFICA = $30;
  CMD_REDIRECIONA               = $2E;
  CMD_REDIRECIONA_E_PROXIMO     = $2F;
  CMD_REDIRECIONA_E_ESPECIFICA  = $32;
  CMD_RES_SENHA_CHAMOU          = $23;
  CMD_RES_SENHA_NAO_CHAMOU      = $24; //Possíveis motivos: 0, N, P, L, M, I, p
  CMD_RES_SENHA_EM_NENHUMA_FILA = $50; //RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA EM NENHUMA FILA
  CMD_RES_SENHA_FORA_PRIORI_ATD = $51; //RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA NAS PRIORIDADES DO ATENDENTE

  CMD_GERAR_SENHA               = $70;
  CMD_GERAR_SENHA_RES           = $C6; //RE: Senha gerada pelo comando $70

  CMD_GET_STATUS_SENHA          = $C9;
  CMD_GET_STATUS_SENHA_RES      = $CA;

  CMD_SOLIC_PRIORID_ATENDEND                        = $C4;
  CMD_SOLIC_PRIORID_ATENDEND_RES                    = $C5;

  CMD_SITUACAO_ATENDIMENTO                          = $3C;

  CMD_OBTER_DADOS_ADICIONAIS_SENHA                  = $CD;
  CMD_OBTER_DADOS_ADICIONAIS_SENHA_RES              = $CE;
  CMD_ATUALIZAR_DADOS_ADICIONAIS_SENHA              = $CB;
  CMD_ATUALIZAR_DADOS_ADICIONAIS_SENHA_RES          = $CC;

  CMD_LISTAR_TAGS_SENHA                             = $AB;
  CMD_LISTAR_TAGS_SENHA_RES                         = $AC;
  CMD_MARCAR_TAG_SENHA                              = $7D;
  CMD_MARCAR_TAG_SENHA_RES                          = $7E;
  CMD_DESMARCAR_TAG_SENHA                           = $AD;
  CMD_DESMARCAR_TAG_SENHA_RES                       = $AE;

  //LM
  CMD_LISTAR_TOTENS                                 = $E4;
  CMD_LISTAR_TOTENS_RES                             = $E5;
  CMD_OBTER_DADOS_TOTEN                             = $E6;
  CMD_OBTER_DADOS_TOTEN_RES                         = $E7;
  CMD_REIMPRIMIR_SENHA                              = $B1;
  CMD_CANCELAR_SENHA                                = $6A;
  CMD_OBTER_TEMPO_ESPERA                            = $E8;
  CMD_OBTER_TEMPO_ESPERA_RES                        = $E9;
  CMD_LISTAR_FILAS_MODULO                           = $EC;
  CMD_LISTAR_FILAS_MODULO_RES                       = $ED;
  CMD_OBTER_TEMPO_ESPERA_UNIDADE                    = $EE;
  CMD_OBTER_TEMPO_ESPERA_UNIDADE_RES                = $EF;

  CMD_OBTER_TEMPO_ESTIMADO_UNIDADE                  = $F0;
  CMD_OBTER_TEMPO_ESTIMADO_UNIDADE_RES              = $F1;
  CMD_OBTER_CONFIGURACAO_MODULO                     = $8C;
  CMD_OBTER_CONFIGURACAO_MODULO_RES                 = $B2;

  CMD_LISTAR_GRUPO_FILAS                            = $F3;
  CMD_LISTAR_GRUPO_FILAS_RES                        = $F4;
  CMD_LISTAR_CATEGORIA_FILAS                        = $F5;
  CMD_LISTAR_CATEGORIA_FILAS_RES                    = $F6;

  CMD_ENVIAR_TEXTO_IMPRESSAO                        = $F7;
  CMD_ENVIAR_TEXTO_IMPRESSAO_RES                    = $F8;

  CMD_ENVIAR_RESPOSTA_PESQUISA                      = $F9;

  CMD_BUSCAR_RESPOSTA_PESQUISA_FLUXO                = $FA;
  CMD_BUSCAR_RESPOSTA_PESQUISA_FLUXO_RES            = $FB;

  {$REGION '//Motivos por Não ter Chamado uma senha - complemento dos comandos 24h, 2Fh, 2Eh, etc'}
  MNC_NAO_HA_SENHAS      = $30; //'0' = 30h = nao ha mais senhas a serem chamadas
  MNC_SENHA_NENHUMA_FILA = $4E; //'N' = 4Eh = senha solicitada nao se encontra em nenhuma fila
  MNC_FORA_PRIORI_ADDR   = $50; //'P' = 50h = senha solicitada se encontra numa fila nao inclusa nas prioridades de atendimento do ADR
  MNC_SEM_ATD_LOGADO_PA  = $4C; //'L' = 4Ch = nao tem atendente logado na PA
  MNC_NUM_ATEND_ULT_MGZ  = $4D; //'M' = 4Dh = número de atendimentos ultrapassa magazine
  MNC_SENHA_INVALIDA     = $49; //'I' = 49h = senha inválida (fora do range)
  MNC_PA_EM_PAUSA        = $70; //'p' = 70h = PA está em pausa
  MNC_SENHA_EM_BRANCO    = $0 ; //    = 00h = <PSWD> = ''
  MNC_FILA_PARA_CHAMADA  = $2 ; // Esta na fila para chamar alguem (rechamou enquanto aguarda liberação do painel)
  MNC_SENHA_DIVERGENTE   = $3 ; //chamou a senha A e retornou B
  MNC_DESCONHECIDO       = $FFFF; //motivo desconhecido

  function GetDescricaoMotivo(IdMotivo : integer) : string;
  {$ENDREGION}

implementation

function GetDescricaoMotivo(IdMotivo : integer) : string;
begin
  case IdMotivo of
    MNC_NAO_HA_SENHAS      : Result := 'Não há mais senhas a serem chamadas';
    MNC_SENHA_NENHUMA_FILA : Result := 'Senha não se encontra em nenhuma fila';
    MNC_FORA_PRIORI_ADDR   : Result := 'Senha em uma fila fora das prioridades de atendimento da PA';
    MNC_SEM_ATD_LOGADO_PA  : Result := 'Não tem atendente logado na PA';
    MNC_NUM_ATEND_ULT_MGZ  : Result := 'Número de atendimentos ultrapassa magazine';
    MNC_SENHA_INVALIDA     : Result := 'Senha inválida (fora dos ranges cadastrados)';
    MNC_PA_EM_PAUSA        : Result := 'PA está em pausa';
    MNC_SENHA_EM_BRANCO    : Result := 'Senha em branco';
    MNC_FILA_PARA_CHAMADA  : Result := 'Na fila para chamar (aguardando liberação do painel)';
    MNC_SENHA_DIVERGENTE   : Result := 'Chamou a senha A e retornou B';
    MNC_DESCONHECIDO       : Result := 'Motivo desconhecido';
  end;
end;

end.
