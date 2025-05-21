unit ufrmParamsNiveisSLA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl, System.UITypes,
  System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis, IniFiles, ufrmParamsSLABase, FMX.Controls.Presentation, FMX.EditBox, FMX.SpinBox,
  System.ImageList, FMX.ImgList, FMX.Effects;

type
  TProcParamsNiveisSla = reference to procedure (const Amarelo, Vermelho: integer; UltimoPerfil: Variant);

  TfrmSicsParamsNiveisSLA = class(TfrmParamsSLABase)
    StyleBook1: TStyleBook;
    cdsPerfisPP_AMARELO: TIntegerField;
    cdsPerfisPP_VERMELHO: TIntegerField;
    Label18: TLabel;
    Label15: TLabel;
    edtSLAPPAmareloHora: TEdit;
    edtSLAPPVermelhoHora: TEdit;
    edtSLAPPAmareloSeg: TEdit;
    edtSLAPPAmareloMin: TEdit;
    edtSLAPPVermelhoMin: TEdit;
    edtSLAPPVermelhoSeg: TEdit;
    Label17: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    rectNiveisSeparacaoSLA: TRectangle;
    rectTituloEspera: TRectangle;
    lblTituloEspera: TLabel;
    img1: TImage;
    img2: TImage;
  protected
    procedure SalvarPerfil; Override;
    procedure CarregarPerfil; Override;
    procedure HabilitaBotoes; Override;
  public
    constructor Create(AOwner: TComponent); override;
    class procedure Exibir(aOwner: TComponent; const aIDUnidade: Integer; const aProcParamsNiveisSla: TProcParamsNiveisSla; const UltimoPerfil: Variant); reintroduce; Virtual;
  end;

implementation

uses DateUtils;

{$R *.fmx}

{ TfrmParamsGraficoSLA }

constructor TfrmSicsParamsNiveisSLA.Create(AOwner: TComponent);
begin
  FPathPerfis := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'slaperfisPP.dat';
  inherited;
end;

class procedure TfrmSicsParamsNiveisSLA.Exibir(aOwner: TComponent; const aIDUnidade: Integer; const aProcParamsNiveisSla: TProcParamsNiveisSla; const UltimoPerfil: Variant);
var
  LfrmSicsParamsNiveisSLA: TfrmSicsParamsNiveisSLA;
  LUltimoPerfil: Variant;
begin
  LfrmSicsParamsNiveisSLA := TfrmSicsParamsNiveisSLA.Create(aOwner, aIDUnidade);
  try
    with LfrmSicsParamsNiveisSLA do
    begin
      LUltimoPerfil := UltimoPerfil;
      // pegando o primeiro perfil caso nao tenha escolhido ainda
      if (LUltimoPerfil = null) then
        LUltimoPerfil := cdsPerfis.FieldByName('ID').Value;

      if LUltimoPerfil <> null then
      begin
        if cdsPerfis.Locate('ID', LUltimoPerfil, []) then
        begin
          dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName] := LUltimoPerfil;
          CarregarPerfil;
        end;
      end;
      LfrmSicsParamsNiveisSLA.ShowModal(
        procedure (aModalResult: TModalResult)
        begin
            if (aModalResult = mrOk) then
            begin
              if Assigned(aProcParamsNiveisSla) then
              begin
//                aProcParamsNiveisSla(
//                  EditsToSegundos(edtSLAPPAmareloHora , edtSLAPPAmareloMin , edtSLAPPAmareloSeg),
//                  EditsToSegundos(edtSLAPPVermelhoHora, edtSLAPPVermelhoMin, edtSLAPPVermelhoSeg),
//                  dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName]);

                aProcParamsNiveisSla(
                   cdsPerfis.FieldByName('PP_AMARELO').AsInteger,
                   cdsPerfis.FieldByName('PP_VERMELHO').AsInteger,
                  dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName]);
              end;
            end;
          LfrmSicsParamsNiveisSLA := nil;
        end);
    end;
  except
    FreeAndNil(LfrmSicsParamsNiveisSLA);
    raise;
  end;
end;

procedure TfrmSicsParamsNiveisSLA.HabilitaBotoes;
begin
  inherited;
  rectNiveisSeparacaoSLA.Enabled := btnSalvarPerfil.Enabled;

  if(not rectNiveisSeparacaoSLA.Enabled)then
  begin
    edtSLAPPVermelhoHora.Text := '00';
    edtSLAPPVermelhoMin.Text := '00';
    edtSLAPPVermelhoSeg.Text := '00';
    edtSLAPPAmareloSeg.Text := '00';
    edtSLAPPAmareloMin.Text := '00';
    edtSLAPPAmareloHora.Text :='00';
  end;
end;

procedure TfrmSicsParamsNiveisSLA.SalvarPerfil;
begin
  if dblkpPerfis.ItemIndex = -1 then Exit;

  with cdsPerfis do
  begin
    if Locate('ID', dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName], []) then
    begin
      Edit;
      FieldByName('PP_AMARELO').AsInteger := EditsToSegundos(edtSLAPPAmareloHora, edtSLAPPAmareloMin, edtSLAPPAmareloSeg);
      FieldByName('PP_VERMELHO').AsInteger := EditsToSegundos(edtSLAPPVermelhoHora, edtSLAPPVermelhoMin, edtSLAPPVermelhoSeg);
      FieldByName('INTCALC_ACABOU_CRIAR').AsBoolean := False;
      Post;
    end;
  end;
end;

procedure TfrmSicsParamsNiveisSLA.CarregarPerfil;
var
  iPPAmarelo, iPPVermelho : Integer;
begin
  with cdsPerfis do
  begin
    if Locate('ID', dblkpPerfis.KeyValue[cdsPerfis, cdsPerfisID.FieldName], []) then
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

end.
