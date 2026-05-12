unit uIntegracao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  uModelo, uGlobal, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, DateUtils,
  Vcl.Buttons, Datasnap.DBClient;

type
  TFrmIntegracao = class(TModelo)
    pnRodape: TPanel;
    DBGrid1: TDBGrid;
    bntAlterar: TButton;
    bntExcluir: TButton;
    ADOSolicitacoesVindi: TADOCommand;
    dsSolicitacoesVindi: TDataSource;
    pnFiltro: TPanel;
    lbSituacao: TLabel;
    cbSituação: TComboBox;
    lbPesquisar: TLabel;
    edPesquisar: TEdit;
    lbOperadora: TLabel;
    cbOperadora: TComboBox;
    pnSemRegistro: TPanel;
    imgSemRegistro: TImage;
    lbSemRegistro: TLabel;
    gbResumo: TGroupBox;
    lbPendente: TLabel;
    lbEmAndamento: TLabel;
    lbFinalizado: TLabel;
    lbTotalPendente: TLabel;
    lbTotalAndamento: TLabel;
    lbTotalFinalizado: TLabel;
    lbTotalGeral: TLabel;
    lbTotal: TLabel;
    pnSeparador: TPanel;
    cbTecnico: TComboBox;
    lbTecnico: TLabel;
    pnTopoFiltro: TPanel;
    cbPeriodo: TComboBox;
    lbPeriodo: TLabel;
    dtDataInicio: TDateTimePicker;
    dtDataFim: TDateTimePicker;
    lbResponsavel: TLabel;
    cbResponsavel: TComboBox;
    cbEnviadoVindi: TComboBox;
    lbEnviado: TLabel;
    lbJaEnviado: TLabel;
    Panel1: TPanel;
    lbEnviadas: TLabel;
    lbTotalEnviado: TLabel;
    lbNaoEnviadas: TLabel;
    lbFaltaEnviar: TLabel;
    bntCadastrar: TButton;
    cdsSolicitacoes: TClientDataSet;

    procedure FormCreate(Sender: TObject);
    procedure bntCadastrarClick(Sender: TObject);
    procedure bntAlterarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure bntExcluirClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cbSituaçãoChange(Sender: TObject);
    procedure edPesquisarChange(Sender: TObject);
    procedure cbOperadoraChange(Sender: TObject);
    procedure cbTecnicoChange(Sender: TObject);
    procedure cbPeriodoChange(Sender: TObject);
    procedure dtDataInicioChange(Sender: TObject);
    procedure dtDataFimChange(Sender: TObject);
    procedure cbResponsavelChange(Sender: TObject);
    procedure cbEnviadoVindiChange(Sender: TObject);

  private
    procedure RealizaConsulta;
    procedure CarregarResumo;
    procedure CarregarCombos;
    function MontarFiltro: string;
    function MontarFiltroResumo: string;
    procedure ExecutarConsultaLocalizar(const SQL: string);

  public
  end;

var
  FrmIntegracao: TFrmIntegracao;

implementation

uses
  uBD, uIntegracaoCadastro, uMensagem;

{$R *.dfm}

procedure TFrmIntegracao.FormCreate(Sender: TObject);
begin
  inherited;
  SetTitulo('INTEGRAÇÕES VINDI : :');

  // CONFIGURA O CLIENTDATASET
  cdsSolicitacoes := TClientDataSet.Create(Self);

  // CONFIGURA O DATASOURCE
  dsSolicitacoesVindi.DataSet := cdsSolicitacoes;

  DBGrid1.DataSource := dsSolicitacoesVindi;
  DBGrid1.OnDrawColumnCell := DBGrid1DrawColumnCell;

  cbPeriodo.ItemIndex := 4;

  dtDataInicio.Date := StartOfTheMonth(Date);
  dtDataFim.Date := EndOfTheMonth(Date);

  dtDataInicio.Visible := False;
  dtDataFim.Visible := False;

  CarregarCombos;
  RealizaConsulta;
  CarregarResumo;

  G_PrecisaAtualizarSolicitacao := False;
end;

procedure TFrmIntegracao.ExecutarConsultaLocalizar(const SQL: string);
var
  Query: TADOQuery;
  i: Integer;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := BD.Conexao;
    Query.SQL.Text := SQL;

    cdsSolicitacoes.DisableControls;
    try
      cdsSolicitacoes.Close;
      Query.Open;

      // Criar a estrutura do ClientDataSet baseada na query
      if cdsSolicitacoes.FieldCount = 0 then
      begin
        cdsSolicitacoes.FieldDefs.Clear;

        for i := 0 to Query.FieldCount - 1 do
        begin
          with Query.Fields[i] do
          begin
            case DataType of
              ftString, ftFixedChar, ftWideString, ftFixedWideChar:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftString, Size);
              ftInteger, ftSmallint, ftWord, ftAutoInc:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftInteger);
              ftFloat, ftCurrency, ftBCD:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftFloat);
              ftDate:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftDate);
              ftDateTime:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftDateTime);
              ftBoolean:
                cdsSolicitacoes.FieldDefs.Add(FieldName, ftBoolean);
            else
              cdsSolicitacoes.FieldDefs.Add(FieldName, ftString, 255);
            end;
          end;
        end;

        cdsSolicitacoes.CreateDataSet;
      end
      else
      begin
        cdsSolicitacoes.Open;
      end;

      // Copiar os dados
      cdsSolicitacoes.EmptyDataSet;

      while not Query.Eof do
      begin
        cdsSolicitacoes.Append;

        for i := 0 to Query.FieldCount - 1 do
        begin
          if cdsSolicitacoes.FindField(Query.Fields[i].FieldName) <> nil then
            cdsSolicitacoes.FieldByName(Query.Fields[i].FieldName).Value := Query.Fields[i].Value;
        end;

        cdsSolicitacoes.Post;
        Query.Next;
      end;

      cdsSolicitacoes.First;
    finally
      Query.Close;
      cdsSolicitacoes.EnableControls;
    end;
  finally
    Query.Free;
  end;
end;

procedure TFrmIntegracao.RealizaConsulta;
var
  sqlIntegracao: string;
  sPesquisa: string;
  DataInicio, DataFim: TDate;
  sDataInicio, sDataFim: string;
  SituacaoID, OperadoraID, TecnicoID, ResponsavelID: Integer;
begin
  sqlIntegracao :=
    'SELECT ' +
    '  SolicitacoesVindi.solicitacaoID, ' +
    '  SolicitacoesVindi.solicitacaoNomeFantasia, ' +
    '  SolicitacoesVindi.solicitacaoTipo, ' +
    '  SolicitacoesVindi.solicitacaoCPF, ' +
    '  SolicitacoesVindi.solicitacaoCNPJ, ' +
    '  SolicitacoesVindi.solicitacaoEnviado, ' +
    '  SolicitacoesVindi.colabID, ' +
    '  SolicitacoesVindi.solicitacaoDtCadastro, ' +
    '  SolicitacoesVindi.solicitacaoObs, ' +
    '  SolicitacoesVindi.solicitacaoTarefa, ' +
    '  SolicitacoesVindi.solicitacaoCodigo, ' +
    '  SolicitacoesVindi.solicitacaoExcluido, ' +
    '  Operadoras.operadoraNome, ' +
    '  Situacoes.situacaoNome, ' +
    '  Colaboradores.colabNome ' +
    'FROM ((SolicitacoesVindi ' +
    'INNER JOIN Operadoras ON SolicitacoesVindi.operadoraID = Operadoras.operadoraID) ' +
    'INNER JOIN Situacoes ON SolicitacoesVindi.situacaoID = Situacoes.situacaoID) ' +
    'INNER JOIN Colaboradores ON SolicitacoesVindi.colabID = Colaboradores.colabID ' +
    'WHERE SolicitacoesVindi.solicitacaoExcluido = False';

  // Filtros
  if cbSituação.ItemIndex > 0 then
  begin
    SituacaoID := Integer(cbSituação.Items.Objects[cbSituação.ItemIndex]);
    sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.situacaoID = ' + IntToStr(SituacaoID);
  end;

  if cbOperadora.ItemIndex > 0 then
  begin
    OperadoraID := Integer(cbOperadora.Items.Objects[cbOperadora.ItemIndex]);
    sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.operadoraID = ' + IntToStr(OperadoraID);
  end;

  if cbTecnico.ItemIndex > 0 then
  begin
    TecnicoID := Integer(cbTecnico.Items.Objects[cbTecnico.ItemIndex]);
    sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.colabID = ' + IntToStr(TecnicoID);
  end;

  if cbResponsavel.ItemIndex > 0 then
  begin
    ResponsavelID := Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);
    sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.colabRespID = ' + IntToStr(ResponsavelID);
  end;

  case cbEnviadoVindi.ItemIndex of
    1: sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.solicitacaoEnviado = False';
    2: sqlIntegracao := sqlIntegracao + ' AND SolicitacoesVindi.solicitacaoEnviado = True';
  end;

  sPesquisa := Trim(edPesquisar.Text);
  if sPesquisa <> '' then
  begin
    sPesquisa := StringReplace(sPesquisa, '''', '', [rfReplaceAll]);
    sqlIntegracao := sqlIntegracao +
      ' AND (SolicitacoesVindi.solicitacaoNomeFantasia LIKE ''%' + sPesquisa + '%'' ' +
      ' OR SolicitacoesVindi.solicitacaoCPF LIKE ''%' + sPesquisa + '%'' ' +
      ' OR SolicitacoesVindi.solicitacaoCNPJ LIKE ''%' + sPesquisa + '%'' ' +
      ' OR SolicitacoesVindi.solicitacaoTarefa LIKE ''%' + sPesquisa + '%'' ' +
      ' OR SolicitacoesVindi.solicitacaoCodigo LIKE ''%' + sPesquisa + '%'' ' +
      ' OR SolicitacoesVindi.solicitacaoObs LIKE ''%' + sPesquisa + '%'') ';
  end;

  // Período
  case cbPeriodo.ItemIndex of
    0: begin DataInicio := Date; DataFim := Date; end;
    1: begin DataInicio := Date-1; DataFim := Date-1; end;
    2: begin DataInicio := Date-7; DataFim := Date; end;
    3: begin DataInicio := Date-15; DataFim := Date; end;
    4: begin DataInicio := StartOfTheMonth(Date); DataFim := EndOfTheMonth(Date); end;
    5: begin
         DataInicio := StartOfTheMonth(IncMonth(Date,-1));
         DataFim := EndOfTheMonth(IncMonth(Date,-1));
       end;
    6: begin
         DataInicio := dtDataInicio.Date;
         DataFim := dtDataFim.Date;
       end;
  end;

  // FORMATO #YYYY-MM-DD#
  sDataInicio := FormatDateTime('yyyy-mm-dd', DataInicio);
  sDataFim := FormatDateTime('yyyy-mm-dd', DataFim);

  sqlIntegracao := sqlIntegracao +
    ' AND SolicitacoesVindi.solicitacaoDtCadastro >= #' + sDataInicio + '#' +
    ' AND SolicitacoesVindi.solicitacaoDtCadastro <= #' + sDataFim + '#' +
    ' ORDER BY SolicitacoesVindi.solicitacaoID';

  // Executar
  ExecutarConsultaLocalizar(sqlIntegracao);

  // UI
  if cdsSolicitacoes.IsEmpty then
  begin
    pnSemRegistro.Visible := True;
    DBGrid1.Visible := False;
    bntAlterar.Enabled := False;
    bntExcluir.Enabled := False;
  end
  else
  begin
    pnSemRegistro.Visible := False;
    DBGrid1.Visible := True;
    bntAlterar.Enabled := True;
    bntExcluir.Enabled := True;
  end;
end;

function TFrmIntegracao.MontarFiltro: string;
var
  DataInicio, DataFim: TDate;
  sDataInicio, sDataFim: string;
  SituacaoID, OperadoraID, TecnicoID, ResponsavelID: Integer;
begin
  Result := ' WHERE 1=1 AND SolicitacoesVindi.solicitacaoExcluido = False ';

  if cbSituação.ItemIndex > 0 then
  begin
    SituacaoID := Integer(cbSituação.Items.Objects[cbSituação.ItemIndex]);
    Result := Result + ' AND SolicitacoesVindi.situacaoID = ' + IntToStr(SituacaoID);
  end;

  if cbOperadora.ItemIndex > 0 then
  begin
    OperadoraID := Integer(cbOperadora.Items.Objects[cbOperadora.ItemIndex]);
    Result := Result + ' AND SolicitacoesVindi.operadoraID = ' + IntToStr(OperadoraID);
  end;

  if cbTecnico.ItemIndex > 0 then
  begin
    TecnicoID := Integer(cbTecnico.Items.Objects[cbTecnico.ItemIndex]);
    Result := Result + ' AND SolicitacoesVindi.colabID = ' + IntToStr(TecnicoID);
  end;

  if cbResponsavel.ItemIndex > 0 then
  begin
    ResponsavelID := Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);
    Result := Result + ' AND SolicitacoesVindi.colabRespID = ' + IntToStr(ResponsavelID);
  end;

  case cbEnviadoVindi.ItemIndex of
    1: Result := Result + ' AND SolicitacoesVindi.solicitacaoEnviado = False';
    2: Result := Result + ' AND SolicitacoesVindi.solicitacaoEnviado = True';
  end;

  case cbPeriodo.ItemIndex of
    0: begin DataInicio := Date; DataFim := Date; end;
    1: begin DataInicio := Date-1; DataFim := Date-1; end;
    2: begin DataInicio := Date-7; DataFim := Date; end;
    3: begin DataInicio := Date-15; DataFim := Date; end;
    4: begin DataInicio := StartOfTheMonth(Date); DataFim := EndOfTheMonth(Date); end;
    5: begin
         DataInicio := StartOfTheMonth(IncMonth(Date,-1));
         DataFim := EndOfTheMonth(IncMonth(Date,-1));
       end;
    6: begin
         DataInicio := dtDataInicio.Date;
         DataFim := dtDataFim.Date;
       end;
  end;

  sDataInicio := FormatDateTime('yyyy-mm-dd', DataInicio);
  sDataFim := FormatDateTime('yyyy-mm-dd', DataFim);

  Result := Result + ' AND SolicitacoesVindi.solicitacaoDtCadastro >= #' + sDataInicio + '#' +
                     ' AND SolicitacoesVindi.solicitacaoDtCadastro <= #' + sDataFim + '#';
end;

function TFrmIntegracao.MontarFiltroResumo: string;
begin
  Result := MontarFiltro;
end;

procedure TFrmIntegracao.CarregarResumo;
var
  Query: TADOQuery;
  sql, filtro: string;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := BD.Conexao;

    filtro := Trim(MontarFiltroResumo);
    if filtro = '' then
      filtro := ' WHERE 1=1 ';

    sql :=
      'SELECT ' +
      'COUNT(*) AS TotalGeral, ' +

      'SUM(IIF(Situacoes.situacaoNome = ''PENDENTE'', 1, 0)) AS TotalPendente, ' +
      'SUM(IIF(Situacoes.situacaoNome = ''EM ANDAMENTO'', 1, 0)) AS TotalAndamento, ' +
      'SUM(IIF(Situacoes.situacaoNome = ''FINALIZADO'', 1, 0)) AS TotalFinalizado, ' +

      'SUM(IIF(solicitacaoEnviado = True, 1, 0)) AS TotalEnviado, ' +
      'SUM(IIF(solicitacaoEnviado = False, 1, 0)) AS TotalNaoEnviado ' +

      'FROM SolicitacoesVindi ' +
      'INNER JOIN Situacoes ON Situacoes.situacaoID = SolicitacoesVindi.situacaoID ' +
      filtro;

    Query.Close;
    Query.SQL.Text := sql;
    Query.Open;

    lbTotalGeral.Caption      := VarToStrDef(Query.FieldByName('TotalGeral').Value, '0');
    lbTotalPendente.Caption   := VarToStrDef(Query.FieldByName('TotalPendente').Value, '0');
    lbTotalAndamento.Caption  := VarToStrDef(Query.FieldByName('TotalAndamento').Value, '0');
    lbTotalFinalizado.Caption := VarToStrDef(Query.FieldByName('TotalFinalizado').Value, '0');
    lbTotalEnviado.Caption    := VarToStrDef(Query.FieldByName('TotalEnviado').Value, '0');
    lbFaltaEnviar.Caption     := VarToStrDef(Query.FieldByName('TotalNaoEnviado').Value, '0');

  finally
    Query.Free;
  end;
end;

procedure TFrmIntegracao.CarregarCombos;
var
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := BD.Conexao;

    // Operadoras
    cbOperadora.Items.Clear;
    Query.SQL.Text := 'SELECT operadoraID, operadoraNome FROM Operadoras ORDER BY operadoraID';
    Query.Open;
    cbOperadora.Items.Add('TODOS');
    while not Query.Eof do
    begin
      cbOperadora.Items.AddObject(
        Query.FieldByName('operadoraNome').AsString,
        TObject(Query.FieldByName('operadoraID').AsInteger)
      );
      Query.Next;
    end;
    Query.Close;
    cbOperadora.ItemIndex := 0;

    // Situação
    cbSituação.Items.Clear;
    Query.SQL.Text := 'SELECT situacaoID, situacaoNome FROM Situacoes ORDER BY situacaoID';
    Query.Open;
    cbSituação.Items.Add('TODOS');
    while not Query.Eof do
    begin
      cbSituação.Items.AddObject(
        Query.FieldByName('situacaoNome').AsString,
        TObject(Query.FieldByName('situacaoID').AsInteger)
      );
      Query.Next;
    end;
    Query.Close;
    cbSituação.ItemIndex := 0;

    // Técnicos
    cbTecnico.Items.Clear;
    Query.SQL.Text := 'SELECT colabID, colabNome FROM Colaboradores ORDER BY colabNome';
    Query.Open;
    cbTecnico.Items.Add('TODOS');
    while not Query.Eof do
    begin
      cbTecnico.Items.AddObject(
        Query.FieldByName('colabNome').AsString,
        TObject(Query.FieldByName('colabID').AsInteger)
      );
      Query.Next;
    end;
    Query.Close;
    cbTecnico.ItemIndex := 0;

    // Responsáveis
    cbResponsavel.Items.Clear;
    Query.SQL.Text := 'SELECT colabID, colabNome FROM Colaboradores WHERE colabResp = True ORDER BY colabNome';
    Query.Open;
    cbResponsavel.Items.Add('TODOS');
    while not Query.Eof do
    begin
      cbResponsavel.Items.AddObject(
        Query.FieldByName('colabNome').AsString,
        TObject(Query.FieldByName('colabID').AsInteger)
      );
      Query.Next;
    end;
    Query.Close;
    cbResponsavel.ItemIndex := 0;

    // Enviado
    cbEnviadoVindi.Items.Clear;
    cbEnviadoVindi.Items.Add('SELECIONE');
    cbEnviadoVindi.Items.Add('NÃO');
    cbEnviadoVindi.Items.Add('SIM');
    cbEnviadoVindi.ItemIndex := 0;

  finally
    Query.Free;
  end;
end;

procedure TFrmIntegracao.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Texto: string;
begin
  DBGrid1.Canvas.Font.Name := FontGrid;
  DBGrid1.Canvas.Font.Size := SizeFontGrid;
  DBGrid1.Canvas.Font.Style := [];

  if odd(cdsSolicitacoes.RecNo) then
  begin
    DBGrid1.Canvas.Brush.Color := CorGridZebrada;
    DBGrid1.Canvas.Font.Color  := CorGridZebradaFonte;
  end
  else
  begin
    DBGrid1.Canvas.Brush.Color := CorGridZebradaNao;
    DBGrid1.Canvas.Font.Color  := CorGridZebradaFonteNao;
  end;

  if (gdSelected in State) and not cdsSolicitacoes.IsEmpty then
  begin
    DBGrid1.Canvas.Brush.Color := CorGridSelecionado;
    DBGrid1.Canvas.Font.Color  := CorGridSelecionadoFonte;
    DBGrid1.Canvas.Font.Style  := GridBold;
  end;

  if Column.FieldName = 'solicitacaoNomeFantasia' then
  begin
    Texto := Column.Field.AsString;

    if Length(Texto) > 19 then
      Texto := Copy(Texto, 1, 19) + '...';

    DBGrid1.Canvas.FillRect(Rect);
    DBGrid1.Canvas.TextOut(Rect.Left + 4, Rect.Top + 2, Texto);
  end
  else
  begin
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

// Eventos
procedure TFrmIntegracao.cbSituaçãoChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmIntegracao.edPesquisarChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
end;

procedure TFrmIntegracao.cbOperadoraChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmIntegracao.cbTecnicoChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmIntegracao.cbPeriodoChange(Sender: TObject);
begin
  if cbPeriodo.ItemIndex = 6 then
  begin
    dtDataInicio.Visible := True;
    dtDataFim.Visible := True;
  end
  else
  begin
    dtDataInicio.Visible := False;
    dtDataFim.Visible := False;
    RealizaConsulta;
    CarregarResumo;
  end;
end;

procedure TFrmIntegracao.dtDataInicioChange(Sender: TObject);
begin
  if cbPeriodo.ItemIndex = 6 then
  begin
    RealizaConsulta;
    CarregarResumo;
  end;
end;

procedure TFrmIntegracao.dtDataFimChange(Sender: TObject);
begin
  if cbPeriodo.ItemIndex = 6 then
  begin
    RealizaConsulta;
    CarregarResumo;
  end;
end;

procedure TFrmIntegracao.cbResponsavelChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmIntegracao.cbEnviadoVindiChange(Sender: TObject);
begin
  RealizaConsulta;
  CarregarResumo;
end;

// Ações
procedure TFrmIntegracao.bntCadastrarClick(Sender: TObject);
begin
  inherited;
  G_AcaoIntegracao := 'cadastrar';
  G_SolicitacaoID := 0;

  FrmIntegracaoCadastro := TFrmIntegracaoCadastro.Create(Self);
  try
    FrmIntegracaoCadastro.ShowModal;
    if G_PrecisaAtualizarSolicitacao then
    begin
      RealizaConsulta;
      CarregarCombos;
      CarregarResumo;
    end;
  finally
    FrmIntegracaoCadastro.Free;
  end;
end;

procedure TFrmIntegracao.bntAlterarClick(Sender: TObject);
begin
  inherited;
  if not cdsSolicitacoes.IsEmpty then
  begin
    G_AcaoIntegracao := 'alterar';
    G_SolicitacaoID := cdsSolicitacoes.FieldByName('solicitacaoID').AsInteger;

    FrmIntegracaoCadastro := TFrmIntegracaoCadastro.Create(Self);
    try
      FrmIntegracaoCadastro.ShowModal;
      if G_PrecisaAtualizarSolicitacao then
      begin
        RealizaConsulta;
        CarregarResumo;
      end;
    finally
      FrmIntegracaoCadastro.Free;
    end;
  end;
end;

procedure TFrmIntegracao.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if not cdsSolicitacoes.IsEmpty then
  begin
    G_AcaoIntegracao := 'alterar';
    G_SolicitacaoID := cdsSolicitacoes.FieldByName('solicitacaoID').AsInteger;

    FrmIntegracaoCadastro := TFrmIntegracaoCadastro.Create(Self);
    try
      FrmIntegracaoCadastro.ShowModal;
      if G_PrecisaAtualizarSolicitacao then
      begin
        RealizaConsulta;
        CarregarResumo;
      end;
    finally
      FrmIntegracaoCadastro.Free;
    end;
  end;
end;

procedure TFrmIntegracao.bntExcluirClick(Sender: TObject);
var
  sql: string;
  solicitacaoID: Integer;
  FrmMsg: TFrmMensagem;
begin
  inherited;

  if cdsSolicitacoes.IsEmpty then
  begin
    FrmMsg := TFrmMensagem.Create(Self);
    try
      FrmMsg.ExibirMensagem(tmAtencao, 'Nenhuma solicitação selecionada!');
    finally
      FrmMsg.Free;
    end;
    Exit;
  end;

  solicitacaoID := cdsSolicitacoes.FieldByName('solicitacaoID').AsInteger;

  FrmMsg := TFrmMensagem.Create(Self);
  try
    if not FrmMsg.Confirmar('Confirmação', 'Deseja realmente excluir esta solicitação?') then
      Exit;
  finally
    FrmMsg.Free;
  end;

  sql := 'UPDATE SolicitacoesVindi SET solicitacaoExcluido = :solicitacaoExcluido WHERE solicitacaoID = :solicitacaoID';
  ADOSolicitacoesVindi.CommandText := sql;

  with ADOSolicitacoesVindi do
  begin
    try
      Parameters.ParamByName('solicitacaoExcluido').Value := True;
      Parameters.ParamByName('solicitacaoID').Value := solicitacaoID;
      Execute;
      Parameters.Clear;

      FrmMsg := TFrmMensagem.Create(Self);
      try
        FrmMsg.ExibirMensagem(tmSucesso, 'Solicitação excluída com sucesso!');
      finally
        FrmMsg.Free;
      end;

      RealizaConsulta;
      CarregarResumo;

    except
      on E: Exception do
      begin
        Parameters.Clear;

        FrmMsg := TFrmMensagem.Create(Self);
        try
          FrmMsg.ExibirMensagem(tmErro, 'Erro: ' + E.Message);
        finally
          FrmMsg.Free;
        end;

        Abort;
      end;
    end;
  end;
end;

end.
