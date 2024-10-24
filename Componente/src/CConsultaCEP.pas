unit CConsultaCEP;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  CConsultaCEP.EventsAndEnums,
  CConsultaCEP.Intf,
  CConsultaCEP.StrategyFactory,
  CConsultaCEP.HTTPIndy;

type
  TSysConsultaCEP = class(TComponent, ISysConsultaCEP)
  private
    FCEP, FUF, FCidade, FLogradouro: string;
    FOnResult: TViaCEPResult;
    FOnError: TNotifyErrorEvent;
    FRetornoTipo: TRetornoTipo;
    FHTTP: IHttpClient;
    FStrategy: IRetornoStrategy;
    procedure SetStrategy(ARetornoTipo: TRetornoTipo);
    procedure SetCEP(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetLogradouro(const Value: string);
    procedure SetRetornoTipo(const Value: TRetornoTipo);

    property CEP: string read FCEP write SetCEP;
    property UF: string read FUF write SetUF;
    property Cidade: string read FCidade write SetCidade;
    property Logradouro: string read FLogradouro write SetLogradouro;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConsultarPorCEP(ACEP: string);
    procedure ConsultarPorEndereco(AUF, ACidade, ALogradouro: string);
  published
    property RetornoTipo: TRetornoTipo read FRetornoTipo write SetRetornoTipo default JSON;
    property OnResult: TViaCEPResult read FOnResult write FOnResult;
    property OnError: TNotifyErrorEvent read FOnError write FOnError;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TSysConsultaCEP]);
end;

{ TSysConsultaCEP }

constructor TSysConsultaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHTTP := TIndyHttpClient.Create;
  RetornoTipo := JSON;
end;

destructor TSysConsultaCEP.Destroy;
begin
  inherited Destroy;
end;


procedure TSysConsultaCEP.ConsultarPorCEP(ACEP: string);
var
  Response: string;
begin
  CEP := ACEP;
  if (FCEP.Length <> 8) and Assigned(FOnError) then
  begin
    FOnError(Self, 'CEP inv�lido. O CEP deve ter 8 d�gitos.');
    Exit;
  end;

  try
    Response := FHTTP.Get('https://viacep.com.br/ws/' + FCEP + '/' + LowerCase(GetEnumName(TypeInfo(TRetornoTipo), Ord(FRetornoTipo))));
    Response := TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes(Response));
    FStrategy.ProcessarRetorno(Response, FOnResult, FOnError);

  except
    on E: Exception do
      if Assigned(FOnError) then
        FOnError(Self, E.Message);
  end;
end;

procedure TSysConsultaCEP.ConsultarPorEndereco(AUF, ACidade, ALogradouro: string);
var
  Response: string;
begin
  UF := AUF;
  Cidade := ACidade;
  Logradouro := ALogradouro;

  if (FUF.IsEmpty) or (FCidade.IsEmpty) or (FLogradouro.IsEmpty) then
  begin
    if Assigned(FOnError) then
      FOnError(Self, 'UF, Cidade e Logradouro devem ser informados.');
    Exit;
  end;

  if (FCidade.Length <= 3) or (FLogradouro.Length <= 3) then
  begin
    if Assigned(FOnError) then
      FOnError(Self, 'Cidade e Logradouro devem conter pelo menos 3 caracteres');
    Exit;
  end;

  try
    Response := FHTTP.Get(Format('https://viacep.com.br/ws/%s/%s/%s/%s', [FUF, FCidade, FLogradouro, LowerCase(GetEnumName(TypeInfo(TRetornoTipo), Ord(FRetornoTipo)))]));
    Response := TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes(Response));
    FStrategy.ProcessarRetorno(Response, FOnResult, FOnError);

  except
    on E: Exception do
      if Assigned(FOnError) then
        FOnError(Self, E.Message);
  end;
end;

procedure TSysConsultaCEP.SetCEP(const Value: string);
begin
  FCEP := Value.Replace('-', '').Trim;
end;

procedure TSysConsultaCEP.SetUF(const Value: string);
begin
  FUF := Value;
end;

procedure TSysConsultaCEP.SetCidade(const Value: string);
begin
  FCidade := Value.Replace(' ', '%20');
end;

procedure TSysConsultaCEP.SetLogradouro(const Value: string);
begin
  FLogradouro := Value.Replace(' ', '%20');;
end;

procedure TSysConsultaCEP.SetRetornoTipo(const Value: TRetornoTipo);
begin
  FRetornoTipo := Value;
  SetStrategy(Value);
end;

procedure TSysConsultaCEP.SetStrategy(ARetornoTipo: TRetornoTipo);
begin
  case ARetornoTipo of
    TRetornoTipo.JSON:
      FStrategy := TFactoryStrategy.New.StrategyJSON;
    TRetornoTipo.XML:
      FStrategy := TFactoryStrategy.New.StrategyXML;
  else
    raise Exception.Create('Tipo de retorno n�o suportado.');
  end;
end;

end.

