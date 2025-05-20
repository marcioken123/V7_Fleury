unit ufrmParamsNiveisSLA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sics_94, Buttons, DBCtrls, DB, DBClient, MyDlls_DR,  ClassLibraryVCL,
  System.UITypes, uDataSetHelper;

type
  TfrmSicsParamsNiveisSLA = class(TForm)
    Label7: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Bevel1: TBevel;
    edtSLAPPAmareloHora: TEdit;
    edtSLAPPAmareloMin: TEdit;
    edtSLAPPAmareloSeg: TEdit;
    edtSLAPPVermelhoHora: TEdit;
    edtSLAPPVermelhoMin: TEdit;
    edtSLAPPVermelhoSeg: TEdit;
    btnOk: TBitBtn;
    btnCancela: TBitBtn;
    dblkpPerfis: TDBLookupComboBox;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    dtsPerfis: TDataSource;
    cdsPerfisClone: TClientDataSet;
    Bevel3: TBevel;
    cdsPerfis: TClientDataSet;
    cdsPerfisID: TIntegerField;
    cdsPerfisNOME: TStringField;
    cdsPerfisPP_AMARELO: TIntegerField;
    cdsPerfisPP_VERMELHO: TIntegerField;
    cdsPerfisINTCALC_ACABOU_CRIAR: TBooleanField;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure cdsPerfisAfterOpen(DataSet: TDataSet);
    procedure SpeedButton4Click(Sender: TObject);
    procedure dblkpPerfisClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure cdsPerfisAfterPost(DataSet: TDataSet);
    procedure cdsPerfisAfterDelete(DataSet: TDataSet);
    procedure btnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPathPerfis: string;
    procedure CriarPerfil;
    procedure SalvarPerfil;
    procedure CarregarPerfil;
    procedure ExcluirPerfil;
    function  EditsToSegundos(EditHoras, EditMinutos, EditSegundos: TEdit): Integer;
    procedure SegundosToEdits(Segundos: Integer; EditHoras, EditMinutos, EditSegundos: TEdit);
  public
    class function Exibir(var ParamsSLA: TParamsNiveisSla; var UltimoPerfil: Variant): Boolean;
  end;

implementation

uses DateUtils;

{$R *.dfm}

{ TfrmParamsGraficoSLA }

class function TfrmSicsParamsNiveisSLA.Exibir(var ParamsSLA: TParamsNiveisSla; var UltimoPerfil: Variant): Boolean;
begin
  with TfrmSicsParamsNiveisSLA.Create(Application) do
  try
    // pegando o primeiro perfil caso nao tenha escolhido ainda
    if UltimoPerfil = Null then
      UltimoPerfil := cdsPerfis.FieldByName('ID').Value;

    if UltimoPerfil <> Null then
      if cdsPerfis.Locate('ID', UltimoPerfil, []) then
      begin
        dblkpPerfis.KeyValue := UltimoPerfil;
        CarregarPerfil;
      end;

    Result := ShowModal = mrOk;

    if Result then
    begin
      with ParamsSla do
      begin
        Amarelo  := EditsToSegundos(edtSLAPPAmareloHora , edtSLAPPAmareloMin , edtSLAPPAmareloSeg );
        Vermelho := EditsToSegundos(edtSLAPPVermelhoHora, edtSLAPPVermelhoMin, edtSLAPPVermelhoSeg);
      end;
      UltimoPerfil := dblkpPerfis.KeyValue;
    end;
  finally
    Release;
  end;
end;

function TfrmSicsParamsNiveisSLA.EditsToSegundos(EditHoras, EditMinutos, EditSegundos: TEdit): Integer;
begin
  Result := (StrToInt(EditHoras.Text) * 60 * 60) + (StrtoInt(EditMinutos.Text) * 60) + StrToInt(EditSegundos.Text);
end;

procedure TfrmSicsParamsNiveisSLA.SegundosToEdits(Segundos: Integer; EditHoras, EditMinutos, EditSegundos: TEdit);
var
  wHoras, wMinutos, wSegundos, wMSec: Word;
begin
  DecodeTime(IncSecond(0, Segundos), wHoras, wMinutos, wSegundos, wMSec);
  EditHoras.Text := Format('%2.2d', [wHoras]);
  EditMinutos.Text := Format('%2.2d', [wMinutos]);
  EditSegundos.Text := Format('%2.2d', [wSegundos]);
end;

procedure TfrmSicsParamsNiveisSLA.FormCreate(Sender: TObject);
begin
  FPathPerfis := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'slaperfisPP.dat';

  cdsPerfis.CreateDataSet;

  if FileExists(FPathPerfis) then
    cdsPerfis.LoadFromFile(FPathPerfis);

  CarregarPerfil;

  LoadPosition (Sender as TForm);
end;

procedure TfrmSicsParamsNiveisSLA.SpeedButton3Click(Sender: TObject);
begin
  //SalvarPerfil;
  CriarPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.cdsPerfisAfterOpen(DataSet: TDataSet);
begin
  cdsPerfisClone.CloneCursor(cdsPerfis, True);
end;

procedure TfrmSicsParamsNiveisSLA.SpeedButton4Click(Sender: TObject);
begin
  SalvarPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.SalvarPerfil;
begin
  if dblkpPerfis.KeyValue = Null then Exit;

  with cdsPerfis do
  begin
    Locate('ID', dblkpPerfis.KeyValue, []);
    Edit;
    FieldByName('PP_AMARELO').AsInteger := EditsToSegundos(edtSLAPPAmareloHora, edtSLAPPAmareloMin, edtSLAPPAmareloSeg);
    FieldByName('PP_VERMELHO').AsInteger := EditsToSegundos(edtSLAPPVermelhoHora, edtSLAPPVermelhoMin, edtSLAPPVermelhoSeg);
    FieldByName('INTCALC_ACABOU_CRIAR').AsBoolean := False;
    Post;
  end;
end;

procedure TfrmSicsParamsNiveisSLA.CarregarPerfil;
var
  iPPAmarelo, iPPVermelho : Integer;
begin
  with cdsPerfis do
  begin
    if Locate('ID', dblkpPerfis.KeyValue, []) then
    begin
      iPPAmarelo := FieldByName('PP_AMARELO').AsInteger;
      iPPVermelho := FieldByName('PP_VERMELHO').AsInteger;
    end
    else
    begin
      iPPAmarelo := 0;
      iPPVermelho := 0;
    end;
    SegundosToEdits(iPPAmarelo, edtSLAPPAmareloHora, edtSLAPPAmareloMin, edtSLAPPAmareloSeg);
    SegundosToEdits(iPPVermelho, edtSLAPPVermelhoHora, edtSLAPPVermelhoMin, edtSLAPPVermelhoSeg);
  end;
end;

procedure TfrmSicsParamsNiveisSLA.dblkpPerfisClick(Sender: TObject);
begin
  CarregarPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.SpeedButton5Click(Sender: TObject);
begin
  if (dblkpPerfis.KeyValue <> Null) and
    (MessageDlg('Confirma a exclusão deste perfil?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    ExcluirPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.ExcluirPerfil;
begin
  cdsPerfis.Delete;
  dblkpPerfis.KeyValue := Null;
  CarregarPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.CriarPerfil;
var
  sNome: string;
begin
  if InputQuery('Criando novo perfil', 'Informe o nome do perfil', sNome) then
  begin
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

    dblkpPerfis.KeyValue := cdsPerfis.FieldByName('ID').Value;

    CarregarPerfil;
  end;
end;

procedure TfrmSicsParamsNiveisSLA.cdsPerfisAfterPost(DataSet: TDataSet);
begin
  cdsPerfis.SaveToFile(FPathPerfis);
end;

procedure TfrmSicsParamsNiveisSLA.cdsPerfisAfterDelete(DataSet: TDataSet);
begin
  cdsPerfis.SaveToFile(FPathPerfis);
end;

procedure TfrmSicsParamsNiveisSLA.btnOkClick(Sender: TObject);
begin
  if (cdsPerfis.Locate('ID', dblkpPerfis.KeyValue, []))
    and (cdsPerfis.FieldByName('INTCALC_ACABOU_CRIAR').AsBoolean) then
      SalvarPerfil;
end;

procedure TfrmSicsParamsNiveisSLA.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
end;

end.
