unit uClienteDAO;

interface

uses
  uCliente, FireDAC.Comp.Client;

type
  TClienteDAO = class
  private
    FConn: TFDConnection;
  public
    constructor Create(AConn: TFDConnection);
    procedure CarregarCliente(ACodigo: Integer; ACliente: TCliente);
  end;

implementation

uses System.SysUtils;

constructor TClienteDAO.Create(AConn: TFDConnection);
begin
  FConn := AConn;
end;

procedure TClienteDAO.CarregarCliente(ACodigo: Integer; ACliente: TCliente);
var
  oQuery: TFDQuery;
begin
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := FConn;
    oQuery.SQL.Text := 'SELECT Codigo, Nome, Cidade, UF FROM Clientes WHERE Codigo = :pCodigoCliente';
    oQuery.ParamByName('pCodigoCliente').AsInteger := ACodigo;
    oQuery.Open;

    ACliente.Codigo := oQuery.FieldByName('Codigo').AsInteger;
    ACliente.Nome := oQuery.FieldByName('Nome').AsString;
    ACliente.Cidade := oQuery.FieldByName('Cidade').AsString;
    ACliente.UF := oQuery.FieldByName('UF').AsString;
  finally
    oQuery.Free;
  end;
end;

end.
