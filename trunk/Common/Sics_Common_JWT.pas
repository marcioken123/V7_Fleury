{*************************************************}
{                                                 }
{               Gera��o da token JWT.             }
{                   Tipo: Bearer                  }
{                 Algor�tmo: HS256                }
{                                                 }
{               Baixar/documenta��o               }
{ https://github.com/paolo-rossi/delphi-jose-jwt  }
{   |                                             }
{   -> Apontar para                               }
{     |                                           }
{     -> delphi-jose-jwt\Source\Common            }
{     |                                           }
{     -> delphi-jose-jwt\Source\JOSE              }
{                                                 }
{*************************************************}

unit Sics_Common_JWT;

interface

uses
  JOSE.Core.JWT, System.SysUtils, JOSE.Core.Builder;

  function getJWTCompactToken(pDateTimeExpiration: TDateTime): String;

implementation

const
  JWTKey: String = 'info2005';//Esta � chava que ele se baseia para criar o token

function getJWTCompactToken(pDateTimeExpiration: TDateTime): String;
var
  LToken: TJWT;
  LCompactToken: string;
begin
  Result:= '';
  LToken := TJWT.Create;
  try
    // Token claims
    LToken.Claims.Issuer := 'ASPECT Midia';
    LToken.Claims.Subject := 'JWT';
    LToken.Claims.Expiration := pDateTimeExpiration;

    // Signing and Compact format creation
    LCompactToken := TJOSE.SHA256CompactToken(JWTKey, LToken);

    Result:= LCompactToken;

  finally
    LToken.Free;
  end;
end;

end.
