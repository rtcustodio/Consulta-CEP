unit CConsultaCEP.StrategyFactory;

interface

uses
  CConsultaCEP.Intf,
  CConsultaCEP.StrategyRetornoJSON,
  CConsultaCEP.StrategyRetornoXML;

type
  TFactoryStrategy = class(TInterfacedObject, IFactoryStrategy)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function New : IFactoryStrategy;
    function StrategyJSON : IRetornoStrategy;
    function StrategyXML : IRetornoStrategy;
  end;

implementation

{ TFactoryStrategy }

constructor TFactoryStrategy.Create;
begin

end;

destructor TFactoryStrategy.Destroy;
begin

  inherited;
end;

class function TFactoryStrategy.New: IFactoryStrategy;
begin
  Result := Self.Create;
end;

function TFactoryStrategy.StrategyJSON: IRetornoStrategy;
begin
  Result := TJSONRetornoStrategy.Create;
end;

function TFactoryStrategy.StrategyXML: IRetornoStrategy;
begin
  Result := TXMLRetornoStrategy.Create;
end;

end.
