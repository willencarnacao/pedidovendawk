unit fmPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, uPedido, uCliente, uProduto,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  uDBConnection, FireDAC.Comp.Client, uPedidoController, FireDAC.Stan.Def,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL;

type
  TfrmPedido = class(TForm)
    lblCliente: TLabel;
    edCliente: TEdit;
    lblProduto: TLabel;
    edProduto: TEdit;
    lblQtd: TLabel;
    edQtd: TEdit;
    lblVlrUnit: TLabel;
    edVlrUnit: TEdit;
    btnSalvarItem: TButton;
    btnGravar: TButton;
    btnCarregar: TButton;
    btnCancelar: TButton;
    grid: TStringGrid;
    lblTotal: TLabel;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    btnLimpar: TButton;
    edNomeCliente: TEdit;
    edDescricaoProd: TEdit;
    lblModoEdicao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarItemClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edClienteChange(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edProdutoChange(Sender: TObject);
    procedure SelecionarItemGrid;
    procedure AtualizarItemSelecionado;
    procedure gridSelectCell(Sender: TObject; ACol, ARow: LongInt;
      var CanSelect: Boolean);
    procedure gridClick(Sender: TObject);
  private
    FConn: TDBConnection;
    FFD: TFDConnection;
    FController: TPedidoController;
    FPedido: TPedido;
    FProduto: TProduto;
    FCliente: TCliente;
    procedure AtualizarGrid;
    procedure AtualizarTotal;
    procedure AjustarTamanhoColunas;

  public
  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}

procedure TfrmPedido.FormCreate(Sender: TObject);
var
  IniPath: string;
begin
  Caption := 'Pedidos de Venda - WKTech';
  btnSalvarItem.Caption := 'Inserir';
  lblModoEdicao.Caption := '';
  FFD := TDBConnection.GetConnection;
  FFD.Connected := True;
  FController := TPedidoController.Create(FFD);
  FPedido := TPedido.Create;
  FProduto := TProduto.Create;
  FCliente := TCliente.Create;

  grid.ColCount := 5;
  grid.FixedRows := 1;
  grid.Cells[0, 0] := 'Cód. Produto';
  grid.ColWidths[0] := 100;
  grid.Cells[1, 0] := 'Descrição';
  grid.Cells[2, 0] := 'Qtde';
  grid.Cells[3, 0] := 'Vlr. Unit.';
  grid.Cells[4, 0] := 'Vlr. Total';
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProduto);
  FreeAndNil(FCliente);
  FreeAndNil(FPedido);
end;

procedure TfrmPedido.AtualizarGrid;
var
  i: Integer;
begin
  grid.RowCount := FPedido.Itens.Count + 1;
  for i := 0 to FPedido.Itens.Count - 1 do
  begin
    grid.Cells[0, i + 1] := FPedido.Itens[i].CodigoProduto.ToString;
    grid.Cells[1, i + 1] := FPedido.Itens[i].DescricaoProduto;
    grid.Cells[2, i + 1] := FormatFloat('0.###', FPedido.Itens[i].Quantidade);
    grid.Cells[3, i + 1] := FormatFloat('0.00', FPedido.Itens[i].ValorUnitario);
    grid.Cells[4, i + 1] := FormatFloat('0.00', FPedido.Itens[i].ValorTotal);
    AjustarTamanhoColunas;
  end;
end;

procedure TfrmPedido.AtualizarItemSelecionado;
var
  idx: Integer;
begin
  if (grid.Row > 0) then
  begin
    idx := grid.Row - 1;

    if (idx >= 0) and (idx < FPedido.Itens.Count) then
    begin
      FPedido.Itens[idx].CodigoProduto   := StrToIntDef(edProduto.Text, FPedido.Itens[idx].CodigoProduto);
      FPedido.Itens[idx].DescricaoProduto:= edDescricaoProd.Text;
      FPedido.Itens[idx].Quantidade      := StrToFloatDef(edQtd.Text, FPedido.Itens[idx].Quantidade);
      FPedido.Itens[idx].ValorUnitario   := StrToFloatDef(edVlrUnit.Text, FPedido.Itens[idx].ValorUnitario);
      FPedido.Itens[idx].ValorTotal      := FPedido.Itens[idx].Quantidade * FPedido.Itens[idx].ValorUnitario;

      FPedido.RecalcularTotal;
      AtualizarGrid;
      AtualizarTotal;
    end;
  end;
end;

procedure TfrmPedido.AtualizarTotal;
begin
  lblTotal.Caption := 'Valor total do pedido: R$ ' + FormatFloat('0.00', FPedido.ValorTotal);
end;

procedure TfrmPedido.btnSalvarItemClick(Sender: TObject);
var
  iCodigoProduto: Integer;
  nQuantidade: Double;
  nValorUnitario: Currency;
  idx: Integer;
begin
  if btnSalvarItem.Caption = 'Inserir' then
  begin
    // Modo inserir (novo item)
    iCodigoProduto := StrToIntDef(edProduto.Text, 0);
    nQuantidade := StrToFloatDef(edQtd.Text, 0);
    nValorUnitario := StrToFloatDef(edVlrUnit.Text, 0);

    if FController.AdicionarItem(FPedido, FProduto.Codigo, FProduto.Descricao, nQuantidade, nValorUnitario) then
    begin
      AtualizarGrid;
      AtualizarTotal;
      edProduto.Clear;
      edDescricaoProd.Clear;
      edQtd.Clear;
      edVlrUnit.Clear;
      edProduto.SetFocus;
    end;
  end
  else if btnSalvarItem.Caption = 'Atualizar' then
  begin
    // Modo atualizar (editar item selecionado)
    idx := grid.Row - 1;
    if (idx >= 0) and (idx < FPedido.Itens.Count) then
    begin
      FPedido.Itens[idx].CodigoProduto    := StrToIntDef(edProduto.Text, FPedido.Itens[idx].CodigoProduto);
      FPedido.Itens[idx].DescricaoProduto := edDescricaoProd.Text;
      FPedido.Itens[idx].Quantidade       := StrToFloatDef(edQtd.Text, FPedido.Itens[idx].Quantidade);
      FPedido.Itens[idx].ValorUnitario    := StrToFloatDef(edVlrUnit.Text, FPedido.Itens[idx].ValorUnitario);
      FPedido.Itens[idx].ValorTotal       := FPedido.Itens[idx].Quantidade * FPedido.Itens[idx].ValorUnitario;

      FPedido.RecalcularTotal;
      AtualizarGrid;
      AtualizarTotal;

      // Resetar para modo Inserir
      btnSalvarItem.Caption := 'Inserir';
      lblModoEdicao.Caption := '';
      edProduto.Clear;
      edDescricaoProd.Clear;
      edQtd.Clear;
      edVlrUnit.Clear;
      edProduto.SetFocus;
    end;
  end;
end;

procedure TfrmPedido.btnLimparClick(Sender: TObject);
begin
  edCliente.Clear;
  edNomeCliente.Clear;
  edProduto.Clear;
  edQtd.Clear;
  edVlrUnit.Clear;
  FController.LimparPedido(FPedido);
  AtualizarGrid;
  AtualizarTotal;
  btnSalvarItem.Caption := 'Inserir';
  lblModoEdicao.Caption := '';
end;

procedure TfrmPedido.edClienteChange(Sender: TObject);
begin
  // TODO: Alimentar FPedido.CodigoCliente?
  FController.CarregarCliente(StrToIntDef(edCliente.Text, 0), FCliente);
  edNomeCliente.Text := FCliente.Nome;
  btnCarregar.Visible := (FCliente.Codigo > 0);
  btnCancelar.Visible := (FCliente.Codigo > 0);
end;

procedure TfrmPedido.edProdutoChange(Sender: TObject);
begin
  FController.CarregarProduto(StrToIntDef(edProduto.Text, 0), FProduto);
  edDescricaoProd.Text := FProduto.Descricao;
  edVlrUnit.Text := CurrToStr(FProduto.PrecoVenda);
end;

procedure TfrmPedido.btnGravarClick(Sender: TObject);
begin
  FPedido.CodigoCliente := StrToIntDef(edCliente.Text, 0);

  if (FController.GravarPedido(FPedido)) then
    ShowMessage('Pedido gravado com número ' + FPedido.NumeroPedido.ToString);
end;

procedure TfrmPedido.btnCarregarClick(Sender: TObject);
var
  sNumeroPedido: string;
  nNumeroPedido: Integer;
begin
  sNumeroPedido := InputBox('Carregar Pedido', 'Número do Pedido:', '');
  nNumeroPedido := StrToIntDef(sNumeroPedido, 0);
  FController.CarregarPedido(nNumeroPedido, FPedido);

  if FPedido.CodigoCliente > 0 then
    edCliente.Text := FPedido.CodigoCliente.ToString
  else
    edCliente.Text := EmptyStr;

  AtualizarGrid;
  AtualizarTotal;

  if FPedido.NumeroPedido = 0 then
    ShowMessage('Pedido não encontrado.');
end;

procedure TfrmPedido.btnCancelarClick(Sender: TObject);
var
  sNumeroPedido: string;
  nNumeroPedido: Integer;
begin
  sNumeroPedido := InputBox('Cancelar Pedido', 'Número do Pedido:', '');
  nNumeroPedido := StrToIntDef(sNumeroPedido, 0);
  if (nNumeroPedido > 0) and (MessageDlg('Confirma cancelamento do pedido ' + sNumeroPedido + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    FController.CancelarPedido(nNumeroPedido);
    ShowMessage('Pedido cancelado.');
    AtualizarTotal;
  end;
end;

procedure TfrmPedido.gridClick(Sender: TObject);
begin
  SelecionarItemGrid;
end;

procedure TfrmPedido.gridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  idx: Integer;
begin
  // Enter para editar (quantidade e valor unitário) e Del para excluir
  if (Key = VK_RETURN) and (grid.Row > 0) then
  begin
    idx := grid.Row - 1;
    FPedido.Itens[idx].Quantidade := StrToFloatDef(InputBox('Editar', 'Quantidade:',
                                     grid.Cells[2, grid.Row]), FPedido.Itens[idx].Quantidade);
    FPedido.Itens[idx].ValorUnitario := StrToFloatDef(InputBox('Editar', 'Valor Unitário:',
                                        grid.Cells[3, grid.Row]), FPedido.Itens[idx].ValorUnitario);
    FPedido.Itens[idx].ValorTotal := FPedido.Itens[idx].Quantidade * FPedido.Itens[idx].ValorUnitario;
    edQtd.Text         := FloatToStr(FPedido.Itens[idx].Quantidade);
    edVlrUnit.Text     := CurrToStr(FPedido.Itens[idx].ValorUnitario);
    FPedido.RecalcularTotal;
    AtualizarGrid;
    AtualizarTotal;
  end
  else if (Key = VK_DELETE) and (grid.Row > 0) then
  begin
    if MessageDlg('Excluir item selecionado?', mtConfirmation, [mbYes, mbNo], 0)
      = mrYes then
    begin
      idx := grid.Row - 1;
      FPedido.Itens.Delete(idx);
      FPedido.RecalcularTotal;
      AtualizarGrid;
      AtualizarTotal;
    end
  end;
end;

procedure TfrmPedido.gridSelectCell(Sender: TObject; ACol, ARow: LongInt;
  var CanSelect: Boolean);
begin
  SelecionarItemGrid;
end;

procedure TfrmPedido.SelecionarItemGrid;
var
  idx: Integer;
begin
  if (grid.Row > 0) then
  begin
    idx := grid.Row - 1;

    if (idx >= 0) and (idx < FPedido.Itens.Count) then
    begin
      edProduto.Text     := FPedido.Itens[idx].CodigoProduto.ToString;
      edDescricaoProd.Text := FPedido.Itens[idx].DescricaoProduto;
      edQtd.Text         := FloatToStr(FPedido.Itens[idx].Quantidade);
      edVlrUnit.Text     := CurrToStr(FPedido.Itens[idx].ValorUnitario);

      // Troca o botão para modo "Atualizar"
      btnSalvarItem.Caption := 'Atualizar';
      lblModoEdicao.Caption := 'Editando item ' + (idx + 1).ToString;
    end;
  end;
end;

procedure TfrmPedido.AjustarTamanhoColunas;
var
  I: Integer;
  LarguraFixas, LarguraTotal, QtdeColunas, NovaLargura: Integer;
begin
  with grid do
  begin
    // Soma a largura das colunas fixas
    LarguraFixas := 0;
    for I := 0 to FixedCols - 1 do
      Inc(LarguraFixas, ColWidths[I] + GridLineWidth);

    // Calcula a largura disponível para as colunas variáveis
    LarguraTotal := ClientWidth - LarguraFixas - (GridLineWidth * (ColCount - FixedCols));

    // Quantidade de colunas que devem ser ajustadas
    QtdeColunas := ColCount - FixedCols;

    if QtdeColunas > 0 then
    begin
      NovaLargura := LarguraTotal div QtdeColunas;

      // Ajusta todas as colunas não fixas igualmente
      for I := FixedCols to ColCount - 1 do
        ColWidths[I] := NovaLargura;
    end;
  end;
end;

end.
