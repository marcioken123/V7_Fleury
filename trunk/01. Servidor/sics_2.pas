unit sics_2;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Sics_91, Sics_94,
  MyDlls_DR,
  ComCtrls, DB, DBClient, DBGrids, ExtCtrls, IniFiles, System.Actions,
  Vcl.ActnList, uDataSetHelper, Vcl.Grids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Datasnap.Provider;

type
  TfrmSicsSituacaoAtendimento = class(TForm)
    CloseButton: TBitBtn;
    FinalizarAtendimentoButton: TButton;
    cdsPAs: TClientDataSet;
    dsPAs: TDataSource;
    cdsPAsId_PA: TIntegerField;
    cdsPAsId_Atd: TIntegerField;
    cdsPAsId_Senha: TIntegerField;
    cdsPAsHorario: TSQLTimeStampField;
    cdsPAsLKUP_PA: TStringField;
    cdsPAsLKUP_ATD: TStringField;
    cdsPAsSENHA: TIntegerField;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    gridPAs: TDBGrid;
    cdsPAsId_Fila: TIntegerField;
    cdsPAsLKUP_FILA: TStringField;
    cdsAtds: TClientDataSet;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    DateTimeField1: TSQLTimeStampField;
    IntegerField4: TIntegerField;
    dsAtds: TDataSource;
    gridAtds: TDBGrid;
    cdsAtdsLKUP_ATD: TStringField;
    cdsAtdsLKUP_PA: TStringField;
    cdsAtdsLKUP_ID_GRUPO: TIntegerField;
    cdsAtdsLKUP_GRUPO: TStringField;
    cdsPAsLKUP_ID_GRUPO: TIntegerField;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsAtdsId_Fila: TIntegerField;
    cdsAtdsLKUP_FILA: TStringField;
    TimerVerificarTimeOutPAS: TTimer;
    cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    cdsPAsAtivo: TStringField;
    cdsClonePAs: TClientDataSet;
    cdsCloneATDs: TClientDataSet;
    cdsPAsNomeCliente: TStringField;
    cdsAtdsNomeCliente: TStringField;
    cdsPAsId_Status: TIntegerField;
    cdsPAsId_MotivoPausa: TIntegerField;
    cdsPAsLKUP_MOTIVOPAUSA: TStringField;
    cdsAtdsId_Status: TIntegerField;
    cdsAtdsId_MotivoPausa: TIntegerField;
    cdsAtdsLKUP_STATUS: TStringField;
    cdsAtdsLKUP_MOTIVOPAUSA: TStringField;
    cdsPAsLKUP_STATUS: TStringField;
    cdsPAsPOSICAO: TIntegerField;
    cdsPAsDisponiveisComChamadaAutomatica: TClientDataSet;
    ActionList1: TActionList;
    cdsAtdsHorarioLogin: TSQLTimeStampField;
    cdsPAsHorarioLogin: TSQLTimeStampField;
    cdsAtdsID: TIntegerField;
    cdsPAsID: TIntegerField;
    cdsAtdsID_UNIDADE: TIntegerField;
    cdsPAsID_UNIDADE: TIntegerField;
    dspAtendPAs: TDataSetProvider;
    qryAtendPAs: TFDQuery;
    qryAtendPAsID_UNIDADE: TIntegerField;
    qryAtendPAsID: TIntegerField;
    qryAtendPAsID_PA: TIntegerField;
    qryAtendPAsID_STATUS: TIntegerField;
    qryAtendPAsID_ATD: TIntegerField;
    qryAtendPAsID_SENHA: TIntegerField;
    qryAtendPAsSENHA: TIntegerField;
    qryAtendPAsNOMECLIENTE: TStringField;
    qryAtendPAsHORARIO: TSQLTimeStampField;
    qryAtendPAsID_FILA: TIntegerField;
    qryAtendPAsID_MOTIVOPAUSA: TIntegerField;
    qryAtendPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    qryAtendPAsATIVO: TStringField;
    qryAtendPAsPOSICAO: TIntegerField;
    qryAtendPAsHORARIOLOGIN: TSQLTimeStampField;
    dspAtendAtds: TDataSetProvider;
    qryAtendAtds: TFDQuery;
    qryAtendAtdsID_UNIDADE: TIntegerField;
    qryAtendAtdsID: TIntegerField;
    qryAtendAtdsID_ATD: TIntegerField;
    qryAtendAtdsID_STATUS: TIntegerField;
    qryAtendAtdsID_PA: TIntegerField;
    qryAtendAtdsID_SENHA: TIntegerField;
    qryAtendAtdsSENHA: TIntegerField;
    qryAtendAtdsNOMECLIENTE: TStringField;
    qryAtendAtdsHORARIO: TSQLTimeStampField;
    qryAtendAtdsID_FILA: TIntegerField;
    qryAtendAtdsID_MOTIVOPAUSA: TIntegerField;
    qryAtendAtdsHORARIOLOGIN: TSQLTimeStampField;
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerVerificarTimeOutPASTimer(Sender: TObject);
    procedure cdsPAsAfterOpen(DataSet: TDataSet);
    procedure cdsAtdsAfterOpen(DataSet: TDataSet);
    procedure cdsAtdsBeforePost(DataSet: TDataSet);
    procedure cdsAtdsReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure dsPAsDataChange(Sender: TObject; Field: TField);
    procedure cdsPAsBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function LoginAtd  (Atd, PA    : integer) : boolean;
    function LogoutAtd (Atd        : integer) : boolean;
    function LogoutPA  (PA         : integer) : boolean;
    function SetPausa  (PA, Motivo : integer) : boolean;
    function UnSetPausa(PA         : integer) : boolean;

    function GetAtendenteEstaLogado(const aIDAtd: Integer; var aIdPA: Integer): Boolean;
    function GetPAEstaAtiva(const aIDAtd: Integer): Boolean;

    procedure GetPASituation(PA: Integer; var Status: TStatusPA; var Atd: Integer; var PWD: string; var FilaProveniente: Integer; var MotivoDaPausa: Integer; var TIM: TDateTime);
    procedure UpdatePASituation(PA: Integer; PWD: string; FilaProveniente: Integer; TIM: TDateTime);
    procedure UpdateNomeDoCliente(Senha: Integer; Nome: string);
    procedure AtualizaListaDeAtendentes;
    procedure VerificarTimeOutPAS;
    procedure AtualizarCdsAtendentes(ACdsOrigem: TClientDataSet);
    //LM
    procedure AtualizarCdsPAs(ACdsOrigem: TClientDataSet);

  end;

var
  frmSicsSituacaoAtendimento: TfrmSicsSituacaoAtendimento;

implementation

uses
  Sics_m, Sics_dm, ASPGenerator;

{$R *.DFM}

function TfrmSicsSituacaoAtendimento.LoginAtd (Atd, PA : integer) : boolean;
var
  nowtime          : TDateTime;
  BM               : TBookmark;
  AtualizarClients : boolean;
begin
  Result := false;
  AtualizarClients := false;
  try
    nowtime := now;

    with cdsPAs do
    begin
      BM := GetBookmark;
      try
        if ((Locate('ID_ATD', Atd, [])) and (FieldByName('ID_PA').AsInteger <> PA)) then
          LogoutAtd(Atd);

        if ((Locate('ID_PA', PA, [])) and (not FieldByName('ID_ATD').IsNull)) then
        begin
          if FieldByName('ID_ATD').AsInteger <> Atd then
            LogoutAtd(FieldByName('ID_ATD').AsInteger)
          else
            Exit;
        end;

        if Locate('ID_PA', PA, []) then
        begin
          Edit;

          if Atd = -1 then
          begin
            FieldByName('ID_ATD'   ).Clear;
            FieldByName('ID_STATUS').AsInteger := ord(spDeslogado);
          end
          else
          begin
            FieldByName('ID_ATD'   ).AsInteger  := ATD;
            FieldByName('ID_STATUS').AsInteger := ord(spDisponivel);
          end;
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;  //NÃO TINHA, COLOQUEI EM 14/05/2010. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('NOMECLIENTE'   ).Clear;  //NÃO TINHA, COLOQUEI EM 31/12/2013. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('HORARIO'       ).AsDateTime := nowtime;
          FieldByName('HORARIOLOGIN'  ).AsDateTime := nowtime; //ACG - 24/07/2018

          Post;

          //Salvar e enviar para todos aqui
          AtualizarClients := true;

          Result := true;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    if Atd <> -1 then
      with cdsAtds do
      begin
        BM := GetBookmark;
        try
          if Locate('ID_ATD', ATD, []) then
          begin
            Edit;

            FieldByName('ID_PA'         ).AsInteger  := PA;
            FieldByName('ID_STATUS'     ).AsInteger := ord(spDisponivel);
            FieldByName('SENHA'         ).Clear;
            FieldByName('Id_Fila'       ).Clear;  //NÃO TINHA, COLOQUEI EM 14/05/2010. VERIFICAR SE PRECISAVA OU NÃO.
            FieldByName('ID_MOTIVOPAUSA').Clear;
            FieldByName('NOMECLIENTE'   ).Clear;  //NÃO TINHA, COLOQUEI EM 31/12/2013. VERIFICAR SE PRECISAVA OU NÃO.
            FieldByName('HORARIO'       ).AsDateTime := nowtime;
            FieldByName('HORARIOLOGIN'  ).AsDateTime := nowtime; //ACG - 24/07/2018
            Post;
          end;
        finally
          GotoBookmark(BM);
          FreeBookmark(BM);
        end;
      end;  // with cds

    if AtualizarClients then
    begin
      frmSicsMain.SalvaSituacao_Atendimento;
      frmSicsMain.AtualizaSituacaoPA(PA);
    end;
  except
    Result := false;
  end;  { try .. except }
end;


function TfrmSicsSituacaoAtendimento.LogoutAtd (Atd : integer) : boolean;
var
  nowtime          : TDateTime;
  BM               : TBookmark;
  AtualizarClients : Boolean;
  PA               : Integer;
//  IdStatus : Integer;
begin
  Result := false;
  AtualizarClients := false;
  try
    nowtime := now;

    with cdsPAs do
    begin
      BM := GetBookmark;
      try
//        IdStatus := FieldByName('ID_STATUS').AsInteger;
        if ((Locate('ID_ATD', ATD, [])) and (TStatusPA(FieldByName('ID_STATUS').AsInteger) = spEmPausa)) then
          RegistraEvento (ord(teEmPausa), ATD, FieldByName('ID_PA').AsInteger, -1, FieldByName('ID_MOTIVOPAUSA').AsInteger, -1, FieldByName('HORARIO').AsDateTime, NowTime)
        else if ((Locate('ID_ATD', ATD, [])) and (not FieldByName('SENHA').IsNull)) then
        begin
          SomenteRedirecionar := True;
          frmSicsMain.Finaliza(FieldByName('ID_PA').AsInteger);   //MELHOR ENCAMINHAR PARA FILA ZERO??
          SomenteRedirecionar := False;
        end;

        if ((Locate('ID_ATD', ATD, [])) and (not FieldByName('HORARIOLOGIN').IsNull)) then
          RegistraEvento (ord(teLogado), ATD, FieldByName('ID_PA').AsInteger, -1, -1, -1, FieldByName('HORARIOLOGIN').AsDateTime, NowTime);

        if Locate('ID_ATD', ATD, []) then
        begin
          Edit;

          FieldByName('ID_ATD'        ).Clear;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spDeslogado);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;  //NÃO TINHA, COLOQUEI EM 14/05/2010. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('NOMECLIENTE'   ).Clear;  //NÃO TINHA, COLOQUEI EM 31/12/2013. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('HORARIO'       ).AsDateTime := nowtime;

          Post;

          //Salvar e enviar para todos aqui
          PA := FieldByName('ID_PA').AsInteger;
          AtualizarClients := true;
          Result := true;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    with cdsAtds do
    begin
      BM := GetBookmark;
      try
        if Locate('ID_ATD', ATD, []) then
        begin
          Edit;

          FieldByName('ID_PA'         ).Clear;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spDeslogado);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;  //NÃO TINHA, COLOQUEI EM 14/05/2010. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('NOMECLIENTE'   ).Clear;  //NÃO TINHA, COLOQUEI EM 31/12/2013. VERIFICAR SE PRECISAVA OU NÃO.
          FieldByName('HORARIO'       ).AsDateTime := nowtime;

          Post;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds


    if AtualizarClients then
    begin
      PA := 0;
      frmSicsMain.SalvaSituacao_Atendimento;
      frmSicsMain.AtualizaSituacaoPA(PA);
    end;
  except
    Result := false;
  end;  { try .. except }
end;

function TfrmSicsSituacaoAtendimento.LogoutPA (PA : integer) : boolean;
var
  BM     : TBookmark;
begin
  Result := false;
  try
    with cdsPAs do
    begin
      BM := GetBookmark;
      try
        if ((Locate('ID_PA', PA, [])) and (not FieldByName('ID_ATD').IsNull)) then
          Result := LogoutAtd (FieldByName('ID_ATD').AsInteger);
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds
  except
    Result := false;
  end;  { try .. except }
end;


function TfrmSicsSituacaoAtendimento.SetPausa  (PA, Motivo : integer) : boolean;
var
  nowtime          : TDateTime;
  BM               : TBookmark;
  AtualizarClients : boolean;
begin
  Result := false;
  AtualizarClients := false;
  try
    nowtime := now;
    with cdsAtds do
    begin
      BM := GetBookmark;
      try
        if Locate('ID_PA', PA, []) then
        begin
          Edit;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spEmPausa);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;
          FieldByName('ID_MOTIVOPAUSA').AsInteger := Motivo;
          FieldByName('NOMECLIENTE'   ).Clear;
          FieldByName('HORARIO'       ).AsDateTime := nowtime;
          Post;
        end
        else
        begin
          Result := False;
          exit;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    with cdsPAs do
    begin
      BM := GetBookmark;
      try

        if Locate('ID_PA', PA, []) then
        begin
          Edit;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spEmPausa);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;
          FieldByName('ID_MOTIVOPAUSA').AsInteger := Motivo;
          FieldByName('NOMECLIENTE'   ).Clear;
          FieldByName('HORARIO'       ).AsDateTime := nowtime;
          Post;

          //Salvar e enviar para todos aqui
          AtualizarClients := true;

          Result := true;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    if AtualizarClients then
    begin
      frmSicsMain.SalvaSituacao_Atendimento;
      frmSicsMain.AtualizaSituacaoPA(PA);
    end;
  except
    Result := false;
  end;  { try .. except }
end;  // func SetPausa


function TfrmSicsSituacaoAtendimento.UnSetPausa(PA: integer): boolean;
var
  nowtime          : TDateTime;
  BM               : TBookmark;
  AtualizarClients : boolean;
begin
  Result := false;
  AtualizarClients := false;
  try
    nowtime := now;

    with cdsPAs do
    begin
      BM := GetBookmark;
      try
        if Locate('ID_PA', PA, []) then
          case TStatusPA(FieldByName('ID_STATUS').AsInteger) of
            spDeslogado     : exit;
            spEmAtendimento : ;//Não faz nada
            spEmPausa       : RegistraEvento (ord(teEmPausa), FieldByName('ID_ATD').AsInteger, PA, -1, FieldByName('ID_MOTIVOPAUSA').AsInteger, -1, FieldByName('HORARIO').AsDateTime, NowTime);
            spDisponivel    : ;//Não faz nada
          end;

        if Locate('ID_PA', PA, []) then
        begin
          Edit;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spDisponivel);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('NOMECLIENTE'   ).Clear;
          FieldByName('HORARIO'       ).AsDateTime := nowtime;
          Post;

          //Salvar e enviar para todos aqui
          AtualizarClients := true;

          Result := true;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    with cdsAtds do
    begin
      BM := GetBookmark;
      try
        if Locate('ID_PA', PA, []) then
        begin
          Edit;
          FieldByName('ID_STATUS'     ).AsInteger := ord(spDisponivel);
          FieldByName('SENHA'         ).Clear;
          FieldByName('Id_Fila'       ).Clear;
          FieldByName('ID_MOTIVOPAUSA').Clear;
          FieldByName('NOMECLIENTE'   ).Clear;
          FieldByName('HORARIO'       ).AsDateTime := nowtime;
          Post;
        end;
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    if AtualizarClients then
    begin
      frmSicsMain.SalvaSituacao_Atendimento;
      frmSicsMain.AtualizaSituacaoPA(PA);
    end;
  except
    Result := false;
  end;  { try .. except }
end;  // func UnSetPausa


function TfrmSicsSituacaoAtendimento.GetPAEstaAtiva(const aIDAtd: Integer): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  if not cdsPAs.Active then
    Exit;

  BM := cdsPAs.GetBookmark;
  try
    try
      cdsPAs.First;
      while not cdsPAs.Eof do
      begin
        Result := cdsPAs.FieldByName('ID_STATUS').AsInteger <> ord(spDeslogado);;
        if Result then
          Break;

        cdsPAs.Next;
      end;
    finally
      if cdsPAs.BookmarkValid(BM) then
        cdsPAs.GotoBookmark(BM);
    end;
  finally
    cdsPAs.FreeBookmark(BM);
  end;
end;

procedure TfrmSicsSituacaoAtendimento.GetPASituation(PA: Integer; var Status: TStatusPA; var Atd: Integer; var PWD: string; var FilaProveniente: Integer;
  var MotivoDaPausa: Integer; var TIM: TDateTime);
var
  BM: TBookmark;
begin
  Status          := spDeslogado;
  Atd             := -1;
  FilaProveniente := -1;
  MotivoDaPausa   := -1;
  PWD             := '---';
  TIM             := EncodeDate(1, 1, 1);

  with cdsClonePAs do
  begin
    BM := GetBookmark;
    try
      if Locate('ID_PA', PA, []) then
      begin
        if not FieldByName('ID_STATUS').IsNull then
          Status := TStatusPA(FieldByName('ID_STATUS').AsInteger);

        if not FieldByName('ID_ATD').IsNull then
          Atd := FieldByName('ID_ATD').AsInteger;

        if not FieldByName('SENHA').IsNull then
          PWD := FieldByName('SENHA').AsString;

        if not FieldByName('ID_FILA').IsNull then
          FilaProveniente := FieldByName('ID_FILA').AsInteger;

        if not FieldByName('ID_MOTIVOPAUSA').IsNull then
          MotivoDaPausa := FieldByName('ID_MOTIVOPAUSA').AsInteger;

        if not FieldByName('HORARIO').IsNull then
          TIM := FieldByName('HORARIO').AsDateTime;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds
end;

procedure TfrmSicsSituacaoAtendimento.UpdatePASituation(PA: Integer; PWD: string; FilaProveniente: Integer; TIM: TDateTime);
var
  BM: TBookmark;
begin
  with cdsClonePAs do
  begin
    BM := GetBookmark;
    try
      if Locate('ID_PA', PA, []) then
      begin
        Edit;

        if ((PWD = '-1') or (PWD = '---')) then
        begin
          FieldByName('ID_STATUS').AsInteger := ord(spDisponivel);
          FieldByName('SENHA').Clear;
          FieldByName('NomeCliente').Clear;
        end
        else
        begin
          FieldByName('ID_STATUS').AsInteger  := ord(spEmAtendimento);
          FieldByName('SENHA').AsString       := PWD;
          FieldByName('NomeCliente').AsString := frmSicsMain.GetNomeParaSenha(strtoint(PWD));
        end;

        if FilaProveniente = -1 then
          FieldByName('ID_FILA').Clear
        else
          FieldByName('ID_FILA').AsInteger := FilaProveniente;

        FieldByName('ID_MOTIVOPAUSA').Clear;
        FieldByName('HORARIO').AsDateTime := TIM;

        Post;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds

  with cdsCloneATDs do
  begin
    BM := GetBookmark;
    try
      if Locate('ID_PA', PA, []) then
      begin
        Edit;
        if ((PWD = '-1') or (PWD = '---')) then
        begin
          FieldByName('ID_STATUS').AsInteger := ord(spDisponivel);
          FieldByName('SENHA').Clear;
          FieldByName('NomeCliente').Clear;
        end
        else
        begin
          FieldByName('ID_STATUS').AsInteger  := ord(spEmAtendimento);
          FieldByName('SENHA').AsString       := PWD;
          FieldByName('NomeCliente').AsString := frmSicsMain.GetNomeParaSenha(strtoint(PWD));
        end;

        if FilaProveniente = -1 then
          FieldByName('ID_FILA').Clear
        else
          FieldByName('ID_FILA').AsInteger := FilaProveniente;

        FieldByName('ID_MOTIVOPAUSA').Clear;
        FieldByName('HORARIO').AsDateTime := TIM;

        Post;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds

  frmSicsMain.SalvaSituacao_Atendimento;
  frmSicsMain.AtualizaSituacaoPA(PA);

end; { proc UpdatePASituation }

procedure TfrmSicsSituacaoAtendimento.UpdateNomeDoCliente(Senha: Integer; Nome: string);
var
  BM: TBookmark;
begin
  with cdsClonePAs do
  begin
    BM := GetBookmark;
    try
      if Locate('SENHA', Senha, []) then
      begin
        Edit;
        FieldByName('NomeCliente').AsString := Nome;
        Post;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds

  with cdsCloneATDs do
  begin
    BM := GetBookmark;
    try
      if Locate('SENHA', Senha, []) then
      begin
        Edit;
        FieldByName('NomeCliente').AsString := Nome;
        Post;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds

  frmSicsMain.SalvaSituacao_Atendimento;
end;   { proc UpdateNomeDoCliente }

function TfrmSicsSituacaoAtendimento.GetAtendenteEstaLogado(const aIDAtd: Integer; var aIdPA: Integer): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  if not cdsPAs.Active then
    Exit;

  BM := cdsPAs.GetBookmark;
  try
    try
      cdsPAs.First;
      while not cdsPAs.Eof do
      begin
        Result := cdsPAs.FieldByName('ID_ATD').AsInteger = aIDAtd;
        if Result then
        begin
          aIdPA := cdsPAs.FieldByName('ID_PA').AsInteger;
          Break;
        end;

        cdsPAs.Next;
      end;
    finally
      if cdsPAs.BookmarkValid(BM) then
        cdsPAs.GotoBookmark(BM);
    end;
  finally
    cdsPAs.FreeBookmark(BM);
  end;
end;

procedure TfrmSicsSituacaoAtendimento.AtualizaListaDeAtendentes;
var
  nowtime : TDateTime;
  BM1, BM2: TBookmark;
begin
  nowtime := now;

  BM1 := dmSicsMain.cdsAtendentes.GetBookmark;
  BM2 := cdsAtds.GetBookmark;
  try
    dmSicsMain.cdsAtendentes.First;
    while not dmSicsMain.cdsAtendentes.eof do
    begin
      if ((dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) and (not cdsAtds.Locate('Id_Atd', dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, []))) then
      begin
        cdsAtds.Append;
        cdsAtds.FieldByName('Id_Atd').AsInteger   := dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger;
        cdsAtds.FieldByName('Horario').AsDateTime := nowtime;
        cdsAtds.Post;
      end
      else if ((not dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) and (cdsAtds.Locate('Id_Atd', dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, []))) then
      begin
        LogoutAtd(cdsAtds.FieldByName('Id_Atd').AsInteger);
        cdsAtds.Delete;
      end;
      dmSicsMain.cdsAtendentes.Next;
    end;

    // FALTA EXCLUIR DO GRID DE SITUAÇÃO OS ATENDENTES QUE FOREM DELETADOS DA TABELA DO BANCO DE DADOS
  finally
    dmSicsMain.cdsAtendentes.GotoBookmark(BM1);
    dmSicsMain.cdsAtendentes.FreeBookmark(BM1);
    try
      cdsAtds.GotoBookmark(BM2);
    finally
      cdsAtds.FreeBookmark(BM2);
    end
  end;
end;

procedure TfrmSicsSituacaoAtendimento.VerificarTimeOutPAS;
var
  DataHoraExpirada : TDateTime;
//  Alterou          : boolean;
begin
//  Alterou := false;
  with TClientDataSet.Create(Self) do
  try
    CloneCursor(cdsPAs, True);

    First;
    while not Eof do
    begin
      if (not FieldByName('ID_ATENDENTE_AUTOLOGIN').IsNull) and
         (FieldByName('Id_Atd').Value <> FieldByName('ID_ATENDENTE_AUTOLOGIN').Value) then
      begin
        LoginAtd(FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger, FieldByName('ID_PA').AsInteger);
//        Alterou := true;
      end;

      if (vgParametrosModulo.TimeOutPA > 0) and
         (FieldByName('SENHA').IsNull) and
         (not FieldByName('Id_Atd').IsNull) and
         (FieldByName('ID_ATENDENTE_AUTOLOGIN').IsNull) then
      begin
        DataHoraExpirada := Now - (1/24/60 * vgParametrosModulo.TimeOutPA);
        if (FieldByName('horario').AsDateTime <= DataHoraExpirada) then
        begin
          LogoutPA(FieldByName('ID_PA').AsInteger);
//          Alterou := true;
        end;
      end;

      Next;
    end;
  finally
    Free;
  end;
end;

procedure TfrmSicsSituacaoAtendimento.FormResize(Sender: TObject);
const
  OFF = 5;
var
  i: Integer;
begin
  PageControl.Top    := OFF;
  PageControl.Left   := OFF;
  PageControl.Width  := ClientWidth - 2 * OFF;
  PageControl.Height := ClientHeight - FinalizarAtendimentoButton.Height - 3 * OFF;

  FinalizarAtendimentoButton.Top  := ClientHeight - FinalizarAtendimentoButton.Height - OFF;
  FinalizarAtendimentoButton.Left := OFF;
  CloseButton.Top                 := FinalizarAtendimentoButton.Top;
  CloseButton.Left                := PageControl.Left + PageControl.Width - CloseButton.Width;

  with gridPAs do
  begin
    Columns[0].Width := Canvas.TextWidth(' 333 ');
    Columns[5].Width := Canvas.TextWidth(' Senha ');
    if vgMostrarNomeCliente then
    begin
      Columns[7].Width := Canvas.TextWidth(' 88:88:88 ');
      Columns[1].Width := (ClientWidth - Columns[0].Width - Columns[5].Width - Columns[7].Width - 9) div 7;
      Columns[2].Width := Columns[1].Width;
      Columns[3].Width := Columns[1].Width;
      Columns[4].Width := Columns[1].Width;
      Columns[6].Width := Columns[1].Width;
      Columns[8].Width := Columns[1].Width;
      Columns[9].Width := Columns[1].Width;
    end
    else
    begin
      Columns[6].Width := Canvas.TextWidth('   88:88:88   ');
      Columns[1].Width := (ClientWidth - Columns[0].Width - Columns[5].Width - Columns[6].Width - 8) div 6;
      Columns[2].Width := Columns[1].Width;
      Columns[3].Width := Columns[1].Width;
      Columns[4].Width := Columns[1].Width;
      Columns[7].Width := Columns[1].Width;
      Columns[8].Width := Columns[1].Width;
    end;
  end;

  for i := 0 to gridAtds.Columns.Count - 1 do
    gridAtds.Columns[i].Width := gridPAs.Columns[i].Width;
end; { proc FormResize }

procedure TfrmSicsSituacaoAtendimento.FormCreate(Sender: TObject);
var
  nowtime: TDateTime;
begin
  //RA
  {$REGION 'Código anterior comentado'}
  //cdsPAs.CreateDataSet;
  //cdsAtds.CreateDataSet;

  //cdsPAs.LogChanges  := False;
  //cdsAtds.LogChanges := False;
  {$ENDREGION}

  cdsAtds.Close;
  cdsAtds.Open;
  cdsAtds.LogChanges := True;

  cdsPAs.Close;
  cdsPAs.Open;
  cdsPAs.LogChanges := True;

  cdsPAs.FieldByName('NomeCliente').Visible  := vgMostrarNomeCliente;
  cdsAtds.FieldByName('NomeCliente').Visible := vgMostrarNomeCliente;

  nowtime := now;

  dmSicsMain.cdsPAs.First;
  while not dmSicsMain.cdsPAs.eof do
  begin
    if dmSicsMain.cdsPAs.FieldByName('ATIVO').AsBoolean then
    begin
      if not cdsPAs.Locate('Id_PA', dmSicsMain.cdsPAs.FieldByName('ID').AsInteger, []) then
      begin
        cdsPAs.Append;

        cdsPAs.FieldByName('Id_PA').AsInteger              := dmSicsMain.cdsPAs.FieldByName('ID').AsInteger;
        cdsPAs.FieldByName('Id_STATUS').AsInteger          := ord(spDeslogado);
        cdsPAs.FieldByName('Horario').AsDateTime           := nowtime;
        cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').Value := dmSicsMain.cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').Value;
        cdsPAs.FieldByName('Ativo').AsBoolean              := dmSicsMain.cdsPAs.FieldByName('ATIVO').AsBoolean;
        cdsPAs.FieldByName('POSICAO').AsInteger            := dmSicsMain.cdsPAs.FieldByName('POSICAO').AsInteger;

        cdsPAs.Post;
      end;
    end;

    dmSicsMain.cdsPAs.Next;
  end; { with }

  if cdsPAs.ChangeCount > 0 then
  begin
    cdsPAs.ApplyUpdates(0);
  end;

  dmSicsMain.cdsAtendentes.First;

  while not dmSicsMain.cdsAtendentes.eof do
  begin
    if dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean then
    begin
      if not cdsAtds.Locate('Id_Atd', dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, []) then
      begin
        cdsAtds.Append;

        cdsAtds.FieldByName('Id_Atd').AsInteger    := dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger;
        cdsAtds.FieldByName('Id_STATUS').AsInteger := ord(spDeslogado);
        cdsAtds.FieldByName('Horario').AsDateTime  := nowtime;

        cdsAtds.Post;
      end;
    end;

    dmSicsMain.cdsAtendentes.Next;
  end; { with }

  if cdsAtds.ChangeCount > 0 then
  begin
    cdsAtds.ApplyUpdates(0);
  end;

  LoadPosition(Sender as TForm);
end; { proc FormCreate }

procedure TfrmSicsSituacaoAtendimento.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
end; { proc FormDestroy }

{ ------------------------------------------------ }


procedure TfrmSicsSituacaoAtendimento.CloseButtonClick(Sender: TObject);
begin
  Close;
end; procedure TfrmSicsSituacaoAtendimento.dsPAsDataChange(Sender: TObject; Field: TField);
begin

end;

{ proc CloseButtonClick }

procedure TfrmSicsSituacaoAtendimento.TimerVerificarTimeOutPASTimer(Sender: TObject);
begin
  TimerVerificarTimeOutPAS.Enabled := False;
  try
    VerificarTimeOutPAS;
  finally
    TimerVerificarTimeOutPAS.Enabled := True;
  end;
end;

procedure TfrmSicsSituacaoAtendimento.cdsPAsAfterOpen(DataSet: TDataSet);
var
  I: Integer;
  PAs: string;
begin
  cdsClonePAs.CloneCursor(cdsPAs, True);
  cdsClonePAs.LogChanges := false;

  if Length(dmSicsServidor.PAsComChamadaAutomatica) = 0 then
    Exit;

  PAs := '';
  for I := 0 to High(dmSicsServidor.PAsComChamadaAutomatica) do
    PAs := PAs + ' (Id_PA = ' + IntToStr(dmSicsServidor.PAsComChamadaAutomatica[I]) + ') OR ';

  PAs := '(' + Copy(PAs,1,Length(PAs)-4) + ')';

  with cdsPAsDisponiveisComChamadaAutomatica do
  begin
    CloneCursor(cdsPAs, true);
    IndexFieldNames := 'HORARIO';
    Filter          := '(Id_Status = 1) and ' + PAs;
    Filtered        := True;
  end;
end;

procedure TfrmSicsSituacaoAtendimento.cdsPAsBeforePost(DataSet: TDataSet);
begin
  if cdsPAs.State = dsInsert then
  begin
    cdsPAsID.AsInteger := TGenerator.NGetNextGenerator('GEN_ID_ATEND_ATDS', dmSicsMain.connOnLine);
  end;
end;

procedure TfrmSicsSituacaoAtendimento.AtualizarCdsAtendentes(ACdsOrigem: TClientDataSet);
begin
  ACdsOrigem.First;
  while not ACdsOrigem.Eof do
  begin
    // ****************************************************************************************************
    // verifica todas os Atendentes ativos no banco de dados e caso exista na situação do atendimento
    // atualiza "Nome, Grupo e Posição", se não existir insere o novo atendente na lista.
    // ****************************************************************************************************
    if (ACdsOrigem.FieldByName('ATIVO').AsString = 'T') then
    begin
      if cdsAtds.Locate('ID_ATD', ACdsOrigem.FieldByName('ID').AsInteger,[]) then
      begin
        //nenhum campo a ser editado caso já exista
      end else
      begin
        cdsAtds.Append;
        cdsAtds.FieldByName('ID_ATD').AsInteger     := ACdsOrigem.FieldByName('ID').AsInteger;
        cdsAtds.FieldByName('Horario').AsDateTime   := Now;
        cdsAtds.FieldByName('Id_Status').AsInteger  := 0;
        cdsAtds.Post;
      end;
    end;
    ACdsOrigem.Next;
  end;

  // ****************************************************************************************************
  // verifica todos os atendentes na situação do atendimento e exclui da lista caso não exista mais ou esteja
  // inativo no banco de dados.
  // ****************************************************************************************************
  cdsAtds.First;
  while not cdsAtds.Eof do
  begin
    if (not ACdsOrigem.Locate('ID', cdsAtds.FieldByName('ID_ATD').AsInteger,[])) or
       (ACdsOrigem.FieldByName('ATIVO').AsString <> 'T') then
      cdsAtds.Delete
    else
      cdsAtds.Next;
  end;
end;

procedure TfrmSicsSituacaoAtendimento.AtualizarCdsPAs(
  ACdsOrigem: TClientDataSet);
begin
  ACdsOrigem.First;
  while not ACdsOrigem.Eof do
  begin
    if (ACdsOrigem.FieldByName('ATIVO').AsString = 'T') then
    begin
      if cdsPAs.Locate('ID_PA',ACdsOrigem.FieldByName('ID').AsInteger,[]) then
      begin
        cdsPAs.Edit;
        if ACdsOrigem.FieldByName('ID_ATENDENTE_AUTOLOGIN').IsNull then
          cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
        else
          cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := ACdsOrigem.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger;

        cdsPAs.FieldByName('Ativo').AsBoolean := true;
        cdsPAs.FieldByName('POSICAO').AsInteger := ACdsOrigem.FieldByName('POSICAO').AsInteger;
        cdsPAs.Post;
      end
      else
      begin
        cdsPAs.Append;
        cdsPAs.FieldByName('Id_PA').AsInteger      := ACdsOrigem.FieldByName('ID').AsInteger;
        cdsPAs.FieldByName('Horario').AsDateTime   := Now;
        cdsPAs.FieldByName('Id_Status').AsInteger  := 0;

        if ACdsOrigem.FieldByName('ID_ATENDENTE_AUTOLOGIN').IsNull then
          cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
        else
          cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := ACdsOrigem.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger;

        cdsPAs.FieldByName('ATIVO').AsBoolean := true;
        cdsPAs.FieldByName('POSICAO').AsInteger  := ACdsOrigem.FieldByName('POSICAO').AsInteger;
        cdsPAs.Post;
      end;
    end;
    ACdsOrigem.Next;
  end;

  // ****************************************************************************************************
  // verifica todos os atendentes na situação do atendimento e exclui da lista caso não exista mais ou esteja
  // inativo no banco de dados.
  // ****************************************************************************************************
  cdsPAs.First;
  while not cdsPAs.Eof do
  begin
    if (not ACdsOrigem.Locate('ID', cdsPAs.FieldByName('ID_PA').AsInteger,[])) or
       (ACdsOrigem.FieldByName('ATIVO').AsString <> 'T') then
      cdsPAs.Delete
    else
      cdsPAs.Next;
  end;
end;

procedure TfrmSicsSituacaoAtendimento.cdsAtdsAfterOpen(DataSet: TDataSet);
begin
  cdsCloneATDs.CloneCursor(cdsAtds, true);
  cdsCloneATDs.LogChanges := false;
end;

procedure TfrmSicsSituacaoAtendimento.cdsAtdsBeforePost(DataSet: TDataSet);
begin
  if cdsAtds.State = dsInsert then
  begin
    cdsAtdsID.AsInteger := TGenerator.NGetNextGenerator('GEN_ID_ATEND_ATDS', dmSicsMain.connOnLine);
  end;
end;

procedure TfrmSicsSituacaoAtendimento.cdsAtdsReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  raise Exception.Create(E.Message);
end;

end.
