unit CConsultaCEP.StrategyRetornoXML;

interface

uses
  CConsultaCEP.Intf,
  CConsultaCEP.EventsAndEnums,
  System.Variants,
  CConsultaCEP.Classes,
  MSXML,
  Xml.XMLDoc, Xml.XMLIntf, Xml.Win.msxmldom;

type
  TXMLRetornoStrategy = class(TInterfacedObject, IRetornoStrategy)
  private

  public
    procedure ProcessarRetorno(const AResponse: string; AOnResult: TViaCEPResult; AOnError: TNotifyErrorEvent);
  end;

implementation

uses
  System.SysUtils;

{ TConsultaCEPStrategyXML }

procedure TXMLRetornoStrategy.ProcessarRetorno(const AResponse: string; AOnResult: TViaCEPResult; AOnError: TNotifyErrorEvent);
var
  XMLDocument: IXMLDocument;
  RootNode, EnderecoNode, EnderecosNode: IXMLNode;
  Endereco : TEndereco;
  I: Integer;
  Erro : boolean;
begin
  XMLDocument := LoadXMLData(AResponse);
  XMLDocument.Encoding := 'UTF-8';
  //XMLDocument.DOMVendor := GetDOMVendor('MSXML');
  RootNode := XMLDocument.DocumentElement;

  if not Assigned(RootNode) then
    raise Exception.Create('Erro no formato do XML.');

  try
    if RootNode.NodeName = 'xmlcep' then
    begin
      EnderecosNode := RootNode.ChildNodes.FindNode('enderecos');

      if Assigned(EnderecosNode) then
      begin
        if EnderecosNode.ChildNodes.Count = 0 then
        begin
          if Assigned(AOnError) then
            AOnError(Self, 'Nenhum endere�o localizado');
          Abort;
        end;

        for I := 0 to EnderecosNode.ChildNodes.Count - 1 do
        begin
          Endereco := TEndereco.Create;
          EnderecoNode := EnderecosNode.ChildNodes[I];
          Endereco.CEP := EnderecoNode.ChildValues['cep'];
          if not VarIsNull( EnderecoNode.ChildValues['logradouro'] ) then
            Endereco.Logradouro := EnderecoNode.ChildValues['logradouro'];
          if not VarIsNull( EnderecoNode.ChildValues['complemento'] ) then
            Endereco.Complemento := EnderecoNode.ChildValues['complemento'];
          if not VarIsNull( EnderecoNode.ChildValues['bairro'] ) then
            Endereco.Bairro := EnderecoNode.ChildValues['bairro'];
          Endereco.Localidade := EnderecoNode.ChildValues['localidade'];
          Endereco.UF := EnderecoNode.ChildValues['uf'];

          if Assigned(AOnResult) then
            AOnResult(Endereco);
        end;
      end
      else
      begin
        Erro := false;
        if not VarIsNull( RootNode.ChildValues['erro'] ) then
          Erro := VarToStr(RootNode.ChildValues['erro']).ToBoolean;

        if Erro and Assigned(AOnError) then
        begin
          AOnError(Self, 'O CEP informado n�o existe.');
          Abort;
        end;

        Endereco := TEndereco.Create;
        Endereco.CEP := RootNode.ChildValues['cep'];
        Endereco.Logradouro := RootNode.ChildValues['logradouro'];
        if not VarIsNull( RootNode.ChildValues['complemento'] ) then
          Endereco.Complemento := RootNode.ChildValues['complemento'];
        Endereco.Bairro := RootNode.ChildValues['bairro'];
        Endereco.Localidade := RootNode.ChildValues['localidade'];
        Endereco.UF := RootNode.ChildValues['uf'];

        if Assigned(AOnResult) then
          AOnResult(Endereco);
      end;
    end
    else
      raise Exception.Create('Formato de resposta XML n�o suportado.');
  except
    on E: Exception do
    begin
      if E is EAbort then Abort;

      if Assigned(AOnError) then
        AOnError(Self, 'Erro ao processar o retorno JSON: ' + E.Message)
      else raise Exception.Create(e.Message);

    end;
  end;

end;

end.
