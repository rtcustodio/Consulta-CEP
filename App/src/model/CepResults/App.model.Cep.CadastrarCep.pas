unit App.model.Cep.CadastrarCep;

interface

uses
  App.model.Cep.Intf,
  App.model.QueryFactory,
  SysUtils,
  App.model.stringUtils;

type
  TCadastrarCep = class(TInterfacedObject, ICadastrarCep)
  private
    FCEP : string;
    FLogradouro : string;
    FComplemento : string;
    FBairro : string;
    FLocalidade : string;
    FUF : string;
    function CEP : string; overload;
    function Logradouro : string; overload;
    function Complemento : string ; overload;
    function Bairro : string; overload;
    function Localidade : string; overload;
    function UF : string; overload;
    function CepExiste : boolean;
    procedure CadastrarCEP;
    procedure AtualizarCEP;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : ICadastrarCep;
    function CEP( AValue : string ) : ICadastrarCep; overload;
    function Logradouro( AValue : string ) : ICadastrarCep; overload;
    function Complemento( AValue : string ) : ICadastrarCep; overload;
    function Bairro( AValue : string ) : ICadastrarCep; overload;
    function Localidade( AValue : string ) : ICadastrarCep; overload;
    function UF( AValue : string ) : ICadastrarCep; overload;
    function Cadastrar : ICadastrarCep;
  end;

implementation

{ TCadastrarCep }

procedure TCadastrarCep.AtualizarCEP;
begin
  TQueryFactory.New
    .Query
    .ExecSQL(
      'UPDATE cep_results SET '+
      'logradouro   = ' + RemoveAcentos(Logradouro).ToUpper.QuotedString + ', '+
      'complemento  = ' + RemoveAcentos(Complemento).ToUpper.QuotedString + ', ' +
      'bairro       = ' + RemoveAcentos(Bairro).ToUpper.QuotedString + ', ' +
      'localidade   = ' + RemoveAcentos(Localidade).ToUpper.QuotedString +', '+
      'uf           = ' + UF.ToUpper.QuotedString +
      'WHERE cep    = ' + CEP
    );
end;

function TCadastrarCep.Bairro(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FBairro := AValue;
end;

function TCadastrarCep.Bairro: string;
begin
  Result := FBairro;
end;

function TCadastrarCep.Cadastrar: ICadastrarCep;
begin
  if CepExiste then
    AtualizarCEP
  else
    CadastrarCEP;
end;

procedure TCadastrarCep.CadastrarCEP;
begin
  TQueryFactory.New
    .Query
    .ExecSQL(
      'INSERT INTO cep_results ( '+
        'cep,           ' +
        'logradouro,    ' +
        'complemento,   ' +
        'bairro,        ' +
        'localidade,    ' +
        'uf            ' +
      ') VALUES (' +
        CEP.QuotedString + ', '+
        RemoveAcentos(Logradouro).ToUpper.QuotedString + ', '+
        RemoveAcentos(Complemento).ToUpper.QuotedString + ', ' +
        RemoveAcentos(Bairro).ToUpper.QuotedString + ', ' +
        RemoveAcentos(Localidade).ToUpper.QuotedString +', '+
        UF.ToUpper.QuotedString +
      ')'
    );
end;

function TCadastrarCep.CEP: string;
begin
  if FCEP.IsEmpty then
    raise Exception.Create('Nenhum CEP informado');
  Result := FCEP;
end;

function TCadastrarCep.CEP(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FCEP := AValue.Replace('-', '');
end;

function TCadastrarCep.CepExiste: boolean;
begin
  var LQryBusca := TQueryFactory.New.Query
    .Table('cep_results')
    .AddField('cep')
    .AddCondition('cep', CEP.QuotedString)
    .Open;
  Result := not LQryBusca.Dataset.IsEmpty;
end;

function TCadastrarCep.Complemento: string;
begin
  Result := FComplemento;
end;

function TCadastrarCep.Complemento(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FComplemento := AValue;
end;

constructor TCadastrarCep.Create;
begin

end;

destructor TCadastrarCep.Destroy;
begin

  inherited;
end;

function TCadastrarCep.Localidade(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FLocalidade := AValue;
end;

function TCadastrarCep.Localidade: string;
begin
  Result := FLocalidade;
end;

function TCadastrarCep.Logradouro: string;
begin
  Result := FLogradouro;
end;

function TCadastrarCep.Logradouro(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FLogradouro := AValue;
end;

class function TCadastrarCep.New: ICadastrarCep;
begin
  Result := Self.Create;
end;

function TCadastrarCep.UF: string;
begin
  Result := FUF;
end;

function TCadastrarCep.UF(AValue: string): ICadastrarCep;
begin
  Result := Self;
  FUF := AValue;
end;

end.
