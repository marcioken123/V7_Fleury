unit untDmUnidadesScc;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Datasnap.DBClient, Data.DB,
  Datasnap.Provider, VCL.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL;

type
  TdmUnidadesScc = class(TDataModule)
    cdsUn: TClientDataSet;
    dspUn: TDataSetProvider;
    cdsUnID: TIntegerField;
    cdsUnNOME: TStringField;
    cdsUnDBDIR: TStringField;
    cdsUnIP: TStringField;
    cdsUnPORTA: TIntegerField;
    cdsUnPORTA_TGS: TIntegerField;
    cdsUnID_UNID_CLI: TStringField;
    Conn: TFDConnection;
    qryUn: TFDQuery;
  private
  public
    procedure CarregarDados(const ACaminhoBD, ADBHost, ADBBanco, ADBUsuario, ADBSenha: String; ADBOSAuthent: Boolean);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UConexaoBD;

{$R *.dfm}

{ TdmUnidadesScc }

procedure TdmUnidadesScc.CarregarDados(const ACaminhoBD, ADBHost, ADBBanco, ADBUsuario, ADBSenha: String;
  ADBOSAuthent: Boolean);
begin
  Conn.Close;
  //RA
  //Conn.Params.Values['Database'] := ACaminhoBD;
  Conn.ConnectionDefName := TConexaoBD.GetConnection(ACaminhoBD,
                                                     ADBHost,
                                                     ADBBanco,
                                                     ADBUsuario,
                                                     ADBSenha,
                                                     ADBOSAuthent);
  try
    cdsUn.Close;
    cdsUn.Open;
  finally
    Conn.Close;
  end;
end;

end.
