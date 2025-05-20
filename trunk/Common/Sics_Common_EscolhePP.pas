unit Sics_Common_EscolhePP;

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
  TfrmSicsCommon_EscolhePP = class(TForm)
    Label1: TAspLabel;
    listPPs: TListView;
    OkBtn: TAspButton;
    CancelBtn: TAspButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure listPPsClick(Sender: TObject);
    procedure listPPsDblClick(Sender: TObject);
    procedure listPPsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
  public
    function InsertPP (IdPP : integer; Nome : string) : boolean;
  end;

var
  frmSicsCommon_EscolhePP : TfrmSicsCommon_EscolhePP;

function GetPP  (var IdPP : integer) : boolean;

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


function TfrmSicsCommon_EscolhePP.InsertPP (IdPP : integer; Nome : string) : boolean;
var
   i : integer;
   TemIgual : boolean;
begin
   with listPPs do
   try
     TemIgual := false;
     i := 0;
     while i <= Items.Count - 1 do
     begin
       try
         if strtoint(Items[i].Caption) = IdPP then
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

     Items[i].Caption := inttostr(IdPP);
     Items[i].SubItems.Add(Nome);
     Result := true;
   except
     Result := false;
   end; { with listPPs }
end; {  func InsertPP }


procedure TfrmSicsCommon_EscolhePP.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
end;  { proc FormCreate }


procedure TfrmSicsCommon_EscolhePP.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
end;  { proc FormDestroy }


procedure TfrmSicsCommon_EscolhePP.FormResize(Sender: TObject);
begin
  listPPs.Left   := 3;
  listPPs.Top    := Label1.Top + Label1.Height + 3;
  listPPs.Width  := ClientWidth - 6;
  listPPs.Height := ClientHeight - Label1.Height - OkBtn.Height - 12;

  listPPs.Columns[1].Width := listPPs.ClientWidth - listPPs.Columns[0].Width;

  OkBtn.Top      := ClientHeight - OkBtn.Height - 3;
  OkBtn.Left     := ClientWidth div 2 - OkBtn.Width - 3;
  CancelBtn.Top  := ClientHeight - OkBtn.Height - 3;
  CancelBtn.Left := ClientWidth div 2 + 3;
end;  { proc FormResize }


function GetPP (var IdPP : integer) : boolean;
begin
  with frmSicsCommon_EscolhePP do
  try
    OkBtn.Enabled := false;
    if ShowModal = mrOk then
    begin
      IdPP := strtoint(listPPs.Items[listPPs.ItemIndex].Caption);
      Result := true;
    end
    else
    begin
      IdPP := 0;
      Result := false;
    end;
  except
    Result := false;
    IdPP := 0;
  end;
end;  { func GetFila }

procedure TfrmSicsCommon_EscolhePP.listPPsClick(Sender: TObject);
begin
  OkBtn.Enabled := (listPPs.ItemIndex <> -1);
end;

procedure TfrmSicsCommon_EscolhePP.listPPsDblClick(Sender: TObject);
begin
  OkBtn.Click;
end;

procedure TfrmSicsCommon_EscolhePP.listPPsSelectItem (Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  OkBtn.Enabled := (listPPs.ItemIndex <> -1);
end;

end.
