unit uIntegracaoNotasCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Tabs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Data.Win.ADODB,
  uModelo, uGlobal;

type
  TFrmIntegracaoNotasCadastro = class(TModelo)
    Pagina: TPageControl;
    TabSheet1: TTabSheet;
    lbCodigo: TLabel;
    edCodigo: TEdit;
    lbNome: TLabel;
    edNome: TEdit;
    lbDocumento: TLabel;           // <--- NOME ALTERADO (era lbDocumentoCPF)
    cbTipoCadastro: TComboBox;
    edDocumento: TEdit;            // <--- NOME ALTERADO (era edCPF e edCNPJ)
    lbTipoCadastro: TLabel;
    lbSituacao: TLabel;
    cbSituacao: TComboBox;
    lbTarefa: TLabel;
    edCodTarefa: TEdit;
    btAbrirTarefa: TButton;
    lbObservacao: TLabel;
    btAlterarC: TButton;
    btCancelarC: TButton;
    Observacao: TMemo;
    cmdComando: TADOCommand;
    qrConsulta: TADOQuery;
    lbtecnico: TLabel;
    cbColaborador: TComboBox;
    edCodCliente: TEdit;
    lbCodigoCliente: TLabel;
    btAbrirCliente: TButton;
    cbResponsavel: TComboBox;
    lbResponsavel: TLabel;
    cbEmitida: TComboBox;
    btCadastrarC: TButton;
    edDtAtivacao: TEdit;
    edDtCadastro: TEdit;
    lbDtCadastro: TLabel;
    lbDtAtivacao: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure btCadastrarCClick(Sender: TObject);
    procedure btAlterarCClick(Sender: TObject);
    procedure cbTipoCadastroChange(Sender: TObject);
    procedure btAbrirTarefaClick(Sender: TObject);
    procedure edCodTarefaKeyPress(Sender: TObject; var Key: Char);
    procedure edCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edNomeKeyPress(Sender: TObject; var Key: Char);
    procedure edDocumentoKeyPress(Sender: TObject; var Key: Char);
    procedure edDocumentoExit(Sender: TObject);
    procedure btCancelarCClick(Sender: TObject);
    procedure btAbrirClienteClick(Sender: TObject);

  private
    function ValidarCampos: Boolean;
    procedure CompletaCadastro(codigo: Integer);
    procedure AplicarMascaraCPF(Edit: TEdit);
    procedure AplicarMascaraCNPJ(Edit: TEdit);
    procedure CarregarCombos;
    procedure AtualizarLabelDocumento;

  public

  end;

var
  FrmIntegracaoNotasCadastro: TFrmIntegracaoNotasCadastro;
  G_AcaoNotas: string;
  G_NotaID: Integer;
  G_PrecisaAtualizarNotas: Boolean;
  AtualizandoCampos: Boolean = False;

implementation

uses
  uBD, System.MaskUtils, ShellApi, SysUtils, uMensagem;

{$R *.dfm}

// ---------------------------------------------------------------------------
// MÁSCARAS
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.AplicarMascaraCPF(Edit: TEdit);
var
  s: string;
begin
  s := Edit.Text;
  s := StringReplace(s, '.', '', [rfReplaceAll]);
  s := StringReplace(s, '-', '', [rfReplaceAll]);
  s := StringReplace(s, '/', '', [rfReplaceAll]);
  Edit.Text := FormatMaskText('000\.000\.000\-00;0;_', s);
end;

procedure TFrmIntegracaoNotasCadastro.AplicarMascaraCNPJ(Edit: TEdit);
var
  s: string;
begin
  s := Edit.Text;
  s := StringReplace(s, '.', '', [rfReplaceAll]);
  s := StringReplace(s, '-', '', [rfReplaceAll]);
  s := StringReplace(s, '/', '', [rfReplaceAll]);
  Edit.Text := FormatMaskText('00\.000\.000\/0000\-00;0;_', s);
end;

procedure TFrmIntegracaoNotasCadastro.AtualizarLabelDocumento;
begin
  if cbTipoCadastro.ItemIndex = 0 then
    lbDocumento.Caption := 'CPF:'
  else
    lbDocumento.Caption := 'CNPJ:';
end;

// ---------------------------------------------------------------------------
// FORM CREATE
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.FormCreate(Sender: TObject);
begin
  inherited;

  G_PrecisaAtualizarNotas := False;

  cmdComando.Connection := BD.Conexao;

  CarregarCombos;

  if cbSituacao.Items.Count > 0 then
    cbSituacao.ItemIndex := 0;

  if cbColaborador.Items.Count > 0 then
    cbColaborador.ItemIndex := 0;

  if cbEmitida.Items.Count > 0 then
    cbEmitida.ItemIndex := 0;

  // PADRÃO JURÍDICA
  if cbTipoCadastro.Items.Count > 1 then
    cbTipoCadastro.ItemIndex := 1
  else if cbTipoCadastro.Items.Count > 0 then
    cbTipoCadastro.ItemIndex := 0;

  cbTipoCadastroChange(nil);
  AtualizarLabelDocumento;

  if G_AcaoNotas = 'cadastrar' then
  begin
    SetTitulo('Cadastrando solicitação de nota fiscal : :');
    btCadastrarC.Visible := True;
    btAlterarC.Visible   := False;
    edDtCadastro.Enabled := False;
    edDtAtivacao.Enabled := False;
  end
  else if G_AcaoNotas = 'alterar' then
  begin
    SetTitulo('Alterando solicitação de nota fiscal : :');
    btCadastrarC.Visible    := False;
    btAlterarC.Visible      := True;
    cbResponsavel.Enabled   := False;
    CompletaCadastro(G_NotaID);
  end;
end;

// ---------------------------------------------------------------------------
// KEY PRESS / EXIT
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.edCodTarefaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if GetKeyState(VK_CONTROL) < 0 then Exit;

  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TFrmIntegracaoNotasCadastro.edCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if GetKeyState(VK_CONTROL) < 0 then Exit;

  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TFrmIntegracaoNotasCadastro.edNomeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  Key := UpCase(Key);
end;

procedure TFrmIntegracaoNotasCadastro.edDocumentoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if GetKeyState(VK_CONTROL) < 0 then Exit;

  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TFrmIntegracaoNotasCadastro.edDocumentoExit(Sender: TObject);
begin
  inherited;

  if Trim(edDocumento.Text) = '' then Exit;

  if cbTipoCadastro.ItemIndex = 0 then
    AplicarMascaraCPF(edDocumento)
  else
    AplicarMascaraCNPJ(edDocumento);
end;

// ---------------------------------------------------------------------------
// COMBO TIPO CADASTRO
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.cbTipoCadastroChange(Sender: TObject);
begin
  AtualizarLabelDocumento;

  if not AtualizandoCampos then
    edDocumento.Clear;
end;

// ---------------------------------------------------------------------------
// ABRIR LINKS
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.btAbrirClienteClick(Sender: TObject);
var
  URL: string;
  FrmMsg: TFrmMensagem;
begin
  if Trim(edCodCliente.Text) = '' then
  begin
    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmAtencao, 'Código cliente não informado!');
    finally
      FrmMsg.Free;
    end;
    edCodCliente.SetFocus;
    Exit;
  end;

  URL := 'https://adm.sistemasca.com/cliente?=c' + Trim(edCodCliente.Text);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmIntegracaoNotasCadastro.btAbrirTarefaClick(Sender: TObject);
var
  URL: string;
  FrmMsg: TFrmMensagem;
begin
  if Trim(edCodTarefa.Text) = '' then
  begin
    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmAtencao, 'Código tarefa não informado!');
    finally
      FrmMsg.Free;
    end;
    edCodTarefa.SetFocus;
    Exit;
  end;

  URL := 'https://adm.sistemasca.com/administrativo/tarefa?=c' + Trim(edCodTarefa.Text);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

// -------------------------------------
// FUNÇÕES AUXILIARES
// -------------------------------------

function SomenteNumeros(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if CharInSet(S[I], ['0'..'9']) then
      Result := Result + S[I];
end;

function ValidarCPF(const CPF: string): Boolean;
var
  Num: string;
  I, Soma, Resto: Integer;
begin
  Result := False;
  Num := SomenteNumeros(CPF);

  if Length(Num) <> 11 then Exit;
  if Num = StringOfChar(Num[1], 11) then Exit;

  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + StrToInt(Num[I]) * (11 - I);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then Resto := 0;
  if Resto <> StrToInt(Num[10]) then Exit;

  Soma := 0;
  for I := 1 to 10 do
    Soma := Soma + StrToInt(Num[I]) * (12 - I);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then Resto := 0;
  if Resto <> StrToInt(Num[11]) then Exit;

  Result := True;
end;

function ValidarCNPJ(const CNPJ: string): Boolean;
var
  Num: string;
  I, Soma, Resto: Integer;
  Peso1: array[1..12] of Integer;
  Peso2: array[1..13] of Integer;
begin
  Result := False;
  Num := SomenteNumeros(CNPJ);

  if Length(Num) <> 14 then Exit;

  Peso1[1]  := 5;  Peso1[2]  := 4;  Peso1[3]  := 3;  Peso1[4]  := 2;
  Peso1[5]  := 9;  Peso1[6]  := 8;  Peso1[7]  := 7;  Peso1[8]  := 6;
  Peso1[9]  := 5;  Peso1[10] := 4;  Peso1[11] := 3;  Peso1[12] := 2;

  Peso2[1]  := 6;  Peso2[2]  := 5;  Peso2[3]  := 4;  Peso2[4]  := 3;
  Peso2[5]  := 2;  Peso2[6]  := 9;  Peso2[7]  := 8;  Peso2[8]  := 7;
  Peso2[9]  := 6;  Peso2[10] := 5;  Peso2[11] := 4;  Peso2[12] := 3;
  Peso2[13] := 2;

  Soma := 0;
  for I := 1 to 12 do
    Soma := Soma + StrToInt(Num[I]) * Peso1[I];

  Resto := Soma mod 11;
  if Resto < 2 then Resto := 0 else Resto := 11 - Resto;
  if Resto <> StrToInt(Num[13]) then Exit;

  Soma := 0;
  for I := 1 to 13 do
    Soma := Soma + StrToInt(Num[I]) * Peso2[I];

  Resto := Soma mod 11;
  if Resto < 2 then Resto := 0 else Resto := 11 - Resto;
  if Resto <> StrToInt(Num[14]) then Exit;

  Result := True;
end;

// ---------------------------------------------------------------------------
// VALIDAR CAMPOS
// ---------------------------------------------------------------------------

function TFrmIntegracaoNotasCadastro.ValidarCampos: Boolean;
var
  FrmMsg: TFrmMensagem;
begin
  Result := False;

  if Trim(edNome.Text) = '' then
  begin
    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmAtencao, 'Preencha o Nome Fantasia!');
    finally
      FrmMsg.Free;
    end;
    edNome.SetFocus;
    Exit;
  end;

  if Trim(edDocumento.Text) = '' then
  begin
    FrmMsg := TFrmMensagem.Create(Self);
    try
      if cbTipoCadastro.ItemIndex = 0 then
        FrmMsg.ExibirMensagem(tmAtencao, 'Preencha o CPF!')
      else
        FrmMsg.ExibirMensagem(tmAtencao, 'Preencha o CNPJ!');
    finally
      FrmMsg.Free;
    end;
    edDocumento.SetFocus;
    Exit;
  end;

  if cbTipoCadastro.ItemIndex = 0 then
  begin
    if not ValidarCPF(edDocumento.Text) then
    begin
      FrmMsg := TFrmMensagem.Create(Self);
      try
        FrmMsg.ExibirMensagem(tmErro, 'CPF inválido!');
      finally
        FrmMsg.Free;
      end;
      edDocumento.SetFocus;
      Exit;
    end;
  end
  else
  begin
    if not ValidarCNPJ(edDocumento.Text) then
    begin
      FrmMsg := TFrmMensagem.Create(Self);
      try
        FrmMsg.ExibirMensagem(tmErro, 'CNPJ inválido!');
      finally
        FrmMsg.Free;
      end;
      edDocumento.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

// -------------------------------------
// CARREGAR COMBOS
// -------------------------------------

procedure TFrmIntegracaoNotasCadastro.CarregarCombos;
var
  qr: TADOQuery;
begin
  qr := TADOQuery.Create(nil);
  try
    qr.Connection := BD.Conexao;

    // SITUAÇÕES
    cbSituacao.Items.Clear;
    qr.SQL.Text := 'SELECT situacaoNotaID, situacaoNotaNome FROM SituacoesNotas ORDER BY situacaoNotaID';
    qr.Open;
    try
      while not qr.Eof do
      begin
        cbSituacao.Items.AddObject(
          qr.FieldByName('situacaoNotaNome').AsString,
          TObject(qr.FieldByName('situacaoNotaID').AsInteger));
        qr.Next;
      end;
    finally
      qr.Close;
    end;

    if cbSituacao.Items.Count > 0 then
      cbSituacao.ItemIndex := 0;

    // COLABORADORES
    cbColaborador.Items.Clear;
    qr.SQL.Text :=
      'SELECT colabID, colabNome ' +
      'FROM Colaboradores ' +
      'WHERE colabAtivo = True AND colabExcluido = False ' +
      'ORDER BY colabNome';
    qr.Open;
    try
      while not qr.Eof do
      begin
        cbColaborador.Items.AddObject(
          qr.FieldByName('colabNome').AsString,
          TObject(qr.FieldByName('colabID').AsInteger));
        qr.Next;
      end;
    finally
      qr.Close;
    end;

    if cbColaborador.Items.Count > 0 then
      cbColaborador.ItemIndex := 0;

    // RESPONSÁVEIS
    cbResponsavel.Items.Clear;
    qr.SQL.Text :=
      'SELECT colabID, colabNome ' +
      'FROM Colaboradores ' +
      'WHERE colabResp = True ' +
      'AND colabAtivo = True ' +
      'AND colabExcluido = False ' +
      'ORDER BY colabNome';
    qr.Open;
    try
      while not qr.Eof do
      begin
        cbResponsavel.Items.AddObject(
          qr.FieldByName('colabNome').AsString,
          TObject(qr.FieldByName('colabID').AsInteger));
        qr.Next;
      end;
    finally
      qr.Close;
    end;

    if cbResponsavel.Items.Count > 0 then
      cbResponsavel.ItemIndex := 0;

  finally
    qr.Free;
  end;
end;

// ---------------------------------------------------------------------------
// COMPLETAR CADASTRO
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.CompletaCadastro(codigo: Integer);
var
  qrTemp: TADOQuery;
  notaID, situacaoID, colabID, respID: Integer;
  nomeFantasia, documento, obs, tarefa, codCliente: string;
  tipo: Integer;
  emitida: Boolean;
  dtAtivacao, dtCadastro: TDateTime;
  temDtAtivacao, temDtCadastro: Boolean;
  cpfValue, cnpjValue: string;
begin
  qrTemp := TADOQuery.Create(nil);
  try
    qrTemp.Connection := BD.Conexao;
    qrTemp.SQL.Text :=
      'SELECT ' +
      '  notaID, ' +
      '  notaNomeFantasia, ' +
      '  notaCPF, ' +
      '  notaCNPJ, ' +
      '  notaTipo, ' +
      '  situacaoNotaID, ' +
      '  notaEmitida, ' +
      '  notaObs, ' +
      '  notaTarefa, ' +
      '  notaCliente, ' +
      '  colabID, ' +
      '  colabRespID, ' +
      '  notaDtAtivacao, ' +
      '  notaDtCadastro ' +
      'FROM NotasFiscais ' +
      'WHERE notaID = :notaID';

    qrTemp.Parameters.ParamByName('notaID').Value := codigo;
    qrTemp.Open;

    if qrTemp.IsEmpty then Exit;

    // BUSCA TODOS OS DADOS ANTES DE FECHAR A QUERY
    notaID := qrTemp.FieldByName('notaID').AsInteger;
    nomeFantasia := qrTemp.FieldByName('notaNomeFantasia').AsString;
    tipo := qrTemp.FieldByName('notaTipo').AsInteger;
    situacaoID := qrTemp.FieldByName('situacaoNotaID').AsInteger;
    emitida := qrTemp.FieldByName('notaEmitida').AsBoolean;
    obs := qrTemp.FieldByName('notaObs').AsString;
    tarefa := qrTemp.FieldByName('notaTarefa').AsString;
    codCliente := qrTemp.FieldByName('notaCliente').AsString;
    colabID := qrTemp.FieldByName('colabID').AsInteger;
    respID := qrTemp.FieldByName('colabRespID').AsInteger;

    // Documento (CPF ou CNPJ)
    cpfValue := '';
    cnpjValue := '';

    if not qrTemp.FieldByName('notaCPF').IsNull then
      cpfValue := Trim(qrTemp.FieldByName('notaCPF').AsString);

    if not qrTemp.FieldByName('notaCNPJ').IsNull then
      cnpjValue := Trim(qrTemp.FieldByName('notaCNPJ').AsString);

    if tipo = 1 then
      documento := cnpjValue
    else
      documento := cpfValue;

    // Datas
    temDtAtivacao := not qrTemp.FieldByName('notaDtAtivacao').IsNull;
    if temDtAtivacao then
      dtAtivacao := qrTemp.FieldByName('notaDtAtivacao').AsDateTime;

    temDtCadastro := not qrTemp.FieldByName('notaDtCadastro').IsNull;
    if temDtCadastro then
      dtCadastro := qrTemp.FieldByName('notaDtCadastro').AsDateTime;

    qrTemp.Close;

    // PREENCHE O FORMULÁRIO
    edCodigo.Text := IntToStr(notaID);
    edNome.Text := nomeFantasia;
    Observacao.Text := obs;
    edCodTarefa.Text := tarefa;
    edCodCliente.Text := codCliente;

    // Tipo e documento
    AtualizandoCampos := True;
    try
      if tipo = 1 then
      begin
        cbTipoCadastro.ItemIndex := 1;
        edDocumento.Text := documento;
        if Trim(edDocumento.Text) <> '' then
          AplicarMascaraCNPJ(edDocumento);
      end
      else
      begin
        cbTipoCadastro.ItemIndex := 0;
        edDocumento.Text := documento;
        if Trim(edDocumento.Text) <> '' then
          AplicarMascaraCPF(edDocumento);
      end;

      AtualizarLabelDocumento;
    finally
      AtualizandoCampos := False;
    end;

    // Datas
    if temDtAtivacao then
      edDtAtivacao.Text := DateTimeToStr(dtAtivacao)
    else
      edDtAtivacao.Clear;

    if temDtCadastro then
      edDtCadastro.Text := DateTimeToStr(dtCadastro)
    else
      edDtCadastro.Clear;

    // Situacao
    cbSituacao.ItemIndex := cbSituacao.Items.IndexOfObject(TObject(situacaoID));
    if cbSituacao.ItemIndex < 0 then cbSituacao.ItemIndex := 0;

    // Emitida
    if emitida then
      cbEmitida.ItemIndex := 1
    else
      cbEmitida.ItemIndex := 0;

    // Colaborador
    cbColaborador.ItemIndex := cbColaborador.Items.IndexOfObject(TObject(colabID));
    if cbColaborador.ItemIndex < 0 then cbColaborador.ItemIndex := 0;

    // Responsavel
    cbResponsavel.ItemIndex := cbResponsavel.Items.IndexOfObject(TObject(respID));
    if cbResponsavel.ItemIndex < 0 then cbResponsavel.ItemIndex := 0;

  finally
    qrTemp.Free;
  end;
end;

// ---------------------------------------------------------------------------
// CADASTRAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.btCadastrarCClick(Sender: TObject);
var
  sql: string;
  FrmMsg: TFrmMensagem;
begin
  if not ValidarCampos then Exit;

  sql :=
    'INSERT INTO NotasFiscais ( ' +
    '  notaNomeFantasia, ' +
    '  notaCPF, ' +
    '  notaCNPJ, ' +
    '  notaTipo, ' +
    '  situacaoNotaID, ' +
    '  notaEmitida, ' +
    '  notaObs, ' +
    '  notaTarefa, ' +
    '  notaCliente, ' +
    '  colabID, ' +
    '  colabRespID ' +
    ') VALUES ( ' +
    '  :notaNomeFantasia, ' +
    '  :notaCPF, ' +
    '  :notaCNPJ, ' +
    '  :notaTipo, ' +
    '  :situacaoNotaID, ' +
    '  :notaEmitida, ' +
    '  :notaObs, ' +
    '  :notaTarefa, ' +
    '  :notaCliente, ' +
    '  :colabID, ' +
    '  :colabRespID ' +
    ')';

  cmdComando.CommandText := sql;

  try
    cmdComando.Parameters.ParamByName('notaNomeFantasia').Value := Trim(edNome.Text);

    if cbTipoCadastro.ItemIndex = 0 then
    begin
      cmdComando.Parameters.ParamByName('notaCPF').Value  := edDocumento.Text;
      cmdComando.Parameters.ParamByName('notaCNPJ').Value := Null;
      cmdComando.Parameters.ParamByName('notaTipo').Value := 0;
    end
    else
    begin
      cmdComando.Parameters.ParamByName('notaCPF').Value  := Null;
      cmdComando.Parameters.ParamByName('notaCNPJ').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('notaTipo').Value := 1;
    end;

    cmdComando.Parameters.ParamByName('situacaoNotaID').Value :=
      Integer(cbSituacao.Items.Objects[cbSituacao.ItemIndex]);

    cmdComando.Parameters.ParamByName('notaEmitida').Value :=
      cbEmitida.ItemIndex;

    cmdComando.Parameters.ParamByName('notaObs').Value    := Observacao.Text;
    cmdComando.Parameters.ParamByName('notaTarefa').Value := edCodTarefa.Text;
    cmdComando.Parameters.ParamByName('notaCliente').Value := edCodCliente.Text;

    cmdComando.Parameters.ParamByName('colabID').Value :=
      Integer(cbColaborador.Items.Objects[cbColaborador.ItemIndex]);

    cmdComando.Parameters.ParamByName('colabRespID').Value :=
      Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);

    cmdComando.Execute;

    G_PrecisaAtualizarNotas := True;

    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmSucesso, 'Solicitação cadastrada com sucesso!');
    finally
      FrmMsg.Free;
    end;

    Close;

  except
    on E: Exception do
    begin
      FrmMsg := TFrmMensagem.Create(Self);
      try
        FrmMsg.ExibirMensagem(tmErro, 'Erro: ' + E.Message);
      finally
        FrmMsg.Free;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// ALTERAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.btAlterarCClick(Sender: TObject);
var
  sql: string;
  FrmMsg: TFrmMensagem;
  SituacaoID: Integer;
  EhFinalizado: Boolean;
begin
  if not ValidarCampos then Exit;

  SituacaoID := Integer(cbSituacao.Items.Objects[cbSituacao.ItemIndex]);
  EhFinalizado := Pos('FINALIZADO', UpperCase(cbSituacao.Text)) > 0;

  sql :=
    'UPDATE NotasFiscais SET ' +
    'notaNomeFantasia = :notaNomeFantasia, ' +
    'notaCPF          = :notaCPF, ' +
    'notaCNPJ         = :notaCNPJ, ' +
    'notaTipo         = :notaTipo, ' +
    'situacaoNotaID   = :situacaoNotaID, ' +
    'notaEmitida      = :notaEmitida, ' +
    'notaObs          = :notaObs, ' +
    'notaTarefa       = :notaTarefa, ' +
    'notaCliente      = :notaCliente, ' +
    'colabID          = :colabID, ' +
    'colabRespID      = :colabRespID, ';

  if EhFinalizado then
    sql := sql + 'notaDtAtivacao = :notaDtAtivacao '
  else
    sql := sql + 'notaDtAtivacao = NULL ';

  sql := sql + 'WHERE notaID = :notaID';

  cmdComando.CommandText := sql;

  try
    cmdComando.Parameters.ParamByName('notaNomeFantasia').Value := Trim(edNome.Text);

    if cbTipoCadastro.ItemIndex = 0 then
    begin
      cmdComando.Parameters.ParamByName('notaCPF').Value  := edDocumento.Text;
      cmdComando.Parameters.ParamByName('notaCNPJ').Value := Null;
      cmdComando.Parameters.ParamByName('notaTipo').Value := 0;
    end
    else
    begin
      cmdComando.Parameters.ParamByName('notaCPF').Value  := Null;
      cmdComando.Parameters.ParamByName('notaCNPJ').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('notaTipo').Value := 1;
    end;

    cmdComando.Parameters.ParamByName('situacaoNotaID').Value := SituacaoID;
    cmdComando.Parameters.ParamByName('notaEmitida').Value := cbEmitida.ItemIndex;
    cmdComando.Parameters.ParamByName('notaObs').Value    := Observacao.Text;
    cmdComando.Parameters.ParamByName('notaTarefa').Value := edCodTarefa.Text;
    cmdComando.Parameters.ParamByName('notaCliente').Value := edCodCliente.Text;

    if cbColaborador.ItemIndex >= 0 then
      cmdComando.Parameters.ParamByName('colabID').Value :=
        Integer(cbColaborador.Items.Objects[cbColaborador.ItemIndex])
    else
      cmdComando.Parameters.ParamByName('colabID').Value := Null;

    if cbResponsavel.ItemIndex >= 0 then
      cmdComando.Parameters.ParamByName('colabRespID').Value :=
        Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex])
    else
      cmdComando.Parameters.ParamByName('colabRespID').Value := Null;

    if EhFinalizado then
      cmdComando.Parameters.ParamByName('notaDtAtivacao').Value := Now;

    cmdComando.Parameters.ParamByName('notaID').Value := G_NotaID;

    cmdComando.Execute;

    G_PrecisaAtualizarNotas := True;

    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmSucesso, 'Solicitação alterada com sucesso!');
    finally
      FrmMsg.Free;
    end;

    Close;

  except
    on E: Exception do
    begin
      FrmMsg := TFrmMensagem.Create(Self);
      try
        FrmMsg.ExibirMensagem(tmErro, 'Erro: ' + E.Message);
      finally
        FrmMsg.Free;
      end;
      cmdComando.Cancel;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// CANCELAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoNotasCadastro.btCancelarCClick(Sender: TObject);
begin
  if G_AcaoNotas = 'alterar' then
    CompletaCadastro(G_NotaID)
  else
    Close;
end;

end.
