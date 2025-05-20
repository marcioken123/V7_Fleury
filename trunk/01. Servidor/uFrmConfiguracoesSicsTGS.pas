unit uFrmConfiguracoesSicsTGS;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DBCtrls, Buttons, DB, FMTBcd, Sics_91,
  uFrmBaseConfiguracoesSics, Vcl.Mask, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, uDataSetHelper;

type
  TFrmConfiguracoesSicsTGS = class(TFrmBaseConfiguracoesSics)
    chkPodeFecharPrograma: TDBCheckBox;
    lblGruposAtendentesPermitidos: TLabel;
    lblGruposTagsPermitidos: TLabel;
    lblGruposIndicadoresPermitidos: TLabel;
    edtGruposAtendentesPermitidos: TDBEdit;
    edtGruposTagsPermitidos: TDBEdit;
    btnGruposAtendentesPermitidos: TButton;
    btnGruposTagsPermitidos: TButton;
    edtGruposIndicadoresPermitidos: TDBEdit;
    btnGruposIndicadoresPermitidos: TButton;
    lblGruposPausasPermitidos: TLabel;
    edtGruposPausasPermitidos: TDBEdit;
    btnGruposPausasPermitidos: TButton;
    dbchkREPORTAR_TEMPOS_MAXIMOS: TDBCheckBox;
    edtGruposPAsPermitidas: TDBEdit;
    btnGruposPAsPermitidas: TButton;
    lblGruposPAsPermitidas: TLabel;
    dbchkVISUALIZAR_GRUPOS: TDBCheckBox;
    dbchkVISUALIZAR_NOME_CLIENTES: TDBCheckBox;
    dbchkMINIMIZAR_PARA_BANDEJA: TDBCheckBox;
    GroupBox1: TGroupBox;
    dbchkPODE_CONFIG_ATENDENTES: TDBCheckBox;
    dbchkPODE_CONFIG_PRIORIDADES_ATEND: TDBCheckBox;
    dbchkPODE_CONFIG_IND_DE_PERFORMANCE: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    procedure btnGruposAtendentesPermitidosClick(Sender: TObject);
    procedure btnGruposTagsPermitidosClick(Sender: TObject);
    procedure btnGruposIndicadoresPermitidosClick(Sender: TObject);
    procedure chkModoLoginLogoutClick(Sender: TObject);
    procedure btnGruposPausasPermitidosClick(Sender: TObject);
    procedure btnGruposPAsPermitidasClick(Sender: TObject);
    procedure edtGruposAtendentesPermitidosKeyPress(Sender: TObject;
      var Key: Char);
    procedure edtGruposAtendentesPermitidosExit(Sender: TObject);
  protected
    procedure SetDefaultConfig; Override;
    procedure PrepareDataSet; Override;
    function GetTipoModulo: TModuloSics; Override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
    procedure HabilitaBotoes; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsTGS: TFrmConfiguracoesSicsTGS;

implementation

uses sics_94;

{$R *.dfm}

procedure TFrmConfiguracoesSicsTGS.btnGruposAtendentesPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposAtendentesPermitidos, 'GRUPOS_ATENDENTES');
end;

procedure TFrmConfiguracoesSicsTGS.btnGruposIndicadoresPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposIndicadoresPermitidos, 'PIS');
end;

procedure TFrmConfiguracoesSicsTGS.btnGruposTagsPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsPermitidos, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsTGS.btnGruposPAsPermitidasClick(Sender: TObject);
begin
  inherited;
  CarregaGrupos(lblGruposPAsPermitidas, 'GRUPOS_PAS');
end;

procedure TFrmConfiguracoesSicsTGS.btnGruposPausasPermitidosClick(Sender: TObject);
begin
  inherited;
  CarregaGrupos(lblGruposPausasPermitidos, 'GRUPOS_MOTIVOS_PAUSA');
end;

function TFrmConfiguracoesSicsTGS.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsTGS;
end;

function TFrmConfiguracoesSicsTGS.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msTGS;
end;

procedure TFrmConfiguracoesSicsTGS.chkModoLoginLogoutClick(Sender: TObject);
begin
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsTGS.edtGruposAtendentesPermitidosExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsTGS.edtGruposAtendentesPermitidosKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsTGS.HabilitaBotoes;
begin
  inherited;
end;

procedure TFrmConfiguracoesSicsTGS.PrepareDataSet;
begin
  inherited;
  chkPodeFecharPrograma.Checked := true;
end;

procedure TFrmConfiguracoesSicsTGS.SetDefaultConfig;
begin
  inherited;
end;

end.
