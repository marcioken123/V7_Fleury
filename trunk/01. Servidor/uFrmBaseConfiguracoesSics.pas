unit uFrmBaseConfiguracoesSics;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons, DB, Grids, DBGrids,
  FMTBcd, DBClient, Sics_91,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, uDataSetHelper;

type
  TFieldsTypes = set of TFieldType;

  TFrmBaseConfiguracoesSics = class(TForm)
    pnlFundo: TPanel;
    grpConfiguracoes: TGroupBox;
    pnlButtonSicsPA: TPanel;
    btnSair: TBitBtn;
    grpConfigTela: TGroupBox;
    grpOutrasConfig: TGroupBox;
    dtsConfig: TDataSource;
    CDSConfig: TClientDataSet;
    dtsModulos: TDataSource;
    CDSModulos: TClientDataSet;
    grpModulos: TGroupBox;
    grdModulos: TDBGrid;
    pnlNovaConfig: TPanel;
    edtNovaConfig: TEdit;
    btnNovaConfig: TButton;
    btnCancelar: TButton;
    btnSicsIncluir: TBitBtn;
    btnSicsExcluir: TBitBtn;
    btnCopiar: TBitBtn;
    btnSalvar: TBitBtn;
    grpGrid: TGroupBox;
    procedure btnSairClick(Sender: TObject);
    procedure btnSicsIncluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCopiarClick(Sender: TObject);
    procedure btnNovaConfigClick(Sender: TObject);
    procedure edtNovaConfigChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtNovaConfigKeyPress(Sender: TObject; var Key: Char);
    procedure grdModulosColEnter(Sender: TObject);
    procedure CDSConfigAfterInsert(DataSet: TDataSet);
    procedure btnSicsExcluirClick(Sender: TObject);
    procedure CDSConfigAfterScroll(DataSet: TDataSet);
    procedure CDSConfigAfterOpen(DataSet: TDataSet);
    procedure btnSalvarClick(Sender: TObject);
    procedure dtsModulosStateChange(Sender: TObject);
    procedure CDSModulosAfterOpen(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure CDSModulosBeforePost(DataSet: TDataSet);
    procedure grdModulosExit(Sender: TObject);
    procedure grdModulosTitleClick(Column: TColumn);
    procedure CDSModulosReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
  private
    FErrors: String;
  protected
    procedure HabilitaBotoesModulos;
    procedure SaveUpdates; Virtual;
    procedure CancelUpdates; Virtual;
    procedure SaveData; Virtual;
    procedure CancelData; Virtual;
    function PermiteCopiarField(const aField: TField): Boolean; virtual;
    procedure PrepareDataSet; Virtual;
    function GetKeyField: String; Virtual;
    function GetTipoModulo: TModuloSics; Virtual; abstract;
    function GetDataSetModuloPrincipal: TClientDataSet; Virtual;
    procedure ModoEdicaoDataSet;
    procedure SetDefaultConfig; Virtual;
    procedure HabilitaBotoes; Virtual;
    procedure HabilitaBotaoSalvar; Virtual;
    function CarregaGrupos(const aEdit: TDBEdit;
      const aNomeGrupo, aTitulo: String; const aMultiSelect: boolean = True): Boolean; overload; Virtual;
    function CarregaGrupos(const aEdit: TLabel; const aNomeGrupo: String; const aMultiSelect: boolean = True)
      : Boolean; overload; Virtual;
    procedure SomenteNumeros(var Key: Char);
    procedure VerificaSequenciaNumeros(var Sender: TObject);
    function GetDataSetFormPrincipal: TClientDataSet; Virtual; abstract;
  public
    { Public declarations }
    class procedure ExibeForm;
  end;

function CarregarGrupos(Conexao: TFDConnection;
  const Tabela, pGrupos, aTitulo: string; const aMultiSelect: boolean = True): string;

implementation

uses sics_94, MyDlls_DR, MyAspFuncoesUteis_VCL, uSelecaoGrupos;

{$R *.dfm}

var
  vApertouBotaoConfirmar: Boolean;

function DataSetEditing(poDataSet: TDataSet): Boolean;
begin
  Result := Assigned(poDataSet) and poDataSet.Active and
    (poDataSet.State in [dsInsert, dsEdit]);
end;

procedure TFrmBaseConfiguracoesSics.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmBaseConfiguracoesSics.btnSalvarClick(Sender: TObject);
begin
  SaveUpdates;
  vApertouBotaoConfirmar := True;
  Close;
end;

procedure TFrmBaseConfiguracoesSics.btnSicsExcluirClick(Sender: TObject);
begin
  SaveData;
  if ((not CDSModulos.IsEmpty) or (not CDSConfig.IsEmpty)) and
    (Application.MessageBox
    ('Tem certeza que deseja excluir o registro selecionado?', 'Confirmação',
    MB_YESNO + MB_ICONQUESTION) = ID_YES) then
  // MRZ Alterado de cdsSicsPA para cdsSicsOnLine
  begin
    if (not CDSConfig.IsEmpty) then
      CDSConfig.Delete;

    if (not CDSModulos.IsEmpty) then
      CDSModulos.Delete;
  end;
end;

procedure TFrmBaseConfiguracoesSics.btnSicsIncluirClick(Sender: TObject);
begin
  pnlNovaConfig.Visible := True;
  edtNovaConfig.SetFocus;
end;

procedure TFrmBaseConfiguracoesSics.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
  PrepareDataSet;
  grdModulos.SelectedIndex := 1;
  vApertouBotaoConfirmar := false;
end;

procedure TFrmBaseConfiguracoesSics.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

function TFrmBaseConfiguracoesSics.GetDataSetModuloPrincipal: TClientDataSet;
begin
  dmSicsMain.CDSModulos.Close;
  dmSicsMain.CDSModulos.Open;

  Result := dmSicsMain.CDSModulos;
end;

function TFrmBaseConfiguracoesSics.GetKeyField: String;
begin
  Result := 'ID';
end;

procedure TFrmBaseConfiguracoesSics.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (not vApertouBotaoConfirmar) then
  begin
    if Application.MessageBox
      ('Atenção! Os dados serão perdidos, deseja realmente sair?',
      'Confirmação', MB_ICONQUESTION or MB_YESNO) = mrNo then
    begin
      Abort;
    end;
  end;
  CancelUpdates;
end;

procedure TFrmBaseConfiguracoesSics.CDSConfigAfterInsert(DataSet: TDataSet);
begin
  SetDefaultConfig;
end;

procedure TFrmBaseConfiguracoesSics.CDSConfigAfterOpen(DataSet: TDataSet);
begin
  HabilitaBotoes;
end;

procedure TFrmBaseConfiguracoesSics.CDSConfigAfterScroll(DataSet: TDataSet);
begin
  HabilitaBotoes;
end;

procedure TFrmBaseConfiguracoesSics.CDSModulosAfterOpen(DataSet: TDataSet);
begin
  HabilitaBotoesModulos;
end;

procedure TFrmBaseConfiguracoesSics.CDSModulosBeforePost(DataSet: TDataSet);
begin
  with CDSModulos do
  begin
    if (FieldByName('ID').AsString = '') then
    begin
      if (FieldByName('NOME').AsString <> '') then
      begin
        FieldByName('ID').Value := dmSicsMain.GetID_MODULOS(GetTipoModulo);
        FieldByName('TIPO').Value := Integer(GetTipoModulo);

        CDSConfig.Append;
        CDSConfig.FieldByName(GetKeyField).Value := CDSModulos.FieldByName('ID').Value;
        CDSConfig.Post;
      end
      else
        DataSet.Delete;
    end;
  end;

end;

procedure TFrmBaseConfiguracoesSics.CDSModulosReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  FErrors := FErrors + E.Message + sLineBreak;
  MyLogException(E);
end;

procedure TFrmBaseConfiguracoesSics.dtsModulosStateChange(Sender: TObject);
begin
  HabilitaBotoesModulos;
end;

procedure TFrmBaseConfiguracoesSics.btnCopiarClick(Sender: TObject);
var
  vValues: array of Variant;
  I: Integer;
  S: string;
  X, Y: Integer;
begin
  SaveData;
  S := EmptyStr;
  if (CDSModulos.RecordCount > 1) then
  begin
    CDSModulos.Prior;
    S := CDSModulos.FieldByName('ID').AsString;
    CDSModulos.Next;
  end;

  if (not CDSConfig.IsEmpty) and InputQuery('Copiar configurações',
    'Copiar para este módulo as configurações do ID:', S) then
  begin
    X := StrToIntDef(S, -1);
    Y := CDSConfig.FieldByName(GetKeyField).AsInteger;

    if (not CDSModulos.IsEmpty) and (X > 0) and (Y > 0) and
      CDSModulos.Locate('ID', X, []) then
    begin
      SetLength(vValues, CDSConfig.FieldCount);
      for I := 0 to Pred(CDSConfig.FieldCount) do
      begin
        if PermiteCopiarField(CDSConfig.Fields[I]) then
          vValues[I] := CDSConfig.Fields[I].Value
        else
          vValues[I] := EmptyStr;
      end;

      if CDSModulos.Locate('ID', Y, []) then
      begin
        CDSConfig.Edit;
        for I := 1 to Pred(CDSConfig.FieldCount) do
        begin
          if PermiteCopiarField(CDSConfig.Fields[I]) then
            CDSConfig.Fields[I].Value := vValues[I];
        end;
        CDSConfig.Post;
      end;
    end;
  end;

end;

procedure TFrmBaseConfiguracoesSics.btnNovaConfigClick(Sender: TObject);
begin
  SaveData;
  CDSModulos.Append;
  CDSModulos.FieldByName('NOME').AsString := edtNovaConfig.Text;
  CDSModulos.FieldByName('ID').Value := dmSicsMain.GetID_MODULOS(GetTipoModulo);
  CDSModulos.FieldByName('TIPO').Value := Integer(GetTipoModulo);
  CDSModulos.Post;

  CDSConfig.Append;
  CDSConfig.FieldByName(GetKeyField).Value := CDSModulos.FieldByName('ID').Value;
  CDSConfig.Post;

  btnCancelar.OnClick(btnCancelar);
end;

procedure TFrmBaseConfiguracoesSics.edtNovaConfigChange(Sender: TObject);
begin
  btnNovaConfig.Enabled := Trim(edtNovaConfig.Text) <> '';
end;

procedure TFrmBaseConfiguracoesSics.btnCancelarClick(Sender: TObject);
begin
  edtNovaConfig.Clear;
  pnlNovaConfig.Visible := false;
end;

procedure TFrmBaseConfiguracoesSics.CancelData;
begin
  if (CDSModulos.State in [dsInsert, dsEdit]) then
    CDSModulos.Cancel;

  if (CDSConfig.State in [dsInsert, dsEdit]) then
    CDSConfig.Cancel;
end;

procedure TFrmBaseConfiguracoesSics.CancelUpdates;
begin
  CancelData;

  if CDSModulos.ChangeCount > 0 then
    CDSModulos.CancelUpdates;

  if CDSConfig.ChangeCount > 0 then
    CDSConfig.CancelUpdates;
end;

function TFrmBaseConfiguracoesSics.CarregaGrupos(const aEdit: TLabel;
  const aNomeGrupo: String; const aMultiSelect: boolean = True): Boolean;
begin
  Result := CarregaGrupos((aEdit.focusControl as TDBEdit), aNomeGrupo,
    aEdit.caption, aMultiSelect);
end;

function TFrmBaseConfiguracoesSics.CarregaGrupos(const aEdit: TDBEdit;
  const aNomeGrupo, aTitulo: String; const aMultiSelect: boolean = True): Boolean;
var
  LNovoValor: String;
begin
  LNovoValor := CarregarGrupos(dmSicsMain.connOnLine, aNomeGrupo,
    aEdit.Text, aTitulo, aMultiSelect);
  Result := (aEdit.Text <> LNovoValor);

  if Result then
  begin
    ModoEdicaoDataSet;
    aEdit.Field.Value := LNovoValor;
  end;
end;

procedure TFrmBaseConfiguracoesSics.edtNovaConfigKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    btnNovaConfigClick(Sender);
    Key := #0;
  end;
end;

class procedure TFrmBaseConfiguracoesSics.ExibeForm;
var
  aForm: TFrmBaseConfiguracoesSics;
begin
  aForm := Self.Create(Application);
  try
    aForm.ShowModal;
  finally
    FreeAndNil(aForm);
  end;
end;

procedure TFrmBaseConfiguracoesSics.grdModulosColEnter(Sender: TObject);
begin
  with grdModulos do
  begin
    if SelectedIndex = 0 then
      SelectedIndex := 1;

    if SelectedField.FieldName = 'ID' then
      Options := Options - [dgEditing]
    else
      Options := Options + [dgEditing];
  end;
end;

procedure TFrmBaseConfiguracoesSics.grdModulosExit(Sender: TObject);
begin
  with CDSModulos do
  begin
    if (State in [dsInsert, dsEdit]) then
    begin
      if (FieldByName('ID').AsString = '') then
      begin
        if (FieldByName('NOME').AsString <> '') then
        begin
          FieldByName('ID').Value := dmSicsMain.GetID_MODULOS(GetTipoModulo);
          FieldByName('TIPO').Value := Integer(GetTipoModulo);
          Post;

          CDSConfig.Append;
          CDSConfig.FieldByName(GetKeyField).Value := FieldByName('ID').Value;
          CDSConfig.Post;
        end
        else
          Delete;
      end;
    end;
  end;

end;

procedure TFrmBaseConfiguracoesSics.grdModulosTitleClick(Column: TColumn);
begin
  if not grdModulos.DataSource.DataSet.IsEmpty then
    TClientDataSet(grdModulos.DataSource.DataSet).IndexFieldNames :=
      Column.FieldName;
end;

procedure TFrmBaseConfiguracoesSics.HabilitaBotaoSalvar;
begin
  btnSalvar.Enabled := DataSetEditing(CDSConfig) or (CDSConfig.ChangeCount > 0)
    or DataSetEditing(CDSModulos) or (CDSModulos.ChangeCount > 0);
end;

procedure TFrmBaseConfiguracoesSics.HabilitaBotoes;
begin
  Exit;
end;

procedure TFrmBaseConfiguracoesSics.HabilitaBotoesModulos;
begin
  btnSicsExcluir.Enabled := (not CDSModulos.IsEmpty);
  btnSicsIncluir.Enabled := CDSModulos.Active;
  btnCopiar.Enabled := btnSicsExcluir.Enabled and (CDSModulos.RecordCount > 1);
end;

procedure TFrmBaseConfiguracoesSics.ModoEdicaoDataSet;
begin
  if (CDSConfig.Active and (not CDSConfig.IsEmpty) and
    (not(CDSConfig.State in [dsInsert, dsEdit]))) then
    CDSConfig.Edit;
end;

function TFrmBaseConfiguracoesSics.PermiteCopiarField
  (const aField: TField): Boolean;
begin
  Result := Assigned(aField) and (aField.FieldName <> GetKeyField);
end;

procedure TFrmBaseConfiguracoesSics.PrepareDataSet;
var
  aDataSetConfig: TClientDataSet;
begin
  CDSModulos.CloneCursor(GetDataSetModuloPrincipal, false, false);
  CDSModulos.Filtered := false;
  CDSModulos.Filter := Format('(TIPO = %d)', [Integer(GetTipoModulo)]);
  CDSModulos.Filtered := True;

  CDSModulos.IndexFieldNames := GetKeyField;
  aDataSetConfig := GetDataSetFormPrincipal;
  if not aDataSetConfig.Active then
    aDataSetConfig.Open;
  CDSConfig.CloneCursor(aDataSetConfig, false, false);
  CDSConfig.IndexFieldNames := GetKeyField;
  CDSConfig.MasterFields := 'ID';
  CDSConfig.MasterSource := dtsModulos;
end;

procedure TFrmBaseConfiguracoesSics.SaveData;
begin
  if (CDSModulos.State in [dsInsert, dsEdit]) then
    CDSModulos.Post;

  if (CDSConfig.State in [dsInsert, dsEdit]) then
    CDSConfig.Post;
end;

procedure TFrmBaseConfiguracoesSics.SaveUpdates;
begin
  FErrors := EmptyStr;

  SaveData;

  CDSModulos.ApplyUpdates(0);

  CDSConfig.ApplyUpdates(0);

  if (CDSModulos.ChangeCount > 0) or (CDSConfig.ChangeCount > 0) or (FErrors <> EmptyStr) then
  begin
    ShowMessage('Falha ao gravar: ' + sLineBreak + sLineBreak + FErrors.Trim);
    abort;
  end;
end;

procedure TFrmBaseConfiguracoesSics.SetDefaultConfig;
var
  I: Integer;
  LComponent: TComponent;
  LChecked: Boolean;

const
  BooleanStr: Array [Boolean] of Char = ('F', 'T');
begin
  for I := 0 to Pred(Self.ComponentCount) do
  begin
    LComponent := Self.Components[I];
    if Assigned(LComponent) and (LComponent is TDBCheckBox) then
    begin
      LChecked := (TDBCheckBox(LComponent).Parent = grpConfigTela);
      if Assigned(TDBCheckBox(LComponent).Field) then
        TDBCheckBox(LComponent).Field.AsString := BooleanStr[LChecked];
    end;
  end;
end;

procedure TFrmBaseConfiguracoesSics.SomenteNumeros(var Key: Char);
begin
  if not(Key in ['0' .. '9', ';', '-', #8, #3, #$16]) then
    Key := #0;
end;

procedure TFrmBaseConfiguracoesSics.VerificaSequenciaNumeros
  (var Sender: TObject);
var
  I: Integer;
  error: Boolean;
  valor: string;
  Edit: TDBEdit;
begin
  if not(Sender is TDBEdit) then
    Exit;
  error := false;
  Edit := TDBEdit(Sender);
  valor := Edit.Text;
  if (valor = '') then
    Exit;
  for I := 0 to Length(valor) do
  begin
    if (valor[I] = '-') then
    begin
      if ((not(valor[I - 1] in ['0' .. '9'])) or
        (not(valor[I + 1] in ['0' .. '9']))) then
      begin
        error := True;
      end;
    end;
    if (error) then
    begin
      ShowMessage('Sequência de números inválida!');
      Edit.Field.Value := '';
      Edit.SetFocus;
      Exit;
    end;
  end;
end;

function CarregarGrupos(Conexao: TFDConnection;
  const Tabela, pGrupos, aTitulo: string; const aMultiSelect: boolean = True): string;
var
  vExisteCampoAtivo, vExisteCampoID, vExisteCampoNome: Boolean;
  sFields: String;

  function GetFirstField(const aFieldsTypes: TFieldsTypes): String;
  var
    I: SmallInt;
  begin
    for I := 0 to FrmSelecaoGrupos.qryGrupos.Fields.Count - 1 do
    begin
      if FrmSelecaoGrupos.qryGrupos.Fields[I].DataType in aFieldsTypes then
      begin
        Result := FrmSelecaoGrupos.qryGrupos.Fields[I].FieldName;
        Break;
      end;
    end;
  end;

const
  Campo_ID = 'ID';
  Campo_Nome = 'NOME';
begin

  Result := pGrupos;

  FrmSelecaoGrupos := TFrmSelecaoGrupos.Create(nil);
  try
    with FrmSelecaoGrupos do
    begin
      FMultiSelect := aMultiSelect;
      qryGrupos.Connection := Conexao;

      cdsGrupos.Close;
      qryGrupos.Close;
      qryGrupos.SQL.Text := Format('SELECT * FROM %s WHERE 1 = 2', [Tabela]);
      qryGrupos.Open;

      vExisteCampoAtivo := Assigned(qryGrupos.FindField('ATIVO'));
      vExisteCampoID := Assigned(qryGrupos.FindField(Campo_ID));
      vExisteCampoNome := Assigned(qryGrupos.FindField(Campo_Nome));

      if vExisteCampoID then
        sFields := Campo_ID
      else
        if Tabela = 'PIS' then begin
          sFields := 'ID_PI AS ' + Campo_ID;
        end else begin
          sFields := GetFirstField([ftInteger, ftSmallint, ftAutoInc]) + ' AS '
            + Campo_ID;
        end;

      qryGrupos.SQL.Text := 'SELECT ' + sFields;
      if vExisteCampoNome then
        sFields := Campo_Nome
      else
        sFields := GetFirstField([ftString]) + ' AS ' + Campo_Nome;

      if (sFields <> '') then
        qryGrupos.SQL.Text := qryGrupos.SQL.Text + ',' + sFields;

      qryGrupos.SQL.Text := qryGrupos.SQL.Text + ' FROM ' + Tabela;

      if vExisteCampoAtivo then begin
        qryGrupos.SQL.Text := qryGrupos.SQL.Text + ' WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
          ' AND ATIVO = ''T''';
      end else begin
        qryGrupos.SQL.Text := qryGrupos.SQL.Text + ' WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString;
      end;

      qryGrupos.Open;
      cdsGrupos.Open;

      Grupos := pGrupos;
    end;
    FrmSelecaoGrupos.caption := aTitulo;
    if FrmSelecaoGrupos.ShowModal = mrOk then
    begin
      Result := FrmSelecaoGrupos.Grupos;
    end;

  finally
    FreeAndNil(FrmSelecaoGrupos);
  end;
end;

end.
