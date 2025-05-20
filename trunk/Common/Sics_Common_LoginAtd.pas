unit Sics_Common_LoginAtd;

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
  TfrmSicsCommon_LoginAtd = class(TForm)
    lblSenha: TAspLabel;
    AtdSenhaEdit: TEdit;
    OKBtn: TAspButton;
    CancelBtn: TAspButton;
    lblAtendente: TAspLabel;
    IdAtdEdit: TEdit;
    lblPA: TAspLabel;
    IdPAEdit: TEdit;
    PANomeCombo: TComboBox;
    AtdNomeCombo: TComboBox;
    procedure IdPAEditChange(Sender: TObject);
    procedure IdAtdEditChange(Sender: TObject);
    procedure PANomeComboChange(Sender: TObject);
    procedure AtdNomeComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizaListaDeAtendentes;
  end;

var
  frmSicsCommon_LoginAtd: TfrmSicsCommon_LoginAtd;

function GetAtdForLogin      (IdPA : integer; var IdAtd : integer) : boolean;
function GetAtdAndPAForLogin (var IdPA, IdAtd : integer) : boolean;

implementation

uses
untCommonDMClient,
Aspect;

{$R *.fmx}
{ %CLASSGROUP 'FMX.Controls.TControl' }

function GetAtdForLogin (IdPA : integer; var IdAtd : integer) : boolean;
const
  OFF = 10;
begin
  Result := false;
  IdAtd := -1;
  with frmSicsCommon_LoginAtd do
  begin
    IdPAEdit.Enabled    := false;
    PANomeCombo.Enabled := false;
    IdPAEdit.Text       := inttostr(IdPA);
    IdAtdEdit.Text      := '';
    AtdSenhaEdit.Text   := '';

    if IdPA = -1 then
    begin
      lblAtendente.Top := lblPA      .Top;
      IdAtdEdit   .Top := IdPAEdit   .Top;
      AtdNomeCombo.Top := PANomeCombo.Top;
    end
    else
    begin
      lblAtendente.Top := lblPA      .Top + lblPA      .Height + 2*OFF;
      IdAtdEdit   .Top := IdPAEdit   .Top + IdPAEdit   .Height + 2*OFF;
      AtdNomeCombo.Top := PANomeCombo.Top + PANomeCombo.Height + 2*OFF;
    end;

    lblSenha    .Top := lblAtendente.Top + lblAtendente.Height + OFF;
    AtdSenhaEdit.Top := IdAtdEdit   .Top + IdAtdEdit   .Height + OFF;
    OKBtn       .Top := AtdSenhaEdit.Top + AtdSenhaEdit.Height + 2*OFF;
    CancelBtn   .Top := OKBtn       .Top;
    ClientHeight     := Trunc(OKBtn       .Top + OKBtn.Height + OFF);

    lblPA      .Visible := (IdPA <> -1);
    IdPAEdit   .Visible := (IdPA <> -1);
    PANomeCombo.Visible := (IdPA <> -1);

    if ShowModal = mrOK then
    begin
      if DMClient.CheckAtdPswd (strtoint(IdAtdEdit.Text), AtdSenhaEdit.Text) then
      begin
        IdAtd := strtoint(IdAtdEdit.Text);
        Result := true;
      end
      else
        AppMessageBox('Senha não confere.', 'Atenção', MB_ICONWARNING);
    end;
  end;
end;

function GetAtdAndPAForLogin (var IdPA, IdAtd : integer) : boolean;
begin
  Result := false;
  IdPA  := -1;
  IdAtd := -1;
  with frmSicsCommon_LoginAtd do
  begin
    IdPAEdit.Enabled    := true;
    PANomeCombo.Enabled := true;
    IdPAEdit.Text       := '';
    IdAtdEdit.Text      := '';
    AtdSenhaEdit.Text   := '';
    if ShowModal = mrOK then
    begin
      if DMClient.CheckAtdPswd (strtoint(IdAtdEdit.Text), AtdSenhaEdit.Text) then
      begin
        IdPA  := strtoint(IdPAEdit.Text);
        IdAtd := strtoint(IdAtdEdit.Text);
        Result := true;
      end
      else
        AppMessageBox('Senha não confere.', 'Atenção', MB_ICONWARNING);
    end;
  end;
end;

procedure TfrmSicsCommon_LoginAtd.IdPAEditChange(Sender: TObject);
var
  i : integer;
  s : string;
begin
  OkBtn.Enabled := true;
  PANomeCombo.ItemIndex := -1;
  try
    if (Sender as TEdit).Text <> '' then
    begin
      s := DMClient.GetPANome(strtoint((Sender as TEdit).Text));
      for i := 0 to PANomeCombo.Items.Count - 1 do
        if PANomeCombo.Items[i] = s then
        begin
          PANomeCombo.ItemIndex := i;
          break;
        end;
    end  { if Sender.text <> '' }
    else
      OkBtn.Enabled := false;

    OkBtn.Enabled := (PANomeCombo.ItemIndex <> -1);
  except
    OkBtn.Enabled := false;
  end;
end;

procedure TfrmSicsCommon_LoginAtd.IdAtdEditChange(Sender: TObject);
var
  i : integer;
  s : string;
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

procedure TfrmSicsCommon_LoginAtd.PANomeComboChange(Sender: TObject);
begin
  if (Sender as TComboBox).ItemIndex <> -1 then
    IdPAEdit.Text := inttostr(DMClient.GetIdPA((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]));
end;


procedure TfrmSicsCommon_LoginAtd.AtdNomeComboChange(Sender: TObject);
begin
  if (Sender as TComboBox).ItemIndex <> -1 then
    IdAtdEdit.Text := inttostr(DMClient.GetIdAtd((Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]));
end;


procedure TfrmSicsCommon_LoginAtd.FormShow(Sender: TObject);
begin
  OkBtn.Enabled := false;
  if IdPAEdit.Enabled then
    IdPAEdit.SetFocus
  else
    IdAtdEdit.SetFocus;
end;


procedure TfrmSicsCommon_LoginAtd.AtualizaListaDeAtendentes;
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

