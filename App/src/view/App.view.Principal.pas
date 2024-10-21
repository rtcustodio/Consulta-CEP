unit App.view.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CConsultaCEP, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Data.DB, Vcl.Mask, Vcl.Grids, Vcl.DBGrids, App.model.Cep.Intf,
  App.model.Cep, App.model.stringUtils, CConsultaCEP.Classes;

type
  TfrmPrincipal = class(TForm)
    SysConsultaCEP1: TSysConsultaCEP;
    Panel1: TPanel;
    rdgTipoPesquisa: TRadioGroup;
    DBGrid1: TDBGrid;
    rdgTipoRetorno: TRadioGroup;
    Panel2: TPanel;
    grpPesquisaCEP: TGroupBox;
    edtCEP: TLabeledEdit;
    grpPesquisaEndereco: TGroupBox;
    edtUF: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtLogradouro: TLabeledEdit;
    BitBtn1: TBitBtn;
    dsConsultas: TDataSource;
    Label1: TLabel;
    Panel3: TPanel;
    lblQuantidadeListada: TLabel;
    Label2: TLabel;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure SysConsultaCEP1Result(const Endereco: TEndereco);
    procedure rdgTipoPesquisaClick(Sender: TObject);
    procedure SysConsultaCEP1Error(Sender: TObject; const ErrorMsg: string);
    procedure rdgTipoRetornoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dsConsultasDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    FCEP : IDAO_CEP;
    FStringCEPSBusca : TStringList;
    procedure PesquisarPorCEP;
    procedure PesquisarPorEndereco;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  CConsultaCEP.EventsAndEnums;

{$R *.dfm}

procedure TfrmPrincipal.BitBtn1Click(Sender: TObject);
begin
  case rdgTipoPesquisa.ItemIndex of
   0: PesquisarPorCEP;
   1: PesquisarPorEndereco;
  end;
end;

procedure TfrmPrincipal.BitBtn2Click(Sender: TObject);
begin
  FCEP.Open;
end;

procedure TfrmPrincipal.DBGrid1DblClick(Sender: TObject);
begin
  edtCEP.Text := dsConsultas.DataSet.FieldByName('cep').AsString;
end;

procedure TfrmPrincipal.dsConsultasDataChange(Sender: TObject; Field: TField);
begin
  lblQuantidadeListada.Caption := dsConsultas.DataSet.RecordCount.ToString;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FStringCEPSBusca := TStringList.Create;
  FStringCEPSBusca.Delimiter := ',';
  case rdgTipoRetorno.ItemIndex of
    0: SysConsultaCEP1.RetornoTipo := JSON;
    1: SysConsultaCEP1.RetornoTipo := XML;
  end;

  FCEP := TDAO_CEP.New.DataSource(dsConsultas).Open;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStringCEPSBusca);
end;

procedure TfrmPrincipal.PesquisarPorCEP;
begin
  FStringCEPSBusca.Clear;
  FCEP.FiltrarPorCEP(edtCEP.Text);
  if not dsConsultas.DataSet.IsEmpty then
  begin
    var Resp := Application.MessageBox('CEP pesquisado já existe na base de dados. Deseja atualizar os dados em uma nova pesquisa?', 'Confirma', MB_YESNO + MB_ICONQUESTION);
    if Resp = mrNo then Exit;
  end;

  SysConsultaCEP1.ConsultarPorCEP(edtCEP.Text);
  FCEP.FiltrarPorCEP( FStringCEPSBusca.DelimitedText );
end;

procedure TfrmPrincipal.PesquisarPorEndereco;
begin
  FStringCEPSBusca.Clear;
  FCEP.FiltrarPorEndereco(RemoveAcentos( edtUF.Text ), RemoveAcentos( edtCidade.Text ), RemoveAcentos( edtLogradouro.Text ));
  if not dsConsultas.DataSet.IsEmpty then
  begin
    var Resp := Application.MessageBox('Endereço pesquisado já existe na base de dados. Deseja atualizar os dados em uma nova pesquisa?', 'Confirma', MB_YESNO + MB_ICONQUESTION);
    if Resp = mrNo then Exit;
  end;

  SysConsultaCEP1.ConsultarPorEndereco(edtUF.Text, edtCidade.Text, edtLogradouro.Text);
  FCEP.FiltrarPorCEP( FStringCEPSBusca.DelimitedText );
end;

procedure TfrmPrincipal.rdgTipoPesquisaClick(Sender: TObject);
  procedure ConfiguraPesquisaCEP;
  begin
    grpPesquisaCEP.Visible := true;
    grpPesquisaEndereco.Visible := false;
    edtCEP.SetFocus;
  end;

  procedure ConfiguraPesquisaEndereco;
  begin
    grpPesquisaCEP.Visible := false;
    grpPesquisaEndereco.Visible := true;
    edtUF.SetFocus;
  end;
begin
  case rdgTipoPesquisa.ItemIndex of
   0: ConfiguraPesquisaCEP ;
   1: ConfiguraPesquisaEndereco;
  end;
end;

procedure TfrmPrincipal.rdgTipoRetornoClick(Sender: TObject);
begin
  case rdgTipoRetorno.ItemIndex of
   0 : SysConsultaCEP1.RetornoTipo := JSON;
   1 : SysConsultaCEP1.RetornoTipo := XML;
  end;
end;

procedure TfrmPrincipal.SysConsultaCEP1Error(Sender: TObject; const ErrorMsg: string);
begin
  Application.MessageBox(PWideChar(ErrorMsg), 'Atenção', MB_ICONWARNING);
end;

procedure TfrmPrincipal.SysConsultaCEP1Result(const Endereco: TEndereco);
begin
  FCEP.CadastrarCEP
    .CEP( Endereco.CEP )
    .Logradouro( Endereco.Logradouro )
    .Complemento( Endereco.Complemento )
    .Bairro( Endereco.Bairro )
    .Localidade( Endereco.Localidade )
    .UF( Endereco.UF )
    .Cadastrar;

  FStringCEPSBusca.Add( Endereco.CEP.Replace('-', '') );
end;

end.
