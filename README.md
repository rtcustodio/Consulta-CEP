<h1>Projeto: Componente de Consulta de CEP</h1>


![Badge](https://img.shields.io/static/v1?label=delphi&message=language&color=blue&style=for-the-badge&logo=delphi)</br>
<b>Descrição</b></br>

Este projeto é um componente Delphi para realizar consultas de CEP via API da ViaCEP, com suporte a diferentes formatos de retorno, como JSON e XML. Ele permite realizar buscas por CEP ou endereço e retorna os dados de endereço completos, além de eventos para lidar com o sucesso ou falha da consulta.</br>
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
<b>Dependências</b></br>
    • REST.Json: Para manipulação de JSON.</br>
    • MSXML: Para manipulação de XML. </br>
    • DUnitX: Utilizado para testes unitários e de integração.</br>
    • OpenSSL: Utilizado para conexão segura da API.</br>
    </br>
<b>Como Utilizar o Componente</b>
    Configuração Inicial: Adicione o componente ao seu projeto, configure o formato de retorno desejado (JSON ou XML), e forneça eventos para capturar o sucesso ou erro da consulta.</br>
```sh
procedure TForm7.BitBtn1Click(Sender: TObject);
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
end;
```

<b>Aplicação de Exemplo:</b><br>
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

```sh
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
```

##Como Executar o Projeto

Certifique-se de que as dependências estejam configuradas no seu ambiente Delphi, e execute a aplicação prjTestes.exe.</br>
