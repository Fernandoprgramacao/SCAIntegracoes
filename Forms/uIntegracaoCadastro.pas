unit uIntegracaoCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Tabs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Data.Win.ADODB,
  uModelo, uGlobal;

type
  TFrmIntegracaoCadastro = class(TModelo)
    Pagina: TPageControl;
    TabSheet1: TTabSheet;
    lbCodigo: TLabel;
    edCodigo: TEdit;
    lbNome: TLabel;
    edNome: TEdit;
    cbOperadora: TComboBox;
    lbOperadora: TLabel;
    lbDocumento: TLabel;
    cbTipoCadastro: TComboBox;
    edDocumento: TEdit;
    lbTipoCadastro: TLabel;
    lbSituacao: TLabel;
    cbSituacao: TComboBox;
    lbTarefa: TLabel;
    edCodTarefa: TEdit;
    btAbrirTarefa: TButton;
    lbObservacao: TLabel;
    btCadastrarC: TButton;
    btAlterarC: TButton;
    btCancelarC: TButton;
    Observacao: TMemo;
    cmdComando: TADOCommand;
    qrConsulta: TADOQuery;
    lbtecnico: TLabel;
    cbColaborador: TComboBox;
    edCodCliente: TEdit;
    Label1: TLabel;
    btAbrirCliente: TButton;
    cbResponsavel: TComboBox;
    lbResponsavel: TLabel;
    cbEnviadoVindi: TComboBox;
    lbEnviado: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure btCadastrarCClick(Sender: TObject);
    procedure btAlterarCClick(Sender: TObject);
    procedure cbTipoCadastroChange(Sender: TObject);
    procedure btAbrirTarefaClick(Sender: TObject);
    procedure edCodTarefaKeyPress(Sender: TObject; var Key: Char);
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
  FrmIntegracaoCadastro: TFrmIntegracaoCadastro;
  G_AcaoIntegracao: string;
  G_SolicitacaoID: Integer;
  G_PrecisaAtualizarSolicitacao: Boolean;
  AtualizandoCampos: Boolean = False;

implementation

uses
  uBD, System.MaskUtils, ShellApi, SysUtils, uMensagem;

{$R *.dfm}

// ---------------------------------------------------------------------------
// MÁSCARAS
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.AplicarMascaraCPF(Edit: TEdit);
var
  s: string;
begin
  s := Edit.Text;
  s := StringReplace(s, '.', '', [rfReplaceAll]);
  s := StringReplace(s, '-', '', [rfReplaceAll]);
  s := StringReplace(s, '/', '', [rfReplaceAll]);
  Edit.Text := FormatMaskText('000\.000\.000\-00;0;_', s);
end;

procedure TFrmIntegracaoCadastro.AplicarMascaraCNPJ(Edit: TEdit);
var
  s: string;
begin
  s := Edit.Text;
  s := StringReplace(s, '.', '', [rfReplaceAll]);
  s := StringReplace(s, '-', '', [rfReplaceAll]);
  s := StringReplace(s, '/', '', [rfReplaceAll]);
  Edit.Text := FormatMaskText('00\.000\.000\/0000\-00;0;_', s);
end;

procedure TFrmIntegracaoCadastro.AtualizarLabelDocumento;
begin
  if cbTipoCadastro.ItemIndex = 0 then
    lbDocumento.Caption := 'CPF:'
  else
    lbDocumento.Caption := 'CNPJ:';
end;

// ---------------------------------------------------------------------------
// CARREGAR COMBOS
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.CarregarCombos;
var
  qr: TADOQuery;
  procedure CarregarCombo(Combo: TComboBox; const SQL: string; CampoID, CampoNome: string);
  var
    id, nome: string;
  begin
    Combo.Items.Clear;
    qr.SQL.Text := SQL;
    qr.Open;
    try
      while not qr.Eof do
      begin
        id := qr.FieldByName(CampoID).AsString;
        nome := qr.FieldByName(CampoNome).AsString;
        Combo.Items.AddObject(nome, TObject(StrToIntDef(id, 0)));
        qr.Next;
      end;
    finally
      qr.Close;
    end;
  end;
begin
  qr := TADOQuery.Create(nil);
  try
    qr.Connection := BD.Conexao;

    CarregarCombo(cbOperadora,
      'SELECT operadoraID, operadoraNome FROM Operadoras ORDER BY operadoraID',
      'operadoraID', 'operadoraNome');

    CarregarCombo(cbSituacao,
      'SELECT situacaoID, situacaoNome FROM Situacoes ORDER BY situacaoID',
      'situacaoID', 'situacaoNome');

    CarregarCombo(cbColaborador,
      'SELECT colabID, colabNome FROM Colaboradores WHERE colabAtivo = True AND colabExcluido = False ORDER BY colabNome',
      'colabID', 'colabNome');

    CarregarCombo(cbResponsavel,
      'SELECT colabID, colabNome FROM Colaboradores WHERE colabResp = True AND colabAtivo = True AND colabExcluido = False ORDER BY colabNome',
      'colabID', 'colabNome');

  finally
    qr.Free;
  end;

  // Define índices padrão
  if cbOperadora.Items.Count > 0 then cbOperadora.ItemIndex := 0;
  if cbSituacao.Items.Count > 0 then cbSituacao.ItemIndex := 0;
  if cbColaborador.Items.Count > 0 then cbColaborador.ItemIndex := 0;
  if cbResponsavel.Items.Count > 0 then cbResponsavel.ItemIndex := 0;
  if cbEnviadoVindi.Items.Count > 0 then cbEnviadoVindi.ItemIndex := 0;
end;

// ---------------------------------------------------------------------------
// COMPLETAR CADASTRO
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.CompletaCadastro(codigo: Integer);
var
  qrTemp: TADOQuery;
  solicitacaoID, operadoraID, situacaoID, colabID, respID: Integer;
  nomeFantasia, documento, obs, tarefa, codCliente: string;
  tipo: Integer;
  enviado: Boolean;
begin
  qrTemp := TADOQuery.Create(nil);
  try
    qrTemp.Connection := BD.Conexao;
    qrTemp.SQL.Text :=
      'SELECT ' +
      '  solicitacaoID, ' +
      '  solicitacaoNomeFantasia, ' +
      '  solicitacaoCPF, ' +
      '  solicitacaoCNPJ, ' +
      '  solicitacaoTipo, ' +
      '  operadoraID, ' +
      '  situacaoID, ' +
      '  solicitacaoEnviado, ' +
      '  solicitacaoObs, ' +
      '  solicitacaoTarefa, ' +
      '  solicitacaoCodigo, ' +
      '  colabID, ' +
      '  colabRespID ' +
      'FROM SolicitacoesVindi ' +
      'WHERE solicitacaoID = :solicitacaoID';

    qrTemp.Parameters.ParamByName('solicitacaoID').Value := codigo;
    qrTemp.Open;

    if qrTemp.IsEmpty then Exit;

    // BUSCA TODOS OS DADOS ANTES DE FECHAR A QUERY
    solicitacaoID := qrTemp.FieldByName('solicitacaoID').AsInteger;
    nomeFantasia := qrTemp.FieldByName('solicitacaoNomeFantasia').AsString;
    tipo := qrTemp.FieldByName('solicitacaoTipo').AsInteger;
    operadoraID := qrTemp.FieldByName('operadoraID').AsInteger;
    situacaoID := qrTemp.FieldByName('situacaoID').AsInteger;
    enviado := qrTemp.FieldByName('solicitacaoEnviado').AsBoolean;
    obs := qrTemp.FieldByName('solicitacaoObs').AsString;
    tarefa := qrTemp.FieldByName('solicitacaoTarefa').AsString;
    codCliente := qrTemp.FieldByName('solicitacaoCodigo').AsString;
    colabID := qrTemp.FieldByName('colabID').AsInteger;
    respID := qrTemp.FieldByName('colabRespID').AsInteger;

    // Documento (CPF ou CNPJ)
    if tipo = 1 then
      documento := qrTemp.FieldByName('solicitacaoCNPJ').AsString
    else
      documento := qrTemp.FieldByName('solicitacaoCPF').AsString;

    qrTemp.Close;

    // PREENCHE O FORMULÁRIO
    edCodigo.Text := IntToStr(solicitacaoID);
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

    // Operadora
    cbOperadora.ItemIndex := cbOperadora.Items.IndexOfObject(TObject(operadoraID));
    if cbOperadora.ItemIndex < 0 then cbOperadora.ItemIndex := 0;

    // Situacao
    cbSituacao.ItemIndex := cbSituacao.Items.IndexOfObject(TObject(situacaoID));
    if cbSituacao.ItemIndex < 0 then cbSituacao.ItemIndex := 0;

    // Enviado
    if enviado then
      cbEnviadoVindi.ItemIndex := 1
    else
      cbEnviadoVindi.ItemIndex := 0;

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
// FORM CREATE
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.FormCreate(Sender: TObject);
begin
  inherited;

  G_PrecisaAtualizarSolicitacao := False;

  cmdComando.Connection := BD.Conexao;

  CarregarCombos;

  // Adiciona itens no cbEnviadoVindi se estiver vazio
  if cbEnviadoVindi.Items.Count = 0 then
  begin
    cbEnviadoVindi.Items.Add('NÃO');
    cbEnviadoVindi.Items.Add('SIM');
    cbEnviadoVindi.ItemIndex := 0;
  end;

  // Define seleção padrão
  if cbTipoCadastro.Items.Count > 1 then
    cbTipoCadastro.ItemIndex := 1
  else if cbTipoCadastro.Items.Count > 0 then
    cbTipoCadastro.ItemIndex := 0;

  cbTipoCadastroChange(nil);
  AtualizarLabelDocumento;

  if G_AcaoIntegracao = 'cadastrar' then
  begin
    SetTitulo('Cadastrando solicitação : :');
    btCadastrarC.Visible := True;
    btAlterarC.Visible := False;
  end
  else if G_AcaoIntegracao = 'alterar' then
  begin
    SetTitulo('Alterando solicitação : :');
    btCadastrarC.Visible := False;
    btAlterarC.Visible := True;
    cbResponsavel.Enabled := False;
    CompletaCadastro(G_SolicitacaoID);
  end;
end;

// ---------------------------------------------------------------------------
// KEY PRESS / EXIT
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.edCodTarefaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if GetKeyState(VK_CONTROL) < 0 then Exit;
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TFrmIntegracaoCadastro.edNomeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  Key := UpCase(Key);
end;

procedure TFrmIntegracaoCadastro.edDocumentoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if GetKeyState(VK_CONTROL) < 0 then Exit;
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TFrmIntegracaoCadastro.edDocumentoExit(Sender: TObject);
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

procedure TFrmIntegracaoCadastro.cbTipoCadastroChange(Sender: TObject);
begin
  AtualizarLabelDocumento;

  // Só limpa se NÃO estiver atualizando campos
  if not AtualizandoCampos then
    edDocumento.Clear;
end;

// ---------------------------------------------------------------------------
// ABRIR LINKS
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.btAbrirClienteClick(Sender: TObject);
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

procedure TFrmIntegracaoCadastro.btAbrirTarefaClick(Sender: TObject);
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

// ---------------------------------------------------------------------------
// FUNÇÕES AUXILIARES
// ---------------------------------------------------------------------------

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
  Result := Resto = StrToInt(Num[11]);
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

  Peso1[1] := 5;  Peso1[2] := 4;  Peso1[3] := 3;  Peso1[4] := 2;
  Peso1[5] := 9;  Peso1[6] := 8;  Peso1[7] := 7;  Peso1[8] := 6;
  Peso1[9] := 5;  Peso1[10] := 4; Peso1[11] := 3; Peso1[12] := 2;

  Peso2[1] := 6;  Peso2[2] := 5;  Peso2[3] := 4;  Peso2[4] := 3;
  Peso2[5] := 2;  Peso2[6] := 9;  Peso2[7] := 8;  Peso2[8] := 7;
  Peso2[9] := 6;  Peso2[10] := 5; Peso2[11] := 4; Peso2[12] := 3;
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
  Result := Resto = StrToInt(Num[14]);
end;

// ---------------------------------------------------------------------------
// VALIDAR CAMPOS
// ---------------------------------------------------------------------------

function TFrmIntegracaoCadastro.ValidarCampos: Boolean;
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

// ---------------------------------------------------------------------------
// CADASTRAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.btCadastrarCClick(Sender: TObject);
var
  sql: string;
  FrmMsg: TFrmMensagem;
begin
  if not ValidarCampos then Exit;

  sql :=
    'INSERT INTO SolicitacoesVindi ( ' +
    '  solicitacaoNomeFantasia, solicitacaoCPF, solicitacaoCNPJ, solicitacaoTipo, ' +
    '  operadoraID, situacaoID, solicitacaoEnviado, solicitacaoObs, ' +
    '  solicitacaoTarefa, solicitacaoCodigo, colabID, colabRespID ' +
    ') VALUES ( ' +
    '  :solicitacaoNomeFantasia, :solicitacaoCPF, :solicitacaoCNPJ, :solicitacaoTipo, ' +
    '  :operadoraID, :situacaoID, :solicitacaoEnviado, :solicitacaoObs, ' +
    '  :solicitacaoTarefa, :solicitacaoCodigo, :colabID, :colabRespID ' +
    ')';

  cmdComando.CommandText := sql;

  try
    cmdComando.Parameters.ParamByName('solicitacaoNomeFantasia').Value := Trim(edNome.Text);

    if cbTipoCadastro.ItemIndex = 0 then
    begin
      cmdComando.Parameters.ParamByName('solicitacaoCPF').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('solicitacaoCNPJ').Value := Null;
      cmdComando.Parameters.ParamByName('solicitacaoTipo').Value := 0;
    end
    else
    begin
      cmdComando.Parameters.ParamByName('solicitacaoCPF').Value := Null;
      cmdComando.Parameters.ParamByName('solicitacaoCNPJ').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('solicitacaoTipo').Value := 1;
    end;

    cmdComando.Parameters.ParamByName('operadoraID').Value := Integer(cbOperadora.Items.Objects[cbOperadora.ItemIndex]);
    cmdComando.Parameters.ParamByName('situacaoID').Value := Integer(cbSituacao.Items.Objects[cbSituacao.ItemIndex]);
    cmdComando.Parameters.ParamByName('solicitacaoEnviado').Value := (cbEnviadoVindi.ItemIndex = 1);
    cmdComando.Parameters.ParamByName('solicitacaoObs').Value := Observacao.Text;
    cmdComando.Parameters.ParamByName('solicitacaoTarefa').Value := edCodTarefa.Text;
    cmdComando.Parameters.ParamByName('solicitacaoCodigo').Value := edCodCliente.Text;
    cmdComando.Parameters.ParamByName('colabID').Value := Integer(cbColaborador.Items.Objects[cbColaborador.ItemIndex]);
    cmdComando.Parameters.ParamByName('colabRespID').Value := Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);

    cmdComando.Execute;

    G_PrecisaAtualizarSolicitacao := True;

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
      raise;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// ALTERAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.btAlterarCClick(Sender: TObject);
var
  sql: string;
  FrmMsg: TFrmMensagem;
begin
  if not ValidarCampos then Exit;

  sql := 'UPDATE SolicitacoesVindi SET ' +
         'solicitacaoNomeFantasia = :solicitacaoNomeFantasia, ' +
         'solicitacaoCPF = :solicitacaoCPF, ' +
         'solicitacaoCNPJ = :solicitacaoCNPJ, ' +
         'solicitacaoTipo = :solicitacaoTipo, ' +
         'operadoraID = :operadoraID, ' +
         'situacaoID = :situacaoID, ' +
         'solicitacaoEnviado = :solicitacaoEnviado, ' +
         'solicitacaoObs = :solicitacaoObs, ' +
         'solicitacaoTarefa = :solicitacaoTarefa, ' +
         'solicitacaoCodigo = :solicitacaoCodigo, ' +
         'colabID = :colabID, ' +
         'colabRespID = :colabRespID ' +
         'WHERE solicitacaoID = :solicitacaoID';

  cmdComando.CommandText := sql;

  try
    cmdComando.Parameters.ParamByName('solicitacaoNomeFantasia').Value := Trim(edNome.Text);

    if cbTipoCadastro.ItemIndex = 0 then
    begin
      cmdComando.Parameters.ParamByName('solicitacaoCPF').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('solicitacaoCNPJ').Value := Null;
      cmdComando.Parameters.ParamByName('solicitacaoTipo').Value := 0;
    end
    else
    begin
      cmdComando.Parameters.ParamByName('solicitacaoCPF').Value := Null;
      cmdComando.Parameters.ParamByName('solicitacaoCNPJ').Value := edDocumento.Text;
      cmdComando.Parameters.ParamByName('solicitacaoTipo').Value := 1;
    end;

    cmdComando.Parameters.ParamByName('operadoraID').Value := Integer(cbOperadora.Items.Objects[cbOperadora.ItemIndex]);
    cmdComando.Parameters.ParamByName('situacaoID').Value := Integer(cbSituacao.Items.Objects[cbSituacao.ItemIndex]);
    cmdComando.Parameters.ParamByName('solicitacaoEnviado').Value := (cbEnviadoVindi.ItemIndex = 1);
    cmdComando.Parameters.ParamByName('solicitacaoObs').Value := Observacao.Text;
    cmdComando.Parameters.ParamByName('solicitacaoTarefa').Value := edCodTarefa.Text;
    cmdComando.Parameters.ParamByName('solicitacaoCodigo').Value := edCodCliente.Text;
    cmdComando.Parameters.ParamByName('colabID').Value := Integer(cbColaborador.Items.Objects[cbColaborador.ItemIndex]);
    cmdComando.Parameters.ParamByName('colabRespID').Value := Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);
    cmdComando.Parameters.ParamByName('solicitacaoID').Value := G_SolicitacaoID;

    cmdComando.Execute;

    G_PrecisaAtualizarSolicitacao := True;

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
      raise;
    end;
  end;
end;

// ---------------------------------------------------------------------------
// CANCELAR
// ---------------------------------------------------------------------------

procedure TFrmIntegracaoCadastro.btCancelarCClick(Sender: TObject);
begin
  if G_AcaoIntegracao = 'alterar' then
    CompletaCadastro(G_SolicitacaoID)
  else
    Close;
end;

end.
