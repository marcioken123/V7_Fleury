unit ufrmPainelMsgConfig;
//Renomeado unit Sics_Common_MsgPainelEImpressora

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, AspLayout, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  untCommonFormBase, Data.Bind.Grid, Data.Bind.DBScope,
  AspFMXHelper, ClassLibrary,  udmSicsMain, 
  IniFiles, Data.FMTBcd, Soap.InvokeRegistry, FMX.ScrollBox, FMX.Memo,
  Soap.Rio, Soap.SOAPHTTPClient, Datasnap.Provider, FMX.Controls.Presentation,
  ;

const
  clPainelMsgFileName  = 'MensPain.cfg';
  clPrinterMsgFileName = 'MensPrnt.cfg';
  clPswdsMsgFileName   = 'MensPswd.cfg';

type
  TfrmPainelMsgConfig = class(TFrmBase)
    dbMemo: TMemo;
    OkBtn: TAspButton;
    CancelBtn: TAspButton;
    SaveBtn: TAspButton;
    OpenBtn: TAspButton;
    PainelLabel: TAspLabel;
    dblkpPainel: TComboBox;
    dblkpTotens: TComboBox;
    cboComandosPaineis: TComboBox;
    procedure MainMemoChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PainelComboChange(Sender: TObject);
  private
    { Private declarations }
    vlChanged : boolean;
    function GetArqNameFromCombo : string;
  public
    { Public declarations }
    OpenDialog1: TAspOpenDialog;
    SaveDialog1: TAspSaveDialog;
  	constructor Create(aOwer: TComponent); Override;
  end;
  
procedure NConfigPainelMsg(aOwner: TComponent; var IdPainel : integer; var p : string);
procedure ConfigPainelMsg(aOwner: TComponent; var p : string);
procedure ConfigPrinterMsg(aOwner: TComponent; var s : string);
procedure ConfigPswdsMsg(aOwner: TComponent; var s : string);
procedure LoadPainelMsg(aOwner: TComponent; var s : string);
procedure LoadPrinterMsg(aOwner: TComponent; var s : string);
procedure LoadPswdsMsg(aOwner: TComponent; var s : string);
procedure SetPainelMsg(aOwner: TComponent; s : string);
procedure SetPrinterMsg(aOwner: TComponent; s : string);
procedure SetPswdsMsg(aOwner: TComponent; s : string);

implementation

{$R *.fmx}

  
constructor TfrmPainelMsgConfig.Create(aOwer: TComponent);
begin
  inherited;
  SaveDialog1 := TAspSaveDialog.Create(Self);
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter := 'Arquivo texto|*.txt|Todos os arquivos|*.*';
  SaveDialog1.FilterIndex := 0;
  SaveDialog1.Options := [TAspSaveDialog.CreatofOverwritePrompt, TAspSaveDialog.CreatofHideReadOnly];
  SaveDialog1.Title := 'Salvar mensagem';
  
  OpenDialog1 := TAspOpenDialog.Create(Self);
  OpenDialog1.DefaultExt := 'txt';
  OpenDialog1.Filter := 'Arquivo texto|*.txt|Todos os arquivos|*.*';
  OpenDialog1.FilterIndex := 0;  
  OpenDialog1.Options := [TAspSaveDialog.CreatofHideReadOnly, TAspSaveDialog.CreatofPathMustExist, TAspSaveDialog.CreatofFileMustExist];
  OpenDialog1.Title := 'Abrir mensagem';
end;

function TfrmPainelMsgConfig.GetArqNameFromCombo : string;
begin
  if PainelCombo.ItemIndex = -1 then
    Result := vgDBDir{ApplicationPath} + '\MensPN.cfg'
  else
    Result := vgDBDir{ApplicationPath} + '\MensPN' + inttostr(PainelCombo.ItemIndex) + '.cfg';
end;


procedure TfrmPainelMsgConfig.PainelComboChange(Sender: TObject);
begin
  if FileExists (GetArqNameFromCombo) then
    MainMemo.Lines.LoadFromFile (GetArqNameFromCombo)
  else
    MainMemo.Clear;
end;


procedure NConfigPainelMsg (aOwner: TComponent; var IdPainel : integer; var p : string);
var
   MsgConfigForm : TfrmPainelMsgConfig;
begin
   //Result := false;
   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner, True);
   try
      with MsgConfigForm do
      begin
         PainelLabel.Visible := true;
         PainelCombo.Visible := true;
         Caption := 'Mensagem do Painel';
//         MainMemo.MaxLength := 2048;
         vlChanged := false;

         PainelCombo.Items.Clear;
         with SicsDataModule.cdsGruposDePaineis do
         begin
           First;
           while not eof do
           begin
             PainelCombo.Items.Add(FieldByName('Nome').AsString);
             Next;
           end;
         end;
         PainelCombo.ItemIndex := 0;
         PainelComboChange(PainelCombo);
		MsgConfigForm.ShowModal(
			procedure (aModalResult: TModalresult)
			begin
        if (aModalResult = mrOk) then
        begin
          IdPainel := PainelCombo.ItemIndex + 1;
          p := MainMemo.Text;
            MainMemo.Lines.SaveToFile (GetArqNameFromCombo);
            //Result := true;
        end;  { if ShowModal = OK }
        MsgConfigForm := nil;
			end);
      end;  { with MsgConfigForm }
   except
      FreeAndNil(MsgConfigForm);
	  raise;
   end;  { try .. finally }
end;  { func ConfigPainelMsg }


function ConfigPainelMsg(aOwner: TComponent; var p : string) : boolean;
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := ApplicationPath;
   while arqname[length(arqname)] = '\' do
      arqname := Copy(arqname, 1, length(arqname)-1);
   arqname := arqname + '\' + clPainelMsgFileName;

   Result := false;
   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner, True);
   try
      with MsgConfigForm do
      begin
         Caption := 'Mensagem do Painel';
         MainMemo.MaxLength := 2048;
         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;
         vlChanged := false;
		 MsgConfigForm.ShowModal(
			procedure (aModalResult: TModalresult)
			begin
        	  if (aModalResult = mrOk) then
        	  begin
        	    p := MainMemo.Text;{16bits -> MainMemo.GetTextBuf(p, GetTextLen + 1);}
        	    MainMemo.Lines.SaveToFile (arqname);
        	  end;
        MsgConfigForm := nil;
			end);
      end; 
   except
      FreeAndNil(MsgConfigForm);
	  raise;
   end;  { try .. finally }
end;  { func ConfigPainelMsg }


procedure ConfigPrinterMsg(aOwner: TComponent; var s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPrinterMsgFileName;

   Result := false;
   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner, True);
   try
      with MsgConfigForm do
      begin
         Caption := 'Mensagem da Impressora';
//         MainMemo.MaxLength := 240;

         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;

         vlChanged := false;
		 MsgConfigForm.ShowModal(
			procedure (aModalResult: TModalresult)
			begin
        	  if ((aModalResult = mrOk) and (vlChanged)) then
        	  begin
                s := MainMemo.Text;
                MainMemo.Lines.SaveToFile (arqname);
              end;  { if ShowModal = OK }
        MsgConfigForm := nil;
			end);
      end;  { with MsgConfigForm }
   except
      FreeAndNil(MsgConfigForm);
	  raise;
   end;  { try .. finally }
end;  { func ConfigPrinterMsg }


procedure ConfigPswdsMsg(aOwner: TComponent; var s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPswdsMsgFileName;

   Result := false;
   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner, True);
   try
      with MsgConfigForm do
      begin
         Caption := 'Mensagem de chamada de senhas';
         MainMemo.MaxLength := 240;
         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;
         vlChanged := false;
		 MsgConfigForm.ShowModal(
			procedure (aModalResult: TModalresult)
			begin
				if ((aModalResult = mrOk) and (vlChanged)) then
				begin
					s := MainMemo.Text;
					MainMemo.Lines.SaveToFile (arqname);
				end;  { if ShowModal = OK }
        MsgConfigForm := nil;
		 end);
      end;  { with MsgConfigForm }
   except
      FreeAndNil(MsgConfigForm);
	  raise;
   end;  { try .. finally }
end;  { func ConfigPswdsMsg }
{$ENDIF NEXTGEN} 


procedure LoadPainelMsg(aOwner: TComponent; var s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := ApplicationPath;
   while arqname[length(arqname)] = '\' do
      arqname := Copy(arqname, 1, length(arqname)-1);
   arqname := arqname + '\' + clPainelMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;
         s := MainMemo.Text;
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func LoadPainelMsg }


procedure LoadPrinterMsg(aOwner: TComponent; var s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPrinterMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         MainMemo.MaxLength := 240;
         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;
         s := MainMemo.Text;
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func LoadPrinterMsg }


procedure LoadPswdsMsg(aOwner: TComponent; var s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPswdsMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         MainMemo.MaxLength := 240;
         if FileExists (arqname) then
            MainMemo.Lines.LoadFromFile (arqname)
         else
            MainMemo.Clear;
         s := MainMemo.Text;
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func LoadPswdsMsg }


procedure SetPainelMsg(aOwner: TComponent; s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := ApplicationPath;
   while arqname[length(arqname)] = '\' do
      arqname := Copy(arqname, 1, length(arqname)-1);
   arqname := arqname + '\' + clPainelMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         MainMemo.Clear;
         MainMemo.Text := s;
         MainMemo.Lines.SaveToFile (arqname);
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func SetPainelMsg }


procedure SetPrinterMsg(aOwner: TComponent; s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPrinterMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         MainMemo.Clear;
         MainMemo.Text := s;
         MainMemo.Lines.SaveToFile (arqname);
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func SetPrinterMsg }


procedure SetPswdsMsg(aOwner: TComponent; s : string);
var
   MsgConfigForm: TfrmPainelMsgConfig;
   arqname : string;
begin
   arqname := vgDBDir + '\' + clPswdsMsgFileName;

   MsgConfigForm := TfrmPainelMsgConfig.Create(aOwner);
   try
      with MsgConfigForm do
      begin
         MainMemo.Clear;
         MainMemo.Text := s;
         MainMemo.Lines.SaveToFile (arqname);
      end;  { with MsgConfigForm }
   finally
      FreeAndNil(MsgConfigForm);
   end;  { try .. finally }
end;  { func SetPswdsMsg }



procedure TfrmPainelMsgConfig.MainMemoChange(Sender: TObject);
begin
   vlChanged := true;
end;

procedure TfrmPainelMsgConfig.FormResize(Sender: TObject);
begin
  inherited;
  MainMemo.Left   := 5;
  MainMemo.Top    := 5;
  MainMemo.Width  := ClientWidth  - 10;
  MainMemo.Height := ClientHeight - OkBtn.Height - 15;

  OpenBtn.Left     := 5;
  OpenBtn.Top      := ClientHeight - OpenBtn.Height - 5;
  SaveBtn.Left     := OpenBtn.Left + OpenBtn.Width + 5;
  SaveBtn.Top      := OpenBtn.Top;
  OkBtn.Left       := ClientWidth - CancelBtn.Width - OkBtn.Width - 10;
  OkBtn.Top        := OpenBtn.Top;
  CancelBtn.Left   := ClientWidth - CancelBtn.Width - 5;
  CancelBtn.Top    := OpenBtn.Top;
  PainelLabel.Left := SaveBtn.Left + SaveBtn.Width  + 10;
  PainelLabel.Top  := OpenBtn.Top;
  PainelCombo.Left := PainelLabel.Left + PainelLabel.Width + 5;
  PainelCombo.Top  := OpenBtn.Top;
end;  { proc FormResize }


procedure TfrmPainelMsgConfig.OpenBtnClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    MainMemo.Lines.Clear;
    MainMemo.Lines.LoadFromFile (OpenDialog1.FileName);
  end;  { if }
end;  { OpenBtn.Click }


procedure TfrmPainelMsgConfig.SaveBtnClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    MainMemo.Lines.SaveToFile (SaveDialog1.FileName);
end;  { SaveBtn.Click }


end.
