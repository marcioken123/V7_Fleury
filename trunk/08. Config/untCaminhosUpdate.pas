unit untCaminhosUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.FMTBcd, Datasnap.Provider, Data.DB, sics_94,
  Datasnap.DBClient,MyDlls_DR,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.Client, uDataSetHelper, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

type
  TfrmCaminhosUpdate = class(TForm)
    lblPA: TLabel;
    edtCaminhoPA: TEdit;
    lblMultPA: TLabel;
    edtCaminhoMultPA: TEdit;
    lblTV: TLabel;
    edtCaminhoTV: TEdit;
    lblOnline: TLabel;
    edtCaminhoOnline: TEdit;
    lblTGS: TLabel;
    edtCaminhoTGS: TEdit;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    qryCaminhosUpdate: TFDQuery;
    dspCaminhosUpdate: TDataSetProvider;
    cdsCaminhosUpdate: TClientDataSet;
    Label1: TLabel;
    edtCaminhoCallCenter: TEdit;
    Label2: TLabel;
    edtCaminhoTotemtouch: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCaminhosUpdate: TfrmCaminhosUpdate;

implementation

{$R *.dfm}

procedure TfrmCaminhosUpdate.btnCancelarClick(Sender: TObject);
begin
  qryCaminhosUpdate.Close;
end;

procedure TfrmCaminhosUpdate.btnOKClick(Sender: TObject);
  procedure InserirValor(key : string;valor : string);
  begin
    with cdsCaminhosUpdate do
    begin
      if(Locate('ID',key,[]))then
         Edit
      else
      begin
        Append;
        FieldByName('ID').AsString := key;
      end;
      FieldByName('VALOR').AsString := valor;
      Post;
    end;
  end;
begin
  try
    InserirValor(CONFIG_KEY_PATHUPDATE_PA,edtCaminhoPA.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_MULTIPA,edtCaminhoMultPA.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_ONLINE,edtCaminhoOnline.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_TV,edtCaminhoTV.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_TGS,edtCaminhoTGS.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_CALLCENTER,edtCaminhoCallCenter.Text);
    InserirValor(CONFIG_KEY_PATHUPDATE_TOTEMTOUCH,edtCaminhoTotemtouch.Text);

    cdsCaminhosUpdate.ApplyUpdates(0);
  except on e : Exception  do
    ErrorMessage('Erro ao salvar os caminhos : '+e.Message);
  end;

end;

procedure TfrmCaminhosUpdate.FormCreate(Sender: TObject);
begin
  try
    qryCaminhosUpdate.Connection := dmSicsMain.connOnLine;

    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_PA'     ).AsString    := CONFIG_KEY_PATHUPDATE_PA;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_MULTIPA').AsString    := CONFIG_KEY_PATHUPDATE_MULTIPA;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_ONLINE' ).AsString    := CONFIG_KEY_PATHUPDATE_ONLINE;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_TGS'    ).AsString    := CONFIG_KEY_PATHUPDATE_TGS;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_TV'     ).AsString    := CONFIG_KEY_PATHUPDATE_TV;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_CALLCENTER').AsString := CONFIG_KEY_PATHUPDATE_CALLCENTER;
    cdsCaminhosUpdate.ParamByName('PATH_UPDATE_TOTEMTOUCH').AsString := CONFIG_KEY_PATHUPDATE_TOTEMTOUCH;

    cdsCaminhosUpdate.Open;
  except on e : Exception  do
    begin
      ErrorMessage('Erro ao buscar os caminhos de update: '+e.Message);
    end;
  end;
end;

procedure TfrmCaminhosUpdate.FormShow(Sender: TObject);
  function BuscaValor(key : string) : string;
  begin
     Result := '';
     if(cdsCaminhosUpdate.Locate('ID',key,[]))then
     begin
       Result := cdsCaminhosUpdate.FieldByName('VALOR').AsString;
     end;
  end;
begin
  try
   edtCaminhoPA.Text         := BuscaValor(CONFIG_KEY_PATHUPDATE_PA);
   edtCaminhoMultPA.Text     := BuscaValor(CONFIG_KEY_PATHUPDATE_MULTIPA);
   edtCaminhoOnline.Text     := BuscaValor(CONFIG_KEY_PATHUPDATE_ONLINE);
   edtCaminhoTGS.Text        := BuscaValor(CONFIG_KEY_PATHUPDATE_TGS);
   edtCaminhoTV.Text         := BuscaValor(CONFIG_KEY_PATHUPDATE_TV);
   edtCaminhoCallCenter.Text := BuscaValor(CONFIG_KEY_PATHUPDATE_CALLCENTER);
  except on e: Exception  do
   ErrorMessage('Erro ao buscar valores : '+e.Message);
  end;
end;
end.
