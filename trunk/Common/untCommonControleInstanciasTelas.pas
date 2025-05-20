unit untCommonControleInstanciasTelas;

interface

uses
  System.Generics.Collections, FMX.Types;

type
  /// <summary>
  ///  Classe utilizada para gerenciar as instâncias das telas que herdam de
  ///  FrameBase e FormBase, que são criadas sempre uma única vez e residem na
  ///  aplicação durante toda a sua vida.
  /// </summary>
  TControleInstanciasTelas = class
  private
    /// <summary>
    ///  Dictionary utilizado para armazenar às referências às instâncias,
    ///  indexadas pelo seus ClassType.
    /// </summary>
    class var FListaTelas: TDictionary<TClass, TFMXObject>;

    /// <summary>
    ///  Remove de FListaTelas a instância de uma classe. Exemplo de uso:
    ///    Remover(TForm1);
    /// </summary>
    class procedure Remover(aClass: TClass);
  public
    /// <summary>
    ///  Verifica se uma uma determinada classe já possui uma instância e, se
    ///  existir, a retorna em aObject. Exemplo de uso:
    ///    if Existe(TForm1, LForm) then LForm.Show;
    /// </summary>
    class function Existe(aClass: TClass; var aObject: TFMXObject): Boolean;
    /// <summary>
    ///  Adiciona na lista de Instâncias Por Classe uma refência à aObject.
    ///  Exemplo de uso:
    ///    Adicionar(TForm1, FForm1);
    /// </summary>
    class procedure Adicionar(aClass: TClass; aObject: TFMXObject);
  end;

implementation


{ TControleInstanciasTelas }

class procedure TControleInstanciasTelas.Adicionar(aClass: TClass;
  aObject: TFMXObject);
begin
  FListaTelas.Add(aClass, aObject);
end;

class function TControleInstanciasTelas.Existe(aClass: TClass;
  var aObject: TFMXObject): Boolean;
begin
  //TDictionary<key, value>.TryGetValue(aKey, out aValue) - pesquisa no
  //dicionário por aKey e retorna o valor em aValue, se encontrado
  result := FListaTelas.TryGetValue(aClass, aObject);
end;

class procedure TControleInstanciasTelas.Remover(aClass: TClass);
begin
  FListaTelas.Remove(aClass);
end;

initialization
  TControleInstanciasTelas.FListaTelas := TDictionary<TClass, TFMXObject>.Create;

finalization
  TControleInstanciasTelas.FListaTelas.Free;

end.
