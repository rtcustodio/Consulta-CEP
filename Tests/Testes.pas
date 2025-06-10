unit Testes;

interface

uses
  DUnitX.TestFramework,
  CConsultaCEP,
  CConsultaCEP.Classes,
  CConsultaCEP.EventsAndEnums,
  SysUtils;

type
  [TestFixture]
  TMyTestObject = class
  private
    SysConsultaCEP1: TSysConsultaCEP;
    FErroMsg: string;
    procedure OnErro( Sender : TObject; const ErroMsg : string );
    procedure OnErroSalvar(Sender : TObject; const ErroMsg : string );
    procedure OnResultTestJSON(const Endereco : TEndereco);
    procedure OnResultTestJSONEndereco(const Endereco : TEndereco);
    procedure OnResultTestXML(const Endereco : TEndereco);
    procedure OnResultTestXMLEndereco(const Endereco : TEndereco);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestConsultaJSONPorCEP;
    [Test]
    procedure TestConsultaJSONPorEndereco;
    [Test]
    procedure TestConsultaXMLPorCEP;
    [Test]
    procedure TestConsultaXMLPorEndereco;
    [Test]
    procedure TestCEPInvalido;
  end;

implementation

procedure TMyTestObject.OnErro(Sender: TObject; const ErroMsg: string);
begin
  raise Exception.Create(ErroMsg);
end;

procedure TMyTestObject.OnErroSalvar(Sender: TObject; const ErroMsg: string);
begin
  FErroMsg := ErroMsg;
end;

procedure TMyTestObject.OnResultTestJSON(const Endereco: TEndereco);
begin
  try
    Assert.AreEqual('97577-532', Endereco.CEP);

  except
    on e : exception do
      raise Exception.Create(e.Message);
  end;
end;

procedure TMyTestObject.OnResultTestJSONEndereco(const Endereco: TEndereco);
begin
  try
    Assert.AreEqual('97575-390', Endereco.CEP);

  except
    on e : exception do
      raise Exception.Create(e.Message);
  end
end;

procedure TMyTestObject.OnResultTestXML(const Endereco: TEndereco);
begin
  try
    Assert.AreEqual('97577-532', Endereco.CEP);

  except
    on e : exception do
      raise Exception.Create(e.Message);
  end;

end;

procedure TMyTestObject.OnResultTestXMLEndereco(const Endereco: TEndereco);
begin
  try
    Assert.AreEqual('97575-390', Endereco.CEP);

  except
    on e : exception do
      raise Exception.Create(e.Message);
  end
end;

procedure TMyTestObject.Setup;
begin
  SysConsultaCEP1 := TSysConsultaCEP.Create(nil);
end;

procedure TMyTestObject.TearDown;
begin
  FreeAndNil(SysConsultaCEP1);
end;

procedure TMyTestObject.TestConsultaJSONPorCEP;
begin
  SysConsultaCEP1.RetornoTipo := JSON;
  SysConsultaCEP1.OnError := OnErro;
  SysConsultaCEP1.OnResult := OnResultTestJSON;
  SysConsultaCEP1.ConsultarPorCEP('97577532');
end;

procedure TMyTestObject.TestConsultaJSONPorEndereco;
begin
  SysConsultaCEP1.RetornoTipo := JSON;
  SysConsultaCEP1.OnError := OnErro;
  SysConsultaCEP1.OnResult := OnResultTestJSONEndereco;
  SysConsultaCEP1.ConsultarPorEndereco('RS', 'SANTANA DO LIVRAMENTO', 'LUIZ PEDRO IRIGOIEN');
end;

procedure TMyTestObject.TestConsultaXMLPorCEP;
begin
  SysConsultaCEP1.RetornoTipo := XML;
  SysConsultaCEP1.OnError := OnErro;
  SysConsultaCEP1.OnResult := OnResultTestXML;
  SysConsultaCEP1.ConsultarPorCEP('97577532');
end;

procedure TMyTestObject.TestConsultaXMLPorEndereco;
begin
  SysConsultaCEP1.RetornoTipo := XML;
  SysConsultaCEP1.OnError := OnErro;
  SysConsultaCEP1.OnResult := OnResultTestXMLEndereco;
  SysConsultaCEP1.ConsultarPorEndereco('RS', 'SANTANA DO LIVRAMENTO', 'LUIZ PEDRO IRIGOIEN');
end;

procedure TMyTestObject.TestCEPInvalido;
begin
  FErroMsg := '';
  SysConsultaCEP1.RetornoTipo := JSON;
  SysConsultaCEP1.OnError := OnErroSalvar;
  SysConsultaCEP1.ConsultarPorCEP('123');
  Assert.AreEqual('CEP inválido. O CEP deve ter 8 dígitos.', FErroMsg);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
