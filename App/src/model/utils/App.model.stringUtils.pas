unit App.model.stringUtils;

interface

function RemoveAcentos(Str: String): String;

implementation

function RemoveAcentos(Str: String): String;
{Remove caracteres acentuados de uma string}
const
  ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ"';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU ';
var
  x : Integer;
Begin
  for x := 1 to Length(Str) do
  begin
    if Pos(Str[x],ComAcento)<>0 Then
    begin
      Str[x] := SemAcento[Pos(Str[x],ComAcento)];
    end;
  end;
  Result := Str;
end;

end.
