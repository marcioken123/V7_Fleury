unit untDmTabelasScc;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Datasnap.DBClient, Data.DB,
  Datasnap.Provider, VCL.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL;

type
  TdmTabelasScc = class(TDataModule)
    Conn: TFDConnection;
    cdsTemp: TClientDataSet;
    dspTemp: TDataSetProvider;
    qryTemp: TFDQuery;
  private
  public
    procedure CarregarDados(const ACaminhoBD, ADBHost, ADBBanco, ADBUsuario, ADBSenha: String; ADBOSAuthent: Boolean);
    function ConsultarDados(const AInstrucaoSQL: string): TFDQuery;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UConexaoBD;

{$R *.dfm}

{ TdmTabelasScc }

procedure TdmTabelasScc.CarregarDados(const ACaminhoBD, ADBHost, ADBBanco, ADBUsuario, ADBSenha: String;
  ADBOSAuthent: Boolean);
begin
  Conn.Close;
  //WOS
  Conn.ConnectionDefName := TConexaoBD.GetConnection(ACaminhoBD,
                                                     ADBHost,
                                                     ADBBanco,
                                                     ADBUsuario,
                                                     ADBSenha,
                                                     ADBOSAuthent);
end;

function TdmTabelasScc.ConsultarDados(const AInstrucaoSQL: string): TFDQuery;
begin
  qryTemp.Close;
  try
    qryTemp.Open(AInstrucaoSQL);
    Result := qryTemp;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao Consultar Dados!');
    end;
  end;
end;

end.
