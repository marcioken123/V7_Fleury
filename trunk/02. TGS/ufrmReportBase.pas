unit ufrmReportBase;
//Renomeado unit ufrmSicsReportBase

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, untMainForm,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope,
  untCommonFrameBase,MyAspFuncoesUteis,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, untCommonFormBase,
  FMX.Effects;

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmReportBase = class(TFrameBase)
  protected
    FHeightqrgrpUnidade: Integer;
    FPreecheuTagsCdsEventos: Boolean;

    procedure ConstroiSql; Virtual; Abstract;
    function  ConstroiDeleteSql : boolean; Virtual; Abstract;
    function  CreateCsvFile (FileName : string) : boolean; Virtual; Abstract;
    procedure PreencherTagsCdsEventos; Virtual; Abstract;
  public
	  constructor Create(aOwer: TComponent); Override;
    function ValidacaoAtivaModoConectado: Boolean; Override;
  end;

 implementation

 {$R *.fmx}

uses Sics_Common_Parametros;
 { TfrmReportBase }

constructor TfrmReportBase.Create(aOwer: TComponent);
begin
  inherited;
end;

function TfrmReportBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := cNaoPossuiConexaoDiretoDB;
end;

end.
