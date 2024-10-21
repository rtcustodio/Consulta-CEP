unit App.model.QueryFactory;

interface

uses App.model.DB.Intf, App.model.Query, App.model.Datamodule;

type
  TQueryFactory = class(TInterfacedObject, IQueryFactory)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function New : IQueryFactory;
    function Query : iQuery;
  end;

implementation

{ TQueryFactory }

constructor TQueryFactory.Create;
begin

end;

destructor TQueryFactory.Destroy;
begin

  inherited;
end;

class function TQueryFactory.New: IQueryFactory;
begin
  Result := Self.Create;
end;

function TQueryFactory.Query: iQuery;
begin
  Result := TQuery.New(DM.FDConnection);
end;

end.
