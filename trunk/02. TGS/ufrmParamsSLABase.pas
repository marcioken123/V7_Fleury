unit ufrmParamsSLABase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls,FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,


  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis,
  untCommonFormBase, IniFiles, FMX.Controls.Presentation,
  Datasnap.DBClient, System.ImageList, FMX.ImgList, FMX.Effects;

type
  TfrmParamsSLABase = class(TFrmBase)
    btnSalvarPerfil: TButton;
    btnExcluirPerfil: TButton;
    btnCriarPerfil: TButton;
    dblkpPerfis: TComboBox;
    Label1: TLabel;
    cdsPerfis: TClientDataSet;
    cdsPerfisID: TIntegerField;
    cdsPerfisNOME: TStringField;
    cdsPerfisINTCALC_ACABOU_CRIAR: TBooleanField;
    dtsPerfis: TDataSource;
    cdsPerfisClone: TClientDataSet;
    Layout1: TLayout;
    btnOk: TButton;
    btnCancela: TButton;
    ilIcones: TImageList;
    rect2: TRectangle;
    rect1: TRectangle;
    Layout2: TLayout;

    procedure btnExcluirPerfilClick(Sender: TObject);
    procedure btnCriarPerfilClick(Sender: TObject);
    procedure btnSalvarPerfilClick(Sender: TObject);
    procedure cdsPerfisAfterOpen(DataSet: TDataSet);
    procedure cdsPerfisAfterPost(DataSet: TDataSet);
    procedure cdsPerfisAfterDelete(DataSet: TDataSet);
    procedure btnOkClick(Sender: TObject);
    procedure dblkpPerfisChange(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
  protected
    FPathPerfis: string;
    procedure SalvarAlteracoesPerfil; Virtual;
    procedure HabilitaBotoes; Virtual;
    procedure CriarPerfil; Virtual;
    procedure LoadComboBoxPerfil; Virtual;
    procedure SalvarPerfil; Virtual; abstract;
    procedure CarregarPerfil; Virtual; abstract;
    procedure ExcluirPerfil; Virtual;
    function  EditsToSegundos(EditHoras, EditMinutos, EditSegundos: TEdit): Integer; Virtual;
    procedure SegundosToEdits(Segundos: Integer; EditHoras, EditMinutos, EditSegundos: TEdit); Virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function ValidacaoAtivaModoConectado: Boolean; Override;

  end;


implementation
uses DateUtils;

{$R *.fmx}
{ TfrmParamsSLABase }

procedure TfrmParamsSLABase.btnCancelaClick(Sender: TObject);
begin
  inherited;
//  Close;
end;

procedure TfrmParamsSLABase.btnCriarPerfilClick(Sender: TObject);
begin
  //SalvarPerfil;
  CriarPerfil;
end;

procedure TfrmParamsSLABase.btnExcluirPerfilClick(Sender: TObject);
var
  LOldRecno: Integer;
begin
  if (dblkpPerfis.ItemIndex <> -1) then
  begin
    LOldRecno := dtsPerfis.DataSet.RecNo;
    ConfirmationMessage('Confirma a exclusão deste perfil?',
      procedure (const aOK: Boolean)
      begin
        if aOK then
        begin
          if (LOldRecno = dtsPerfis.DataSet.RecNo) then
            ExcluirPerfil
          else
            ErrorMessage(Format('Contexto foi alterado. Registro de %d para %d.', [LOldRecno, dtsPerfis.DataSet.RecNo]));
        end;
      end);
  end;
end;

procedure TfrmParamsSLABase.btnOkClick(Sender: TObject);
begin
  if (cdsPerfis.Locate('ID', dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName], [])) then
      SalvarPerfil;
  cdsPerfis.MergeChangeLog;
  Close;
end;

procedure TfrmParamsSLABase.btnSalvarPerfilClick(Sender: TObject);
begin
  SalvarPerfil;
end;

procedure TfrmParamsSLABase.cdsPerfisAfterDelete(DataSet: TDataSet);
begin
  SalvarAlteracoesPerfil;
end;

procedure TfrmParamsSLABase.cdsPerfisAfterOpen(DataSet: TDataSet);
begin
  cdsPerfisClone.CloneCursor(cdsPerfis, True);
  LoadComboBoxPerfil;
end;

procedure TfrmParamsSLABase.cdsPerfisAfterPost(DataSet: TDataSet);
begin
  SalvarAlteracoesPerfil;
end;

procedure TfrmParamsSLABase.dblkpPerfisChange(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
  CarregarPerfil;
end;

function TfrmParamsSLABase.EditsToSegundos(EditHoras, EditMinutos,
  EditSegundos: TEdit): Integer;
begin
  Result := (StrToInt(EditHoras.Text) * 60 * 60) + (StrtoInt(EditMinutos.Text) * 60) + StrToInt(EditSegundos.Text);
end;

procedure TfrmParamsSLABase.ExcluirPerfil;
begin
  cdsPerfis.Delete;
  dblkpPerfis.ItemIndex := -1;
  CarregarPerfil;
end;

procedure TfrmParamsSLABase.HabilitaBotoes;
begin
  btnSalvarPerfil.Enabled := dblkpPerfis.ItemIndex > -1;
  btnOk.Enabled := (btnSalvarPerfil.Enabled or (cdsPerfis.ChangeCount > 0));
  btnExcluirPerfil.Enabled := btnSalvarPerfil.Enabled;
end;

procedure TfrmParamsSLABase.LoadComboBoxPerfil;
begin
  dblkpPerfis.Import(cdsPerfis, cdsPerfisNOME.FieldName);
  HabilitaBotoes;
end;

procedure TfrmParamsSLABase.SalvarAlteracoesPerfil;
begin
  cdsPerfis.SaveToFile(FPathPerfis);
  LoadComboBoxPerfil;
end;


constructor TfrmParamsSLABase.Create(AOwner: TComponent);
begin
  inherited;


  cdsPerfis.CreateDataSet;
  if FileExists(FPathPerfis) then
    cdsPerfis.LoadFromFile(FPathPerfis);
  cdsPerfis.MergeChangeLog;
  cdsPerfis.CancelUpdates;

  CarregarPerfil;
  HabilitaBotoes;
end;

procedure TfrmParamsSLABase.CriarPerfil;
var
  LValoresDefault: array of string;
  LCurrentIndexPerfil: Integer;
begin
  SetLength(LValoresDefault, 1);
  LValoresDefault[0] := '';
  LCurrentIndexPerfil := dblkpPerfis.ItemIndex;
  InputQuery('Criando novo perfil', ['Informe o nome do perfil'], LValoresDefault,
    procedure(const AResult: TModalResult; const AValues: array of string)
    var
      sNome: string;
    begin
      if (AResult = mrOk) then
      begin
        sNome := '';
        if (Length(AValues) = 1) then
          sNome := AValues[0];

        if (LCurrentIndexPerfil <> dblkpPerfis.ItemIndex)   then
          raise Exception.Create('Contexto do perfil foi alterado.');

        if Trim(sNome) = '' then
          raise Exception.Create('Nome não informado');

        if cdsPerfis.Locate('NOME', sNome, []) then
          raise Exception.Create('Perfil já existente');

        cdsPerfisClone.IndexFieldNames := 'ID';
        cdsPerfisClone.Last;

        cdsPerfis.Append;
        cdsPerfis.FieldByName('ID').AsInteger := cdsPerfisClone.FieldByName('ID').AsInteger + 1;
        cdsPerfis.FieldByName('NOME').AsString := sNome;
        cdsPerfis.FieldByName('INTCALC_ACABOU_CRIAR').AsBoolean := True;
        cdsPerfis.Post;

        dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName] := cdsPerfis.FieldByName('ID').Value;

        CarregarPerfil;
      end;
    end);
end;

procedure TfrmParamsSLABase.SegundosToEdits(Segundos: Integer; EditHoras,
  EditMinutos, EditSegundos: TEdit);
var
  wHoras, wMinutos, wSegundos, wMSec: Word;
begin
  DecodeTime(IncSecond(0, Segundos), wHoras, wMinutos, wSegundos, wMSec);
  EditHoras.Text := Format('%2.2d', [wHoras]);
  EditMinutos.Text := Format('%2.2d', [wMinutos]);
  EditSegundos.Text := Format('%2.2d', [wSegundos]);
end;

function TfrmParamsSLABase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := False; //Não utiliza DB somente arquivo local ini
end;

end.
