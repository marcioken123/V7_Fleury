unit uNotificacaoPopup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Ani, FMX.Effects,
  FMX.Layouts;

type
  TNotificacaoPopup = class(TForm)
    lFechar: TLabel;
    lMensagem: TLabel;
    recTitulo: TRectangle;
    lTitulo: TLabel;
    recMensagem: TRectangle;
    TimerAutoClose: TTimer;
    GlowEffect1: TGlowEffect;
    lHoraRecebimento: TLabel;
    layBase: TLayout;
    timerShow: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormShow(Sender: TObject);
    procedure timerShowTimer(Sender: TObject);
  private
    FTitulo: String;
    FAnterior: TNotificacaoPopup;
    FProximo: TNotificacaoPopup;
    procedure SetTitulo(const Value: String);
    procedure UpdatePosition;
    procedure FecharPopupsDoMesmoIndicador(ANomeIndicador: String);
    procedure AnimarFechando;
  public
    property Titulo: String read FTitulo write SetTitulo;
    class var UltimoPopup: TNotificacaoPopup;
    class procedure Exibir(AMensagem, ATitulo: String; ACor: TAlphaColor;
      ASegundosAutoFechar: Integer; ANomeIndicador: String);
  end;

implementation

{$R *.fmx}

uses System.Generics.Collections;

procedure TNotificacaoPopup.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LProximo: TNotificacaoPopup;
begin
  Visible := False;
  LProximo := FProximo;

  //atualiza o encadeamento
  if TNotificacaoPopup.UltimoPopup = Self then
    TNotificacaoPopup.UltimoPopup := FAnterior;
  if Assigned(FAnterior) then
    FAnterior.FProximo := FProximo;
  if Assigned(FProximo) then
    FProximo.FAnterior := FAnterior;

  if Assigned(LProximo) then
    LProximo.UpdatePosition;

  Action := TCloseAction.caFree;
end;

procedure TNotificacaoPopup.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  TimerAutoClose.Enabled := False;
  lTitulo.Text := FTitulo;
end;

procedure TNotificacaoPopup.AnimarFechando;
begin
  TAnimator.AnimateFloatWait(layBase, 'opacity', 0, 0.2);
end;

procedure TNotificacaoPopup.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  AnimarFechando;
  Close;
end;

procedure TNotificacaoPopup.FormShow(Sender: TObject);
begin
  layBase.Align := TAlignLayout.None;
  layBase.Position.Y := Self.Height+1;
  timerShow.Enabled := True;
end;

procedure TNotificacaoPopup.SetTitulo(const Value: String);
begin
  FTitulo := Value;
  lTitulo.Text := FTitulo;
end;

procedure TNotificacaoPopup.UpdatePosition;
const
  INI_TOP = 10;
  ESP_HOR = 10;
  ESP_VER = 5;
var
  LTimerAtivo: Boolean;
begin
  LTimerAtivo := TimerAutoClose.Enabled;
  TimerAutoClose.Enabled := False;
  try
    if not Assigned(FAnterior) then //primeiro quadro
    begin
      Top := Screen.WorkAreaHeight - Height - ESP_VER;
      Left := Screen.WorkAreaWidth - (Width + ESP_HOR);
    end
    else
    begin
      //posiciona acima do anterior
      Top := FAnterior.Top - Height - ESP_VER;
      Left := FAnterior.Left;

      //se está passando da parte superior da tela, posiciona na coluna à esquerda
      if (Top < 0) then
      begin
        Top := Screen.WorkAreaHeight - Height - ESP_VER;
        Left := FAnterior.Left - (Width + ESP_HOR{*Tag});

        //se ao posicionar na cola à esquerda exceder o canto da tela, recomeça
        if Left < Screen.WorkAreaRect.Left then
        begin
          Tag := Tag + 1;
          Top := (Screen.WorkAreaHeight - Height) - (ESP_VER * Tag);
          Left := Screen.WorkAreaWidth - (Width + (ESP_HOR*Tag))
        end;
      end;
    end;

    if Assigned(FProximo) then
      FProximo.UpdatePosition;
  finally
    TimerAutoClose.Enabled := LTimerAtivo;
  end;
end;

procedure TNotificacaoPopup.FecharPopupsDoMesmoIndicador(ANomeIndicador: String);
var
  i: Integer;
  LForm: TNotificacaoPopup;
  LListaFormsFechar: TList<TNotificacaoPopup>;
begin
  LListaFormsFechar := TList<TNotificacaoPopup>.Create;
  try
    //recupera os forms que devem ser fechados
    for i := 0 to Screen.FormCount-1 do
      if Screen.Forms[i] is TNotificacaoPopup then
      begin
        LForm := TNotificacaoPopup(Screen.Forms[i]);
        if LForm.TagString = ANomeIndicador then
        begin
          try
            LForm.TimerAutoClose.Enabled := False;
            LListaFormsFechar.Add(LForm);
          except
            //o form pode ter sido fechado no instante em que sua referência
            //foi capturada
          end;
        end;
      end;

    //fecha os forms identificados com o mesmo nome de indicador
    while LListaFormsFechar.Count > 0 do
    begin
      //primeiro remove da lista para diminuir o RefCount, fechando em seguida
      LForm := LListaFormsFechar.Items[0];
      LListaFormsFechar.Delete(0);
      try
        LForm.AnimarFechando;
        LForm.Close;
      except
        //form pode já ter sido fechado/destruído por interação do usuário
      end;
    end;
  finally
    LListaFormsFechar.Free;
  end;
end;

class procedure TNotificacaoPopup.Exibir(AMensagem, ATitulo: String;
  ACor: TAlphaColor; ASegundosAutoFechar: Integer; ANomeIndicador: String);
var
  LForm: TNotificacaoPopup;
begin
  LForm := TNotificacaoPopup.Create(nil);

  LForm.FecharPopupsDoMesmoIndicador(ANomeIndicador);

  //A TagString do Form é usada para identificar de qual Indicador se refere
  //aquela notificação. Ao receber uma notificação do mesmo PI, a notificação
  //anterior é fechada, para não acumular alertas diferentes ref. ao mesmo PI
  LForm.TagString := ANomeIndicador;

  //A tag do form é usada para o posicionamento das notificações caso já tenham
  //sido exibidas tantas quantos caibam na tela. Neste momento o tag é incremen-
  //tado para que as novas notificações sobreponham parcialmente as anteriores.
  //Vide método UpdatePosition;
  LForm.Tag := 1;

  //tamanho
  LForm.Width := 201;
  LForm.Height := 130;

  //encadeamento e posicionamento da
  LForm.FAnterior := TNotificacaoPopup.UltimoPopup;
  if Assigned(LForm.FAnterior) then
  begin
    LForm.FAnterior.FProximo := LForm;
    LForm.Tag := LForm.FAnterior.Tag;
  end;
  LForm.FProximo := nil;
  TNotificacaoPopup.UltimoPopup := LForm;

  //posicionamento conforme encadeamento
  LForm.UpdatePosition;

  //mensagem, título e hora de recebimento
  LForm.lMensagem.Text := AMensagem;
  LForm.Titulo := ATitulo;
  LForm.recTitulo.Fill.Color := ACor;
  LForm.lHoraRecebimento.TExt := FormatDateTime('HH:NN:SS', Now);

  //Exibir o form e ativar o "auto-fechar"
  LForm.Show;
  if ASegundosAutoFechar > 0 then
  begin
    LForm.TimerAutoClose.Tag := ASegundosAutoFechar;
    LForm.TimerAutoClose.Enabled := True;
    LForm.TimerAutoClose.OnTimer(LForm.TimerAutoClose);
  end;
end;

procedure TNotificacaoPopup.TimerAutoCloseTimer(Sender: TObject);
begin
  if TimerAutoClose.Tag = 0 then
  begin
    TimerAutoClose.Enabled := False;
    AnimarFechando;
    Close;
  end
  else
  begin
    lTitulo.Text := FTitulo + ' (' + TimerAutoClose.Tag.ToString + ')';
    TimerAutoClose.Tag := TimerAutoClose.Tag - 1;
  end;
end;

procedure TNotificacaoPopup.timerShowTimer(Sender: TObject);
begin
  timerShow.Enabled := False;
  TAnimator.AnimateFloat(layBase, 'position.y', 0);
end;

end.
