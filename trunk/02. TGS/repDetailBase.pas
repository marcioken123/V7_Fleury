unit repDetailBase;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  System.UITypes,
  Qrctrls, quickrpt, qrprntr,
   repGraphBase,System.Types, System.SysUtils, System.Classes, System.Variants,
  Vcl.Controls;

type
  TqrSicsDetailBase = class(TqrSicsGraphicBase)
    procedure QRDBText3Print(sender: TObject; var Value: String); Virtual; Abstract;
    procedure QRDBText4Print(sender: TObject; var Value: String); Virtual; Abstract;
    procedure QRDBText5Print(sender: TObject; var Value: String); Virtual; Abstract;
    procedure QRDBText1Print(sender: TObject; var Value: String); Virtual; Abstract;
  private
    { Private declarations }
  public
    StrListUnidadesAtds: TStringList;
    StrListUnidadesPAs: TStringList;
    StrListUnidadesFilas: TStringList;
    StrListUnidadesTotens: TStringList;
    StrListUnidadesFluxos: TStringList;
    StrListUnidadesTags: TStringList;

    constructor Create(aOwner: TComponent); Override;
    destructor Destroy; Override;
    procedure AlinharLabels; Virtual; Abstract;
  end;
  
implementation

{$R *.dfm}
 
constructor TqrSicsDetailBase.Create(aOwner: TComponent);
begin
  inherited;
  StrListUnidadesAtds := TStringList.Create;
  StrListUnidadesPAs := TStringList.Create;
  StrListUnidadesFilas := TStringList.Create;
  StrListUnidadesTotens := TStringList.Create;
  StrListUnidadesFluxos := TStringList.Create;
  StrListUnidadesTags := TStringList.Create;
end;

destructor TqrSicsDetailBase.Destroy;
begin
  FreeAndNil(StrListUnidadesAtds);
  FreeAndNil(StrListUnidadesPAs);
  FreeAndNil(StrListUnidadesFilas);
  FreeAndNil(StrListUnidadesTotens);
  FreeAndNil(StrListUnidadesFluxos);
  FreeAndNil(StrListUnidadesTags);
  inherited;
end;

end.
