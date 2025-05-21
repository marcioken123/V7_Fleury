unit udmPlayListManager;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  Vcl.ExtCtrls, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt, FireDAC.Comp.DataSet, Datasnap.DBClient, JvPanel, WMPLib_TLB,
  MyDlls_DR, FireDAC.Phys.Intf, FireDAC.Phys.FBDef, FireDAC.DApt.Intf;

type
  TProcToSetImageAtualizandoPlaylist = procedure (const Panel: TJvPanel; const Path: string) of Object;
  TProcToFinalizarAtualizacaoPlaylist = procedure (const Panel: TJvPanel) of Object;

  TDMPlayListManager = class(TDataModule)
    FDConnection: TFDConnection;
    TimerVerificaPlayListManager: TTimer;
    FDQueryArquivos: TFDQuery;
    FDQueryArquivosIDMIDIA: TIntegerField;
    FDQueryArquivosARQUIVO_MIDIA: TBlobField;
    FDQueryPlayList: TFDQuery;
    FDQueryPlayListORDEM: TIntegerField;
    FDQueryPlayListIDMIDIA: TIntegerField;
    FDQueryPlayListDURACAOSEGS: TIntegerField;
    FDQueryPlayListHASH_ARQUIVO: TStringField;
    FDQueryPlayListEXTENSAO: TStringField;
    ClientDataSetPlayList: TClientDataSet;
    ClientDataSetPlayListARQUIVO_CAMINHO: TStringField;
    ClientDataSetPlayListARQUIVO_TIPO: TStringField;
    ClientDataSetPlayListARQUIVO_DURACAOSEGS: TIntegerField;
    FDQueryPlayListTIPO: TStringField;
    ClientDataSetPlayListARQUIVO_HASH: TStringField;
    procedure TimerVerificaPlayListManagerTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FProcSetImageAtualizandoPlaylist: TProcToSetImageAtualizandoPlaylist;
    FProcFinalizarAtualizacaoPlaylist: TProcToFinalizarAtualizacaoPlaylist;
    FAtualizandoPlaylist: Boolean;
  public
    FPanel: TJvPanel;

    function  ConectarDBPlaylist:Boolean;
    procedure GetPlayList(PathPlayList: string);
    procedure DelPlayList(PathPlayList: string);

    property ProcSetImageAtualizandoPlaylist: TProcToSetImageAtualizandoPlaylist
      read FProcSetImageAtualizandoPlaylist
      write FProcSetImageAtualizandoPlaylist;
    property ProcFinalizarAtualizacaoPlaylist: TProcToFinalizarAtualizacaoPlaylist
      read FProcFinalizarAtualizacaoPlaylist
      write FProcFinalizarAtualizacaoPlaylist;
    property AtualizandoPlaylist: Boolean read FAtualizandoPlaylist;
  end;

var
  DMPlayListManager: TDMPlayListManager;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses SicsTV_m, System.IOUtils, Vcl.Dialogs, System.Types, System.Threading;

{$R *.dfm}

function TDMPlayListManager.ConectarDBPlaylist: Boolean;
var LCaminhoBD: String;
begin
  try
    FDConnection.Close;

    case frmSicsTVPrincipal.vgTVPlayListManager.TipoBanco of
      0: begin
           if frmSicsTVPrincipal.vgTVPlayListManager.HostBanco <> EmptyStr then
             LCaminhoBD := frmSicsTVPrincipal.vgTVPlayListManager.HostBanco +':'+ frmSicsTVPrincipal.vgTVPlayListManager.NomeArquivoBanco
           else
             LCaminhoBD := frmSicsTVPrincipal.vgTVPlayListManager.NomeArquivoBanco;

           FDConnection.DriverName       := 'FB';
           FDConnection.Params.Database  := LCaminhoBD;
           FDConnection.Params.UserName  := frmSicsTVPrincipal.vgTVPlayListManager.UsuarioBanco;
           FDConnection.Params.Password  := frmSicsTVPrincipal.vgTVPlayListManager.SenhaBanco;
         end;

      1: begin
           //Caso for fazer para o SQLServer
         end;
    end;

    FDConnection.Open;

    TimerVerificaPlayListManager.Enabled  := False;
    TimerVerificaPlayListManager.Interval := frmSicsTVPrincipal.vgTVPlayListManager.IntervaloVerificacao * 60000;
    TimerVerificaPlayListManagerTimer(TimerVerificaPlayListManager);

    Result := True;
  except on E: Exception do
    Result := False;
  end;
end;

procedure TDMPlayListManager.DataModuleCreate(Sender: TObject);
begin
  FAtualizandoPlaylist := False;
end;

procedure TDMPlayListManager.DelPlayList(PathPlayList: string);
var
i: integer;
sr: TSearchRec;
begin
  I := FindFirst(PathPlayList +'\*.*', faAnyFile, SR);
  while I = 0 do
  begin
    DeleteFile(PathPlayList +'\'+ SR.Name);
    I := FindNext(SR);
  end;
end;

procedure TDMPlayListManager.GetPlayList(PathPlayList: string);
var LCaminho, LCaminhoTMP, LNomeArquivo, LPathPlayListTMP: String;
    LMudou: Boolean;
    LArquivos: TStringDynArray;
    I: Integer;
begin
  LMudou := False;
  try
    LPathPlayListTMP := PathPlayList + 'TMP';

    if not DirectoryExists(LPathPlayListTMP) then
      CreateDir(LPathPlayListTMP);

    if not ClientDataSetPlayList.Active then
      ClientDataSetPlayList.CreateDataSet;

    FDQueryPlayList.Close;
    FDQueryPlayList.ParamByName('IDTV').AsInteger := frmSicsTVPrincipal.vgTVPlayListManager.IDTV;
    FDQueryPlayList.Open;
    if not FDQueryPlayList.IsEmpty then
    begin
      LMudou := FDQueryPlayList.RecordCount <> ClientDataSetPlayList.RecordCount;
      while ((not FDQueryPlayList.eof) and (not LMudou)) do
      begin
        if not ClientDataSetPlayList.Locate('ARQUIVO_HASH',FDQueryPlayListHASH_ARQUIVO.AsString,[]) then
          LMudou := True;

        FDQueryPlayList.Next;
      end;

      if LMudou then
      begin
        TThread.Synchronize(nil, procedure
        begin
          if Assigned(ProcSetImageAtualizandoPlaylist) then
            ProcSetImageAtualizandoPlaylist(DMPlayListManager.FPanel,
                                            'Atualizando Playlist.jpg');
        end);

        ClientDataSetPlayList.Close;
        ClientDataSetPlayList.CreateDataSet;
        FDQueryPlayList.First;
        while not FDQueryPlayList.eof do
        begin
          LNomeArquivo := FDQueryPlayListHASH_ARQUIVO.AsString + '.'+
                          FDQueryPlayListEXTENSAO.AsString;

          LCaminho     := PathPlayList + PathDelim  + LNomeArquivo;
          LCaminhoTMP  := LPathPlayListTMP + PathDelim  + LNomeArquivo;

          if (not FileExists(LCaminho)) then
          begin
            if (not FileExists(LCaminhoTMP)) then
            begin
              FDQueryArquivos.Close;
              FDQueryArquivos.ParamByName('IDMIDIA').AsInteger := FDQueryPlayListIDMIDIA.AsInteger;
              FDQueryArquivos.Open;
              TBlobField(FDQueryArquivos.FieldByName('ARQUIVO_MIDIA')).SaveToFile(LCaminhoTMP);
              FDQueryArquivos.Close;
            end;
          end
          else
            TFile.Move(LCaminho,LCaminhoTMP);

          ClientDataSetPlayList.Append;
          ClientDataSetPlayListARQUIVO_CAMINHO.AsString      := LCaminho;
          ClientDataSetPlayListARQUIVO_TIPO.AsString         := FDQueryPlayListTIPO.AsString;
          ClientDataSetPlayListARQUIVO_HASH.AsString         := FDQueryPlayListHASH_ARQUIVO.AsString;
          ClientDataSetPlayListARQUIVO_DURACAOSEGS.AsInteger := FDQueryPlayListDURACAOSEGS.AsInteger * 1000;
          ClientDataSetPlayList.Post;

          FDQueryPlayList.Next;
        end;

        try
          if TDirectory.Exists(PathPlayList) then
          begin
            DelPlayList(PathPlayList);
            LArquivos := TDirectory.GetFiles(LPathPlayListTMP);
            for I := 0 to High(LArquivos) do
              TFile.Move(LArquivos[i], TPath.Combine(PathPlayList, ExtractFileName(LArquivos[i])));
            RemoveDir(LPathPlayListTMP)
          end
          else
            TDirectory.Move(LPathPlayListTMP, PathPlayList);

          if Assigned(ProcFinalizarAtualizacaoPlaylist) then
            ProcFinalizarAtualizacaoPlaylist(DMPlayListManager.FPanel);
        except on E: Exception do
          TThread.Synchronize(nil, procedure
          begin
            ShowMessage('Erro ao tentar Mover Diretório!' + E.Message);
          end);
        end;
      end;
    end
    else
    begin
      ProcSetImageAtualizandoPlaylist(DMPlayListManager.FPanel,
                                      'Atualizando Playlist.jpg');
    end;
    FDQueryPlayList.Close;
  finally
    TimerVerificaPlayListManager.Enabled  := True;
  end;
end;

procedure TDMPlayListManager.TimerVerificaPlayListManagerTimer(Sender: TObject);
begin
  TimerVerificaPlayListManager.Enabled := False;
  TTask.Run(procedure
  begin
    try
      TThread.Synchronize(nil, procedure begin FAtualizandoPlaylist := True end);
      try
        GetPlayList(frmSicsTVPrincipal.vgTVPlayListManager.DiretorioLocal);
      finally
        TThread.Synchronize(nil, procedure begin FAtualizandoPlaylist := False end);
      end;
    except
      on E: Exception do
        MyLogException(E);
    end;
  end);
end;

end.


