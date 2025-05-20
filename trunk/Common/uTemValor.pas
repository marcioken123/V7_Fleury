unit uTemValor;

interface

type
  TTemBoolean = record
    Tem: Boolean;
    Valor: Boolean;
  end;

  TTemDate = record
    Tem: Boolean;
    Valor: TDate;
  end;

  TTemDateTime = record
    Tem: Boolean;
    Valor: TDateTime;
  end;

  TTemInteger = record
    Tem: Boolean;
    Valor: Integer;
  end;

  TTemString = record
    Tem: Boolean;
    Valor: string;
  end;

  TTemTime = record
    Tem: Boolean;
    Valor: TTime;
  end;

implementation

end.
