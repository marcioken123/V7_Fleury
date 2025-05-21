unit SicsTV_Parametros;

interface

uses
  System.Classes, System.SysUtils, System.JSON, MyAspFuncoesUteis_VCL, AspJson,
  Sics_Common_Parametros, Vcl.Forms, Winapi.Windows, StrUtils, IniFiles,
  MyDlls_DR, JvExExtCtrls, JvComponent, JvComponentBase, JvTrayIcon, JvImage,
  JvGIF, JvExControls, JvImageTransform, JvSecretPanel, JvBackgrounds, JvPanel,
  JvExStdCtrls, JvBehaviorLabel, JvExtComponent, ShockwaveFlashObjects_TLB,
  WMPLib_TLB, Vcl.ExtCtrls, System.UITypes,
  Vcl.Graphics, Vcl.Controls, DSUtil,
  Winapi.DirectShow9;

procedure CarregarParametrosINI;
procedure CarregarParametrosTV(Parametros: string);
procedure CarregarParametrosTVPaineis(Parametros: string);
procedure SalvarParametrosTV(CarregaINI: Boolean = False);
function  SalvarParametrosTVPaineis(Parametros: TParametrosModuloTVPaineis): TJSONObject;
procedure LoadPanel (no : integer);

implementation

uses
  SicsTV_m,

  SicsTV_3,
  Sics_Common_DataModuleClientConnection;

{$REGION 'procedure CarregarParametrosINI'}
procedure CarregarParametrosINI;
var
  IniFile     : TIniFile;
  i           : integer;
  LJSONArray  : TJSONArray;
  LJSONPainel : TJSONObject;
begin
  Finalize(vgParametrosModulo.Paineis);
  SetLength(vgParametrosModulo.Paineis, 0);

  //if gfInitializing then
  with frmSicsTVPrincipal do
  begin
    IniFile := TIniFile.Create(GetAppIniFileName);
    try
      LJSONArray := TJSONArray.Create;

      try
        for i := 1 to cgMaxPanels do //for i := Low(vgParametrosModulo.Paineis) to High(vgParametrosModulo.Paineis) do //
          if IniFile.SectionExists('Panel'+inttostr(i)) then
          begin
            //CreatePanel(i, TTipoDePainel(IniFile.ReadInteger('Panel'+inttostr(i), 'Tipo', 1))); // TTipoDePainel(vgParametrosModulo.Paineis[i].Tipo)
            SetLength(vgParametrosModulo.Paineis, Length(vgParametrosModulo.Paineis) + 1);

            //if (TTipoDePainel(IniFile.ReadInteger('Panel'+inttostr(i), 'Tipo', 1)) = tpTV) then  // vgParametrosModulo.Paineis[i].Tipo
              //CreatePanel(i, tpVideo,true);
            SicsTV_Parametros.LoadPanel(i);

            LJSONPainel := SalvarParametrosTVPaineis(vgParametrosModulo.Paineis[High(vgParametrosModulo.Paineis)]);

            LJSONArray.AddElement(LJSONPainel);
          end;

        dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($46) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + LJSONArray.ToJSON, 0);
      except
        on E: Exception do
          MyLogException (Exception.Create ('Erro ao Carregar parãmetros INI: '+ IniFile.FileName +' Erro: "' + E.Message + '"'));
      end;

      Delay(600);
    finally
      IniFile.Free;
    end;
  end;
end;
{$ENDREGION 'procedure CarregarParametrosINI'}

{$REGION 'procedure CarregarParametrosTV'}
procedure CarregarParametrosTV(Parametros: string);
var
  ObjJSon: TJSONValue;
  LJsonObjeto: TJSONObject;
begin
  ObjJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Parametros), 0);
  try
    LJsonObjeto := TAspJson.GetJsonObjectOfJson(ObjJson);

    vgParametrosModulo.IdModulo                  := TAspJson.GetValueOfJson(LJsonObjeto, 'ID');

    try
      with TIniFile.Create(GetAppIniFileName) do
      begin
        if vgParametrosModulo.IdModulo > 0 then
          WriteInteger('Settings', 'IdModulo', vgParametrosModulo.IdModulo);
        Free;
      end;
    finally

    end;

    vgParametrosModulo.ChamadaInterrompeVideo    := TAspJson.GetValueOfJson(LJsonObjeto, 'CHAMADAINTERROMPEVIDEO');
    vgParametrosModulo.PortaIPPainel             := TAspJson.GetValueOfJson(LJsonObjeto, 'PortaIPPainel');
    vgParametrosModulo.IdTV                      := TAspJson.GetValueOfJson(LJsonObjeto, 'IdTV');
    vgParametrosModulo.IdPainel                  := TAspJson.GetValueOfJson(LJsonObjeto, 'IdPainel');
    vgParametrosModulo.IndicadoresPermitidos     := TAspJson.GetValueOfJson(LJsonObjeto, 'INDICADORESPERMITIDOS');
    vgParametrosModulo.MaximizarMonitor1         := TAspJson.GetValueOfJson(LJsonObjeto, 'MAXIMIZARMONITOR1');
    vgParametrosModulo.MaximizarMonitor2         := TAspJson.GetValueOfJson(LJsonObjeto, 'MaximizarMonitor2');

    vgParametrosModulo.DeH                       := TAspJson.GetValueOfJson(LJsonObjeto, 'DeH');
    vgParametrosModulo.DeM                       := TAspJson.GetValueOfJson(LJsonObjeto, 'DeM');
    vgParametrosModulo.AteH                      := TAspJson.GetValueOfJson(LJsonObjeto, 'AteH');
    vgParametrosModulo.AteM                      := TAspJson.GetValueOfJson(LJsonObjeto, 'AteM');
    vgParametrosModulo.FuncionaDomingo           := TAspJson.GetValueOfJson(LJsonObjeto, 'FuncionaDomingo');
    vgParametrosModulo.FuncionaSabado            := TAspJson.GetValueOfJson(LJsonObjeto, 'FuncionaSabado');
    vgParametrosModulo.Volume                    := TAspJson.GetValueOfJson(LJsonObjeto, 'Volume');
    vgParametrosModulo.LastMute                  := TAspJson.GetValueOfJson(LJsonObjeto, 'LastMute');

    LoadHorarioDeFuncionamento(frmSicsTVPrincipal.vgHorarioDeFuncionamento);

    frmSicsTVPrincipal.vlAddress := TAspJson.GetValueOfJson(LJsonObjeto, 'IdPainel');

    if not frmSicsTVPrincipal.EstaNoHorarioDeFuncionamento then
      Application.MessageBox('A tela ficará preta pois não está no horário de funcionamento do programa.', 'Aviso', MB_ICONWARNING);

    vgParametrosModulo.JaEstaConfigurado         := True;

    //if ReadBool ('Settings', 'MaximizarMonitor1', true ) then
    if vgParametrosModulo.MaximizarMonitor1 then
      frmSicsTVPrincipal.menuMonitor1.Click
    //else if ReadBool ('Settings', 'MaximizarMonitor2', false ) then
    else if vgParametrosModulo.MaximizarMonitor2 then
      frmSicsTVPrincipal.menuMonitor2.Click
    else
      LoadPosition (frmSicsTVPrincipal);
  finally
    FreeAndNil(ObjJSon);
  end;
end;
{$ENDREGION CarregarParametrosTV}

{$REGION 'procedure CarregarParametrosTVPaineis'}
procedure CarregarParametrosTVPaineis(Parametros: string);
var
  LJSONArray  : TJSONArray;
  ObjJSon     : TJSONValue;
  LJsonObjeto : TJSONObject;
begin
  Finalize(vgParametrosModulo.Paineis);
  SetLength(vgParametrosModulo.Paineis, 0);

  LJSONArray := TJSONObject.ParseJSONValue(Parametros) as TJSONArray;
  try
    if LJSONArray.Count > 0 then
    begin
      for var LCount := 0 to Pred(LJSONArray.Count) do
      begin
        LJsonObjeto := (LJSONArray.Items[LCount] as TJSONObject);

        SetLength(vgParametrosModulo.Paineis, Length(vgParametrosModulo.Paineis) + 1);

        vgParametrosModulo.Paineis[LCount].ID                           := TAspJson.GetValueOfJson(LJsonObjeto, 'ID');
        vgParametrosModulo.Paineis[LCount].Id_Modulo_TV                 := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_MODULO_TV');

        vgParametrosModulo.Paineis[LCount].Top                          := TAspJson.GetValueOfJson(LJsonObjeto, 'TOP');
        vgParametrosModulo.Paineis[LCount].Left                         := TAspJson.GetValueOfJson(LJsonObjeto, 'LEFT');
        vgParametrosModulo.Paineis[LCount].Height                       := TAspJson.GetValueOfJson(LJsonObjeto, 'HEIGHT');
        vgParametrosModulo.Paineis[LCount].Width                        := TAspJson.GetValueOfJson(LJsonObjeto, 'WIDTH');
        vgParametrosModulo.Paineis[LCount].Color                        := TAspJson.GetValueOfJson(LJsonObjeto, 'COLOR');
        vgParametrosModulo.Paineis[LCount].ArquivosVideo                := TAspJson.GetValueOfJson(LJsonObjeto, 'ARQUIVOSVIDEO');
        vgParametrosModulo.Paineis[LCount].Tipo                         := TAspJson.GetValueOfJson(LJsonObjeto, 'TIPO');
        vgParametrosModulo.Paineis[LCount].SoftwareHomologado           := TAspJson.GetValueOfJson(LJsonObjeto, 'SOFTWAREHOMOLOGADO');

        vgParametrosModulo.Paineis[LCount].ArquivoSom                   := TAspJson.GetValueOfJson(LJsonObjeto, 'ARQUIVOSOM');
        vgParametrosModulo.Paineis[LCount].ArquivoSomPI                 := TAspJson.GetValueOfJson(LJsonObjeto, 'ARQUIVOSOMPI');
        vgParametrosModulo.Paineis[LCount].ArquivosVideo                := TAspJson.GetValueOfJson(LJsonObjeto, 'ARQUIVOSVIDEO');
        vgParametrosModulo.Paineis[LCount].Atraso                       := TAspJson.GetValueOfJson(LJsonObjeto, 'ATRASO');
        vgParametrosModulo.Paineis[LCount].BackgroundFile               := TAspJson.GetValueOfJson(LJsonObjeto, 'BACKGROUNDFILE');
        vgParametrosModulo.Paineis[LCount].CaminhoDoExecutavel          := TAspJson.GetValueOfJson(LJsonObjeto, 'CAMINHODOEXECUTAVEL');
        vgParametrosModulo.Paineis[LCount].DiretorioLocal               := TAspJson.GetValueOfJson(LJsonObjeto, 'DIRETORIOLOCAL');
        vgParametrosModulo.Paineis[LCount].DisposicaoLinhas             := TAspJson.GetValueOfJson(LJsonObjeto, 'DISPOSICAOLINHAS');
        vgParametrosModulo.Paineis[LCount].Formato                      := TAspJson.GetValueOfJson(LJsonObjeto, 'FORMATO');
        vgParametrosModulo.Paineis[LCount].Fonte                        := TAspJson.GetValueOfJson(LJsonObjeto, 'FONTE');
        vgParametrosModulo.Paineis[LCount].FonteColor                   := TAspJson.GetValueOfJson(LJsonObjeto, 'FONTECOLOR');
        vgParametrosModulo.Paineis[LCount].FonteSize                    := TAspJson.GetValueOfJson(LJsonObjeto, 'FONTESIZE');
        vgParametrosModulo.Paineis[LCount].Espacamento                  := TAspJson.GetValueOfJson(LJsonObjeto, 'ESPACAMENTO');
        vgParametrosModulo.Paineis[LCount].IndicadorSomPI               := TAspJson.GetValueOfJson(LJsonObjeto, 'INDICADORSOMPI');
        vgParametrosModulo.Paineis[LCount].IntervaloVerificacao         := TAspJson.GetValueOfJson(LJsonObjeto, 'INTERVALOVERIFICACAO');
        vgParametrosModulo.Paineis[LCount].Dispositivo                  := TAspJson.GetValueOfJson(LJsonObjeto, 'DISPOSITIVO');
        vgParametrosModulo.Paineis[LCount].LayoutNomeClienteAlinhamento := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTNOMECLIENTEALINHAMENTO');
        vgParametrosModulo.Paineis[LCount].LayoutNomeClienteALT         := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTNOMECLIENTEALT');
        vgParametrosModulo.Paineis[LCount].LayoutNomeClienteLARG        := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTNOMECLIENTELARG');
        vgParametrosModulo.Paineis[LCount].LayoutNomeClienteX           := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTNOMECLIENTEX');
        vgParametrosModulo.Paineis[LCount].LayoutNomeClienteY           := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTNOMECLIENTEY');
        vgParametrosModulo.Paineis[LCount].LayoutPAAlinhamento          := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTPAALINHAMENTO');
        vgParametrosModulo.Paineis[LCount].LayoutPAALT                  := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTPAALT');
        vgParametrosModulo.Paineis[LCount].LayoutPALARG                 := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTPALARG');
        vgParametrosModulo.Paineis[LCount].LayoutPAX                    := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTPAX');
        vgParametrosModulo.Paineis[LCount].LayoutPAY                    := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTPAY');
        vgParametrosModulo.Paineis[LCount].LayoutSenhaAlinhamento       := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTSENHAALINHAMENTO');
        vgParametrosModulo.Paineis[LCount].LayoutSenhaALT               := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTSENHAALT');
        vgParametrosModulo.Paineis[LCount].LayoutSenhaLARG              := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTSENHALARG');
        vgParametrosModulo.Paineis[LCount].LayoutSenhaX                 := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTSENHAX');
        vgParametrosModulo.Paineis[LCount].LayoutSenhaY                 := TAspJson.GetValueOfJson(LJsonObjeto, 'LAYOUTSENHAY');
        vgParametrosModulo.Paineis[LCount].MargemDireita                := TAspJson.GetValueOfJson(LJsonObjeto, 'MARGEMDIREITA');
        vgParametrosModulo.Paineis[LCount].MargemEsquerda               := TAspJson.GetValueOfJson(LJsonObjeto, 'MARGEMESQUERDA');
        vgParametrosModulo.Paineis[LCount].MargemInferior               := TAspJson.GetValueOfJson(LJsonObjeto, 'MARGEMINFERIOR');

        vgParametrosModulo.Paineis[LCount].MostrarNomeCliente           := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRARNOMECLIENTE');
        vgParametrosModulo.Paineis[LCount].MostrarPA                    := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRARPA');
        vgParametrosModulo.Paineis[LCount].MostrarSenha                 := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRARSENHA');
        vgParametrosModulo.Paineis[LCount].Negrito                      := TAspJson.GetValueOfJson(LJsonObjeto, 'NEGRITO');
        vgParametrosModulo.Paineis[LCount].NomeArquivoBanco             := TAspJson.GetValueOfJson(LJsonObjeto, 'NOMEARQUIVOBANCO');
        vgParametrosModulo.Paineis[LCount].NomeArquivoHTML              := TAspJson.GetValueOfJson(LJsonObjeto, 'NOMEARQUIVOHTML');
        vgParametrosModulo.Paineis[LCount].NomeDaJanela                 := TAspJson.GetValueOfJson(LJsonObjeto, 'NOMEDAJANELA');
        vgParametrosModulo.Paineis[LCount].PASPermitidas                := TAspJson.GetValueOfJson(LJsonObjeto, 'PASPERMITIDAS');
        vgParametrosModulo.Paineis[LCount].PortaBanco                   := TAspJson.GetValueOfJson(LJsonObjeto, 'PORTABANCO');
        vgParametrosModulo.Paineis[LCount].Quantidade                   := TAspJson.GetValueOfJson(LJsonObjeto, 'QUANTIDADE');
        vgParametrosModulo.Paineis[LCount].Resolucao                    := TAspJson.GetValueOfJson(LJsonObjeto, 'RESOLUCAO');
        vgParametrosModulo.Paineis[LCount].ResolucaoPadrao              := TAspJson.GetValueOfJson(LJsonObjeto, 'RESOLUCAOPADRAO');

        vgParametrosModulo.Paineis[LCount].SenhaBanco                   := TAspJson.GetValueOfJson(LJsonObjeto, 'SENHABANCO');
        vgParametrosModulo.Paineis[LCount].SomArquivo                   := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMARQUIVO');
        vgParametrosModulo.Paineis[LCount].SomVoz                       := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZ');
        vgParametrosModulo.Paineis[LCount].SomVozChamada0               := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA0');
        vgParametrosModulo.Paineis[LCount].SomVozChamada1               := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA1');
        vgParametrosModulo.Paineis[LCount].SomVozChamada1Marcado        := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA1MARCADO');

        vgParametrosModulo.Paineis[LCount].SomVozChamada2               := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA2');
        vgParametrosModulo.Paineis[LCount].SomVozChamada2Marcado        := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA2MARCADO');
        vgParametrosModulo.Paineis[LCount].SomVozChamada3Marcado        := TAspJson.GetValueOfJson(LJsonObjeto, 'SOMVOZCHAMADA3MARCADO');
        vgParametrosModulo.Paineis[LCount].Sublinhado                   := TAspJson.GetValueOfJson(LJsonObjeto, 'SUBLINHADO');
        vgParametrosModulo.Paineis[LCount].TempoAlternancia             := TAspJson.GetValueOfJson(LJsonObjeto, 'TEMPOALTERNANCIA');
        vgParametrosModulo.Paineis[LCount].Transparente                 := TAspJson.GetValueOfJson(LJsonObjeto, 'TRANSPARENTE');

        vgParametrosModulo.Paineis[LCount].UsuarioBanco                 := TAspJson.GetValueOfJson(LJsonObjeto, 'USUARIOBANCO');
        vgParametrosModulo.Paineis[LCount].ValorAcompanhaCorDoNivel     := TAspJson.GetValueOfJson(LJsonObjeto, 'VALORACOMPANHACORDONIVEL');
        vgParametrosModulo.Paineis[LCount].VoiceIndex                   := TAspJson.GetValueOfJson(LJsonObjeto, 'VOICEINDEX');
      end;

      vgParametrosModulo.JaEstaConfiguradoPaineis := True;

      frmSicsTVPrincipal.tmrReconnect.Enabled := True;
      frmSicsTVPrincipal.InicializarForm;
    end;
  finally
    FreeAndNil(ObjJSon);
  end;
end;
{$ENDREGION 'procedure CarregarParametrosTVPaineis'}

{$REGION 'procedure SalvarParametrosTV'}
procedure SalvarParametrosTV(CarregaINI: Boolean);
var
  LJSONModulo_TV: TJSONObject;

  procedure CarregaParametrosINI;
  begin
    with TIniFile.Create(GetAppIniFileName) do
    begin
      vgParametrosModulo.ChamadaInterrompeVideo                 := ReadBool    ('Settings'  , 'ChamadaInterrompeVideo'         , false  );
      vgParametrosModulo.PortaIPPainel                          := ReadInteger ('Settings'  , 'PortaIPPainel'                  , 3001   );
      vgParametrosModulo.MaximizarMonitor1                      := ReadBool    ('Settings'  , 'MaximizarMonitor1'              , false  );
      vgParametrosModulo.MaximizarMonitor2                      := ReadBool    ('Settings'  , 'MaximizarMonitor2'              , false  );
      vgParametrosModulo.IdTV                                   := ReadInteger ('Settings'  , 'IdTV'                           , 0      ); // Integer;
      vgParametrosModulo.IndicadoresPermitidos                  := ReadString  ('Settings'  , 'IndicadoresPermitidos'          , ''     ); // string;
      vgParametrosModulo.Volume                                 := ReadInteger ('VisioForge', 'Volume'                         , 0      ); // integer;
      vgParametrosModulo.FuncionaSabado                         := ReadBool    ('Settings'  , 'FuncionaSabado'                 , False  ); // Boolean;
      vgParametrosModulo.FuncionaDomingo                        := ReadBool    ('Settings'  , 'FuncionaDomingo'                , False  ); // Boolean;
      vgParametrosModulo.DeH                                    := ReadInteger ('Settings'  , 'DeH'                            , 0      ); // Integer;
      vgParametrosModulo.DeM                                    := ReadInteger ('Settings'  , 'DeM'                            , 0      ); // Integer;
      vgParametrosModulo.AteH                                   := ReadInteger ('Settings'  , 'AteH'                           , 0      ); // Integer;
      vgParametrosModulo.AteM                                   := ReadInteger ('Settings'  , 'AteM'                           , 0      ); // Integer;
      vgParametrosModulo.LastMute                               := ReadInteger ('ACTIVE'    , 'LastMute'                       , 0      ); // Integer;

      Free;
    end;
  end;
begin
  LJSONModulo_TV := TJSONObject.Create;

  if CarregaINI then CarregaParametrosINI;

  try
    LJSONModulo_TV.AddPair('IDMODULO',               vgParametrosModulo.IdModulo.ToString); //Integer;
    LJSONModulo_TV.AddPair('IDPAINEL',               vgParametrosModulo.IdPainel.ToString); // Integer;
    LJSONModulo_TV.AddPair('PORTAIPPAINEL',          vgParametrosModulo.PortaIPPainel.ToString); // Integer;
    LJSONModulo_TV.AddPair('CHAMADAINTERROMPEVIDEO', IfThen(vgParametrosModulo.ChamadaInterrompeVideo, 'T', 'F')); // Boolean;
    LJSONModulo_TV.AddPair('MAXIMIZARMONITOR1',      IfThen(vgParametrosModulo.MaximizarMonitor1, 'T', 'F')); // Boolean;
    LJSONModulo_TV.AddPair('MAXIMIZARMONITOR2',      IfThen(vgParametrosModulo.MaximizarMonitor2, 'T', 'F')); // Boolean;
    LJSONModulo_TV.AddPair('IDTV',                   vgParametrosModulo.IdTV.ToString); // Integer;
    LJSONModulo_TV.AddPair('INDICADORESPERMITIDOS',  vgParametrosModulo.IndicadoresPermitidos); // string;
    LJSONModulo_TV.AddPair('VOLUME',                 vgParametrosModulo.Volume.ToString); // integer;
    LJSONModulo_TV.AddPair('FUNCIONASABADO',         IfThen(vgParametrosModulo.FuncionaSabado, 'T', 'F')); // Boolean;
    LJSONModulo_TV.AddPair('FUNCIONADOMINGO',        IfThen(vgParametrosModulo.FuncionaDomingo, 'T', 'F')); // Boolean;
    LJSONModulo_TV.AddPair('DEH',                    vgParametrosModulo.DeH.ToString); // Integer;
    LJSONModulo_TV.AddPair('DEM',                    vgParametrosModulo.DeM.ToString); // Integer;
    LJSONModulo_TV.AddPair('ATEH',                   vgParametrosModulo.AteH.ToString); // Integer;
    LJSONModulo_TV.AddPair('ATEM',                   vgParametrosModulo.AteM.ToString); // Integer;
    LJSONModulo_TV.AddPair('LASTMUTE',               vgParametrosModulo.LastMute.ToString); // Integer;

    dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($57) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + LJSONModulo_TV.ToJSON, 0);
  finally
    LJSONModulo_TV.Free;
  end;
end;
{$ENDREGION 'procedure SalvarParametrosTV'}

{$REGION 'procedure SalvarParametrosTVPaineis'}
function SalvarParametrosTVPaineis(Parametros: TParametrosModuloTVPaineis): TJSONObject;
var
  LJSONModulo_TV: TJSONObject;
  LJsonArray: TJSONArray;
begin
  LJSONModulo_TV := TJSONObject.Create;

  try
    if Parametros.ID > 0 then
      LJSONModulo_TV.AddPair('ID',                           Parametros.ID.ToString); // Integer;

    if vgParametrosModulo.IdModulo>0 then
      LJSONModulo_TV.AddPair('ID_MODULO_TV',                 vgParametrosModulo.IdModulo.ToString); // Integer;

    LJSONModulo_TV.AddPair('TIPO',                         Parametros.Tipo.ToString); // Integer;

    if Parametros.BackgroundFile<>EmptyStr then
      LJSONModulo_TV.AddPair('BACKGROUNDFILE',               Parametros.BackgroundFile); // string;

    if Parametros.Fonte<>EmptyStr then
      LJSONModulo_TV.AddPair('FONTE',                        Parametros.Fonte); // string;

    if Parametros.ArquivoSom<>EmptyStr then
      LJSONModulo_TV.AddPair('ARQUIVOSOM',                   Parametros.ArquivoSom); // string;

    if Parametros.FlashFile<>EmptyStr then
      LJSONModulo_TV.AddPair('FLASHFILE',                    Parametros.FlashFile); // string;

    if Parametros.CaminhoDoExecutavel<>EmptyStr then
      LJSONModulo_TV.AddPair('CAMINHODOEXECUTAVEL',          Parametros.CaminhoDoExecutavel); // string;

    if Parametros.NomeDaJanela<>EmptyStr then
      LJSONModulo_TV.AddPair('NOMEDAJANELA',                 Parametros.NomeDaJanela); // string;

    if Parametros.ResolucaoPadrao<>EmptyStr then
      LJSONModulo_TV.AddPair('NOMEDAJANELA',                 Parametros.ResolucaoPadrao); // string;

    if Parametros.ArquivosVideo<>EmptyStr then
      LJSONModulo_TV.AddPair('ARQUIVOSVIDEO',                Parametros.ArquivosVideo); // string;

    if Parametros.HostBanco<>EmptyStr then
      LJSONModulo_TV.AddPair('HOSTBANCO',                    Parametros.HostBanco); // string;

    if Parametros.PortaBanco<>EmptyStr then
      LJSONModulo_TV.AddPair('PORTABANCO',                   Parametros.PortaBanco); // string;

    if Parametros.NomeArquivoBanco<>EmptyStr then
      LJSONModulo_TV.AddPair('NOMEARQUIVOBANCO',             Parametros.NomeArquivoBanco); // string;

    if Parametros.UsuarioBanco<>EmptyStr then
      LJSONModulo_TV.AddPair('USUARIOBANCO',                 Parametros.UsuarioBanco); // string;

    if Parametros.SenhaBanco<>EmptyStr then
      LJSONModulo_TV.AddPair('SENHABANCO',                   Parametros.SenhaBanco); // string;

    if Parametros.DiretorioLocal<>EmptyStr then
      LJSONModulo_TV.AddPair('DIRETORIOLOCAL',               Parametros.DiretorioLocal); // string;

    if Parametros.LayoutSenhaX>0 then
      LJSONModulo_TV.AddPair('LAYOUTSENHAX',                 Parametros.LayoutSenhaX.ToString); // Integer;

    if Parametros.LayoutSenhaY>0 then
      LJSONModulo_TV.AddPair('LAYOUTSENHAY',                 Parametros.LayoutSenhaY.ToString); // Integer;

    if Parametros.LayoutSenhaLARG>0 then
      LJSONModulo_TV.AddPair('LAYOUTSENHALARG',              Parametros.LayoutSenhaLARG.ToString); // Integer;

    if Parametros.LayoutSenhaALT>0 then
      LJSONModulo_TV.AddPair('LAYOUTSENHAALT',               Parametros.LayoutSenhaALT.ToString); // Integer;

    if Parametros.LayoutPAX>0 then
      LJSONModulo_TV.AddPair('LAYOUTPAX',                    Parametros.LayoutPAX.ToString); // Integer;

    if Parametros.LayoutPAY>0 then
      LJSONModulo_TV.AddPair('LAYOUTPAY',                    Parametros.LayoutPAY.ToString); // Integer;

    if Parametros.LayoutPALARG>0 then
      LJSONModulo_TV.AddPair('LAYOUTPALARG',                 Parametros.LayoutPALARG.ToString); // Integer;

    if Parametros.LayoutPAALT>0 then
      LJSONModulo_TV.AddPair('LAYOUTPAALT',                  Parametros.LayoutPAALT.ToString); // Integer;

    if Parametros.LayoutNomeClienteX>0 then
      LJSONModulo_TV.AddPair('LAYOUTNOMECLIENTEX',           Parametros.LayoutNomeClienteX.ToString); // Integer;

    if Parametros.LayoutNomeClienteX>0 then
      LJSONModulo_TV.AddPair('LAYOUTNOMECLIENTEY',           Parametros.LayoutNomeClienteY.ToString); // Integer;

    if Parametros.LayoutNomeClienteX>0 then
      LJSONModulo_TV.AddPair('LAYOUTNOMECLIENTELARG',        Parametros.LayoutNomeClienteLARG.ToString); // Integer;

    if Parametros.LayoutNomeClienteALT>0 then
      LJSONModulo_TV.AddPair('LAYOUTNOMECLIENTEALT',         Parametros.LayoutNomeClienteALT.ToString); // Integer;

    if Parametros.Quantidade<>EmptyStr then
      LJSONModulo_TV.AddPair('QUANTIDADE',                   Parametros.Quantidade); // string;

    if Parametros.Atraso<>EmptyStr then
      LJSONModulo_TV.AddPair('ATRASO',                       Parametros.Atraso); // string;

    if Parametros.Espacamento<>EmptyStr then
      LJSONModulo_TV.AddPair('ESPACAMENTO',                  Parametros.Espacamento); // string;

    if Parametros.PASPermitidas<>EmptyStr then
      LJSONModulo_TV.AddPair('PASPERMITIDAS',                Parametros.PASPermitidas); // string;

    if Parametros.MargemSuperior>0 then
      LJSONModulo_TV.AddPair('MARGEMSUPERIOR',               Parametros.MargemSuperior.ToString); // Integer;

    if Parametros.MargemInferior>0 then
      LJSONModulo_TV.AddPair('MARGEMINFERIOR',               Parametros.MargemInferior.ToString); // Integer;

    if Parametros.MargemEsquerda>0 then
      LJSONModulo_TV.AddPair('MARGEMESQUERDA',               Parametros.MargemEsquerda.ToString); // Integer;

    if Parametros.MargemDireita>0 then
      LJSONModulo_TV.AddPair('MARGEMDIREITA',                Parametros.MargemDireita.ToString); // Integer;

    if Parametros.MargemDireita>0 then
      LJSONModulo_TV.AddPair('FORMATO',                      Parametros.Formato); //  string;

    if Parametros.MargemDireita>0 then
      LJSONModulo_TV.AddPair('NOMEARQUIVOHTML',              Parametros.NomeArquivoHTML); // string;

    if Parametros.MargemDireita>0 then
      LJSONModulo_TV.AddPair('INDICADORSOMPI',               Parametros.IndicadorSomPI); // string;

    if Parametros.MargemDireita>0 then
      LJSONModulo_TV.AddPair('ARQUIVOSOMPI',                 Parametros.ArquivoSomPI); // string;

    LJSONModulo_TV.AddPair('LEFT',                         Parametros.Left.ToString); // Integer;
    LJSONModulo_TV.AddPair('TOP',                          Parametros.Top.ToString); // Integer;
    LJSONModulo_TV.AddPair('HEIGHT',                       Parametros.Height.ToString); // Integer;
    LJSONModulo_TV.AddPair('WIDTH',                        Parametros.Width.ToString); // Integer;
    LJSONModulo_TV.AddPair('COLOR',                        Parametros.Color.ToString); // Integer;

    if Parametros.FonteSize>0 then
      LJSONModulo_TV.AddPair('FONTESIZE',                    Parametros.FonteSize.ToString); // Integer;

    if Parametros.FonteColor>0 then
      LJSONModulo_TV.AddPair('FONTECOLOR',                   Parametros.FonteColor.ToString); // Integer;

    if Parametros.SoftwareHomologado>0 then
      LJSONModulo_TV.AddPair('SOFTWAREHOMOLOGADO',           Parametros.SoftwareHomologado.ToString); //  Integer;

    if Parametros.Dispositivo>0 then
      LJSONModulo_TV.AddPair('DISPOSITIVO',                  Parametros.Dispositivo.ToString); //  Integer;

    if Parametros.Resolucao>0 then
      LJSONModulo_TV.AddPair('RESOLUCAO',                    Parametros.Resolucao.ToString); // Integer;

    if Parametros.TempoAlternancia>0 then
      LJSONModulo_TV.AddPair('TEMPOALTERNANCIA',             Parametros.TempoAlternancia.ToString); //  Integer;

    if Parametros.IDTVPlayListManager>0 then
      LJSONModulo_TV.AddPair('IDTVPLAYLISTMANAGER',          Parametros.IDTVPlayListManager.ToString); //  Integer;

    if Parametros.TipoBanco>0 then
      LJSONModulo_TV.AddPair('TIPOBANCO',                    Parametros.TipoBanco.ToString); //  Integer;

    if Parametros.IntervaloVerificacao>0 then
      LJSONModulo_TV.AddPair('INTERVALOVERIFICACAO',         Parametros.IntervaloVerificacao.ToString); //  Integer;

    //if Parametros.LayoutSenhaAlinhamento>0 then
    LJSONModulo_TV.AddPair('LAYOUTSENHAALINHAMENTO',       Parametros.LayoutSenhaAlinhamento.ToString); // Integer;

    //if Parametros.LayoutPAAlinhamento>0 then
    LJSONModulo_TV.AddPair('LAYOUTPAALINHAMENTO',          Parametros.LayoutPAAlinhamento.ToString); // Integer;

    //if Parametros.LayoutNomeClienteAlinhamento>0 then
    LJSONModulo_TV.AddPair('LAYOUTNOMECLIENTEALINHAMENTO', Parametros.LayoutNomeClienteAlinhamento.ToString); // Integer;

    if Parametros.SomVozChamada0>0 then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA0',               Parametros.SomVozChamada0.ToString); // Integer;

    if Parametros.SomVozChamada1>0 then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA1',               Parametros.SomVozChamada1.ToString); // Integer;

    if Parametros.SomVozChamada2>0 then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA2',               Parametros.SomVozChamada2.ToString); // Integer;

    if Parametros.VoiceIndex>0 then
      LJSONModulo_TV.AddPair('VOICEINDEX',                   Parametros.VoiceIndex.ToString); // Integer;

    LJSONModulo_TV.AddPair('ATUALIZACAOPLAYLIST',          DateToStr(Parametros.AtualizacaoPlaylist)); // TDate;

    if Parametros.Transparente then
      LJSONModulo_TV.AddPair('TRANSPARENTE',                 IfThen(Parametros.Transparente, 'T', 'F')); // Boolean;

    if Parametros.Negrito then
      LJSONModulo_TV.AddPair('NEGRITO',                      IfThen(Parametros.Negrito, 'T', 'F')); // Boolean;

    if Parametros.Italico then
      LJSONModulo_TV.AddPair('ITALICO',                      IfThen(Parametros.Italico, 'T', 'F')); // Boolean;

    if Parametros.Sublinhado then
      LJSONModulo_TV.AddPair('SUBLINHADO',                   IfThen(Parametros.Sublinhado, 'T', 'F')); // Boolean;

    if Parametros.MostrarSenha then
      LJSONModulo_TV.AddPair('MOSTRARSENHA',                 IfThen(Parametros.MostrarSenha, 'T', 'F')); // Boolean;

    if Parametros.MostrarPA then
      LJSONModulo_TV.AddPair('MOSTRARPA',                    IfThen(Parametros.MostrarPA, 'T', 'F')); // Boolean;

    if Parametros.MostrarNomeCliente then
      LJSONModulo_TV.AddPair('MOSTRARNOMECLIENTE',           IfThen(Parametros.MostrarNomeCliente, 'T', 'F')); // Boolean;

    if Parametros.SomArquivo then
      LJSONModulo_TV.AddPair('SOMARQUIVO',                   IfThen(Parametros.SomArquivo, 'T', 'F')); // Boolean;

    if Parametros.SomVoz then
      LJSONModulo_TV.AddPair('SOMVOZ',                       IfThen(Parametros.SomVoz, 'T', 'F')); // Boolean;

    if Parametros.SomVozChamada1Marcado then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA1MARCADO',        IfThen(Parametros.SomVozChamada1Marcado, 'T', 'F')); //Boolean;

    if Parametros.SomVozChamada2Marcado then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA2MARCADO',        IfThen(Parametros.SomVozChamada2Marcado, 'T', 'F')); // Boolean;

    if Parametros.SomVozChamada3Marcado then
      LJSONModulo_TV.AddPair('SOMVOZCHAMADA3MARCADO',        IfThen(Parametros.SomVozChamada3Marcado, 'T', 'F')); // Boolean;

    if Parametros.DisposicaoLinhas then
      LJSONModulo_TV.AddPair('DISPOSICAOLINHAS',             IfThen(Parametros.DisposicaoLinhas, 'T', 'F')); // Boolean;

    if Parametros.ValorAcompanhaCorDoNivel then
      LJSONModulo_TV.AddPair('VALORACOMPANHACORDONIVEL',     IfThen(Parametros.ValorAcompanhaCorDoNivel, 'T', 'F')); // Boolean;

    vgParametrosModulo.JaEstaConfigurado        := False;
    vgParametrosModulo.JaEstaConfiguradoPaineis := False;

    LJsonArray := TJSONArray.Create;
    LJsonArray.AddElement(LJSONModulo_TV);

    //dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($46) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4) + LJsonArray.ToJSON, 0);
  finally
    Result := LJSONModulo_TV;
  end;
end;
{$ENDREGION 'procedure SalvarParametrosTVPaineis'}

{$REGION 'procedure LoadPanel'}
procedure LoadPanel (no : integer);
var
  IniFile              : TIniFile;
  LPainel              : Integer;
begin
  LPainel := High(vgParametrosModulo.Paineis);

  IniFile := TIniFile.Create(GetAppIniFileName);

  try
    vgParametrosModulo.ChamadaInterrompeVideo                 := IniFile.ReadBool    ('Settings'  , 'ChamadaInterrompeVideo'         , false  );
    vgParametrosModulo.PortaIPPainel                          := IniFile.ReadInteger ('Settings'  , 'PortaIPPainel'                  , 3001   );
    vgParametrosModulo.MaximizarMonitor1                      := IniFile.ReadBool    ('Settings'  , 'MaximizarMonitor1'              , false  );
    vgParametrosModulo.MaximizarMonitor2                      := IniFile.ReadBool    ('Settings'  , 'MaximizarMonitor2'              , false  );
    vgParametrosModulo.IdTV                                   := IniFile.ReadInteger ('Settings'  , 'IdTV'                           , 0      ); // Integer;
    vgParametrosModulo.IndicadoresPermitidos                  := IniFile.ReadString  ('Settings'  , 'IndicadoresPermitidos'          , ''     ); // string;
    vgParametrosModulo.Volume                                 := IniFile.ReadInteger ('VisioForge', 'Volume'                         , 0      ); // integer;
    vgParametrosModulo.FuncionaSabado                         := IniFile.ReadBool    ('Settings'  , 'FuncionaSabado'                 , False  ); // Boolean;
    vgParametrosModulo.FuncionaDomingo                        := IniFile.ReadBool    ('Settings'  , 'FuncionaDomingo'                , False  ); // Boolean;
    vgParametrosModulo.DeH                                    := IniFile.ReadInteger ('Settings'  , 'DeH'                            , 0      ); // Integer;
    vgParametrosModulo.DeM                                    := IniFile.ReadInteger ('Settings'  , 'DeM'                            , 0      ); // Integer;
    vgParametrosModulo.AteH                                   := IniFile.ReadInteger ('Settings'  , 'AteH'                           , 0      ); // Integer;
    vgParametrosModulo.AteM                                   := IniFile.ReadInteger ('Settings'  , 'AteM'                           , 0      ); // Integer;
    vgParametrosModulo.LastMute                               := IniFile.ReadInteger ('ACTIVE'    , 'LastMute'                       , 0      ); // Integer;

    vgParametrosModulo.Paineis[LPainel].Tipo                  := IniFile.ReadInteger ('Panel'+inttostr(no), 'Tipo'                 , 1     );
    vgParametrosModulo.Paineis[LPainel].Left                  := IniFile.ReadInteger ('Panel'+inttostr(no), 'Left'                 , 0     );
    vgParametrosModulo.Paineis[LPainel].Top                   := IniFile.ReadInteger ('Panel'+inttostr(no), 'Top'                  , 0     );
    vgParametrosModulo.Paineis[LPainel].Height                := IniFile.ReadInteger ('Panel'+inttostr(no), 'Height'               , 0     );
    vgParametrosModulo.Paineis[LPainel].Width                 := IniFile.ReadInteger ('Panel'+inttostr(no), 'Width'                , 0     );
    vgParametrosModulo.Paineis[LPainel].Color                 := TColor(IniFile.ReadInteger('Panel'+inttostr(no), 'Color'          , 0     ));
    vgParametrosModulo.Paineis[LPainel].Transparente          := IniFile.ReadBool    ('Panel'+inttostr(no), 'Transparent'          , false );

    vgParametrosModulo.Paineis[LPainel].BackgroundFile        := IniFile.ReadString  ('Panel'+inttostr(no), 'BackgroundFile'       , '');

    vgParametrosModulo.Paineis[LPainel].Fonte                 := IniFile.ReadString  ('Panel'+inttostr(no), 'Fonte'                , 'Arial'     ) ;
    vgParametrosModulo.Paineis[LPainel].FonteSize             := IniFile.ReadInteger ('Panel'+inttostr(no), 'FonteSize'            , 12          ) ;
    vgParametrosModulo.Paineis[LPainel].FonteColor            := TColor(IniFile.ReadInteger ('Panel'+inttostr(no), 'FonteColor'    , ord(clBlack)));

    vgParametrosModulo.Paineis[LPainel].Negrito               := IniFile.ReadBool    ('Panel'+inttostr(no), 'Negrito'              , false    );
    vgParametrosModulo.Paineis[LPainel].Italico               := IniFile.ReadBool    ('Panel'+inttostr(no), 'Italico'              , false    );
    vgParametrosModulo.Paineis[LPainel].Sublinhado            := IniFile.ReadBool    ('Panel'+inttostr(no), 'Sublinhado'           , false    );

    vgParametrosModulo.Paineis[LPainel].MostrarSenha          := IniFile.ReadBool    ('Panel'+inttostr(no), 'MostrarSenha'         , false    );
    vgParametrosModulo.Paineis[LPainel].LayoutSenhaX          := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutSenhaX'         , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutSenhaY          := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutSenhaY'         , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutSenhaLarg       := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutSenhaLarg'      , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutSenhaAlt        := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutSenhaAlt'       , 0);

    vgParametrosModulo.Paineis[LPainel].MostrarPA             := IniFile.ReadBool    ('Panel'+inttostr(no), 'MostrarPA'            , false    );
    vgParametrosModulo.Paineis[LPainel].LayoutPAX             := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutPAX'            , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutPAY             := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutPAY'            , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutPALarg          := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutPALarg'         , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutPAAlt           := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutPAAlt'          , 0);

    vgParametrosModulo.Paineis[LPainel].MostrarNomeCliente    := IniFile.ReadBool    ('Panel'+inttostr(no), 'MostrarNomeCliente'   , false    );
    vgParametrosModulo.Paineis[LPainel].LayoutNomeClienteX    := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutNomeClienteX'   , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutNomeClienteY    := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutNomeClienteY'   , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutNomeClienteLarg := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutNomeClienteLarg', 0);
    vgParametrosModulo.Paineis[LPainel].LayoutNomeClienteAlt  := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutNomeClienteAlt' , 0);

    vgParametrosModulo.Paineis[LPainel].PASPermitidas                := IniFile.ReadString  ('Panel'+inttostr(no), 'PASPermitidas'          , '');
    vgParametrosModulo.Paineis[LPainel].SomArquivo                   := IniFile.ReadBool    ('Panel'+inttostr(no), 'SomArquivo'             , false);
    vgParametrosModulo.Paineis[LPainel].SomVoz                       := IniFile.ReadBool    ('Panel'+inttostr(no), 'SomVoz'                 , false);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada0               := IniFile.ReadInteger ('Panel'+inttostr(no), 'SomVozChamada0'         , 0);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada1               := IniFile.ReadInteger ('Panel'+inttostr(no), 'SomVozChamada1'         , 0);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada2               := IniFile.ReadInteger ('Panel'+inttostr(no), 'SomVozChamada2'         , 0);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada1Marcado        := IniFile.ReadBool    ('Panel'+inttostr(no), 'SomVozChamada1Marcado'  , false);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada2Marcado        := IniFile.ReadBool    ('Panel'+inttostr(no), 'SomVozChamada2Marcado'  , false);
    vgParametrosModulo.Paineis[LPainel].SomVozChamada3Marcado        := IniFile.ReadBool    ('Panel'+inttostr(no), 'SomVozChamada3Marcado'  , false);
    vgParametrosModulo.Paineis[LPainel].VoiceIndex                   := IniFile.ReadInteger ('Panel'+inttostr(no), 'VoiceIndex'             , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutSenhaAlinhamento       := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutSenhaAlinhamento' , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutPAAlinhamento          := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutPAAlinhamento'    , 0);
    vgParametrosModulo.Paineis[LPainel].LayoutNomeClienteAlinhamento := IniFile.ReadInteger ('Panel'+inttostr(no), 'LayoutNomeClienteAlinhamento' , 0);

    vgParametrosModulo.Paineis[LPainel].ArquivoSom                   := IniFile.ReadString  ('Panel'+inttostr(no), 'ArquivoSom'           , '');
    vgParametrosModulo.Paineis[LPainel].FlashFile                    := IniFile.ReadString  ('Panel'+inttostr(no), 'FlashFile'            , '');

    vgParametrosModulo.Paineis[LPainel].IntervaloVerificacao         := IniFile.ReadInteger ('Panel'+inttostr(no), 'Interval'             , 15);

    vgParametrosModulo.Paineis[LPainel].SoftwareHomologado           := IniFile.ReadInteger ('Panel'+inttostr(no), 'SoftwareHomologado'   , -1);
    vgParametrosModulo.Paineis[LPainel].CaminhoDoExecutavel   := IniFile.ReadString  ('Panel'+inttostr(no), 'CaminhoDoExecutavel'  , '');
    vgParametrosModulo.Paineis[LPainel].NomeDaJanela          := IniFile.ReadString  ('Panel'+inttostr(no), 'NomeDaJanela'         , '');
    vgParametrosModulo.Paineis[LPainel].Dispositivo           := IniFile.ReadInteger ('Panel'+inttostr(no), 'Dispositivo'          , -1);
    vgParametrosModulo.Paineis[LPainel].Resolucao             := IniFile.ReadInteger ('Panel'+inttostr(no), 'Resolucao'            , -1);
    vgParametrosModulo.Paineis[LPainel].ResolucaoPadrao       := IniFile.ReadString  ('Panel'+inttostr(no), 'ResolucaoPadrao'      , '0x0');
    vgParametrosModulo.Paineis[LPainel].TempoAlternancia      := IniFile.ReadInteger ('Panel'+inttostr(no), 'TempoAlternancia'     ,  0);

    //vgParametrosModulo.Paineis[LPainel].volume := ReadInteger('VisioForge', 'Volume', 800);

    vgParametrosModulo.Paineis[LPainel].ArquivosVideo         := StringReplace(IniFile.ReadString('Panel'+inttostr(No), 'ArquivosVideo' , ''), '|', #13 + #10, [rfReplaceAll]);
    //vgParametrosModulo.Paineis[LPainel].IDTV                 := IniFile.ReadInteger('Panel'+inttostr(no), 'IDTVPlayListManager', 0);
    vgParametrosModulo.Paineis[LPainel].TipoBanco             := IniFile.ReadInteger ('Panel'+inttostr(no), 'TipoBanco'           , 0);
    vgParametrosModulo.Paineis[LPainel].HostBanco             := IniFile.ReadString  ('Panel'+inttostr(no), 'HostBanco'           , '');
    vgParametrosModulo.Paineis[LPainel].PortaBanco            := IniFile.ReadString  ('Panel'+inttostr(no), 'PortaBanco'          , '');
    vgParametrosModulo.Paineis[LPainel].NomeArquivoBanco      := IniFile.ReadString  ('Panel'+inttostr(no), 'NomeArquivoBanco'    , '');
    vgParametrosModulo.Paineis[LPainel].UsuarioBanco          := IniFile.ReadString  ('Panel'+inttostr(no), 'UsuarioBanco'        , '');
    vgParametrosModulo.Paineis[LPainel].SenhaBanco            := IniFile.ReadString  ('Panel'+inttostr(no), 'SenhaBanco'          , '');
    vgParametrosModulo.Paineis[LPainel].DiretorioLocal        := IniFile.ReadString  ('Panel'+inttostr(no), 'DiretorioLocal'      , '');
    vgParametrosModulo.Paineis[LPainel].IntervaloVerificacao  := IniFile.ReadInteger ('Panel'+inttostr(no), 'IntervaloVerificacao', 10);
    vgParametrosModulo.Paineis[LPainel].AtualizacaoPlayList   := IniFile.ReadDateTime('Panel'+inttostr(no), 'AtualizacaoPlayList' , Now);
  finally
    IniFile.Free;
  end;  { try .. finally }
end;
{$ENDREGION 'procedure LoadPanel'}

end.
