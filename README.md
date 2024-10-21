**Projeto: Componente de Consulta de CEP**
**Descrição**
Este projeto é um componente Delphi para realizar consultas de CEP via APIs, com suporte a diferentes formatos de retorno, como JSON e XML. Ele permite realizar buscas por CEP ou endereço e retorna os dados de endereço completos, além de eventos para lidar com o sucesso ou falha da consulta.
Estrutura do Projeto (Componente)

/src
  |-- CConsultaCEP.pas
  |-- CConsultaCEP.Classes.pas
  |-- CConsultaCEP.EventsAndEnums.pas
  |-- CConsultaCEP.StrategyRetornoJSON.pas
  |-- CconsultaCEP.StrategyRetornoXML.pas
  |-- CconsultaCEP.HTTPIndy.pas
  |-- CconsultaCEP.Intf.pas
  |-- CConsultaCEP.StrategyFactory


**Design Patterns Utilizados**
    • Strategy Pattern: Utilizado para selecionar dinamicamente a estratégia de retorno da consulta (JSON ou XML), conforme a necessidade.
    • Observer Pattern: Utilizado para notificar o chamador através de eventos (OnResult, OnError) sobre o resultado ou falha das consultas.
    • Factory Pattern:  Foi utilizada uma fábrica para criar as instâncias das estratégias.

**Dependências**
    • REST.Json: Para manipulação de JSON.
    • MSXML: Para manipulação de XML. 
    • DUnitX: Utilizado para testes unitários e de integração.
**Como Utilizar o Componente**
    1. Configuração Inicial: Adicione o componente ao seu projeto, configure o formato de retorno desejado (JSON ou XML), e forneça eventos para capturar o sucesso ou erro da consulta.
_procedure TForm7.BitBtn1Click(Sender: TObject);
var
  ConsultaCEP: TSysConsultaCEP;
begin
  ConsultaCEP := TSysConsultaCEP.Create(nil);
  try
    ConsultaCEP.RetornoTipo := JSON;  // ou XML
    ConsultaCEP.OnResult := OnResult;
    ConsultaCEP.OnError  := OnErro;
    ConsultaCEP.ConsultarPorCEP('97577532');
  finally
    ConsultaCEP.Free;
  end;
end;

procedure TForm7.OnErro(Sender: TObject; const ErroMsg: string);
begin
  raise Exception.Create(ErroMsg);
end;

procedure TForm7.OnResult(const Endereco: TEndereco);
begin
  ShowMessage('Endereço: ' + Endereco.Logradouro);
end;_

**2. Aplicação de Exemplo: **
Na pasta App, você encontrará uma aplicação de exemplo que demonstra como utilizar o componente. Esta aplicação utiliza o SQLite como banco de dados e inclui um arquivo config.ini para definir o local da base de dados. 
- A aplicação grava todas as consultas realizadas na base. Caso um registro já exista, ela pergunta se você deseja atualizar os dados. 

**Testes**
O projeto inclui tanto testes unitários quanto testes de integração para validar o funcionamento do componente.
Executar os Testes
    • Testes Unitários: Validações de formatação de retorno (JSON e XML), erros de consulta e comportamento esperado do componente.
    • Testes de Integração: Executam consultas reais a APIs de CEP e verificam se as respostas são processadas corretamente pelo componente.
    1. Abra o projeto de testes no Delphi.
    2. Execute os testes diretamente no DUnitX.
Exemplo de Teste Unitário para JSON

_procedure TMyTestObject.TestConsultaJSONPorCEP;
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
end;_

Como Executar o Projeto
Certifique-se de que as dependências estejam configuradas no seu ambiente Delphi, e execute a aplicação prjTestes.exe.
