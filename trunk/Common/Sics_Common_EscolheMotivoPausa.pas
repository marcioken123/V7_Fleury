unit Sics_Common_EscolheMotivoPausa;

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
  TfrmSicsCommon_EscolheMotivoPausa = class(TForm)
    Label1: TAspLabel;
    listMotivosPausa: TListView;
    OkBtn: TAspButton;
    CancelBtn: TAspButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure listMotivosPausaClick(Sender: TObject);
    procedure listMotivosPausaDblClick(Sender: TObject);
    procedure listMotivosPausaSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
  public
    function InsertMotivoPausa (IdMP : integer; Nome : string) : boolean;
  end;

var
  frmSicsCommon_EscolheMotivoPausa : TfrmSicsCommon_EscolheMotivoPausa;

function GetMotivoPausa  (var IdMP : integer) : boolean;

implementation

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

procedure InsertInList (List : TListView; Id, Nome : string);
begin

  with List do
  begin
    Items.Add;
    Items[Items.Count - 1].Caption := Id;

    Items[Items.Count - 1].Detail := Nome;
//    Items[Items.Count - 1].SubItems.Add(Grupo);
  end;  { with }
end;


function TfrmSicsCommon_EscolheMotivoPausa.InsertMotivoPausa (IdMP : integer; Nome : string) : boolean;
var
   i : integer;
   TemIgual : boolean;
begin
   with listMotivosPausa do
   try
     TemIgual := false;
     i := 0;
     while i <= Items.Count - 1 do
     begin
       try
         if strtoint(Items[i].Caption) = IdMP then
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

     Items[i].Caption := inttostr(IdMP);
    Items[i].Detail := Nome;
     Result := true;
   except
     Result := false;
   end; { with listMotivosPausa }
end; {  func InsertMotivoPausa }


procedure TfrmSicsCommon_EscolheMotivoPausa.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
end;  { proc FormCreate }


procedure TfrmSicsCommon_EscolheMotivoPausa.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
end;  { proc FormDestroy }


procedure TfrmSicsCommon_EscolheMotivoPausa.FormResize(Sender: TObject);
begin
  with listMotivosPausa do
  begin
    Left   := 3;
    Top    := Label1.Top + Label1.Height + 3;
    Width  := Parent.ClientWidth - 6;
    Height := Parent.ClientHeight - Label1.Height - OkBtn.Height - 12;

    Columns[1].Width := ClientWidth - Columns[0].Width;
  end;

  OkBtn.Top      := ClientHeight - OkBtn.Height - 3;
  OkBtn.Left     := ClientWidth div 2 - OkBtn.Width - 3;
  CancelBtn.Top  := ClientHeight - OkBtn.Height - 3;
  CancelBtn.Left := ClientWidth div 2 + 3;
end;  { proc FormResize }


function GetMotivoPausa (var IdMP : integer) : boolean;
begin
  with frmSicsCommon_EscolheMotivoPausa do
  try
    OkBtn.Enabled := false;
    if ShowModal = mrOk then
    begin
      IdMP := strtoint(listMotivosPausa.Items[listMotivosPausa.ItemIndex].Caption);
      Result := true;
    end
    else
    begin
      IdMP := 0;
      Result := false;
    end;
  except
    Result := false;
    IdMP := 0;
  end;
end;  { func GetMotivoPausa }


procedure TfrmSicsCommon_EscolheMotivoPausa.listMotivosPausaClick(Sender: TObject);
begin
  OkBtn.Enabled := (listMotivosPausa.ItemIndex <> -1);
end;


procedure TfrmSicsCommon_EscolheMotivoPausa.listMotivosPausaDblClick(Sender: TObject);
begin
  OkBtn.Click;
end;


procedure TfrmSicsCommon_EscolheMotivoPausa.listMotivosPausaSelectItem (Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  OkBtn.Enabled := (listMotivosPausa.ItemIndex <> -1);
end;

end.
