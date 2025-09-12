program WKTechPedido;

uses
  Vcl.Forms,
  System.SysUtils,
  fmPedido in 'view\fmPedido.pas' {frmPedido},
  uPedido in 'model\uPedido.pas',
  uCliente in 'model\uCliente.pas',
  uProduto in 'model\uProduto.pas',
  uClienteDAO in 'dao\uClienteDAO.pas',
  uDBConnection in 'dao\uDBConnection.pas',
  uPedidoDAO in 'dao\uPedidoDAO.pas',
  uProdutoDAO in 'dao\uProdutoDAO.pas',
  uPedidoController in 'controller\uPedidoController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
