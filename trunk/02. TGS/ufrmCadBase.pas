unit ufrmCadBase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, Fmx.Bind.Editors, FMX.Layouts, FMX.Grid, FMX.Types,
  FMX.Controls, FMX.StdCtrls,
  FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.ExtCtrls, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Objects, FMX.Edit, FMX.TabControl, untMainForm,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, udmCadBase,
  MyAspFuncoesUteis, untCommonFrameBase, System.Bindings.Outputs, FMX.Controls.Presentation,
  untCommonFormBase, System.ImageList, FMX.ImgList, FMX.Effects;

type
  TfrmSicsCadBase = class(TFrameBase)
    lytRodape: TLayout;
    btnCancelar: TButton;
    btnOK: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetIDUnidade(const Value: Integer); Override;
    function GetClassDM: TClassdmSicsCadBase; Virtual; abstract;
    procedure HabilitaBotoes; virtual;
  public
    dmSicsCadBase: TdmSicsCadBase;
    mudouTipoPis :Boolean;
    clicouTipoPis : Boolean;
    clicouNoBotaoOK :Boolean;
    changeCheck : Boolean;
    destructor Destroy; override;
    function ValidacaoAtivaModoConectado: Boolean; Override;

    procedure Inicializar; Virtual;
    procedure AtualizarPIS; Virtual;
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;


  end;

implementation

uses
   untCommonDMConnection,
  Sics_Common_Parametros, untCommonDMUnidades;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

procedure TfrmSicsCadBase.AfterConstruction;
begin
  inherited;

  if (IdUnidade = ID_UNIDADE_VAZIA) then
    IdUnidade := vgParametrosModulo.UnidadePadrao;
end;

procedure TfrmSicsCadBase.AtualizarPIS;
begin

end;

procedure TfrmSicsCadBase.btnCancelarClick(Sender: TObject);
begin
  inherited;
  Visible := False;
end;

procedure TfrmSicsCadBase.btnOKClick(Sender: TObject);
begin
  inherited;

  Visible := False;
end;

constructor TfrmSicsCadBase.Create(AOwner: TComponent);
begin
  inherited;
  mudouTipoPis := False;
  clicouTipoPis := False;
  clicouNoBotaoOK := False;
  changeCheck := False;
  dmSicsCadBase := nil;
  FIdUnidade := ID_UNIDADE_VAZIA;
end;

destructor TfrmSicsCadBase.Destroy;
begin
  FreeAndNil(dmSicsCadBase);
  inherited;
end;


procedure TfrmSicsCadBase.HabilitaBotoes;
begin
  btnOK.Enabled := Assigned(dmSicsCadBase) and (dmSicsCadBase.PossuiModificacoes);
end;

procedure TfrmSicsCadBase.Inicializar;
begin
  if not Assigned(dmSicsCadBase) then
    dmSicsCadBase := GetClassDM.Create(Self, IdUnidade)
  else
    dmSicsCadBase.IdUnidade := IdUnidade;
end;

procedure TfrmSicsCadBase.SetIdUnidade(const Value: Integer);
begin
  if (IdUnidade <> Value) then
  begin
    inherited;
    Inicializar;
    AspUpdateColunasGrid(Self, bndList);
  end;
end;

function TfrmSicsCadBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

end.

