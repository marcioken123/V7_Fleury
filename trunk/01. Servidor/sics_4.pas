unit sics_4;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, MyDlls_DR,  ClassLibraryVCL,
  System.ImageList, Vcl.ImgList;

const
  IMG_OK      = 1;
  IMG_NOTOK   = 0;
  IMG_CONEXAO = 2;
  IMG_PA      = 2;
  IMG_ONLINE  = 3;
  IMG_TOTEM   = 4;
  IMG_PAINEL  = 5;
  IMG_TECLADO = 6;

type
  TfrmSicsConexoes = class(TForm)
    tvConexoes: TTreeView;
    ImageList1: TImageList;
    btnAtualizar: TBitBtn;
    btnFechar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    NodePasMultiPas: TTreeNode;
    NodeOnLineTGS: TTreeNode;
    NodePaineis: TTreeNode;
    NodeTotens: TTreeNode;
    NodeTeclados: TTreeNode;
  end;

var
  frmSicsConexoes: TfrmSicsConexoes;

implementation

uses
  sics_m;

{$R *.dfm}

procedure TfrmSicsConexoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmSicsConexoes.FormResize(Sender: TObject);
const
  OFF = 10;
begin
  tvConexoes.Left   := OFF;
  tvConexoes.Width  := ClientWidth - 2*OFF;
  tvConexoes.Top    := OFF;
  tvConexoes.Height := ClientHeight - btnAtualizar.Height - 3*OFF;

  btnAtualizar.Left := tvConexoes.Left;
  btnAtualizar.Top  := tvConexoes.Top + tvConexoes.Height + OFF;

  btnFechar.Left := ClientWidth - btnFechar.Width - OFF;
  btnFechar.Top  := btnAtualizar.Top;
end;


procedure TfrmSicsConexoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSicsConexoes.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
end;

procedure TfrmSicsConexoes.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);

  frmSicsConexoes := nil;
end;

procedure TfrmSicsConexoes.btnAtualizarClick(Sender: TObject);
begin
  frmSicsMain.CriarItemsFormConexoes;
end;

end.
