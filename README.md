<h1>Projeto: Componente de Consulta de CEP</h1>

<b>Descrição</b></br>

Este projeto é um componente Delphi para realizar consultas de CEP via APIs, com suporte a diferentes formatos de retorno, como JSON e XML. Ele permite realizar buscas por CEP ou endereço e retorna os dados de endereço completos, além de eventos para lidar com o sucesso ou falha da consulta.</br>
Estrutura do Projeto (Componente)</br>
</br>
/src</br>
  |-- CConsultaCEP.pas</br>
  |-- CConsultaCEP.Classes.pas</br>
  |-- CConsultaCEP.EventsAndEnums.pas</br>
  |-- CConsultaCEP.StrategyRetornoJSON.pas</br>
  |-- CconsultaCEP.StrategyRetornoXML.pas</br>
  |-- CconsultaCEP.HTTPIndy.pas</br>
  |-- CconsultaCEP.Intf.pas</br>
  |-- CConsultaCEP.StrategyFactory</br>
  </br>
</br>
<b>Design Patterns Utilizados</b></br>
    • Strategy Pattern: Utilizado para selecionar dinamicamente a estratégia de retorno da consulta (JSON ou XML), conforme a necessidade.</br>
    • Observer Pattern: Utilizado para notificar o chamador através de eventos (OnResult, OnError) sobre o resultado ou falha das consultas.</br>
    • Factory Pattern:  Foi utilizada uma fábrica para criar as instâncias das estratégias.</br>
</br>
<b>Dependências</b>
    • REST.Json: Para manipulação de JSON.</br>
    • MSXML: Para manipulação de XML. </br>
    • DUnitX: Utilizado para testes unitários e de integração.</br>
    </br>
<b>Como Utilizar o Componente</b>
    1. Configuração Inicial: Adicione o componente ao seu projeto, configure o formato de retorno desejado (JSON ou XML), e forneça eventos para capturar o sucesso ou erro da consulta.</br>
<i>procedure TForm7.BitBtn1Click(Sender: TObject);</br>
var</br>
  ConsultaCEP: TSysConsultaCEP;</br>
begin</br>
  ConsultaCEP := TSysConsultaCEP.Create(nil);</br>
  try</br>
    ConsultaCEP.RetornoTipo := JSON;  // ou XML</br>
    ConsultaCEP.OnResult := OnResult;</br>
    ConsultaCEP.OnError  := OnErro;</br>
    ConsultaCEP.ConsultarPorCEP('97577532');</br>
  finally</br>
    ConsultaCEP.Free;</br>
  end;</br>
end;</br>
</br>
procedure TForm7.OnErro(Sender: TObject; const ErroMsg: string);</br>
begin</br>
  raise Exception.Create(ErroMsg);</br>
end;</br>
</br>
procedure TForm7.OnResult(const Endereco: TEndereco);</br>
begin</br>
  ShowMessage('Endereço: ' + Endereco.Logradouro);</br>
end;</br></i>
</br>
<b>2. Aplicação de Exemplo:</b><br>
- Na pasta App, você encontrará uma aplicação de exemplo que demonstra como utilizar o componente. Esta aplicação utiliza o SQLite como banco de dados e inclui um arquivo config.ini para definir o local da base de dados. </br>
<b>*** Configurar o local do banco de dados no config.ini***</b><br>
- A aplicação grava todas as consultas realizadas na base. Caso um registro já exista, ela pergunta se você deseja atualizar os dados. </br>
</br>
<b>Testes</b>
O projeto inclui tanto testes unitários quanto testes de integração para validar o funcionamento do componente.</br>
Executar os Testes</br>
    • Testes Unitários: Validações de formatação de retorno (JSON e XML), erros de consulta e comportamento esperado do componente.</br>
    • Testes de Integração: Executam consultas reais a APIs de CEP e verificam se as respostas são processadas corretamente pelo componente.</br>
    1. Abra o projeto de testes no Delphi.</br>
    2. Execute os testes diretamente no DUnitX.</br>
Exemplo de Teste Unitário para JSON</br>
</br>
<i>procedure TMyTestObject.TestConsultaJSONPorCEP;</br>
begin</br>
  SysConsultaCEP1.RetornoTipo := JSON;</br>
  SysConsultaCEP1.OnError := OnErro;</br>
  SysConsultaCEP1.OnResult := OnResultTestJSON;</br>
  SysConsultaCEP1.ConsultarPorCEP('97577532');</br>
end;</br>
</br>
procedure TMyTestObject.TestConsultaJSONPorEndereco;</br>
begin</br>
  SysConsultaCEP1.RetornoTipo := JSON;</br>
  SysConsultaCEP1.OnError := OnErro;</br>
  SysConsultaCEP1.OnResult := OnResultTestJSONEndereco;</br>
  SysConsultaCEP1.ConsultarPorEndereco('RS', 'SANTANA DO LIVRAMENTO', 'LUIZ PEDRO IRIGOIEN');</br>
end;</br></i>
</br>
<b>Como Executar o Projeto</b></br>
Certifique-se de que as dependências estejam configuradas no seu ambiente Delphi, e execute a aplicação prjTestes.exe.</br>
