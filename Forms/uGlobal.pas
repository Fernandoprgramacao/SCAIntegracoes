unit uGlobal;

interface

uses
  Windows, ADODB, SysUtils, System.DateUtils, Data.DB, Math, Variants,
  System.Classes, Vcl.Graphics, Vcl.Dialogs, Vcl.Forms, ComObj,
  uMensagem;

procedure MsgSistema(Tipo: TTipoMensagem; Texto: string);

const
  FontGrid                 = 'Tahoma';
  SizeFontGrid             = 10;
  cor_padrao               = clBlack;
  CorGridSelecionado       = $00FFE7CE;
  CorGridZebrada           = $00F9F9F9;
  CorGridZebradaFonte      = cor_padrao;
  CorGridZebradaNao        = clWhite;
  CorGridZebradaFonteNao   = cor_padrao;
  CorGridSelecionadoFonte  = clNavy;
  GridBold                 = [fsBold];

function ExecutaCommando(SQLText: string): String;
procedure ExibeForm(Base: TComponentClass; Form: TForm);
procedure ExportarQueryParaExcel(AQuery: TDataSet; const NomeAba: string);
function ExecutaSQLConta(SQL:String) : Integer;

implementation

uses
  uBD;

procedure MsgSistema(Tipo: TTipoMensagem; Texto: string);
var
  Frm: TFrmMensagem;
begin
  Frm := TFrmMensagem.Create(nil);
  try
    Frm.ExibirMensagem(Tipo, Texto);
  finally
    Frm.Free;
  end;
end;

function ExecutaCommando(SQLText: string): String;
var
  comando: TADOCommand;
begin
  Result := 'Erro ao executar comando!';
  comando := TADOCommand.Create(nil);
  try
    try
      comando.Connection := bd.Conexao;
      comando.CommandText := SQLText;
      comando.ParamCheck := False;
      comando.Prepared := False;
      comando.Execute;
      Result := 'OK';
    except
      on E: Exception do
      begin
        ShowMessage('Erro! ' + E.Message);
        Abort;
      end;
    end;
  finally
    FreeAndNil(comando);
  end;
end;

procedure ExibeForm(Base: TComponentClass; Form: TForm);
begin
  Application.CreateForm(Base, Form);
  Form.ShowModal;
  Form.Free;
  Form := nil;
end;

procedure ExportarQueryParaExcel(AQuery: TDataSet; const NomeAba: string);
var
  Excel, Sheet: Variant;
  Col, Row: Integer;
begin
  Excel := CreateOleObject('Excel.Application');
  Excel.Visible := False;
  Excel.WorkBooks.Add;

  Sheet := Excel.WorkBooks[1].Sheets[1];
  Sheet.Name := NomeAba;

  for Col := 0 to AQuery.FieldCount - 1 do
    Sheet.Cells[1, Col + 1] := AQuery.Fields[Col].DisplayName;

  Row := 2;

  AQuery.DisableControls;
  try
    AQuery.First;
    while not AQuery.Eof do
    begin
      for Col := 0 to AQuery.FieldCount - 1 do
        Sheet.Cells[Row, Col + 1] := AQuery.Fields[Col].AsString;

      Inc(Row);
      AQuery.Next;
    end;
  finally
    AQuery.EnableControls;
  end;

  Sheet.Columns.AutoFit;
  Excel.Visible := True;
end;

function ExecutaSQLConta(SQL:String) : Integer;
var
  consulta: TADOQuery;
begin
  Result := 0;
  consulta := TADOQuery.Create(nil);
  try
    try
      consulta.ParamCheck := False;
      consulta.Connection := bd.Conexao;
      consulta.SQL.Add(SQL);
      consulta.Open;

      if not consulta.IsEmpty then
        if not VarIsNull(consulta.FieldByName('Total').Value) then
          Result := consulta.FieldByName('Total').AsInteger;
    except
      Result := 0;
    end;
  finally
    consulta.Close;
    FreeAndNil(consulta);
  end;
end;

end.

