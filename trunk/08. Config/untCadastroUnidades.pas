unit untCadastroUnidades;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  MyDlls_DR,  MyAspFuncoesUteis_VCL,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, System.Math,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons, DB, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmCadastroUnidades = class(TForm)
    edtNome: TDBEdit;
    lblNome: TLabel;
    edtIP: TDBEdit;
    lblIP: TLabel;
    edtBaseDados: TDBEdit;
    lblBaseDados: TLabel;
    edtPorta: TDBEdit;
    lblPorta: TLabel;
    edtPortaTGS: TDBEdit;
    lblPortaTGS: TLabel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    edtIDUnidadeCliente: TDBEdit;
    lblIDUnidade: TLabel;
    pnlConexaoSQL: TPanel;
    lblServer: TLabel;
    lblBanco: TLabel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    edtServerSQL: TDBEdit;
    edtBancoSQL: TDBEdit;
    edtUsuarioSQL: TDBEdit;
    edtSenhaSQL: TDBEdit;
    chxAutenticacaoOSSQL: TDBCheckBox;
    cbTipoBancodeDados: TComboBox;
    lblTipoBanco: TLabel;
    Label1: TLabel;
    lkpGrupo: TDBLookupComboBox;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTipoBancodeDadosSelect(Sender: TObject);
  private
    { Private declarations }
    procedure ApresentaInformacaoBancodeDados;
  public
    { Public declarations }
  end;

var
  FrmCadastroUnidades: TFrmCadastroUnidades;

implementation

uses
   {$IFDEF CompilarPara_CONFIG}untMainForm{$ELSE}, sics_m{$ENDIF},
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.Client, sics_94,
  uScriptUnidades;

{$R *.dfm}

procedure TFrmCadastroUnidades.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmCadastroUnidades.btnOKClick(Sender: TObject);
var
  conn : TFDConnection;
begin
  if Trim(edtNome.Text) = '' then
  begin
    edtNome.SetFocus;
    Abort;
  end;

  if MainForm.cdsUnidades.State in dsEditModes then
  begin
    MainForm.cdsUnidadesTIPOBANCO.AsString := IntToStr(cbTipoBancodeDados.ItemIndex);
    MainForm.cdsUnidades.Post;

    MainForm.cdsUnidades.ApplyUpdates(0);
  end;

  with MainForm.qryAuxScriptBd do
  begin
    Close;
    Sql.Text := 'SELECT VALOR FROM CONFIGURACOES_GERAIS WHERE ID = ' + QuotedStr(CONFIG_KEY_BD_VERSION) + ' AND ID_UNIDADE=' + QuotedStr(MainForm.cdsUnidadesID.AsString);
    Open;

    if IsEmpty then
    begin
      conn := MainForm.connUnidades;
      conn.ExecSQL('INSERT INTO CONFIGURACOES_GERAIS (ID_UNIDADE, ID, VALOR) '+
                   'VALUES (' + QuotedStr(MainForm.cdsUnidadesID.AsString) + ', ' +
                   QuotedStr(CONFIG_KEY_BD_VERSION) + ', ' +
                   QuotedStr(IntToStr(High(ScriptsBdUnidades))) + ')');
      FreeAndNil(conn);
    end;

    Close;
  end;

  Self.Close;
end;

procedure TFrmCadastroUnidades.cbTipoBancodeDadosSelect(Sender: TObject);
begin
  ApresentaInformacaoBancodeDados;
end;

procedure TFrmCadastroUnidades.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_ESCAPE then
    Self.Close

  else if Key = VK_RETURN then
  begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Key := 0;
  end;

  inherited;
end;

procedure TFrmCadastroUnidades.FormShow(Sender: TObject);
begin
  if ((MainForm.cdsUnidades.Active) and (MainForm.cdsUnidadesTIPOBANCO.AsString <> EmptyStr)) then
  begin
    cbTipoBancodeDados.ItemIndex := StrToIntDef(MainForm.cdsUnidadesTIPOBANCO.AsString,0);
  end;

  ApresentaInformacaoBancodeDados;
end;

procedure TFrmCadastroUnidades.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if MainForm.cdsUnidades.State in dsEditModes then
  begin
    MainForm.cdsUnidades.Cancel;
  end;

  inherited;
end;

procedure TFrmCadastroUnidades.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
end;

procedure TFrmCadastroUnidades.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;
procedure TfrmCadastroUnidades.ApresentaInformacaoBancodeDados;
begin
  lblBaseDados.Visible  := (cbTipoBancodeDados.ItemIndex = 0);
  edtBaseDados.Visible  := (cbTipoBancodeDados.ItemIndex = 0);
  pnlConexaoSQL.Visible := (cbTipoBancodeDados.ItemIndex = 1);

  Self.Height           := IfThen(cbTipoBancodeDados.ItemIndex = 1, 370, 250);
end;


end.
