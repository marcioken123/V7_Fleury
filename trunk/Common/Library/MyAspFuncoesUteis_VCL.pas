unit MyAspFuncoesUteis_VCL;

interface

{$IF Defined(CompilarPara_SCC) OR Defined(CompilarPara_TVMONITOR) OR Defined(CompilarPara_TVCORP)}
  {$INCLUDE ..\..\AspDefineDiretivas.inc}
{$ELSE}
  {$INCLUDE ..\AspDefineDiretivas.inc}
{$ENDIF}

uses
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.ExtCtrls,

{$IFNDEF IS_MOBILE}
  Winapi.ShellAPI,
  WinAPI.Windows,
{$ENDIF !IS_MOBILE}

  Data.DB,
  FireDac.Comp.Client,

  FireDac.DApt,
  FireDac.Phys.FB,
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
  {$IFNDEF IS_MOBILE}
  System.Win.Registry,
  {$ENDIF}
  Xml.xmldom,
  System.Generics.Collections,
  Data.SqlExpr,
  System.UIConsts,
  {$REGION 'AspJSon'}
    System.JSON
  {$ENDREGION};

const
  {$REGION 'ClassLibraryVCL'}
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

{$REGION 'AspectVCL'}
  ID_UNIDADE_PRINCIPAL = 0;
  ID_UNIDADE_VAZIA = -1;
  CHAR_FALSO = 'F';
{$ENDREGION}
type
 {$REGION 'ClassLibraryVCL'}
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
  TInputCloseDialogProc = reference to procedure(const AResult: TModalResult);

{$ENDREGION}

{$REGION 'AspFuncoesUteis'}
  TLogExcecao = procedure (const psMessage: string; aControler: Tobject) of object;
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
{$ENDREGION}

{$REGION 'AspEncode'}
TAspEncode = class
     class function AspCharToEncode(const aChar: Char): Integer;
     class function AspANSIToUTF8(const aChar: Char): Integer;
     class function AspIntToHex(const Value: Integer; const Digits: Integer = 4): string;
end;
{$ENDREGION}

{$REGION 'AspectVCL'}
  TCastControl = Vcl.Controls.TWinControl;
  TCastForm = Vcl.Forms.TForm;
  TCastFrame = Vcl.Forms.TFrame;


  /// <summary>
  ///   Componente que permite ser notificado quando um parent È destruido.
  /// </summary>
  TComponentFreeNotify = class(TComponent{$IFDEF FIREMONKEY}, IFreeNotification, IFreeNotificationBehavior{$ENDIF FIREMONKEY})
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure FreeNotification(AObject: TObject); Reintroduce; Overload; Virtual;
    procedure FreeNotification(AObject: TComponent); Overload; Virtual;

  end;

  TListaControl = TList<TCastControl>;
{$ENDREGION}

{$REGION 'ClassLibrary'}
function EnableDisableAllControls(Controle: Vcl.Controls.TWinControl; const Enable: Boolean;
  aControlNaoModificar: Vcl.Controls.TWinControl = nil): Boolean;

function ArrayToString(const aListaValues: array of string; const aDelimiter: String = '|'): String;

function GetDiretorioAsp: String;//mirrai
function SettingsPathName: string;
function ForceDirAsp(const aDiretorio: String): Boolean;
function ActiveControl: TControl;
procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
function ApplicationName(AExtension: Boolean = False): string; overload;

function ApplicationName(AExtension: string): string; overload;
function ApplicationPath: string;
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
function CurrentPID: Integer;
function Decrypt(AText: string; AKey: string = ''): string;
function Encrypt(AText: string; AKey: string = ''): string;
function Encryption(AMode: TEncryptionMode; AText: string; AKey: string = ''): string;
function ExternalIP: string;
function FileHash(APath: string): string;
function FindConnection: TFDConnection;
function ActiveForm: Vcl.Forms.TForm;
function FindForm(AClass: TComponentClass): Vcl.Forms.TForm;
procedure AspAtualizarPropriedade(aForm: Vcl.Forms.TForm; aComponente: Tobject; const aNomePropriedade: string; const aValorPropriedade: Variant);
function GetSelectValue(const aLista: Vcl.StdCtrls.TListBox): String;
function DeleteFolder(Dir: String): boolean;
function CopyFolder(DirFonte, DirDest: String): boolean;
{$IFNDEF IS_MOBILE}
function CreateProcessSimple(const cmd: string): boolean;
{$ENDIF IS_MOBILE}

function Focused(AControl: TControl): Boolean;
function FullApplicationPath: string;
function GenerateString(ALength: Integer; AContent: string = ''): string;
function Hash(AValue: string; AMode: THashMode): string;
function HtmlDecode(AText: string): string;
function InternalIP: string;
function InternetDateTime(ASyncTime: Boolean = False): TDateTime;
function LineBreak(ACount: Integer = 1): string;
function Mask(AValue: Variant; AMask: string): string;
function MemberClass(AMember: TRttiMember): TClass;
function ClassMemberName(const AMember): string;

function PlatformToString(APlatform: TOSVersion.TPlatform): string;
function PropertyExists(AObject: TObject; AName: string): Boolean;
function AspLerPropriedade(aComponente: TComponent; const aNomePropriedade: string; const aValorPadrao: Variant): Variant;
procedure GetObjectDaPropriedade(var aObject: TObject; var aListaPropriedades: string);
function RemoveCharacter(AText, ACharacters: string): string;
function RemoveLineBreak(AText: string): string;
function RemoveMask(AText: string): string;
function RemoveThousandSeparator(AText: string): string;
function RemoveTag(AText, AOpenTag, ACloseTag: string): string; overload;
function RemoveTag(AText: string): string; overload;
function SettingsFileName: string;
function SetWhereClause(ASQL, ACondition: string): string;
function TextHash(AText: string): string;
function UnicodeChar(AChar: Char): Char;
function WriteDebugLog(AText: string): Boolean;

function WriteLog(AText: string): Boolean;
function WriteSettings(ASection, AIdent: string; AValue: Variant; const aCanForceWrite: Boolean = True): Boolean; overload;
function WriteSettings(AIdent: string; AValue: Variant; const aCanForceWrite: Boolean = True): Boolean; overload;
function WriteTextFile(APath, AText: string; AAppend: Boolean = False): Boolean;
procedure ConnectDatabase;
procedure DisconnectDatabase;
procedure ExecuteThread(AExecute, ATerminate: TProcedure; AShowProgress: Boolean; AMessage: string); overload;
procedure ExecuteThread(AExecute: TProcedure; AMessage: string); overload;
procedure ExecuteThread(AExecute: TProcedure); overload;
procedure ErrorHandling(E: Exception);
procedure ErrorStopMessage(const AMessage: string);
procedure FinalizeApplication;
procedure HttpGet(AURL: string; var AContent: TStream); overload;
procedure HttpPost(AURL: string; AParams: TStrings; var AContent: TStream); overload;
function HttpRequest(AMode: TRequestMode; AURL: string; AParams: TStrings; var AContent: TStream): string;
function HttpGet(AURL: string): string; overload;
function HttpPost(AURL: string; AParams: TStrings): string; overload;
procedure LoadSettings;
procedure WarningMessage(AMessage: string);

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

{$ENDREGION}

{$REGION 'AspectVCL'}
function GetDescProtoculo(const aProtocolo: Integer): String;

procedure ValidaAppMultiInstancia;
function valorPorExtenso(vlr: real): string;
function RemovePrefixoCor(const aCorExtensa: String): String;
function StrAlphaToColor(const aCorExtensa: String): TAlphaColor;

function GetApplication: Vcl.Forms.TApplication;
function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
function SettingsFileNamePosition: String;

{$ENDREGION}
var
{$REGION 'ClassLibraryVCL'}
//  Settings      : TSettings;
  Device        : TDevice;
  DataConnection: TFDConnection;
  Database      : TDatabase;
  FDiretorioAsp: String;
{$ENDREGION}
{$REGION 'AspectVCL'}
   TentativaLogException : integer;
{$ENDREGION}
implementation

uses untLog, MyDlls_DR,
  {$REGION 'AspectVCL'}
  Winapi.PsAPI;
  {$ENDREGION}

{$REGION 'ClassLibrary'}
{$IFNDEF IS_MOBILE}
function GetProgramFilesDir: string;
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

function ActiveControl: TControl;
var
  vForm: TForm;
begin
  Result := nil;
  vForm := ActiveForm;

  if Assigned(vForm) then
    Result := ActiveForm.ActiveControl;
end;

function ApplicationName(AExtension: Boolean): string;
var
  vName: string;
begin
  vName  := ExtractFileName(FullApplicationPath);
  Result := IfThen(AExtension, vName, TPath.GetFileNameWithoutExtension(vName));
end;

function ApplicationName(AExtension: string): string;
begin
  Result := ApplicationName(False) + AExtension; //SICS PA.Ini
end;

function ApplicationPath: string;
begin
  Result := GetApplicationPath;
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
{$ENDIF !IS_MOBILE}
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
  Result := GetApplicationPath;
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
    Result := '';
    exit;
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

function SettingsFileName: string;
begin
  Result := GetAppIniFileName;
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

procedure ErrorStopMessage(const AMessage: string);
begin
  ErrorMessage(AMessage);
end;

procedure FinalizeApplication;
begin
  Halt;
end;

procedure HttpGet(AURL: string; var AContent: TStream);
begin
  HttpRequest(rmGet, AURL, nil, AContent);
end;

procedure HttpPost(AURL: string; AParams: TStrings; var AContent: TStream);
begin
  HttpRequest(rmPost, AURL, AParams, AContent);
end;

procedure LoadSettings;
begin

end;

procedure CustomMessage(AMessage: string; AType: TMsgDlgType;
  aCloseDialogProc: TInputCloseDialogProc);
var
  vButtons     : TMsgDlgButtons;
  LResult: Integer;
begin
  case AType of
    TMsgDlgType.mtWarning, TMsgDlgType.mtError, TMsgDlgType.mtInformation:
      vButtons := [TMsgDlgBtn.mbOK];

    TMsgDlgType.mtConfirmation:
      vButtons := [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo];
  end;

  LResult := VCL.Dialogs.MessageDlg(AMessage, AType, vButtons, 0);

  if Assigned(aCloseDialogProc) then
    aCloseDialogProc(LResult);
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
  vRectangle: Vcl.ExtCtrls.TPanel;
  vLabel    : TLabel;
  vAni      : Vcl.ExtCtrls.TImage;
begin

  if Assigned(FProgressForm) then
    Exit;

  // FAniFrameRate := AniFrameRate;
  // AniFrameRate  := 100;


  FProgressForm              := TForm.CreateNew(GetApplication);
  FProgressForm.BorderStyle  := TFormBorderStyle.bsNone;
  FProgressForm.Position     := TPosition.poMainFormCenter;
  FProgressForm.Height       := 400;
  FProgressForm.Width        := 400;

  vRectangle            := Vcl.ExtCtrls.TPanel.Create(FProgressForm);
  vRectangle.Top        := FProgressForm.Height - vRectangle.Height - 50;
  vRectangle.Left       := Trunc(FProgressForm.Width / 5);
  vRectangle.Parent     := FProgressForm;
  vRectangle.Height     := 20;
  vRectangle.Width      := 250;

  vLabel                          := TLabel.Create(FProgressForm);
  vLabel.Parent                   := vRectangle;

  vLabel.Align                    := TAlign.alClient;
  vLabel.Font.Name                := 'Verdana';
  vLabel.Font.Size                := 12;
  vLabel.Alignment                := TAlignment.taCenter;
  vLabel.Caption                     := FMessage;

  vAni        := Vcl.ExtCtrls.TImage.Create(FProgressForm);
  vAni.Parent := FProgressForm;

  vAni.Align  := TAlign.alTop;
  vAni.Height := 150;
  vAni.Width  := 150;

  vAni.Enabled := True;

  vRectangle.Visible := not FMessage.IsEmpty;

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
    FDiretorioAsp := ExtractFilePath(ApplicationPath);
  Result := FDiretorioAsp;
end;

function ForceDirAsp(const aDiretorio: String): Boolean;
begin
  Result := ForceDirectories(aDiretorio);
end;

function SettingsPathName: string;
begin
  Result := ExtractFilePath(GetAppIniFileName);
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


{$IFNDEF IS_MOBILE}
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

procedure ConfirmationMessage(const AMessage: string; aCloseDialogProc: TInputCloseConfirmationMessage);
var
  LResult: Boolean;
begin
  LResult := MyDlls_DR.ConfirmationMessage(AMessage);
  if Assigned(aCloseDialogProc) then
    aCloseDialogProc(LResult);
end;
{$ENDREGION}

{$REGION 'AspFuncoesUteis'}

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
{$ENDREGION}

{$REGION 'AspEncode'}

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


{$REGION 'AspectVCL'}

function GetApplication: Vcl.Forms.TApplication;
begin
  Result := Vcl.Forms.Application;
end;

function ExtractStr(var aStr: String; const aIndex, aCount: Integer): string;
begin
  Result := Copy(aStr, 2, 4);
  Delete(aStr, 2, 4);
end;

{ TComponentFreeNotify }

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
      TFieldType.ftMemo, TFieldType.ftFixedChar, TFieldType.ftWideString, ftString:
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
  Result := GetAppPositionFileName;
end;

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
  //LNomeApp := ApplicationName(True);
  LNomeApp := ExtractFileName(Application.ExeName);

  LQtdeOutrosProcessos := ContaProcessos(LNomeApp) - COUNT_CURRENT_APP;
  if (LQtdeOutrosProcessos > 0) then
  begin
    ErrorMessage(
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


function RemovePrefixoCor(const aCorExtensa: String): String;
begin
  Result := aCorExtensa;
end;
{$ENDREGION}
initialization

  FDiretorioAsp := '';
//  GetApplication.OnException := TClassLibrary.ErrorHandling;

finalization

end.
