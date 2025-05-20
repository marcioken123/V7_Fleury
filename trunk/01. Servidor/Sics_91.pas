unit Sics_91;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  System.SysUtils;

type
  TTipoEvento    = (teEspera, teRechama, teAtendimento, teOcioso, teLogado, teEmPausa);
  TRecTipoEvento = record
                     ID   : integer;
                     Nome : string;
                   end;

  TStatusPA = (spDeslogado, spDisponivel, spEmAtendimento, spEmPausa);
  TRecStatusPA = record
                   ID   : integer;
                   Nome : string;
                 end;


  TModeloPainel    = (mp4080, mp220, mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito,
                      mp2311, mp2511_LadoEsquerdo, mp2511_LadoDireito, mp2911_LadoEsquerdo,
                      mp2911_LadoDireito, mpTV, mpNumericoMultiLinhasLinha1, mpNumericoMultiLinhasLinha2,
                      mpNumericoMultiLinhasLinha3, mp2411, mp4120);
  TRecModeloPainel = record
                       ID   : integer;
                       Nome : string;
                     end;

  TRecModeloTotem = record
                       ID   : integer;
                       Nome : string;
                     end;

  TTipoPI    = (tpiPessoasEmFilaAgora, tpiEsperaMaximaAgora, tpiEsperaMediaUltimosN,
                tpiPessoasEmAtendimentoAgora, tpiTempoDeAtendimentoAgora,
                tpiAtendentesLogadosAgora, tpiCombinacaoDeIndicadores,
                tpiTempoEstimadoDeEspera, tpiTempoMedioDeAtendimento,
                tpiValorBancoDadosHorario, tpiValorBancoDadosNumerico);

  TRecTipoPI = record
                 ID                      : integer;
                 Nome, TabelaRelacionada : string;
                 FormatoHorario          : boolean
               end;

  TAlinhamentoPI    = (apiEsquerdo, apiDireito, apiCentralizado);
  TRecAlinhamentoPI = record
                        ID   : integer;
                        Nome : string;
                      end;

  TNivelPI    = (npNormal, npAtencao, npCritico);
  TRecNivelPI = record
                  ID        : integer;
                  Nome, Cor : string;
                  CodigoCor : integer;
                  Posicao   : Integer;
                  CorPainelEletronico : string;
                end;

  TFuncaoPI    = (fpiSoma, fpiMaximo, fpiMinimo, fpiMedia);
  TRecFuncaoPI = record
                   ID   : integer;
                   Nome : string;
                 end;

  TAcaoAlarmePI    = (aaNenhuma, aaEnviarEmail, aaMensagemNoPainel, aaMensagemParaPA, aaEnviarSMS);
  TRecAcaoAlarmePI = record
                       ID                      : integer;
                       Nome, TabelaRelacionada : string;
                     end;

  TModuloSics        = (msNone, msPA, msMPA, msOnLine, msTGS, msTV, msServidor, msCallCenter, msTotemTouch);

  //Verificar a necessidade e uso destes tipos, e tentar eliminar caso não necessários
  TTipoDeGrupo       = (tgNenhum, tgFila, tgTAG, tgPP, tgPA, tgAtd,tgNomesPAs, tgPausa, tgVisTAG, tgMtrBotao, tgMtrBloq, tgMtrPriori, tgMtrPermInc, tgPI);
  TTipoDeGrupoPA     = tgFila .. tgPausa;
  TTipoDeGrupoMPA    = TTipoDeGrupoPA;
  TTipoDeGrupoOnLine = tgFila .. tgMtrPermInc;

  TTipoGrupoPorModulo = record
    IdModulo: Integer;
    FModuloSics: TModuloSics;
    TipoDeGrupo: TTipoDeGrupo;
    case TModuloSics of
      msPA     : (GrupoPA: TTipoDeGrupoPA);
      msOnLine : (GrupoOnLine: TTipoDeGrupoOnLine);
      msMPA    : (GrupoGrupoMPA: TTipoDeGrupoMPA);
      msTGS    : (GrupoGrupoTGS: TTipoDeGrupo);
  end;

  TGetNomeColunaPorModulo = reference to function (aModuloSics: TModuloSics): string;
  //Verificar a necessidade e uso destes tipos acima, e tentar eliminar caso não necessários

const
  DESC_TOTEM_OBSOLETO = '* Obsoleto *';

  TOTEM_MODELO_6_BOTOES                       =  1;
  TOTEM_MODELO_8_BOTOES                       =  2;
  TOTEM_MODELO_TOUCH                          =  3;
  TOTEM_MODELO_IMPRESSORA                     =  4;
  TOTEM_MODELO_BALCAO                         =  5;
  TOTEM_MODELO_SILOUETE                       =  6;
  TOTEM_MODELO_SILOUETE_BEMATECH              =  7;
  TOTEM_MODELO_TOUCH_ZEBRA                    =  8;
  TOTEM_MODELO_TOUCH_BALCAO_PAREDE            =  9;
  TOTEM_MODELO_IMPRESSORA_BEMATECH            = 10;
  TOTEM_MODELO_SILOUETE_TOUCH                 = 11;
  TOTEM_MODELO_ELGIN                          = 12;
  TOTEM_MODELO_BALCAO_RAPIDO                  = 13;
  TOTEM_MODELO_SILOUETE_RAPIDO                = 14;
  TOTEM_MODELO_MULTITELAS                     = 15;
  TOTEM_MODELO_STANDALONE                     = 16;
  TOTEM_MODELO_SLIMBUTTON                     = 17;
  TOTEM_MODELO_SLIMTOUCH                      = 18;
  TOTEM_MODELO_TOUCH_BALCAO_PAREDE_MULTITELAS = 19;

  TiposEventos : array [TTipoEvento] of TRecTipoEvento = (
      (ID : 0; Nome : 'Espera'     ),
      (ID : 1; Nome : 'Rechama'    ),
      (ID : 2; Nome : 'Atendimento'),
      (ID : 3; Nome : 'Ocioso'     ),
      (ID : 4; Nome : 'Logado'     ),
      (ID : 5; Nome : 'Pausa'      )
    );

  StatusPAs : array[TStatusPA] of TRecStatusPA = (
      (ID : 0; Nome : 'Deslogado'     ),
      (ID : 1; Nome : 'Disponível'    ),
      (ID : 2; Nome : 'Em atendimento'),
      (ID : 3; Nome : 'Em pausa'      )
    );

  ModelosPaineis : array[TModeloPainel] of TRecModeloPainel = (
      (ID :  0; Nome : '4080C'                          ),
      (ID :  1; Nome : '220C'                           ),
      (ID :  2; Nome : 'BetaBrite'                      ),
      (ID :  3; Nome : 'BetaSics - Lado Esquerdo'       ),
      (ID :  4; Nome : 'BetaSics - Lado Direito'        ),
      (ID :  5; Nome : '2311X'                          ),
      (ID :  6; Nome : '2511X - Lado Esquerdo'          ),
      (ID :  7; Nome : '2511X - Lado Direito'           ),
      (ID :  8; Nome : '2911X - Lado Esquerdo'          ),
      (ID :  9; Nome : '2911X - Lado Direito'           ),
      (ID : 10; Nome : 'TV'                             ),
      (ID : 11; Nome : 'Numérico Multilinhas - Linha 1' ),
      (ID : 12; Nome : 'Numérico Multilinhas - Linha 2' ),
      (ID : 13; Nome : 'Numérico Multilinhas - Linha 3' ),
      (ID : 14; Nome : '2411X'                          ),
      (ID : 15; Nome : '4120C'                          )
    );


    ModelosTotens : array[1..19] of TRecModeloTotem = (
      (ID : TOTEM_MODELO_6_BOTOES                      ; Nome : DESC_TOTEM_OBSOLETO               ),
      (ID : TOTEM_MODELO_8_BOTOES                      ; Nome : DESC_TOTEM_OBSOLETO               ),
      (ID : TOTEM_MODELO_TOUCH                         ; Nome : DESC_TOTEM_OBSOLETO               ),
      (ID : TOTEM_MODELO_IMPRESSORA                    ; Nome : DESC_TOTEM_OBSOLETO               ),
      (ID : TOTEM_MODELO_BALCAO                        ; Nome : 'Balcão'                          ),
      (ID : TOTEM_MODELO_SILOUETE                      ; Nome : 'Silouete'                        ),
      (ID : TOTEM_MODELO_SILOUETE_BEMATECH             ; Nome : 'Silouete Bematech'               ),
      (ID : TOTEM_MODELO_TOUCH_ZEBRA                   ; Nome : 'Touch Zebra'                     ),
      (ID : TOTEM_MODELO_TOUCH_BALCAO_PAREDE           ; Nome : 'Touch Balcão Parede'             ),
      (ID : TOTEM_MODELO_IMPRESSORA_BEMATECH           ; Nome : 'Impressora Bematech'             ),
      (ID : TOTEM_MODELO_SILOUETE_TOUCH                ; Nome : 'Silouete Touch'                  ),
      (ID : TOTEM_MODELO_ELGIN                         ; Nome : 'Elgin G0'                        ),
      (ID : TOTEM_MODELO_BALCAO_RAPIDO                 ; Nome : 'Balcão Rápido'                   ),
      (ID : TOTEM_MODELO_SILOUETE_RAPIDO               ; Nome : 'Silouete Rápido'                 ),
      (ID : TOTEM_MODELO_MULTITELAS                    ; Nome : 'MultiTelas'                      ),
      (ID : TOTEM_MODELO_STANDALONE                    ; Nome : 'StandAlone'                      ),
      (ID : TOTEM_MODELO_SLIMBUTTON                    ; Nome : 'Slim Button'                     ),
      (ID : TOTEM_MODELO_SLIMTOUCH                     ; Nome : 'Slim Touch'                      ),
      (ID : TOTEM_MODELO_TOUCH_BALCAO_PAREDE_MULTITELAS; Nome : 'Touch Balcão Parede MultiTelas'  )
    );


  TiposPIs : array[TTipoPI] of TRecTipoPI = (
      (ID :  0; Nome : 'Número de pessoas em fila agora'           ; TabelaRelacionada : 'Filas'             ; FormatoHorario : false),
      (ID :  1; Nome : 'Tempo máximo de espera na fila agora'      ; TabelaRelacionada : 'Filas'             ; FormatoHorario : true ),
      (ID :  2; Nome : 'Tempo médio de espera na fila (ultimos N)' ; TabelaRelacionada : 'Filas'             ; FormatoHorario : true ),
      (ID :  3; Nome : 'Número de pessoas em atendimento agora'    ; TabelaRelacionada : 'PAs'               ; FormatoHorario : false),
      (ID :  4; Nome : 'Tempo de atendimento por PA agora'         ; TabelaRelacionada : 'PAs'               ; FormatoHorario : true ),
      (ID :  5; Nome : 'Número de atendentes logados agora'        ; TabelaRelacionada : 'PAs'               ; FormatoHorario : false),
      (ID :  6; Nome : 'Combinação de indicadores'                 ; TabelaRelacionada : 'PIs'               ; FormatoHorario : true ),
      (ID :  7; Nome : 'Tempo Estimado de Espera (TEE)'            ; TabelaRelacionada : 'Filas, PAs'        ; FormatoHorario : true ),
      (ID :  8; Nome : 'Tempo Médio de Atendimento (TMA)'          ; TabelaRelacionada : 'PAs'               ; FormatoHorario : true ),
      (ID :  9; Nome : 'Valor em banco de dados (Horário)'         ; TabelaRelacionada : 'PIS_VALORES_EM_BD' ; FormatoHorario : true ),
      (ID : 10; Nome : 'Valor em banco de dados (Numérico)'        ; TabelaRelacionada : 'PIS_VALORES_EM_BD' ; FormatoHorario : false)
    );


  AlinhamentosPIs : array[TAlinhamentoPI] of TRecAlinhamentoPI = (
      (ID : 0; Nome : 'Esquerdo'    ),
      (ID : 1; Nome : 'Direito'     ),
      (ID : 2; Nome : 'Centralizado')
    );


  NiveisPIs : array[TNivelPI] of TRecNivelPI = (
      (ID : 0; Nome : 'Normal' ; Cor : 'Verde'   ; CodigoCor : 65280 ; Posicao : 1 ; CorPainelEletronico : 'Verde'),
      (ID : 1; Nome : 'Atenção'; Cor : 'Amarelo' ; CodigoCor : 65535 ; Posicao : 2 ; CorPainelEletronico : 'Ambar'),
      (ID : 2; Nome : 'Crítico'; Cor : 'Vermelho'; CodigoCor : 255   ; Posicao : 3 ; CorPainelEletronico : 'Vermelho')
    );


  FuncoesPIs : array[TFuncaoPI] of TRecFuncaoPI = (
      (ID : 0; Nome : 'Soma'  ),
      (ID : 1; Nome : 'Máximo'),
      (ID : 2; Nome : 'Mínimo'),
      (ID : 3; Nome : 'Média' )
    );


  AcoesAlarmesPIs: array[TAcaoAlarmePI] of TRecAcaoAlarmePI = (
      (ID : 0; Nome : '(nenhuma)'          ; TabelaRelacionada : ''          ),
      (ID : 1; Nome : 'Enviar e-mail'      ; TabelaRelacionada : 'EMails'    ),
      (ID : 2; Nome : 'Mensagem no painel' ; TabelaRelacionada : 'Paineis'   ),
      (ID : 3; Nome : 'Mensagem para PA'   ; TabelaRelacionada : 'PAs'       ),
      (ID : 4; Nome : 'Enviar SMS'         ; TabelaRelacionada : 'Celulares' )
    );

implementation

end.
