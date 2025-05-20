{$WRITEABLECONST ON}

unit ClassLibraryVCL;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

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
  Xml.xmldom;

const

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
type
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
var
//  Settings      : TSettings;
  Device        : TDevice;
  DataConnection: TFDConnection;
  Database      : TDatabase;
  FDiretorioAsp: String;

implementation

uses AspectVCL, untLog, MyDlls_DR;

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

initialization

  FDiretorioAsp := '';
//  GetApplication.OnException := TClassLibrary.ErrorHandling;

finalization

end.
