unit ufrmExportarEmail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  system.jSon,ASPHTTPRequest, System.NetEncoding, IOUtils, FMX.Layouts,
  FMX.Effects;

type
  TfrmExportarEmail = class(TForm)
    rectFundo: TRectangle;
    rectMain: TRectangle;
    rectTitulo: TRectangle;
    lblTitulo: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edRemetente: TEdit;
    edDestinatario: TEdit;
    edAssunto: TEdit;
    edMensagem: TMemo;
    rectRodape: TRectangle;
    rectCancelar: TRectangle;
    Label10: TLabel;
    rectEmail: TRectangle;
    rectImgEmail: TRectangle;
    Label9: TLabel;
    Image3: TImage;
    Layout1: TLayout;
    recCaption: TRectangle;
    lblCaption: TLabel;
    rectMin: TRectangle;
    imgMin: TImage;
    GlowEffect3: TGlowEffect;
    rectMax: TRectangle;
    imgMax: TImage;
    GlowEffect4: TGlowEffect;
    imgRes: TImage;
    GlowEffect1: TGlowEffect;
    rectClose: TRectangle;
    imgClose: TImage;
    GlowEffect2: TGlowEffect;
    rectBackground: TRectangle;
    Image4: TImage;
    GlowEffect5: TGlowEffect;
    procedure rectEmailClick(Sender: TObject);
    procedure rectCancelarClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure btnCloseFormClick(Sender: TObject);
    procedure imgResClick(Sender: TObject);
    procedure imgMaxClick(Sender: TObject);
    procedure rectMaxClick(Sender: TObject);
    procedure rectCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDestinatario   :string;
    FMensagem       :string;
    FTituloMensagem :string;
    FRemetente      :string;
    FDestinatariosCopia :string;
    FDestinatariosCopiaOculta :string;
    FUnidadeDR :string;
    FTipoEpisodioDR :string;
    FArquivoPDF :string;
    FArquivoCSV :string;
    FUrl_EnviarEmailGenerico: String;
    FTentativasApi: Integer;
    FErro: Integer;

    function PostFromAPI(AURL: String; AJson: TJSONObject; ATentivas: Integer = 1): string;
    procedure SetDestinatario(const Value: String);
    procedure SetMensagem(const Value: String);
    procedure SetTituloMensagem(const Value: String);
    procedure SetRemetente(const Value: String);
    procedure SetDestinatariosCopia(const Value: String);
    procedure SetDestinatariosCopiaOculta(const Value: String);
    procedure SetUnidadeDR(const Value: String);
    procedure SetTipoEpisodioDR(const Value: String);
    procedure SetArquivoPDF(const Value: String);
    procedure SetArquivoCSV(const Value: String);
    procedure SetUrl_EnviarEmailGenerico(const Value: String);

  public
    { Public declarations }

    Property Destinatario   :string read FDestinatario write SetDestinatario;
    Property Mensagem       :string read FMensagem write SetMensagem;
    Property TituloMensagem :string read FTituloMensagem write SetTituloMensagem;
    Property Remetente      :string read FRemetente write SetRemetente;
    Property DestinatariosCopia :string read FDestinatariosCopia write SetDestinatariosCopia;
    Property DestinatariosCopiaOculta :string read FDestinatariosCopiaOculta write SetDestinatariosCopiaOculta;
    Property UnidadeDR :string read FUnidadeDR write SetUnidadeDR;
    Property TipoEpisodioDR :string read FTipoEpisodioDR write SetTipoEpisodioDR;
    Property ArquivoPDF :string read FArquivoPDF write SetArquivoPDF;
    Property ArquivoCSV :string read FArquivoCSV write SetArquivoCSV;
    property Url_EnviarEmailGenerico: String read FUrl_EnviarEmailGenerico write SetUrl_EnviarEmailGenerico;
  end;

var
  frmExportarEmail: TfrmExportarEmail;

implementation

{$R *.fmx}
uses untlog;

procedure TfrmExportarEmail.rectCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportarEmail.rectCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportarEmail.rectEmailClick(Sender: TObject);
var
  LJSON : TJSONObject;
  LResultado: String;
  LResposta: String;
  Base64: TBase64Encoding;
  vRelatorioContent:String;
begin
  if (trim(edDestinatario.Text) <> '') and
     (trim(edAssunto.Text) <> '') and
     (trim(edRemetente.Text) <> '') then begin
    try
      Base64 := TBase64Encoding.Create(0);
      if ArquivoPDF <> '' then begin
        if FileExists(ArquivoPDF) then begin
          vRelatorioContent := Base64.Encode(TFile.ReadAllText(ArquivoPDF,  TEncoding.ANSI));
        end;
      end;
      LJSON := TJSONObject.Create;
      LJSON.AddPair('Destinatario', UTF8Encode(edDestinatario.Text));
      LJSON.AddPair('Mensagem', UTF8Encode(edMensagem.Lines.Text));
      LJSON.AddPair('TituloMensagem', UTF8Encode(edAssunto.Text));
      LJSON.AddPair('IsHTML', TJSONBool.Create(False));
      LJSON.AddPair('Remetente', UTF8Encode(edRemetente.Text));
      LJSON.AddPair('DestinatariosCopia', UTF8Encode(''));
      LJSON.AddPair('DestinatariosCopiaOculta', UTF8Encode(''));
      LJSON.AddPair('UnidadeDR', 'null');
      LJSON.AddPair('TipoEpisodioDR', 'null');
      LJSON.AddPair('NomeArquivo', UTF8Encode(ExtractFileName(ArquivoPDF)));
      LJSON.AddPair('Base64', vRelatorioContent);
      LResposta := PostFromAPI(Url_EnviarEmailGenerico, LJSON);
    finally
      DeleteFile(ArquivoPDF);
      LJSON.Free;
      FreeAndNil(Base64);
    end;
    try
      Base64 := TBase64Encoding.Create(0);
      if ArquivoCSV <> '' then begin
        if FileExists(ArquivoCSV) then begin
          vRelatorioContent := Base64.Encode(TFile.ReadAllText(ArquivoCSV,  TEncoding.ANSI));
        end;
      end;
      LJSON := TJSONObject.Create;
      LJSON.AddPair('Destinatario', UTF8Encode(edDestinatario.Text));
      LJSON.AddPair('Mensagem', UTF8Encode(edMensagem.Lines.Text));
      LJSON.AddPair('TituloMensagem', UTF8Encode(edAssunto.Text));
      LJSON.AddPair('IsHTML', TJSONBool.Create(False));
      LJSON.AddPair('Remetente', UTF8Encode(edRemetente.Text));
      LJSON.AddPair('DestinatariosCopia', UTF8Encode(''));
      LJSON.AddPair('DestinatariosCopiaOculta', UTF8Encode(''));
      LJSON.AddPair('UnidadeDR', 'null');
      LJSON.AddPair('TipoEpisodioDR', 'null');
      LJSON.AddPair('NomeArquivo', UTF8Encode(ExtractFileName(ArquivoCSV)));
      LJSON.AddPair('Base64', vRelatorioContent);
      LResposta := PostFromAPI(Url_EnviarEmailGenerico, LJSON);
    finally
      DeleteFile(ArquivoCSV);
      LJSON.Free;
      FreeAndNil(Base64);
    end;
    ShowMessage('Email enviado com sucesso!');
    Close;
  end
  else begin
    ShowMessage('Preencha os campos Remetente, Destinatário e Assunto');
  end;
end;

procedure TfrmExportarEmail.rectMaxClick(Sender: TObject);
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

procedure TfrmExportarEmail.SetArquivoCSV(const Value: String);
begin
  FArquivoCSV := Value;
end;

procedure TfrmExportarEmail.SetArquivoPDF(const Value: String);
begin
  FArquivoPDF := Value;
end;


procedure TfrmExportarEmail.SetDestinatario(const Value: String);
begin
  FDestinatario := Value;
end;

procedure TfrmExportarEmail.SetDestinatariosCopia(const Value: String);
begin
  FDestinatariosCopia := Value;
end;

procedure TfrmExportarEmail.SetDestinatariosCopiaOculta(const Value: String);
begin
  FDestinatariosCopiaOculta := Value;
end;

procedure TfrmExportarEmail.SetMensagem(const Value: String);
begin
  FMensagem := Value;
end;

procedure TfrmExportarEmail.SetRemetente(const Value: String);
begin
  FRemetente  := Value;
end;

procedure TfrmExportarEmail.SetTipoEpisodioDR(const Value: String);
begin
  FTipoEpisodioDR := Value;
end;

procedure TfrmExportarEmail.SetTituloMensagem(const Value: String);
begin
  FTituloMensagem := Value;
end;

procedure TfrmExportarEmail.SetUnidadeDR(const Value: String);
begin
  FUnidadeDR := Value;
end;

procedure TfrmExportarEmail.SetUrl_EnviarEmailGenerico(const Value: String);
begin
  FUrl_EnviarEmailGenerico := Value;
end;


procedure TfrmExportarEmail.btnCloseFormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportarEmail.FormCreate(Sender: TObject);
begin
  imgMax.Visible := True;
  imgRes.Visible := False;
end;

procedure TfrmExportarEmail.imgCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportarEmail.imgMaxClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsMaximized;
  imgMax.Visible := False;
  imgRes.Visible := True;
end;

procedure TfrmExportarEmail.imgResClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsNormal;
  imgMax.Visible := True;
  imgRes.Visible := False;
end;

function TfrmExportarEmail.PostFromAPI(AURL: String; AJson: TJSONObject; ATentivas: Integer = 1): string;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
begin
  TLog.MyLog('GetFromAPI (Tentativa ' + FTentativasApi.ToString + ') POST "' + AURL + '": ' + AJson.ToString, nil, 0, False, TCriticalLog.tlINFO);

  LStreamJson := TStringStream.Create(AJson.ToJSON);
  LStreamRes := TStringStream.Create;
  try
    try
      try

        THTTPRequest.Post(AURL, LStreamJson);
        Result := UTF8ToString(LStreamRes.DataString);
        FTentativasApi := 1;
        TLog.MyLog('GetFromAPI StatusCode ' + LStatusCode + ' POST Result "' + AURL + '": ' + Result, nil, 0, False, TCriticalLog.tlINFO);
      except
        if ATentivas > 1 then
        begin
          if FTentativasApi < ATentivas then
          begin
            inc(FTentativasApi);
            Sleep(2000);
            Result := PostFromAPI(AURL, AJson, ATentivas);
          end
          else if FTentativasApi >= ATentivas then
          begin
            FTentativasApi := 1;
            FErro := 2;
          end;
        end
        else
        begin
          Result:= '';
          FTentativasApi := 1;
          FErro := 2;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;



end.
