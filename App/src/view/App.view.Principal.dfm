object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Busca CEP'
  ClientHeight = 549
  ClientWidth = 1019
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object Label1: TLabel
    Left = 0
    Top = 105
    Width = 1019
    Height = 25
    Align = alTop
    Caption = 'Listagem dos endere'#231'os'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitTop = 185
    ExplicitWidth = 212
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1019
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object rdgTipoPesquisa: TRadioGroup
      Left = 0
      Top = 0
      Width = 169
      Height = 105
      Align = alLeft
      Caption = 'Tipo de Pesquisa'
      ItemIndex = 0
      Items.Strings = (
        'Por CEP'
        'Por Endere'#231'o')
      TabOrder = 0
      OnClick = rdgTipoPesquisaClick
      ExplicitLeft = 169
      ExplicitHeight = 81
    end
    object rdgTipoRetorno: TRadioGroup
      Left = 850
      Top = 0
      Width = 169
      Height = 105
      Align = alRight
      Caption = 'Tipo de Retorno'
      ItemIndex = 0
      Items.Strings = (
        'JSON'
        'XML')
      TabOrder = 1
      OnClick = rdgTipoRetornoClick
      ExplicitLeft = 0
      ExplicitHeight = 81
    end
    object grpPesquisaEndereco: TGroupBox
      Left = 169
      Top = 0
      Width = 576
      Height = 105
      Align = alLeft
      Caption = 'Pesquisar por Endere'#231'o'
      TabOrder = 2
      Visible = False
      ExplicitLeft = 569
      ExplicitTop = -6
      ExplicitHeight = 81
      object edtUF: TLabeledEdit
        Left = 6
        Top = 49
        Width = 83
        Height = 29
        CharCase = ecUpperCase
        EditLabel.Width = 19
        EditLabel.Height = 21
        EditLabel.Caption = 'UF'
        TabOrder = 0
        Text = ''
      end
      object edtCidade: TLabeledEdit
        Left = 95
        Top = 49
        Width = 154
        Height = 29
        CharCase = ecUpperCase
        EditLabel.Width = 48
        EditLabel.Height = 21
        EditLabel.Caption = 'Cidade'
        TabOrder = 1
        Text = ''
      end
      object edtLogradouro: TLabeledEdit
        Left = 255
        Top = 49
        Width = 218
        Height = 29
        CharCase = ecUpperCase
        EditLabel.Width = 82
        EditLabel.Height = 21
        EditLabel.Caption = 'Logradouro'
        TabOrder = 2
        Text = ''
      end
      object BitBtn3: TBitBtn
        AlignWithMargins = True
        Left = 479
        Top = 48
        Width = 92
        Height = 30
        Margins.Top = 25
        Margins.Bottom = 25
        Align = alRight
        Caption = 'Pesquisar'
        TabOrder = 3
        OnClick = BitBtn3Click
        ExplicitHeight = 6
      end
    end
    object grpPesquisaCEP: TGroupBox
      Left = 745
      Top = 0
      Width = 225
      Height = 105
      Align = alLeft
      Caption = 'Pesquisar CEP'
      TabOrder = 3
      ExplicitLeft = 569
      object edtCEP: TLabeledEdit
        Left = 14
        Top = 49
        Width = 121
        Height = 29
        CharCase = ecUpperCase
        EditLabel.Width = 27
        EditLabel.Height = 21
        EditLabel.Caption = 'CEP'
        NumbersOnly = True
        TabOrder = 0
        Text = ''
      end
      object BitBtn1: TBitBtn
        AlignWithMargins = True
        Left = 149
        Top = 48
        Width = 71
        Height = 30
        Margins.Top = 25
        Margins.Bottom = 25
        Align = alRight
        Caption = 'Pesquisar'
        TabOrder = 1
        OnClick = BitBtn1Click
        ExplicitHeight = 6
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 130
    Width = 1019
    Height = 384
    Align = alClient
    DataSource = dsConsultas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'cep'
        Title.Caption = 'CEP'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'logradouro'
        Title.Caption = 'Logradouro'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'complemento'
        Title.Caption = 'Complemento'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bairro'
        Title.Caption = 'Bairro'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'localidade'
        Title.Caption = 'Cidade'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'uf'
        Title.Caption = 'UF'
        Width = 60
        Visible = True
      end>
  end
  object Panel3: TPanel
    Left = 0
    Top = 514
    Width = 1019
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblQuantidadeListada: TLabel
      AlignWithMargins = True
      Left = 180
      Top = 3
      Width = 9
      Height = 29
      Align = alLeft
      Caption = '0'
      Layout = tlCenter
      ExplicitLeft = 194
      ExplicitHeight = 21
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 171
      Height = 29
      Align = alLeft
      Caption = 'Quantidade listada:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 25
    end
    object BitBtn2: TBitBtn
      AlignWithMargins = True
      Left = 768
      Top = 3
      Width = 248
      Height = 29
      Align = alRight
      Caption = 'Listar todos CEPs cadastrados'
      TabOrder = 0
      OnClick = BitBtn2Click
    end
  end
  object SysConsultaCEP1: TSysConsultaCEP
    OnResult = SysConsultaCEP1Result
    OnError = SysConsultaCEP1Error
    Left = 744
    Top = 16
  end
  object dsConsultas: TDataSource
    OnDataChange = dsConsultasDataChange
    Left = 480
    Top = 392
  end
end
