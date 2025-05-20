unit Sics_Common_LogoutAtd;

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
  TfrmSicsCommon_LogoutAtd = class(TForm)
    OKBtn: TAspButton;
    CancelBtn: TAspButton;
    NomeLabel: TAspLabel;
    IdAtdEdit: TEdit;
    AtdNomeCombo: TComboEdit;
    procedure IdAtdEditChange(Sender: TObject);
    procedure AtdNomeComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AtualizaListaDeAtendentes;
  end;

var
  frmSicsCommon_LogoutAtd: TfrmSicsCommon_LogoutAtd;

//function GetAtdForLogout (var IdAtd : integer) : boolean;

implementation



uses untCommonDMClient;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

//FMX COmentado para utilizar showmodal com procedure ModalResult
//function GetAtdForLogout (var IdAtd : integer) : boolean;
//begin
//  Result := false;
//  IdAtd := -1;
//  with frmSicsCommon_LogoutAtd do
  //begin
//    IdAtdEdit.Text := '';
//    ShowModal(
//      procedure (aResult: TModalResult)
//      begin
//        if aResult = mrOK then
//        begin
//          if AtdNomeCombo.ItemIndex >= 0 then
//          begin
//            IdAtd := strtoint(IdAtdEdit.Text);
//            Result := true;
//          end;
//        end;
////      end);
//  end;
//end;


procedure TfrmSicsCommon_LogoutAtd.IdAtdEditChange(Sender: TObject);
var
  i                     : integer;
  s                     : string;
begin
  OkBtn.Enabled := true;
  AtdNomeCombo.ItemIndex := -1;
  try
    if (Sender as TEdit).Text <> '' then
    begin
      s := DMClient.GetAtdNome(strtoint((Sender as TEdit).Text));
      for i := 0 to AtdNomeCombo.Items.Count - 1 do
        if AtdNomeCombo.Items[i] = s then
        begin
          AtdNomeCombo.ItemIndex := i;
          break;
        end;
    end  { if Sender.text <> '' }
    else
      OkBtn.Enabled := false;

    OkBtn.Enabled := (AtdNomeCombo.ItemIndex <> -1);
  except
    OkBtn.Enabled := false;
  end;
end;


procedure TfrmSicsCommon_LogoutAtd.AtdNomeComboChange(Sender: TObject);
begin
  if (Sender as TComboBox).ItemIndex <> -1 then
    IdAtdEdit.Text := inttostr(DMClient.GetIdAtd((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]));
end;


procedure TfrmSicsCommon_LogoutAtd.FormShow(Sender: TObject);
begin
  OkBtn.Enabled := false;
  if IdAtdEdit.Enabled then
    IdAtdEdit.SetFocus;
end;

procedure TfrmSicsCommon_LogoutAtd.AtualizaListaDeAtendentes;
begin
  AtdNomeCombo.Items.Clear;

  with DMClient.cdsAtendentes do
  begin
    First;
    while not eof do
    begin
      AtdNomeCombo.Items.Add(FieldByName('Nome').AsString);
      Next;
    end;
  end;
end;

end.

