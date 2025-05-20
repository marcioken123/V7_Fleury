unit untCommonFormBaseOnLineTGS;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  MyAspFuncoesUteis, FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,

  untCommonFrameBase, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,System.Json,
  Data.Bind.Grid, Data.Bind.DBScope, System.UIConsts,
  FMX.Menus, Sics_Common_Parametros,
  {$IFNDEF CompilarPara_TGS}
  APIs.Common,
  {$ENDIF}
  untCommonFormBase, FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.ListBox,
  FMX.Effects;

type
  TFrmBase_OnLine_TGS = class(TFrmBase)
    ilPrincipal: TImageList;
    lytMenu: TLayout;
    bndUnidade: TBindSourceDB;
    lytFrames: TLayout;
    lytLeft: TLayout;
    rectAbrirFechar: TRectangle;
    rectSeta: TRectangle;
    imgSetaAbrir: TImage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure imgSetaAbrirClick(Sender: TObject);
  private
    FLarguraMenu: Single;
    procedure GravaSituacaoMenu;
  protected
    FFrameAtivo: TFrameBase;
    FFirstActivate: Boolean;
    function ExibeFormPorUnidade(aFuncFormUnidade: Pointer) : TObject; Overload;
    procedure ExibeFormPorUnidade(LObjetoUnidade: TObject); Overload;
    procedure ForcarModoDesconectado; Override;
    function PodeFechar: Boolean;
    procedure SetIDUnidade(const Value: Integer); override;
    procedure SetModoConexaoAtual(const aIdUnidade: Integer;const Value: Boolean); override;
    function GetIsIndexOfFrame(const aCurrentIndex: Integer; const aClass: TClass): Boolean; Virtual; abstract;
    procedure TrocarUnidadeDoFormAtivo;
  public
    procedure CarregarParametrosINI; Override;
    procedure ExibirFrame(const aIndexItem: Integer); virtual; abstract;
    procedure ExibeSomenteOFrame(const aFrameAtual: TFrameBase; const aParentFrameNaoOculta: TFmxObject = nil); Virtual;
    procedure EncaminharSenhaFilaTriagem(const aSenha, aFilaTriagem: Integer;
      const aNomeTriagem: string = ''; aNomeImpressora: string = ''; aQtdImpressao: Integer = 0; aModeloImpressora: string = '');
    procedure OcultaTodosFrames(const aFrameAtual : TFrameBase; const aParentFrameNaoOculta: TFmxObject = nil ); virtual;
   	function GetSituacaoAtual: String; virtual;
   	function GetSituacaoAtualPA(Const aPA: Integer): String; virtual;
    procedure DefinirNomeParaSenha(const aIdUnidade, Senha: Integer; const Nome: string); Virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;

  end;

const
  INDEX_VAZIO = -1;
implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

uses
  untCommonDMConnection,
  untCommonFrameSituacaoAtendimento,
  untCommonFormProcessoParalelo,
  untCommonDMClient,
  untCommonFrameIndicadorPerformance,
  untCommonDMUnidades,
  System.IniFiles,
  APIs.Aspect.Sics.ImprimirEtiqueta, untCommonFormDadosAdicionais;

procedure TFrmBase_OnLine_TGS.CarregarParametrosINI;
begin
  inherited;
end;

constructor TFrmBase_OnLine_TGS.Create(AOwner: TComponent);
begin
  inherited;

  FFirstActivate := True;
end;

function TFrmBase_OnLine_TGS.PodeFechar: Boolean;
begin
  if vgParametrosModulo.JaEstaConfigurado then
    Result := vgParametrosModulo.PodeFecharPrograma
  else
    Result := true;
end;

procedure TFrmBase_OnLine_TGS.SetIDUnidade(const Value: Integer);
var
  LDMConnection: TDMConnection;
begin
  if (IDUnidade <> Value) then
  begin
    inherited;

    LDMConnection := DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
    if Assigned(LDMConnection) and (dmUnidades.FormClient = Self) then
      LDMConnection.Reconnectar(IDUnidade);

    if Self.Visible then
      TrocarUnidadeDoFormAtivo;
  end;
end;

procedure TFrmBase_OnLine_TGS.TrocarUnidadeDoFormAtivo;
begin
  if Assigned(FFrameAtivo) then
    FFrameAtivo.IDUnidade := IDUnidade;
end;

procedure TFrmBase_OnLine_TGS.SetModoConexaoAtual(const aIdUnidade: Integer;const Value: boolean);
begin
  inherited;

end;

procedure TFrmBase_OnLine_TGS.DefinirNomeParaSenha(const aIdUnidade, Senha: Integer; const Nome: string);
var
  LFraSituacaoAtendimento: TFraSituacaoAtendimento;
  LFrmProcessoParalelo: TFrmProcessoParalelo;
begin
  LFraSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
  if Assigned(LFraSituacaoAtendimento) then
    LFraSituacaoAtendimento.UpdateNomeCliente(Senha, Nome);

  LFrmProcessoParalelo := FrmProcessoParalelo(aIdUnidade);
  if Assigned(LFrmProcessoParalelo) then
    LFrmProcessoParalelo.UpdateNomeCliente(Senha, Nome);
end;


destructor TFrmBase_OnLine_TGS.Destroy;
begin

  inherited;
end;

procedure TFrmBase_OnLine_TGS.ForcarModoDesconectado;
begin
end;

procedure TFrmBase_OnLine_TGS.FormActivate(Sender: TObject);
begin
  inherited;
  FFirstActivate := False;
end;

procedure TFrmBase_OnLine_TGS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not PodeFechar then
    Action := TCloseAction.caNone
  else
    inherited;

  GravaSituacaoMenu;

  Application.Terminate;
end;

procedure TFrmBase_OnLine_TGS.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := PodeFechar;
  inherited;
end;

procedure TFrmBase_OnLine_TGS.FormShow(Sender: TObject);
begin
  inherited;
  CarregarParametrosDB;

  FLarguraMenu := lytLeft.Width;

  if(vgParametrosModulo.MenuEscondido)then
  begin
    lytLeft.Width := 15;
    imgSetaAbrir.RotationAngle := 0;
    lytMenu.Visible := False;
  end
  else
  begin
    lytLeft.Width := FLarguraMenu;
    imgSetaAbrir.RotationAngle := 180;
    lytMenu.Visible := True;
  end;
end;

function TFrmBase_OnLine_TGS.GetSituacaoAtual: String;
var
  LDMClient: TDMClient;
begin
  Result := '';
  LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    Result := GetSituacaoAtualPA(LDMClient.FCurrentPA);
end;

function TFrmBase_OnLine_TGS.GetSituacaoAtualPA(const aPA: Integer): String;
begin
  Result := '';
end;

procedure TFrmBase_OnLine_TGS.GravaSituacaoMenu;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(AspLib_GetAppIniFileName);
  try
   LIni.WriteBool('Settings', 'MenuEscondido'   , vgParametrosModulo.MenuEscondido);
  finally
   LIni.Free;
  end;
end;

procedure TFrmBase_OnLine_TGS.imgSetaAbrirClick(Sender: TObject);
begin
  if(lytLeft.Width = FLarguraMenu)then
  begin
    imgSetaAbrir.RotationAngle := 0;
    lytLeft.Width := 15;
    lytMenu.Visible := False;
    vgParametrosModulo.MenuEscondido := True;
  end
  else
  begin
    imgSetaAbrir.RotationAngle := 180;
    lytLeft.Width := FLarguraMenu;
    lytMenu.Visible := True;
    vgParametrosModulo.MenuEscondido := False;
  end;
end;

procedure TFrmBase_OnLine_TGS.OcultaTodosFrames(const aFrameAtual : TFrameBase; const aParentFrameNaoOculta: TFmxObject = nil);
  procedure OcultaFrame(aFrameOcultar, aFrameComparar: TFrameBase);
  begin
    if (Assigned(aFrameOcultar) and (aFrameComparar <> aFrameOcultar) and
     ((not Assigned(aParentFrameNaoOculta)) or (aParentFrameNaoOculta <> aFrameOcultar.Parent))) then
      aFrameOcultar.Visible := False;
  end;


  procedure OcultaForm(aFrameOcultar: TForm);
  begin
    if (Assigned(aFrameOcultar) and
     ((not Assigned(aParentFrameNaoOculta)) or (aParentFrameNaoOculta <> aFrameOcultar.Parent))) then
      aFrameOcultar.Visible := False;
  end;
var
  LChildren: TFMxObject;
begin
  if(lytFrames.Children = nil)then
  Exit;

  for LChildren in lytFrames.Children do
    begin
        try
          // Oculta frame diferente do frame atual
          if Assigned(LChildren) then
          begin
            if(LChildren is TFrame) then
              OcultaFrame(TFrameBase(LChildren), aFrameAtual)
            else
            if(LChildren is TForm) then
              OcultaForm(TForm(LChildren));
          end;
        except
          on E: Exception do
          begin
            if e.ClassType = EAbort then
              Continue
            else
              raise;
          end;
        end;
    end;
end;

function TFrmBase_OnLine_TGS.ExibeFormPorUnidade(aFuncFormUnidade: Pointer) : TObject;
var
  LObjetoUnidade: TObject;
begin
  LObjetoUnidade := TFuncFormUnidade(aFuncFormUnidade)(IDUnidade, CRIAR_SE_NAO_EXISTIR, Self);
  if(LObjetoUnidade <> nil) then
  begin
    if(LObjetoUnidade is TFOrm) then
      ExibeSomenteOFrame(nil, TFOrm(LObjetoUnidade))
    else if(LObjetoUnidade is TFrameBase) then
      ExibeSomenteOFrame(TFrameBase(LObjetoUnidade));
  end;
  Result := LObjetoUnidade;
end;

procedure TFrmBase_OnLine_TGS.ExibeFormPorUnidade(LObjetoUnidade: TObject);
begin
  if(LObjetoUnidade <> nil) then
  begin
    if(LObjetoUnidade is TFOrm) then
      ExibeSomenteOFrame(nil, TFOrm(LObjetoUnidade))
    else if(LObjetoUnidade is TFrameBase) then
      ExibeSomenteOFrame(TFrameBase(LObjetoUnidade));
  end;
end;

procedure TFrmBase_OnLine_TGS.ExibeSomenteOFrame(const aFrameAtual: TFrameBase; const aParentFrameNaoOculta: TFmxObject);

  procedure SetVisivelFrame(const aFrame: TFrameBase);
//  var
//    FProcOnClose: TProcOnHide;
  begin
    if Assigned(aFrame) then
    begin
      aFrame.Parent := lytFrames;
      aFrame.Align  := TAlignLayout.Client;

      aFrame.Visible := True;

      {$IFDEF CompilarPara_TGS_ONLINE}
      if aFrame is TFraIndicadorPerformance then
        with TFraIndicadorPerformance(aFrame) do
         PIsUpdateTimerTimer(PIsUpdateTimer);
      {$ENDIF}
    (* {$IFDEF CompilarPara_TGS}
      FProcOnClose := procedure (aSender: TObject)
        begin
          //and (GetIsIndexOfFrame(lstSubMenu.ItemIndex, aFrame.ClassType))
          if ((lstSubMenu <> nil) ) then
          begin
            lstSubMenu.ItemIndex := INDEX_VAZIO;
            lytSubMenu.Visible := False;
          end;
        end;
      aFrame.AddOnClose(FProcOnClose);
      {$ENDIF}*)
    end;
  end;

  procedure SetVisivelForm(const aFrame: TFmxObject);
  begin
    if (ASsigned(aFrame) and (aFrame is TForm)) then
      TForm(aFrame).Show;
  end;

begin
  try
    if not (Assigned(lytFrames) and (lytFrames.Children <> nil) and (lytFrames.ChildrenCount >0)) then
      Exit;

      OcultaTodosFrames(aFrameAtual,aParentFrameNaoOculta);

  finally
    SetVisivelFrame(aFrameAtual);
    SetVisivelForm(aParentFrameNaoOculta);
  end;
end;


procedure TFrmBase_OnLine_TGS.EncaminharSenhaFilaTriagem(const aSenha,
  aFilaTriagem: Integer;const aNomeTriagem: string = ''; aNomeImpressora: string = ''; aQtdImpressao: Integer = 0; aModeloImpressora: string = '');
begin
  {$IFNDEF CompilarPara_TGS}
  if (aFilaTriagem > 0) and (aSenha > 0) then
  begin
    ConfirmationMessage('Deseja encaminhar a senha ' + aSenha.ToString + ' para ' + aNomeTriagem,
      procedure (const aOK: Boolean)
      var
        LJson:TJSonObject;
        //LParametrosEntradaObterDadosAdicionais: APIs.Aspect.Sics.DadosAdicionais.TParametrosEntradaObterAPI;
        //LParametrosSaidaObterDadosAdicionais: APIs.Aspect.Sics.DadosAdicionais.TParametrosSaidaObterAPI;
        LParametrosEntradaImprimirEtiqueta : APIs.Aspect.Sics.ImprimirEtiqueta.TParametrosEntradaAPI;
        LErroAPI: APIs.Common.TErroAPI;
        LContinua: boolean;
        LIdTrakCare, LLocalParRef, LCodProfissional: string;
      begin
        if aOK then
        begin
          LContinua:= True;

          if vgParametrosModulo.EnviaEtiqueta then
          begin
            //LParametrosEntradaObterDadosAdicionais.SENHA := asenha.ToString;
            //LParametrosEntradaObterDadosAdicionais.IDUnidade := vgParametrosModulo.IdUnidadeCliente;

            with DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR) do
            begin
              //SolicitarDadosAdicionais(FCodPAAtual, aSenha.ToString, vgParametrosModulo.IdUnidadeCliente);

              EnviarComando(cProtocoloPAVazia + Chr($CD) + aSenha.ToString, IdUnidade);

              Application.ProcessMessages;

              LJson := FJSONDadosAdicionais;
            end;

            //if apis.Aspect.Sics.DadosAdicionais.ObterDados(LParametrosEntradaObterDadosAdicionais,LParametrosSaidaObterDadosAdicionais,LErroAPI) = raok then
            if LJson.TryGetValue('idtrakcare', LIdTrakCare) then
            begin
              LJson.TryGetValue('LOCALPARREF', LLocalParRef);
              LJson.TryGetValue('CODPROFISSIONAL', LCodProfissional);

              LParametrosEntradaImprimirEtiqueta.IdPassagem    := LIdTrakCare;
              LParametrosEntradaImprimirEtiqueta.Device        := vgParametrosModulo.NomeImpressoraEtiqueta;
              LParametrosEntradaImprimirEtiqueta.QtdeImpressao := vgParametrosModulo.QtdeImpressao;
              LParametrosEntradaImprimirEtiqueta.Etiqueta      := vgParametrosModulo.ModeloImpressora;
              LParametrosEntradaImprimirEtiqueta.LocalPArRef   := StrToIntDef(LLocalParRef, 0);
              LParametrosEntradaImprimirEtiqueta.IdMedico      := StrToIntDef(LCodProfissional, 0);

              if apis.Aspect.Sics.ImprimirEtiqueta.TAPIAspectSicsImprimirEtiqueta.Execute(LParametrosEntradaImprimirEtiqueta,LErroAPI) <> raOk then
              begin
                if MessageDlg('Falha ao imprimir a etiqueta.'+chr(13)+'Continuar o envio da senha?', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes,TMsgDlgBtn.mbNo], 0) = mrNo then
                begin
                  LContinua:= False;
                end;
              end;
            end;
          end;

          if LContinua then
          begin
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).InserirSenhaFila(aSenha, aFilaTriagem);
          end;
        end;
      end);
  end;
  {$ENDIF}
end;

end.
