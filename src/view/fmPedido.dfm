object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  Caption = 'Pedidos de Venda - WKTech'
  ClientHeight = 420
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblCliente: TLabel
    Left = 16
    Top = 16
    Width = 65
    Height = 15
    Caption = 'C'#243'd. Cliente'
  end
  object lblProduto: TLabel
    Left = 16
    Top = 72
    Width = 71
    Height = 15
    Caption = 'C'#243'd. Produto'
  end
  object lblQtd: TLabel
    Left = 399
    Top = 72
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object lblVlrUnit: TLabel
    Left = 478
    Top = 72
    Width = 71
    Height = 15
    Caption = 'Valor Unit'#225'rio'
  end
  object lblTotal: TLabel
    Left = 16
    Top = 368
    Width = 153
    Height = 15
    Caption = 'Valor total do pedido: R$ 0,00'
  end
  object lblModoEdicao: TLabel
    Left = 16
    Top = 117
    Width = 80
    Height = 15
    Caption = 'lblModoEdicao'
  end
  object edCliente: TEdit
    Left = 16
    Top = 34
    Width = 65
    Height = 23
    TabOrder = 0
    OnChange = edClienteChange
  end
  object btnCarregar: TButton
    Left = 328
    Top = 370
    Width = 120
    Height = 28
    Caption = '&Carregar Pedido'
    TabOrder = 6
    OnClick = btnCarregarClick
  end
  object btnCancelar: TButton
    Left = 456
    Top = 370
    Width = 120
    Height = 28
    Caption = 'Ca&ncelar Pedido'
    TabOrder = 7
    OnClick = btnCancelarClick
  end
  object edProduto: TEdit
    Left = 16
    Top = 88
    Width = 65
    Height = 23
    TabOrder = 1
    OnChange = edProdutoChange
  end
  object edQtd: TEdit
    Left = 399
    Top = 88
    Width = 73
    Height = 23
    TabOrder = 2
  end
  object edVlrUnit: TEdit
    Left = 478
    Top = 88
    Width = 81
    Height = 23
    TabOrder = 3
  end
  object btnSalvarItem: TButton
    Left = 568
    Top = 83
    Width = 120
    Height = 28
    Caption = 'Inserir'
    TabOrder = 4
    OnClick = btnSalvarItemClick
  end
  object grid: TStringGrid
    Left = 16
    Top = 136
    Width = 688
    Height = 216
    TabOrder = 5
    OnClick = gridClick
    OnKeyDown = gridKeyDown
    OnSelectCell = gridSelectCell
  end
  object btnGravar: TButton
    Left = 584
    Top = 368
    Width = 120
    Height = 32
    Caption = '&Gravar Pedido'
    TabOrder = 8
    OnClick = btnGravarClick
  end
  object btnLimpar: TButton
    Left = 568
    Top = 32
    Width = 120
    Height = 28
    Caption = '&Limpar'
    TabOrder = 9
    OnClick = btnLimparClick
  end
  object edNomeCliente: TEdit
    Left = 87
    Top = 34
    Width = 472
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 10
    OnChange = edClienteChange
  end
  object edDescricaoProd: TEdit
    Left = 87
    Top = 88
    Width = 306
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 11
    OnChange = edClienteChange
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 568
    Top = 144
  end
end
