unit CConsultaCEP.StrategyRetornoJSON;

interface

uses
  CConsultaCEP.EventsAndEnums,
  CConsultaCEP.Intf,
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  REST.Json,
  CConsultaCEP.Classes
;

type
  TJSONRetornoStrategy = class(TInterfacedObject, IRetornoStrategy)
  private

  public
    procedure ProcessarRetorno(const AResponse: string; AOnResult: TViaCEPResult; AOnError: TNotifyErrorEvent);
  end;

implementation


{ TJSONRetornoStrategy }

procedure TJSONRetornoStrategy.ProcessarRetorno(const AResponse: string;
  AOnResult: TViaCEPResult; AOnError: TNotifyErrorEvent);
var
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  Endereco: TEndereco;
  I: Integer;
begin
  JSONValue := TJSONObject.ParseJSONValue(AResponse);

  if not Assigned(JSONValue) then
  begin
    if Assigned(AOnError) then
      AOnError(Self, 'Erro no formato do JSON.');
    Exit;
  end;

  try
    try
      if JSONValue is TJSONArray then
      begin
        JSONArray := JSONValue as TJSONArray;
        if JSONArray.Count = 0 then
        begin
          if Assigned(AOnError) then
            AOnError(Self, 'Nenhum endere�o localizado');
          Abort;
        end;

        for I := 0 to JSONArray.Count - 1 do
        begin
          JSONObject := JSONArray.Items[I] as TJSONObject;
          Endereco := TJson.JsonToObject<TEndereco>(JSONObject.ToString);

          if Assigned(Endereco) then
          begin
            if Assigned(AOnResult) then
              AOnResult(Endereco);
          end;
        end;
      end
      else if JSONValue is TJSONObject then
      begin
        Endereco := TJson.JsonToObject<TEndereco>(AResponse);
        if AResponse.Contains('erro') then
        begin
          if Assigned(AOnError) then
            AOnError(Self, 'CEP informado n�o existe');
          Abort;
        end;

        if Assigned(Endereco) then
        begin
          if Assigned(AOnResult) then
            AOnResult(Endereco);
        end
        else
        begin
          if Assigned(AOnError) then
            AOnError(Self, 'Erro ao desserializar o JSON.');
        end;
      end
      else
        raise Exception.Create('Formato de resposta JSON n�o suportado.');

    except
      on E: Exception do
      begin
         if E is EAbort then Abort;

        if Assigned(AOnError) then
          AOnError(Self, 'Erro ao processar o retorno JSON: ' + E.Message)
        else raise Exception.Create(e.Message);
      end;
    end;
  finally
    JSONValue.Free;
  end;
end;


end.
