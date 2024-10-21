unit CConsultaCEP.Intf;

interface

uses CConsultaCEP.EventsAndEnums;

type
  ISysConsultaCEP = interface
    ['{8A7A418E-80E6-4573-8039-8DF92F13FEF3}']
    procedure ConsultarPorCEP(ACEP: string);
    procedure ConsultarPorEndereco(AUF, ACidade, ALogradouro: string);
  end;

  IRetornoStrategy = interface
    ['{AAE7CDEE-65D9-4112-8BC4-C0D0F7D12871}']
    procedure ProcessarRetorno(const AResponse: string; AOnResult: TViaCEPResult; AOnError: TNotifyErrorEvent);
  end;

  IFactoryStrategy = interface
    ['{0AD1E685-2A03-44DE-9233-FBC477193F49}']
    function StrategyJSON : IRetornoStrategy;
    function StrategyXML : IRetornoStrategy;
  end;

  IHttpClient = interface
    ['{A3A31794-B4B4-453E-9A73-25B91DB2B8C4}']
    function Get(const AURL: string): string;
  end;
implementation

end.
