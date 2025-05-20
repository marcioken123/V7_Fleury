unit untCommonFormBaseSelecao;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  System.UIConsts,

  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis,
  untCommonFormBase, FMX.Controls.Presentation, System.ImageList,
  FMX.ImgList, FMX.Effects;

const
  {$IFDEF IS_MOBILE}
  CARACTER_SEPARADOR = ' | ';
  {$ELSE}
  CARACTER_SEPARADOR = #9;
  {$ENDIF IS_MOBILE}

type
  TFrmBaseSelecao = class(TFrmBase)
    lblSubTitulo: TLabel;
    lytRodape: TLayout;
    layOkCancelar: TLayout;
    btnOK: TButton;
    btnCancelar: TButton;
    Lista: TListBox;
    ilPrincipal: TImageList;
    procedure FormShow(Sender: TObject);
    procedure ListaChange(Sender: TObject);
    procedure ListaClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListaDblClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSeguirAtendimentoClick(Sender: TObject);

  private
    FClicouAlgumBotao: Boolean;

    {$IFDEF IS_MOBILE}
    FIndexUltimoClick, FQtdeClickRegistro: Integer;
    FDataUltimoClick: TDateTime;

    procedure ClearInfoClick;
    {$ENDIF IS_MOBILE}

    procedure ValidateEnableButtons;

    {$IFDEF ANDROID} //RAP 15/06/2016  //***IOS
    procedure ConfiguraLayoutAndroid; //RAP 15/06/2016
    {$ENDIF ENDIF}
  public
    ListaInicializada: Boolean;
    FCacheUltimoIndexSelecionado: SmallInt;

    procedure InicializarLista; virtual;

    function Incluir(const ID: Integer; const Nome: string; const aIndex: Integer = -1): Boolean; Virtual;
    function PosicionaNoItem(const ID: Integer): Boolean;
    function GetItemIndex(const ID: Integer): Integer;
    function IdSelecionado: Integer;
    function GetSituacaoAtual: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

  end;

implementation

uses
  System.DateUtils;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

{ TFrmBaseSelecao }

procedure TFrmBaseSelecao.InicializarLista;

var
  Header: TListBoxGroupHeader;
begin
  if Lista.Count = 0 then
  begin
    Header        := TListBoxGroupHeader.Create(Self);
    Header.Parent := Lista;
    Header.DefaultTextSettings.Font.Size := 20;

    if MobileDevice then begin //RAP 15/06/2016
      Header.DefaultTextSettings.Font.Size := 28;
      Header.Text := #9#9'ID' + CARACTER_SEPARADOR + 'Nome';
    end else begin
        Header.Text := 'ID              Nome';
    end;
    Lista.AddObject(Header);
    ListaInicializada := true;
  end;
end;

procedure TFrmBaseSelecao.btnSeguirAtendimentoClick(Sender: TObject);
begin
  inherited;
  FClicouAlgumBotao := True;
end;

procedure TFrmBaseSelecao.btnCancelarClick(Sender: TObject);
begin
  inherited;
  FClicouAlgumBotao := False;
end;

procedure TFrmBaseSelecao.btnOKClick(Sender: TObject);
begin
  inherited;
  FCacheUltimoIndexSelecionado := Lista.ItemIndex;
  FClicouAlgumBotao := True;
end;


{$IFDEF IS_MOBILE}
procedure TFrmBaseSelecao.ClearInfoClick;
begin
  FIndexUltimoClick := -1;
  FQtdeClickRegistro := 0;
  FDataUltimoClick := 0;
end;
{$ENDIF IS_MOBILE}

constructor TFrmBaseSelecao.Create(AOwner: TComponent);
begin
  inherited;

  FClicouAlgumBotao := False;

  {$IFDEF IS_MOBILE}
  ClearInfoClick;
  {$ENDIF IS_MOBILE}
  FCacheUltimoIndexSelecionado := -1;
  ListaInicializada := False;
  if MobileDevice then
    Lista.DefaultItemStyles.ItemStyle := 'colorlistboxitemstyle';

end;

destructor TFrmBaseSelecao.Destroy;
begin

  inherited;
end;

procedure TFrmBaseSelecao.FormActivate(Sender: TObject);
begin
  inherited;
  Self.Invalidate;
end;

procedure TFrmBaseSelecao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  btnCloseForm.Visible := False; //RAP 15/06/2016
  if not FClicouAlgumBotao then
    ModalResult := mrCancel;
end;

procedure TFrmBaseSelecao.FormResize(Sender: TObject);
begin
  inherited;
  {$IFDEF ANDROID} //RAP 15/06/2016 //***IOS
    ConfiguraLayoutAndroid;
  {$ENDIF ENDIF}
end;

procedure TFrmBaseSelecao.FormShow(Sender: TObject);
begin
  inherited;
  FClicouAlgumBotao := False;
  InicializarLista;
  Lista.ItemIndex := -1;
  if (Lista.Count > FCacheUltimoIndexSelecionado) then
     Lista.ItemIndex := FCacheUltimoIndexSelecionado;
  ValidateEnableButtons;
end;

function TFrmBaseSelecao.GetItemIndex(const ID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Lista.Items.Count -1 do
  begin
    if (Lista.ListItems[i].Tag = ID) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TFrmBaseSelecao.GetSituacaoAtual: string;
begin
  Result := 'IdSelecionado: ' + IntToStr(IdSelecionado);
end;

function TFrmBaseSelecao.IdSelecionado: Integer;
begin
  Result := -1;
  if (Lista.ItemIndex > -1) then
    Result := Lista.ListItems[Lista.ItemIndex].Tag;
end;

function TFrmBaseSelecao.Incluir(const ID: Integer; const Nome: string; const aIndex: Integer): Boolean;
var
  Linha: string;
  LIndex: Integer;
begin
  Result := True;
  InicializarLista;
  Linha := FormatFloat('00',ID) + '         ' + Nome;
  if Lista.Items.IndexOf(Linha) = -1 then
  begin
    if aIndex = -1 then
      LIndex := Lista.Items.Add(Linha)
    else
    begin
      Lista.Items.Insert(aIndex, Linha);
      LIndex := aIndex;
    end;

    Lista.ListItems[LIndex].Tag := ID;
    {$IFNDEF IS_MOBILE}
    Lista.ListItems[LIndex].DefaultTextSettings.Font.Size := 16;
    Lista.ListItems[LIndex].Font.Size := 16;
    {$ENDIF IS_MOBILE}

    {$IFDEF IS_MOBILE}
    Lista.ListItems[LIndex].DefaultTextSettings.Font.Size := 50;
    Lista.ListItems[LIndex].Font.Size := 50;
    {$ENDIF IS_MOBILE}

    Lista.ListItems[LIndex].StyledSettings := Lista.ListItems[LIndex].StyledSettings - [TStyledSetting.Size];
    Lista.ListItems[LIndex].Repaint;
    Lista.Repaint;
  end;
end;

procedure TFrmBaseSelecao.ListaChange(Sender: TObject);
begin
  inherited;
  ValidateEnableButtons;
end;

procedure TFrmBaseSelecao.ListaClick(Sender: TObject);
begin
  inherited;
  ValidateEnableButtons;
end;

procedure TFrmBaseSelecao.ListaDblClick(Sender: TObject);
begin
  inherited;
  {$IFNDEF ANDROID}
    btnOKClick(sender);
    Self.ModalResult := mrOk;
  {$ENDIF}
end;

function TFrmBaseSelecao.PosicionaNoItem(const ID: Integer): Boolean;
begin
  Lista.ItemIndex := GetItemIndex(ID);
  Result := (Lista.ItemIndex > -1) or (ID = -1);
end;

procedure TFrmBaseSelecao.ValidateEnableButtons;
begin
  btnOK.Enabled := Lista.ItemIndex > 0;
  lblSubTitulo.Visible := (Trim(lblSubTitulo.Text) <> '');
end;


{$IFDEF ANDROID} //RAP 15/06/2016  //***IOS
procedure TFrmBaseSelecao.ConfiguraLayoutAndroid;
var
  Altura, Largura, TamanhoFonte, I: Integer;
begin
  Altura := 70;
  Largura := 250;
  TamanhoFonte := 18;

  recCaption.Height := 75;
  self.lblCaption.TextSettings.Font.Size := 42;

  lblSubTitulo.Height := 34;
  lblSubTitulo.TextSettings.Font.Size := 28;

  lytRodape.Height := 100;
  lytRodape.Position.Y := Self.Height - lytRodape.Height;

  layOkCancelar.Height := lytRodape.Height - 2;
  layOkCancelar.Width := lytRodape.Width - 2;
  layOkCancelar.Position.Y := 1;
  layOkCancelar.Position.X := 1;

  btnOk.TextSettings.Font.Size := TamanhoFonte;
  btnOk.Height := Altura;
  btnOk.Width := Largura;
  btnOk.Position.Y := 15;
  btnOk.Position.X := 15;

  btnCancelar.TextSettings.Font.Size := TamanhoFonte;
  btnCancelar.Height := Altura;
  btnCancelar.Width := Largura;
  btnCancelar.Position.Y := 15;

  btnCancelar.Position.X := (Screen.Width - btnCancelar.Width - 15);

  for I := 0 to Pred(Lista.Items.Count) do begin
    Lista.ListItems[I].TextSettings.Font.Size := 24;
  end;
end;
{$ENDIF ENDIF}

end.
