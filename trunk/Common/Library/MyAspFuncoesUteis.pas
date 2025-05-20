unit MyAspFuncoesUteis;

interface

{$IF Defined(CompilarPara_SICS) or Defined(CompilarPara_TGS) or
     Defined(CompilarPara_PA) or Defined(CompilarPara_MULTIPA) or
     Defined(CompilarPara_CONFIG) or Defined(CompilarPara_ONLINE) or
     Defined(CompilarPara_CALLCENTER) or Defined(CompilarPara_TOTEMTOUCH)}
  {$INCLUDE ..\AspDefineDiretivas.inc}
{$ELSE}
  {$DEFINE SuportaSMS}
  {$DEFINE SuportaPing}
  {$DEFINE SuportaEmail}
  {$IFDEF NEXTGEN}{$DEFINE IS_MOBILE}{$ENDIF}
{$ENDIF}

uses
  {$IFNDEF AplicacaoFiremokeySemVCL}
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.ExtCtrls,
  {$ENDIF AplicacaoFiremokeySemVCL}

{$IFDEF FIREMONKEY}
  FMX.Ani,
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Bind.Grid,
  {AspFMXHelper}
  Data.Bind.Grid,
  Data.Bind.Components,
  Data.Bind.DBScope,
  {AspFMXHelper}
  FMX.Controls,
  FMX.DateTimeCtrls,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Effects,
  FMX.Filter,
  FMX.Forms,
  FMX.Graphics,
  FMX.Grid,

  FMX.Layouts,
  FMX.ListBox,
  FMX.Menus,
  FMX.Objects,
  FMX.Platform,
  FMX.StdCtrls,
  FMX.TreeView,
  FMX.Types,

{$ENDIF FIREMONKEY}


{$IFNDEF IS_MOBILE}
  Winapi.ShellAPI,
  WinAPI.Windows,
  WinAPI.Messages,
  {$IFDEF FIREMONKEY}
  FMX.Platform.Win,
  {$ENDIF FIREMONKEY}
{$ENDIF IS_MOBILE}

{$IFDEF ANDROID}
  Androidapi.JNI.App,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Provider,
  Androidapi.JNI.Telephony,
  Androidapi.JNIBridge,
  FMX.Helpers.Android,
  FMX.Platform.Android,
{$ENDIF ANDROID}

{$IFDEF IOS}
  iOSapi.UIKit,
{$ENDIF IOS}

  Data.DB,
  FireDac.Comp.Client,

  FireDac.DApt,
  {$IFNDEF IS_MOBILE}
  FireDac.Phys.FB,
  {$ENDIF}
  IdGlobal,
  IdHashMessageDigest,
  IdHTTP,

  IdIPWatch,
  IdSNTP,
  IdTCPClient,

  System.Bindings.Outputs,
  System.Character,
  System.Classes,
  System.ConvUtils,


  System.IniFiles,
  System.IOUtils,

  System.MaskUtils,
  System.Math,

  System.Rtti,
  System.Sensors,
  System.StrUtils,
  System.SyncObjs,

  System.SysUtils,
  System.Types,
  System.TypInfo,

  System.UITypes,
  System.Variants,
  System.VarUtils,

  DataSnap.DBClient,
  {Aspect}
  System.UIConsts,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,
  Data.SqlExpr,
  {Aspect}
  {$IFNDEF IS_MOBILE}
  System.Win.Registry,
  {$ENDIF}
  {$IFDEF SuportaPortaCom}
  VaComm,
  {$ENDIF SuportaPortaCom}
  Xml.xmldom;

const
 {$REGION 'AspInterfaces'}
 {$IFDEF FIREMONKEY}
  claBtnFace = TAlphaColor($FFE0E0E0);
  claWindowText = claBtnFace;
  claGrayText = System.UIConsts.claGray;
 {$ENDIF FIREMONKEY}
 {$ENDREGION}

 {$REGION 'CLassLibrary'}
  cKey = 'M7WYLF9K81IP0RLV';

  cNumbers = '0123456789';
  cLetters = 'ABCDEFGHIJKLMNOPQRSTUVXWYZ';

  cMyComponents = 'My Components';
  cSettings     = 'Settings';
  cDriverName   = 'DriverName';
  cDatabase     = 'Database';
  cSelect       = 'SELECT';

  cDecimalDigits  = 2;
  cCurrencyFormat = '#,##0.00';

  {$ENDREGION}

  {$REGION 'Aspect'}
  CHAR_FALSO = 'F';
  {$ENDREGION}

  type

{$REGION 'AspEncode'}
TAspEncode = class
     class function AspCharToEncode(const aChar: Char): Integer;
     class function AspANSIToUTF8(const aChar: Char): Integer;
     class function AspIntToHex(const Value: Integer; const Digits: Integer = 4): string;
end;
{$ENDREGION}

  {$REGION 'AspFMXHelper'}
  TGetDataSetLinkGrid = reference to function (const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet;
  TGridHelper = class helper for FMX.Grid.TCustomGrid
  public
    function SelectedColumn: TColumn;
    function ColumnByHeader(const aHeader: String): TColumn;
    function GetFieldNameByColumn(const aColumn: TColumn; const aBinding: TBindingsList): string;
    function GetColumnByFieldName(const aFieldName: string; const aBinding: TBindingsList): TColumn; Overload;
    function GetColumnByFieldName(const aFieldName: string; const aLinkGridToDataSource: TLinkGridToDataSource): TColumn; Overload;
  end;
  TAspLinkGridToDataSource = class(TLinkGridToDataSource)
  protected
    procedure Reactivate; Override;
    function RequiresControlHandler: Boolean; Override;
  public
    NomeColunaAllCliente: String;
    constructor Create(aOwner: Tcomponent); Override;
  end;

  TComboBoxHelper = class helper for FMX.ListBox.TComboBox
  private
    function GetKeyValue(const aDataSet: TDataSet; const aKeyField: String): Variant;
    procedure SetKeyValue(const aDataSet: TDataSet; const aKeyField: String; const Value: Variant);
  public
	 property KeyValue[const aDataSet: TDataSet; const aKeyField: String]: Variant read GetKeyValue write SetKeyValue;
	 procedure Import(const aDataSet: TDataSet; const aDisplayFieldName: String);
  end;

  TMenuItemHelper = class helper for FMX.Menus.TMenuItem
  public
    procedure CheckedAll(const aIsChecked: Boolean = True); Overload;
    procedure CheckedAll(MenuPai: TMenuItem; const aIsChecked: Boolean = True); Overload;
    function GetItemChecked(MenuPai: TMenuItem): TMenuItem; Overload;
    function GetItemChecked: TMenuItem; Overload;
  end;

  TPopupMenuHelper = class helper for FMX.Menus.TPopupMenu
  public
    procedure CheckedAll(const aIsChecked: Boolean = True);
    function GetItemChecked: TMenuItem;
  end;
   {$ENDREGION}

  {$REGION 'AspFuncoesUteis'}

  TLogExcecao = procedure (const psMessage: string; aControler: Tobject) of object;

  TArrayOfString = array of String;

  /// <summary>
  ///   Lista de pointeiros da vari·vel. Assim permite alterar o valor da v·riavel.
  /// Exemplo: var aForm: TForm; aForm := TFormSelecao.create; permite que em outros
  /// locais\unit altere o valor da vari·vel "aForm". Exemplo TFormCadPessoa.limpar executa ListaReference[i] := nil;
  /// </summary>
  TListReferencesVar = array of Pointer;

  /// <summary>
  ///   Classe de exceÁ„o que grava no arquivo de log todas
  ///  as exceÁıes criados
  /// </summary>
  TAspException = class(Exception)
  protected
    function GetMessage: string; Virtual;
    procedure SetMessage(const Value: string); Virtual;
  public
    Owner: TComponent;
    class var FLogExcecao: TLogExcecao;
    procedure ParserLog;
    constructor Create(const aOwner: TComponent; const Msg: string); virtual;
    constructor CreateFmt(const aOwner: TComponent; const Msg: string; const Args: array of const); virtual;
    property Message: string read GetMessage write SetMessage;
    destructor Destroy; Override;
  end;

  TConexaoIP = record
                 EnderecoIP : string;
                 PortaIP    : integer;
               end;

  TConexaoIPArray = array of TConexaoIP;
  {$ENDREGION}

  {$REGION 'ClassLibrary'}
  {$IF not Defined(CompilarPara_SICS)}
  TIntArray = TIntegerDynArray;
  {$ENDIF}
  TAspAnsiChar = {$IFNDEF IS_MOBILE}AnsiChar{$ELSE}Char{$ENDIF IS_MOBILE};
  TAspAnsiString = {$IFNDEF IS_MOBILE}AnsiString{$ELSE}String{$ENDIF IS_MOBILE};
  TClassLibrary = class
  public
    class procedure ErrorHandling(Sender: TObject; E: Exception); overload;
  end;

  TProcedure = reference to procedure;

  TMultiThread = class(TThread)
  private

    FExecute  : TProcedure;
    FTerminate: TProcedure;

    FProgressForm: TForm;

    FShowProgress: Boolean;
    FMessage     : string;

    procedure ShowProgressForm;
    procedure CloseProgressForm;

  protected

    procedure Execute; override;

    procedure DoInternalTerminate(Sender: TObject);

  public
    constructor Create(AExecute, ATerminte: TProcedure; AShowProgressForm: Boolean; AMessage: string);

    procedure Start;
  end;

  TDevice = record
    Architecture: TOSVersion.TArchitecture;
    ArchitectureName: string;
    Platform: TOSVersion.TPlatform;
    PlatformName: string;
    IMEI: string;
    SerialNumber: string;
    Country: string;
    Carrier: string;
    CarrierName: string;
    LineNumber: string;
  end;

  TSettings = record
  end;

  THashMode = (hmFile, hmText);

  TRequestMode = (rmGet, rmPost);

  TEncryptionMode = (emEncrypt, emDecrypt);

  TClassMember = (cmField, cmProperty, cmMethod);

  TDatabaseID = (dbUnknown, dbOracle, dbMsSQL, dbMySQL, dbFirebird, dbInterbase);

  TDatabase = record
    ID: TDatabaseID;
    Driver: string;
    FriendlyName: string;
    Collate: string;
    ClauseMaxRecord: string;
  end;

  TValidComponent = function (const aComponent: TComponent): Boolean of object;
  TInputCloseConfirmationMessage = reference to procedure(const aConfirmation: Boolean);
  {$IFNDEF FIREMONKEY}
  TInputCloseDialogProc = reference to procedure(const AResult: TModalResult);
  {$ENDIF FIREMONKEY}
//const
//  ModelosDasImpressoras : array[TTipoDeImpressora] of string = ('Bematech', 'Mecaf', 'Zebra', 'Seiko', 'Fujitsu', 'Custom');


  {$ENDREGION}

  {$REGION 'Aspect'}
  TCastControl = {$IFDEF FIREMONKEY}FMX.Controls.TControl{$ELSE}Vcl.Controls.TWinControl{$ENDIF FIREMONKEY};
  TCastForm = {$IFDEF FIREMONKEY}FMX.Forms.{$ELSE}Vcl.Forms.{$ENDIF FIREMONKEY}TForm;
  TCastFrame = {$IFDEF FIREMONKEY}FMX.Forms.{$ELSE}Vcl.Forms.{$ENDIF FIREMONKEY}TFrame;



  /// <summary>
  ///   Classe que grava a posiÁ„o do form quando o mesmo foi instanciado "LoadPosition".
  /// Utilizado para quando efetuar o "SavePosition" ao fechar o form n„o gravar
  ///  no arquivo ini os dados que n„o foram modificados pelo usu·rio.
  ///  Assim n„o poluindo o ini.
  /// </summary>
  TPositionForm = class(TComponent)
  private
    FForm: TObject;
    procedure SetForm(const Value: TObject);
  public
    Top, Left, Height, Width, WindowState, AOT, FormStyle: Integer;
    MD5Column: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property Form: TObject read FForm write SetForm;
  end;

  /// <summary>
  ///   Utilizada para localizar o form.
  ///  Percore a lista de form e verifica Item atual = Form atual.
  /// </summary>
  TComparerPositionsForms<T> = class(TComparer<TPositionForm>)
  public
    function Compare(const Left, Right: TPositionForm): Integer; Override;
  end;

  /// <summary>
  ///   Lista de forms que foi efetuado o loadposition.
  /// </summary>
  TPositionsForms = class(TList<TPositionForm>)
  public
    function IndexOfForm(aForm: TObject): Integer;
    destructor Destroy; override;
  end;

  /// <summary>
  ///   Componente que permite ser notificado quando um parent È destruido.
  /// </summary>
  TComponentFreeNotify = class(TComponent{$IFDEF FIREMONKEY}, IFreeNotification, IFreeNotificationBehavior{$ENDIF FIREMONKEY})
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure FreeNotification(AObject: TObject); Reintroduce; Overload; Virtual;
    procedure FreeNotification(AObject: TComponent); Overload; Virtual;
    {$IFDEF FIREMONKEY}
    procedure AddFreeNotify(const AObject: IFreeNotification); virtual;
    procedure RemoveFreeNotify(const AObject: IFreeNotification); virtual;
    {$ENDIF FIREMONKEY}
  end;

  TListaControl = TList<TCastControl>;
  {$ENDREGION}



{$REGION 'AspFMXHelper'}
function EhCorClara(const aCorValidar: TAlphaColor): Boolean;
function EhCorPreta(const aCorValidar: TAlphaColor): Boolean;
procedure AspUpdateColunasGrid(const aOwner: TComponent;
  const aGrid: TCustomGrid; const aDataSet: TDataSet; const aDistruirLarguraColunas: Boolean = True;
  const aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean = False;
  const aClearColumns: Boolean = False;
  const aNomeColunaAllCliente: string = ''); Overload;

procedure AspUpdateColunasGrid(const aOwner: TComponent; const aLinkGridToDataSource: TLinkGridToDataSource;
  const aDataSetLinkGrid: TGetDataSetLinkGrid = nil;
  const aDistruirLarguraColunas: Boolean = True;
  const aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean = False;
  const aClearColumns: Boolean = False); Overload;

procedure AspUpdateColunasGrid(const aOwner: TComponent; const aLinkGridToDataSource: TLinkGridToDataSource; const aDataSet: TDataSet;
  const aDistruirLarguraColunas: Boolean = True;
  const aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean = False;
  const aClearColumns: Boolean = False); Overload;

procedure AspUpdateColunasGrid(const aOwner: TComponent; const aBindingsList: TBindingsList;
  const aDataSetLinkGrid: TGetDataSetLinkGrid = nil;
  const aDistruirLarguraColunas: Boolean = True;
  const aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean = False;
  const aClearColumns: Boolean = False); Overload;

  procedure AspUpdateTamanhoColunasProporcialGrid(const aGrid: TCustomGrid; const aRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean;
  const aNomeColunaAllCliente: string = ''); Overload;

  procedure AspUpdateTamanhoColunasProporcialGrid(const aLinkGridToDataSource: TLinkGridToDataSource;
  const aRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean); Overload;
{$ENDREGION}

{$REGION 'AspFuncoesUteis'}
/// <summary>
///   Percora a lista de vari·vel do tipo objeto "Var aObjeto: TObject" e set nil
/// </summary>
procedure RemoveAllVarReference(var aListReferencesVar: TListReferencesVar);

/// <summary>
///   Adicionar uma vari·vel do tipo "TObject" a lista. Assim podendo manipula em qualquer lugar.
/// Deve ser executa apÛs set da vari·vel Exemplo "var aControl: TContro;  aControl := TControl.Create(); AddVarReference(Lista, @aControl);
/// </summary>
procedure AddVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer);

/// <summary>
///   Remove uma vari·vel do tipo "TObject" da lista.
/// Ao destruir o objeto deve remover a referencia para n„o dar execeÁ„o.
/// Quando a vari·vel est· dentro de um mÈtodo deve executar do final mÈtodo.
/// Quando a vari·vel est· dentro de um classe deve executar ao destruir a classe.
/// Quando a vari·vel È global deve executar no finalization da unit.
/// </summary>
procedure RemoveVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer);
function IndexOfVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer): Integer;
procedure SetComponenteFreeNotify(const aSender: TComponent; var aOldValue: TControl; const aNewValue: TControl);
function GetComponenteFreeNotify(const aSender: TComponent; aOldValue, aNewValue: TObject): TObject;
function  MyConverteASCII (Source : string; const CaracteresLegiveisComoTexto : boolean = false; const ConvertidosEntreMaiorMenor : boolean = false; const ConverterEmHexa: boolean = true; const IndicarHexaOuDec: boolean = false) : string;

/// <summary>
///   Adicionar\remove free notificaÁ„o ou seja quando o objeto "X" est· vinculado a outro
/// objeto "Y" com uma v·rival "var y.ObjetoX: X;" A destruir o objeto X deve limpar a vari·vel
/// No objeto y "y.ObjetoX := nil"
/// </summary>
function RemoveOrAddFreeNotify(aSender: TComponent; aFormComponentesDesabilitados: TObject; const aRemove: Boolean): Boolean; Overload;

/// <summary>
///   Transforma um valor com virgula em inteiro.
/// Se possui alguma valor apÛs a virgula o valor retorna È valor antes virgula + 1
/// </summary>
function Arredonda(const aValor: Single): Integer;

function RemoveAcento(aText : string) : string;

{$IFDEF FIREMONKEY}
/// <summary>
///   Adiciona freenotificaÁ„o no set da property
/// </summary>
procedure OnSetAncora(const aControl: TControl; const aOwner: IFreeNotification);
{$ENDIF FIREMONKEY}


{$ENDREGION}

{$REGION 'ClassLibrary'}
 function ASPEzPorListaTodosComandos : string;
function FormatLeftString(Comprimento: Integer; s: string): string;
function  FormatCenterString (Comprimento: Integer; s: string; const PreencherComEspacosAoFinal: boolean = true): string;
{$IFDEF FIREMONKEY}
function EnableDisableAllControls(Controle: FMX.Controls.TControl; const Enable: Boolean;
  aControlNaoModificar: FMX.Controls.TControl = nil): Boolean; {$IFNDEF AplicacaoFiremokeySemVCL}Overload;{$ENDIF AplicacaoFiremokeySemVCL}
{$ENDIF FIREMONKEY}
{$IFNDEF AplicacaoFiremokeySemVCL}
function EnableDisableAllControls(Controle: Vcl.Controls.TWinControl; const Enable: Boolean;
  aControlNaoModificar: Vcl.Controls.TWinControl = nil): Boolean; {$IFDEF FIREMONKEY}Overload;{$ENDIF FIREMONKEY}
{$ENDIF AplicacaoFiremokeySemVCL}

function Eleva(const Base, Expoente: integer): integer;
function FormatNumber(const Digits, i: Integer): string;
function FormatTimeComAspas(const T: TTime): string;
function GetDataOfMyLogException: String;
function ArrayToString(const aListaValues: array of string; const aDelimiter: String = '|'): String;


procedure SetIniFileName(const aNewFilePath: String);
function GetDiretorioAsp: String;//mirrai
function SettingsPathName: string;
function ForceDirAsp(const aDiretorio: String): Boolean;
function ActiveControl: TControl;
function ApplicationName(AExtension: Boolean = False): string; overload;

function ApplicationName(AExtension: string): string; overload;
function ApplicationPath: string;
function GetApplicationPath: string;
function ArchitectureToString(AArchitecture: TOSVersion.TArchitecture): string;
function CheckCNPJ(AValue: string): Boolean;
function CheckCPF(AValue: string): Boolean;
function CheckInternet: Boolean;
function CheckIP(AAddress: string): Boolean;
function CheckPort(AHost: string; APort: Word): Boolean;
function ClassContext(AClass: TClass): TRttiType;
function ClassFields(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiField>;
function ClassMembers(AClass: TClass; AMember: TClassMember; ADeclaredOnly: Boolean = False): TArray<TRttiMember>;
function ClassMemberList(AClass: TClass; AMember: TClassMember; ADeclaredOnly: Boolean = False): TStrings;
function ClassMethods(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiMethod>;
function ClassProperties(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiProperty>;
procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
function CurrentPID: Integer;
procedure CustomMessage(AMessage: string; AType: TMsgDlgType; aCloseDialogProc: TInputCloseDialogProc);
function Decrypt(AText: string; AKey: string = ''): string;
function Encrypt(AText: string; AKey: string = ''): string;
function Encryption(AMode: TEncryptionMode; AText: string; AKey: string = ''): string;
function ExternalIP: string;
function FileHash(APath: string): string;
function FindConnection: TFDConnection;
{$IFDEF FIREMONKEY}
function ActiveForm: FMX.Forms.TForm;
function FindForm(AClass: TComponentClass): FMX.Forms.TForm;
{$ELSE}
function ActiveForm: Vcl.Forms.TForm;
function FindForm(AClass: TComponentClass): Vcl.Forms.TForm;
{$ENDIF FIREMONKEY}

{$IFNDEF AplicacaoFiremokeySemVCL}
procedure AspAtualizarPropriedade(aForm: Vcl.Forms.TForm; aComponente: Tobject; const aNomePropriedade: string; const aValorPropriedade: Variant);{$IFDEF FIREMONKEY}Overload;{$ENDIF FIREMONKEY}
function GetSelectValue(const aLista: Vcl.StdCtrls.TListBox): String;{$IFDEF FIREMONKEY}Overload;{$ENDIF FIREMONKEY}
{$ENDIF AplicacaoFiremokeySemVCL}

{$IFNDEF IS_MOBILE}
function DeleteFolder(Dir: String): boolean;
function CopyFolder(DirFonte, DirDest: String): boolean;
function CreateProcessSimple(const cmd: string): boolean;
{$ENDIF IS_MOBILE}

{$IFDEF FIREMONKEY}
function ScreenSize: TPoint;
function SaveControlAsImage(AObject: TFmxObject; AFileName: string): Boolean;
procedure AspAtualizarPropriedade(aForm: FMX.Forms.TCommonCustomForm; aComponente: Tobject; const aNomePropriedade: string; const aValorPropriedade: Variant); {$IFNDEF AplicacaoFiremokeySemVCL}Overload;{$ENDIF AplicacaoFiremokeySemVCL}
function GetSelectValue(const aLista: FMX.ListBox.TListBox): String;{$IFNDEF AplicacaoFiremokeySemVCL}Overload;{$ENDIF AplicacaoFiremokeySemVCL}
{$ENDIF FIREMONKEY}

function Focused(AControl: TControl): Boolean;
function FullApplicationPath: string;
function GenerateString(ALength: Integer; AContent: string = ''): string;
function Hash(AValue: string; AMode: THashMode): string;
function HttpRequest(AMode: TRequestMode; AURL: string; AParams: TStrings; var AContent: TStream): string;
function HttpGet(AURL: string): string; overload;
function HttpPost(AURL: string; AParams: TStrings): string; overload;
function HtmlDecode(AText: string): string;
function InternalIP: string;
function InternetDateTime(ASyncTime: Boolean = False): TDateTime;
function LineBreak(ACount: Integer = 1): string;
function Mask(AValue: Variant; AMask: string): string;
function MemberClass(AMember: TRttiMember): TClass;
function ClassMemberName(const AMember): string;
function MobileDevice: Boolean;
function PlatformToString(APlatform: TOSVersion.TPlatform): string;
function PropertyExists(AObject: TObject; AName: string): Boolean;
function AspLerPropriedade(aComponente: TComponent; const aNomePropriedade: string; const aValorPadrao: Variant): Variant;
procedure GetObjectDaPropriedade(var aObject: TObject; var aListaPropriedades: string);
function ReadIniFile(const APath, ASection, AIdent: string; const ADefault: Variant; const aCanForceWrite: Boolean = true): Variant; Overload;
function ReadIniFile(AniFile: TIniFile; const ASection, AIdent: string; const ADefault: Variant; const aCanForceWrite: Boolean = true): Variant; Overload;
function ReadSettings(ASection, AIdent: string; ADefault: Variant; const aCanForceWrite: Boolean = True): Variant;
function RemoveCharacter(AText, ACharacters: string): string;
function RemoveLineBreak(AText: string): string;
function RemoveMask(AText: string): string;
function RemoveThousandSeparator(AText: string): string;
function RemoveTag(AText, AOpenTag, ACloseTag: string): string; overload;
function RemoveTag(AText: string): string; overload;
function SettingsFileName: string;
function  GetAppIniFileName: string;

function AppMessageBox(Text : string; Caption : string; Flags : integer) : integer;

function SetWhereClause(ASQL, ACondition: string): string;
function TextHash(AText: string): string;
function UnicodeChar(AChar: Char): Char;
function WriteDebugLog(AText: string): Boolean;

function WriteIniFile(var aIniFile: TIniFile; const ASection, AIdent: string;
  const AValue: Variant; const AOverwrite: Boolean = True; const aCanForceWrite: Boolean = true): Boolean; overload;
function WriteIniFile(const APath, ASection, AIdent: string; const AValue: Variant;
  const AOverwrite: Boolean = True; const aCanForceWrite: Boolean = true): Boolean; overload;
function WriteLog(AText: string): Boolean;
function WriteSettings(ASection, AIdent: string; AValue: Variant; const aCanForceWrite: Boolean = True): Boolean; overload;
function WriteSettings(AIdent: string; AValue: Variant; const aCanForceWrite: Boolean = True): Boolean; overload;
function WriteTextFile(APath, AText: string; AAppend: Boolean = False): Boolean;
procedure ConnectDatabase;
procedure Delay(AMillisecond: Integer);
procedure DisconnectDatabase;
procedure ExecuteThread(AExecute, ATerminate: TProcedure; AShowProgress: Boolean; AMessage: string); overload;
procedure ExecuteThread(AExecute: TProcedure; AMessage: string); overload;
procedure ExecuteThread(AExecute: TProcedure); overload;
procedure ErrorHandling(E: Exception);
procedure ErrorMessage(const AMessage: string);
procedure ErrorMessageWithoutLog(const AMessage: string);
procedure ErrorStopMessage(const AMessage: string);
procedure FinalizeApplication;
procedure HttpGet(AURL: string; var AContent: TStream); overload;
procedure HttpPost(AURL: string; AParams: TStrings; var AContent: TStream); overload;
procedure InformationMessage(AMessage: string);
procedure LoadSettings;
procedure ReadDeviceInfo;
procedure WarningMessage(AMessage: string);
procedure StrToIntArray(S: string; var A: TIntegerDynArray; const aConsiderarTodos: Boolean = True);
function AspStrToIntArray(const S: string; const aConsiderarTodos: Boolean = True): TIntegerDynArray;
function ExisteNoIntArray(I: Integer; A: TIntegerDynArray): Boolean;
procedure IntArrayToStr(const A: TIntegerDynArray; var S: string; const aConsiderarTodos: Boolean = True);
function AspIntArrayToStr(const A: TIntegerDynArray; const aConsiderarTodos: Boolean = True): String;
procedure SeparaStrings(const aValue, aSeparador: string; var Antes, Depois: string);
function AspFindComponentAndSubComp(const aOwner: TComponent; const AName: string;
  const aFindInSubComponent: Boolean = False; const aValidComponent: TValidComponent = nil): TComponent;



function FieldExists(ds: TDataSet; FieldName: string): boolean;
procedure AbrirCDS(const aDataSet: TClientDataSet; const aLogChanges: Boolean = False);

function AspAnsiStringToString(const aValue: TAspAnsiString): String;
function AspAnsiCharToString(const aValue: TAspAnsiChar): String;
function AspStringToAnsiString(const aValue: String): TAspAnsiString;

 {$IFNDEF IS_MOBILE}
function GetProgramFilesDir: string;
{$ENDIF IS_MOBILE}

function AspLib_GetAppIniFileName : string;

{$ENDREGION}

{$REGION 'Aspect'}
function Coalesce(const aValue, aValueDefault: String): String; Overload;
function Coalesce(const aValue, aValueDefault: Single): Single; Overload;
function Coalesce(const aValue, aValueDefault: TAlphaColor): TAlphaColor; Overload;

function RemovePrefixoCor(const aCorExtensa: String): String;
function StrAlphaToColor(const aCorExtensa: String): TAlphaColor;

{$IFNDEF IS_MOBILE}
function GetPID(ProcessName: string): DWORD; //FunÁ„o obter o ID do Processo (PID)
{$IFDEF SuportaPortaCom}
function PortaSerial_SetConfig(var SerialPort: TVaComm; const SerialConfig: string): boolean;
{$ENDIF SuportaPortaCom}
{$ENDIF}
procedure MyLogException(E: Exception; const DisplayMsg : boolean = false);
function GetDescProtoculo(const aProtocolo: Integer): String;

{$IFNDEF IS_MOBILE}
function GetCurrentWindowsUserName: string;
procedure GerarArquivoWorking;
function Gerar_Log(operacao : String) : String;
function NaoMostrarNomesRepetidos(Lista_EXE : TStrings) : TStrings;
function ExisteArquivoWorking : Boolean;
function GetPathArquivoWorking : string;
function AspUpd_GerarScriptUpdateAlternativo(ArqUpDir : String) : Boolean;
function Lista_arquivos(var Lista_arqs_upt : TStrings; const Path, Mascara : string) : integer;
function Verifica_dependencias(Lista_arqs_upt : TStrings; var Lista_EXE : TStrings) : Boolean;
function Busca_DLL(ID_exe : Integer; nome_DLL, nome_exe : string) : Boolean;
procedure Finalizar_programas(Lista_EXE : TStrings);
function AspUpd_FazerUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean;
function AspUpd_ChecarUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean;
procedure AspUpd_ChecarEFazerUpdate(ArqUpDir: string);
function FindWindowByTitle(WindowTitle: string;AppHandle : HWND): Hwnd;
procedure VerificaInstanciaApp(WindowTitle: PWideChar; UseFindWindowByTitle: Boolean = false);
{$ENDIF}

procedure ValidaAppMultiInstancia;
function valorPorExtenso(vlr: real): string;

{$IFNDEF IS_MOBILE}
function GetExeVersion: string;
function ContaProcessos(s: string; const SomenteDoUsuarioAtual: boolean = false): integer;
{$ENDIF}

{$IFDEF FIREMONKEY}
procedure LoadPosition(aForm: FMX.Forms.TForm); Overload;
procedure LoadPosition(aForm: FMX.Forms.TFrame); Overload;
procedure SavePosition(aForm: FMX.Forms.TForm); Overload;
procedure SavePosition(aForm: FMX.Forms.TFrame); Overload;
function ClearTitledStringGrid(var SG: FMX.Grid.TStringGrid): Boolean; Overload;
function StrToConexaoIPArray (s: string): TConexaoIPArray;
{$ENDIF}

{$IFNDEF AplicacaoFiremokeySemVCL}
procedure LoadPosition(aForm: Vcl.Forms.TForm); Overload;
procedure LoadPosition(aForm: Vcl.Forms.TFrame); Overload;
procedure SavePosition(aForm: Vcl.Forms.TForm); Overload;
procedure SavePosition(aForm: Vcl.Forms.TFrame); Overload;
function ClearTitledStringGrid(var SG: VCL.Grids.TStringGrid): Boolean; {$IFDEF FIREMONKEY}Overload;{$ENDIF FIREMONKEY}
{$ENDIF}

function MyFormatDateTime(Format: string; DateTime: TDateTime): string;

{$IFDEF AplicacaoFiremokeySemVCL}
function GetApplication: FMX.Forms.TApplication;
{$ELSE}
function GetApplication: Vcl.Forms.TApplication;
{$ENDIF}
function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
function SettingsFileNamePosition: String;
{$ENDREGION}


var
{$REGION 'ClassLibrary'}
//  Settings      : TSettings;
  Device        : TDevice;
  DataConnection: TFDConnection;
  Database      : TDatabase;
  FSettingsFileName: String;
  FDiretorioAsp: String;
{$ENDREGION}
{$REGION 'Aspect'}
  FPositionsForms: TPositionsForms;
  FComparerPositionsForms: TComparerPositionsForms<TPositionForm>;
  FSettingsFileNamePosition: String;
  TentativaLogException : integer;
  LIniciaFormCantoSuperiorEsquerdo:Boolean;
{$ENDREGION}

const
{$REGION 'Aspect'}
  CorConectado    = TAlphaColorRec.White;
  CorDesconectado = TAlphaColorRec.Red;
  CorProcessando  = TAlphaColorRec.Blue;
  cPosition = 'Position';

  LARGURA_CARACTER = 6;
  LARGURA_BARRA_ROLAGEM = 17;
{$ENDREGION}
implementation

uses
{$IFNDEF IS_MOBILE}
  Winapi.PsAPI,
  Winapi.TlHelp32,
  {$ENDIF IS_MOBILE}untLog;

{$REGION 'AspFMXHelper'}
function EhCorClara(const aCorValidar: TAlphaColor): Boolean;
begin
  Result := ((TAlphaColorRec.Null = aCorValidar)) or (((TAlphaColorRec(aCorValidar).B >= 127)
   or (TAlphaColorRec(aCorValidar).G >= 127)
   or (TAlphaColorRec(aCorValidar).R >= 127)) and
   (TAlphaColorRec(aCorValidar).G > 0));
end;

function EhCorPreta(const aCorValidar: TAlphaColor): Boolean;
begin
  Result := (TAlphaColorRec(aCorValidar).R <= 50) and
            (TAlphaColorRec(aCorValidar).G <= 50) and
            (TAlphaColorRec(aCorValidar).B <= 50);
end;

procedure AspUpdateTamanhoColunasProporcialGrid(const aGrid: TCustomGrid; const aRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean;
  const aNomeColunaAllCliente: string);
var
  LColumn: TColumn;
  LSumWithColumns, LAumentarColuna, LWithAumentar, LRestoAumentarColuna,
  LWidthDesconsiderar: Single;
  LCountColumn, i: Integer;
begin
  if not (Assigned(aGrid) and (aGrid.Width > 0)) then
    Exit;

  try
    LCountColumn := 0;
    LSumWithColumns := 0;

    for i := 0 to aGrid.ColumnCount -1 do
    begin
      LColumn := aGrid.Columns[i];
      if Assigned(LColumn) and LColumn.Visible then
      begin
        if (LColumn.Width > -1) then
          LSumWithColumns := LSumWithColumns + LColumn.Width;
        Inc(LCountColumn);
      end;
    end;

    if (LCountColumn > 1) and (Trim(aNomeColunaAllCliente) <> '') then
      LCountColumn := 1;

    if (LCountColumn = 0) then
      Exit;

    LWidthDesconsiderar := LARGURA_CARACTER; //diminuindo um caracter, para evitar barra de rolagem horizontal
    if aGrid.RowCount >= aGrid.VisibleRows then //se tem mais linhas do que o visÌvel, ent„o tem barra de rolagem vertical
      LWidthDesconsiderar := LWidthDesconsiderar - LARGURA_BARRA_ROLAGEM; //portanto, diminui a largura desta barra de rolagem para n„o gerar a barra horizontal
    LWithAumentar := (aGrid.Width - LWidthDesconsiderar) - LSumWithColumns;
    if ((LWithAumentar = 0) or ((not aRecalcularCasoTelaMenorQueTamanhoColunasOriginal) and (LWithAumentar < 0))) then
      Exit;

    LAumentarColuna := Trunc(LWithAumentar / LCountColumn);
    if (LAumentarColuna = 0) then
      Exit;

    LRestoAumentarColuna := (LWithAumentar / LCountColumn) - Trunc(LWithAumentar / LCountColumn);
    LColumn := nil;
    for i := 0 to aGrid.ColumnCount -1 do
    begin
      LColumn := aGrid.Columns[i];
      if Assigned(LColumn) and LColumn.Visible then
      begin
        if not (Assigned(aGrid.Columns[i]) and
          ((Trim(aNomeColunaAllCliente) = '') or (aGrid.Columns[i].Header = aNomeColunaAllCliente))) then
          Continue;

        LColumn.Width := LColumn.Width + LAumentarColuna;
      end;
    end;

    if (Assigned(LColumn) and (LRestoAumentarColuna <> 0)) then
      LColumn.Width := LColumn.Width + LRestoAumentarColuna;
  finally
//    aGrid.UpdateColumns;
//    if aGrid.CanFocus then
//      aGrid.SetFocus;
//    aGrid.RealignContent;
//    aGrid.InvalidateContentSize;
//    aGrid.Repaint;
  end;
end;

procedure AspUpdateTamanhoColunasProporcialGrid(const aLinkGridToDataSource: TLinkGridToDataSource;
  const aRecalcularCasoTelaMenorQueTamanhoColunasOriginal: Boolean);
var
  LColumn: TLinkGridToDataSourceColumn;
  LGridColumn: TColumn;
  LSumWithColumns, LAumentarColuna, LWithAumentar, LRestoAumentarColuna,
  LDesconsiderarBarraRolagem: Single;
  LNovoLargura, LCountColumn, i: Integer;
  LGrid: TCustomGrid;
  LNomeColunaAllCliente: String;
begin
  if not (Assigned(aLinkGridToDataSource) and Assigned(aLinkGridToDataSource.GridControl) and
    (aLinkGridToDataSource.GridControl is TCustomGrid)) then
    Exit;

  LGrid := TCustomGrid(aLinkGridToDataSource.GridControl);
  if (LGrid.Width <= 0) then
    Exit;

  LCountColumn := 0;
  LSumWithColumns := 0;

  for I := aLinkGridToDataSource.Columns.Count - 1 downto 0 do
  begin
    LColumn     := aLinkGridToDataSource.Columns[I];
    if Assigned(LColumn) and LColumn.Visible then
    begin
      if (LColumn.Width > -1) then
        LSumWithColumns := LSumWithColumns + LColumn.Width;
      Inc(LCountColumn);
    end;
  end;

  LNomeColunaAllCliente := '';
  if (aLinkGridToDataSource is TAspLinkGridToDataSource) then
    LNomeColunaAllCliente := TAspLinkGridToDataSource(aLinkGridToDataSource).NomeColunaAllCliente;

  if ((LCountColumn > 1) and (Trim(LNomeColunaAllCliente) <> '')) then
    LCountColumn := 1;

  if (LCountColumn = 0) then
    Exit;

  LWithAumentar := (LGrid.Width - LARGURA_CARACTER) - LSumWithColumns;
  if ((LWithAumentar = 0) or ((not aRecalcularCasoTelaMenorQueTamanhoColunasOriginal) and (LWithAumentar < 0))) then
    Exit;

  LAumentarColuna := Trunc(LWithAumentar / LCountColumn);
  if (LAumentarColuna = 0) then
    Exit;

  LRestoAumentarColuna := (LWithAumentar / LCountColumn) - Trunc(LWithAumentar / LCountColumn);

  if LGrid.RowCount >= LGrid.VisibleRows then
    LDesconsiderarBarraRolagem := LARGURA_BARRA_ROLAGEM
  else
    LDesconsiderarBarraRolagem := 0;

  LColumn := nil;
  LGridColumn := nil;
  for I := aLinkGridToDataSource.Columns.Count - 1 downto 0 do
  begin
    if (aLinkGridToDataSource.Columns[I] <> nil) and aLinkGridToDataSource.Columns[I].Visible then
    begin
      if not (Assigned(aLinkGridToDataSource.Columns[I]) and
        ((Trim(LNomeColunaAllCliente) = '') or (aLinkGridToDataSource.Columns[I].MemberName = LNomeColunaAllCliente))) then
        Continue;

      LColumn     := aLinkGridToDataSource.Columns[I];
      LGridColumn := LGrid.GetColumnByFieldName(LColumn.MemberName, aLinkGridToDataSource);
      LNovoLargura := Trunc(((trunc(LColumn.Width * (LGrid.Width-LDesconsiderarBarraRolagem))) / LSumWithColumns));
      LColumn.Width := LNovoLargura;
      if Assigned(LGridColumn) then
        LGridColumn.Width := LNovoLargura;
    end;
  end;

  if (Assigned(LColumn) and (LRestoAumentarColuna <> 0)) then
  begin
    LNovoLargura := Trunc(LColumn.Width + LRestoAumentarColuna);
    if LNovoLargura > 0 then
    begin
      LColumn.Width := LNovoLargura;
      if Assigned(LGridColumn) then
        LGridColumn.Width := LNovoLargura;
    end;
  end;
end;


procedure AspUpdateColunasGrid(const aOwner: TComponent; const aLinkGridToDataSource: TLinkGridToDataSource;
  const aDataSetLinkGrid: TGetDataSetLinkGrid;
 const aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal, aClearColumns: Boolean);
var
  aDataSet: TDataSet;
begin
  aDataSet := nil;
  if ASsigned(aDataSetLinkGrid) then
    aDataSet := aDataSetLinkGrid(aLinkGridToDataSource);
  if (not Assigned(aDataSet)) and Assigned(aLinkGridToDataSource) and Assigned(aLinkGridToDataSource.GridControl) and (aLinkGridToDataSource.GridControl is TCustomGrid) and
    Assigned(aLinkGridToDataSource.DataSource) and (aLinkGridToDataSource.DataSource is TBindSourceDB) then
    aDataSet := TBindSourceDB(aLinkGridToDataSource.DataSource).DataSet;

  AspUpdateColunasGrid(aOwner, aLinkGridToDataSource, aDataSet, aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal,
    aClearColumns);
end;

procedure AspUpdateColunasGrid(const aOwner: TComponent; const aLinkGridToDataSource: TLinkGridToDataSource; const aDataSet: TDataSet;
  const aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal,
  aClearColumns: Boolean);
var
  LColuna     : TLinkGridToDataSourceColumn;
  LGridColumn: TColumn;
  aField      : TField;
  LRoot: IRoot;
  aGrid: TCustomGrid;
  I: Integer;
  LQtdeColumns: Integer;
  function GetWithPorTexto(const aText: String; const aFonteSize: Single): Single;
  begin
    Result := (Length(aText) * aFonteSize) / 2;
  end;
begin
  aGrid := nil;
  try
    if (not (Assigned(aLinkGridToDataSource) and Assigned(aDataSet) and
      Assigned(aLinkGridToDataSource.GridControl) and
      ((aLinkGridToDataSource.GridControl is TCustomGrid) and
        Assigned(aLinkGridToDataSource.DataSource) and
        (aLinkGridToDataSource.DataSource is TBindSourceDB)))) then
      Exit;
   aGrid := TCustomGrid(aLinkGridToDataSource.GridControl);
    if not (Assigned(aGrid) ) then
      Exit;

    if (not Assigned(aGrid.Root)) and ASsigned(aOwner) and ASsigned(aOwner.Owner) and aOwner.Owner.GetInterface(IRoot, LRoot) then
      aGrid.SetRoot(LRoot);

    if aClearColumns then
      aLinkGridToDataSource.Columns.Clear;
    if (aLinkGridToDataSource.Columns.Count <= 0) then
      aLinkGridToDataSource.Columns.RebuildColumns;

    LQtdeColumns := aLinkGridToDataSource.Columns.Count;
    for I := aLinkGridToDataSource.Columns.Count - 1 downto 0 do
    begin
      LColuna     := aLinkGridToDataSource.Columns[I];
      aField      := aDataSet.FindField(LColuna.MemberName);
      if not (Assigned(aField) and Assigned(LColuna)) then
        Continue;

      if (aField.Tag = 1) and (aField is TStringField) and TStringField(aField).FixedChar then
      begin
        TLinkGridToDataSourceColumn(LColuna).ColumnStyle := 'CheckColumn';
        LColuna.CustomFormat := 'ToStr(%s) = "T"';
      end;

      LColuna.Visible  := aField.Visible;
      LColuna.Header   := aField.DisplayLabel;
      LGridColumn := aGrid.GetColumnByFieldName(LColuna.MemberName, aLinkGridToDataSource);

      if ((LQtdeColumns <= 4) and (LColuna.ColumnStyle = 'CheckColumn')) then
        LColuna.Width := 10
      else if ((LQtdeColumns <= 4) and (LColuna.MemberName = 'ID')) then
        LColuna.Width := 5
      else
        LColuna.Width := Max(aField.DisplayWidth, Round(GetWithPorTexto(aField.DisplayLabel, aGrid.TextSettings.Font.Size) * 2) + 5);

      if Assigned(LGridColumn) then
        LGridColumn.Width    := Max(aField.DisplayWidth, Round(GetWithPorTexto(aField.DisplayLabel, aGrid.TextSettings.Font.Size) * 2) + 5);
    end;

    if aDistruirLarguraColunas then
      AspUpdateTamanhoColunasProporcialGrid(aLinkGridToDataSource, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal);
  except
    on E: Exception do
    begin
      if Assigned(aGrid) then
        e.Message :=  e.Message + #13 + 'Grid: ' + aGrid.Name;
      if Assigned(aOwner) then
        e.Message :=  e.Message + #13 + 'Owner: ' + aOwner.Name;
      e.Message := 'Erro ao atualizar as colunas na grid.' + #13 + e.Message;
      TLog.TreatException('', aOwner, e);
      raise;
    end;
  end;
end;


procedure AspUpdateColunasGrid(const aOwner: TComponent; const aGrid: TCustomGrid; const aDataSet: TDataSet;
  const aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal, aClearColumns: Boolean;
  const aNomeColunaAllCliente: string);
var
  aColuna: TColumn;
  I      : Integer;
  aField : TField;
  LRoot  : IRoot;
begin
  if not (Assigned(aGrid) and Assigned(aDataSet)) then
    Exit;

  if (not Assigned(aGrid.Root)) and ASsigned(aOwner.Owner) and aOwner.Owner.GetInterface(IRoot, LRoot) then
    aGrid.SetRoot(LRoot);

//  if aClearColumns then
//    aGrid.col

  for I        := aDataSet.FieldCount - 1 downto 0 do
  begin
    aField  := aDataSet.Fields[i];
    aColuna := aGrid.ColumnByHeader(aField.FieldName);
    if not (Assigned(aField) and Assigned(aColuna)) then
      Continue;

    aColuna.Visible  := aField.Visible;
    aColuna.Header   := aField.DisplayLabel;
    aColuna.Width    := Max(aField.DisplayWidth, Trunc(Length(aField.DisplayLabel) * LARGURA_CARACTER));
  end;
  if aDistruirLarguraColunas then
    AspUpdateTamanhoColunasProporcialGrid(aGrid, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal, aNomeColunaAllCliente);
end;

procedure AspUpdateColunasGrid(const aOwner: TComponent;
  const aBindingsList: TBindingsList;
  const aDataSetLinkGrid: TGetDataSetLinkGrid;
  const aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal,
  aClearColumns: Boolean);
var
  i: Integer;
begin
  if not Assigned(aBindingsList) then
    Exit;

  for i := 0 to aBindingsList.BindCompCount -1 do
  begin
    if Assigned(aBindingsList.BindComps[i]) and (aBindingsList.BindComps[i] is TLinkGridToDataSource) then
      AspUpdateColunasGrid(aOwner, TLinkGridToDataSource(aBindingsList.BindComps[i]),
        aDataSetLinkGrid, aDistruirLarguraColunas, aAoDistruirLarguraColunasRecalcularCasoTelaMenorQueTamanhoColunasOriginal,
        aClearColumns);
  end;
end;

function TGridHelper.ColumnByHeader(const aHeader: String): TColumn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to ColumnCount -1  do
  begin
    if Columns[i].Header = aHeader then
    begin
      Result := Columns[i];
      Break;
    end;
  end;
end;

function TGridHelper.GetColumnByFieldName(const aFieldName: string; const aBinding: TBindingsList): TColumn;
var
  i: Integer;
begin
  Result := nil;
  if (aFieldName <> '') and Assigned(aBinding) then
  begin
    for i := 0 to aBinding.BindCompCount -1 do
    begin
      if not (Assigned(aBinding.BindComps[i]) and (aBinding.BindComps[i] is TLinkGridToDataSource)) then
        Continue;

      Result := GetColumnByFieldName(aFieldName, TLinkGridToDataSource(aBinding.BindComps[i]));
      if Assigned(Result) then
        Exit;
    end;
  end;
end;

function TGridHelper.GetColumnByFieldName(const aFieldName: string; const aLinkGridToDataSource: TLinkGridToDataSource): TColumn;
var
  LColuna: TLinkGridToDataSourceColumn;
  i2: Integer;
begin
  Result := nil;
  if (aFieldName <> '') and Assigned(aLinkGridToDataSource) then
  begin
    if (aLinkGridToDataSource.GridControl <> Self) then
      Exit;

    for i2 := 0 to aLinkGridToDataSource.Columns.Count -1 do
    begin
      LColuna := aLinkGridToDataSource.Columns.Items[i2];
      if Assigned(LColuna) and (LColuna.MemberName = aFieldName) then
      begin
        Result := ColumnByHeader(LColuna.Header);
        Exit;
      end;
    end;
  end;
end;

function TGridHelper.GetFieldNameByColumn(const aColumn: TColumn; const aBinding: TBindingsList): string;
var
  i: Integer;
  LLinkGridToDataSource: TLinkGridToDataSource;
  LColuna: TLinkGridToDataSourceColumn;
  i2: Integer;
begin
  Result := '';
  if Assigned(aColumn) and Assigned(aBinding) then
  begin
    for i := 0 to aBinding.BindCompCount -1 do
    begin
      if not (Assigned(aBinding.BindComps[i]) and (aBinding.BindComps[i] is TLinkGridToDataSource)) then
        Continue;

      LLinkGridToDataSource := TLinkGridToDataSource(aBinding.BindComps[i]);
      if (LLinkGridToDataSource.GridControl <> Self) then
        Continue;

      for i2 := 0 to LLinkGridToDataSource.Columns.Count -1 do
      begin
        LColuna := LLinkGridToDataSource.Columns.Items[i2];
        if Assigned(LColuna) and (LColuna.Header = aColumn.Header) then
        begin
          Result := LColuna.MemberName;
          Exit;
        end;
      end;
    end;
  end;
end;

function TGridHelper.SelectedColumn: TColumn;
begin
  Result := nil;
  if Assigned(PopupMenu) and (PopupMenu is TPopupMenu) then
    Result := Self.ColumnByPoint(TPopupMenu(PopupMenu).PopupPoint.X, TPopupMenu(PopupMenu).PopupPoint.Y);
end;

{ TAspLinkGridToDataSource }

constructor TAspLinkGridToDataSource.Create(aOwner: Tcomponent);
begin
  inherited;
  NomeColunaAllCliente := '';
end;

procedure TAspLinkGridToDataSource.Reactivate;
begin
end;

function TAspLinkGridToDataSource.RequiresControlHandler: Boolean;
begin
  Result := False;
end;

function TComboBoxHelper.GetKeyValue(const aDataSet: TDataSet; const aKeyField: String): Variant;
begin
  Result := null;
  if (ItemIndex > -1) and Assigned(aDataSet) and (aDataSet.RecordCount > ItemIndex) then
  begin
    aDataSet.Recno := ItemIndex + 1;
    Result := aDataSet.FieldByName(aKeyField).Value;
  end;
end;

procedure TComboBoxHelper.SetKeyValue(const aDataSet: TDataSet; const aKeyField: String; const Value: Variant);
begin
  if Assigned(aDataSet) and (not aDataSet.IsEmpty) and aDataSet.Locate(aKeyField, Value, []) then
    ItemIndex := aDataSet.Recno -1
  else
    ItemIndex := -1;
end;

procedure TComboBoxHelper.Import(const aDataSet: TDataSet; const aDisplayFieldName: String);
var
  LOldRecno: Integer;
begin
  Self.Items.Clear;
  aDataSet.DisableControls;
  try
    LOldRecno := aDataSet.Recno;
    try
      aDataSet.First;
      while not aDataSet.Eof do
      begin
        Self.Items.Add(aDataSet.FieldByName(aDisplayFieldName).AsString);
        aDataSet.Next;
      end;
    finally
      if (LOldRecno > -1) then
      aDataSet.Recno := LOldRecno;
    end;
  finally
	  aDataSet.EnableControls;
  end;
end;
{ TPopupMenuHelper }

procedure TPopupMenuHelper.CheckedAll(const aIsChecked: Boolean);
var
  LItem: TMenuItem;
  i: SmallInt;
begin
  for i := 0 to ItemsCount -1 do
  begin
    LItem := Items[i];
    if Assigned(LItem) then
      LItem.CheckedAll(aIsChecked);
  end;
end;

function TPopupMenuHelper.GetItemChecked: TMenuItem;
var
  LItem: TMenuItem;
  i: SmallInt;
begin
  Result := nil;
  for i := 0 to ItemsCount -1 do
  begin
    LItem := Items[i];
    if Assigned(LItem) then
    begin
      Result := LItem.GetItemChecked;
      if Assigned(Result) then
        Break;
    end;
  end;
end;
{ TMenuItemHelper }

procedure TMenuItemHelper.CheckedAll(MenuPai: TMenuItem; const aIsChecked: Boolean);
var
  i: Integer;
begin
  if MenuPai.ItemsCount = 0 then
    MenuPai.IsChecked := False;

  for i := 0 to MenuPai.ItemsCount  -1 do
  begin
    if MenuPai.Items[i].ItemsCount = 0 then
      MenuPai.Items[i].IsChecked := False
    else
      CheckedAll(MenuPai.Items[i], aIsChecked);
  end;
end;

procedure TMenuItemHelper.CheckedAll(const aIsChecked: Boolean);
begin
  CheckedAll(Self, aIsChecked);
end;

function TMenuItemHelper.GetItemChecked: TMenuItem;
begin
  Result := GetItemChecked(Self);
end;

function TMenuItemHelper.GetItemChecked(MenuPai: TMenuItem): TMenuItem;
var
  i: Integer;
begin
  Result := nil;

  with MenuPai do
  begin
    for i := 0 to ItemsCount -1 do
    begin
      if Items[i].ItemsCount = 0 then
      begin
        if Items[i].IsChecked then
          Result := Items[i];
      end
      else
        Result := GetItemChecked(Items[i]);

      if Assigned(Result) then
        System.Break;
    end;
  end;
end;

{$ENDREGION}

{$REGION 'AspFuncoesUteis'}

procedure SetComponenteFreeNotify(const aSender: TComponent; var aOldValue: TControl; const aNewValue: TControl);
begin
  aOldValue := TControl(GetComponenteFreeNotify(aSender, aOldValue, aNewValue));
end;

function GetComponenteFreeNotify(const aSender: TComponent; aOldValue: TObject; aNewValue: TObject): TObject;
begin
  Result := aNewValue;
  if (aOldValue = aNewValue) then
    Exit;

  if Assigned(aOldValue) then
    RemoveOrAddFreeNotify(aSender, aOldValue, True);

  if Assigned(aNewValue) then
    RemoveOrAddFreeNotify(aSender, aNewValue, False);
end;

function RemoveOrAddFreeNotify(aSender: TComponent; aFormComponentesDesabilitados: TObject; const aRemove: Boolean): Boolean;
var
  sErroInfo: string;
  {$IFDEF FIREMONKEY}
  LFreeNotificationBehavior: IFreeNotificationBehavior;
  LFreeNotification: IFreeNotification;
  {$ENDIF FIREMONKEY}
begin
  Result := False;
  sErroInfo := '';
  try
    if not Assigned(aFormComponentesDesabilitados) then
      Exit;

    if (aFormComponentesDesabilitados is TComponent) then
    begin
      sErroInfo := sErroInfo + ' Classe: ' + TComponent(aFormComponentesDesabilitados).ClassName;
      sErroInfo := sErroInfo + ' Nome: ' + TComponent(aFormComponentesDesabilitados).Name;
      if aRemove then
        TComponent(aFormComponentesDesabilitados).RemoveFreeNotification(aSender)
      else
        TComponent(aFormComponentesDesabilitados).FreeNotification(aSender);
      Result := True;
    end
    else
    begin
      {$IFDEF FIREMONKEY}
      if Supports(aFormComponentesDesabilitados, IFreeNotificationBehavior, LFreeNotificationBehavior)
        and Supports(aSender, IFreeNotification, LFreeNotification) then
      begin
        if aRemove then
          LFreeNotificationBehavior.RemoveFreeNotify(LFreeNotification)
        else
          LFreeNotificationBehavior.AddFreeNotify(LFreeNotification);
        Result := True;
      end;
      {$ENDIF FIREMONKEY}
    end;
  except
    on E: Exception do
    begin
      Assert(False, 'Erro ao remover forms desabilitados.' + #13 +
        sErroInfo + #13 + 'Erro: ' + e.message);
      Exit;
    end;
  end;
end;

function Arredonda(const aValor: Single): Integer;
begin
  Result := Trunc(aValor);
  if (aValor > Result) then
    Inc(Result);
end;

function RemoveAcento(aText : string) : string;
const
  ComAcento = '¿¡¬√ƒ≈«»… ÀÃÕŒœ—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝';
  SemAcento = 'AAAAAACEEEEIIIINOOOOOUUUUYaaaaaaceeeeiiiinooooouuuuy';
var
  x: Cardinal;
begin;
  for x := 1 to Length(aText) do
  try
    if (Pos(aText[x], ComAcento) <> 0) then
      aText[x] := SemAcento[ Pos(aText[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;

  Result := aText;
end;

{ TAspException }

constructor TAspException.Create(const aOwner: TComponent; const Msg: string);
begin
  Owner := aOwner;
  inherited Create(Msg);
  ParserLog;
end;

constructor TAspException.CreateFmt(const aOwner: TComponent; const Msg: string; const Args: array of const);
begin
  Owner := aOwner;
  inherited CreateFmt(Msg, Args);
  ParserLog;
end;

destructor TAspException.Destroy;
begin
  owner := nil;
  inherited;
end;

function TAspException.GetMessage: string;
begin
  Result := inherited Message;
end;

procedure TAspException.ParserLog;
begin
  if Assigned(FLogExcecao) then
    FLogExcecao(Message, Owner);
end;

procedure TAspException.SetMessage(const Value: string);
begin
  inherited Message := Value;
  ParserLog;
end;

procedure AddVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer);
begin
  SetLength(aListReferencesVar, Length(aListReferencesVar) + 1);
  aListReferencesVar[Length(aListReferencesVar) - 1] := aPointer;
end;

procedure RemoveVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer);
var
  LIndexReference: Integer;
begin
  LIndexReference := IndexOfVarReference(aListReferencesVar, aPointer);
  if LIndexReference > -1 then
  begin
    aListReferencesVar[LIndexReference] := nil;
    if LIndexReference = High(aListReferencesVar) then
      SetLength(aListReferencesVar, Length(aListReferencesVar) - 1);
  end;
end;

function IndexOfVarReference(var aListReferencesVar: TListReferencesVar; aPointer: Pointer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(aListReferencesVar) to High(aListReferencesVar) do
  begin
    if (aListReferencesVar[i] = aPointer) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure RemoveAllVarReference(var aListReferencesVar: TListReferencesVar);
var
  I: Integer;
begin
  try
    for i := Low(aListReferencesVar) to High(aListReferencesVar) do
    begin
      try
        if (aListReferencesVar[i] <> nil) then
        begin
          TObject(aListReferencesVar[i]^) := nil;
          aListReferencesVar[i] := nil;
        end;
      except
//        ErrorMessage('Erro ao remover a referÍncia.');
        Continue;
      end;
    end;
  finally
    SetLength(aListReferencesVar, 0);
  end;
end;

{$IFDEF FIREMONKEY}
procedure OnSetAncora(const aControl: TControl; const aOwner: IFreeNotification);
begin
  if Assigned(aControl) then
    aControl.AddFreeNotify(aOwner);
end;
{$ENDIF FIREMONKEY}

function  ContaSubStrings     (SubString, s : string) : integer;
var
  aux : string;
begin
  Result := 0;
  while Pos(Substring, s) > 0 do
  begin
    Result := Result + 1;
    SeparaStrings (s, Substring, aux, s);
  end;
end;  { func ContaSubStrings }

function StrToConexaoIPArray (s: string): TConexaoIPArray;

  function MesclarIP(IP1, IP2: string): string;
  var
    i: Integer;
  begin
    case ContaSubStrings('.', IP2) of
      3:
        Result := IP2;
      2:
        begin
          Result := '';
          for i  := 1 to length(IP1) do
            if IP1[i] <> '.' then
              Result := Result + IP1[i]
            else
            begin
              Result := Result + '.' + IP2;
              break;
            end;
        end;
      1:
        begin
          Result := copy(IP1, 1, Pos('.', IP1));
          for i  := Pos('.', IP1) + 1 to length(IP1) do
            if IP1[i] <> '.' then
              Result := Result + IP1[i]
            else
            begin
              Result := Result + '.' + IP2;
              break;
            end;
        end;
      0:
        begin
          Result := '';
          for i  := length(IP1) downto 1 do
            if IP1[i] = '.' then
            begin
              Result := copy(IP1, 1, i) + IP2;
              break;
            end;
        end;
    else
      Result := '';
    end; { case }
  end;   { func MesclarIP }

var
  i, IPPort           : Integer;
  aux1, aux2, UltimoIP: string;
begin
  if s <> '' then
  begin
    while ((s <> '') and (CharInSet(s[1], [',', ';']))) do
      s := copy(s, 2, length(s) - 1);

    while ((s <> '') and (CharInSet(s[length(s)], [',', ';']))) do
      s := copy(s, 1, length(s) - 1);

    SetLength(Result, ContaSubStrings(';', s) + ContaSubStrings(',', s) + 1);
    UltimoIP := '';
    i        := low(Result);
    while s <> '' do
    begin
      SeparaStrings(s, ';', aux1, s);
      SeparaStrings(aux1, ':', aux1, aux2);
      if aux2 <> '' then
        IPPort := strtoint(aux2)
      else
        IPPort := 3001;
      while aux1 <> '' do
      begin
        SeparaStrings(aux1, ',', aux2, aux1);
        UltimoIP             := MesclarIP(UltimoIP, aux2);
        Result[i].EnderecoIP := UltimoIP;
        Result[i].PortaIP    := IPPort;
        i                    := i + 1;
      end;
    end;
  end;
end; { func StrToConexaoIPArray }

function ExisteNoIPArray     (IP: string; a: TConexaoIPArray): boolean;
var
  j: Integer;
begin
  try
    Result := false;
    for j  := Low(a) to High(a) do
      if (a[j].EnderecoIP = IP) then
      begin
        Result := true;
        break;
      end;
  except
    Result := false;
  end;
end; { func ExisteNoIntArray }

function MyConverteASCII (Source : string; const CaracteresLegiveisComoTexto : boolean = false; const ConvertidosEntreMaiorMenor : boolean = false; const ConverterEmHexa: boolean = true; const IndicarHexaOuDec: boolean = false) : string;
var
  i               : integer;
  aux             : string;
  ImprimindoTexto : boolean;
begin
  Result := '';
  ImprimindoTexto := false;
  for i := 1 to length(Source) do
  begin
    if ((CaracteresLegiveisComoTexto) and (CharInSet(Source[i], [' '..'.','0'..'[', ']'..'~']))) then
    begin
      if ImprimindoTexto then
        Result := Result + Source[i]
      else
        Result := Result + '/' + Source[i];

      ImprimindoTexto := true;
    end
    else
    begin
      if ImprimindoTexto then
      begin
        Result := Result + '\ ';
        ImprimindoTexto := false;
      end;

      if ConverterEmHexa then
        aux := IntToHex(ord(Source[i]), 2)
      else
        aux := FormatNumber(3, ord(Source[i]));

      if IndicarHexaOuDec then
      begin
        if ConverterEmHexa then
          aux := aux + 'h'
        else
          aux := aux + 'd';
      end;

      if ConvertidosEntreMaiorMenor then
        aux := '<' + aux + '> '
      else
        aux := aux + ' ';

      Result := Result + aux;
    end;
  end;

  if ImprimindoTexto then
    Result := Result + '\ ';
end;

{$ENDREGION}


{$REGION 'ClassLibrary'}

{$IFNDEF IS_MOBILE}
function GetProgramFilesDir : string;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False);
    Result := reg.ReadString('ProgramFilesDir');
  finally
    reg.Free;
  end;
end;
{$ENDIF IS_MOBILE}

procedure AbrirCDS(const aDataSet: TClientDataSet; const aLogChanges: Boolean = False);
begin
  if aDataSet.Active then
  begin
    aDataSet.CancelUpdates;
    aDataSet.MergeChangeLog;
    aDataSet.Close;
  end;
  aDataSet.Open;
  if not aLogChanges then
    aDataSet.LogChanges := aLogChanges;
end;

function FieldExists(ds: TDataSet; FieldName: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i  := 0 to ds.Fields.Count - 1 do
    if ds.Fields[i].FieldName = FieldName then
    begin
      Result := true;
      break;
    end;
end;

{$IFDEF FIREMONKEY}
function ActiveForm: FMX.Forms.TForm;
begin
  Result := FMX.Forms.TForm(FMX.Forms.Screen.ActiveForm);
end;

function FindForm(AClass: TComponentClass): FMX.Forms.TForm;
var
  I: Integer;
begin
  Result := nil;
  if not Assigned(AClass) then
    Exit;

  for I := 0 to Pred(GetApplication.ComponentCount) do
  begin
    if GetApplication.Components[I].ClassName = AClass.ClassName then
    begin
      Result := TForm(GetApplication.Components[I]);
      Break;
    end;
  end;
end;

{$ELSE}
function ActiveForm: Vcl.Forms.TForm;
begin
  Result := Vcl.Forms.Screen.ActiveForm;
end;

function FindForm(AClass: TComponentClass): Vcl.Forms.TForm;
var
  I: Integer;
begin
  Result := nil;
  if not Assigned(AClass) then
    Exit;
  for I := 0 to Pred(GetApplication.ComponentCount) do
  begin
    if GetApplication.Components[I].ClassName = AClass.ClassName then
    begin
      Result := TForm(GetApplication.Components[I]);
      Break;
    end;
  end;
end;
{$ENDIF FIREMONKEY}

function ActiveControl: TControl;
var
  vForm: TForm;
begin
  Result := nil;
  vForm := ActiveForm;

{$IFNDEF FIREMONKEY}

  if Assigned(vForm) then
    Result := ActiveForm.ActiveControl;

{$ELSE}

  if Assigned(vForm) and (vForm.Focused is TControl) then
    Result := TControl(ActiveForm.Focused.GetObject);

{$ENDIF FIREMONKEY}

end;
function ApplicationName(AExtension: Boolean): string;
var
  vName: string;
begin
  {$IFDEF ANDROID}
  vName  := TAndroidHelper.ApplicationTitle; //mirrai Retorna: "SICS PA"
  {$ELSE}
    {$IFDEF IOS}
    vName := Application.MainForm.Caption; //***IOS
    {$ELSE}
    vName  := ExtractFileName(FullApplicationPath);
    {$ENDIF}
  {$ENDIF}
  Result := IfThen(AExtension, vName, TPath.GetFileNameWithoutExtension(vName));
end;

function ApplicationName(AExtension: string): string;
begin
  Result := ApplicationName(False) + AExtension; //SICS PA.Ini
end;

function GetApplicationPath: string;
begin
  Result := ExcludeTrailingPathDelimiter(ApplicationPath);
end;

function ApplicationPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FullApplicationPath));
end;

function ArchitectureToString(AArchitecture: TOSVersion.TArchitecture): string;
begin
  Result := '';

  case AArchitecture of
    arIntelX86:
      Result := 'IntelX86';

    arIntelX64:
      Result := 'IntelX64';

    arARM32:
      Result := 'ARM32';
  end;
end;

function CheckCNPJ(AValue: string): Boolean;
var
  N     : array [1 .. 12] of Integer;
  D1, D2: Integer;
  S1, S2: string;
begin
  Result := False;
  AValue := RemoveMask(AValue);

  if AValue.Length <> 14 then
    Exit;

  N[1]  := StrToInt(AValue[1]);
  N[2]  := StrToInt(AValue[2]);
  N[3]  := StrToInt(AValue[3]);
  N[4]  := StrToInt(AValue[4]);
  N[5]  := StrToInt(AValue[5]);
  N[6]  := StrToInt(AValue[6]);
  N[7]  := StrToInt(AValue[7]);
  N[8]  := StrToInt(AValue[8]);
  N[9]  := StrToInt(AValue[9]);
  N[10] := StrToInt(AValue[10]);
  N[11] := StrToInt(AValue[11]);
  N[12] := StrToInt(AValue[12]);

  D1 := N[12] * 2 + N[11] * 3 + N[10] * 4 + N[9] * 5 + N[8] * 6 + N[7] * 7 + N[6] * 8 + N[5] * 9 + N[4] * 2 + N[3] * 3 + N[2] * 4 + N[1] * 5;
  D1 := 11 - (D1 mod 11);
  D1 := IfThen(D1 > 10, 0, D1);

  D2 := D1 * 2 + N[12] * 3 + N[11] * 4 + N[10] * 5 + N[9] * 6 + N[8] * 7 + N[7] * 8 + N[6] * 9 + N[5] * 2 + N[4] * 3 + N[3] * 4 + N[2] * 5 + N[1] * 6;
  D2 := 11 - (D2 mod 11);
  D2 := IfThen(D2 > 10, 0, D2);

  S1 := AValue[13] + AValue[14];
  S2 := IntToStr(D1) + IntToStr(D2);

  Result := S1.Equals(S2);
end;

function CheckCPF(AValue: string): Boolean;
var
  N     : array [1 .. 9] of Integer;
  D1, D2: Integer;
  S1, S2: string;
begin

  Result := False;
  AValue := RemoveMask(AValue);

  if AValue.Length <> 11 then
    Exit;

  N[1] := StrToInt(AValue[1]);
  N[2] := StrToInt(AValue[2]);
  N[3] := StrToInt(AValue[3]);
  N[4] := StrToInt(AValue[4]);
  N[5] := StrToInt(AValue[5]);
  N[6] := StrToInt(AValue[6]);
  N[7] := StrToInt(AValue[7]);
  N[8] := StrToInt(AValue[8]);
  N[9] := StrToInt(AValue[9]);

  D1 := N[9] * 2 + N[8] * 3 + N[7] * 4 + N[6] * 5 + N[5] * 6 + N[4] * 7 + N[3] * 8 + N[2] * 9 + N[1] * 10;
  D1 := 11 - (D1 mod 11);
  D1 := IfThen(D1 > 10, 0, D1);

  D2 := D1 * 2 + N[9] * 3 + N[8] * 4 + N[7] * 5 + N[6] * 6 + N[5] * 7 + N[4] * 8 + N[3] * 9 + N[2] * 10 + N[1] * 11;
  D2 := 11 - (D2 mod 11);
  D2 := IfThen(D2 > 10, 0, D2);

  S1 := AValue[10] + AValue[11];
  S2 := IntToStr(D1) + IntToStr(D2);

  Result := S1.Equals(S2);
end;

function CheckInternet: Boolean;
begin
  Result := CheckPort('google.com', 80);
end;

function CheckIP(AAddress: string): Boolean;
var
  vGroup: TArray<string>;
  I     : Integer;
begin
  Result := False;

  if AAddress.IsEmpty then
    Exit;

  vGroup := AAddress.Split(['.']);
  for I  := 0 to High(vGroup) do
  begin
    Result := (not vGroup[I].IsEmpty) and (InRange(StrToIntDef(vGroup[I], -1), 0, 255));
    if not Result then
      Break;
  end;
end;

function CheckPort(AHost: string; APort: Word): Boolean;
var
  TCPClient: TIdTCPClient;
begin
  Result := False;

  TCPClient := TIdTCPClient.Create(GetApplication);
  try

    TCPClient.Host := AHost;
    TCPClient.Port := APort;
    try
      TCPClient.Connect;
      Result := True;
    except
      Exit;
    end;
    TCPClient.Disconnect;
  finally
    FreeAndNil(TCPClient);
  end;
end;

function ClassContext(AClass: TClass): TRttiType;
var
  Ctx: TRttiContext;
begin
  Ctx    := TRttiContext.Create;
  Result := Ctx.GetType(AClass.ClassInfo);
end;

function ClassFields(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiField>;
begin
  Result := TArray<TRttiField>(ClassMembers(AClass, TClassMember.cmField, ADeclaredOnly));
end;

function ClassMembers(AClass: TClass; AMember: TClassMember; ADeclaredOnly: Boolean): TArray<TRttiMember>;
var
  LRttiType: TRttiType;
begin
  LRttiType := ClassContext(AClass);
  with LRttiType do
  begin
    try
      case AMember of
        cmField:
          if ADeclaredOnly then
            Result := TArray<TRttiMember>(GetDeclaredFields)
          else
            Result := TArray<TRttiMember>(GetFields);

        cmProperty:
          if ADeclaredOnly then
            Result := TArray<TRttiMember>(GetDeclaredProperties)
          else
            Result := TArray<TRttiMember>(GetProperties);

        cmMethod:
          if ADeclaredOnly then
            Result := TArray<TRttiMember>(GetDeclaredMethods)
          else
            Result := TArray<TRttiMember>(GetMethods);
      end;
    finally
      FreeAndNil(LRttiType);
    end;
  end;
end;

function ClassMemberList(AClass: TClass; AMember: TClassMember; ADeclaredOnly: Boolean): TStrings;
var
  Member: TRttiMember;
begin
  Result := TStringList.Create;

  for Member in ClassMembers(AClass, AMember, ADeclaredOnly) do
    Result.Add(Member.Name);
end;

function ClassMethods(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiMethod>;
begin
  Result := TArray<TRttiMethod>(ClassMembers(AClass, TClassMember.cmMethod, ADeclaredOnly));
end;

function ClassProperties(AClass: TClass; ADeclaredOnly: Boolean = False): TArray<TRttiProperty>;
begin
  Result := TArray<TRttiProperty>(ClassMembers(AClass, TClassMember.cmProperty, ADeclaredOnly));
end;

procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
begin
  CustomMessage(AMessage, TMsgDlgType.mtConfirmation,
    procedure (const aModalResult: TModalResult)
    begin
      if Assigned(aCloseDialogProc) then
        aCloseDialogProc(aModalResult in [mrOk, mrYes, mrYesToAll, mrContinue, mrAll]);
    end);

end;

procedure ConnectDatabase;
begin
  LoadSettings;
  FindConnection;

  DataConnection.Connected := False;
  DataConnection.Params.LoadFromFile(SettingsFileName);

  DataConnection.DriverName := AnsiUpperCase(DataConnection.Params.Values[cDriverName]);
  DataConnection.Connected  := True;

  with Database do
  begin
    Driver := DataConnection.DriverName;

    if Driver = 'ORACLE' then
    begin
      ID              := dbOracle;
      FriendlyName    := 'Oracle';
      Collate         := '';
      ClauseMaxRecord := 'ROWNUM';
    end
    else if Driver = 'MSSQL' then
    begin
      ID              := dbMsSQL;
      FriendlyName    := 'SQL Server';
      Collate         := 'LATIN1_GENERAL_CI_AI';
      ClauseMaxRecord := 'TOP';
    end
    else if Driver = 'MYSQL' then
    begin
      ID              := dbMySQL;
      FriendlyName    := 'MySQL';
      Collate         := '';
      ClauseMaxRecord := 'LIMIT';
    end
    else if Driver = 'FIREBIRD' then
    begin
      ID              := dbFirebird;
      FriendlyName    := 'Firebird';
      Collate         := 'PT_BR';
      ClauseMaxRecord := 'FIRST';
    end;

    Collate := 'COLLATE ' + Database.Collate;
  end;
end;

function CurrentPID: Integer;
begin
{$IFNDEF IS_MOBILE}
  Result := GetCurrentProcessId;
{$ELSE}
  Result := 0;
{$ENDIF IS_MOBILE}
end;

procedure CustomMessage(AMessage: string; AType: TMsgDlgType;
  aCloseDialogProc: TInputCloseDialogProc);
var
  vButtons     : TMsgDlgButtons;
  {$IFNDEF FIREMONKEY}
  LResult: Integer;
  {$ENDIF FIREMONKEY}
begin
  case AType of
    TMsgDlgType.mtWarning, TMsgDlgType.mtError, TMsgDlgType.mtInformation:
      vButtons := [TMsgDlgBtn.mbOK];

    TMsgDlgType.mtConfirmation:
      vButtons := [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo];
  end;

  {$IFDEF FIREMONKEY}FMX.Dialogs.{$ELSE}LResult := VCL.Dialogs.{$ENDIF}
    MessageDlg(AMessage, AType, vButtons, 0{$IFDEF FIREMONKEY}, aCloseDialogProc{$ENDIF FIREMONKEY});

  {$IFNDEF FIREMONKEY}
  if Assigned(aCloseDialogProc) then
    aCloseDialogProc(LResult);
  {$ENDIF FIREMONKEY}
end;

function Decrypt(AText, AKey: string): string;
begin
  Result := Encryption(emDecrypt, AText, AKey);
end;

function Encrypt(AText, AKey: string): string;
begin
  Result := Encryption(emEncrypt, AText, AKey);
end;

function Encryption(AMode: TEncryptionMode; AText, AKey: string): string;
const
  HexChar    = '$';
  DestFormat = '%1.2x';
var
  KeyLen, KeyPos, OffSet, Range, TextPos, TextAsc, TempTextAsc: Integer;
  Dest: string;
begin
  Result := '';

  if AText.IsEmpty then
    Exit;

  if AKey.IsEmpty then
    AKey := cKey;

  Dest    := '';
  KeyLen  := AKey.Length;
  KeyPos  := 0;
  Range   := 256;

  case AMode of
    emEncrypt:
      begin
        Randomize;
        OffSet      := Random(Range);
        Dest        := Format(DestFormat, [OffSet]);
        for TextPos := 1 to AText.Length do
        begin
          TextAsc := (Ord(AText[TextPos]) + OffSet) mod 255;

          if KeyPos < KeyLen then
            Inc(KeyPos)
          else
            KeyPos := 1;

          TextAsc := TextAsc xor Ord(AKey[KeyPos]);

          Dest   := Dest + Format(DestFormat, [TextAsc]);
          OffSet := TextAsc;
        end;
      end;

    emDecrypt:
      begin
        OffSet  := StrToInt(HexChar + Copy(AText, 1, 2));
        TextPos := 3;
        repeat
          TextAsc := StrToInt(HexChar + Copy(AText, TextPos, 2));

          if TextAsc = -1 then
          begin
            Result := AText;
            Exit;
          end;

          if KeyPos < KeyLen then
            Inc(KeyPos)
          else
            KeyPos := 1;

          TempTextAsc := TextAsc xor Ord(AKey[KeyPos]);

          if TempTextAsc <= OffSet then
            TempTextAsc := 255 + TempTextAsc - OffSet
          else
            TempTextAsc := TempTextAsc - OffSet;

          Dest   := Dest + Chr(TempTextAsc);
          OffSet := TextAsc;
          Inc(TextPos, 2);
        until (TextPos >= AText.Length);
      end;
  end;

  Result := Dest;
end;

function ExternalIP: string;
var
  vList : TStringList;
  vIndex: Integer;
  vURL  : string;
begin

  Result := '';

  if CheckInternet then
  begin
    vList := TStringList.Create;
    vList.Add('http://dynupdate.no-ip.com/ip.php');
    vList.Add('http://checkip.dyndns.org');
    vList.Add('http://checkip.dyndns.org:8245');

    repeat
      vIndex := RandomRange(0, vList.Count);
      vURL   := vList[vIndex];

      Result := HttpGet(vURL);

      if Result.Contains(':') then
      begin
        Result := RemoveLineBreak(Result);
        Result := RemoveTag(Result);
        Result := Copy(Result, Pos(':', Result) + 2);
      end;
    until CheckIP(Result);

    FreeAndNil(vList);
  end;
end;

function FileHash(APath: string): string;
begin
  Result := Hash(APath, hmFile);
end;

function FindConnection: TFDConnection;
var
  A, B     : Integer;
  Component: TComponent;
begin
  Result := DataConnection;
  if Assigned(Result) then
    Exit;

  for A := 0 to Pred(GetApplication.ComponentCount) do
  begin
    for B := 0 to Pred(GetApplication.Components[A].ComponentCount) do
    begin
      Component := GetApplication.Components[A].Components[B];
      if (Component is TFDConnection) then
      begin
        Result         := (Component as TFDConnection);
        DataConnection := Result;
        Exit;
      end;
    end;
  end;
  if not Assigned(Result) then
  begin
    ErrorMessage('Connection object not found');
    FinalizeApplication;
  end;
end;

function Focused(AControl: TControl): Boolean;
begin
  Result := (AControl = ActiveControl);
end;

function FullApplicationPath: string;
begin
  {$IFDEF ANDROID}
  Result := GetDiretorioAsp + TAndroidHelper.ApplicationTitle + '.apk' //mirrai
  {$ELSE}
    {$IFDEF IOS}
    raise Exception.Create('Full Application Path not Allowed on iOS'); //***IOS
    {$ELSE}
    Result := ParamStr(0);
    {$ENDIF}
  {$ENDIF ANDROID}
end;

function GenerateString(ALength: Integer; AContent: string): string;
var
  I    : Integer;
  vChar: Char;
begin
  Result := '';

  AContent := IfThen(AContent.IsEmpty, (cNumbers + cLetters), AContent);

  for I := 0 to Pred(ALength) do
  begin
    vChar  := AContent[Succ(Random(Length(AContent)))];
    Result := Result + vChar;
  end;
end;

function Hash(AValue: string; AMode: THashMode): string;
var
  vHashMD5              : TIdHashMessageDigest5;
  vFileStream           : TFileStream;
begin
  Result                 := '';
  try
    vHashMD5 := TIdHashMessageDigest5.Create;
    try
      case AMode of
        hmFile:
          begin
            if FileExists(AValue) then
            begin
              vFileStream            := TFileStream.Create(AValue, fmOpenRead or fmShareDenyWrite);
              try
                Result                 := vHashMD5.HashStreamAsHex(vFileStream);
              finally
                FreeAndNil(vFileStream);
              end;
            end;
          end;

        hmText:
          begin
            Result := vHashMD5.HashStringAsHex(AValue);
          end;
      end;
    finally
      FreeAndNil(vHashMD5);
    end;
  except
    TLog.MyLog('Erro ao criptografar valor.', nil, 0, True);
  end;
end;

function HttpRequest(AMode: TRequestMode; AURL: string; AParams: TStrings; var AContent: TStream): string;
var
  vHTTP: TIdHTTP;
begin
  Result := '';

  if not CheckInternet then
    Exit;

  vHTTP := TIdHTTP.Create(GetApplication);
  try
    vHTTP.HandleRedirects   := True;
    vHTTP.HTTPOptions       := [hoForceEncodeParams];
    vHTTP.ProtocolVersion   := pv1_1;
    vHTTP.Request.UserAgent := 'Mozilla/5.0 (compatible; MSIE)';

    case AMode of
      rmGet:
        begin
          if Assigned(AContent) then
            vHTTP.Get(AURL, AContent)
          else
            Result := vHTTP.Get(AURL);
        end;

      rmPost:
        begin
          if Assigned(AContent) then
            vHTTP.Post(AURL, AParams, AContent)
          else
            Result := vHTTP.Post(AURL, AParams);
        end;
    end;
  finally
    FreeAndNil(vHTTP);
  end;
end;

function HttpGet(AURL: string): string;
var
  vStream: TStream;
begin
  vStream := nil;
  Result  := HttpRequest(rmGet, AURL, nil, vStream);
end;

function HttpPost(AURL: string; AParams: TStrings): string;
var
  vStream: TStream;
begin
  vStream := nil;
  Result  := HttpRequest(rmPost, AURL, AParams, vStream);
end;

function HtmlDecode(AText: string): string;
var
  I: Integer;
  C: Char;
  H: string;
begin
  Result := AText;
  for I  := 0 to 255 do
  begin
    C      := Chr(I);
    H      := '&#' + IntToStr(I) + ';';
    Result := Result.Replace(H, C);
  end;
end;

function InternalIP: string;
var
  vIPWatch: TIdIPWatch;
begin
  Result   := '';
  vIPWatch := TIdIPWatch.Create(GetApplication);
  try
    vIPWatch.HistoryEnabled := False;
    vIPWatch.ForceCheck;
    Result := vIPWatch.LocalIP;
  finally
    FreeAndNil(vIPWatch);
  end;
end;

function InternetDateTime(ASyncTime: Boolean): TDateTime;
var
  vSNTP: TIdSNTP;
begin
  vSNTP  := TIdSNTP.Create(GetApplication);
  try
    vSNTP.Host := 'pool.ntp.org';
    Result     := vSNTP.DateTime;
    if ASyncTime then
      vSNTP.SyncTime;
  finally
    FreeAndNil(vSNTP);
  end;
end;

function LineBreak(ACount: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I  := 0 to Pred(ACount) do
  begin
    Result := Result + Char(vkReturn) + Char(vkLineFeed);
  end;
end;

function Mask(AValue: Variant; AMask: string): string;
begin
  AValue := RemoveMask(AValue);
  Result := FormatMaskText(AMask + ';0', VarToStr(AValue));
end;

function MemberClass(AMember: TRttiMember): TClass;
begin
  Result := nil;
  if Assigned(AMember.Parent.Handle) then
    Result := TRttiInstanceType(AMember.Parent).MetaClassType;
end;

function ClassMemberName(const AMember): string;
begin
  Result := TRttiMember(AMember).Name;
end;

function MobileDevice: Boolean;
begin
{$IFDEF IS_MOBILE}
  Result := True;
{$ELSE}
  Result := False;
{$ENDIF IS_MOBILE}

end;

function PlatformToString(APlatform: TOSVersion.TPlatform): string;
begin
  Result := '';
  case APlatform of
    pfWindows:
      Result := 'Windows';

    pfMacOS:
      Result := 'MacOS';

    pfiOS:
      Result := 'iOS';

    pfAndroid:
      Result := 'Android';

    pfWinRT:
      Result := 'WinRT';

    pfLinux:
      Result := 'Linux';
  end;
end;

function PropertyExists(AObject: TObject; AName: string): Boolean;
begin
  Result := Assigned(GetPropInfo(AObject.ClassInfo, AName));
end;

procedure GetObjectDaPropriedade(var aObject: TObject; var aListaPropriedades: string);
var
  LNomePropriendade: String;
begin
  while aListaPropriedades.Contains('.') do
  begin
    LNomePropriendade := aListaPropriedades.Substring(0, aListaPropriedades.IndexOf('.'));
    aListaPropriedades := aListaPropriedades.Substring(Succ(aListaPropriedades.IndexOf('.')));

    if Assigned(aObject) and PropertyExists(aObject, LNomePropriendade) then
      aObject := GetObjectProp(aObject, LNomePropriendade);
  end;
end;

function AspLerPropriedade(aComponente: TComponent; const aNomePropriedade: string; const aValorPadrao: Variant): Variant;
var
  LObject          : TObject;
  LNomePropriendade, LListaPropriedades: string;
begin
  Result := aValorPadrao;

  LListaPropriedades := aNomePropriedade;
  LNomePropriendade := aNomePropriedade;
  LObject := aComponente;
  GetObjectDaPropriedade(LObject, LListaPropriedades);
  if Assigned(LObject) and PropertyExists(LObject, LListaPropriedades) then
    Result := GetPropValue(LObject, LListaPropriedades);
end;


{$IFDEF FIREMONKEY}
procedure AspAtualizarPropriedade(aForm: FMX.Forms.TCommonCustomForm; aComponente: TObject; const aNomePropriedade: string; const aValorPropriedade: Variant);
var
  LObject          : TObject;
  LNomePropriendade, LListaPropriedades: string;
begin
  if not Assigned(aComponente) then
    Exit;

  LListaPropriedades := aNomePropriedade;
  LNomePropriendade := aNomePropriedade;
  LObject := aComponente;
  GetObjectDaPropriedade(LObject, LListaPropriedades);

  if Assigned(LObject) and PropertyExists(LObject, LListaPropriedades) then
  begin
    SetPropValue(aComponente, LListaPropriedades, aValorPropriedade);
    if Assigned(aForm) then
      aForm.Invalidate;
  end;
end;
{$ENDIF FIREMONKEY}

function ReadIniFile(AniFile: TIniFile; const ASection, AIdent: string; const ADefault: Variant; const aCanForceWrite: Boolean = true): Variant; Overload;
begin
  Result := '';
  if (Assigned(AniFile) and (not WriteIniFile(AniFile, ASection, AIdent, VarToStr(ADefault), False, aCanForceWrite))) then
    Result := AniFile.ReadString(ASection, AIdent, '');

  if VarToStr(Result) = '' then
    Result := ADefault;
end;

function ReadIniFile(const APath, ASection, AIdent: string; const ADefault: Variant; const aCanForceWrite: Boolean = true): Variant; Overload;
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(APath);
  try
    Result := ReadIniFile(vIniFile, ASection, AIdent, ADefault, aCanForceWrite);
  finally
    FreeAndNil(vIniFile);
  end;
end;

function ReadSettings(ASection, AIdent: string; ADefault: Variant; const aCanForceWrite: Boolean): Variant;
begin
  Result := ReadIniFile(SettingsFileName, ASection, AIdent, ADefault, aCanForceWrite);
end;

function RemoveCharacter(AText, ACharacters: string): string;
var
  I: Integer;
begin
  Result := AText;
  for I  := 0 to High(ACharacters) do
  begin
    Result := Result.Replace(ACharacters[I], '');
  end;
end;

function RemoveLineBreak(AText: string): string;
begin
  AText  := AText.Replace(Char(vkLineFeed), Space, [rfReplaceAll]);
  Result := RemoveCharacter(AText, Char(vkReturn) + Char(vkLineFeed));
end;

function RemoveMask(AText: string): string;
begin
  Result := RemoveCharacter(AText, ' |()/\.-_:,');
end;

function RemoveThousandSeparator(AText: string): string;
begin
  Result := RemoveCharacter(AText, FormatSettings.ThousandSeparator);
end;

function RemoveTag(AText, AOpenTag, ACloseTag: string): string;
var
  A, B  : Integer;

  procedure ReadTagPosition;
  begin
    A := Pos(AOpenTag, Result);
    B := Pos(ACloseTag, Result);
  end;

begin
  Result := AText;

  ReadTagPosition;
  while ((A > 0) and (B > 0) and (A < B)) do
  begin
    Delete(Result, A, (B + ACloseTag.Length) - A);
    ReadTagPosition;
  end;
end;

function RemoveTag(AText: string): string;
begin
  Result := RemoveTag(AText, '<', '>');
end;

{$IFDEF FIREMONKEY}
function SaveControlAsImage(AObject: TFmxObject; AFileName: string): Boolean;
var
  vBitmap: FMX.Graphics.TBitmap;
begin
  vBitmap := FMX.Graphics.TBitmap.Create;
  try
    vBitmap.Clear(TAlphaColorRec.White);
    if AObject is TForm then
    begin
      vBitmap.Width  := Round(FMX.Forms.TForm(AObject).Canvas.Width);
      vBitmap.Height := Round(FMX.Forms.TForm(AObject).Canvas.Height);
    end
    else
    begin
      vBitmap.Width  := Round(FMX.Controls.TControl(AObject).Width);
      vBitmap.Height := Round(FMX.Controls.TControl(AObject).Height);
    end;
    if vBitmap.Canvas.BeginScene then
    begin
      if AObject is FMX.Forms.TForm then
      begin
        FMX.Forms.TForm(AObject).PaintTo(vBitmap.Canvas);
      end
      else
      begin
        FMX.Controls.TControl(AObject).PaintTo(vBitmap.Canvas, RectF(0, 0, vBitmap.Width, vBitmap.Height));
      end;
      vBitmap.Canvas.EndScene;
    end;
    vBitmap.SaveToFile(AFileName);
    Result := True;
  finally
    FreeAndNil(vBitmap);
  end;
end;

function ScreenSize: TPoint;
var
  ScreenSvc: IFMXScreenService;
  Size     : TPointF;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenSvc)) then
  begin
    Size     := ScreenSvc.GetScreenSize;
    Result.X := Round(Size.X);
    Result.Y := Round(Size.Y);
  end;
end;
{$ENDIF FIREMONKEY}


function AspLib_GetAppIniFileName : string;
begin
  Result := SettingsFileName;
end;

function SettingsFileName: string;
var
  vFileName: string;
begin
  if FSettingsFileName = '' then
  begin
    vFileName := ApplicationName('.ini'); //SICS PA.Ini
    FSettingsFileName := SettingsPathName + vFileName;//Este verificar Retorna: /storage/emulated/0/SICS PA.Ini
  end;
  Result := FSettingsFileName;
end;

function GetAppIniFileName: string;
begin
  Result := SettingsFileName;
end;

function AppMessageBox(Text : string; Caption : string; Flags : integer) : integer;
var
  LResult: Integer;
const
  {$IFDEF IS_MOBILE}
  AppMessageBox_Erro = 0;
  AppMessageBox_Confirmation = AppMessageBox_Erro + 1;
  AppMessageBox_Warning = AppMessageBox_Confirmation + 1;
  AppMessageBox_Information = AppMessageBox_Warning + 1;
  {$ELSE}
  AppMessageBox_Erro = MB_ICONHAND;
  AppMessageBox_Confirmation = MB_ICONQUESTION;
  AppMessageBox_Warning = MB_ICONEXCLAMATION;
  AppMessageBox_Information = MB_ICONASTERISK;
  {$ENDIF IS_MOBILE}
begin
  Result := mrOk;

  if (Flags >= AppMessageBox_Information)  then
    InformationMessage(Text)
  else
  if (Flags>= AppMessageBox_Warning) then
    WarningMessage(Text)
  else
  if (Flags >= AppMessageBox_Confirmation) then
  begin
    LResult := mrNone;
    try
      ConfirmationMessage(Text,
        procedure (const aResult: Boolean)
        begin
          if aResult then
            LResult := mrYes
          else
            LResult := mrNo;
        end);
      while (LResult = mrOk) do
      begin
        Sleep(100);
      end;
    finally
      Result := LResult;
    end;
  end
  else
    ErrorMessage(Text);
end;

function SetWhereClause(ASQL, ACondition: string): string;
var
  vGroupBy     : Boolean;
  vHaving      : Boolean;
  vOrderBy     : Boolean;
  vPosCondition: Integer;
  vPosGroupBy  : Integer;
  vPosHaving   : Integer;
  vPosOrderBy  : Integer;
  vPosWhere    : Integer;
  vWhere       : Boolean;

  function PositionWhereClause: Integer;
  const
    cClause = ' WHERE ';
  var
    S             : string;
    I, X, vPosX, Y: Integer;
  begin
    Result := 0;
    Y      := 0;
    X      := Length(cClause);
    for I  := Length(ASQL) downto 0 do
    begin
      vPosX := (I - X + 1);
      S     := Copy(ASQL, vPosX, X);
      if (Pos(')', S) > 0) then
        Inc(Y);
      if (Pos('(', S) > 0) then
        Dec(Y);

      if (Y <= 0) and SameText(S, cClause) then
      begin
        Result := (vPosX);
        Break;
      end;
    end;
  end;

  function PositionOrderByClause: Integer;
  const
    cClause = ' ORDER BY ';
  var
    S          : string;
    I, X, vPosX: Integer;
  begin
    Result := 0;
    X      := Length(cClause);
    for I  := Length(ASQL) downto 0 do
    begin
      vPosX := (I - (X + 1));
      S     := Copy(ASQL, vPosX, X);

      if SameText(S, cClause) then
      begin
        Result := (vPosX);
        Break;
      end;
    end;
  end;

  function PositionGroupByClause: Integer;
  const
    cClause = ' GROUP BY ';
  var
    S          : string;
    I, X, vPosX: Integer;
  begin
    Result := 0;
    X      := Length(cClause);
    for I  := Length(ASQL) downto 0 do
    begin
      vPosX := (I - (X + 1));
      S     := Copy(ASQL, vPosX, X);

      if SameText(S, cClause) then
      begin
        Result := (vPosX);
        Break;
      end;
    end;
  end;

  function PositionHavingClause: Integer;
  const
    cClause = ' HAVING ';
  var
    S          : string;
    I, X, vPosX: Integer;
  begin
    Result := 0;
    X      := Length(cClause);
    for I  := Length(ASQL) downto 0 do
    begin
      vPosX := (I - (X + 1));
      S     := Copy(ASQL, vPosX, X);

      if SameText(S, cClause) then
      begin
        Result := (vPosX);
        Break;
      end;
    end;
  end;

begin
  ASQL       := RemoveLineBreak(ASQL).Trim;
  ACondition := RemoveLineBreak(ACondition).Trim;

  if ASQL.IsEmpty or ACondition.IsEmpty then
  begin
    Result := ASQL;
    Exit;
  end;

  vPosWhere := PositionWhereClause;
  vWhere    := (vPosWhere > 0);

  vPosOrderBy := PositionOrderByClause;
  vOrderBy    := (vPosOrderBy > 0);

  vPosGroupBy := PositionGroupByClause;
  vGroupBy    := (vPosGroupBy > 0);

  vPosHaving := PositionHavingClause;
  vHaving    := (vPosHaving > 0);

  vPosCondition := (Length(ASQL) + 1);

  if vOrderBy then
    vPosCondition := vPosOrderBy;

  if vGroupBy then
    vPosCondition := vPosGroupBy;

  if vHaving then
    vPosCondition := vPosHaving;

  if vWhere then

    vPosCondition := (vPosWhere + 6);

  if vWhere then
    ACondition := ' (' + ACondition + ') AND '
  else
    ACondition := ' WHERE (' + ACondition + ') ';

  Insert(ACondition, ASQL, vPosCondition);

  Result := ASQL;
end;

function TextHash(AText: string): string;
begin
  Result := Hash(AText, hmText);
end;

function UnicodeChar(AChar: Char): Char;
begin
  Result := AChar;
  // ? ? ? ? ? ?
end;

function WriteDebugLog(AText: string): Boolean;
begin
  Result := False;
  // if Settings.WriteDebugLog then
  // WriteLog('DEBUG: ' + AText);
end;

function WriteIniFile(var aIniFile: TIniFile; const ASection, AIdent: string; const AValue: Variant;
  const AOverwrite, aCanForceWrite: Boolean): Boolean;
var
  vValueExists: Boolean;
begin
  Result := False;
  if not Assigned(aIniFile) then
    Exit;

  vValueExists := aIniFile.ValueExists(ASection, AIdent);
  if (vValueExists and AOverwrite) or (aCanForceWrite and (not vValueExists)) then
  begin
    Result := True;
    aIniFile.WriteString(ASection, AIdent, VarToStr(AValue));
  end;
end;

function WriteIniFile(const APath, ASection, AIdent: string; const AValue: Variant;
  const AOverwrite, aCanForceWrite: Boolean): Boolean;
var
  vIniFile    : TIniFile;
begin
  vIniFile := TIniFile.Create(APath);
  try
    Result := WriteIniFile(vIniFile, ASection, AIdent, AValue, AOverwrite, aCanForceWrite);
  finally
    FreeAndNil(vIniFile);
  end;
end;


function WriteLog(AText: string): Boolean;
begin
  Result := False;
  //AText := FormatDateTime('dd/mm/yyyy hh:nn:ss,zzz', Now) + LineBreak + AText + LineBreak(2);
  // Result := WriteTextFile(Settings.LogFileName, AText, True);
end;

function WriteSettings(ASection, AIdent: string; AValue: Variant; const aCanForceWrite: Boolean): Boolean;
begin
  Result := WriteIniFile(SettingsFileName, ASection, AIdent, AValue, True, aCanForceWrite);
end;

function WriteSettings(AIdent: string; AValue: Variant; const aCanForceWrite: Boolean): Boolean;
begin
  Result := WriteSettings(cSettings, AIdent, AValue, aCanForceWrite);
end;

function WriteTextFile(APath, AText: string; AAppend: Boolean): Boolean;
var
  vEncoding: TEncoding;
begin
  vEncoding := TEncoding.UTF8;

  if AAppend and FileExists(APath) then
    TFile.AppendAllText(APath, AText, vEncoding)
  else
  begin
    TFile.WriteAllText(APath, AText, vEncoding);
  end;
  Result := True;
end;

procedure Delay(AMillisecond: Integer);
const
  Interval = 250;
var
  A, B, C: Double;
  I      : Integer;
begin
  if AMillisecond > Interval then
  begin
    A := (AMillisecond / Interval);
    B := Int(A);
    C := AMillisecond - (B * Interval);

    for I := 1 to Round(B) do
    begin
      Sleep(Interval);
      GetApplication.ProcessMessages;
    end;
    Sleep(Round(C));
  end
  else
    Sleep(AMillisecond);
end;

procedure DisconnectDatabase;
begin
  if Assigned(DataConnection) then
    DataConnection.Connected := False;
end;

procedure ExecuteThread(AExecute, ATerminate: TProcedure; AShowProgress: Boolean; AMessage: string);
begin
  with TMultiThread.Create(AExecute, ATerminate, AShowProgress, AMessage) do
    Start;
end;

procedure ExecuteThread(AExecute: TProcedure; AMessage: string);
begin
  ExecuteThread(AExecute, nil, True, AMessage);
end;

procedure ExecuteThread(AExecute: TProcedure);
begin
  ExecuteThread(AExecute, nil, False, '');
end;

procedure ErrorHandling(E: Exception);
begin
  TClassLibrary.ErrorHandling(nil, E);
end;

procedure ErrorMessage(const AMessage: string);
begin
  TLog.MyLog(AMessage, nil);
  CustomMessage(AMessage, TMsgDlgType.mtError,
    procedure (const AResult: TModalResult)
    begin

    end);
end;
procedure ErrorMessageWithoutLog(const AMessage: string);
begin
  CustomMessage(AMessage, TMsgDlgType.mtError,
    procedure (const AResult: TModalResult)
    begin

    end);
end;



procedure ErrorStopMessage(const AMessage: string);
begin
  ErrorMessage(AMessage);
end;

procedure FinalizeApplication;
begin
{$IFDEF ANDROID}
  MainActivity.finish;
{$ELSE}
  {$IFDEF IOS}
  //***IOS
  //no iOS n„o se pode finalizar a aplicaÁ„o. verificar onde a funÁ„o È chamada
  //e proceder com o tratamento correto
  {$ELSE}
  Halt;
  {$ENDIF}
{$ENDIF}
end;

procedure HttpGet(AURL: string; var AContent: TStream);
begin
  HttpRequest(rmGet, AURL, nil, AContent);
end;

procedure HttpPost(AURL: string; AParams: TStrings; var AContent: TStream);
begin
  HttpRequest(rmPost, AURL, AParams, AContent);
end;

procedure InformationMessage(AMessage: string);
begin
  CustomMessage(AMessage, TMsgDlgType.mtInformation,
    procedure (const AResult: TModalResult)
    begin

    end);
end;

procedure LoadSettings;
begin

end;

procedure ReadDeviceInfo;

 {$IF Defined(ANDROID) or Defined(IOS)}
var
  Hardware: {$IFDEF ANDROID}JTelephonyManager{$ENDIF ANDROID}{$IFDEF IOS}UIDevice{$ENDIF IOS};

  {$IFDEF ANDROID}
  Obj      : JObject;
  {$ENDIF ANDROID}
{$ENDIF}

begin
  Device.Architecture     := TOSVersion.Architecture;
  Device.ArchitectureName := ArchitectureToString(Device.Architecture);
  Device.Platform         := TOSVersion.Platform;
  Device.PlatformName     := PlatformToString(Device.Platform);
  Device.IMEI             := '';
  Device.SerialNumber     := '';
  Device.Country          := '';
  Device.Carrier          := '';
  Device.CarrierName      := '';
  Device.LineNumber       := '';

  if MobileDevice then
  begin

{$IFDEF ANDROID}

    Obj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
    if Assigned(Obj) then
    begin
      Hardware := TJTelephonyManager.Wrap((Obj as ILocalObject).GetObjectID);
      if Assigned(Hardware) then
      begin
        Device.IMEI := JStringToString(Hardware.getDeviceId);

        if Device.IMEI.IsEmpty then
          Device.IMEI := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver, TJSettings_Secure.JavaClass.ANDROID_ID));

        Device.SerialNumber := JStringToString(Hardware.getSimSerialNumber);
        Device.Country      := JStringToString(Hardware.getSimCountryIso);
        Device.Carrier      := JStringToString(Hardware.getSimOperator);
        Device.CarrierName  := JStringToString(Hardware.getSimOperatorName);
        Device.LineNumber   := JStringToString(Hardware.getLine1Number);
      end;
    end;

{$ENDIF ANDROID}
{$IFDEF IOS}

    Hardware := TUIDevice.Wrap(TUIDevice.OCClass.currentDevice);
    if Assigned(Hardware) then
    begin

    end;

{$ENDIF IOS}

  end;
end;

procedure WarningMessage(AMessage: string);
begin
  CustomMessage(AMessage, TMsgDlgType.mtWarning,
    procedure (const AResult: TModalResult)
    begin

    end);
end;

{ TClassLibrary }

class procedure TClassLibrary.ErrorHandling(Sender: TObject; E: Exception);
begin
  TLog.TreatException('', nil, e);
end;

{ TMultiThread }

procedure TMultiThread.CloseProgressForm;
begin
  if Assigned(FProgressForm) and FShowProgress then
  begin
    FProgressForm.Close;
    // AniFrameRate := FAniFrameRate;
  end;
end;

constructor TMultiThread.Create(AExecute, ATerminte: TProcedure; AShowProgressForm: Boolean; AMessage: string);
begin
  inherited Create(True);

  FreeOnTerminate := True;

  FExecute   := AExecute;
  FTerminate := ATerminte;

  FShowProgress := AShowProgressForm;
  FMessage      := AMessage;

  OnTerminate := DoInternalTerminate;
end;

procedure TMultiThread.DoInternalTerminate(Sender: TObject);
begin
  if Assigned(FTerminate) then
    FTerminate;

  CloseProgressForm;
end;

procedure TMultiThread.Execute;
begin
  inherited;
  if Assigned(FExecute) then
    FExecute;
end;

procedure TMultiThread.ShowProgressForm;
var
  vRectangle: {$IFDEF FIREMONKEY}FMX.Objects.TRectangle{$ELSE}Vcl.ExtCtrls.TPanel{$ENDIF FIREMONKEY};
  vLabel    : TLabel;
  vAni      : {$IFDEF FIREMONKEY}FMX.StdCtrls.TAniIndicator{$ELSE}Vcl.ExtCtrls.TImage{$ENDIF FIREMONKEY};
begin

  if Assigned(FProgressForm) then
    Exit;

  // FAniFrameRate := AniFrameRate;
  // AniFrameRate  := 100;


  FProgressForm              := TForm.CreateNew(GetApplication);
  {$IFDEF FIREMONKEY}
  FProgressForm.BorderStyle  := TFmxFormBorderStyle.None;
  FProgressForm.Position     := TFormPosition.MainFormCenter;
  FProgressForm.Transparency := True;
  {$ELSE}
  FProgressForm.BorderStyle  := TFormBorderStyle.bsNone;
  FProgressForm.Position     := TPosition.poMainFormCenter;
  {$ENDIF FIREMONKEY}
  FProgressForm.Height       := 400;
  FProgressForm.Width        := 400;

  {$IFDEF FIREMONKEY}
  vRectangle            := FMX.Objects.TRectangle.Create(FProgressForm);
  vRectangle.Position.Y := FProgressForm.Height - vRectangle.Height - 50;
  vRectangle.Position.X := FProgressForm.Width / 5;
  {$ELSE}
  vRectangle            := Vcl.ExtCtrls.TPanel.Create(FProgressForm);
  vRectangle.Top        := FProgressForm.Height - vRectangle.Height - 50;
  vRectangle.Left       := Trunc(FProgressForm.Width / 5);
  {$ENDIF FIREMONKEY}
  vRectangle.Parent     := FProgressForm;
  vRectangle.Height     := 20;
  vRectangle.Width      := 250;

  vLabel                          := TLabel.Create(FProgressForm);
  vLabel.Parent                   := vRectangle;
  {$IFDEF FIREMONKEY}
  vLabel.Align                    := TAlignLayout.Client;
  vLabel.TextSettings.Font.Family := 'Verdana';
  vLabel.TextSettings.Font.Size   := 12;
  vLabel.TextSettings.HorzAlign   := TTextAlign.Center;
  vLabel.Text                     := FMessage;
  {$ELSE}
  vLabel.Align                    := TAlign.alClient;
  vLabel.Font.Name                := 'Verdana';
  vLabel.Font.Size                := 12;
  vLabel.Alignment                := TAlignment.taCenter;
  vLabel.Caption                     := FMessage;
  {$ENDIF FIREMONKEY}

  vAni        := {$IFDEF FIREMONKEY}FMX.StdCtrls.TAniIndicator{$ELSE}Vcl.ExtCtrls.TImage{$ENDIF FIREMONKEY}.Create(FProgressForm);
  vAni.Parent := FProgressForm;
  {$IFDEF FIREMONKEY}
  vAni.Align  := TAlignLayout.Center;
  {$ELSE}
  vAni.Align  := TAlign.alTop;
  {$ENDIF FIREMONKEY}
  vAni.Height := 150;
  vAni.Width  := 150;

  vAni.Enabled := True;

  vRectangle.Visible := not FMessage.IsEmpty;

  if MobileDevice then
    FProgressForm.Show
  else
    FProgressForm.ShowModal;
end;

procedure TMultiThread.Start;
begin
  inherited Start;

  if FShowProgress then
    ShowProgressForm;
end;

function GetDiretorioAsp: String;
begin
  if (FDiretorioAsp = '') then
  begin
    {$IFDEF IS_MOBILE}
    FDiretorioAsp := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath);
    {$ELSE}
    FDiretorioAsp := ExtractFilePath(ParamStr(0));
    {$ENDIF}
  end;
  Result := FDiretorioAsp;
end;

function ForceDirAsp(const aDiretorio: String): Boolean;
begin
  Result := System.SysUtils.ForceDirectories(aDiretorio);
end;

function SettingsPathName: string;
begin
  {$IFDEF IS_MOBILE}
  Result := GetDiretorioAsp;
  {$ELSE}
  Result := ApplicationPath;
  {$ENDIF}
end;

function ExisteNoIntArray(I: Integer; A: TIntegerDynArray): Boolean;
var
  J: Integer;
begin
  try
    Result := False;
    for J  := Low(A) to High(A) do
      if ((A[J] = I) or (A[J] = 0)) then
      begin
        Result := True;
        Break;
      end;
  except
    Result := False;
    Exit;
  end;
end;

function AspStrToIntArray(const S: string; const aConsiderarTodos: Boolean): TIntegerDynArray;
begin
  SetLength(Result, 0);
  StrToIntArray(s, Result, aConsiderarTodos);
end;

procedure StrToIntArray(S: string; var A: TIntegerDynArray; const aConsiderarTodos: Boolean);
var
  I, J, Comprimento, IndexPos: Integer;
  Aux              : string;
begin
  try
    Finalize(A);
    Comprimento := 0;
    if aConsiderarTodos and ((Pos('TODOS', AnsiUpperCase(S)) > 0) or
        (Pos('TODAS', AnsiUpperCase(S)) > 0) or
        (Pos('TODOS(AS)', AnsiUpperCase(S)) > 0)) then
    begin
      SetLength(A, 1);
      A[0] := 0;
    end
    else
    begin
      Aux   := '';
      {$IFDEF IS_MOBILE}
      for I := 0 to (Length(S)-1) do
      {$ELSE}
      for I := 1 to Length(S) do
      {$ENDIF}
      begin
        if ((S[I] = ';') or (S[I] = ',')) then
        begin
          IndexPos := Pos('-', Aux);
          if (IndexPos <= 0) then
          begin
            if Trim(Aux) <> '' then
            begin
              Comprimento := Comprimento + 1;
              SetLength(A, Comprimento);
              A[Comprimento - 1] := StrToIntDef(Trim(Aux), 0);
            end;
          end
          else
            for J := StrToIntDef(Trim(Copy(Aux, 1, IndexPos- 1)), 0) to
              StrToInt(Trim(Copy(Aux, IndexPos + 1, Length(Aux) - IndexPos))) do
            begin
              Comprimento := Comprimento + 1;
              SetLength(A, Comprimento);
              A[Comprimento - 1] := J;
            end;
          Aux := '';
        end
        else
          Aux := Aux + S[I];
      end;
      if Aux <> '' then
      begin
        IndexPos := Pos('-', Aux);
        if (IndexPos <= 0) then
        begin
          Comprimento := Comprimento + 1;
          SetLength(A, Comprimento);
          A[Comprimento - 1] := StrToIntDef(Trim(Aux), 0);
        end
        else
          for J := StrToIntDef(Trim(Copy(Aux, 1, Pos('-', Aux) - 1)), 0) to
            StrToIntDef(Trim(Copy(Aux, Pos('-', Aux) + 1, Length(Aux) - Pos('-', Aux))), 0) do
          begin
            Comprimento := Comprimento + 1;
            SetLength(A, Comprimento);
            A[Comprimento - 1] := J;
          end;
      end;
    end;
  except
    A := nil;
    Exit;
  end;
end;

procedure IntArrayToStr(const A: TIntegerDynArray; var S: string; const aConsiderarTodos: Boolean);
begin
  s := AspIntArrayToStr(a, aConsiderarTodos);
end;

function AspIntArrayToStr(const A: TIntegerDynArray; const aConsiderarTodos: Boolean): String;
var
  I, Primeiro, Ultimo, Atual: Integer;
begin
  Result := '';
  try
    if Length(A) <= 0 then
    begin
      Exit;
    end;

    if aConsiderarTodos and ExisteNoIntArray(0, A) then
    begin
      Result := 'Todos(as)';
    end
    else
    begin
      Primeiro := A[0];
      Ultimo   := A[0];
      for I    := low(A) + 1 to high(A) do
      begin
        Atual := A[I];
        if Atual - Ultimo > 1 then
        begin
          if Ultimo <> Primeiro then
            Result := Result + inttostr(Primeiro) + '-' + inttostr(Ultimo) + ';'
          else
            Result := Result + inttostr(Primeiro) + ';';
          Primeiro := Atual;
          Ultimo   := Atual;
        end
        else
        begin
          Ultimo := Atual;
        end;
      end;

      if Ultimo <> Primeiro then
        Result := Result + inttostr(Primeiro) + '-' + inttostr(Ultimo)
      else
        Result := Result + inttostr(Primeiro);
    end;
  except
    Result := '';
    Exit;
  end;
end;

procedure SeparaStrings(const aValue, aSeparador: string; var Antes, Depois: string);
var
  LIndexValue: integer;
begin
  LIndexValue := Pos(aSeparador, aValue);
  if LIndexValue <= 0 then
  begin
    Antes  := aValue;
    Depois := '';
  end
  else
  begin
    Antes  := Copy(aValue, 1, LIndexValue - 1);
    Depois := Copy(aValue, LIndexValue + Length(aSeparador), Length(aValue) -
      LIndexValue - Length(aSeparador) + 1);
  end;
end;

function AspAnsiStringToString(const aValue: TAspAnsiString): String;
begin
  Result := string(aValue);
end;

function AspAnsiCharToString(const aValue:  TAspAnsiChar): String;
begin
  Result := string(aValue);
end;

function AspStringToAnsiString(const aValue: String): TAspAnsiString;
begin
  Result := TAspAnsiString(aValue);
end;

function AspFindComponentAndSubComp(const aOwner: TComponent; const AName: string;
  const aFindInSubComponent: Boolean; const aValidComponent: TValidComponent): TComponent;

  function IsComponentFinder(const aComponent: TComponent): Boolean;
  begin
    if Assigned(aValidComponent) then
      Result := (Assigned(aComponent) and aValidComponent(aComponent)) and
        ((AName = '') or (Pos(UpperCase(AName), UpperCase(aComponent.Name)) = 1))
    else
      Result := (Assigned(aComponent) and (UpperCase(aComponent.Name) = UpperCase(AName)));
  end;

  function InternalFindComponentSub(const aComponent: TComponent): TComponent;
  var
    i            : Integer;
    LSubComponent: TComponent;
  begin
    Result := nil;
    if not Assigned(aComponent) then
      Exit;

    if IsComponentFinder(aComponent) then
    begin
      Result := aComponent;
      Exit;
    end;
    Result := aComponent.FindComponent(AName);

    if (aFindInSubComponent and (not Assigned(Result))) then
    begin
      for i := 0 to aComponent.ComponentCount - 1 do
      begin
        LSubComponent := aComponent.Components[i];
        if not (Assigned(LSubComponent) and (LSubComponent <> aComponent)) then
          Continue;
        if IsComponentFinder(LSubComponent) then
        begin
          Result := LSubComponent;
          Exit;
        end;
        Result := InternalFindComponentSub(LSubComponent);
        if Assigned(Result) then
          Exit;
      end;
    end;

  end;

begin
  Result := nil;
  if (AName <> '') or Assigned(aValidComponent) then
    Result := InternalFindComponentSub(aOwner);
end;


{$IFNDEF AplicacaoFiremokeySemVCL}
function GetSelectValue(const aLista: Vcl.StdCtrls.TListBox): String;
begin
  Result := EmptyStr;
  if (aLista.ItemIndex > -1) then
    Result := aLista.Items[aLista.ItemIndex];
end;

procedure AspAtualizarPropriedade(aForm: Vcl.Forms.TForm; aComponente: TObject; const aNomePropriedade: string; const aValorPropriedade: Variant);
var
  LObject          : TObject;
  LNomePropriendade, LListaPropriedades: string;
begin
  if not Assigned(aComponente) then
    Exit;

  LListaPropriedades := aNomePropriedade;
  LNomePropriendade := aNomePropriedade;
  LObject := aComponente;
  GetObjectDaPropriedade(LObject, LListaPropriedades);

  if Assigned(LObject) and PropertyExists(LObject, LListaPropriedades) then
  begin
    SetPropValue(aComponente, LListaPropriedades, aValorPropriedade);
    if Assigned(aForm) then
      aForm.Invalidate;
  end;
end;
{$ENDIF AplicacaoFiremokeySemVCL}

{$J+}

{$IFNDEF IS_MOBILE}
function CopyFolder(DirFonte, DirDest: String): boolean;
var
  ShFileOpStruct: TShFileOpStruct;
begin
  Result := False;
  if (DirFonte <> '') and (DirDest <> '') and DirectoryExists(DirFonte) then
  begin
    try
      DirFonte := DirFonte + '\*.*' + #0;
      DirDest := DirDest + #0;
      FillChar(ShFileOpStruct, Sizeof(TShFileOpStruct), 0);
      with ShFileOpStruct do
      begin
        // Wnd := GetApplication.Handle;
        wFunc := FO_COPY;
        pFrom := PChar(DirFonte);
        pTo := PChar(DirDest);
        fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;
      end;
      Result := (ShFileOperation(ShFileOpStruct) = 0);
    except
      Result := False;
      Exit;
    end;
  end;
end;

function DeleteFolder(Dir: String): boolean;
var
  ShFileOpStruct: TShFileOpStruct;
begin
  Result := False;
  if (Dir <> '') and DirectoryExists(Dir) then
  begin
    try
      Dir := Dir + #0;
      FillChar(ShFileOpStruct, Sizeof(TShFileOpStruct), 0);
      with ShFileOpStruct do
      begin
        // Wnd    := GetApplication.Handle;
        wFunc := FO_DELETE;
        pFrom := PChar(Dir);
        fFlags := FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;
      end;
      Result := (ShFileOperation(ShFileOpStruct) = 0);
    except
      Result := False;
    end;
  end;
end;

function CreateProcessSimple(const cmd: string): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  FillChar(SUInfo, Sizeof(SUInfo), #0);
  SUInfo.cb := Sizeof(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;
  SUInfo.wShowWindow := SW_HIDE;

  Result := CreateProcess(nil, PChar(cmd), nil, nil, False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, SUInfo, ProcInfo);

  if (Result) then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);

    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;
{$ENDIF IS_MOBILE}
{$IFDEF FIREMONKEY}
function GetSelectValue(const aLista: FMX.ListBox.TListBox): String;
begin
  Result := EmptyStr;
  if (aLista.ItemIndex > -1) then
    Result := aLista.Items[aLista.ItemIndex];
end;
{$ENDIF FIREMONKEY}

function ArrayToString(const aListaValues: array of string; const aDelimiter: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(aListaValues) -1 do
  begin
    if (Result <> '') then
      Result := Result + aDelimiter;
    Result := Result + aListaValues[i];
  end;
end;


function ASPEzPorListaTodosComandos : string;
var
  i : integer;
const
MaxComandos         = 219;
  MaxCaracteres       = 53;
  MaxSlots            = 75;
  ESC                 = Chr(27);

  Formatos : array[1..MaxComandos] of String =
            ('{{1 Bipe}}',                                         '{{3 Bipes}}',

             '{{Efeito Aleatorio}}',                               '{{Efeito Piscar}}',
             '{{Efeito Aparecer}}',                                '{{Efeito Manter}}',
             '{{Efeito Empurrar Para Baixo}}',                     '{{Efeito Empurrar Para Dentro}}',
             '{{Efeito Empurrar Para  Esquerda}}',                 '{{Efeito Empurrar Para Direita}}',
             '{{Efeito Empurrar Para Fora}}',                      '{{Efeito Empurrar Para Cima}}',
             '{{Efeito Rodar}}',                                   '{{Efeito Subir}}',
             '{{Efeito Deslizamento Individual}}',                 '{{Efeito Neve}}',
             '{{Efeito Faiscante}}',                               '{{Efeito Spray}}',
             '{{Efeito Constelacao de Estrelas}}',                 '{{Efeito Chaveamento}}',
             '{{Efeito Cintilante}}',                              '{{Efeito Varrer Para Baixo}}',
             '{{Efeito Varrer Para Dentro}}',                      '{{Efeito Varrer Para Esquerda}}',
             '{{Efeito Varrer Para Direita}}',                     '{{Efeito Varrer Para Fora}}',
             '{{Efeito Varrer Para Cima}}',                        '{{Efeito Rodar Condensado}}',
             '{{Animacao Nao Beba e Dirija}}',                     '{{Animacao Bomba}}',
             '{{Animacao Fogos de Artificio}}',                    '{{Animacao Nao Fume}}',
             '{{Animacao Animal Correndo}}',                       '{{Animacao Caca-Niquel}}',
             '{{Animacao Obrigado}}',                              '{{Animacao Carro Turbo}}',
             '{{Animacao Bem Vindo}}',                             '{{Efeito Intercolocacao}}',
             '{{Animacao Noticias}}',                              '{{Animacao Cornetas}}',
             '{{Animacao Peixes}}',                                '{{Animacao Bexigas}}',

             '{{Superior Efeito Aleatorio}}',                      '{{Superior Efeito Piscar}}',
             '{{Superior Efeito Aparecer}}',                       '{{Superior Efeito Manter}}',
             '{{Superior Efeito Empurrar Para Baixo}}',            '{{Superior Efeito Empurrar Para Dentro}}',
             '{{Superior Efeito Empurrar Para Esquerda}}',         '{{Superior Efeito Empurrar Para Direita}}',
             '{{Superior Efeito Empurrar Para Fora}}',             '{{Superior Efeito Empurrar Para Cima}}',
             '{{Superior Efeito Rodar}}',                          '{{Superior Efeito Subir}}',
             '{{Superior Efeito Deslizamento Individual}}',        '{{Superior Efeito Neve}}',
             '{{Superior Efeito Faiscante}}',                      '{{Superior Efeito Spray}}',
             '{{Superior Efeito Constelacao de Estrelas}}',        '{{Superior Efeito Chaveamento}}',
             '{{Superior Efeito Cintilante}}',                     '{{Superior Efeito Varrer Para Baixo}}',
             '{{Superior Efeito Varrer Para Dentro}}',             '{{Superior Efeito Varrer Para Esquerda}}',
             '{{Superior Efeito Varrer Para Direita}}',            '{{Superior Efeito Varrer Para Fora}}',
             '{{Superior Efeito Varrer Para Cima}}',               '{{Superior Efeito Rodar Condensado}}',
             '{{Superior Animacao Nao Beba e Dirija}}',            '{{Superior Animacao Bomba}}',
             '{{Superior Animacao Fogos de Artificio}}',           '{{Superior Animacao Nao Fume}}',
             '{{Superior Animacao Animal Correndo}}',              '{{Superior Animacao Caca-Niquel}}',
             '{{Superior Animacao Obrigado}}',                     '{{Superior Animacao Carro Turbo}}',
             '{{Superior Animacao Bem Vindo}}',                    '{{Superior Efeito Intercolocacao}}',
             '{{Superior Animacao Noticias}}',                     '{{Superior Animacao Cornetas}}',
             '{{Superior Animacao Peixes}}',                       '{{SuperiorAnimacao Bexigas}}',

             '{{Inferior Efeito Aleatorio}}',                      '{{Inferior Efeito Piscar}}',
             '{{Inferior Efeito Aparecer}}',                       '{{Inferior Efeito Manter}}',
             '{{Inferior Efeito Empurrar Para Baixo}}',            '{{Inferior Efeito Empurrar Para Dentro}}',
             '{{Inferior Efeito Empurrar Para Esquerda}}',         '{{Inferior Efeito Empurrar Para Direita}}',
             '{{Inferior Efeito Empurrar Para Fora}}',             '{{Inferior Efeito Empurrar Para Cima}}',
             '{{Inferior Efeito Rodar}}',                          '{{Inferior Efeito Subir}}',
             '{{Inferior Efeito Deslizamento Individual}}',        '{{Inferior Efeito Neve}}',
             '{{Inferior Efeito Faiscante}}',                      '{{Inferior Efeito Spray}}',
             '{{Inferior Efeito Constelacao de Estrelas}}',        '{{Inferior Efeito Chaveamento}}',
             '{{Inferior Efeito Cintilante}}',                     '{{Inferior Efeito Varrer Para Baixo}}',
             '{{Inferior Efeito Varrer Para Dentro}}',             '{{Inferior Efeito Varrer Para Esquerda}}',
             '{{Inferior Efeito Varrer Para Direita}}',            '{{Inferior Efeito Varrer Para Fora}}',
             '{{Inferior Efeito Varrer Para Cima}}',               '{{Inferior Efeito Rodar Condensado}}',
             '{{Inferior Animacao Nao Beba e Dirija}}',            '{{Inferior Animacao Bomba}}',
             '{{Inferior Animacao Fogos de Artificio}}',           '{{Inferior Animacao Nao Fume}}',
             '{{Inferior Animacao Animal Correndo}}',              '{{Inferior Animacao Caca-Niquel}}',
             '{{Inferior Animacao Obrigado}}',                     '{{Inferior Animacao Carro Turbo}}',
             '{{Inferior Animacao Bem Vindo}}',                    '{{Inferior Efeito Intercolocacao}}',
             '{{Inferior Animacao Noticias}}',                     '{{Inferior Animacao Cornetas}}',
             '{{Inferior Animacao Peixes}}',                       '{{Inferior Animacao Bexigas}}',

             '{{Meio Efeito Aleatorio}}',                          '{{Meio Efeito Piscar}}',
             '{{Meio Efeito Aparecer}}',                           '{{Meio Efeito Manter}}',
             '{{Meio Efeito Empurrar Para Baixo}}',                '{{Meio Efeito Empurrar Para Dentro}}',
             '{{Meio Efeito Empurrar Para Esquerda}}',             '{{Meio Efeito Empurrar Para Direita}}',
             '{{Meio Efeito Empurrar Para Fora}}',                 '{{Meio Efeito Empurrar Para Cima}}',
             '{{Meio Efeito Rodar}}',                              '{{Meio Efeito Subir}}',
             '{{Meio Efeito Deslizamento Individual}}',            '{{Meio Efeito Neve}}',
             '{{Meio Efeito Faiscante}}',                          '{{Meio Efeito Spray}}',
             '{{Meio Efeito Constelacao de Estrelas}}',            '{{Meio Efeito Chaveamento}}',
             '{{Meio Efeito Cintilante}}',                         '{{Meio Efeito Varrer Para Baixo}}',
             '{{Meio Efeito Varrer Para Dentro}}',                 '{{Meio Efeito Varrer Para Esquerda}}',
             '{{Meio Efeito Varrer Para Direita}}',                '{{Meio Efeito Varrer Para Fora}}',
             '{{Meio Efeito Varrer Para Cima}}',                   '{{Meio Efeito Rodar Condensado}}',
             '{{Meio Animacao Nao Beba e Dirija}}',                '{{Meio Animacao Bomba}}',
             '{{Meio Animacao Fogos de Artificio}}',               '{{Meio Animacao Nao Fume}}',
             '{{Meio Animacao Animal Correndo}}',                  '{{Meio Animacao Caca-Niquel}}',
             '{{Meio Animacao Obrigado}}',                         '{{Meio Animacao Carro Turbo}}',
             '{{Meio Animacao Bem Vindo}}',                        '{{Meio Efeito Intercolocacao}}',
             '{{Meio Animacao Noticias}}',                         '{{Meio Animacao Cornetas}}',
             '{{Meio Animacao Peixes}}',                           '{{Meio Animacao Bexigas}}',

             '{{Caractere Largo}}',             '{{Piscar Caractere}}',
             '{{Caractere Altura Dupla}}',      '{{Descendentes Reais}}',
             '{{Caractere Largura Fixa}}',      '{{Caractere Largura Dupla}}',

             '{{Caractere Estreito}}',          '{{Nao Piscar Caractere}}',
             '{{Caractere Altura Normal}}',     '{{Descendentes Nao-Reais}}',
             '{{Caractere Largura Variavel}}',  '{{Caractere Largura Normal}}',

             '{{Nova Pagina}}',                 '{{Nova Linha}}',

             '{{Temperatura Fahrenheit}}',      '{{Temperatura Celsius}}',

             '{{Data mm/dd/aa}}',               '{{Data dd/mm/aa}}',
             '{{Data mm-dd-aa}}',               '{{Data dd-mm-aa}}',
             '{{Data mm.dd.aa}}',               '{{Data dd.mm.aa}}',
             '{{Data mm dd aa}}',               '{{Data dd mm aa}}',
             '{{Data mmm.dd,aaaa}}',

             '{{Hora}}',                        '{{Dia da Semana}}',

             '{{Fonte 10 LEDs}}',               '{{Fonte 5 LEDs}}',
             '{{Fonte 7 LEDs}}',                '{{Fonte 7 LEDs Serifada}}',
             '{{Fonte 15/16 LEDs}}',            '{{Fonte 15/16 LEDs Serifada}}',

             '{{Vermelho}}',                    '{{Vermelho Claro}}',
             '{{Verde}}',                       '{{Verde Claro}}',
             '{{Laranja}}',                     '{{Laranja Claro}}',
             '{{Azul}}',                        '{{Azul Claro}}',
             '{{Ambar}}',                       '{{Marrom}}',
             '{{Amarelo}}',                     '{{Lilas}}',
             '{{Branco}}',
             '{{Arco-Iris 1}}',                 '{{Arco-Iris 2}}',
             '{{Mix}}',                         '{{Aleatoria}}',

             '{{Velocidade 1}}',                '{{Velocidade 2}}',
             '{{Velocidade 3}}',                '{{Velocidade 4}}',
             '{{Velocidade 5}}',                '{{Velocidade Ultra-Rapida}}',

             '{{Meio Espaco}}');

begin
  Result := '';
  try
    for i := 1 to MaxComandos do
      Result := Result + Formatos[i] + #13;

    Result := Result + '{{Figura XX}}' + #13;
    Result := Result + '{{Variavel XX}}';
  except
    Result  := '';
  end;
end; { function ASPEzPorEnviaVariavel }

function FormatLeftString(Comprimento: Integer; s: string): string;
begin
  try
    Result := s;
    while length(Result) < Comprimento do
      Result := Result + ' ';
  except
    Result := '';
  end;
end; { proc FormatString }

function  FormatCenterString  (Comprimento: Integer; s: string; const PreencherComEspacosAoFinal: boolean = true): string;
var
  i: Integer;
begin
  try
    Result   := '';
    for i    := 1 to ((Comprimento - length(s)) div 2) do
      Result := Result + ' ';
    Result   := Result + s;
    if PreencherComEspacosAoFinal then
      while length(Result) < Comprimento do
        Result := Result + ' ';
  except
    Result := '';
  end;
end; { proc FormatString }

{$IFDEF FIREMONKEY}
function EnableDisableAllControls(Controle: FMX.Controls.TControl; const Enable: Boolean;
  aControlNaoModificar: FMX.Controls.TControl): Boolean;
var
  i: Integer;
  LControlChild: FMX.Controls.TControl;
begin
  Result := true;
  try
    for i := 0 to Controle.ControlsCount - 1 do
    begin
      LControlChild := Controle.Controls[i];
      if (LControlChild <> aControlNaoModificar) then
      begin
        if (Assigned(LControlChild) and (LControlChild is FMX.Controls.TControl) and (FMX.Controls.TControl(LControlChild).ControlsCount > 0)) then
        begin
          Result := EnableDisableAllControls(FMX.Controls.TControl(LControlChild), Enable, aControlNaoModificar);
          if not Result then
            Break;
        end;
        LControlChild.Enabled := Enable;
      end;
    end;
  except
    Result := false;
  end; { try .. except }
end;
{$ENDIF FIREMONKEY}

{$IFNDEF AplicacaoFiremokeySemVCL}
function EnableDisableAllControls(Controle: Vcl.Controls.TWinControl; const Enable: Boolean;
  aControlNaoModificar: Vcl.Controls.TWinControl): Boolean;
var
  i: Integer;
  LControlChild: Vcl.Controls.TControl;
begin
  Result := true;
  try
    for i := 0 to Controle.ControlCount - 1 do
    begin
      LControlChild := Controle.Controls[i];
      if (aControlNaoModificar <> LControlChild) then
      begin
        if (Assigned(LControlChild) and (LControlChild is Vcl.Controls.TWinControl) and (Vcl.Controls.TWinControl(LControlChild).ControlCount > 0)) then
        begin
          Result := EnableDisableAllControls(Vcl.Controls.TWinControl(LControlChild), Enable, aControlNaoModificar);
          if not Result then
            Break;
        end;

        LControlChild.Enabled := Enable;
      end;
    end;
  except
    Result := false;
    Exit;
  end; { try .. except }
end;
{$ENDIF AplicacaoFiremokeySemVCL}

function Eleva(const Base, Expoente: Integer): Integer;
var
  i: Integer;
begin
  Result   := 1;
  for i    := 1 to Expoente do
    Result := Result * Base;
end; { func Eleva }

function FormatNumber(const Digits, i: Integer): string;
begin
  try
    Result := inttostr(i);
    while length(Result) < Digits do
      Result := '0' + Result;
  except
    Result := '';
  end;
end; { proc FormatNumber }

function FormatTimeComAspas(const T: TTime): string;
begin
  try
    Result := '';
    if strtoint(FormatDateTime('hh', T)) <> 0 then
      Result := Result + FormatDateTime('h', T) + 'h';
    if strtoint(FormatDateTime('nn', T)) <> 0 then
      Result := Result + FormatDateTime('n', T) + '''';
    if strtoint(FormatDateTime('ss', T)) <> 0 then
      Result := Result + FormatDateTime('s', T) + '"';
    if Result = '' then
      Result := '0"';
  except
    Result := '';
  end;
end; { func FormatTimeComAspas }

function GetDataOfMyLogException: String;
var
  sLogFileNameTemp, LogFileName: string;
  LIniFile: TIniFile;
  LFile: TStringList;
begin
  Result := EmptyStr;
  try
    sLogFileNameTemp := IncludeTrailingPathDelimiter(SettingsPathName) + 'TempLog.dat';
    LIniFile := TIniFile.Create(SettingsFileName);
    try
      LogFileName := LIniFile.ReadString('Log de Erros', 'NomeDoArquivo', IncludeTrailingPathDelimiter(SettingsPathName) + 'Log.dat');

      if LogFileName = '' then
        LogFileName := IncludeTrailingPathDelimiter(SettingsPathName) + 'Log.dat';

      LFile := TStringList.Create;
      try
        if FileExists(LogFileName) then
          LFile.LoadFromFile(LogFileName)
        else
        if FileExists(sLogFileNameTemp) then
          LFile.LoadFromFile(sLogFileNameTemp);
        Result := LFile.Text;
      finally
        FreeAndNIl(LFile);
      end;
    finally
      FreeAndNIl(LIniFile);
    end;
  except
    Exit;
  end;
end;

procedure SetIniFileName(const aNewFilePath: String);
begin
  FSettingsFileName := aNewFilePath;
end;

{$ENDREGION}

{$REGION 'Aspect'}


{$IFDEF AplicacaoFiremokeySemVCL}
function GetApplication: FMX.Forms.TApplication;
begin
  Result := FMX.Forms.Application;
end;
{$ELSE}
function GetApplication: Vcl.Forms.TApplication;
begin
  Result := Vcl.Forms.Application;
end;
{$ENDIF AplicacaoFiremokeySemVCL}


{$IFDEF FIREMONKEY}
procedure LoadPosition(aForm: FMX.Forms.TForm);
var
  LName: string;
  LPositionForm: TPositionForm;
  IndexForm: Integer;
  LIniFilePosition: TIniFile;

  procedure LoadPosicaoGrid;
  var
    LGrid: FMX.Grid.TCustomGrid;
    LColumn: FMX.Grid.TColumn;
    i, i2: Integer;
    LNameGrid: string;
  begin
    for i := 0 to aForm.ComponentCount -1 do
    begin
      if Assigned(aForm.Components[i]) and (aForm.Components[i] is FMX.Grid.TCustomGrid) then
      begin
        LGrid := FMX.Grid.TCustomGrid(aForm.Components[i]);
        LNameGrid := LGrid.Name;
        for i2 := 0 to LGrid.ColumnCount -1 do
        begin
          LColumn := LGrid.Columns[i];
          if Assigned(LColumn) then
          begin
            LColumn.Width := ReadIniFile(LIniFilePosition, LName, LNameGrid + 'Width', LColumn.Width, False);

          end;
        end;
      end;
    end;
  end;
begin
  if not Assigned(aForm) then
    Exit;

  LName := aForm.Name;
  LIniFilePosition := TIniFile.Create(SettingsFileNamePosition);
  try
    if ReadIniFile(LIniFilePosition, LName, 'IniciaFormCantoSuperiorEsquerdo', 0, False) = 1 then
    begin
      LIniciaFormCantoSuperiorEsquerdo  := True;
    end
    else
    begin
      LIniciaFormCantoSuperiorEsquerdo  := False;
    end;
    if LIniciaFormCantoSuperiorEsquerdo = False then
    begin
      aForm.Top         := ReadIniFile(LIniFilePosition, LName, 'Top', aForm.Top, False);
      aForm.Left        := ReadIniFile(LIniFilePosition, LName, 'Left', aForm.Left, False);
    end
    else
    begin
      aForm.Top         := 0;
      aForm.Left        := 0;
    end;
    aForm.Height      := ReadIniFile(LIniFilePosition, LName, 'Height', aForm.Height, False);
    aForm.Width       := ReadIniFile(LIniFilePosition, LName, 'Width', aForm.Width, False);
    aForm.WindowState := System.UITypes.TWindowState(ReadIniFile(LIniFilePosition, LName, 'WindowState', Integer(aForm.WindowState), False));
    aForm.FormStyle   := FMX.Types.TFormStyle(ReadIniFile(LIniFilePosition, LName, 'FormStyle', Integer(aForm.FormStyle), False));

    IndexForm := FPositionsForms.IndexOfForm(aForm);
    if (IndexForm = - 1) then
    begin
      LPositionForm := TPositionForm.Create(nil);
      FPositionsForms.Add(LPositionForm);
    end
    else
      LPositionForm := FPositionsForms.Items[IndexForm];

    LPositionForm.Form        := aForm;
    LPositionForm.Top         := aForm.Top;
    LPositionForm.Left        := aForm.Left;
    LPositionForm.Height      := aForm.Height;
    LPositionForm.Width       := aForm.Width;
    LPositionForm.WindowState := Integer(aForm.WindowState);
    LPositionForm.FormStyle   := Integer(aForm.FormStyle);
    //LoadPosicaoGrid;
  finally
    FreeAndNil(LIniFilePosition);
  end;
end;

procedure LoadPosition(aForm: FMX.Forms.TFrame);
begin
  Exit;
end;

procedure SavePosition(aForm: FMX.Forms.TForm);
var
  LName: string;
  LPositionForm: TPositionForm;
  IndexForm: Integer;
  LIniFilePosition: TIniFile;

  procedure GravaPosicaoGrid;
  var
    LGrid: FMX.Grid.TCustomGrid;
    LColumn: FMX.Grid.TColumn;
    i, i2: Integer;
    LNameGrid: string;
  begin
    for i := 0 to aForm.ComponentCount -1 do
    begin
      if Assigned(aForm.Components[i]) and (aForm.Components[i] is FMX.Grid.TCustomGrid) then
      begin
        LGrid := FMX.Grid.TCustomGrid(aForm.Components[i]);
        LNameGrid := LGrid.Name;
        for i2 := 0 to LGrid.ColumnCount -1 do
        begin
          LColumn := LGrid.Columns[i2];
          if Assigned(LColumn) then
          begin
            WriteIniFile(LIniFilePosition, LName, LNameGrid + 'Width', LColumn.Width, False);
          end;
        end;
      end;
    end;
  end;
begin
  if not Assigned(aForm) then
    Exit;

  LIniFilePosition := TIniFile.Create(SettingsFileNamePosition);
  try
    LName := aForm.Name;
    IndexForm := FPositionsForms.IndexOfForm(aForm);
    if (IndexForm > - 1) then
    begin
      LPositionForm := FPositionsForms.Items[IndexForm];
      try
        if LIniciaFormCantoSuperiorEsquerdo = True then
        begin
          WriteIniFile(LIniFilePosition, LName, 'IniciaFormCantoSuperiorEsquerdo', 1);
        end
        else
        begin
          WriteIniFile(LIniFilePosition, LName, 'IniciaFormCantoSuperiorEsquerdo', 0);
        end;

        //Se n„o modificou posiÁ„o form n„o salvar no ini
        if ((LPositionForm.Form = aForm) and
            (LPositionForm.Top = aForm.Top) and
            (LPositionForm.Left = aForm.Left) and
            (LPositionForm.Height = aForm.Height) and
            (LPositionForm.Width = aForm.Width) and
            (LPositionForm.WindowState = Integer(aForm.WindowState)) and
            (LPositionForm.FormStyle = Integer(aForm.FormStyle))) then
          exit;
      finally
        FPositionsForms.Delete(IndexForm);
      end;
    end;
    if screen.Height < (aForm.Top+aForm.Height) then
    begin
      aform.Top := Trunc(screen.Height - aForm.Height);
    end;
    if screen.Width < (aForm.Left+aForm.Width) then
    begin
      aform.Left := Trunc(screen.Width - aForm.Width);
    end;
    WriteIniFile(LIniFilePosition, LName, 'Top', aForm.Top);
    WriteIniFile(LIniFilePosition, LName, 'Left', aForm.Left);
    WriteIniFile(LIniFilePosition, LName, 'Height', aForm.Height);
    WriteIniFile(LIniFilePosition, LName, 'Width', aForm.Width);
    WriteIniFile(LIniFilePosition, LName, 'WindowState', Ord(aForm.WindowState));
    WriteIniFile(LIniFilePosition, LName, 'FormStyle', Integer(aForm.FormStyle));
    GravaPosicaoGrid;
  finally
    FreeAndNil(LIniFilePosition);
  end;
end;


procedure SavePosition(aForm: FMX.Forms.TFrame);
begin
  Exit;
end;


function ClearTitledStringGrid(var SG: FMX.Grid.TStringGrid): Boolean;
var
  I: Integer;
begin
  Result := True;
  try
    SG.RowCount      := 2;
    for I            := 0 to SG.ColumnCount - 1 do
      SG.Cells[I, 1] := '';
  except
    Result := False;
    Exit;
  end;
end;
{$ENDIF FIREMONKEY}

{$IFNDEF AplicacaoFiremokeySemVCL}
procedure LoadPosition(aForm: Vcl.Forms.TFrame);
begin
  Exit;
end;

procedure LoadPosition(aForm: Vcl.Forms.TForm);
var
  LName: string;
  LPositionForm: TPositionForm;
  LIndexForm: Integer;
  LIniFilePosition: TIniFile;
begin
  if not Assigned(aForm) then
    Exit;

  LIniFilePosition := TIniFile.Create(SettingsFileNamePosition);
  try
    LName := aForm.Name;

    aForm.Top         := ReadIniFile(LIniFilePosition, LName, 'Top', aForm.Top, False);
    aForm.Left        := ReadIniFile(LIniFilePosition, LName, 'Left', aForm.Left, False);
    aForm.Height      := ReadIniFile(LIniFilePosition, LName, 'Height', aForm.Height, False);
    aForm.Width       := ReadIniFile(LIniFilePosition, LName, 'Width', aForm.Width, False);
    aForm.WindowState := System.UITypes.TWindowState(ReadIniFile(LIniFilePosition, LName, 'WindowState', Integer(aForm.WindowState), False));
    aForm.FormStyle   := Vcl.Forms.TFormStyle(ReadIniFile(LIniFilePosition, LName, 'FormStyle', Integer(aForm.FormStyle), False));

    LIndexForm := FPositionsForms.IndexOfForm(aForm);
    if (LIndexForm = - 1) then
    begin
      LPositionForm := TPositionForm.Create(nil);
      FPositionsForms.Add(LPositionForm);
    end
    else
      LPositionForm := FPositionsForms.Items[LIndexForm];

    LPositionForm.Form        := aForm;
    LPositionForm.Top         := aForm.Top;
    LPositionForm.Left        := aForm.Left;
    LPositionForm.Height      := aForm.Height;
    LPositionForm.Width       := aForm.Width;
    LPositionForm.WindowState := Integer(aForm.WindowState);
    LPositionForm.FormStyle   := Integer(aForm.FormStyle);
  finally
    FreeAndNil(LIniFilePosition);
  end;
end;
procedure SavePosition(aForm: Vcl.Forms.TFrame);
begin
  Exit;
end;

procedure SavePosition(aForm: Vcl.Forms.TForm);
var
  LName: string;
  LPositionForm: TPositionForm;
  IndexForm: Integer;
  LIniFilePosition: TIniFile;
begin
  if not Assigned(aForm) then
    Exit;

  LIniFilePosition := TIniFile.Create(SettingsFileNamePosition);
  try
    LName := aForm.Name;
    IndexForm := FPositionsForms.IndexOfForm(aForm);
    if (IndexForm > - 1) then
    begin
      LPositionForm := FPositionsForms.Items[IndexForm];
      try
        //Se n„o modificou posiÁ„o form n„o salvar no ini
        if ((LPositionForm.Form = aForm) and
            (LPositionForm.Top = aForm.Top) and
            (LPositionForm.Left = aForm.Left) and
            (LPositionForm.Height = aForm.Height) and
            (LPositionForm.Width = aForm.Width) and
            (LPositionForm.WindowState = Integer(aForm.WindowState)) and
            (LPositionForm.FormStyle = Integer(aForm.FormStyle))) then
          exit;
      finally
        FPositionsForms.Delete(IndexForm);
      end;
    end;
    WriteIniFile(LIniFilePosition, LName, 'Top', aForm.Top);
    WriteIniFile(LIniFilePosition, LName, 'Left', aForm.Left);
    WriteIniFile(LIniFilePosition, LName, 'Height', aForm.Height);
    WriteIniFile(LIniFilePosition, LName, 'Width', aForm.Width);
    WriteIniFile(LIniFilePosition, LName, 'WindowState', Ord(aForm.WindowState));
    WriteIniFile(LIniFilePosition, LName, 'FormStyle', Integer(aForm.FormStyle));
  finally
    FreeAndNIl(LIniFilePosition);
  end;
end;

function ClearTitledStringGrid(var SG: VCL.Grids.TStringGrid): Boolean;
var
  I: Integer;
begin
  Result := True;
  try
    SG.RowCount      := 2;
    for I            := 0 to SG.ColCount - 1 do
      SG.Cells[I, 1] := '';
  except
    Result := False;
    Exit;
  end;
end;
{$ENDIF AplicacaoFiremokeySemVCL}


//function PortaSerial_LeIniEAbreFMX(var SerialPort: TComPort): Boolean;
//var
//  S: string;
//begin
//  Result := True;
//
//  try
//    S := ReadSettings(cSettings, SerialPort.Name + 'Config', 'Com1,9600,8,n,1');
//
//    PortaSerial_SetConfigFMX(SerialPort, S);
//    SerialPort.Open;
//  except
//    on E: Exception do
//      Result := False;
//  end;
//end;
//
//function PortaSerial_GetConfigFMX(SerialPort: TComPort): string;
//begin
//  Result := SerialPort.DeviceName + ',';
//
//  case SerialPort.Baudrate of
//    br110:
//      Result := Result + '110,';
//    br300:
//      Result := Result + '300,';
//    br600:
//      Result := Result + '600,';
//    br1200:
//      Result := Result + '1200,';
//    br2400:
//      Result := Result + '2400,';
//    br4800:
//      Result := Result + '4800,';
//    br9600:
//      Result := Result + '9600,';
//    br14400:
//      Result := Result + '14400,';
//    br19200:
//      Result := Result + '19200,';
//    br38400:
//      Result := Result + '38400,';
//    br56000:
//      Result := Result + '56000,';
//    br57600:
//      Result := Result + '57600,';
//    br115200:
//      Result := Result + '115200,';
//    br128000:
//      Result := Result + '128000,';
//    br256000:
//      Result := Result + '256000,';
//  else
//    Result := Result + 'bbbb,';
//  end;
//
//  case SerialPort.Databits of
//    db7:
//      Result := Result + '7,';
//    db8:
//      Result := Result + '8,';
//  else
//    Result := Result + 'd,';
//  end;
//
//  case SerialPort.Parity of
//    paNone:
//      Result := Result + 'n,';
//    paEven:
//      Result := Result + 'e,';
//    paOdd:
//      Result := Result + 'o,';
//  else
//    Result := Result + 'p,';
//  end;
//
//  case SerialPort.Stopbits of
//    sb1:
//      Result := Result + '1';
//    sb2:
//      Result := Result + '2';
//  else
//    Result := Result + 's';
//  end;
//end;
//
//function PortaSerial_SetConfigFMX(var SerialPort: TComPort; SerialConfig: string): Boolean;
//var
//  I            : Integer;
//  auxbaud      : Integer;
//  auxdatalength: Integer;
//  auxstopbits  : Integer;
//  auxparity    : Char;
//  Aux          : string;
//  auxDeviceName: string;
//begin
//  Result := True;
//  try
//    auxbaud       := 0;
//    auxdatalength := 0;
//    auxparity     := #0;
//    auxDeviceName := '';
//    Aux           := '';
//
//    for I := 1 to Length(SerialConfig) do
//    begin
//      if SerialConfig[I] = ',' then
//      begin
//        if auxDeviceName = '' then
//          auxDeviceName := Aux
//        else if auxbaud = 0 then
//          auxbaud := StrToInt(Aux)
//        else if auxdatalength = 0 then
//          auxdatalength := StrToInt(Aux)
//        else
//          auxparity := Aux[1];
//        Aux         := '';
//      end
//      else
//        Aux := Aux + SerialConfig[I];
//    end;
//    auxstopbits := StrToInt(Aux);
//
//    SerialPort.DeviceName := auxDeviceName;
//
//    case auxbaud of
//      110:
//        SerialPort.Baudrate := br110;
//      300:
//        SerialPort.Baudrate := br300;
//      600:
//        SerialPort.Baudrate := br600;
//      1200:
//        SerialPort.Baudrate := br1200;
//      2400:
//        SerialPort.Baudrate := br2400;
//      4800:
//        SerialPort.Baudrate := br4800;
//      9600:
//        SerialPort.Baudrate := br9600;
//      14400:
//        SerialPort.Baudrate := br14400;
//      19200:
//        SerialPort.Baudrate := br19200;
//      38400:
//        SerialPort.Baudrate := br38400;
//      56000:
//        SerialPort.Baudrate := br56000;
//      57600:
//        SerialPort.Baudrate := br57600;
//      115200:
//        SerialPort.Baudrate := br115200;
//      128000:
//        SerialPort.Baudrate := br128000;
//      256000:
//        SerialPort.Baudrate := br256000;
//    else
//      Result := False;
//    end; { case }
//
//    case auxdatalength of
//      7:
//        SerialPort.Databits := db7;
//      8:
//        SerialPort.Databits := db8;
//    else
//      Result := False;
//    end; { case }
//
//    case auxstopbits of
//      1:
//        SerialPort.Stopbits := sb1;
//      2:
//        SerialPort.Stopbits := sb2;
//    else
//      Result := False;
//    end; { case }
//
//    case auxparity of
//      'N', 'n':
//        SerialPort.Parity := paNone;
//      'E', 'e':
//        SerialPort.Parity := paEven;
//      'O', 'o':
//        SerialPort.Parity := paOdd;
//    else
//      Result := False;
//    end; { case }
//
//    // Para gerar erro na function de abertura de porta serial
//    if not Result then
//      SerialPort.DeviceName := 'COM_ERRO';
//  except
//    Result := False;
//  end;
//
//end;

//function GetExeVersion: string;
//var
//  Exe         : string;
//  Size, Handle: DWORD;
//  Buffer      : TBytes;
//  FixedPtr    : PVSFixedFileInfo;
//begin
//  Exe  := ParamStr(0);
//  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
//  if Size = 0 then
//    RaiseLastOSError;
//  SetLength(Buffer, Size);
//  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
//    RaiseLastOSError;
//  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
//    RaiseLastOSError;
//  Result := Format('%d.%d.%d.%d', [LongRec(FixedPtr.dwFileVersionMS).Hi, // major
//    LongRec(FixedPtr.dwFileVersionMS).Lo, // minor
//    LongRec(FixedPtr.dwFileVersionLS).Hi,  // release
//    LongRec(FixedPtr.dwFileVersionLS).Lo]) // build
//end;

function MyFormatDateTime(Format: string; DateTime: TDateTime): string;
begin
  Result := '';
  if copy(Format, 1, 3) = '[h]' then
  begin
    Result := inttostr(HoursBetween(0, DateTime));
    Delete(Format, 1, 3);
  end;

  if Format <> '' then
    Result := Result + FormatDateTime(Format, DateTime);
end;


{ TComparerPositionsForms<TPositionForm> }

function TComparerPositionsForms<T>.Compare(const Left,
  Right: TPositionForm): Integer;
begin
  Result := -1;
  if Left.Form = Right.Form then
    Result := 0;
end;

{ TPositionsForms }

destructor TPositionsForms.Destroy;
var
  I: Integer;
  LItem: TPositionForm;
begin
  for I := Count -1 downto 0 do
  begin
    LItem := Items[i];
    FreeAndNil(LItem);
    Items[i] := nil;
  end;

  inherited;
end;

function TPositionsForms.IndexOfForm(aForm: TObject): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count -1 do
  begin
    if Assigned(Items[i]) and (Items[i].Form = aForm) then
    begin
      Result := i;
      Break;
    end;
  end;
end;







function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
begin
  Result := Copy(aStr, 2, 4);
  Delete(aStr, 2, 4);
end;

{ TComponentFreeNotify }

{$IFDEF FIREMONKEY}
procedure TComponentFreeNotify.AddFreeNotify(const AObject: IFreeNotification);
begin
  if Assigned(AObject) then
  begin
    if (AObject is TComponent) then
      FreeNotification(TComponent(AObject))
    else
      Assert(False, 'N„o È possÌvel AddFreeNotify');
  end;
end;

procedure TComponentFreeNotify.RemoveFreeNotify(const AObject: IFreeNotification);
begin
  if Assigned(AObject) then
  begin
    if (AObject is TComponent) then
      RemoveFreeNotification(TComponent(AObject))
    else
      Assert(False, 'N„o È possÌvel RemoveFreeNotify');
  end;
end;
{$ENDIF FIREMONKEY}

procedure TComponentFreeNotify.FreeNotification(AObject: TObject);
begin
  if (Assigned(AObject) and (AObject is TComponent)) then
    Notification(TCOmponent(AObject), opRemove);
end;

procedure TComponentFreeNotify.FreeNotification(AObject: TComponent);
begin
  inherited FreeNotification(AObject);
end;

procedure TComponentFreeNotify.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;

{ TPositionForm }

constructor TPositionForm.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TPositionForm.Destroy;
begin
  Form := nil;
  inherited;
end;

procedure TPositionForm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and Assigned(AComponent) and (AComponent = FForm) then
    Form := nil;
end;

procedure TPositionForm.SetForm(const Value: TObject);
begin
  FForm := TObject(GetComponenteFreeNotify(Self, FForm, Value));
end;


function GetDescProtoculo(const aProtocolo: Integer): String;
begin
  case aProtocolo of
    $20: Result := 'Chamar proxima senha';
    $21: Result := 'Chamar senha especifica';
    $22: Result := 'Rechamar ultima senha';
    $23: Result := 'RE: Chamou senha especifica';
    $24: Result := 'RE: Nao chamou nenhuma senha';
    $25: Result := 'Finalizar atendimento';
    $26: Result := 'RE: Prioridades de atendimento redefinidas. FaÁa Refresh.';
    $27: Result := 'Solicitar mensagem institucional (paineis)';
    $28: Result := 'Solicitar inÌcio ou tÈrmino de pausa';
    $29: Result := 'Solicitar situacao do atendimento por PAs';
    $2A: Result := 'Solicitar lista dos status das PAs';
    $2B: Result := 'RE: Mensagem institucional (paineis)';
    $2C: Result := 'RE: Mensagem dos bilhetes (rodape impressora de senha)';
    $2D: Result := 'RE: Lista dos status das PAs';
    $2E: Result := 'Redirecionar senha atendida para outra fila (pela PA que est· atendendo)';
    $2F: Result := 'Redirecionar senha atendida para outra fila (pela PA que est· atendendo) e chamar prÛximo cliente';
    $30: Result := 'Chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)';
    $31: Result := 'Redirecionar senha atendida para outra fila (pela PA que est· atendendo) e chamar senha especifica, se estiver dentro das prioridades do ADR';
    $32: Result := 'Redirecionar senha atendida para outra fila (pela PA que est· atendendo) e chamar senha especifica, esteja ela em qualquer fila ou em nenhuma (forcar chamada)';
    $33: Result := 'RE: Comando nao suportado pela versao';
    $34: Result := 'Solicitar situacao de filas';
    $35: Result := 'RE: Situacao das filas';
    $36: Result := 'Solicitar numero de pessoas em espera, de acordo com as prioridades das PAs';
//    $37 ='';
    $38: Result := 'Chamar proxima senha + Horario de retirada da senha';
    $39: Result := 'RE: Senha chamada + Horario de retirada da senha';
//    $3A ='';
    $3B: Result := 'RE: Numero de senhas em espera, por PA';
    $3C: Result := 'RE: Situacao do atendimento, por PAs';
    $3D: Result := 'Solicitar nomes das PAs';
    $3E: Result := 'RE: Nomes das PAs';
    $3F: Result := 'Solicitar tabela de PPs';
    $40: Result := 'RE: Tabela de PPs';
    $41: Result := 'Solicitar tabela de Motivos de Pausa';
    $42: Result := 'RE: Tabela de Motivos de Pausa';
    $50: Result := 'RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA EM NENHUMA FILA';
    $51: Result := 'RE: Nao chamou nenhuma senha - SENHA NAO SE ENCONTRA NAS PRIORIDADES DO ATENDENTE';
    $52: Result := 'Envio de texto';
    $53: Result := 'Finalizar atendimento de uma determinada senha';
    $54: Result := 'Solicitar login de atendente - NOVO FORMATO NA V5, COM LOGIN E HASH DA SENHA';
    $55: Result := 'Solicitar logout de atendente especifico';
    $56: Result := 'Solicitar nome de cliente para uma senha';
    $57: Result := 'RE: Definir nome de cliente para uma senha';
    $58: Result := 'Solicitar situaÁ„o dos processos paralelos de uma senha ou de todas';
    $59: Result := 'RE: SituaÁ„o dos processos paralelos';
    $5A: Result := 'Solicitar finalizaÁ„o de processos paralelos';
    $5B: Result := 'Solicita login de atendente e conferencia da senha  <= APENAS PARA TECLADO, POIS N√O ENCRIPTA A SENHA !!!!';
    $5C: Result := 'RE: Nome do atendente logado';
    $5D: Result := 'Solicitar logout do atendente que estiver na PA';
    $5E: Result := 'Solicitar situacao total da PA';
    $5F: Result := 'RE: Situacao total de uma PA';
    $60: Result := 'RE: Teclado serial 1100 - Apaga Flash';
    $61: Result := 'RE: Teclado serial 1100 - Grava Bloco em Flash';
    $62: Result := 'RE: Teclado serial 1100 - Gravacao Completa de Bloco em Flash';
    $63: Result := 'Teclado serial - Erro de Gravacao de Bloco em Flash';
    $64: Result := 'Solicitar nomes dos PIs';
    $65: Result := 'RE: Nomes dos PIs';
    $66: Result := 'Solicitar situacao dos PIs';
    $67: Result := 'RE: Situacao dos PIs';
    $68: Result := 'Solicitar inÌcio de PP';
    $69: Result := 'Solicitar evento de marcar/desmarcar uma checkbox de fila priorit·ria ou bloqueada';
    $6A: Result := 'Solicitar exclus„o de uma senha';
    $6B: Result := 'Solicitar inclus„o de uma senha numa fila';
    $6C: Result := 'Solicitar situaÁ„o detalhada de uma fila';
    $6D: Result := 'RE: SituaÁ„o detalhada das senhas de uma ou mais filas';
$6E: Result := 'Solicitar situaÁ„o detalhada dos status "priorit·ria" e "bloqueada" das filas';
$6F: Result := 'RE: SituaÁ„o detalhada dos status "priorit·ria" e "bloqueada" das filas';
    $70: Result := 'Solicitar evento de clique de um bot„o de retirada de senha, informando em qual impressora imprimir a senha  (NOVO)';
$71: Result := 'Solicitar nome, login, grupo, senha e ativo dos atendentes';
$72: Result := 'RE: Nome, login, grupo, senha e ativo de atendentes, tambÈm utilizado para solicitar alteraÁ„o de dados para um atendente => OBS: Servidor sempre envia somente os ativos';
    $73: Result := 'RE: Chamada de senhas em "painel" do tipo SicsTV';
    $74: Result := 'Solicitar inserÁ„o de atendente';
    $75: Result := 'RE: Novo atendente inserido';
    $76: Result := 'Solicitar impress„o de cÛdigo de barras de atendente';
    $77: Result := 'Redirecionar senha para outra fila, pela senha';
$78: Result := 'Solicitar nomes dos Grupos (PAs, Atds, Filas, Tags, PPs, etc)';
$79: Result := 'RE: Nomes das Grupos (PAs, Atds, Filas, Tags, PPs, etc)';
    $7A: Result := 'Tabela reconfigurada, solicitar Refresh';
$7B: Result := 'Solicitar nomes e cor das filas  (NOVO)';
$7C: Result := 'RE: Nomes e cores das filas      (NOVO)';
    $7D: Result := 'Definir TAG para uma determinada senha';
    $7E: Result := 'Re: TAG para uma determinada senha';
$7F: Result := 'Solicitar nomes das TAGs';
$AA: Result := 'Re: Nomes das TAGs';
    $AB: Result := 'Solicitar TAGs de uma senha especÌfica';
    $AC: Result := 'Re: TAGs de uma senha especÌfica';
    $AD: Result := 'Solicitar Desassociacao de TAGs';
    $AE: Result := 'Re: Desassociacao de TAGs';
$AF: Result := 'Solicitar nomes no totem e cores das filas';
$86: Result := 'RE: Nomes no totem e cores das filas ****REMOVIDO****';
    $B1: Result := 'Solicitar reimpress„o de uma senha especÌfica, informando em qual impressora imprimir a senha';
$88: Result := 'Solicitar lista de canais permissionados e canal padr„o';
$89: Result := 'RE: Lista de canais permissionados';
    $8A: Result := 'Setar canal padr„o';
    $8B: Result := 'RE: Canal padr„o setado';
$8C: Result := 'Solicitar par‚metros do mÛdulo SICS';
    $8D: Result := '--- (vago)';
    $8E: Result := '--- (vago)';
    $8F: Result := 'RE: Login efetuado ou acesso negado';
$B2: Result := 'RE: Par‚metros do mÛdulo SICS';
    $B3: Result := 'Obter lista de conexıes TCP/IP';
    $B4: Result := 'RE: Lista de conexıes TCP/IP';
    $B5: Result := 'Informa que o servidor dever· solicitar lista de canais ao painel (TV)';
    $B6: Result := 'Envia canais permissionados';
    $B7: Result := 'Solicitar Log Erros do Servidor';
    $B8: Result := 'Re: Log Erros do Servidor';
    $0A: Result := 'Solita configuraÁ„o gerais path update';
    $0B: Result := 'Re: Solita configuraÁ„o gerais path update';
    $0C: Result := 'Re: Vers„o protocolo diferente';
    $0D: Result := 'Solicita dados SQL';
    $0E: Result := 'Re: Dados SQL';
    $F1: Result := 'Teclado serial - ERRO Timeout';
  else
	  Result := 'N„o encontrado';
  end;
end;


function FieldValueToChar(const aField: TField; const aDefault: Char = CHAR_FALSO): Char;
begin
  Result := aDefault;
  if Assigned(aField) and (Length(aField.AsString) > 0) then
    Result := aField.AsString[1];
end;

function FieldsValueToChar(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDefault: Char = CHAR_FALSO): String;
var
  LFieldName: String;
begin
  Result := EmptyStr;
  for LFieldName in aFieldNames do
  begin
    Result := Result + FieldValueToChar(aSQLDataSet.FieldByName(LFieldName), aDefault);
  end;
end;

function FieldsValueToString(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDelimiter: String = ';'): String;
var
  LFieldName: String;
begin
  Result := aDelimiter;
  for LFieldName in aFieldNames do
  begin
    Result := Result + aSQLDataSet.FieldByName(LFieldName).AsString + aDelimiter;
  end;
end;

function FieldsValueToField(const aSQLDataSet: TSQLQuery; const aFieldNames: Array of String; const aDelimiter: String = '|'): String;
var
  LFieldName: String;
  LField: TField;
begin
  Result := EmptyStr;

  for LFieldName in aFieldNames do
  begin
    LField := aSQLDataSet.FieldByName(LFieldName);
    case LField.DataType of
      ftMemo, ftFixedChar, ftWideString, ftString:
        begin
          Result := Result + LField.AsString;
          if LField.Size > 1 then
            Result := Result + aDelimiter;
        end;
      TFieldType.ftByte, TFieldType.ftShortint, TFieldType.ftLargeint, TFieldType.ftAutoInc, TFieldType.ftSmallint, TFieldType.ftInteger: Result := Result + TAspEncode.AspIntToHex(LField.AsInteger, 4);
      TFieldType.ftSingle, TFieldType.ftLongWord, TFieldType.ftExtended, TFieldType.ftCurrency, TFieldType.ftBCD, TFieldType.ftWord, TFieldType.ftFloat: Result := Result + LField.AsString + aDelimiter;
      TFieldType.ftBoolean: Result := Result + FieldValueToChar(LField);
      TFieldType.ftDate: Result := Result + FormatDateTime('dd/mm/yyyy', LField.AsDateTime);
      TFieldType.ftTime: Result := Result + FormatDateTime('hh:mm:ss', LField.AsDateTime);
      TFieldType.ftDateTime: Result := Result + FormatDateTime('dd/mm/yyyy hh:mm:ss', LField.AsDateTime);
    else
      raise Exception.Create('Erro ao enviar par‚metros.');
    end;
  end;
end;
function SettingsFileNamePosition: String;
begin
  if FSettingsFileNamePosition = '' then
  begin
    FSettingsFileNamePosition := SettingsFileName;
    FSettingsFileNamePosition := IncludeTrailingPathDelimiter(ExtractFileDir(FSettingsFileNamePosition)) + 'PosicaoTela' + ExtractFileName(FSettingsFileNamePosition);
  end;
  Result := FSettingsFileNamePosition;
end;

procedure MyLogException(E: Exception; const DisplayMsg : boolean = false);
var
  LogFileName        : string;
  LimiteDiasLog      : Integer;
  ApresentarMensagem : Boolean;

  f : textfile;
  DataHoje: TDate;
  iLinhaExcluir: Integer;
  sAux, sLogFileNameTemp, sLogFileNameUsando, sDir: string;

  function VerDataPassouLimite: Boolean;
  var
    DataAux: TDate;
  begin
    ReadLn(F, sAux);

    if Length(sAux) = 18 then
      Insert('20', sAux, 7);

    Inc(iLinhaExcluir);
    DataAux := EncodeDate(StrToInt(Copy(sAux, 7, 4)), StrToInt(Copy(sAux, 4, 2)), StrToInt(Copy(sAux, 1, 2)));
    Result := Trunc(DataHoje - DataAux) > LimiteDiasLog;
  end;

  procedure AbrirArquivo(Path: string);
  begin
    sLogFileNameUsando := Path;
    AssignFile(f, Path);
    try
      if FileExists(Path) then
        Append(f)
      else
        Rewrite(f);
    except
      CloseFile(f);
      raise;
    end;
  end;

begin
    sLogFileNameTemp := ApplicationPath + '\TempLog.dat';

  try
    with TIniFile.Create(SettingsFileName) do
    try
      LogFileName        := ReadString  ('Log de Erros', 'NomeDoArquivo'     , ApplicationPath + '\Log.dat' );
      LimiteDiasLog      := ReadInteger ('Log de Erros', 'LimiteDeDias'      , 0                               );
      ApresentarMensagem := ReadBool    ('Log de Erros', 'ApresentarMensagem', false                           );

      if LogFileName = '' then
        LogFileName := ApplicationPath + '\Log.dat';

      sDir := ExtractFileDir(LogFileName);
      if not DirectoryExists(sDir) then
        ForceDirectories(sDir);

      try
        try
          AbrirArquivo(LogFileName);
          TentativaLogException := 0;
        except
          AbrirArquivo(sLogFileNameTemp);
          Inc(TentativaLogException);
          if TentativaLogException > 20 then
            LogFileName := sLogFileNameTemp;
        end;
        WriteLn(f, '=====================================');
        WriteLn(f, FormatDateTime('dd/mm/yyyy  hh:nn:ss', now));
        WriteLn(f, '  Classe: ', E.ClassName);
        WriteLn(f, 'Mensagem: ', E.Message  );
        if LogFileName <> sLogFileNameUsando then
          WriteLn(f, '     Obs: ', 'Gravando em ' + sLogFileNameUsando + ', pois n„o foi possÌvel gravar em ' + LogFileName);
        if (DisplayMsg) or ((E.ClassName <> 'EEnvioDeEmail') and (E.ClassName <> 'ERegistroDeOperacao') and (E.ClassName <> 'ESNMPManagerError') and (ApresentarMensagem)) then
          ErrorMessage('Classe: '+E.ClassName+#13'  Erro: '+E.Message);
      finally
        // checando se "foi mesmo feito um AssignFile", senao da erro ao chamar o CloseFile
        if TTextRec(F).Mode <> fmClosed then
          CloseFile(f);
      end;

      WriteString  ('Log de Erros', 'NomeDoArquivo'     , LogFileName       );
      WriteInteger ('Log de Erros', 'LimiteDeDias'      , LimiteDiasLog     );
      WriteBool    ('Log de Erros', 'ApresentarMensagem', ApresentarMensagem);
    finally
      Free;
    end;
  except
    // se de erro aqui eh pq deu erro ou ao escrever o INI
    // ou ao escrever no arquivo temporario de log
    // esse eh um caso critico, entao CAI FORA
    Exit;
  end;

  try

    iLinhaExcluir := 0;
    if ((FileExists(sLogFileNameUsando)) and (LimiteDiasLog > 0)) then
    try
      Reset(F);
      DataHoje := Date;
      ReadLn(F, sAux);
      iLinhaExcluir := 1;
      while (sAux <> '=====================================')  and (not Eof(F)) do
      begin
        ReadLn(F, sAux);
        Inc(iLinhaExcluir);
      end;
      if VerDataPassouLimite then
      begin
        while not Eof(F) do
        begin
          Inc(iLinhaExcluir);
          ReadLn(F, sAux);
          if sAux <> '=====================================' then
            Continue
          else
            if not VerDataPassouLimite then
              Break;
        end;
        Dec(iLinhaExcluir, 2);
      end
      else
        iLinhaExcluir := 0;
    finally
      CloseFile(f);
    end;

    // edu - depois tentar melhorar isso pra nao ocupar mta memoria
    if iLinhaExcluir > 0 then
    begin
      with TStringList.Create do
      try
        LoadFromFile(sLogFileNameUsando);
        while iLinhaExcluir > 0 do
        begin
          Delete(0);
          Dec(iLinhaExcluir);
        end;
        SaveToFile(sLogFileNameUsando);
      finally
        Free;
      end;
    end;

  except
    on E2: Exception do
    begin
      try
        AssignFile(f, sLogFileNameUsando);
        try
          Append(F);
          WriteLn(f, '=====================================');
          WriteLn(f, FormatDateTime('dd/mm/yyyy  hh:nn:ss', now));
          WriteLn(f, 'Erro ao processar exceÁ„o!');
          WriteLn(f, 'Mensagem: ', E2.Message  );
        finally
          CloseFile(F);
        end;
      except
        //Deu erro dentro do tratamento do erro, n„o faz mais nada, n„o conseguiu logar.
      end;
    end;
  end;
end;

{$IFNDEF IS_MOBILE}
function GetPathArquivoWorking : string;
const
  NomeArquivoWorking          = 'updating.tmp'          ;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FullApplicationPath)) + NomeArquivoWorking;
end;

function AspUpd_GerarScriptUpdateAlternativo(ArqUpDir : String) : Boolean;
var
//  i         : Integer;
  arqscript: TStrings;
const
  NomeScriptUpdateAlternativo = 'UpdateManual.bat';
begin
  Result := True;
  arqscript := TStringList.Create;
  try
    arqscript.Clear;
    Gerar_Log('--------------------------------------------------------------------------------------------------');
    Gerar_Log('Iniciou a geraÁ„o do script do atualizador alternativo (se ocorrer falha grave, todos os arquivos da atualizaÁ„o ser„o copiados diretamente.)');

    arqscript.Add('REM FAZ C”PIA TOTAL E DIRETA DE TODOS OS ARQUIVOS DA ATUALIZA«√O DISPONÕVEL NO LOCAL DE UPDATE,');
    arqscript.Add('REM CASO OCORRA UMA FALHA GRAVE QUE IMPE«A A INICIALIZA«√O NORMAL DA APLICA«√O.');
    arqscript.Add('copy /y "'+IncludeTrailingPathDelimiter(ArqUpDir)+'*.*" "'+ExtractFilePath(FullApplicationPath)+'*.*"');
    Gerar_Log('Copiou todos os arquivos do local de update "'+IncludeTrailingPathDelimiter(ArqUpDir)+'" para a pasta da aplicaÁ„o em "'+ExtractFilePath(FullApplicationPath)+'"');
    arqscript.SaveToFile(ExtractFilePath(FullApplicationPath)+'\'+ NomeScriptUpdateAlternativo);
    Gerar_Log('Terminou de gerar o script do atualizador alternativo.');
  finally
    arqscript.Free;
  end;
end;

function ExisteArquivoWorking : Boolean;
begin
  Result := FileExists(GetPathArquivoWorking);
end;

procedure GerarArquivoWorking;
var
  LStringList: TStringList;
begin
  LStringList := TStringList.Create;
  try
    LStringList.SaveToFile(GetPathArquivoWorking);
  finally
    FreeAndNil(LStringList);
  end;
end;

function Gerar_Log(operacao : String) : String;
var
  LogFile : TextFile;
begin
  AssignFile (LogFile, IncludeTrailingPathDelimiter(SettingsPathName) + 'AspUpdate.log');
  if FileExists(IncludeTrailingPathDelimiter(SettingsPathName) + 'AspUpdate.log') Then
    Append(LogFile)
  else
    Rewrite(LogFile);

  try
    Writeln(LogFile, DateToStr(Date)+' - '+TimeToStr(Time)+' - '+operacao);
  finally
    CloseFile(LogFile);
  end;
end;

function Busca_DLL(ID_exe : Integer; nome_DLL, nome_exe : string) : Boolean;
var
  ModuleSnap    : THandle;
  ModuleEntry32 : TModuleEntry32;
  More          : Boolean;
begin
  ModuleSnap := 0;
  try
    Gerar_Log('Iniciou busca de DLL para o mÛdulo '+nome_exe);
    Result := False;
    ModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ID_exe);

    if (ModuleSnap <> 0) And (ModuleSnap < 1) then Exit;

    ModuleEntry32.dwSize := SizeOf(ModuleEntry32);
    More := Module32First(ModuleSnap, ModuleEntry32);
    while More do
    begin

      Result := (ExtractFileName(StrPas(ModuleEntry32.szExePath)) = nome_DLL);
      if (Result) Then
      begin
        Gerar_Log('Detectou que DLL ' + nome_DLL + ' era dependente do execut·vel '+ExtractFileName(StrPas(ModuleEntry32.szExePath)));
        Break;
      end;

      More := Module32Next(ModuleSnap, ModuleEntry32);
    end;
  finally
    CloseHandle(ModuleSnap);
    Gerar_Log('Terminou busca de DLL para o mÛdulo '+nome_exe);
  end;
end;

function Verifica_dependencias(Lista_arqs_upt : TStrings; var Lista_EXE : TStrings) : Boolean;
const
  PROCESS_TERMINATE=$0001;
var
  i               : Integer;
  ContinueLoop    : BOOL;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
  Gerar_Log('Iniciando verificaÁ„o de dependÍncias e mÛdulos abertos.');
  result := False;
  Lista_EXE.Clear;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    For i := 0 to Lista_arqs_upt.Count - 1 Do
    begin
      if (Length(ExtractFileExt(FProcessEntry32.szExeFile)) <> 0) Then
      begin
        if ExtractFileExt(Lista_arqs_upt.Strings[i]) = '.dll' Then
        begin
          if Busca_DLL(FProcessEntry32.th32ProcessID, Lista_arqs_upt.Strings[i], ExtractFileName(FProcessEntry32.szExeFile)) Then
          begin
            Gerar_Log('Encontrou DLL '+Lista_arqs_upt.Strings[i]+' em execuÁ„o e incluiu na lista de finalizaÁ„o.');
            Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
            Result := True;
          end;
        end
        else
        if FProcessEntry32.szExeFile = Lista_arqs_upt.Strings[i] Then
        begin
          Gerar_Log('Encontrou mÛdulo da aplicaÁ„o '+Lista_arqs_upt.Strings[i]+' em execuÁ„o e incluiu na lista de finalizaÁ„o.');
          Lista_EXE.Add(ExtractFileName(FProcessEntry32.szExeFile));
          Result := True;
        end;
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('Fim da verificaÁ„o de dependÍncias e mÛdulos abertos');
end;

function NaoMostrarNomesRepetidos(Lista_EXE : TStrings) : TStrings;
var
  i: Integer;
  ListaTemp: TStrings;
begin
  ListaTemp := TStringList.Create;
  ListaTemp.Clear;
  for i := 0 to Lista_EXE.Count-1 do
  begin
    if AnsiStrPos(pchar(ListaTemp.Text), pchar(Lista_EXE.Strings[i])) = nil then
      ListaTemp.Add(Lista_EXE.Strings[i]);
  end;
  Result := ListaTemp;
end;

function Lista_arquivos(var Lista_arqs_upt : TStrings; const Path, Mascara : string) : integer;
var
  Findresult : integer;
  SearchRec  : TSearchRec;

  function GetValueOfFile(const FileName: string): string;
  var
    oStream: TStringStream;
  begin
    Result := '';
    if (FileExists(FileName)) then
    begin
      oStream := TStringStream.Create;
      try
        oStream.LoadFromFile(FileName);
        Result := Trim(oStream.DataString);
      finally
        FreeAndNil(oStream);
      end;
    end;
  end;
begin
  try
    Findresult := FindFirst(Path + Mascara, faNormal, SearchRec);
    Lista_arqs_upt.Clear;
    Gerar_Log('Carregou a lista de arquivos disponÌveis no local de publicaÁ„o da nova vers„o.');

    while findresult = 0 Do
    begin
      if (SearchRec.Name <> '..') And (SearchRec.Name <> '.') then
      begin
        if (Fileexists(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) And (Fileexists(Path+SearchRec.Name)) Then
        begin
          if (GetValueOfFile(Path+SearchRec.Name) <> GetValueOfFile(ExtractFilePath(FullApplicationPath)+'\'+SearchRec.Name)) Then
          begin
            Lista_arqs_upt.Add(SearchRec.Name);
            Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' È uma vers„o diferente da atual.');
            Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' ‡ lista de atualizaÁ„o.');
          end;
        end
        else
        if (Fileexists(Path+SearchRec.Name)) Then
        begin
          Lista_arqs_upt.Add(SearchRec.Name);
          Gerar_Log('Verificou que o arquivo '+SearchRec.Name+' È um arquivo novo que n„o existe na vers„o atual, sendo considerado nova vers„o.');
          Gerar_Log('Adicionou o arquivo '+SearchRec.Name+' ‡ lista de atualizaÁ„o.');
        end;
      end;
      Findresult := FindNext(SearchRec);
    end;
    System.SysUtils.FindClose(SearchRec);
    Gerar_Log('Terminou a verificaÁ„o de disponibilidade da nova vers„o.');
  except
    Gerar_Log('Ocorreu um erro durante a verificaÁ„o de uma possÌvel atualizaÁ„o.');
  end;
  Result := 0;
end;

procedure Finalizar_programas(Lista_EXE : TStrings);
const
  PROCESS_TERMINATE=$0001;
var
  i               : Integer;
  ContinueLoop    : BOOL;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
  Gerar_Log('--------------------------------------------------------------------------------------------------');
  Gerar_Log('Fechamento dos mÛdulos e DLLs abertas');
  Gerar_Log('');
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    for i := 0 To Lista_EXE.Count-1 Do
    begin
      if (StrIComp(PChar(ExtractFileName(FProcessEntry32.szExeFile)), PChar(Lista_EXE.Strings[i])) = 0) or (StrIComp(FProcessEntry32.szExeFile, PChar(Lista_EXE.Strings[i])) = 0) Then
      begin
        TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
        Gerar_Log('Finalizou mÛdulo ' + ExtractFileName(FProcessEntry32.szExeFile));
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Gerar_Log('');
  Gerar_Log('Fim do fechamento dos mÛdulos e DLLs abertas.');
  Gerar_Log('--------------------------------------------------------------------------------------------------');
end;

function AspUpd_FazerUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean; export;
var
  i, j                                             : Integer;
  Lista_EXE, arqscript, arqrestore : TStrings;
  FinalizaProgs                                    : Boolean;
  bPrecisaAtualizarEXE                             : Boolean;
  bExecutouBat                                     : Boolean;
const
  NomeScriptUpdate            = 'UpdateTemp.bat'    ;
  NomeScriptRestore           = 'RollbackManual.bat'     ;
  NomeArquivoWorking          = 'updating.tmp'          ;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';
  bExecutouBat := False;

  GerarArquivoWorking;
  try
    Result        := false;
    FinalizaProgs := false;
    bPrecisaAtualizarEXE := False;

    try
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Gerar_Log('InÌcio do processo de atualizaÁ„o dos arquivos (Download)');

      if (ArqUpDir = '') then
      begin
        Gerar_Log('ConfiguraÁ„o da atualizaÁ„o autom·tica n„o est· configurada no INI');
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Exit;
      end;

      Gerar_Log('Local de publicaÁ„o das atualizaÁıes: '+ArqUpDir);
      Gerar_Log('Local atual da aplicaÁ„o: '+ ExtractFilePath(FullApplicationPath));

      Lista_EXE         := TStringList.Create;

      try

        if Lista_arqs_upt.count = 0 then
        begin
          Gerar_Log('Nenhuma atualizaÁ„o foi encontrada pelo mÛdulo '+ExtractFileName(FullApplicationPath)+'. Provavelmente foi feita anteriormente por outro mÛdulo do sistema.');
          Result := True;
          exit;
        end;

        //Verifica se existem mÛdulos DLLs ou execut·veis da aplicaÁ„o, que estejam abertos antes de atualizar.
        Gerar_Log('--------------------------------------------------------------------------------------------------');
        Gerar_Log('VerificaÁ„o de mÛdulos abertos e dependÍncias de DLLs antes de fechar');
        Gerar_Log('');

        if Verifica_dependencias(Lista_arqs_upt, Lista_EXE) Then
        begin
          if Lista_EXE.Count > 1 then
            InformationMessage('O(s) seguinte(s) programa(s) precisa(m) ser fechado(s) antes da atualizaÁ„o:' + #13 + #10 +
            TStringList(NaoMostrarNomesRepetidos(Lista_EXE)).CommaText);

          FinalizaProgs := true;
        end;

        Gerar_Log('');
        Gerar_Log('Fim verificaÁ„o de mÛdulos abertos e dependÍncias');
        Gerar_Log('--------------------------------------------------------------------------------------------------');

        if (Lista_arqs_upt.Count > 0) Then
        begin
          For i := Lista_arqs_upt.Count-1 downto 0 Do
          begin
            try
              SetFileAttributes(PChar(FullApplicationPath), FILE_ATTRIBUTE_NORMAL);
              Gerar_Log('Retirou os atributos de proteÁ„o do arquivo '+ExtractFileName(FullApplicationPath)+' localizado na pasta da aplicaÁ„o.');
              if fileexists(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]) then
              begin
                SetFileAttributes(PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]), FILE_ATTRIBUTE_NORMAL);
                Gerar_Log('Retirou os atributos de proteÁ„o do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplicaÁ„o.');
              end;
            except
              Gerar_Log('Erro ao retirar os atributos de proteÁ„o do arquivo '+Lista_arqs_upt.Strings[i]+' localizado na pasta da aplicaÁ„o.');
              exit;
            end;

            try
              CopyFile(PChar(ArqUpDir+Lista_arqs_upt.Strings[i]),PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]+'.upt'),True);
              Gerar_Log('Baixou o arquivo '+Lista_arqs_upt.Strings[i]+' e gravou como '+Lista_arqs_upt.Strings[i]+'.upt');
            except
              Gerar_Log('Erro ao baixar o arquivo '+Lista_arqs_upt.Strings[i]+' e gravar como '+Lista_arqs_upt.Strings[i]+'.upt');
            end;

            if (not fileexists(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[i]+'.upt')) then
            begin
              For j := 0 To Lista_arqs_upt.Count-1 Do
                Deletefile(PChar(ExtractFilePath(FullApplicationPath)+'\'+Lista_arqs_upt.Strings[j]+'.upt'));

              Gerar_Log('Ocorreu uma falha de conex„o com o servidor. Processo abortado.');
              Result := false;
              Exit;
            end;
            if Lista_arqs_upt.Strings[i] = ExtractFileName(FullApplicationPath) then
            begin
              Lista_arqs_upt.Delete(i);
              bPrecisaAtualizarEXE := True;
            end;
          end;

          Result := True;

          //Gravar script tempor·rio em formato .BAT que substitui os arquivos atuais pelos arquivos baixados
          Gerar_Log('Gerando script de atualizaÁ„o.');
          arqscript  := TStringList.Create;
          arqrestore := TStringList.Create;
          arqrestore.Add('REM M”DULO RESTAURADOR DE BACKUPS DA APLICA«√O PARA RECUPERAR A APLICA«√O SE OCORRER FALHA DURANTE O PROCESSO DE UPDATE.');
          try
            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM FAZ NOVO BACKUP DO PROGRAMA ".EXE" SUBSTITUINDO A C”PIA ANTERIOR.');
              arqscript.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'.bak"');
              arqscript.Add('if exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRU«√O NO SCRIPT DE RESTORE, PARA RESTAURA«√O DO M”DULO PRINCIPAL DA APLICA«√O.');
              arqrestore.Add('if exist "'+FullApplicationPath+'.bak" del "'+FullApplicationPath+'"');
              arqrestore.Add('if not exist "'+FullApplicationPath+'" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM FAZ NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICA«√O SUBSTITUINDO AS C”PIAS ANTERIORES.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqscript.Add('if exist "' +ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak"');
              arqrestore.Add('REM ADICIONA INSTRU«√O NO SCRIPT DE RESTORE, PARA RESTAURA«√O DO ARQUIVO DA APLICA«√O.');
              arqrestore.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" del "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqrestore.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add ('REM TERMINOU DE FAZER O NOVO BACKUP DOS DEMAIS ARQUIVOS DA APLICA«√O. ');
            arqrestore.Add('REM TERMINOU DE PREPARAR O SCRIPT RESTAURADOR DE BACKUPS DA APLICA«√O.');

            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM QUANDO O ARQUIVO PRINCIPAL .EXE N√O POSSUIR ATUALIZA«√O');
              arqscript.Add('REM DISPONÕVEL, DEVER¡ SER CRIADA UMA FALSA ATUALIZA«√O');
              arqscript.Add('REM A PARTIR DO ARQUIVO PRINCIPAL .EXE ATUAL. MAIS ADIANTE,');
              arqscript.Add('REM O ARQUIVO ".UPT" SER¡ NECESS¡RIO PARA QUE O EXECUT¡VEL');
              arqscript.Add('REM ORIGINAL, SEJA RESTAURADO.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" copy /y "'+FullApplicationPath+'" "'+FullApplicationPath+'.upt"');

              arqscript.Add('REM ROLLBACK - SE A FALSA ATUALIZA«√O DO EXECUT¡VEL N√O FOR CRIADA POR ALGUM MOTIVO, SER¡ FEITO O ROLLBACK DA APLICA«√O.');
              arqscript.Add('if not exist "'+FullApplicationPath+'.upt" goto INICIO_ROLLBACK' );
            end;

            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('REM BLOCO QUE DETECTAR¡ QUANDO O ARQUIVO A SER');
              arqscript.Add('REM ATUALIZADO, FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICAR¡ QUE O MESMO N√O ESTAR¡ MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECU«√O.');
              arqscript.Add('REM CASO O ARQUIVO A SER ATUALIZADO N√O SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SER¡ ABORTADO E SER¡ FEITO O ROOLBACK DA APLICA«√O.');
              arqscript.Add('set i=1');
              arqscript.Add(':Repete'+IntToStr(i));
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" DEL "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto Repete'+IntToStr(i));

              arqscript.Add('REM AP”S DETECTAR QUE O ARQUIVO EST¡ FECHADO E TER REMOVIDO O');
              arqscript.Add('REM ORIGINAL, RESTAURA O MESMO A PARTIR DA C”PIA DE ATUALIZA«√O');
              arqscript.Add('REM BAIXADA.');
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" ' + 'move "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.upt" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
              arqscript.Add('REM ');

              arqscript.Add('REM ROLLBACK - SE O ARQUIVO ATUAL N√O FOR ATUALIZADO A PARTIR DE SUA VERS√O ".UPT" POR ALGUM MOTIVO, SER¡ FEITO O ROLLBACK DA APLICA«√O.');
              arqscript.Add('if not exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'" goto INICIO_ROLLBACK');
            end;


            if bPrecisaAtualizarEXE then
            begin
              arqscript.Add('REM BLOCO QUE DETECTAR¡ QUANDO O PROGRAMA PRINCIPAL');
              arqscript.Add('REM FOR FECHADO. SE O ARQUIVO PUDER SER DELETADO,');
              arqscript.Add('REM SIGNIFICAR¡ QUE O MESMO N√O ESTAR¡ MAIS CARREGADO OU');
              arqscript.Add('REM EM EXECU«√O.');
              arqscript.Add('REM CASO O PROGRAMA PRINCIPAL N√O SEJA FECHADO/DELETADO EM APROXIMADAMENTE 5 seg.,');
              arqscript.Add('REM O LOOPING DETECTOR SER¡ ABORTADO E SER¡ FEITO O ROOLBACK DA APLICA«√O.');
              arqscript.Add('set i=1');
              arqscript.Add(':REP');
              arqscript.Add('if exist "'+FullApplicationPath+'" del "'+FullApplicationPath+'"');
              arqscript.Add('set /a i=%i%+1');
              arqscript.Add('REM ROLLBACK - POR TEMPO');
              arqscript.Add('if /I %i% equ 2500 goto INICIO_ROLLBACK');
              arqscript.Add('if exist "'+FullApplicationPath+'" goto REP');

              arqscript.Add('REM FINALMENTE RESTAURA O PROGRAMA PRINCIPAL A PARTIR DA');
              arqscript.Add('REM VERS√O DE ATUALIZA«√O.');
              arqscript.Add('if exist "'+FullApplicationPath+'.upt" move "'+FullApplicationPath+'.upt'+'" "'+FullApplicationPath+'"');
            end;

            arqscript.Add('REM ROLLBACK - SE O EXECUT¡VEL PRINCIPAL N√O FOR ATUALIZADO POR ALGUM MOTIVO, SER¡ FEITO O ROLLBACK DA APLICA«√O.');
            arqscript.Add('if not exist "'+FullApplicationPath+'" goto INICIO_ROLLBACK');

            arqscript.Add('REM VAI DIRETO AO PONTO ONDE COME«A A ATUALIZA«√O DA APLICA«√O.');
            arqscript.Add('goto ATUALIZA«√O');

            arqscript.Add('REM ROTINA DE RESTAURA«√O (ROLLBACK) DE TODOS OS ARQUIVOS DA APLICA«√O, CASO TENHA OCORRIDO ALGUMA FALHA DURANTE A ATUALIZA«√O.');
            arqscript.Add('REM CASO O ARQUIVO EXECUT¡VEL DA APLICA«√O N√O TENHA SIDO RESTAURADO DEVIDO A ALGUMA FALHA, TODOS OS BACKUPS SER√O RESTAURADOS.');
            arqscript.Add('REM RESTAURA O BACKUP DO EXECUT¡VEL PRINCIPAL DA APLICA«√O.');
            arqscript.Add(':INICIO_ROLLBACK');
            arqscript.Add('if exist "'+FullApplicationPath+'.bak" copy /y "'+FullApplicationPath+'.bak" "'+FullApplicationPath+'"');

            arqscript.Add('REM RESTAURA OS BACKUPS DE TODOS OS ARQUIVOS DA APLICA«√O.');
            For i := 0 To Lista_arqs_upt.Count-1 Do
            begin
              arqscript.Add('if exist "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" '+'copy /y "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'.bak" "'+ExtractFilePath(FullApplicationPath)+Lista_arqs_upt.Strings[i]+'"');
            end;
            arqscript.Add('REM FIM DA ROTINA DE RESTAURA«√O (ROLLBACK).');

            arqscript.Add('ECHO N„o foi possÌvel executar a atualizaÁ„o dos arquivos, porque ocorreu uma falha ao baixar o pacote de atualizaÁ„o.');
            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICA«√O COMO ATUAL, ANTES DE REINICIAR O M”DULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');
            arqscript.Add('REM REINICIA O M”DULO PRINCIPAL DA APLICA«√O AP”S O ROLLBACK.');
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('EXIT');

            arqscript.Add('REM A ATUALIZA«√O COME«A NESTE PONTO.');
            arqscript.Add(':ATUALIZA«√O');

            arqscript.Add('REM DEFINE A PASTA DE ORIGEM DA APLICA«√O COMO ATUAL, ANTES DE REINICIAR O M”DULO PRINCIPAL.');
            arqscript.Add('Cd "' + ExtractFilePath(FullApplicationPath)+'"');

            arqscript.Add('REM REINICIA O M”DULO PRINCIPAL DA APLICA«√O AP”S A ATUALIZA«√O E EXLUIR O BAT DE SCRIPT.');
            //arqscript.Add('PAUSE');
            arqscript.Add('del '+ExtractFileName(GetPathArquivoWorking));
            arqscript.Add('Start ' + ExtractFileName(FullApplicationPath));
            arqscript.Add('del '+NomeScriptUpdate);

            arqscript.SaveToFile (ExtractFilePath(FullApplicationPath)+NomeScriptUpdate );
            arqrestore.SaveToFile(ExtractFilePath(FullApplicationPath)+NomeScriptRestore);
          finally
            arqscript.Free;
          end;
          Gerar_Log('Terminou de gerar o script de atualizaÁ„o.');

          Gerar_Log('Chamando o arquivo de script.');
          bExecutouBat := True;
          WinExec(PAnsiChar(AnsiString(ExtractFilePath(FullApplicationPath) + '\' + NomeScriptUpdate)), SW_NORMAL);
          Gerar_Log('Chamou o arquivo de Script para que fosse executado.');

          if FinalizaProgs then
            Finalizar_programas(Lista_EXE);

          Gerar_Log('Fechando a aplicaÁ„o para permitir a substituiÁ„o dos arquivos atuais pelos da nova vers„o.');
          FinalizeApplication;

          ShellExecute(0, 'open', PChar(ApplicationPath), nil, nil, SW_SHOWNORMAL);
          Gerar_Log('Fechou a aplicaÁ„o para permitir a substituiÁ„o dos arquivos atuais pelos da nova vers„o.');

        end;
      finally
        Lista_EXE.Free;
      end;
      Gerar_Log('Finalizou o processo de atualizaÁ„o.');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
    except
      Gerar_Log('Ocorreu um erro durante o processo de atualizaÁ„o.');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Result := False;
    end;
  except
    if not bExecutouBat then
      DeleteFile(Pchar(GetPathArquivoWorking));
    raise;
  end;
end;

function AspUpd_ChecarUpdate(ArqUpDir: string; const Lista_arqs_upt: TStrings): Boolean; export;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';
  Result := false;
  Gerar_Log('--------------------------------------------------------------------------------------------------');
  Gerar_Log('VerificaÁ„o de nova vers„o da aplicaÁ„o');

  if (ArqUpDir = '') then
  begin
    Gerar_Log('ConfiguraÁ„o da atualizaÁ„o autom·tica n„o est· configurada no INI');
    Gerar_Log('--------------------------------------------------------------------------------------------------');
    Exit;
  end;

  AspUpd_GerarScriptUpdateAlternativo(ArqUpDir);

  Gerar_Log('Local de publicaÁ„o das atualizaÁıes: '+ArqUpDir);
  Result := (Lista_arqs_upt.Count > 0);
  if Result then
  begin
    Gerar_Log('Existe atualizaÁ„o disponÌvel.');
  end
  else
  begin
    Gerar_Log('N„o existe atualizaÁ„o disponÌvel.');
    Gerar_Log('--------------------------------------------------------------------------------------------------');
  end;
end;

procedure AspUpd_ChecarEFazerUpdate(ArqUpDir: string); export;
var
  Lista_arqs_upt: TStrings;
begin
  if ((Length(ArqUpDir) > 0) and (ArqUpDir[Length(ArqUpDir)] <> '\')) then
    ArqUpDir := ArqUpDir + '\';

  try
    if (ArqUpDir = '') then
    begin
      Gerar_Log('ConfiguraÁ„o da atualizaÁ„o autom·tica n„o est· configurada no INI');
      Gerar_Log('--------------------------------------------------------------------------------------------------');
      Exit;
    end;

    if ExisteArquivoWorking then
    begin
      InformationMessage('J· existe uma atualizaÁ„o ocorrendo neste momento ou houve uma falha na ˙ltima atualizaÁ„o. Favor tentar novamente.' +
        #13 + 'Arquivo: ' + GetPathArquivoWorking);
      FinalizeApplication;
    end;

    Lista_arqs_upt := TStringList.Create;
    try
      Lista_arquivos(Lista_arqs_upt, ArqUpDir,'*.*');
      if ASPUPD_ChecarUpdate(ArqUpDir, Lista_arqs_upt) then
      begin
        ConfirmationMessage('Existe uma atualizaÁ„o disponÌvel. Clique em Ok para aplicar esta atualizaÁ„o agora.',
          procedure(const aConfirmation: Boolean)
          begin
            if aConfirmation and (not ASPUPD_FazerUpdate(ArqUpDir, Lista_arqs_upt)) Then
            begin
              InformationMessage('N„o foi possÌvel atualizar o sistema. Pode ter ocorrido algum problema de conex„o com o servidor de dados. Por favor feche todos os aplicativos e tente novamente. Caso ainda n„o seja possÌvel, por favor entre em contato com o suporte tÈcnico.');
            end;
          end);
      end;
    finally
      FreeAndNil(Lista_arqs_upt);
    end;
  except
    raise;
  end;
end;

function FindWindowByTitle(WindowTitle: string;AppHandle : HWND): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(AppHandle, GW_HWNDFIRST);
  while NextHandle > 0 do
  begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;

procedure VerificaInstanciaApp(WindowTitle: PWideChar; UseFindWindowByTitle : boolean);
var
  LHandle: THandle;
begin
  if(ContaProcessos(ApplicationName(true)) > 1)then
  begin
    if(UseFindWindowByTitle)then
      LHandle := FindWindowByTitle(WindowTitle,ApplicationHWND)
    else
      LHandle := WinAPI.Windows.FindWindow(nil, WindowTitle);
    if(LHandle <> 0)then
    begin
      SendMessage(LHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
      SetForegroundWindow(LHandle);

      Halt(0);
    end;
  end;
end;
{$ENDIF IS_MOBILE}

procedure ValidaAppMultiInstancia;
{$IFNDEF IS_MOBILE}
var
  LQtdeOutrosProcessos: Integer;
  LNomeApp: String;

  function UpperCaseFirst(Const aValue: String): String;
  begin
    Result := Trim(aValue);
    if Length(Result) > 0 then
      Result[1] := UpperCase(Result[1])[1];
  end;

  function IncluideInfinitive(const aValue: String; const aCount: Integer = 1): String;
  begin
    Result := aValue;
    if aCount > 1 then
      Result := aValue + 's';
  end;
const
  COUNT_CURRENT_APP =1;
{$ENDIF IS_MOBILE}
begin
  {$IFNDEF IS_MOBILE}
  LNomeApp := ApplicationName(True);
  LQtdeOutrosProcessos := ContaProcessos(LNomeApp, True) - COUNT_CURRENT_APP;
  if (LQtdeOutrosProcessos > 0) then
  begin
    WarningMessage(
      Format('%s %s do aplicativo "%s" j· est· em execuÁ„o. '+
       'Por favor feche-o antes de tentar rodar o programa novamente.', [UpperCaseFirst(valorPorExtenso(LQtdeOutrosProcessos)),
        IncluideInfinitive('processo', LQtdeOutrosProcessos), LNomeApp]));
    FinalizeApplication;
  end;
  {$ENDIF IS_MOBILE}
end;

function valorPorExtenso(vlr: real): string;
const
  unidade: array [1 .. 19] of string = ('um', 'dois', 'trÍs', 'quatro', 'cinco', 'seis', 'sete', 'oito', 'nove', 'dez', 'onze', 'doze', 'treze',
    'quatorze', 'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove');
  centena: array [1 .. 9] of string = ('cento', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos',
    'novecentos');
  dezena: array [2 .. 9] of string     = ('vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa');
  qualificaS: array [0 .. 4] of string = ('', 'mil', 'milh„o', 'bilh„o', 'trilh„o');
  qualificaP: array [0 .. 4] of string = ('', 'mil', 'milhıes', 'bilhıes', 'trilhıes');
var
  inteiro                      : Int64;
  resto                        : real;
  vlrS, s, saux, vlrP, centavos: string;
  n, unid, dez, cent, tam, i   : integer;
begin
  if (vlr = 0) then
  begin
    valorPorExtenso := 'zero';
    exit;
  end;

  inteiro := trunc(vlr);    // parte inteira do valor
  resto   := vlr - inteiro; // parte fracion·ria do valor
  vlrS    := inttostr(inteiro);
  if (length(vlrS) > 15) then
  begin
    valorPorExtenso := 'Erro: valor superior a 999 trilhıes.';
    exit;
  end;

  s        := '';
  centavos := inttostr(round(resto * 100));

  // definindo o extenso da parte inteira do valor
  i      := 0;
  while (vlrS <> '0') do
  begin
    tam := length(vlrS);
    // retira do valor a 1a. parte, 2a. parte, por exemplo, para 123456789:
    // 1a. parte = 789 (centena)
    // 2a. parte = 456 (mil)
    // 3a. parte = 123 (milhıes)
    if (tam > 3) then
    begin
      vlrP := copy(vlrS, tam - 2, tam);
      vlrS := copy(vlrS, 1, tam - 3);
    end
    else
    begin // ˙ltima parte do valor
      vlrP := vlrS;
      vlrS := '0';
    end;
    if (vlrP <> '000') then
    begin
      saux := '';
      if (vlrP = '100') then
        saux := 'cem'
      else
      begin
        n    := strtoint(vlrP);     // para n = 371, tem-se:
        cent := n div 100;          // cent = 3 (centena trezentos)
        dez  := (n mod 100) div 10; // dez  = 7 (dezena setenta)
        unid := (n mod 100) mod 10; // unid = 1 (unidade um)
        if (cent <> 0) then
          saux := centena[cent];
        if ((dez <> 0) or (unid <> 0)) then
        begin
          if ((n mod 100)<= 19) then
          begin
            if (length(saux)<> 0) then
              saux := saux + ' e ' + unidade[n mod 100]
            else
              saux := unidade[n mod 100];
          end
          else
          begin
            if (length(saux)<> 0) then
              saux := saux + ' e ' + dezena[dez]
            else
              saux := dezena[dez];
            if (unid <> 0) then
              if (length(saux)<> 0) then
                saux := saux + ' e ' + unidade[unid]
              else
                saux := unidade[unid];
          end;
        end;
      end;
      if ((vlrP = '1') or (vlrP = '001')) then
      begin
        if (i = 0) // 1a. parte do valor (um real)
        then
        else
          saux := saux + ' ' + qualificaS[i];
      end
      else if (i <> 0) then
        saux := saux + ' ' + qualificaP[i];
      if (length(s)<> 0) then
        s := saux + ', ' + s
      else
        s := saux;
    end;
    i     := i + 1; // prÛximo qualificador: 1- mil, 2- milh„o, 3- bilh„o, ...
  end;

  // definindo o extenso dos centavos do valor
  if (centavos <> '0') // valor com centavos
  then
  begin
    if (length(s)<> 0) // se n„o È valor somente com centavos
    then
      s := s + ' e ';
    if (centavos = '1') then
//      s := s + 'um centavo'
    else
    begin
      n := strtoint(centavos);
      if (n <= 19) then
        s := s + unidade[n]
      else
      begin               // para n = 37, tem-se:
        unid := n mod 10; // unid = 37 % 10 = 7 (unidade sete)
        dez  := n div 10; // dez  = 37 / 10 = 3 (dezena trinta)
        s    := s + dezena[dez];
        if (unid <> 0) then
          s := s + ' e ' + unidade[unid];
      end;
//      s := s + ' centavos';
    end;
  end;
  valorPorExtenso := s;
end;

{$IFNDEF IS_MOBILE}
function GetCurrentWindowsUserName: string;
const
  cnMaxUserNameLen = 254;
var
  sUserName    : string;
  dwUserNameLen: DWORD;
begin
  dwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(sUserName, cnMaxUserNameLen);
  GetUserName(PChar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen);
  Result := Trim(sUserName);
end;

function ContaProcessos(s: string; const SomenteDoUsuarioAtual: boolean = false): integer;
var
  KernelVersionHi : DWORD;
  IsWin95         : boolean;
  IsWin95OSR2     : boolean;
  IsWin98         : boolean;
  IsWin98SE       : boolean;
  IsWinME         : boolean;
  IsWinNT         : boolean;
  IsWinNT3        : boolean;
  IsWinNT31       : boolean;
  IsWinNT35       : boolean;
  IsWinNT351      : boolean;
  IsWinNT4        : boolean;
  IsWin2K         : boolean;
  IsWinXP         : boolean;
  ProcessorCount  : Cardinal;
  AllocGranularity: Cardinal;
  PageSize        : Cardinal;
  i               : integer;
  PIDs            : array [0 .. 1024] of DWORD;
  Needed          : DWORD;
  FileName        : string;
  SnapProcHandle  : THandle;
  ProcEntry       : TProcessEntry32;
  NextProc        : boolean;
  UsuarioProcesso : string;
  DominioProcesso : string;
type
  TWindowsVersion = (wvUnknown, wvWin95, wvWin95OSR2, wvWin98, wvWin98SE, wvWinME, wvWinNT31, wvWinNT35, wvWinNT351, wvWinNT4, wvWin2000, wvWinXP);

  PTOKEN_USER = ^TOKEN_USER;

  _TOKEN_USER = record
    User: TSidAndAttributes;
  end;

  TOKEN_USER = _TOKEN_USER;

  function GetModulePath(const Module: HMODULE): string;
  var
    L: integer;
  begin
    L := MAX_PATH + 1;
    SetLength(Result, L);
    L := GetModuleFileName(Module, Pointer(Result), L);
    SetLength(Result, L);
  end;

  function VersionFixedFileInfo(const FileName: string; var FixedInfo: TVSFixedFileInfo): boolean;
  var
    Size, FixInfoLen: DWORD;
    Handle          : DWORD;
    Buffer          : string;
    FixInfoBuf      : PVSFixedFileInfo;
  begin
    Result := false;
    Size   := GetFileVersionInfoSize(PChar(FileName), Handle);
    if Size > 0 then
    begin
      SetLength(Buffer, Size);
      if GetFileVersionInfo(PChar(FileName), Handle, Size, Pointer(Buffer)) and VerQueryValue(Pointer(Buffer), '\', Pointer(FixInfoBuf), FixInfoLen) and
        (FixInfoLen = SizeOf(TVSFixedFileInfo)) then
      begin
        Result    := True;
        FixedInfo := FixInfoBuf^;
      end;
    end;
  end;

  function GetWindowsVersion: TWindowsVersion;
  begin
    Result := wvUnknown;
    case Win32Platform of
      VER_PLATFORM_WIN32_WINDOWS : case Win32MinorVersion of
                                     0 .. 9   : if Trim(Win32CSDVersion) = 'B' then
                                                  Result := wvWin95OSR2
                                                else
                                                  Result := wvWin95;
                                     10 .. 89 : // On Windows ME Win32MinorVersion can be 10 (indicating Windows 98
                                                // under certain circumstances (image name is setup.exe). Checking
                                                // the kernel version is one way of working around that.
                                                if KernelVersionHi = $0004005A then // 4.90.x.x
                                                  Result := wvWinME
                                                else if Trim(Win32CSDVersion) = 'A' then
                                                  Result := wvWin98SE
                                                else
                                                  Result := wvWin98;
                                     90       : Result := wvWinME;
                                   end;
      VER_PLATFORM_WIN32_NT      : case Win32MajorVersion of
                                     3 : case Win32MinorVersion of
                                          1  : Result := wvWinNT31;
                                          5  : Result := wvWinNT35;
                                          51 : Result := wvWinNT351;
                                         end;
                                     4 : Result := wvWinNT4;
                                     5 : case Win32MinorVersion of
                                         0 : Result := wvWin2000;
                                         1 : Result := wvWinXP;
                                         end;
                                   end;
    end;
  end;

  procedure InitSysInfo;
  var
    SystemInfo      : TSystemInfo;
    Kernel32FileName: string;
    VerFixedFileInfo: TVSFixedFileInfo;
  begin
    { processor information related initialization }
    FillChar(SystemInfo, SizeOf(SystemInfo), #0);
    GetSystemInfo(SystemInfo);
    ProcessorCount   := SystemInfo.dwNumberOfProcessors;
    AllocGranularity := SystemInfo.dwAllocationGranularity;
    PageSize         := SystemInfo.dwPageSize;

    { Windows version information }
    IsWinNT          := Win32Platform = VER_PLATFORM_WIN32_NT;
    Kernel32FileName := GetModulePath(GetModuleHandle(kernel32));
    if (not IsWinNT) and VersionFixedFileInfo(Kernel32FileName, VerFixedFileInfo) then
      KernelVersionHi := VerFixedFileInfo.dwProductVersionMS
    else
      KernelVersionHi := 0;

    case GetWindowsVersion of
      wvUnknown   : ;
      wvWin95     : IsWin95 := True;
      wvWin95OSR2 : IsWin95OSR2 := True;
      wvWin98     : IsWin98 := True;
      wvWin98SE   : IsWin98SE := True;
      wvWinME     : IsWinME := True;
      wvWinNT31   : begin
                      IsWinNT3  := True;
                      IsWinNT31 := True;
                    end;
      wvWinNT35   : begin
                      IsWinNT3  := True;
                      IsWinNT35 := True;
                    end;
      wvWinNT351  : begin
                      IsWinNT3   := True;
                      IsWinNT351 := True;
                    end;
      wvWinNT4    : IsWinNT4 := True;
      wvWin2000   : IsWin2K := True;
      wvWinXP     : IsWinXP := True;
    end;
  end;

  function ProcessFileName(PID: DWORD): string;
  var
    Handle : THandle;
    path   : array[0..MAX_PATH - 1] of char;
  begin
    Result := '';

    Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);
    if Handle <> 0 then
      try
        if GetModuleBaseName(Handle, 0, path, MAX_PATH) > 0 then
          Result := path;
      finally
        CloseHandle(Handle);
      end;
  end;

  function GetUserAndDomainFromPID(ProcessId: DWORD; var User, Domain: string): boolean;
  var
    hToken              : THandle;
    cbBuf               : Cardinal;
    ptiUser             : PTOKEN_USER;
    snu                 : SID_NAME_USE;
    ProcessHandle       : THandle;
    UserSize, DomainSize: DWORD;
    bSuccess            : boolean;
  begin
    Result        := false;
    ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION, false, ProcessId);
    if ProcessHandle <> 0 then
    begin
      if OpenProcessToken(ProcessHandle, TOKEN_QUERY, hToken) then
      begin
        bSuccess := GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf);
        ptiUser  := nil;
        while (not bSuccess) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
        begin
          ReallocMem(ptiUser, cbBuf);
          bSuccess := GetTokenInformation(hToken, TokenUser, ptiUser, cbBuf, cbBuf);
        end;
        CloseHandle(hToken);

        if not bSuccess then
        begin
          Exit;
        end;

        UserSize   := 0;
        DomainSize := 0;
        LookupAccountSid(nil, ptiUser.User.Sid, nil, UserSize, nil, DomainSize, snu);
        if (UserSize <> 0) and (DomainSize <> 0) then
        begin
          SetLength(User, UserSize);
          SetLength(Domain, DomainSize);
          if LookupAccountSid(nil, ptiUser.User.Sid, PChar(User), UserSize, PChar(Domain), DomainSize, snu) then
          begin
            Result := True;
            User   := StrPas(PChar(User));
            Domain := StrPas(PChar(Domain));
          end;
        end;

        if bSuccess then
        begin
          FreeMem(ptiUser);
        end;
      end;
      CloseHandle(ProcessHandle);
    end;
  end;

begin
  try
    Result := 0;

    IsWin95         := false;
    IsWin95OSR2     := false;
    IsWin98         := false;
    IsWin98SE       := false;
    IsWinME         := false;
    IsWinNT         := false;
    IsWinNT3        := false;
    IsWinNT31       := false;
    IsWinNT35       := false;
    IsWinNT351      := false;
    IsWinNT4        := false;
    IsWin2K         := false;
    IsWinXP         := false;

    InitSysInfo;

    if GetWindowsVersion in [wvWinNT31, wvWinNT35, wvWinNT351, wvWinNT4] then
    begin
      if EnumProcesses(@PIDs, SizeOf(PIDs), Needed) then
      begin
        for i := 0 to (Needed div SizeOf(DWORD)) - 1 do
        begin
          case PIDs[i] of
            0: // PID 0 is always the "System Idle Process" but this name cannot be
               // retrieved from the system and has to be fabricated.
               FileName := 'System Idle Process';
            2: // On NT 4 PID 2 is the "System Process" but this name cannot be
               // retrieved from the system and has to be fabricated.
               if IsWinNT4 then
                 FileName := 'System Process'
               else
                 FileName := ProcessFileName(PIDs[i]);
            8: // On Win2K PID 8 is the "System Process" but this name cannot be
               // retrieved from the system and has to be fabricated.
               if IsWin2K or IsWinXP then
                 FileName := 'System Process'
               else
                 FileName := ProcessFileName(PIDs[i]);
            else FileName := ProcessFileName(PIDs[i]);
          end; { case }

          if Pos(AnsiUpperCase(s), AnsiUpperCase(FileName)) > 0 then
          begin
            if (not SomenteDoUsuarioAtual) or (GetCurrentWindowsUserName = UsuarioProcesso) then
              Result := Result + 1;
          end;
        end; { for i }
      end;   { if ENumProcesses }
    end      { if GetWinVersion }
    else
    begin
      SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      if (SnapProcHandle <> INVALID_HANDLE_VALUE) then
        try
          ProcEntry.dwSize := SizeOf(ProcEntry);
          NextProc         := Process32First(SnapProcHandle, ProcEntry);
          while NextProc do
          begin
            if ProcEntry.th32ProcessID = 0 then
            begin
              // PID 0 is always the "System Idle Process" but this name cannot be
              // retrieved from the system and has to be fabricated.
              FileName := 'System Idle Process';
            end
            else
            begin
              if IsWin2K or IsWinXP then
              begin
                FileName := ProcessFileName(ProcEntry.th32ProcessID);
                if FileName = '' then
                  FileName := ProcEntry.szExeFile;
              end
              else
                FileName := ExtractFileName(ProcEntry.szExeFile);
            end;

            GetUserAndDomainFromPID(ProcEntry.th32ProcessID, UsuarioProcesso, DominioProcesso);

            if Pos(AnsiUpperCase(s), AnsiUpperCase(FileName)) > 0 then
            begin
              if (not SomenteDoUsuarioAtual) or (GetCurrentWindowsUserName = UsuarioProcesso) then
                Result := Result + 1;
            end;

            NextProc := Process32Next(SnapProcHandle, ProcEntry);
          end;
        finally
          CloseHandle(SnapProcHandle);
        end;
    end; { else }
  except
    Result := 0;
  end; { try .. except }
end;
{$ENDIF}

{$IFNDEF IS_MOBILE}
function GetExeVersion: string;
var
   BufferLen, iDataSize  : Cardinal;
   Buffer     : PChar;
   P, pData   : Pointer;
   S      : String;
   FileName: Pchar;
begin
  FileName := Pchar(PAnsiString(FullApplicationPath));
  Result := '';
  iDataSize := GetFileVersionInfoSize(PChar(FileName), BufferLen);
  if iDataSize > 0 then
  begin
    GetMem(pData, iDataSize);
    try
      if (GetFileVersionInfo(PChar(FileName), 0, iDataSize, pData) and (iDataSize > 0)) then
      begin
        VerQueryValue(pData, '\VarFileInfo\Translation', P, BufferLen);
        S := Format('\StringFileInfo\%.4x%.4x\FileVersion', [LoWord(Integer(P^)), HiWord(Integer(P^))]);

        if VerQueryValue(pData, PChar(S), Pointer(Buffer), BufferLen) then
          Result := StrPas(Buffer);
      end;
    finally
      FreeMem(pData,iDataSize);
    end;
  end;
end;
{$ENDIF}

{$IFNDEF IS_MOBILE}
{$IFDEF SuportaPortaCom}
function PortaSerial_SetConfig(var SerialPort: TVaComm; const SerialConfig: string): boolean;
var
  i, auxbaud, auxdatalength, auxstopbits: Integer;
  auxparity                             : char;
  aux, auxDeviceName                    : string;
begin
  Result := true;
  try
    auxbaud       := 0;
    auxdatalength := 0;
    auxparity     := #0;
    auxDeviceName := '';
    aux           := '';

    for i := 1 to length(SerialConfig) do
    begin
      if SerialConfig[i] = ',' then
      begin
        if auxDeviceName = '' then
          auxDeviceName := aux
        else if auxbaud = 0 then
          auxbaud := strtoint(aux)
        else if auxdatalength = 0 then
          auxdatalength := StrToIntDef(aux, 0)
        else
        if Length(aux) > 0 then
          auxparity := aux[1]
        else
          auxparity := #0;

        aux         := '';
      end
      else
        aux := aux + SerialConfig[i];
    end;
    auxstopbits := StrToIntDef(aux, 0);

    if auxDeviceName = '' then
      auxDeviceName := aux;
    if (auxDeviceName <> '') then
      SerialPort.DeviceName := auxDeviceName;

    case auxbaud of
      110:
        SerialPort.Baudrate := br110;
      300:
        SerialPort.Baudrate := br300;
      600:
        SerialPort.Baudrate := br600;
      1200:
        SerialPort.Baudrate := br1200;
      2400:
        SerialPort.Baudrate := br2400;
      4800:
        SerialPort.Baudrate := br4800;
      9600:
        SerialPort.Baudrate := br9600;
      14400:
        SerialPort.Baudrate := br14400;
      19200:
        SerialPort.Baudrate := br19200;
      38400:
        SerialPort.Baudrate := br38400;
      56000:
        SerialPort.Baudrate := br56000;
      57600:
        SerialPort.Baudrate := br57600;
      115200:
        SerialPort.Baudrate := br115200;
      128000:
        SerialPort.Baudrate := br128000;
      256000:
        SerialPort.Baudrate := br256000;
    else
      begin
        if auxbaud > 0 then
        begin
          SerialPort.Baudrate := brUser;
          SerialPort.UserBaudrate := auxbaud;
        end
        else
        begin
          Result := false;
        end;
      end;
    end; { case }

    case auxdatalength of
      7:
        SerialPort.Databits := db7;
      8:
        SerialPort.Databits := db8;
    else
      Result := false;
    end; { case }

    case auxstopbits of
      1:
        SerialPort.Stopbits := sb1;
      2:
        SerialPort.Stopbits := sb2;
    else
      Result := false;
    end; { case }

    case auxparity of
      'N', 'n':
        SerialPort.Parity := paNone;
      'E', 'e':
        SerialPort.Parity := paEven;
      'O', 'o':
        SerialPort.Parity := paOdd;
    else
      Result := false;
    end; { case }

    // Para gerar erro na function de abertura de porta serial
    if (not Result) then
      SerialPort.DeviceName := 'COM_ERRO';
  except
    Result := false;
  end;
end; { func PortaSerial_SetConfig }
{$ENDIF SuportaPortaCom}
{$ENDIF}

function Coalesce(const aValue, aValueDefault: String): String;
begin
  Result := aValue;
  if (Trim(Result) = '') then
    Result := aValueDefault;
end;


function Coalesce(const aValue, aValueDefault: Single): Single;
begin
  Result := aValue;
  if (Result = 0) then
    Result := aValueDefault;
end;

function Coalesce(const aValue, aValueDefault: TAlphaColor): TAlphaColor;
begin
  Result := aValue;
  if (Result = claNUll) then
    Result := aValueDefault;
end;

function RemovePrefixoCor(const aCorExtensa: String): String;
begin
  Result := aCorExtensa;
end;

function StrAlphaToColor(const aCorExtensa: String): TAlphaColor;
var
  LCorExtensa: String;
begin
  Result := claNull;

  LCorExtensa := Trim(UpperCase(aCorExtensa));

  if (LCorExtensa = UpperCase('Alpha')) then
    Result := TAlphaColorRec.Alpha
  else
  if (LCorExtensa = UpperCase('Aliceblue')) then
    Result := TAlphaColorRec.Aliceblue
  else
  if (LCorExtensa = UpperCase('Antiquewhite')) then
    Result := TAlphaColorRec.Antiquewhite
  else
  if (LCorExtensa = UpperCase('Aqua')) then
    Result := TAlphaColorRec.Aqua
  else
  if (LCorExtensa = UpperCase('Aquamarine')) then
    Result := TAlphaColorRec.Aquamarine
  else
  if (LCorExtensa = UpperCase('Azure')) then
    Result := TAlphaColorRec.Azure
  else
  if (LCorExtensa = UpperCase('Beige')) then
    Result := TAlphaColorRec.Beige
  else
  if (LCorExtensa = UpperCase('Bisque')) then
    Result := TAlphaColorRec.Bisque
  else
  if (LCorExtensa = UpperCase('Black')) then
    Result := TAlphaColorRec.Black
  else
  if (LCorExtensa = UpperCase('Blanchedalmond')) then
    Result := TAlphaColorRec.Blanchedalmond
  else
  if (LCorExtensa = UpperCase('Blue')) then
    Result := TAlphaColorRec.Blue
  else
  if (LCorExtensa = UpperCase('Blueviolet')) then
    Result := TAlphaColorRec.Blueviolet
  else
  if (LCorExtensa = UpperCase('Brown')) then
    Result := TAlphaColorRec.Brown
  else
  if (LCorExtensa = UpperCase('Burlywood')) then
    Result := TAlphaColorRec.Burlywood
  else
  if (LCorExtensa = UpperCase('Cadetblue')) then
    Result := TAlphaColorRec.Cadetblue
  else
  if (LCorExtensa = UpperCase('Chartreuse')) then
    Result := TAlphaColorRec.Chartreuse
  else
  if (LCorExtensa = UpperCase('Chocolate')) then
    Result := TAlphaColorRec.Chocolate
  else
  if (LCorExtensa = UpperCase('Coral')) then
    Result := TAlphaColorRec.Coral
  else
  if (LCorExtensa = UpperCase('Cornflowerblue')) then
    Result := TAlphaColorRec.Cornflowerblue
  else
  if (LCorExtensa = UpperCase('Cornsilk')) then
    Result := TAlphaColorRec.Cornsilk
  else
  if (LCorExtensa = UpperCase('Crimson')) then
    Result := TAlphaColorRec.Crimson
  else
  if (LCorExtensa = UpperCase('Cyan')) then
    Result := TAlphaColorRec.Cyan
  else
  if (LCorExtensa = UpperCase('Darkblue')) then
    Result := TAlphaColorRec.Darkblue
  else
  if (LCorExtensa = UpperCase('Darkcyan')) then
    Result := TAlphaColorRec.Darkcyan
  else
  if (LCorExtensa = UpperCase('Darkgoldenrod')) then
    Result := TAlphaColorRec.Darkgoldenrod
  else
  if (LCorExtensa = UpperCase('Darkgray')) then
    Result := TAlphaColorRec.Darkgray
  else
  if (LCorExtensa = UpperCase('Darkgreen')) then
    Result := TAlphaColorRec.Darkgreen
  else
  if (LCorExtensa = UpperCase('Darkgrey')) then
    Result := TAlphaColorRec.Darkgrey
  else
  if (LCorExtensa = UpperCase('Darkkhaki')) then
    Result := TAlphaColorRec.Darkkhaki
  else
  if (LCorExtensa = UpperCase('Darkmagenta')) then
    Result := TAlphaColorRec.Darkmagenta
  else
  if (LCorExtensa = UpperCase('Darkolivegreen')) then
    Result := TAlphaColorRec.Darkolivegreen
  else
  if (LCorExtensa = UpperCase('Darkorange')) then
    Result := TAlphaColorRec.Darkorange
  else
  if (LCorExtensa = UpperCase('Darkorchid')) then
    Result := TAlphaColorRec.Darkorchid
  else
  if (LCorExtensa = UpperCase('Darkred')) then
    Result := TAlphaColorRec.Darkred
  else
  if (LCorExtensa = UpperCase('Darksalmon')) then
    Result := TAlphaColorRec.Darksalmon
  else
  if (LCorExtensa = UpperCase('Darkseagreen')) then
    Result := TAlphaColorRec.Darkseagreen
  else
  if (LCorExtensa = UpperCase('Darkslateblue')) then
    Result := TAlphaColorRec.Darkslateblue
  else
  if (LCorExtensa = UpperCase('Darkslategray')) then
    Result := TAlphaColorRec.Darkslategray
  else
  if (LCorExtensa = UpperCase('Darkslategrey')) then
    Result := TAlphaColorRec.Darkslategrey
  else
  if (LCorExtensa = UpperCase('Darkturquoise')) then
    Result := TAlphaColorRec.Darkturquoise
  else
  if (LCorExtensa = UpperCase('Darkviolet')) then
    Result := TAlphaColorRec.Darkviolet
  else
  if (LCorExtensa = UpperCase('Deeppink')) then
    Result := TAlphaColorRec.Deeppink
  else
  if (LCorExtensa = UpperCase('Deepskyblue')) then
    Result := TAlphaColorRec.Deepskyblue
  else
  if (LCorExtensa = UpperCase('Dimgray')) then
    Result := TAlphaColorRec.Dimgray
  else
  if (LCorExtensa = UpperCase('Dimgrey')) then
    Result := TAlphaColorRec.Dimgrey
  else
  if (LCorExtensa = UpperCase('Dodgerblue')) then
    Result := TAlphaColorRec.Dodgerblue
  else
  if (LCorExtensa = UpperCase('Firebrick')) then
    Result := TAlphaColorRec.Firebrick
  else
  if (LCorExtensa = UpperCase('Floralwhite')) then
    Result := TAlphaColorRec.Floralwhite
  else
  if (LCorExtensa = UpperCase('Forestgreen')) then
    Result := TAlphaColorRec.Forestgreen
  else
  if (LCorExtensa = UpperCase('Fuchsia')) then
    Result := TAlphaColorRec.Fuchsia
  else
  if (LCorExtensa = UpperCase('Gainsboro')) then
    Result := TAlphaColorRec.Gainsboro
  else
  if (LCorExtensa = UpperCase('Ghostwhite')) then
    Result := TAlphaColorRec.Ghostwhite
  else
  if (LCorExtensa = UpperCase('Gold')) then
    Result := TAlphaColorRec.Gold
  else
  if (LCorExtensa = UpperCase('Goldenrod')) then
    Result := TAlphaColorRec.Goldenrod
  else
  if (LCorExtensa = UpperCase('Gray')) then
    Result := TAlphaColorRec.Gray
  else
  if (LCorExtensa = UpperCase('Green')) then
    Result := TAlphaColorRec.Green
  else
  if (LCorExtensa = UpperCase('Greenyellow')) then
    Result := TAlphaColorRec.Greenyellow
  else
  if (LCorExtensa = UpperCase('Grey')) then
    Result := TAlphaColorRec.Grey
  else
  if (LCorExtensa = UpperCase('Honeydew')) then
    Result := TAlphaColorRec.Honeydew
  else
  if (LCorExtensa = UpperCase('Hotpink')) then
    Result := TAlphaColorRec.Hotpink
  else
  if (LCorExtensa = UpperCase('Indianred')) then
    Result := TAlphaColorRec.Indianred
  else
  if (LCorExtensa = UpperCase('Indigo')) then
    Result := TAlphaColorRec.Indigo
  else
  if (LCorExtensa = UpperCase('Ivory')) then
    Result := TAlphaColorRec.Ivory
  else
  if (LCorExtensa = UpperCase('Khaki')) then
    Result := TAlphaColorRec.Khaki
  else
  if (LCorExtensa = UpperCase('Lavender')) then
    Result := TAlphaColorRec.Lavender
  else
  if (LCorExtensa = UpperCase('Lavenderblush')) then
    Result := TAlphaColorRec.Lavenderblush
  else
  if (LCorExtensa = UpperCase('Lawngreen')) then
    Result := TAlphaColorRec.Lawngreen
  else
  if (LCorExtensa = UpperCase('Lemonchiffon')) then
    Result := TAlphaColorRec.Lemonchiffon
  else
  if (LCorExtensa = UpperCase('Lightblue')) then
    Result := TAlphaColorRec.Lightblue
  else
  if (LCorExtensa = UpperCase('Lightcoral')) then
    Result := TAlphaColorRec.Lightcoral
  else
  if (LCorExtensa = UpperCase('Lightcyan')) then
    Result := TAlphaColorRec.Lightcyan
  else
  if (LCorExtensa = UpperCase('Lightgoldenrodyellow')) then
    Result := TAlphaColorRec.Lightgoldenrodyellow
  else
  if (LCorExtensa = UpperCase('Lightgray')) then
    Result := TAlphaColorRec.Lightgray
  else
  if (LCorExtensa = UpperCase('Lightgreen')) then
    Result := TAlphaColorRec.Lightgreen
  else
  if (LCorExtensa = UpperCase('Lightgrey')) then
    Result := TAlphaColorRec.Lightgrey
  else
  if (LCorExtensa = UpperCase('Lightpink')) then
    Result := TAlphaColorRec.Lightpink
  else
  if (LCorExtensa = UpperCase('Lightsalmon')) then
    Result := TAlphaColorRec.Lightsalmon
  else
  if (LCorExtensa = UpperCase('Lightseagreen')) then
    Result := TAlphaColorRec.Lightseagreen
  else
  if (LCorExtensa = UpperCase('Lightskyblue')) then
    Result := TAlphaColorRec.Lightskyblue
  else
  if (LCorExtensa = UpperCase('Lightslategray')) then
    Result := TAlphaColorRec.Lightslategray
  else
  if (LCorExtensa = UpperCase('Lightslategrey')) then
    Result := TAlphaColorRec.Lightslategrey
  else
  if (LCorExtensa = UpperCase('Lightsteelblue')) then
    Result := TAlphaColorRec.Lightsteelblue
  else
  if (LCorExtensa = UpperCase('Lightyellow')) then
    Result := TAlphaColorRec.Lightyellow
  else
  if (LCorExtensa = UpperCase('LtGray')) then
    Result := TAlphaColorRec.LtGray
  else
  if (LCorExtensa = UpperCase('MedGray')) then
    Result := TAlphaColorRec.MedGray
  else
  if (LCorExtensa = UpperCase('DkGray')) then
    Result := TAlphaColorRec.DkGray
  else
  if (LCorExtensa = UpperCase('MoneyGreen')) then
    Result := TAlphaColorRec.MoneyGreen
  else
  if (LCorExtensa = UpperCase('LegacySkyBlue')) then
    Result := TAlphaColorRec.LegacySkyBlue
  else
  if (LCorExtensa = UpperCase('Cream')) then
    Result := TAlphaColorRec.Cream
  else
  if (LCorExtensa = UpperCase('Lime')) then
    Result := TAlphaColorRec.Lime
  else
  if (LCorExtensa = UpperCase('Limegreen')) then
    Result := TAlphaColorRec.Limegreen
  else
  if (LCorExtensa = UpperCase('Linen')) then
    Result := TAlphaColorRec.Linen
  else
  if (LCorExtensa = UpperCase('Magenta')) then
    Result := TAlphaColorRec.Magenta
  else
  if (LCorExtensa = UpperCase('Maroon')) then
    Result := TAlphaColorRec.Maroon
  else
  if (LCorExtensa = UpperCase('Mediumaquamarine')) then
    Result := TAlphaColorRec.Mediumaquamarine
  else
  if (LCorExtensa = UpperCase('Mediumblue')) then
    Result := TAlphaColorRec.Mediumblue
  else
  if (LCorExtensa = UpperCase('Mediumorchid')) then
    Result := TAlphaColorRec.Mediumorchid
  else
  if (LCorExtensa = UpperCase('Mediumpurple')) then
    Result := TAlphaColorRec.Mediumpurple
  else
  if (LCorExtensa = UpperCase('Mediumseagreen')) then
    Result := TAlphaColorRec.Mediumseagreen
  else
  if (LCorExtensa = UpperCase('Mediumslateblue')) then
    Result := TAlphaColorRec.Mediumslateblue
  else
  if (LCorExtensa = UpperCase('Mediumspringgreen')) then
    Result := TAlphaColorRec.Mediumspringgreen
  else
  if (LCorExtensa = UpperCase('Mediumturquoise')) then
    Result := TAlphaColorRec.Mediumturquoise
  else
  if (LCorExtensa = UpperCase('Mediumvioletred')) then
    Result := TAlphaColorRec.Mediumvioletred
  else
  if (LCorExtensa = UpperCase('Midnightblue')) then
    Result := TAlphaColorRec.Midnightblue
  else
  if (LCorExtensa = UpperCase('Mintcream')) then
    Result := TAlphaColorRec.Mintcream
  else
  if (LCorExtensa = UpperCase('Mistyrose')) then
    Result := TAlphaColorRec.Mistyrose
  else
  if (LCorExtensa = UpperCase('Moccasin')) then
    Result := TAlphaColorRec.Moccasin
  else
  if (LCorExtensa = UpperCase('Navajowhite')) then
    Result := TAlphaColorRec.Navajowhite
  else
  if (LCorExtensa = UpperCase('Navy')) then
    Result := TAlphaColorRec.Navy
  else
  if (LCorExtensa = UpperCase('Oldlace')) then
    Result := TAlphaColorRec.Oldlace
  else
  if (LCorExtensa = UpperCase('Olive')) then
    Result := TAlphaColorRec.Olive
  else
  if (LCorExtensa = UpperCase('Olivedrab')) then
    Result := TAlphaColorRec.Olivedrab
  else
  if (LCorExtensa = UpperCase('Orange')) then
    Result := TAlphaColorRec.Orange
  else
  if (LCorExtensa = UpperCase('Orangered')) then
    Result := TAlphaColorRec.Orangered
  else
  if (LCorExtensa = UpperCase('Orchid')) then
    Result := TAlphaColorRec.Orchid
  else
  if (LCorExtensa = UpperCase('Palegoldenrod')) then
    Result := TAlphaColorRec.Palegoldenrod
  else
  if (LCorExtensa = UpperCase('Palegreen')) then
    Result := TAlphaColorRec.Palegreen
  else
  if (LCorExtensa = UpperCase('Paleturquoise')) then
    Result := TAlphaColorRec.Paleturquoise
  else
  if (LCorExtensa = UpperCase('Palevioletred')) then
    Result := TAlphaColorRec.Palevioletred
  else
  if (LCorExtensa = UpperCase('Papayawhip')) then
    Result := TAlphaColorRec.Papayawhip
  else
  if (LCorExtensa = UpperCase('Peachpuff')) then
    Result := TAlphaColorRec.Peachpuff
  else
  if (LCorExtensa = UpperCase('Peru')) then
    Result := TAlphaColorRec.Peru
  else
  if (LCorExtensa = UpperCase('Pink')) then
    Result := TAlphaColorRec.Pink
  else
  if (LCorExtensa = UpperCase('Plum')) then
    Result := TAlphaColorRec.Plum
  else
  if (LCorExtensa = UpperCase('Powderblue')) then
    Result := TAlphaColorRec.Powderblue
  else
  if (LCorExtensa = UpperCase('Purple')) then
    Result := TAlphaColorRec.Purple
  else
  if (LCorExtensa = UpperCase('Red')) then
    Result := TAlphaColorRec.Red
  else
  if (LCorExtensa = UpperCase('Rosybrown')) then
    Result := TAlphaColorRec.Rosybrown
  else
  if (LCorExtensa = UpperCase('Royalblue')) then
    Result := TAlphaColorRec.Royalblue
  else
  if (LCorExtensa = UpperCase('Saddlebrown')) then
    Result := TAlphaColorRec.Saddlebrown
  else
  if (LCorExtensa = UpperCase('Salmon')) then
    Result := TAlphaColorRec.Salmon
  else
  if (LCorExtensa = UpperCase('Sandybrown')) then
    Result := TAlphaColorRec.Sandybrown
  else
  if (LCorExtensa = UpperCase('Seagreen')) then
    Result := TAlphaColorRec.Seagreen
  else
  if (LCorExtensa = UpperCase('Seashell')) then
    Result := TAlphaColorRec.Seashell
  else
  if (LCorExtensa = UpperCase('Sienna')) then
    Result := TAlphaColorRec.Sienna
  else
  if (LCorExtensa = UpperCase('Silver')) then
    Result := TAlphaColorRec.Silver
  else
  if (LCorExtensa = UpperCase('Skyblue')) then
    Result := TAlphaColorRec.Skyblue
  else
  if (LCorExtensa = UpperCase('Slateblue')) then
    Result := TAlphaColorRec.Slateblue
  else
  if (LCorExtensa = UpperCase('Slategray')) then
    Result := TAlphaColorRec.Slategray
  else
  if (LCorExtensa = UpperCase('Slategrey')) then
    Result := TAlphaColorRec.Slategrey
  else
  if (LCorExtensa = UpperCase('Snow')) then
    Result := TAlphaColorRec.Snow
  else
  if (LCorExtensa = UpperCase('Springgreen')) then
    Result := TAlphaColorRec.Springgreen
  else
  if (LCorExtensa = UpperCase('Steelblue')) then
    Result := TAlphaColorRec.Steelblue
  else
  if (LCorExtensa = UpperCase('Tan')) then
    Result := TAlphaColorRec.Tan
  else
  if (LCorExtensa = UpperCase('Teal')) then
    Result := TAlphaColorRec.Teal
  else
  if (LCorExtensa = UpperCase('Thistle')) then
    Result := TAlphaColorRec.Thistle
  else
  if (LCorExtensa = UpperCase('Tomato')) then
    Result := TAlphaColorRec.Tomato
  else
  if (LCorExtensa = UpperCase('Turquoise')) then
    Result := TAlphaColorRec.Turquoise
  else
  if (LCorExtensa = UpperCase('Violet')) then
    Result := TAlphaColorRec.Violet
  else
  if (LCorExtensa = UpperCase('Wheat')) then
    Result := TAlphaColorRec.Wheat
  else
  if (LCorExtensa = UpperCase('White')) then
    Result := TAlphaColorRec.White
  else
  if (LCorExtensa = UpperCase('Whitesmoke')) then
    Result := TAlphaColorRec.Whitesmoke
  else
  if (LCorExtensa = UpperCase('Yellow')) then
    Result := TAlphaColorRec.Yellow
  else
  if (LCorExtensa = UpperCase('Yellowgreen')) then
    Result := TAlphaColorRec.Yellowgreen
  else
  if (LCorExtensa = UpperCase('Null')) then
    Result := TAlphaColorRec.Null;
end;
{$IFNDEF IS_MOBILE}
function GetPID(ProcessName: string): DWORD; //FunÁ„o obter o ID do Processo (PID)
var
  MyHandle: THandle;
  Struct: TProcessEntry32;
begin
  Result:=0;
  try
    MyHandle:=CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
    Struct.dwSize:=Sizeof(TProcessEntry32);
    if Process32First(MyHandle, Struct) then
      if Struct.szExeFile=ProcessName then
      begin
        Result:=Struct.th32ProcessID;
        Exit;
      end;
    while Process32Next(MyHandle, Struct) do
      if Struct.szExeFile=ProcessName then
      begin
        Result:=Struct.th32ProcessID;
        Exit;
      end;
  except on exception do
    Exit;
  end;
end;
{$ENDIF IS_MOBILE}

{$ENDREGION}


{$REGION 'TAspEncode'}

class function TAspEncode.AspANSIToUTF8(const aChar: Char): Integer;
begin
   case aChar of
    'Ä': Result := 128; //Entrada: Ä:128 saÌda: Ä:226 ID: 128
    'Å': Result := 129; //Entrada: Å:129 saÌda: Å:194 ID: 129
    'Ç': Result := 130; //Entrada: Ç:130 saÌda: Ç:226 ID: 130
    'É': Result := 131; //Entrada: É:131 saÌda: É:198 ID: 131
    'Ñ': Result := 132; //Entrada: Ñ:132 saÌda: Ñ:226 ID: 132
    'Ö': Result := 133; //Entrada: Ö:133 saÌda: Ö:226 ID: 133
    'Ü': Result := 134; //Entrada: Ü:134 saÌda: Ü:226 ID: 134
    'á': Result := 135; //Entrada: á:135 saÌda: á:226 ID: 135
    'à': Result := 136; //Entrada: à:136 saÌda: à:203 ID: 136
    'â': Result := 137; //Entrada: â:137 saÌda: â:226 ID: 137
    'ä': Result := 138; //Entrada: ä:138 saÌda: ä:197 ID: 138
    'ã': Result := 139; //Entrada: ã:139 saÌda: ã:226 ID: 139
    'å': Result := 140; //Entrada: å:140 saÌda: å:197 ID: 140
    'ç': Result := 141; //Entrada: ç:141 saÌda: ç:194 ID: 141
    'é': Result := 142; //Entrada: é:142 saÌda: é:197 ID: 142
    'è': Result := 143; //Entrada: è:143 saÌda: è:194 ID: 143
    'ê': Result := 144; //Entrada: ê:144 saÌda: ê:194 ID: 144
    'ë': Result := 145; //Entrada: ë:145 saÌda: ë:226 ID: 145
    'í': Result := 146; //Entrada: í:146 saÌda: í:226 ID: 146
    'ì': Result := 147; //Entrada: ì:147 saÌda: ì:226 ID: 147
    'î': Result := 148; //Entrada: î:148 saÌda: î:226 ID: 148
    'ï': Result := 149; //Entrada: ï:149 saÌda: ï:226 ID: 149
    'ñ': Result := 150; //Entrada: ñ:150 saÌda: ñ:226 ID: 150
    'ó': Result := 151; //Entrada: ó:151 saÌda: ó:226 ID: 151
    'ò': Result := 152; //Entrada: ò:152 saÌda: ò:203 ID: 152
    'ô': Result := 153; //Entrada: ô:153 saÌda: ô:226 ID: 153
    'ö': Result := 154; //Entrada: ö:154 saÌda: ö:197 ID: 154
    'õ': Result := 155; //Entrada: õ:155 saÌda: õ:226 ID: 155
    'ú': Result := 156; //Entrada: ú:156 saÌda: ú:197 ID: 156
    'ù': Result := 157; //Entrada: ù:157 saÌda: ù:194 ID: 157
    'û': Result := 158; //Entrada: û:158 saÌda: û:197 ID: 158
    'ü': Result := 159; //Entrada: ü:159 saÌda: ü:197 ID: 159
    '†': Result := 160; //Entrada: †:160 saÌda: †:194 ID: 160
    '°': Result := 161; //Entrada: °:161 saÌda: °:194 ID: 161
    '¢': Result := 162; //Entrada: ¢:162 saÌda: ¢:194 ID: 162
    '£': Result := 163; //Entrada: £:163 saÌda: £:194 ID: 163
    '§': Result := 164; //Entrada: §:164 saÌda: §:194 ID: 164
    '•': Result := 165; //Entrada: •:165 saÌda: •:194 ID: 165
    '¶': Result := 166; //Entrada: ¶:166 saÌda: ¶:194 ID: 166
    'ß': Result := 167; //Entrada: ß:167 saÌda: ß:194 ID: 167
    '®': Result := 168; //Entrada: ®:168 saÌda: ®:194 ID: 168
    '©': Result := 169; //Entrada: ©:169 saÌda: ©:194 ID: 169
    '™': Result := 170; //Entrada: ™:170 saÌda: ™:194 ID: 170
    '´': Result := 171; //Entrada: ´:171 saÌda: ´:194 ID: 171
    '¨': Result := 172; //Entrada: ¨:172 saÌda: ¨:194 ID: 172
    '≠': Result := 173; //Entrada: ≠:173 saÌda: ≠:194 ID: 173
    'Æ': Result := 174; //Entrada: Æ:174 saÌda: Æ:194 ID: 174
    'Ø': Result := 175; //Entrada: Ø:175 saÌda: Ø:194 ID: 175
    '∞': Result := 176; //Entrada: ∞:176 saÌda: ∞:194 ID: 176
    '±': Result := 177; //Entrada: ±:177 saÌda: ±:194 ID: 177
    '≤': Result := 178; //Entrada: ≤:178 saÌda: ≤:194 ID: 178
    '≥': Result := 179; //Entrada: ≥:179 saÌda: ≥:194 ID: 179
    '¥': Result := 180; //Entrada: ¥:180 saÌda: ¥:194 ID: 180
    'µ': Result := 181; //Entrada: µ:181 saÌda: µ:194 ID: 181
    '∂': Result := 182; //Entrada: ∂:182 saÌda: ∂:194 ID: 182
    '∑': Result := 183; //Entrada: ∑:183 saÌda: ∑:194 ID: 183
    '∏': Result := 184; //Entrada: ∏:184 saÌda: ∏:194 ID: 184
    'π': Result := 185; //Entrada: π:185 saÌda: π:194 ID: 185
    '∫': Result := 186; //Entrada: ∫:186 saÌda: ∫:194 ID: 186
    'ª': Result := 187; //Entrada: ª:187 saÌda: ª:194 ID: 187
    'º': Result := 188; //Entrada: º:188 saÌda: º:194 ID: 188
    'Ω': Result := 189; //Entrada: Ω:189 saÌda: Ω:194 ID: 189
    'æ': Result := 190; //Entrada: æ:190 saÌda: æ:194 ID: 190
    'ø': Result := 191; //Entrada: ø:191 saÌda: ø:194 ID: 191
    '¿': Result := 192; //Entrada: ¿:192 saÌda: ¿:195 ID: 192
    '¡': Result := 193; //Entrada: ¡:193 saÌda: ¡:195 ID: 193
    '¬': Result := 194; //Entrada: ¬:194 saÌda: ¬:195 ID: 194
    'ƒ': Result := 196; //Entrada: ƒ:196 saÌda: ƒ:195 ID: 196
    '≈': Result := 197; //Entrada: ≈:197 saÌda: ≈:195 ID: 197
    '∆': Result := 198; //Entrada: ∆:198 saÌda: ∆:195 ID: 198
    '«': Result := 199; //Entrada: «:199 saÌda: «:195 ID: 199
    '»': Result := 200; //Entrada: »:200 saÌda: »:195 ID: 200
    '…': Result := 201; //Entrada: …:201 saÌda: …:195 ID: 201
    ' ': Result := 202; //Entrada:  :202 saÌda:  :195 ID: 202
    'À': Result := 203; //Entrada: À:203 saÌda: À:195 ID: 203
    'Ã': Result := 204; //Entrada: Ã:204 saÌda: Ã:195 ID: 204
    'Õ': Result := 205; //Entrada: Õ:205 saÌda: Õ:195 ID: 205
    'Œ': Result := 206; //Entrada: Œ:206 saÌda: Œ:195 ID: 206
    'œ': Result := 207; //Entrada: œ:207 saÌda: œ:195 ID: 207
    '–': Result := 208; //Entrada: –:208 saÌda: –:195 ID: 208
    '—': Result := 209; //Entrada: —:209 saÌda: —:195 ID: 209
    '“': Result := 210; //Entrada: “:210 saÌda: “:195 ID: 210
    '”': Result := 211; //Entrada: ”:211 saÌda: ”:195 ID: 211
    '‘': Result := 212; //Entrada: ‘:212 saÌda: ‘:195 ID: 212
    '’': Result := 213; //Entrada: ’:213 saÌda: ’:195 ID: 213
    '÷': Result := 214; //Entrada: ÷:214 saÌda: ÷:195 ID: 214
    '◊': Result := 215; //Entrada: ◊:215 saÌda: ◊:195 ID: 215
    'ÿ': Result := 216; //Entrada: ÿ:216 saÌda: ÿ:195 ID: 216
    'Ÿ': Result := 217; //Entrada: Ÿ:217 saÌda: Ÿ:195 ID: 217
    '⁄': Result := 218; //Entrada: ⁄:218 saÌda: ⁄:195 ID: 218
    '€': Result := 219; //Entrada: €:219 saÌda: €:195 ID: 219
    '‹': Result := 220; //Entrada: ‹:220 saÌda: ‹:195 ID: 220
    '›': Result := 221; //Entrada: ›:221 saÌda: ›:195 ID: 221
    'ﬁ': Result := 222; //Entrada: ﬁ:222 saÌda: ﬁ:195 ID: 222
    'ﬂ': Result := 223; //Entrada: ﬂ:223 saÌda: ﬂ:195 ID: 223
    '‡': Result := 224; //Entrada: ‡:224 saÌda: ‡:195 ID: 224
    '·': Result := 225; //Entrada: ·:225 saÌda: ·:195 ID: 225
    '‚': Result := 226; //Entrada: ‚:226 saÌda: ‚:195 ID: 226
    '„': Result := 227; //Entrada: „:227 saÌda: „:195 ID: 227
    '‰': Result := 228; //Entrada: ‰:228 saÌda: ‰:195 ID: 228
    'Â': Result := 229; //Entrada: Â:229 saÌda: Â:195 ID: 229
    'Ê': Result := 230; //Entrada: Ê:230 saÌda: Ê:195 ID: 230
    'Á': Result := 231; //Entrada: Á:231 saÌda: Á:195 ID: 231
    'Ë': Result := 232; //Entrada: Ë:232 saÌda: Ë:195 ID: 232
    'È': Result := 233; //Entrada: È:233 saÌda: È:195 ID: 233
    'Í': Result := 234; //Entrada: Í:234 saÌda: Í:195 ID: 234
    'Î': Result := 235; //Entrada: Î:235 saÌda: Î:195 ID: 235
    'Ï': Result := 236; //Entrada: Ï:236 saÌda: Ï:195 ID: 236
    'Ì': Result := 237; //Entrada: Ì:237 saÌda: Ì:195 ID: 237
    'Ó': Result := 238; //Entrada: Ó:238 saÌda: Ó:195 ID: 238
    'Ô': Result := 239; //Entrada: Ô:239 saÌda: Ô:195 ID: 239
    '': Result := 240; //Entrada: :240 saÌda: :195 ID: 240
    'Ò': Result := 241; //Entrada: Ò:241 saÌda: Ò:195 ID: 241
    'Ú': Result := 242; //Entrada: Ú:242 saÌda: Ú:195 ID: 242
    'Û': Result := 243; //Entrada: Û:243 saÌda: Û:195 ID: 243
    'Ù': Result := 244; //Entrada: Ù:244 saÌda: Ù:195 ID: 244
    'ı': Result := 245; //Entrada: ı:245 saÌda: ı:195 ID: 245
    'ˆ': Result := 246; //Entrada: ˆ:246 saÌda: ˆ:195 ID: 246
    '˜': Result := 247; //Entrada: ˜:247 saÌda: ˜:195 ID: 247
    '¯': Result := 248; //Entrada: ¯:248 saÌda: ¯:195 ID: 248
    '˘': Result := 249; //Entrada: ˘:249 saÌda: ˘:195 ID: 249
    '˙': Result := 250; //Entrada: ˙:250 saÌda: ˙:195 ID: 250
    '˚': Result := 251; //Entrada: ˚:251 saÌda: ˚:195 ID: 251
    '¸': Result := 252; //Entrada: ¸:252 saÌda: ¸:195 ID: 252
    '˝': Result := 253; //Entrada: ˝:253 saÌda: ˝:195 ID: 253
    '˛': Result := 254; //Entrada: ˛:254 saÌda: ˛:195 ID: 254
    'ˇ': Result := 255; //Entrada: ˇ:255 saÌda: ˇ:195 ID: 255
  else
    Result := Ord(aChar);
  end;
end;

class function TAspEncode.AspCharToEncode(const aChar: Char): Integer;
begin
  {$IFNDEF ANDROID}
  Result := TEncoding.Default.GetBytes(aChar)[0];
  {$ELSE}
  Result := TAspEncode.AspANSIToUTF8(aChar);
  {$ENDIF ENDIF}
end;

class function TAspEncode.AspIntToHex(const Value,
  Digits: Integer): string;
begin
   Result := Copy(IntToHex(Value, Digits), 1, Digits);
end;
{$ENDREGION}
initialization
  TAspException.FLogExcecao := nil;

 FSettingsFileName := '';
  FDiretorioAsp := '';
//  GetApplication.OnException := TClassLibrary.ErrorHandling;
  ReadDeviceInfo;

  FSettingsFileNamePosition := '';
  TentativaLogException := 0;
  FComparerPositionsForms := TComparerPositionsForms<TPositionForm>.Create;
  FPositionsForms := TPositionsForms.Create(FComparerPositionsForms);

finalization
  TAspException.FLogExcecao := nil;
  FreeAndNil(FPositionsForms);


end.

