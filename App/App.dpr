program App;

uses
  Vcl.Forms,
  App.view.Principal in 'src\view\App.view.Principal.pas' {frmPrincipal},
  App.model.Datamodule in 'src\model\datamodule\App.model.Datamodule.pas' {DM: TDataModule},
  App.model.Query in 'src\model\Query\App.model.Query.pas',
  App.model.SQLConditions in 'src\model\Query\App.model.SQLConditions.pas',
  App.model.DB.Intf in 'src\model\Query\App.model.DB.Intf.pas',
  SimpleQueryFiredac in 'src\model\Query\SimpleQueryFiredac.pas',
  App.model.QueryFactory in 'src\model\Query\App.model.QueryFactory.pas',
  App.model.Cep.Intf in 'src\model\CepResults\App.model.Cep.Intf.pas',
  App.model.Cep in 'src\model\CepResults\App.model.Cep.pas',
  App.model.Cep.CadastrarCep in 'src\model\CepResults\App.model.Cep.CadastrarCep.pas',
  Vcl.Themes,
  Vcl.Styles,
  App.model.stringUtils in 'src\model\utils\App.model.stringUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Radiant');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
