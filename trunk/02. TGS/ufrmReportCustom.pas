unit ufrmReportCustom;
//Renomeado unit sics_95;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, System.DateUtils, untMainForm, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, System.UIConsts, System.Generics.Defaults,
  System.Generics.Collections, System.UITypes, System.Types, System.SysUtils,
  System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  MyAspFuncoesUteis, Sics_Common_Splash, IniFiles, Data.FMTBcd,
  Datasnap.Provider, untCommonFormBase, FMX.Menus, ufrmReportBase,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Effects,
  FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

const
//CANEXCLUDE : boolean = true;
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0'#13'10/03/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 2.0 Rev. A'#13'01/10/02';
//VERSAODBASE = 'Base de dados:'#13'Versão 3.0'#13'18/09/03';
  VERSAODBASE = 'Base de dados:'#13'Versão 3.1'#13'30/01/06';

type
  TfrmSicsReportCustom = class(TfrmReportBase)
    dsEventos: TDataSource;
    MainGrid: TGrid;
    MainMenu1: TMenuBar;
    ShortcutsMenu: TMenuItem;
    MenuPrint: TMenuItem;
    qryEventos: TFDQuery;
    cdsEventos: TClientDataSet;
    qryTabelasUnidades: TFDQuery;
    cdsEventosTmp: TClientDataSet;
    dspEventosTmp: TDataSetProvider;
    qryGetTagsTicket: TFDQuery;
    lytRodape: TLayout;
    FecharButton: TButton;
    ExportBtn: TButton;
    RecordsLabel: TLabel;
    Label1: TLabel;
    chkMostrarTipoSenha: TCheckBox;
    chkMostrarNomeDosClientes: TCheckBox;
    chkMostrarTags: TCheckBox;
    ProgressBar1: TProgressBar;
    bndEventos: TBindSourceDB;
    dtsMain: TDataSource;
    LinkGridEventos: TLinkGridToDataSource;
    PrintPreviewButton: TButton;
    procedure PrintPreviewButtonClick(Sender: TObject);
    procedure FecharButtonClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure cdsAddEventoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsEventosAfterOpen(DataSet: TDataSet);
    procedure cdsEventosDURACAO_SEGUNDOSGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure chkMostrarTagsChange(Sender: TObject);
    procedure chkMostrarTipoSenhaChange(Sender: TObject);
    procedure chkMostrarNomeDosClientesChange(Sender: TObject);
    procedure dsEventosDataChange(Sender: TObject; Field: TField);
    procedure dtsMainStateChange(Sender: TObject);
    procedure cdsEventosBeforeOpen(DataSet: TDataSet);
  protected
    function  ConstroiDeleteSql : boolean; Override;
    function  CreateCsvFile (FileName : string) : boolean; Override;
    procedure PreencherTagsCdsEventos; Override;
    procedure AtualizaQtdeRegistros; virtual;
    procedure UpdateColunasGrid; virtual;
    procedure SetVisible(const aVisible: Boolean); Override;
  public
    ExportDialog: TSaveDialog;
	  constructor Create(aOwer: TComponent); Override;
    destructor Destroy; Override;
  end;


//procedure ExcludeRecords;


implementation

{$R *.fmx}

uses
  {$IFDEF SuportaQuickRep}
  repDetail,
  repPrview,
  {$ENDIF SuportaQuickRep}
   Sics_Common_Parametros, untCommonFrameBase, ufrmPesquisaRelatorioBase, untCommonDMClient, untCommonDMConnection,
  untCommonDMUnidades;




{--------------------------------------------------}

constructor TfrmSicsReportCustom.Create(aOwer: TComponent);
begin
  inherited;
  FPreecheuTagsCdsEventos := False;
  qryEventos.Connection := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR).connRelatorio;
  qryGetTagsTicket.Connection := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR).connRelatorio;

  ExportDialog := TSaveDialog.Create(Self);
  ExportDialog.DefaultExt := 'cvs';
  ExportDialog.Filter :=
      'Campos separados por v'#237'rgula (*.csv)|*.csv|Arquivos texto (*.txt' +
      ')|*.txt|Todos os arquivos (*.*)|*.*';
  ExportDialog.Options := [TOpenOption.ofOverwritePrompt, TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist];
  ExportDialog.Title := 'Exportar dados para arquivo';
  // por ser um processo LENTO, melhor desligar SEMPRE e
  // deixar o usuario clicar manualmente
  chkMostrarTags.IsChecked := False;
end;

function ExtractOR (const s : string) : string;
begin
   Result := Copy(s, 1, length(s)-2);
end;

function TfrmSicsReportCustom.ConstroiDeleteSql : boolean;
begin
  Result := False;
end;


function TfrmSicsReportCustom.CreateCsvFile (FileName : string) : boolean;
var
  Arq : TextFile;
  s : string;
begin
  Result := true;
  try
    AssignFile (Arq, FileName);
    rewrite (Arq);
    cdsEventos.DisableControls;
    ProgressBar1.Max := cdsEventos.RecordCount;
    ProgressBar1.Value := 0;
    ProgressBar1.Visible := true;
    try
       s := 'Senha;';

        if chkMostrarNomeDosClientes.IsChecked then
          s := s + 'Cliente;';

        if chkMostrarTipoSenha.IsChecked then
          s := s + 'Tipo;';

        s := s + 'Evento;Fila;PA;Atendente;Inicio;Término;';

        if chkMostrarTags.IsChecked then
          s := s + 'Tags';

      writeln (arq, s);
      cdsEventos.First;
      while not cdsEventos.eof do
      begin
        s := cdsEventos.FieldByName('NUMEROTICKET').AsString + ';';

        if chkMostrarNomeDosClientes.IsChecked then
          s := s + cdsEventos.FieldByName('NOMECLIENTE').AsString + ';';

        if chkMostrarTipoSenha.IsChecked then
          s := s + cdsEventos.FieldByName('TIPOTICKET').AsString + ';';

        s := s +
             cdsEventos.FieldByName('NOMETIPOEVENTO').AsString + ';' +
             cdsEventos.FieldByName('NOMEFILAESPERA').AsString + ';' +
             cdsEventos.FieldByName('NOMEPA'        ).AsString + ';' +
             cdsEventos.FieldByName('NOMEATD'       ).AsString + ';' +
             cdsEventos.FieldByName('INICIO'        ).AsString + ';' +
             cdsEventos.FieldByName('FIM'           ).AsString + ';' ;

        if chkMostrarTags.IsChecked then
          s := s + cdsEventos.FieldByName('INTCALC_TAGS').AsString;

        writeln (arq, s);
        ProgressBar1.Value := cdsEventos.RecNo;
        cdsEventos.Next;
      end;  { while not eof }
    finally
      CloseFile (Arq);
      cdsEventos.EnableControls;
      ProgressBar1.Visible := false;
    end;  { try .. finally }
  except
    Result := false;
  end;  { try .. except }
end;

destructor TfrmSicsReportCustom.Destroy;
begin
  qryEventos.Close;
  cdsEventos.Close;

  inherited;
end;

procedure TfrmSicsReportCustom.dsEventosDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  AtualizaQtdeRegistros;
end;

procedure TfrmSicsReportCustom.dtsMainStateChange(Sender: TObject);
begin
  inherited;
  AtualizaQtdeRegistros;
end;

procedure TfrmSicsReportCustom.PrintPreviewButtonClick(Sender: TObject);
begin
  Exit;
end;

procedure TfrmSicsReportCustom.SetVisible(const aVisible: Boolean);
begin
  inherited;
  if aVisible then
  begin
    TfrmSicsSplash.ShowStatus('Carregando os dados...');
    try
      try
        ConstroiSql;
        UpdateColunasGrid;
      finally
      end;
    finally
      TfrmSicsSplash.Hide;
    end;
  end;
end;

procedure TfrmSicsReportCustom.FecharButtonClick(Sender: TObject);
begin
  Visible := False;
end;

procedure TfrmSicsReportCustom.PreencherTagsCdsEventos;
var
  sTags: string;
  iRecordCount: Integer;
begin
  with cdsEventos do
  begin
    First;

    TfrmSicsSplash.ShowStatus('Obtendo as Tags, aguarde...');
    try
      DisableControls;
      try
        iRecordCount := RecordCount;

        First;
        while not Eof do
        begin
          TfrmSicsSplash.ShowStatus('Obtendo as Tags ' + #13 + #10 + '(Registro ' + IntToStr(RecNo) + ' de ' + IntToStr(iRecordCount) + ')');
          Application.ProcessMessages;

          sTags := '';
          qryGetTagsTicket.Close;
          qryGetTagsTicket.Connection := DMClient(FieldByName('ID_UNIDADE').AsInteger, not CRIAR_SE_NAO_EXISTIR).connRelatorio;
          qryGetTagsTicket.ParamByName('IDS_TICKET').AsInteger := FieldByName('ID_TICKET').AsInteger;
          qryGetTagsTicket.Open;
          try
            qryGetTagsTicket.First;
            while not qryGetTagsTicket.Eof do
            begin
              if sTags <> '' then
                sTags := sTags + ',';
              sTags := sTags + qryGetTagsTicket.FieldByName('NOMETAG').AsString;
              qryGetTagsTicket.Next;
            end;
          finally
            qryGetTagsTicket.Close;
          end;

          Edit;
          FieldByName('INTCALC_TAGS').AsString := sTags;
          Post;

          Next;
        end;
      finally
        EnableControls;
      end;
    finally
      TfrmSicsSplash.Hide;
    end;
  end;
end;

procedure TfrmSicsReportCustom.ExportBtnClick(Sender: TObject);
begin
  if(ExportDialog.Execute)then
  begin
    if CreateCsvFile(ExportDialog.FileName) then
       InformationMessage('Dados exportados.');
  end;
end;

{--------------------------------------------------}
{ Procedures para customizacoes }

procedure TfrmSicsReportCustom.chkMostrarNomeDosClientesChange(Sender: TObject);
begin
  inherited;
  cdsEventos.FieldByName('NOMECLIENTE').Visible := chkMostrarNomeDosClientes.IsChecked;
  UpdateColunasGrid;
end;

procedure TfrmSicsReportCustom.chkMostrarTipoSenhaChange(Sender: TObject);
begin
  inherited;
  cdsEventos.FieldByName('TIPOTICKET').Visible := chkMostrarTipoSenha.IsChecked;
  UpdateColunasGrid;
end;

procedure TfrmSicsReportCustom.UpdateColunasGrid;
begin
  AspUpdateColunasGrid(Self, bndList);
end;

procedure TfrmSicsReportCustom.AtualizaQtdeRegistros;
var
  LRecordCount: Integer;
begin
  LRecordCount := 0;
  if Assigned(dtsMain.DataSet) and dtsMain.DataSet.Active then
    LRecordCount := dtsMain.DataSet.RecordCount;
  RecordsLabel.Text := IntToStr(LRecordCount);
end;

procedure TfrmSicsReportCustom.cdsAddEventoReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TfrmSicsReportCustom.cdsEventosAfterOpen(DataSet: TDataSet);
var
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorioBase;

  function AjustaField(const aFieldName: String; const aDisplayLabel: string = ''; const aSize: Integer = 70;
    const aVisible: Boolean = False; aAlignment: TAlignment = taLeftJustify; const aDisplayFormat: string = ''): Boolean;
  var
    LField: TField;
  begin
    LField := cdsEventos.FindField(aFieldName);
    Result := Assigned(LField);
    if not result then
      Exit;

    LField.DisplayLabel := aDisplayLabel;
    LField.DisplayWidth := aSize;
    LField.Visible := aVisible;
    LField.Alignment := aAlignment;
    if (LField is TDateTimeField) then
      TDateTimeField(LField).DisplayFormat := aDisplayFormat;
  end;

begin
  LfrmPesquisaRelatorio := (owner as TfrmPesquisaRelatorioBase);
  inherited;

  cdsEventos.FieldByName('LKP_NOME_UNIDADE').Visible := (LfrmPesquisaRelatorio.cdsUnidades.RecordCount > 1);
  cdsEventos.LogChanges := False;
  FPreecheuTagsCdsEventos := False;

  AtualizaQtdeRegistros;
  AspUpdateColunasGrid(Self, bndList);

end;

procedure TfrmSicsReportCustom.cdsEventosBeforeOpen(DataSet: TDataSet);
var
  LFieldLookup: TField;
begin
  inherited;

  LFieldLookup := cdsEventos.FindField('LKP_NOME_UNIDADE');
  if Assigned(LFieldLookup) then
    LFieldLookup.LookupDataSet := dmUnidades.cdsUnidadesClone;
end;

procedure TfrmSicsReportCustom.chkMostrarTagsChange(Sender: TObject);
begin
  inherited;
  cdsEventos.FieldByName('INTCALC_TAGS').Visible := chkMostrarTags.IsChecked;
  UpdateColunasGrid;

  if (chkMostrarTags.IsChecked) and (not FPreecheuTagsCdsEventos) then
  begin
    PreencherTagsCdsEventos;
    FPreecheuTagsCdsEventos := True;
  end;
end;

procedure TfrmSicsReportCustom.cdsEventosDURACAO_SEGUNDOSGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', IncSecond(0, Sender.AsInteger));
end;

end.

