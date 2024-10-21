unit App.model.Cep.Intf;

interface

uses
  Data.DB;

type
  ICadastrarCep = interface;
  IDAO_CEP = interface
    ['{CA1B3B8F-4346-43C3-9821-A8FB2E85F84D}']
    function DataSource( AValue : TDataSource ) : IDAO_CEP;
    function Open : IDAO_CEP;
    function CadastrarCEP : ICadastrarCep;
    function FiltrarPorCEP( AValue : string ) : IDAO_CEP;
    function FiltrarPorEndereco( AUF, ACidade, ALogradouro : string ) :IDAO_CEP;
  end;

  ICadastrarCep = interface
    ['{BC812CA9-9044-405F-815F-E16C4A0B3622}']
    function CEP( AValue : string ) : ICadastrarCep;
    function Logradouro( AValue : string ) : ICadastrarCep;
    function Complemento( AValue : string ) : ICadastrarCep;
    function Bairro( AValue : string ) : ICadastrarCep;
    function Localidade( AValue : string ) : ICadastrarCep;
    function UF( AValue : string ) : ICadastrarCep;
    function Cadastrar : ICadastrarCep;
  end;

implementation

end.
