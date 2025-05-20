unit untParametroBaseINI;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  System.Generics.Collections, SysUtils, System.Types, Classes, IniFiles, Datasnap.DBClient, System.Generics.defaults,
  {$IFDEF FIREMONKEY}
  FMX.Types, FMX.StdCtrls, AspPanel, AspLabelFMX, AspGroupBox,  AspButton,
  {$ENDIF}

  {$IFDEF SuportaDLL}MyDlls_DX,  ClassLibraryVCL, AspectVCL, {$ELSE}ClassLibrary, Aspect, AspComponenteUnidade,{$ENDIF SuportaDLL}
  System.UITypes, System.IOUtils, AspFuncoesUteis;

type
  {$IFDEF SuportaDLL}
  TTipoTela = (tcParametrosModulo);
  {$ENDIF SuportaDLL}

  TParametrosModuloBase = class(TComponent)
  strict private
    FConfiguradoParametrosModulo: Boolean;
  protected
    procedure SetConfiguradoParametrosModulo(const Value: Boolean); Virtual;
  public
    function GetDescModulo: String; Virtual;
    /// <summary>
    ///   Inicializa os valores da variável quando não existe no INI são esses valores que
    ///  ficarão em vigor.
    /// </summary>
    procedure SetValoresDefault; Virtual;
    class function GetTipoTela: TTipoTela; Virtual;
    constructor Create(aOwner: TComponent); Override;

    /// <summary>
    ///  Indica se já efetuou a leitura total do parâmetros no INI.
    /// </summary>
    property ConfiguradoParametrosModulo: Boolean read FConfiguradoParametrosModulo write SetConfiguradoParametrosModulo;
  end;

  TParametrosModuloIniBase = class(TParametrosModuloBase)
  protected
    procedure SetConfiguradoParametrosModulo(const Value: Boolean); Override;
  public
    procedure BeforeDestruction; override;
    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    /// <summary>
    ///  Le no arquivo ini os parâmetros configurados e
    ///  caso não exista os parâmetros ou ini o valor do parâmetro fico o padrão
    ///  definido no método SetValoresDefault;
    /// </summary>
    procedure CarregaParametrosPorIni; Virtual;
    /// <summary>
    ///  Grava no arquivo ini os novos valores do parâmetro
    /// </summary>
    procedure SalvarParametrosPorIni; Virtual;
    procedure SetValoresDefault; Override;
    /// <summary>
    ///  Grava ou lê do arquivo ini os novos valores do parâmetro
    /// </summary>
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Virtual;
  end;


  TParametrosModuloBaseConfigIni = class(TParametrosModuloIniBase)
  public
    ArqUpdateDir: String;

    {$IF not (Defined(CompilarPara_SICS) or Defined(CompilarPara_Config))}
    IdModulo: Integer;
    DBDir: String;
    TCPSrvPort: Integer;
    TCPSrvAdr: String;
    TCPSrvAdrContingencia: String;
    IntervaloReceberComando: Integer;
    IntervaloReconectar: Integer;
    BotaoConfiguracaoTransparente: Boolean;
    BotaoConfiguracaoVisivel: Boolean;
    property TCPSrvPortContingencia: Integer read TCPSrvPort;
    {$ENDIF}
    procedure SetValoresDefault; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;

  /// <summary>
  ///   Lista de objetos que destroi os objetos filho ao ser destruida.
  /// </summary>
  TListOwner<TObject> = class(TList<TObject>)
  public
    Owner: TComponent;
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; Override;
  end;
  
  /// <summary>
  ///   Configuração de caminho do servidor por unidade
  ///  Utilizado para o Config, Online e TGS poder alterar o servidor ativo.
  /// </summary>
  TParametroUnidade = class(TParametrosModuloIniBase)
  public
    IdUnidade: Integer;
    Unidade: String;
    BaseOnLine: String;
    BaseRelatorios: String;
    Endereco: String;
    Porta: Integer;
    DBDir: String;
    constructor Create(aOwner: TComponent); Override;
  end;

  TListaUnidades = class(TListOwner<TParametroUnidade>)
  public
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Virtual;
  end;

  TParametrosModuloBase_PA_MPA_TGSIni = class(TParametrosModuloBaseConfigIni)
  public
    CodebarPort: String;
    procedure SetValoresDefault; Override;
    procedure CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean); Override;
  end;
  
implementation
uses Sics_Common_Parametros, untLog;



{ TParametrosModuloIniBase }

procedure TParametrosModuloIniBase.BeforeDestruction;
begin
  SalvarParametrosPorIni;
  inherited;

end;

procedure TParametrosModuloIniBase.CarregaParametrosPorIni;
begin
  inherited;
  CarregarOuSalvarParametrosPorIni(False);
  ConfiguradoParametrosModulo := True;
end;

procedure TParametrosModuloIniBase.CarregarOuSalvarParametrosPorIni(
  const aSalvar: Boolean);
begin

end;

class function TParametrosModuloBase.GetTipoTela: TTipoTela;
begin
  Result := tcParametrosModulo;
end;

procedure TParametrosModuloBaseConfigIni.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  inherited;
  ArqUpdateDir := WriteOrReadSettings(aSalvar, cSettings, 'ArqUpdateDir', ArqUpdateDir);

  {$IF not (Defined(CompilarPara_SICS) or Defined(CompilarPara_Config))}
  DBDir := WriteOrReadSettings(aSalvar, cSettings, 'DBDir', DBDir);
  TCPSrvAdr := WriteOrReadSettings(aSalvar, SecaoConexoes, IdentTCPSrvAdr, TCPSrvAdr);
  TCPSrvPort := StrToIntDef(WriteOrReadSettings(aSalvar, SecaoConexoes, IdentiTCPSrvPort, TCPSrvPort), 0);
  IdModulo := StrToIntDef(WriteOrReadSettings(aSalvar, cSettings, IdentIdModulo, IdModulo, True), 0);
  TCPSrvAdrContingencia := WriteOrReadSettings(aSalvar, SecaoConexoes, 'TCPSrvAdrContingencia', TCPSrvAdrContingencia);
  IntervaloReceberComando := WriteOrReadSettings(aSalvar, SecaoConexoes, 'IntervaloReceberComando', IntervaloReceberComando);
  IntervaloReconectar := WriteOrReadSettings(aSalvar, SecaoConexoes, 'IntervaloReconectar', IntervaloReconectar);
  BotaoConfiguracaoTransparente := WriteOrReadSettings(aSalvar, SecaoConexoes, 'BotaoConfiguracaoTransparente', BotaoConfiguracaoTransparente);
  BotaoConfiguracaoVisivel := WriteOrReadSettings(aSalvar, SecaoConexoes, 'BotaoConfiguracaoVisivel', BotaoConfiguracaoVisivel);
  {$ENDIF}
end;

{$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_PA_MULTIPA)}
procedure TParametrosModuloBase_PA_MPA_TGSIni.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
begin
  inherited;
  CodebarPort := WriteOrReadSettings(aSalvar, cSettings, 'CodeBarPort', CodebarPort);
end;


procedure TParametrosModuloBase_PA_MPA_TGSIni.SetValoresDefault;
begin
  inherited;
  CodebarPort := 'com1';
end;
{$ENDIF}

constructor TParametrosModuloIniBase.Create(aOwner: TComponent);
begin
  inherited;
  TLog.OnGetDescModulo := GetDescModulo;

end;

destructor TParametrosModuloIniBase.Destroy;
begin
  TLog.OnGetDescModulo := nil;

  inherited;
end;

procedure TParametrosModuloIniBase.SetConfiguradoParametrosModulo(const Value: Boolean);
begin
  if (ConfiguradoParametrosModulo = Value) then
    Exit;
  inherited;
  {$IFNDEF SuportaDLL}
  if Value and Assigned(FListaFormComponentesDesabilitados) then
    FListaFormComponentesDesabilitados.CarregarParametrosINIForAll;
  {$ENDIF !SuportaDLL}
end;

procedure TParametrosModuloBase.SetConfiguradoParametrosModulo(const Value: Boolean);
begin
  FConfiguradoParametrosModulo := Value;
end;

procedure TParametrosModuloBaseConfigIni.SetValoresDefault;
begin
  inherited;

  ArqUpdateDir := '';
  {$IF not (Defined(CompilarPara_SICS) or Defined(CompilarPara_Config))}

  {$IFDEF Debug}
  BotaoConfiguracaoTransparente := False;
  {$ELSE}
  BotaoConfiguracaoTransparente := True;
  {$ENDIF Debug}
  BotaoConfiguracaoVisivel := True;
  TCPSrvAdr := IP_DEFAULT;
  DBDir := '';
  TCPSrvPort := PortaPadrao;
  IdModulo := 0;
  TCPSrvAdrContingencia := '';
  IntervaloReceberComando := 1000;
  IntervaloReconectar := 5000;
  {$ENDIF}
end;

procedure TParametrosModuloIniBase.SalvarParametrosPorIni;
begin
  CarregarOuSalvarParametrosPorIni(True);
end;

procedure TParametrosModuloBase.SetValoresDefault;
begin

end;


procedure TParametrosModuloIniBase.SetValoresDefault;
begin
  inherited;
  ConfiguradoParametrosModulo := False;
end;

  {$IF Defined(CompilarPara_SICS) or Defined(CompilarPara_CONFIG) or Defined(CompilarPara_TGS) or Defined(CompilarPara_ONLINE)}
{ TParametroUnidade }

constructor TParametroUnidade.Create(aOwner: TComponent);
begin
  IdUnidade := 0;
  Unidade := '';
  BaseOnLine := '';
  BaseRelatorios := '';
  Endereco := '';
  Porta := 0;
  DBDir := '';
  inherited;
end;

{ TListaUnidades }

procedure TListaUnidades.CarregarOuSalvarParametrosPorIni(const aSalvar: Boolean);
var
  aUnidade: TParametroUnidade;
  indexUnidade: Integer;
  LCriarParametro: Boolean;
begin
  for indexUnidade := 1 to cgMaxUnidades do
  begin
    LCriarParametro := Count < indexUnidade;

    if LCriarParametro then
    begin
      if (aSalvar and (indexUnidade > 1)) then
        Break;

      aUnidade := TParametroUnidade.Create(Owner);
    end
    else
      aUnidade := Items[indexUnidade-1];

    try
      aUnidade.IdUnidade      := indexUnidade;
      aUnidade.Unidade        := WriteOrReadSettings(aSalvar, 'Unidades', 'Unidade' + inttostr(indexUnidade), aUnidade.Unidade, aSalvar);
      aUnidade.BaseOnLine     := WriteOrReadSettings(aSalvar, 'Unidades', 'BaseOnLine' + inttostr(indexUnidade), aUnidade.BaseOnLine, aSalvar);
      aUnidade.BaseRelatorios := WriteOrReadSettings(aSalvar, 'Unidades', 'BaseRelatorios' + inttostr(indexUnidade), aUnidade.BaseRelatorios, aSalvar);
      aUnidade.Endereco       := WriteOrReadSettings(aSalvar, 'Unidades', 'EnderecoIP' + inttostr(indexUnidade), aUnidade.Endereco, aSalvar);
      aUnidade.Porta          := WriteOrReadSettings(aSalvar, 'Unidades', 'PortaIP' + inttostr(indexUnidade), aUnidade.Porta, aSalvar);
      aUnidade.DBDir          := WriteOrReadSettings(aSalvar, 'Unidades', 'DBDir' + inttostr(indexUnidade), aUnidade.DBDir, aSalvar);
     { if (indexUnidade = 1) then
      begin
        aUNidade.Unidade := 'Unidade 2';
        aUNidade.Endereco := 'localhost';
        aUNidade.Porta := 6602;
        aUNidade.BaseOnLine := 'C:\SICSBASEv5Unid2.FDB';
        aUNidade.BaseRelatorios := 'C:\SICSBASEv5Unid2.FDB';
      end;    }
    finally
      if (aUnidade.Unidade <> '') and ((aUnidade.BaseOnLine <> '') or (aUnidade.BaseRelatorios <> '')) then
      begin
        if (LCriarParametro) then
          Insert(indexUnidade -1, aUnidade);
      end
      else
      begin
        if not LCriarParametro then
          Delete(indexUnidade -1);

        FreeAndNil(aUnidade);
      end;
    end;
  end;
end;
{$ENDIF}


{ TListOwner<T> }

constructor TListOwner<TObject>.Create(AOwner: TComponent);
begin
  inherited Create;
  Owner := AOwner;
end;

destructor TListOwner<TObject>.Destroy;
var
  i: Integer;
  LObje: TObject;
begin
  for i := self.Count -1 downto 0 do
  begin
    LObje := Self.Items[i];
    Self.remove(LObje);
    FreeAndNil(LObje);
  end;
  inherited;
end;


constructor TParametrosModuloBase.Create(aOwner: TComponent);
begin
  FConfiguradoParametrosModulo := False;
  inherited;
end;

function TParametrosModuloBase.GetDescModulo: String;
begin
  Result := '';

  {$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_PA_MULTIPA) or
    Defined(CompilarPara_SICSTV) or Defined(CompilarPara_ONLINE)}
  if Assigned(ParametrosModuloIni) then
    Result := 'ID Módulo: ' + IntToStr(ParametrosModuloIni.IdModulo);
  {$ENDIF}

  {$IFDEF CompilarPara_PA}
  if ASsigned(ParametrosModuloDB) then
    Result := Result + ' ID PA: ' + IntToStr(ParametrosModuloDB.IdPA);
  {$ENDIF CompilarPara_PA}

end;

end.
