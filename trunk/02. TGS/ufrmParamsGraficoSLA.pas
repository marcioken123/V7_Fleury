unit ufrmParamsGraficoSLA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls,  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,


  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis, ufrmParamsSLABase,
  IniFiles, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Effects;

type
  TProcParametrosSQL = reference to procedure (EspAmarelo, EspVermelho, AtdAmarelo, AtdVermelho: Integer; UltimoPerfil: Variant);

  TfrmSicsParamsGraficoSLA = class(TfrmParamsSLABase)
    cdsPerfisESP_AMARELO: TIntegerField;
    cdsPerfisESP_VERMELHO: TIntegerField;
    cdsPerfisATD_AMARELO: TIntegerField;
    cdsPerfisATD_VERMELHO: TIntegerField;
    Label18: TLabel;
    edtSLAEspVermelhoHora: TEdit;
    edtSLAEspVermelhoMin: TEdit;
    edtSLAEspVermelhoSeg: TEdit;
    edtSLAEspAmareloSeg: TEdit;
    Label14: TLabel;
    edtSLAEspAmareloMin: TEdit;
    Label13: TLabel;
    edtSLAEspAmareloHora: TEdit;
    Label15: TLabel;
    Label23: TLabel;
    Label22: TLabel;
    Label16: TLabel;
    Label24: TLabel;
    Label21: TLabel;
    edtSLAAtdAmareloHora: TEdit;
    Label19: TLabel;
    edtSLAAtdAmareloSeg: TEdit;
    Label20: TLabel;
    edtSLAAtdAmareloMin: TEdit;
    edtSLAAtdVermelhoMin: TEdit;
    edtSLAAtdVermelhoSeg: TEdit;
    edtSLAAtdVermelhoHora: TEdit;
    Label17: TLabel;
    rectEspera: TRectangle;
    rectTituloEspera: TRectangle;
    lblTituloEspera: TLabel;
    img1: TImage;
    img2: TImage;
    rectAtendimento: TRectangle;
    Rectangle2: TRectangle;
    Label8: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
  protected
    procedure SalvarPerfil; Override;
    procedure HabilitaBotoes; Override;
    procedure CarregarPerfil; Override;
  public
    constructor Create(AOwner: TComponent); override;
    class procedure Exibir(aOwner: TComponent; const aIDUnidade: Integer; aProcParametrosSLA: TProcParametrosSQL; const UltimoPerfil: Variant); reintroduce; virtual;
  end;

implementation

uses DateUtils;

{$R *.fmx}

{ TfrmParamsGraficoSLA }

class procedure TfrmSicsParamsGraficoSLA.Exibir(aOwner: TComponent; const aIDUnidade: Integer; aProcParametrosSLA: TProcParametrosSQL; const UltimoPerfil: Variant);
var	
  LfrmSicsParamsGraficoSLA: TfrmSicsParamsGraficoSLA;
  LUltimoPerfil: Variant;
begin
  LfrmSicsParamsGraficoSLA := TfrmSicsParamsGraficoSLA.Create(aOwner,aIDUnidade);

  try
    with LfrmSicsParamsGraficoSLA do
    begin
      LUltimoPerfil := UltimoPerfil;
      // pegando o primeiro perfil caso nao tenha escolhido ainda
      if LUltimoPerfil = null then
        LUltimoPerfil := cdsPerfis.FieldByName('ID').Value;

      if LUltimoPerfil <> null then
      if cdsPerfis.Locate('ID', LUltimoPerfil, []) then
      begin
        dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName] := LUltimoPerfil;
        CarregarPerfil;
      end;
      LfrmSicsParamsGraficoSLA.ShowModal(
        procedure (aModalResult: TModalResult)
        begin
          if (aModalResult = mrOk) then
          begin
            if Assigned(aProcParametrosSLA) then
              aProcParametrosSLA(
                cdsPerfis.FieldByName('ESP_AMARELO').AsInteger,
                cdsPerfis.FieldByName('ESP_VERMELHO').AsInteger,
                cdsPerfis.FieldByName('ATD_AMARELO').AsInteger,
                cdsPerfis.FieldByName('ATD_VERMELHO').AsInteger,
                dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName]);
          end;
          LfrmSicsParamsGraficoSLA := nil;
        end);
    end;
  except
    FreeAndNIl(LfrmSicsParamsGraficoSLA);
	  raise;
  end;
end;

procedure TfrmSicsParamsGraficoSLA.HabilitaBotoes;
begin
  inherited;
  rectEspera.Enabled := btnSalvarPerfil.Enabled;
  rectAtendimento.Enabled := btnSalvarPerfil.Enabled;
  if(not rectEspera.Enabled)then
  begin
    edtSLAEspVermelhoHora.Text := '00';
    edtSLAEspVermelhoMin.Text := '00';
    edtSLAEspVermelhoSeg.Text := '00';
    edtSLAEspAmareloSeg.Text := '00';
    edtSLAEspAmareloMin.Text := '00';
    edtSLAEspAmareloHora.Text :='00';

    edtSLAAtdVermelhoHora.Text := '00';
    edtSLAAtdVermelhoMin.Text := '00';
    edtSLAAtdVermelhoSeg.Text := '00';
    edtSLAAtdAmareloSeg.Text := '00';
    edtSLAAtdAmareloMin.Text := '00';
    edtSLAAtdAmareloHora.Text :='00';


  end;
end;

procedure TfrmSicsParamsGraficoSLA.SalvarPerfil;
begin
  if (dblkpPerfis.ItemIndex = -1) then Exit;

  with cdsPerfis do
  begin
   // Filtered := False;
  //  Filter := 'ID = ' + VarToStr(dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName]);
  //  Filtered := True;
    if Locate('ID', dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName], []) then
    //if(not Eof)then
    begin
      Edit;
      FieldByName('ESP_AMARELO').AsInteger := EditsToSegundos(edtSLAEspAmareloHora, edtSLAEspAmareloMin, edtSLAEspAmareloSeg);
      FieldByName('ESP_VERMELHO').AsInteger := EditsToSegundos(edtSLAEspVermelhoHora, edtSLAEspVermelhoMin, edtSLAEspVermelhoSeg);
      FieldByName('ATD_AMARELO').AsInteger := EditsToSegundos(edtSLAAtdAmareloHora, edtSLAAtdAmareloMin, edtSLAAtdAmareloSeg);
      FieldByName('ATD_VERMELHO').AsInteger := EditsToSegundos(edtSLAAtdVermelhoHora, edtSLAAtdVermelhoMin, edtSLAAtdVermelhoSeg);
      FieldByName('INTCALC_ACABOU_CRIAR').AsBoolean := False;
      Post;
    end;
  end;
end;

procedure TfrmSicsParamsGraficoSLA.btnCancelaClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfrmSicsParamsGraficoSLA.btnOkClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfrmSicsParamsGraficoSLA.CarregarPerfil;
var
  iEspAmarelo, iEspVermelho, iAtdAmarelo, iAtdVermelho: Integer;
begin
  if(dblkpPerfis.ItemIndex = -1)then
    exit;
  with cdsPerfis do
  begin
   // Filtered := false;
   // Filter := 'ID = ' + VarToStr(dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName]);
   // Filtered := True;
    if Locate('ID', dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName], []) then
    //if(not Eof)then
    begin
      iEspAmarelo := FieldByName('ESP_AMARELO').AsInteger;
      iEspVermelho := FieldByName('ESP_VERMELHO').AsInteger;
      iAtdAmarelo := FieldByName('ATD_AMARELO').AsInteger;
      iAtdVermelho := FieldByName('ATD_VERMELHO').AsInteger;
    end
    else
    begin
      iEspAmarelo := 0;
      iEspVermelho := 0;
      iAtdAmarelo := 0;
      iAtdVermelho := 0;
    end;
    SegundosToEdits(iEspAmarelo, edtSLAEspAmareloHora, edtSLAEspAmareloMin, edtSLAEspAmareloSeg);
    SegundosToEdits(iEspVermelho, edtSLAEspVermelhoHora, edtSLAEspVermelhoMin, edtSLAEspVermelhoSeg);
    SegundosToEdits(iAtdAmarelo, edtSLAAtdAmareloHora, edtSLAAtdAmareloMin, edtSLAAtdAmareloSeg);
    SegundosToEdits(iAtdVermelho, edtSLAAtdVermelhoHora, edtSLAAtdVermelhoMin, edtSLAAtdVermelhoSeg);
  end;
end;

constructor TfrmSicsParamsGraficoSLA.Create(AOwner: TComponent);
begin
  FPathPerfis := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'slaperfis.dat';
  inherited;

end;

end.
