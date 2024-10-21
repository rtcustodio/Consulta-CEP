unit CConsultaCEP.EventsAndEnums;

interface

uses CConsultaCEP.Classes;

type
  TRetornoTipo = (JSON, XML);
  //TViaCEPResult = procedure(const CEP, Logradouro, Complemento, Bairro, Cidade, Estado, Result: string) of object;
  TViaCEPResult = procedure(const Endereco: TEndereco) of object;
  TNotifyErrorEvent = procedure(Sender: TObject; const ErrorMsg: string) of object;

implementation

end.
