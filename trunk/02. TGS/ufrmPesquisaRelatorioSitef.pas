unit ufrmPesquisaRelatorioSitef;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.Edit, FMX.DateTimeCtrls, FMX.StdCtrls, FMX.Effects,
  FMX.Objects, FMX.Controls.Presentation, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, System.ImageList, FMX.ImgList, System.dateutils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IniFiles, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, System.strutils,System.JSON,
  System.NetEncoding, IOUtils,Winapi.ShellAPI,Winapi.Windows;

type
  TTipoPesquisa = (tpTodos, tpTotem, tpBandeira, tpPassagem, tpNSU, tpAutorizacao);
  TUnidades = record
                 id : Integer;
                 Nome: String;
               end;
  TfrmPesquisaRelatorioSitef = class(TForm)
    rectFundo: TRectangle;
    rectPesquisa: TRectangle;
    rbFiltroAutorizacao: TRadioButton;
    rbFiltroBandeira: TRadioButton;
    rbFiltroTotem: TRadioButton;
    rbFiltroTodos: TRadioButton;
    rect1: TRectangle;
    rectPeriodo: TRectangle;
    Label1: TLabel;
    Label4: TLabel;
    rectTituloPeriodoRelatorio: TRectangle;
    dtPeriodoDE: TDateEdit;
    Label2: TLabel;
    dtPeriodoATE: TDateEdit;
    rbFiltroPassagem: TRadioButton;
    rbFiltroNSU: TRadioButton;
    Label3: TLabel;
    edFiltro: TEdit;
    rectGrid: TRectangle;
    rectNomeUnidade: TRectangle;
    lblNomeUnidade: TLabel;
    rectRodape: TRectangle;
    rectRodapeGrid: TRectangle;
    lbTotalTransacoes: TLabel;
    lbValorTotal: TLabel;
    rectEsquerda: TRectangle;
    imgResources: TImageList;
    rectImgImprimir: TRectangle;
    rectImprimir: TRectangle;
    rectCancelar: TRectangle;
    rectEmail: TRectangle;
    rectImgEmail: TRectangle;
    Image1: TImage;
    rectPesquisar: TRectangle;
    Rectangle2: TRectangle;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    listItensFiltro: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Image2: TImage;
    Image3: TImage;
    fcConnMain: TFDConnection;
    fdQryMain: TFDQuery;
    stGridMain: TStringGrid;
    colPassagem: TStringColumn;
    colNSU: TStringColumn;
    colAutorizacao: TStringColumn;
    colParcelas: TStringColumn;
    colData: TStringColumn;
    colHora: TStringColumn;
    colDoc: TStringColumn;
    colBandeira: TStringColumn;
    colStatusTransacao: TStringColumn;
    colTerminal: TStringColumn;
    colTotem: TStringColumn;
    colValor: TStringColumn;
    sdExportarCSV: TSaveDialog;
    layBase: TLayout;
    recCaption: TRectangle;
    lblCaption: TLabel;
    imgClose: TImage;
    GlowEffect2: TGlowEffect;
    imgRes: TImage;
    GlowEffect1: TGlowEffect;
    imgMin: TImage;
    GlowEffect3: TGlowEffect;
    imgMax: TImage;
    GlowEffect4: TGlowEffect;
    rectMin: TRectangle;
    rectMax: TRectangle;
    rectClose: TRectangle;
    rectBackground: TRectangle;
    BitBtn1: TButton;
    Image4: TImage;
    GlowEffect5: TGlowEffect;
    rectUnidade: TRectangle;
    Rectangle3: TRectangle;
    Label11: TLabel;
    cboListaUnidades: TComboBox;
    procedure rbFiltroTodosChange(Sender: TObject);
    procedure rbFiltroTotemChange(Sender: TObject);
    procedure rbFiltroBandeiraChange(Sender: TObject);
    procedure rbFiltroPassagemChange(Sender: TObject);
    procedure rbFiltroNSUChange(Sender: TObject);
    procedure rbFiltroAutorizacaoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rectEmailClick(Sender: TObject);
    procedure rectImprimirClick(Sender: TObject);
    procedure rectCancelarClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure btnCloseFormClick(Sender: TObject);
    procedure imgMaxClick(Sender: TObject);
    procedure imgResClick(Sender: TObject);
    procedure rectCloseClick(Sender: TObject);
    procedure rectMaxClick(Sender: TObject);
    procedure rectPesquisarClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure cboListaUnidadesChange(Sender: TObject);

  private
    { Private declarations }
    FIdUnidade: String;
    FUnidadesLib : Array of TUnidades;
    FServidorDB: String;
    FBDUnidades:string;
    FUrl_EnviarEmailGenerico: String;
    FTitulo : string;
    FPeriodo : string;
    FTotal : string;
    vTipoPesquisa : String;
    vSelectSQL : String;
    vArquivoPDF :string;
    vArquivoCSV :string;
    gridValores: array of array of TValue;
    ColPos : Array of Integer;

    function ExportToExcel(AGrid:TStringGrid;AFileName:String):Boolean;
    procedure SetIdUnidade(const Value: String);
    procedure SetServidorDB(const Value: String);
    procedure SetBDUnidades(const Value: String);
    procedure SetTitulo(const Value: string);
    procedure SetPeriodo(const Value: string);
    procedure SetTotal(const Value: string);
    procedure SetUrl_EnviarEmailGenerico(const Value: string);
    procedure MudaPesquisa(vTipoPesquisa: TTipoPesquisa);
    procedure CarregaListItens(vTipoPesquisa: TTipoPesquisa);
    procedure PesquisarRegistros;
    procedure GerarArqJson;
    procedure PreencheUnidades;

    property Titulo     : string read FTitulo     write SetTitulo;
    property Periodo    : string read FPeriodo    write SetPeriodo;
    property Total      : string read FTotal      write SetTotal;

  public
    { Public declarations }
    function ExecAndWait(const FileName, Params: string;const WindowState: Word): Boolean;

    property IdUnidade  : String read FIdUnidade  write SetIdUnidade;
    property ServidorDB : String read FServidorDB write SetServidorDB;
    property BDUnidades : string read FBDUnidades write SetBDUnidades;
    property Url_EnviarEmailGenerico: String read FUrl_EnviarEmailGenerico write SetUrl_EnviarEmailGenerico;

  end;

var
  frmPesquisaRelatorioSitef: TfrmPesquisaRelatorioSitef;

implementation

{$R *.fmx}

uses ufrmExportarEmail,untCommonControleInstanciasTelas,MyAspFuncoesUteis, untLog;

procedure TfrmPesquisaRelatorioSitef.FormCreate(Sender: TObject);
var
  ArqIni: TIniFile;
  LNomeIni: String;
  oParams: TFDPhysFBConnectionDefParams;
  oDef: IFDStanConnectionDef;
begin
  imgRes.Visible := False;
  imgMax.Visible := True;
  dtPeriodoDE.DateTime := Yesterday;
  dtPeriodoATE.DateTime := Yesterday;
  rectNomeUnidade.Visible := False;
  LNomeIni := StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll]);
  ArqIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + LNomeIni);
  try
    IdUnidade := ArqIni.ReadString('Settings', 'IdUnidade', '0');
    ServidorDB := ArqIni.ReadString('Settings', 'ServidorDB', '192.168.0.196');
    BDUnidades:= ArqIni.ReadString('Settings', 'BDUnidades', 'C:\Program Files (x86)\Aspect\SICS_HIAE\DBase\SICSUNIDADES.FDB');
    Url_EnviarEmailGenerico := ArqIni.ReadString('EndPointsSiaf', 'URL_ENVIAREMAILGENERICO', 'http://10.33.1.27:20014/emailgenerico/enviar');
    ArqIni.WriteString('Settings', 'IdUnidade', IdUnidade);
    ArqIni.WriteString('Settings', 'BDUnidades',BDUnidades);
    ArqIni.WriteString('Settings', 'ServidorDB',ServidorDB);
    ArqIni.WriteString('EndPointsSiaf', 'URL_ENVIAREMAILGENERICO', Url_EnviarEmailGenerico);
    fcConnMain.Params.Values['Database']:= BDUnidades;
    fcConnMain.Params.Values['UserName']:= 'sysdba';
    fcConnMain.Params.Values['Password']:= 'masterkey';
    fcConnMain.Params.Values['Server']:= ServidorDB;
    fcConnMain.Connected := true;
  finally
    FreeAndNil(ArqIni);
  end;

  listItensFiltro.Visible := False;
  edFiltro.Visible := False;

  PreencheUnidades;
end;


procedure TfrmPesquisaRelatorioSitef.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Self.StartWindowDrag;
end;

procedure TfrmPesquisaRelatorioSitef.GerarArqJson;
var
  json :TJSONObject;
  vArq: TextFile;
  vArqExporta : string;
  vConteudo : string;
  Base64: TBase64Encoding;
  i: integer;
  ArqIni: TIniFile;
  LNomeIni: String;
begin
  try
    try
      ForceDirectories(ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA');
      vArqExporta := ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA\RelatSitef_' + FormatDateTime('DD-MM-YYYY',Now) + '.DAT';
      LNomeIni := ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA\RelatSitef.ini';
      Base64 := TBase64Encoding.Create(100, '');
      ArqIni := TIniFile.Create(LNomeIni);
      ArqIni.WriteString('Settings', 'Arquivo', Base64.Encode(vArqExporta) );
      ArqIni.WriteString('Settings', 'Titulo', Base64.Encode(Titulo));
      ArqIni.WriteString('Settings', 'Periodo', Base64.Encode(Periodo) );
      ArqIni.WriteString('Settings', 'Total', Base64.Encode(Total) );
      AssignFile(vArq, vArqExporta, TEncoding.Default.CodePage);
      Rewrite(vArq);
      for i  := 0 to stGridMain.RowCount-1 do
      begin
        jSon := TJSONObject.Create;
        jSon.AddPair('PASSAGEM',stGridMain.Cells[0,i]);
        jSon.AddPair('NSU',stGridMain.Cells[1,i]);
        jSon.AddPair('AUTORIZACAO',stGridMain.Cells[2,i]);
        jSon.AddPair('PARCELAS',TJSONNumber.Create(StrToInt(stGridMain.Cells[3,i])));
        jSon.AddPair('DATA',stGridMain.Cells[4,i]);
        jSon.AddPair('HORA',stGridMain.Cells[5,i]);
        jSon.AddPair('DOC',stGridMain.Cells[6,i]);
        jSon.AddPair('BANDEIRA',stGridMain.Cells[7,i]);
        jSon.AddPair('STATUS_TRANSACAO',stGridMain.Cells[8,i]);
        jSon.AddPair('TERMINAL',stGridMain.Cells[9,i]);
        jSon.AddPair('TOTEM',stGridMain.Cells[10,i]);
        jSon.AddPair('VALOR', StringReplace(stGridMain.Cells[11,i],'R$ ','',[rfReplaceAll]));
        vConteudo:= Base64.Encode(jSon.ToString);
        WriteLn(vArq, vConteudo);
        FreeAndNil(json);
      end;
      Flush(vArq);
    finally
    FreeAndNil(ArqIni);
      Base64.Free;
      CloseFile(vArq);
    end;

  except on e:exception do
  end;
end;

procedure TfrmPesquisaRelatorioSitef.imgCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioSitef.imgMaxClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsMaximized;
  imgMax.Visible := False;
  imgRes.Visible := True;
end;

procedure TfrmPesquisaRelatorioSitef.imgResClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsNormal;
  imgMax.Visible := True;
  imgRes.Visible := False;
end;

procedure TfrmPesquisaRelatorioSitef.MudaPesquisa(vTipoPesquisa: TTipoPesquisa);
begin
    if (cboListaUnidades.Items.Count > 0) and (cboListaUnidades.ItemIndex >=0) then
  begin
    edFiltro.Visible := False;
    listItensFiltro.Visible := False;
    case vTipoPesquisa of
      tpTodos:
        begin

        end;
      tpTotem:
        begin
          listItensFiltro.Visible := True;
          CarregaListItens(vTipoPesquisa);
        end;
      tpBandeira:
        begin
          listItensFiltro.Visible := True;
          CarregaListItens(vTipoPesquisa);
        end;
      tpPassagem:
        begin
          edFiltro.Visible := True;
        end;
      tpNSU:
        begin
          edFiltro.Visible := True;
        end;
      tpAutorizacao:
        begin
          edFiltro.Visible := True;
        end;
    end;
  end
  else
  begin
    ErrorMessageWithoutLog('Selecione uma unidade');
  end;

end;

procedure TfrmPesquisaRelatorioSitef.PesquisarRegistros;
var
  vDataHoraIni : TDateTime;
  vDataHoraFim : TDateTime;
  fs: TFormatSettings;
  i:integer;
  vTemChecados,vMarcou:boolean;
  qry: TFDQuery;
  vSomaValor : Double;
begin
  fs := TFormatSettings.Create;
  fs.DateSeparator := '/';
  fs.ShortDateFormat := 'DD/MM/YYYY';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm';
  fs.LongTimeFormat := 'hh:mm:ss';

  vDataHoraIni := dtPeriodoDE.DateTime;
  vDataHoraFim := dtPeriodoATE.DateTime;
  Titulo := 'Relatorio Sitef - ' + FUnidadesLib[cboListaUnidades.ItemIndex].Nome + ' - ';
  if rbFiltroTodos.IsChecked then begin
	  vDataHoraIni := StrToDateTime('01/01/2021 00:00:00',fs);
	  vDataHoraFim := tomorrow;
    Titulo := Titulo + 'TODOS';
  end;

  Periodo := 'De ' + FormatDateTime('DD/MM/YYYY',vDataHoraIni) + ' a ' + FormatDateTime('DD/MM/YYYY',vDataHoraFim);

	vSelectSQL := 'SELECT PASSAGEM, NSU, AUTORIZACAO, PARCELAS, ' +
                        'DATAHORA, DOC, REDE, STATUS_TRANSACAO, TERMINAL, TOTEM, VALOR ' +
                '  FROM RELAT_SITEF ' +
				        '	WHERE (DATAHORA >= (' + QuotedStr(FormatDateTime('YYYY-MM-DD 00:00:00',vDataHoraIni)) +' ) and DATAHORA <= (' + QuotedStr(FormatDateTime('YYYY-MM-DD 23:59:59',vDataHoraFim)) + ')) ' +
                ' AND ID_UNIDADE = ' + IntToStr(FUnidadesLib[cboListaUnidades.ItemIndex].id);

	if rbFiltroTotem.IsChecked then begin
    vTemChecados := False;
    for i := 0 to listItensFiltro.Items.Count - 1 do begin
      if listItensFiltro.ItemByIndex(i).IsChecked then begin
        vTemChecados := True;
      end;
    end;
    if vTemChecados = True then begin
      vSelectSQL := vSelectSQL + 'AND TOTEM in (';
      Titulo := Titulo + 'TOTENS: ';
      vMarcou := False;
      for i := 0 to listItensFiltro.Items.Count - 1 do begin
        if listItensFiltro.ItemByIndex(i).IsChecked then begin
          if vMarcou = True then begin
            vSelectSQL := vSelectSQL + ', ';
            Titulo := Titulo + ', ';
          end;
      		vSelectSQL := vSelectSQL + Quotedstr( listItensFiltro.ItemByIndex(i).Text);
          Titulo := Titulo + listItensFiltro.ItemByIndex(i).Text;
          vMarcou := True;
        end;
      end;
      vSelectSQL := vSelectSQL + ') ';
    end
    else begin
      showmessage('Selecione um dos TOTENS!');
      vSelectSQL := '';
      Titulo := '';
    end;
	end;

	if rbFiltroBandeira.IsChecked then begin
    vTemChecados := False;
    for i := 0 to listItensFiltro.Items.Count - 1 do begin
      if listItensFiltro.ItemByIndex(i).IsChecked then begin
        vTemChecados := True;
      end;
    end;
    if vTemChecados = True then begin
      vSelectSQL := vSelectSQL + 'AND REDE in (';
      Titulo := Titulo + 'BANDEIRA(s): ';
      vMarcou := False;
      for i := 0 to listItensFiltro.Items.Count - 1 do begin
        if listItensFiltro.ItemByIndex(i).IsChecked then begin
          if vMarcou = True then begin
            vSelectSQL := vSelectSQL + ', ';
            Titulo := Titulo + ', ';
          end;
          vSelectSQL := vSelectSQL + Quotedstr( listItensFiltro.ItemByIndex(i).Text);
          Titulo := Titulo + listItensFiltro.ItemByIndex(i).Text;
          vMarcou := True;
        end;
      end;
      vSelectSQL := vSelectSQL + ') ';
    end
    else begin
      showmessage('Selecione uma das BANDEIRAS!');
      vSelectSQL := '';
      Titulo := '';
    end;
	end;

	if rbFiltroAutorizacao.IsChecked then begin
    if trim(edFiltro.Text) <> '' then begin
  		vSelectSQL := vSelectSQL + 'AND AUTORIZACAO = ' + QuotedStr(edFiltro.text) + ' ';
      Titulo := Titulo + 'AUTORIZACAO: ' + edFiltro.text;
    end
    else begin
      showmessage('Preencha o campo do Filtro!');
      vSelectSQL := '';
      Titulo := '';
    end;
	end;

  if rbFiltroPassagem.IsChecked then begin
    if trim(edFiltro.Text) <> '' then begin
  	  vSelectSQL := vSelectSQL + ' AND PASSAGEM = ' + QuotedStr(edFiltro.text) + ' ';
      Titulo := Titulo + 'PASSAGEM: ' + edFiltro.text;
    end
    else begin
      showmessage('Preencha o campo do Filtro!');
      vSelectSQL := '';
      Titulo := '';
    end;
  end;

  if rbFiltroNSU.IsChecked then begin
    if trim(edFiltro.Text) <> '' then begin
  		vSelectSQL := vSelectSQL + ' AND NSU = ' + QuotedStr(edFiltro.text) + ' ';
      Titulo := Titulo + 'NSU: ' + edFiltro.text;
    end
    else begin
      showmessage('Preencha o campo do Filtro!');
      vSelectSQL := '';
      Titulo := '';
    end;
	end;

  if vSelectSQL <> '' then
  begin
    try
      try
        vSelectSQL := vSelectSQL + 'Order by DATAHORA, DOC';
        fdQryMain.sql.Clear;
        fdQryMain.sql.Text := vSelectSQL;
        fdQryMain.Open;
        fdQryMain.Last;
        fdQryMain.First;
        if fdQryMain.RecordCount > 0 then
        begin
			stGridMain.RowCount := fdQryMain.RecordCount;
			for i := 0 to fdQryMain.RecordCount -1 do begin
			  stGridMain.Cells[0,i] := fdQryMain.FieldByName('PASSAGEM').AsString;
			  stGridMain.Cells[1,i] := fdQryMain.FieldByName('NSU').AsString;
			  stGridMain.Cells[2,i] := fdQryMain.FieldByName('AUTORIZACAO').AsString;
			  stGridMain.Cells[3,i] := ifthen( fdQryMain.FieldByName('PARCELAS').AsInteger <> 0,fdQryMain.FieldByName('PARCELAS').AsString,'1');
			  stGridMain.Cells[4,i] := FormatDateTime('DD/MM/YYYY', fdQryMain.FieldByName('DATAHORA').AsDateTime);
			  stGridMain.Cells[5,i] := FormatDateTime('HH:NN:SS', fdQryMain.FieldByName('DATAHORA').AsDateTime);
			  stGridMain.Cells[6,i] := fdQryMain.FieldByName('DOC').AsString;
			  stGridMain.Cells[7,i] := fdQryMain.FieldByName('REDE').AsString;
			  stGridMain.Cells[8,i] := fdQryMain.FieldByName('STATUS_TRANSACAO').AsString;
			  stGridMain.Cells[9,i] := fdQryMain.FieldByName('TERMINAL').AsString;
			  stGridMain.Cells[10,i] := fdQryMain.FieldByName('TOTEM').AsString;
			  stGridMain.Cells[11,i] := 'R$ ' + FormatFloat('0.00', fdQryMain.FieldByName('VALOR').AsFloat);
			  vSomaValor := vSomaValor + fdQryMain.FieldByName('VALOR').AsFloat;
			  fdQryMain.Next;
			end;
        end
        else
        begin
          showmessage('A pesquisa retornou 0 (zero) registros');
        end;
        lbTotalTransacoes.Text := 'Total de Transações ' + IntToStr(fdQryMain.RecordCount);
        lbValorTotal.Text := 'Valor Total R$ ' + formatfloat('0.00', vSomaValor);
        Total := formatfloat('0.00', vSomaValor);
      finally
      end;
    except on e:Exception do
    end;
  end;

//  GridRelatSitef.val
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroAutorizacaoChange(Sender: TObject);
begin
  if rbFiltroAutorizacao.IsChecked then begin
    MudaPesquisa(tpAutorizacao);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroBandeiraChange(Sender: TObject);
begin
  if rbFiltroBandeira.IsChecked then begin
    MudaPesquisa(tpBandeira);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroNSUChange(Sender: TObject);
begin
  if rbFiltroNSU.IsChecked then begin
    MudaPesquisa(tpNSU);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroPassagemChange(Sender: TObject);
begin
  if rbFiltroPassagem.IsChecked then begin
    MudaPesquisa(tpPassagem);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroTodosChange(Sender: TObject);
begin
  if rbFiltroTodos.IsChecked then begin
    MudaPesquisa(tpTodos);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rbFiltroTotemChange(Sender: TObject);
begin
  if rbFiltroTotem.IsChecked then begin
    MudaPesquisa(tpTotem);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rectCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioSitef.rectCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioSitef.rectEmailClick(Sender: TObject);
var
  frmExportarEmail : TfrmExportarEmail;
begin
  if Titulo <> ''  then begin
    GerarArqJson;
    if FileExists(ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA\RelatSitef.ini') then begin
      ExecAndWait(ExtractFilePath(ParamStr(0)) + 'SICS_PDF.exe','RelatSitef',SW_HIDE);
      vArquivoPDF := ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA\RelatSitef_' + FormatDateTime('DD-MM-YYYY',Now) + '.PDF';
      vArquivoCSV := ExtractFilePath(ParamStr(0)) + 'ASPECT\DATA\RelatSitef_' + FormatDateTime('DD-MM-YYYY',Now) + '.CSV';
      ExportToExcel(stGridMain,vArquivoCSV);
      frmExportarEmail := TfrmExportarEmail.Create(Self);
      frmExportarEmail.lblCaption.Text := 'Envio por Email';
      frmExportarEmail.Destinatario := '';
      frmExportarEmail.edDestinatario.Text := frmExportarEmail.Destinatario;
      frmExportarEmail.Mensagem := '';
      frmExportarEmail.edMensagem.Lines.Text := frmExportarEmail.Mensagem;
      frmExportarEmail.TituloMensagem := Titulo;
      frmExportarEmail.edAssunto.Text := frmExportarEmail.TituloMensagem;
      frmExportarEmail.Remetente := 'noreply@einstein.br';
      frmExportarEmail.edRemetente.Text := frmExportarEmail.Remetente;
      frmExportarEmail.DestinatariosCopia := '';
      frmExportarEmail.DestinatariosCopiaOculta := '';
      frmExportarEmail.UnidadeDR := '';
      frmExportarEmail.TipoEpisodioDR := '';
      frmExportarEmail.ArquivoPDF := vArquivoPDF;
      frmExportarEmail.ArquivoCSV := vArquivoCSV;
      frmExportarEmail.Url_EnviarEmailGenerico := Url_EnviarEmailGenerico;
      frmExportarEmail.ShowModal;
      frmExportarEmail.DisposeOf;
      frmExportarEmail := nil;
    end;
  end
  else begin
    ShowMessage('Sem dados para enviar email');
  end;
end;



procedure TfrmPesquisaRelatorioSitef.rectImprimirClick(Sender: TObject);
var
  vArqExport : string;
begin
  if Titulo <> '' then begin
    sdExportarCSV.Filter:= 'Arquivos CSV|*.csv';
    If sdExportarCSV.Execute Then begin
      if RightBStr(UpperCase(sdExportarCSV.FileName),4) = '.CSV'then begin
        vArqExport:=sdExportarCSV.FileName;
      end
      else begin
        vArqExport:=sdExportarCSV.FileName + '.csv';
      end;
    end;
    if vArqExport <> ''  then begin
      if ExportToExcel(stGridMain,vArqExport) then begin
        ShowMessage('Dados exportados com sucesso!');
      end;
    end;
  end
  else begin
    ShowMessage('Sem dados para imprimir');
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rectMaxClick(Sender: TObject);
begin
  if Self.WindowState = TWindowState.wsNormal then  begin
    imgRes.Visible := True;
    imgMax.Visible := False;
    Self.WindowState := TWindowState.wsMaximized;
  end
  else
  if Self.WindowState = TWindowState.wsMaximized then begin
    imgRes.Visible := False;
    imgMax.Visible := True;
    Self.WindowState := TWindowState.wsNormal;
  end;
end;

procedure TfrmPesquisaRelatorioSitef.rectPesquisarClick(Sender: TObject);
begin
  PesquisarRegistros;
end;

procedure TfrmPesquisaRelatorioSitef.btnCloseFormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPesquisaRelatorioSitef.CarregaListItens(vTipoPesquisa: TTipoPesquisa);
var
  lbi: TListBoxItem;
  i:integer;
  qry: TFDQuery;
begin
  try
    listItensFiltro.BeginUpdate;
    qry := TFDQuery.Create(Self);
    qry.Connection := fcConnMain;
    try
      listItensFiltro.Clear;
      qry.Close;
      qry.SQL.Clear;
      case vTipoPesquisa of
        tpTotem:
          begin
            qry.SQL.Add('SELECT DISTINCT(TOTEM) ITEM ');
            qry.SQL.Add('  FROM RELAT_SITEF ');
            qry.SQL.Add(' WHERE ID_UNIDADE = ' + IntToStr(FUnidadesLib[cboListaUnidades.ItemIndex].id));
            qry.SQL.Add(' ORDER BY TOTEM');
          end;
        tpBandeira:
          begin
            qry.SQL.Add('SELECT DISTINCT(REDE) ITEM ');
            qry.SQL.Add('  FROM RELAT_SITEF ');
            qry.SQL.Add(' WHERE ID_UNIDADE = ' + IntToStr(FUnidadesLib[cboListaUnidades.ItemIndex].id));
            qry.SQL.Add(' ORDER BY REDE');
          end;
      end;
      qry.Open;
      for i := 0 to qry.RecordCount - 1 do begin
        lbi := TListBoxItem.Create(listItensFiltro);
        lbi.Parent := listItensFiltro;
        lbi.Text := qry.FieldByName('ITEM').AsString;
        qry.Next;
      end;
    finally
      listItensFiltro.EndUpdate;
    end;
  finally
    qry.DisposeOf;
    qry := nil;
  end;
end;

procedure TfrmPesquisaRelatorioSitef.cboListaUnidadesChange(Sender: TObject);
begin
  if rbFiltroBandeira.IsChecked then
  begin
    MudaPesquisa(tpBandeira);
  end
  else if rbFiltroTotem.IsChecked then
  begin
    MudaPesquisa(tpTotem);
  end;
end;

procedure TfrmPesquisaRelatorioSitef.SetBDUnidades(const Value: String);
begin
  FBDUnidades := Value;
end;

procedure TfrmPesquisaRelatorioSitef.SetIdUnidade(const Value: String);
begin
  FIdUnidade := Value;
end;


procedure TfrmPesquisaRelatorioSitef.SetPeriodo(const Value: string);
begin
  FPeriodo := Value
end;

procedure TfrmPesquisaRelatorioSitef.SetServidorDB(const Value: String);
begin
  FServidorDB := Value;
end;

procedure TfrmPesquisaRelatorioSitef.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

procedure TfrmPesquisaRelatorioSitef.SetTotal(const Value: string);
begin
  FTotal := Value;
end;

procedure TfrmPesquisaRelatorioSitef.SetUrl_EnviarEmailGenerico(
  const Value: string);
begin
  FUrl_EnviarEmailGenerico := Value;
end;

function TfrmPesquisaRelatorioSitef.ExecAndWait(const FileName, Params: string;
const WindowState: Word): Boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  CmdLine := '"' + FileName + '" ' + Params;

  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    PChar(ExtractFilePath(FileName)), SUInfo, ProcInfo);
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function  TfrmPesquisaRelatorioSitef.ExportToExcel(AGrid:TStringGrid;AFileName:String):Boolean;
var
  row,col:Integer;
  lst:TStringList;
  txt:String;
  tnd:String;
begin
  lst := TStringList.Create;
  fdQryMain.First;
  txt := 'PASSAGEM;NSU;AUTORIZACAO;PARCELAS;DATA;HORA;DOC;BANDEIRA;STATUS_TRANSACAO;TERMINAL;TOTEM;VALOR;UNIDADE; ';
  lst.Add(txt);
  for row := 0 to  fdQryMain.RecordCount-1 do
  begin
    txt := '';
    tnd := '';
    txt := '"' + fdQryMain.FieldByName('PASSAGEM').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('NSU').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('AUTORIZACAO').AsString + '";';
    txt := txt + ifthen( fdQryMain.FieldByName('PARCELAS').AsInteger <> 0,fdQryMain.FieldByName('PARCELAS').AsString,'1') + ';' ;
    txt := txt + FormatDateTime('DD/MM/YYYY', fdQryMain.FieldByName('DATAHORA').AsDateTime) + ';';
    txt := txt + FormatDateTime('HH:NN:SS', fdQryMain.FieldByName('DATAHORA').AsDateTime) + ';';
    txt := txt + '"' + fdQryMain.FieldByName('DOC').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('REDE').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('STATUS_TRANSACAO').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('TERMINAL').AsString + '";';
    txt := txt + '"' + fdQryMain.FieldByName('TOTEM').AsString + '";';
    txt := txt + StringReplace(FormatFloat('0.00', fdQryMain.FieldByName('VALOR').AsFloat),'.',',',[rfReplaceAll]) + ';';
    txt := txt + '"' + FUnidadesLib[cboListaUnidades.ItemIndex].Nome + '";';
    lst.Add(txt);
    fdQryMain.Next;
  end;
  try
    lst.SaveToFile(AFileName);
    Result := True;
  except
    Result := False;
  end;
  lst.Free;
end;


procedure TfrmPesquisaRelatorioSitef.PreencheUnidades;
var
  i:integer;
  qryUnidades: TFdquery;
  vUnidadesLib: TIntegerDynArray;
begin
  try
    try
      qryUnidades := TFDQuery.Create(Self);
      qryUnidades.Connection := fcConnMain;
      qryUnidades.sql.Add('SELECT ID,NOME ');
      qryUnidades.sql.Add('FROM UNIDADES ');
      qryUnidades.sql.Add('ORDER BY NOME');
      qryUnidades.Open;
      qryUnidades.last;
      qryUnidades.first;
      SetLength(FUnidadesLib,0);
      StrToIntArray(StringReplace(IdUnidade, ',', ';', [rfReplaceAll, rfIgnoreCase]), vUnidadesLib);
      for i := 0 to qryUnidades.RecordCount - 1 do
      begin
        if ExisteNoIntArray(qryUnidades.FieldByName('ID').AsInteger, vUnidadesLib) then
        begin
          SetLength(FUnidadesLib,Length(FUnidadesLib)+1);
          FUnidadesLib[Length(FUnidadesLib)-1].id := qryUnidades.FieldByName('ID').AsInteger;
          FUnidadesLib[Length(FUnidadesLib)-1].Nome := qryUnidades.FieldByName('Nome').AsString;
        end;
        qryUnidades.next;
      end;
      cboListaUnidades.Clear;
      for i := 0 to Length(FUnidadesLib)-1 do
      begin
        cboListaUnidades.Items.Add(FUnidadesLib[i].Nome);
      end;
    finally
      qryUnidades.Close;
      qryUnidades.DisposeOf;
      qryUnidades:= nil;
    end;
  except on e:exception do
    TLog.MyLog('Relatório Sitef - Erro na listagem das unidades: ' + e.Message, nil, 0, false);
  end;
end;

end.
