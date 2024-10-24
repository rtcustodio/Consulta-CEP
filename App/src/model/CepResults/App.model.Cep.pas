unit App.model.Cep;

interface

uses
  App.model.Cep.Intf,
  Data.DB,
  App.model.DB.Intf,
  App.model.QueryFactory,
  App.model.Cep.CadastrarCep,
  SysUtils;

type
  TDAO_CEP = class(TInterfacedObject, IDAO_CEP)
  private
    FQuery : IQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : IDAO_CEP;
    function DataSource( AValue : TDataSource ) : IDAO_CEP;
    function Open : IDAO_CEP;
    function FiltrarPorCEP( AValue : string ) : IDAO_CEP;
    function FiltrarPorEndereco( AUF, ACidade, ALogradouro : string ) :IDAO_CEP;
    function CadastrarCEP : ICadastrarCep;
  end;

implementation

{ TDAO_CEP }

function TDAO_CEP.CadastrarCEP: ICadastrarCep;
begin
  Result := TCadastrarCep.New;
end;

constructor TDAO_CEP.Create;
begin
  FQuery := TQueryFactory.New.Query
    .Table('cep_results')
    .AddField('codigo')
    .AddField('cast(cep as char) as cep')
    .AddField('cast(logradouro as char) as logradouro')
    .AddField('cast(complemento as char) as complemento')
    .AddField('cast(bairro as char) as bairro')
    .AddField('cast(localidade as char) as localidade')
    .AddField('cast(uf as char) as uf');
end;

function TDAO_CEP.DataSource(AValue: TDataSource): IDAO_CEP;
begin
  Result := Self;
  AValue.DataSet := FQuery.Dataset;
end;

destructor TDAO_CEP.Destroy;
begin

  inherited;
end;

function TDAO_CEP.FiltrarPorCEP(AValue: string): IDAO_CEP;
begin
  Result := Self;
  if AValue.IsEmpty then
    raise Exception.Create('Informe um CEP');
  FQuery
    .ClearConditions
    .AddSpecialCondicion('cep in ('+AValue+')')
    .Open;
end;

function TDAO_CEP.FiltrarPorEndereco(AUF, ACidade,
  ALogradouro: string): IDAO_CEP;
begin
  Result := Self;
  FQuery
    .ClearConditions
    .AddCondition('uf', AUF.ToUpper.QuotedString)
    .AddCondition('localidade', ACidade.ToUpper.QuotedString)
    .AddCondition('logradouro', ('%'+ALogradouro.ToUpper+'%').QuotedString, ' like ')
    .Open;
end;

class function TDAO_CEP.New: IDAO_CEP;
begin
  Result := Self.Create;
end;

function TDAO_CEP.Open: IDAO_CEP;
begin
  Result := Self;
  FQuery.ClearConditions.Open;
end;

end.
