unit uProdutoDAO;

interface

uses
  uProduto, FireDAC.Comp.Client;

type
  TProdutoDAO = class
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    procedure CarregarProduto(ACodigo: Integer; AProduto: TProduto);
  end;

implementation

uses System.SysUtils, FireDAC.VCLUI.Wait;

constructor TProdutoDAO.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

procedure TProdutoDAO.CarregarProduto(ACodigo: Integer; AProduto: TProduto);
var
  oQuery: TFDQuery;
begin
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FConn;
    oQuery.SQL.Text := 'SELECT Codigo, Descricao, PrecoVenda FROM Produtos WHERE Codigo = :pCodigoProduto';
    oQuery.ParamByName('pCodigoProduto').AsInteger := ACodigo;
    oQuery.Open;

    AProduto.Codigo := oQuery.FieldByName('Codigo').AsInteger;
    AProduto.Descricao := oQuery.FieldByName('Descricao').AsString;
    AProduto.PrecoVenda := oQuery.FieldByName('PrecoVenda').AsCurrency;
  finally
    oQuery.Free;
  end;
end;

end.
