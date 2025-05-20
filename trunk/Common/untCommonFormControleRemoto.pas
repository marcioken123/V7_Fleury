unit untCommonFormControleRemoto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBase, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, untCommonDMClient,
  FMX.ListBox, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Data.DB, Datasnap.DBClient;

const
  VERSAO_PROTOCOLO = 3;
  STX              = Chr(2);
  ETX              = Chr(3);

type
  TFrmControleRemoto = class(TFrmBase)
    cbbTV: TComboBox;
    Label1: TLabel;
    btnVolMais: TButton;
    btnVolMenos: TButton;
    btnCanMais: TButton;
    btnCanMenos: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ClientSocket: TIdTCPClient;
    cdsTVs: TClientDataSet;
    cdsTVsNOME: TStringField;
    cdsTVsTCPIP: TStringField;
    SwCloseCaption: TSwitch;
    Label4: TLabel;
    procedure btnVolMaisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetAjusteTV(sMessage: String);
  public
    { Public declarations }
    procedure GetlistPainelTV(Lista: String);
  end;

var
  FrmControleRemoto: TFrmControleRemoto;

implementation

uses
  Sics_Common_Parametros, untCommonDMUnidades, IdGlobal, untCommonDMConnection,
  StrUtils, MyAspFuncoesUteis;

{$R *.fmx}

procedure TFrmControleRemoto.btnVolMaisClick(Sender: TObject);
var
  Comando: String;
begin
  if Sender = btnVolMais then
    Comando := 'V+'
  else
  if Sender = btnVolMenos then
    Comando := 'V-'
  else
  if Sender = btnCanMais  then
    Comando := 'C+'
  else
  if Sender = btnCanMenos then
    Comando := 'C-'
  else
  if Sender = SwCloseCaption then
    Comando := 'T';

  Comando := STX + IntToHex(VERSAO_PROTOCOLO, 4) + '0000' + Chr($A4) + Comando + ETX;

  SetAjusteTV(Comando);
end;

procedure TFrmControleRemoto.FormShow(Sender: TObject);
begin
  DMConnection(ID_UNIDADE_PADRAO, not CRIAR_SE_NAO_EXISTIR)
    .EnviarComando('0000' + Chr($CF),
                   ID_UNIDADE_PADRAO,
                   'Solicitando TVS Controle Remoto',
                   True);

  if not cdsTVs.IsEmpty then
  begin
    cdsTVs.First;
    while not cdsTVs.Eof do
    begin
      cbbTV.Items.Add(cdsTVsNOME.AsString);
      cdsTVs.Next;
    end;
    cbbTV.ItemIndex := 0;
  end;
end;

procedure TFrmControleRemoto.GetlistPainelTV(Lista: String);
var sListaSeparada: TStringDynArray;
    i,iCount: Integer;
    LEnderecosIP : TConexaoIPArray;
    LTCPIP: string;
begin
  sListaSeparada := SplitString(Lista,TAB);
  cdsTVs.CreateDataSet;
  cdsTVs.Open;
  for i:=low(sListaSeparada) to high(sListaSeparada) do
  begin
    if not sListaSeparada[i].IsEmpty then
    begin
      LEnderecosIP := StrToConexaoIpArray(Copy(sListaSeparada[i],(Pos(';', sListaSeparada[i])+1)));
      for iCount := low(LEnderecosIP) to high(LEnderecosIP) do
      begin
        cdsTVs.Append;
        if high(LEnderecosIP) > 0 then
          cdsTVsNOME.AsString  := Copy(sListaSeparada[i],1,(Pos(';', sListaSeparada[i])-1)) + ' - ' + IntToStr(iCount + 1)
        else
          cdsTVsNOME.AsString  := Copy(sListaSeparada[i],1,(Pos(';', sListaSeparada[i])-1));

        LTCPIP               := LEnderecosIP[iCount].EnderecoIP +':'+ IntToStr(LEnderecosIP[iCount].PortaIP);
        cdsTVsTCPIP.AsString := LTCPIP;
        cdsTVs.Post;
      end;
    end;
  end;
end;

procedure TFrmControleRemoto.SetAjusteTV(sMessage: String);
var LTCPIP: string;
begin
  try
    if cdsTVs.Locate('NOME',cbbTV.Selected.Text,[]) then
    begin
      LTCPIP := cdsTVsTCPIP.AsString;

      if Pos(':', LTCPIP) > 0 then
      begin
        ClientSocket.Host := Copy(LTCPIP,1,(Pos(':', LTCPIP)-1));
        ClientSocket.Port := StrToIntDef(Copy(LTCPIP,(Pos(':', LTCPIP) +1)),0);
      end
      else
      begin
        ClientSocket.Host := LTCPIP;
        ClientSocket.Port := 3001;
      end;

      try
        if (not ClientSocket.Connected) then
          ClientSocket.Connect;
      except on e: exception do
        begin
          ShowMessage('Erro ao conectar Socket:' + #13#13 + e.Message);
          Halt;
        end;
      end;
      if ClientSocket.Connected then
        ClientSocket.IOHandler.WriteLn(sMessage, IndyTextEncoding_OSDefault);
    end;
  except on e: exception do
    begin
      ShowMessage('Erro ao enviar comando ao servidor.' + #13#13 + e.Message);
    end;
  end;
end;

end.
