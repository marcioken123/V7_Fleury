unit Sics_92;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MyDlls_DR,  MyAspFuncoesUteis_VCL,
  Dialogs, StdCtrls, ExtCtrls;

type
  TTipoDeInsercaoDeSenha = (isNova, isUltima, isNone);

  TfrmSicsGerarNovaSenhaOuUtilizarUltima = class(TForm)
    rgEscolha: TRadioGroup;
    lblPergunta: TLabel;
    btnOK: TButton;
    btnCancela: TButton;
    procedure rgEscolhaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GerarNovaSenhaOuManterUltima (senha : string) : TTipoDeInsercaoDeSenha;

implementation

{$R *.dfm}

function GerarNovaSenhaOuManterUltima (senha : string) : TTipoDeInsercaoDeSenha;
begin
  with TfrmSicsGerarNovaSenhaOuUtilizarUltima.Create(Application) do
  try
    BorderStyle := bsDialog;
    Result := isNone;
    lblPergunta.Caption := 'Você gostaria de criar uma nova senha ' + senha + ' ou trata-se da última que foi utilizada com este número?';
    rgEscolha.Items[0]  := 'Gerar nova senha ' + senha;
    rgEscolha.Items[1]  := 'Trata-se da última senha ' + senha + ' que foi utilizada';
    rgEscolha.ItemIndex := -1;
    if ShowModal = mrOk then
    begin
      if rgEscolha.ItemIndex = 0 then
        Result := isNova
      else
        Result := isUltima;
    end;
  finally
    Free;
  end;
end;


procedure TfrmSicsGerarNovaSenhaOuUtilizarUltima.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
end;

procedure TfrmSicsGerarNovaSenhaOuUtilizarUltima.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TfrmSicsGerarNovaSenhaOuUtilizarUltima.rgEscolhaClick(
  Sender: TObject);
begin
  btnOK.Enabled := rgEscolha.ItemIndex <> -1;
end;

end.
