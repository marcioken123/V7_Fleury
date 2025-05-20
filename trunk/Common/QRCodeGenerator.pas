unit QRCodeGenerator;

interface

uses Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.PNGImage, DelphiZXingQRCode;

type
  TQRCodeGenerator = class
  private
    FData: String;
    FWidth: Integer;
    FHeight: Integer;
    FEncoding: TQRCodeEncoding;
    FQuietZone: Integer;
    FQRBmp: TBitmap;
    FQRCode: TDelphiZXingQRCode;

    procedure DoGenerate;
  public
    function GetJPG(const ACompressionQuality: TJPEGQualityRange): TJPEGImage;
    function GetPNG(const ACompressionLevel: TCompressionLevel): TPNGImage;
    function GetBMP: TBitmap;
    function GetJPGFile(const AFileName: String; const ACompressionQuality: TJPEGQualityRange): Boolean;
    function GetPNGFile(const AFileName: String; const ACompressionLevel: TCompressionLevel): Boolean;
    function GetBMPFile(const AFileName: String): Boolean;

    constructor Create(const AData: String; AWidth, AHeight: Integer;
      const AEncoding: TQRCodeEncoding; const AQuietZone: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, System.Classes;

{ TQRCodeGenerator }

constructor TQRCodeGenerator.Create(const AData: String; AWidth,
  AHeight: Integer; const AEncoding: TQRCodeEncoding;
  const AQuietZone: Integer);
begin
  FData := AData;
  FWidth := AWidth;
  FHeight := AHeight;
  FEncoding := AEncoding;
  FQuietZone := AQuietZone;

  FQRCode := TDelphiZXingQRCode.Create;
  FQRBmp := TBitmap.Create;

  DoGenerate;
end;

destructor TQRCodeGenerator.Destroy;
begin
  FQRCode.Free;
  FQRBmp.Free;
  inherited;
end;

procedure TQRCodeGenerator.DoGenerate;
var
  LRow, LColumn: Integer;
begin
  FQRCode.Data := FData;
  FQRCode.Encoding := FEncoding;
  FQRCode.QuietZone := FQuietZone;

  FQRBmp.SetSize(FQRCode.Rows, FQRCode.Columns);
  for LRow := 0 to FQRCode.Rows - 1 do
  begin
    for LColumn := 0 to FQRCode.Columns - 1 do
    begin
      if FQRCode.IsBlack[LRow, LColumn] then
      begin
        FQRBmp.Canvas.Pixels[LColumn, LRow] := clBlack;
      end else
      begin
        FQRBmp.Canvas.Pixels[LColumn, LRow] := clWhite;
      end;
    end;
  end;
end;

function TQRCodeGenerator.GetBMP: TBitmap;
var
  LScale: Double;
begin
  result := TBitmap.Create;
  result.SetSize(FWidth, FHeight);
  result.Canvas.Brush.Color := clWhite;
  result.Canvas.FillRect(Rect(0, 0, FWidth, FHeight));
  if ((FQRBmp.Width > 0) and (FQRBmp.Height > 0)) then
  begin
    if (FWidth < FHeight) then
    begin
      LScale := FWidth / FQRBmp.Width;
    end else
    begin
      LScale := FHeight / FQRBmp.Height;
    end;
    result.Canvas.StretchDraw(
      Rect(0, 0, Trunc(LScale*FQRBmp.Width), Trunc(LScale*FQRBmp.Height)),
      FQRBmp);
  end;
end;

function TQRCodeGenerator.GetBMPFile(const AFileName: String): Boolean;
var
  LBMP: TBitmap;
begin
  LBMP := GetBMP;
  try
    LBMP.SaveToFile(AFileName);
  finally
    LBMP.Free;
  end;
  result := FileExists(AFileName);
end;

function TQRCodeGenerator.GetJPG(
  const ACompressionQuality: TJPEGQualityRange): TJPEGImage;
var
  LBMP: TBitmap;
  LJPG: TJPEGImage;
begin
  LBMP := GetBMP;
  try
    result := TJPEGImage.Create;
    result.CompressionQuality := ACompressionQuality;
    result.Assign(LBMP);
  finally
    LBMP.Free
  end;
end;

function TQRCodeGenerator.GetJPGFile(const AFileName: String;
  const ACompressionQuality: TJPEGQualityRange): Boolean;
var
  LJPEG: TJPEGImage;
begin
  LJPEG := GetJPG(ACompressionQuality);
  try
    LJPEG.SaveToFile(AFileName);
  finally
    LJPEG.Free;
  end;
  result := FileExists(AFileName);
end;

function TQRCodeGenerator.GetPNG(
  const ACompressionLevel: TCompressionLevel): TPNGImage;
var
  LBMP: TBitmap;
  LPNG: TPNGImage;
begin
  LBMP := GetBMP;
  try
    result := TPNGImage.Create;
    result.CompressionLevel := ACompressionLevel;
    result.Assign(LBMP);
  finally
    LBMP.Free
  end;
end;

function TQRCodeGenerator.GetPNGFile(const AFileName: String;
  const ACompressionLevel: TCompressionLevel): Boolean;
var
  LPNG: TPngImage;
begin
  LPNG := GetPNG(ACompressionLevel);
  try
    LPNG.SaveToFile(AFileName);
  finally
    LPNG.Free;
  end;
  result := FileExists(AFileName);
end;

end.
