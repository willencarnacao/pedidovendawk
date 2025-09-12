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
    function ObterProduto(ACodigo: Integer): TProduto;
  end;

implementation

uses System.SysUtils, FireDAC.VCLUI.Wait;

constructor TProdutoDAO.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

function TProdutoDAO.ObterProduto(ACodigo: Integer): TProduto;
var
  oQuery: TFDQuery;
  oProduto: TProduto;
begin
  Result := nil;
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FConn;
    oQuery.SQL.Text := 'SELECT Codigo, Descricao, PrecoVenda FROM Produtos WHERE Codigo = :pCodigoProduto';
    oQuery.ParamByName('pCodigoProduto').AsInteger := ACodigo;
    oQuery.Open;
    if not oQuery.IsEmpty then
    begin
      oProduto := TProduto.Create;
      oProduto.Codigo := oQuery.FieldByName('Codigo').AsInteger;
      oProduto.Descricao := oQuery.FieldByName('Descricao').AsString;
      oProduto.PrecoVenda := oQuery.FieldByName('PrecoVenda').AsCurrency;
      Result := oProduto;
    end;
  finally
    oQuery.Free;
  end;
end;

end.
