unit uPedidoController;

interface

uses uPedido, uProduto, uCliente, uProdutoDAO, uClienteDAO, FireDAC.Comp.Client;

type
  TPedidoController = class
  private
    FConn: TFDConnection;
    FProdutoDAO: TProdutoDAO;
    FClienteDAO: TClienteDAO;
  public
    constructor Create(AConn: TFDConnection);
    destructor Destroy; override;
    function AdicionarItem(APedido: TPedido; ACodigoProduto: Integer; ADescricaoProduto: String; AQuantidade: Double; AValorUnitario: Currency): Boolean;
    function GravarPedido(APedido: TPedido): Boolean;
    procedure CarregarPedido(ANumero: Integer; APedido: TPedido);
    procedure CarregarProduto(ACodigoProduto: Integer; AProduto: TProduto);
    procedure CarregarCliente(ACodigoCliente: Integer; ACliente: TCliente);
    procedure CancelarPedido(ANumero: Integer);
    procedure LimparPedido(APedido: TPedido);
  end;

implementation

uses System.SysUtils, uPedidoDAO, VCL.Dialogs;

constructor TPedidoController.Create(AConn: TFDConnection);
begin
  FConn := AConn;
  FProdutoDAO := TProdutoDAO.Create(FConn);
  FClienteDAO := TClienteDAO.Create(FConn);
end;

destructor TPedidoController.Destroy;
begin
  FProdutoDAO.Free;
  FClienteDAO.Free;
  inherited;
end;

function TPedidoController.AdicionarItem(APedido: TPedido; ACodigoProduto: Integer; ADescricaoProduto: String; AQuantidade: Double; AValorUnitario: Currency): Boolean;
var
  oItem: TPedidoItem;
  oProduto: TProduto;
begin
  Result := False;

  oProduto := TProduto.Create;
  try
    CarregarProduto(ACodigoProduto, oProduto);

    if (oProduto.Codigo = 0) then
    begin
      ShowMessage('Produto não encontrado');
      Exit;
    end;
  finally
    FreeAndNil(oProduto);
  end;

  if AQuantidade <= 0 then
  begin
    ShowMessage('Quantidade deve ser maior que zero.');
    Exit;
  end;

  if AValorUnitario <= 0 then
  begin
    ShowMessage('Valor unitário deve ser maior que zero.');
    Exit;
  end;

  oItem := TPedidoItem.Create;
  oItem.CodigoProduto := ACodigoProduto;
  oItem.DescricaoProduto := ADescricaoProduto;
  oItem.Quantidade := AQuantidade;
  oItem.ValorUnitario := AValorUnitario;
  oItem.ValorTotal := oItem.Quantidade * oItem.ValorUnitario;

  try
    APedido.Itens.Add(oItem);
    APedido.RecalcularTotal;
  finally
    Result := True;
  end;
end;

function TPedidoController.GravarPedido(APedido: TPedido): Boolean;
var
  oDAOPedido: TPedidoDAO;
  iNumeroPedido: Integer;
  oCliente: TCliente;
begin
  Result := False;

  oCliente := TCliente.Create;
  try
    CarregarCliente(APedido.CodigoCliente, oCliente);

    if (oCliente.Codigo = 0) then
    begin
      ShowMessage('Cliente não encontrado');
      Exit;
    end;
  finally
    FreeAndNil(oCliente);
  end;

  if APedido.Itens.Count = 0 then
  begin
    ShowMessage('Inclua ao menos um item.');
    Exit;
  end;

  oDAOPedido := TPedidoDAO.Create(FConn);
  try
    if (APedido.NumeroPedido > 0) then
    begin
      iNumeroPedido := APedido.NumeroPedido;
      oDAOPedido.AtualizarPedido(APedido);
    end
    else
      iNumeroPedido := oDAOPedido.InserirPedido(APedido);

    APedido.NumeroPedido := iNumeroPedido;

    if APedido.NumeroPedido > 0 then
      Result := True;
  finally
    oDAOPedido.Free;
  end;
end;

procedure TPedidoController.LimparPedido(APedido: TPedido);
begin
  APedido.NumeroPedido := 0;
  APedido.DataEmissao := 0;
  APedido.CodigoCliente := 0;
  APedido.ValorTotal := 0;
  APedido.Itens.Clear;
end;

procedure TPedidoController.CarregarCliente(ACodigoCliente: Integer; ACliente: TCliente);
var
  oDAOCliente: TClienteDAO;
begin
  oDAOCliente := TClienteDAO.Create(FConn);
  try
    oDAOCliente.CarregarCliente(ACodigoCliente, ACliente);
  finally
    oDAOCliente.Free;
  end;
end;

procedure TPedidoController.CarregarPedido(ANumero: Integer; APedido: TPedido);
var
  oDAOPedido: TPedidoDAO;
begin
  oDAOPedido := TPedidoDAO.Create(FConn);
  try
    oDAOPedido.CarregarPedido(ANumero, APedido);
  finally
    oDAOPedido.Free;
  end;
end;

procedure TPedidoController.CarregarProduto(ACodigoProduto: Integer; AProduto: TProduto);
var
  oDAOProduto: TProdutoDAO;
begin
  oDAOProduto := TProdutoDAO.Create(FConn);
  try
    oDAOProduto.CarregarProduto(ACodigoProduto, AProduto);
  finally
    oDAOProduto.Free;
  end;
end;

procedure TPedidoController.CancelarPedido(ANumero: Integer);
var
  DAO: TPedidoDAO;
begin
  DAO := TPedidoDAO.Create(FConn);
  try
    DAO.CancelarPedido(ANumero);
  finally
    DAO.Free;
  end;
end;

end.
