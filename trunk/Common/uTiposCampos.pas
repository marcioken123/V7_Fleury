unit uTiposCampos;

interface

type
  TTipoCampo = (tcTexto, tcInteiro, tcDecimal, tcData, tcHora,
                tcDataHora, tcLogico);

var
  NomesTiposCampos: array[tcTexto..tcLogico] of String = (
    'Texto', 'Inteiro', 'Decimal', 'Data', 'Hora',
    'Data/Hora', 'L�gico'
  );

implementation

end.
