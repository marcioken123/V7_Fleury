unit uDataSetHelper;

interface

uses
  Datasnap.DBClient, FireDAC.Comp.Client, FireDAC.Stan.Param, System.Math;

type
  TClientDataSet = class(Datasnap.DBClient.TClientDataSet)
  protected
    procedure DoBeforeOpen; override;
    procedure DoBeforePost; override;
  end;

  TFDQuery = class(FireDAC.Comp.Client.TFDQuery)
  protected
    procedure DoBeforeOpen; override;
    procedure DoBeforePost; override;
  end;

function GetIDUnidade: Integer;

implementation

uses {$IFDEF FIREMONKEY} untCommonDMUnidades, UConexaoBD {$ELSE} sics_94 {$ENDIF};

function GetIDUnidade: Integer;
begin
  {$IFDEF FIREMONKEY}
    Result := IfThen(dmUnidades.ConfiguradoParaMultiUnidades, dmUnidades.UnidadeAtiva, TConexaoBD.IdUnidade);
  {$ELSE}
    Result := vgParametrosModulo.IdUnidade;
  {$ENDIF}
end;

{ TClientDataSet }

procedure TClientDataSet.DoBeforeOpen;
begin
  if Self.Params.FindParam('ID_UNIDADE') = nil then
  begin
    inherited;
    Exit;
  end;

  if (Self.ParamByName('ID_UNIDADE').AsInteger > 0) and (Self.ParamByName('ID_UNIDADE').AsInteger = GetIDUnidade) then
  begin
    { Mantem o valor da unidade informada }
  end else begin
    Self.ParamByName('ID_UNIDADE').AsInteger := GetIDUnidade;
  end;

  inherited;
end;

procedure TClientDataSet.DoBeforePost;
begin
  if Self.FindField('ID_UNIDADE') = nil then
  begin
    inherited;
    Exit;
  end;

  if (Self.FieldByName('ID_UNIDADE').AsInteger > 0) and (Self.FieldByName('ID_UNIDADE').AsInteger = GetIDUnidade) then
  begin
    { Mantem o valor da unidade informada }
  end else
  begin
    Self.FieldByName('ID_UNIDADE').AsInteger := GetIDUnidade;
  end;
  inherited;

end;

{ TFDQuery }

procedure TFDQuery.DoBeforeOpen;
begin
  if Self.DataSource <> nil then
  begin
    inherited;
    Exit;
  end;

  if Self.Params.FindParam('ID_UNIDADE') = nil then
  begin
    inherited;
    Exit;
  end;

  if (Self.ParamByName('ID_UNIDADE').AsInteger > 0) and (Self.ParamByName('ID_UNIDADE').AsInteger = GetIDUnidade) then
  begin
    { Mantem o valor da unidade informada }
  end else
  begin
    Self.ParamByName('ID_UNIDADE').AsInteger := GetIDUnidade;
  end;

  inherited;
end;

procedure TFDQuery.DoBeforePost;
begin
  if Self.FindField('ID_UNIDADE') = nil then
  begin
    inherited;
    Exit;
  end;

  if (Self.FieldByName('ID_UNIDADE').AsInteger > 0) and (Self.FieldByName('ID_UNIDADE').AsInteger = GetIDUnidade) then
  begin
    { Mantem o valor da unidade informada }
  end else
  begin
    Self.FieldByName('ID_UNIDADE').AsInteger := GetIDUnidade;
  end;

  inherited;
end;

end.
