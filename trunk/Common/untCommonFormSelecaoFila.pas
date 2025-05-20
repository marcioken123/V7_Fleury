unit untCommonFormSelecaoFila;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
{$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
{$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts,
  FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UITypes, System.Types, System.SysUtils, System.Classes,
  System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis,
  Sics_Common_Parametros, untCommonFormBaseSelecao, untCommonFormBase,
  untCommonDMClient,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Effects;

type
  TFrmSelecaoFila = class(TFrmBaseSelecao)
    laySeguirAtendimento: TLayout;
    btnSeguirAtendimento: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    PermiteFinalizar: Boolean;
    FSenha, FPA: integer;
    FDMClient: TDMClient;
    procedure InicializarLista; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure ConfiguraLayoutAndroid; // RAP 15/06/2016
  end;

function FrmSelecaoFila(const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False; const AOwner: TComponent = nil)
  : TFrmSelecaoFila;

implementation

{$R *.fmx}

uses untCommonFormStyleBook;
{ %CLASSGROUP 'FMX.Controls.TControl' }

{ TFrmSelecaoFila }

function FrmSelecaoFila(const aIDUnidade: integer;
  const aAllowNewInstance: Boolean = False; const AOwner: TComponent = nil)
  : TFrmSelecaoFila;
begin
  Result := TFrmSelecaoFila(TFrmSelecaoFila.GetInstancia(aIDUnidade,
    aAllowNewInstance, AOwner));
end;

constructor TFrmSelecaoFila.Create(AOwner: TComponent);
begin
  inherited;
  PermiteFinalizar := True;
  FDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
end;

destructor TFrmSelecaoFila.Destroy;
begin

  inherited;
end;

procedure TFrmSelecaoFila.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  PermiteFinalizar := True;
end;

procedure TFrmSelecaoFila.FormCreate(Sender: TObject);
begin
  inherited;
{$IFDEF CompilarPara_CALLCENTER}
  Self.Caption := 'Tipo de Ajuda';
  lblSubTitulo.Text := 'Selecione o Tipo de Ajuda:';
{$ENDIF}
end;

procedure TFrmSelecaoFila.FormResize(Sender: TObject);
begin
  inherited;
{$IFDEF ANDROID} // RAP 15/06/2016 //***IOS
  ConfiguraLayoutAndroid;

{$ENDIF ENDIF}
end;

procedure TFrmSelecaoFila.FormShow(Sender: TObject);
{$IFNDEF CompilarPara_CALLCENTER}
var
  i, Fila, PA, Senha: integer;
  DataHora: TDateTime;
{$ENDIF}
begin
  inherited;
{$IFNDEF CompilarPara_CALLCENTER}
  if (vgParametrosModulo.VisualizarAgendamentos) and (Assigned(FDMClient)) then
    for i := 1 to Lista.Items.Count - 1 do
    begin
      Fila := Lista.ListItems[i].Tag;
      PA := FPA;
      Senha := FSenha;
      if Fila > 0 then
      begin
        if FDMClient.ExisteAgendamento(PA, Senha, Fila, DataHora) then
          Lista.Items[i] := IntToStr(Fila) + '          ' +
            FormatDateTime('hh:nn', DataHora) + '         ' +
            FDMClient.GetFilaNome(Fila)
        else
          Lista.Items[i] := FormatFloat('00', Fila) + '         ' + '--:--' +
            '         ' + FDMClient.GetFilaNome(Fila);
      end;
    end;
{$ENDIF}
end;

procedure TFrmSelecaoFila.InicializarLista;
begin
   inherited;
  if ListaInicializada and PermiteFinalizar then
  begin
    {$IFNDEF CompilarPara_CALLCENTER}
    ListaInicializada := False;

    if vgParametrosModulo.PermiteFinalizar then
      Incluir(0, 'Nenhuma (Finalizar atendimento)', 1);
    {$ENDIF}
  end
  else
  if (not ListaInicializada) and (not PermiteFinalizar) and (Lista.Count >= 2) then
  begin
    Lista.Items.Delete(1);
    ListaInicializada := True;
  end;
  Lista.ClearSelection;
end;

procedure TFrmSelecaoFila.ConfiguraLayoutAndroid; // RAP 15/06/2016
begin
  recCaption.Height := 75;
  Self.lblCaption.TextSettings.Font.Size := 42;

  lblSubTitulo.Height := 34;
  lblSubTitulo.TextSettings.Font.Size := 28;
end;

end.
