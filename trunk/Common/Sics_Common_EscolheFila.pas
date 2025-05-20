unit Sics_Common_EscolheFila;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, AspLayout, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox, 
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  
  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, 
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, 
  AspFMXHelper, ClassLibrary, MyDlls_DX,  
  IniFiles, untCommonFormBase, untCommonFrameBase;

type
  TfrmSicsCommon_EscolheFila = class(TForm)
    OkBtn: TAspButton;
    CancelBtn: TAspButton;
    Label1: TAspLabel;
    listFilas: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure listFilasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure listFilasClick(Sender: TObject);
    procedure listFilasDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function InsertFila (IdFila : integer; Nome : string) : boolean;
  end;

var
  frmSicsCommon_EscolheFila: TfrmSicsCommon_EscolheFila;

function GetFila       (var Fx : integer) : boolean;
function IsAllowedFila (Fx : integer) : boolean;

implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

procedure InsertInList (List : TListView; Id, Nome : string);
begin
  with List do
  begin
    Items.Add;
    Items[Items.Count - 1].Caption := Id;
    Items[Items.Count - 1].SubItems.Add(Nome);
//    Items[Items.Count - 1].SubItems.Add(Grupo);
  end;  { with }
end;


function TfrmSicsCommon_EscolheFila.InsertFila (IdFila : integer; Nome : string) : boolean;
var
   i : integer;
   TemIgual : boolean;
begin
   { eduardo rocha - fazendo a insercao da fila ZERO neste ponto, antes estava no
     create do form, porem no metodo DecifraProtocolo do Sics_Common_DataModuleClientConnection
     tem um Clear na lista pra depois sim comecar a inserir, portanto, nesta perde a fila ZERO
     Deixando aqui garante que qualquer outro lugar que faça clear,
     na primeira inserção ja insere a fila ZERO
   }
   if listFilas.Items.Count = 0 then
     InsertInList(listFilas, '0', 'Nenhuma (finalizar atendimento)');

   Result := false;
   if not IsAllowedFila (IdFila) then
     Exit;

   with listFilas do
   begin
     TemIgual := false;
     i := 0;
     while i <= Items.Count - 1 do
     begin
       try
         if strtoint(Items[i].Caption) = IdFila then
         begin
           TemIgual := true;
           break;
         end;
         i := i + 1;
       except
         break;
       end;  { try .. except }
     end;  { while i }

     if not TemIgual then
       Items.Add;

     Items[i].Caption := inttostr(IdFila);
     Items[i].SubItems.Add(Nome);
   end; { with listFilas }
   Result := true;
end; {  func InsertFila }


procedure TfrmSicsCommon_EscolheFila.FormCreate(Sender: TObject);
begin

  LoadPosition(Sender as TForm);
end;  { proc FormCreate }


procedure TfrmSicsCommon_EscolheFila.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
end;  { proc FormDestroy }


procedure TfrmSicsCommon_EscolheFila.FormResize(Sender: TObject);
begin
  listFilas.Left   := 3;
  listFilas.Top    := Label1.Top + Label1.Height + 3;
  listFilas.Width  := ClientWidth - 6;
  listFilas.Height := ClientHeight - Label1.Height - OkBtn.Height - 12;

  listFilas.Columns[1].Width := listFilas.ClientWidth - listFilas.Columns[0].Width;

  OkBtn.Top      := ClientHeight - OkBtn.Height - 3;
  OkBtn.Left     := ClientWidth div 2 - OkBtn.Width - 3;
  CancelBtn.Top  := ClientHeight - OkBtn.Height - 3;
  CancelBtn.Left := ClientWidth div 2 + 3;
end;  { proc FormResize }


function GetFila (var Fx : integer) : boolean;
begin
  with frmSicsCommon_EscolheFila do
  try
    OkBtn.Enabled := false;
    if ShowModal = mrOk then
    begin
//      if ChooseFilaForm.NenhumaCheckBox.Checked then
//        Fx := 0
//      else
//        Fx := strtoint(frmCommon_EscolheFila.FilasGrid.Cells[0,frmCommon_EscolheFila.FilasGrid.Row]);
      Fx := strtoint(listFilas.Items[listFilas.ItemIndex].Caption);
      Result := true;
    end
    else
    begin
      Fx := 0;
      Result := false;
    end;
  except
    Result := false;
    Fx := 0;
  end;
end;  { func GetFila }


function IsAllowedFila (Fx : integer) : boolean;
begin
  Result := ( ExisteNoIntArray(Fx, ParametrosModulo.FilasPermitidas) or
              ExisteNoIntArray(0 , ParametrosModulo.FilasPermitidas)
            );
end;  { is AllowedFila }


procedure TfrmSicsCommon_EscolheFila.listFilasSelectItem (Sender: TObject;
                                              Item: TListItem; Selected: Boolean);
begin
  OkBtn.Enabled := (listFilas.ItemIndex <> -1);
end;

procedure TfrmSicsCommon_EscolheFila.listFilasClick(Sender: TObject);
begin
  OkBtn.Enabled := (listFilas.ItemIndex <> -1);
end;

procedure TfrmSicsCommon_EscolheFila.listFilasDblClick(Sender: TObject);
begin
  OkBtn.Click;
end;

end.
