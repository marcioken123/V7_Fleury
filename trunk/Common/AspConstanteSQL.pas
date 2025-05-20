unit AspConstanteSQL;

interface

uses SysUtils;

type
  TAspConstantesSQL = class
  
  end;

const
  cSELECT_ALL_COM_MODULO = 'SELECT C.*, M.NOME FROM %s C INNER JOIN MODULOS M ON M.ID = C.ID WHERE C.ID = %d';
  cSELECT_NEXT_GEN = 'SELECT CAST(GEN_ID(GEN_ID_%s, %d) AS INTEGER) AS ID FROM RDB$DATABASE';
implementation


end.