unit uNotasFiscais;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  uModelo, uGlobal, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, DateUtils,
  Vcl.Buttons, Datasnap.DBClient;

type
  TFrmNotasFiscais = class(TModelo)
    pnTopoFiltro: TPanel;
    lbSituacao: TLabel;
    lbTecnico: TLabel;
    lbPesquisar: TLabel;
    cbSituação: TComboBox;
    cbTecnico: TComboBox;
    edPesquisar: TEdit;
    pnFiltro: TPanel;
    lbPeriodo: TLabel;
    lbResponsavel: TLabel;
    lbEmitida: TLabel;
    gbResumo: TGroupBox;
    lbPendente: TLabel;
    lbEmAndamento: TLabel;
    lbFinalizado: TLabel;
    lbTotalPendente: TLabel;
    lbTotalAndamento: TLabel;
    lbTotalFinalizado: TLabel;
    lbTotalGeral: TLabel;
    lbTotal: TLabel;
    lbJaEmitidas: TLabel;
    lbEmitidas: TLabel;
    lbTotalEmitidas: TLabel;
    lbNaoEmitidas: TLabel;
    lbTotalNaoEmitidas: TLabel;
    pnSeparador: TPanel;
    Panel1: TPanel;
    cbResponsavel: TComboBox;
    cbEmitida: TComboBox;
    pnSemRegistro: TPanel;
    imgSemRegistro: TImage;
    lbSemRegistro: TLabel;
    pnRodape: TPanel;
    bntAlterar: TButton;
    bntFechar: TButton;
    bntCadastrar: TButton;
    DBGrid1: TDBGrid;
    ADONotasFiscais: TADOCommand;
    dsNotasFiscais: TDataSource;
    lbAguardando: TLabel;
    lbTotalAguardando: TLabel;
    cdsNotasFiscais: TClientDataSet;
    pcPeriodo: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnFiltroTopo: TPanel;
    cbPeriodo: TComboBox;
    dtDataInicio: TDateTimePicker;
    dtDataFim: TDateTimePicker;

    procedure FormCreate(Sender: TObject);
    procedure bntFecharClick(Sender: TObject);
    procedure edPesquisarChange(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);

    procedure cbSituaçãoChange(Sender: TObject);
    procedure cbTecnicoChange(Sender: TObject);
    procedure cbResponsavelChange(Sender: TObject);
    procedure cbEmitidaChange(Sender: TObject);
    procedure cbPeriodoChange(Sender: TObject);
    procedure dtDataInicioChange(Sender: TObject);
    procedure dtDataFimChange(Sender: TObject);
    procedure bntCadastrarClick(Sender: TObject);
    procedure bntAlterarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure pcPeriodoChange(Sender: TObject);

  private
    procedure RealizaConsulta;
    procedure CarregarResumo;
    procedure CarregarCombos;
    function MontarFiltro: string;
    procedure ExecutarConsultaLocalizar(const SQL: string);
    function GetCampoData: string;
  end;

var
  FrmNotasFiscais: TFrmNotasFiscais;

implementation

uses
  uBD, uIntegracaoNotasCadastro, uMensagem;

{$R *.dfm}

procedure TFrmNotasFiscais.ExecutarConsultaLocalizar(const SQL: string);
var
  Query: TADOQuery;
  i: Integer;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := BD.Conexao;
    Query.SQL.Text := SQL;

    cdsNotasFiscais.DisableControls;
    try
      cdsNotasFiscais.Close;
      Query.Open;

      // Criar a estrutura do ClientDataSet baseada na query
      if cdsNotasFiscais.FieldCount = 0 then
      begin
        cdsNotasFiscais.FieldDefs.Clear;

        for i := 0 to Query.FieldCount - 1 do
        begin
          with Query.Fields[i] do
          begin
            case DataType of
              ftString, ftFixedChar, ftWideString, ftFixedWideChar:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftString, Size);
              ftInteger, ftSmallint, ftWord, ftAutoInc:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftInteger);
              ftFloat, ftCurrency, ftBCD:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftFloat);
              ftDate:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftDate);
              ftDateTime:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftDateTime);
              ftBoolean:
                cdsNotasFiscais.FieldDefs.Add(FieldName, ftBoolean);
            else
              cdsNotasFiscais.FieldDefs.Add(FieldName, ftString, 255);
            end;
          end;
        end;

        cdsNotasFiscais.CreateDataSet;
      end
      else
      begin
        cdsNotasFiscais.Open;
      end;

      // Copiar os dados
      cdsNotasFiscais.EmptyDataSet;

      while not Query.Eof do
      begin
        cdsNotasFiscais.Append;

        for i := 0 to Query.FieldCount - 1 do
        begin
          if cdsNotasFiscais.FindField(Query.Fields[i].FieldName) <> nil then
            cdsNotasFiscais.FieldByName(Query.Fields[i].FieldName).Value := Query.Fields[i].Value;
        end;

        cdsNotasFiscais.Post;
        Query.Next;
      end;

      cdsNotasFiscais.First;

      // Formatar campos de data no ClientDataSet
      if cdsNotasFiscais.FindField('notaDtAtivacao') <> nil then
        TDateTimeField(cdsNotasFiscais.FieldByName('notaDtAtivacao')).DisplayFormat := 'dd/mm/yyyy hh:nn';

      if cdsNotasFiscais.FindField('notaDtCadastro') <> nil then
        TDateTimeField(cdsNotasFiscais.FieldByName('notaDtCadastro')).DisplayFormat := 'dd/mm/yyyy hh:nn';

    finally
      Query.Close;
      cdsNotasFiscais.EnableControls;
    end;
  finally
    Query.Free;
  end;
end;

procedure TFrmNotasFiscais.FormCreate(Sender: TObject);
begin
  inherited;

  SetTitulo('NOTAS FISCAIS : :');

  // CONFIGURA O CLIENTDATASET
  cdsNotasFiscais := TClientDataSet.Create(Self);

  // CONFIGURA O DATASOURCE
  dsNotasFiscais.DataSet := cdsNotasFiscais;
  DBGrid1.DataSource := dsNotasFiscais;

  DBGrid1.OnDrawColumnCell := DBGrid1DrawColumnCell;

  cbPeriodo.ItemIndex := 4;

  dtDataInicio.Date := StartOfTheMonth(Date);
  dtDataFim.Date := EndOfTheMonth(Date);

  dtDataInicio.Enabled := False;
  dtDataFim.Enabled := False;

  CarregarCombos;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Texto: string;
begin
  DBGrid1.Canvas.Font.Name := FontGrid;
  DBGrid1.Canvas.Font.Size := SizeFontGrid;
  DBGrid1.Canvas.Font.Style := [];

  // ZEBRADO
  if not cdsNotasFiscais.IsEmpty then
  begin
    if odd(cdsNotasFiscais.RecNo) then
    begin
      DBGrid1.Canvas.Brush.Color := CorGridZebrada;
      DBGrid1.Canvas.Font.Color  := CorGridZebradaFonte;
    end
    else
    begin
      DBGrid1.Canvas.Brush.Color := CorGridZebradaNao;
      DBGrid1.Canvas.Font.Color  := CorGridZebradaFonteNao;
    end;
  end;

  // SELECIONADO
  if (gdSelected in State) and not cdsNotasFiscais.IsEmpty then
  begin
    DBGrid1.Canvas.Brush.Color := CorGridSelecionado;
    DBGrid1.Canvas.Font.Color  := CorGridSelecionadoFonte;
    DBGrid1.Canvas.Font.Style  := GridBold;
  end;

  // TRATAMENTO DO CAMPO
  if Column.FieldName = 'notaNomeFantasia' then
  begin
    Texto := Column.Field.AsString;

    if Length(Texto) > 18 then
      Texto := Copy(Texto, 1, 18) + '...';

    DBGrid1.Canvas.FillRect(Rect);
    DBGrid1.Canvas.TextOut(Rect.Left + 4, Rect.Top + 2, Texto);
  end
  else
  begin
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TFrmNotasFiscais.bntAlterarClick(Sender: TObject);
begin
  inherited;

  if not cdsNotasFiscais.IsEmpty then
  begin
    G_AcaoNotas := 'alterar';
    G_NotaID := cdsNotasFiscais.FieldByName('notaID').AsInteger;

    FrmIntegracaoNotasCadastro := TFrmIntegracaoNotasCadastro.Create(Self);
    try
      FrmIntegracaoNotasCadastro.ShowModal;

      if G_PrecisaAtualizarNotas then
      begin
        RealizaConsulta;
        CarregarResumo;
      end;

    finally
      FrmIntegracaoNotasCadastro.Free;
    end;
  end;
end;

procedure TFrmNotasFiscais.DBGrid1DblClick(Sender: TObject);
begin
  inherited;

  if not cdsNotasFiscais.IsEmpty then
  begin
    G_AcaoNotas := 'alterar';
    G_NotaID := cdsNotasFiscais.FieldByName('notaID').AsInteger;

    FrmIntegracaoNotasCadastro := TFrmIntegracaoNotasCadastro.Create(Self);
    try
      FrmIntegracaoNotasCadastro.ShowModal;

      if G_PrecisaAtualizarNotas then
      begin
        RealizaConsulta;
        CarregarResumo;
      end;

    finally
      FrmIntegracaoNotasCadastro.Free;
    end;
  end;
end;

procedure TFrmNotasFiscais.bntCadastrarClick(Sender: TObject);
begin
  inherited;

  G_AcaoNotas := 'cadastrar';
  G_NotaID := 0;

  FrmIntegracaoNotasCadastro := TFrmIntegracaoNotasCadastro.Create(Self);
  try
    FrmIntegracaoNotasCadastro.ShowModal;

    if G_PrecisaAtualizarNotas then
    begin
      RealizaConsulta;
      CarregarCombos;
      CarregarResumo;
    end;

  finally
    FrmIntegracaoNotasCadastro.Free;
  end;
end;

procedure TFrmNotasFiscais.bntFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmNotasFiscais.edPesquisarChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
end;

procedure TFrmNotasFiscais.cbSituaçãoChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.cbTecnicoChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.cbResponsavelChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.cbEmitidaChange(Sender: TObject);
begin
  inherited;
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.cbPeriodoChange(Sender: TObject);
begin
  // habilita só no personalizado
  dtDataInicio.Enabled := cbPeriodo.ItemIndex = 6;
  dtDataFim.Enabled := cbPeriodo.ItemIndex = 6;

  case cbPeriodo.ItemIndex of
    0: begin // Hoje
         dtDataInicio.Date := Date;
         dtDataFim.Date := Date;
       end;

    1: begin // Ontem
         dtDataInicio.Date := Date - 1;
         dtDataFim.Date := Date - 1;
       end;

    2: begin // Últimos 7 dias
         dtDataInicio.Date := Date - 7;
         dtDataFim.Date := Date;
       end;

    3: begin // Últimos 15 dias
         dtDataInicio.Date := Date - 15;
         dtDataFim.Date := Date;
       end;

    4: begin // Mês atual
         dtDataInicio.Date := StartOfTheMonth(Date);
         dtDataFim.Date := EndOfTheMonth(Date);
       end;

    5: begin // Mês anterior
         dtDataInicio.Date := StartOfTheMonth(IncMonth(Date, -1));
         dtDataFim.Date := EndOfTheMonth(IncMonth(Date, -1));
       end;

    // 6 = personalizado (não altera)
  end;

  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.dtDataInicioChange(Sender: TObject);
begin
  if cbPeriodo.ItemIndex = 6 then
  begin
    RealizaConsulta;
    CarregarResumo;
  end;
end;

procedure TFrmNotasFiscais.dtDataFimChange(Sender: TObject);
begin
  if cbPeriodo.ItemIndex = 6 then
  begin
    RealizaConsulta;
    CarregarResumo;
  end;
end;

function TFrmNotasFiscais.GetCampoData: string;
begin
  if pcPeriodo.ActivePageIndex = 0 then
    Result := 'NotasFiscais.notaDtCadastro'
  else
    Result := 'NotasFiscais.notaDtAtivacao';
end;

function TFrmNotasFiscais.MontarFiltro: string;
var
  SituacaoID, TecnicoID, ResponsavelID: Integer;
  CampoData: string;
begin
  Result := ' WHERE NotasFiscais.notaExcluido = False ';

  CampoData := GetCampoData;

  if cbSituação.ItemIndex > 0 then
  begin
    SituacaoID := Integer(cbSituação.Items.Objects[cbSituação.ItemIndex]);
    Result := Result + ' AND NotasFiscais.situacaoNotaID = ' + IntToStr(SituacaoID);
  end;

  if cbTecnico.ItemIndex > 0 then
  begin
    TecnicoID := Integer(cbTecnico.Items.Objects[cbTecnico.ItemIndex]);
    Result := Result + ' AND NotasFiscais.colabID = ' + IntToStr(TecnicoID);
  end;

  if cbResponsavel.ItemIndex > 0 then
  begin
    ResponsavelID := Integer(cbResponsavel.Items.Objects[cbResponsavel.ItemIndex]);
    Result := Result + ' AND NotasFiscais.colabRespID = ' + IntToStr(ResponsavelID);
  end;

  case cbEmitida.ItemIndex of
    1: Result := Result + ' AND NotasFiscais.notaEmitida = False';
    2: Result := Result + ' AND NotasFiscais.notaEmitida = True';
  end;

  // SEMPRE USA OS CAMPOS
  Result := Result +
    ' AND ' + CampoData + ' >= #' + FormatDateTime('yyyy-mm-dd', dtDataInicio.Date) + '#' +
    ' AND ' + CampoData + ' < #' + FormatDateTime('yyyy-mm-dd', dtDataFim.Date + 1) + '#';
end;

procedure TFrmNotasFiscais.pcPeriodoChange(Sender: TObject);
begin
  RealizaConsulta;
  CarregarResumo;
end;

procedure TFrmNotasFiscais.RealizaConsulta;
var
  sql, sPesquisa: string;
begin
  sql :=
    'SELECT NotasFiscais.*, SituacoesNotas.situacaoNotaNome, Colaboradores.colabNome ' +
    'FROM (NotasFiscais ' +
    'INNER JOIN SituacoesNotas ON SituacoesNotas.situacaoNotaID = NotasFiscais.situacaoNotaID) ' +
    'INNER JOIN Colaboradores ON Colaboradores.colabID = NotasFiscais.colabID ' +
    MontarFiltro;

  sPesquisa := Trim(edPesquisar.Text);

  if sPesquisa <> '' then
  begin
    sPesquisa := StringReplace(sPesquisa, '''', '', [rfReplaceAll]);

    sql := sql +
      ' AND (notaNomeFantasia LIKE ''%' + sPesquisa + '%'' ' +
      ' OR notaCPF LIKE ''%' + sPesquisa + '%'' ' +
      ' OR notaCNPJ LIKE ''%' + sPesquisa + '%'' ' +
      ' OR notaTarefa LIKE ''%' + sPesquisa + '%'' ' +
      ' OR notaObs LIKE ''%' + sPesquisa + '%'') ';
  end;

  sql := sql + ' ORDER BY notaID';

  // Executa a consulta usando ClientDataSet
  ExecutarConsultaLocalizar(sql);

  // UI

  if cdsNotasFiscais.IsEmpty then
  begin
    pnSemRegistro.Visible := True;
    DBGrid1.Visible := False;
    bntAlterar.Enabled := False;
  end
  else
  begin
    pnSemRegistro.Visible := False;
    DBGrid1.Visible := True;
    bntAlterar.Enabled := True;
  end;
end;

procedure TFrmNotasFiscais.CarregarResumo;
var
  Query: TADOQuery;
  sql, filtro: string;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := BD.Conexao;

    filtro := Trim(MontarFiltro);
    if filtro = '' then
      filtro := ' WHERE 1=1 ';

    sql :=
      'SELECT ' +
      'COUNT(*) AS TotalGeral, ' +

      'SUM(IIF(SituacoesNotas.situacaoNotaNome = ''PENDENTE'', 1, 0)) AS TotalPendente, ' +
      'SUM(IIF(SituacoesNotas.situacaoNotaNome = ''AGUARDANDO'', 1, 0)) AS TotalAguardando, ' +
      'SUM(IIF(SituacoesNotas.situacaoNotaNome = ''EM ANDAMENTO'', 1, 0)) AS TotalAndamento, ' +
      'SUM(IIF(SituacoesNotas.situacaoNotaNome = ''FINALIZADO'', 1, 0)) AS TotalFinalizado, ' +

      'SUM(IIF(notaEmitida = True, 1, 0)) AS TotalEmitidas, ' +
      'SUM(IIF(notaEmitida = False, 1, 0)) AS TotalNaoEmitidas ' +

      'FROM NotasFiscais ' +
      'INNER JOIN SituacoesNotas ON SituacoesNotas.situacaoNotaID = NotasFiscais.situacaoNotaID ' +
      filtro;

    Query.Close;
    Query.SQL.Text := sql;
    Query.Open;

    lbTotalGeral.Caption        := VarToStrDef(Query.FieldByName('TotalGeral').Value, '0');
    lbTotalPendente.Caption     := VarToStrDef(Query.FieldByName('TotalPendente').Value, '0');
    lbTotalAguardando.Caption   := VarToStrDef(Query.FieldByName('TotalAguardando').Value, '0');
    lbTotalAndamento.Caption    := VarToStrDef(Query.FieldByName('TotalAndamento').Value, '0');
    lbTotalFinalizado.Caption   := VarToStrDef(Query.FieldByName('TotalFinalizado').Value, '0');
    lbTotalEmitidas.Caption     := VarToStrDef(Query.FieldByName('TotalEmitidas').Value, '0');
    lbTotalNaoEmitidas.Caption  := VarToStrDef(Query.FieldByName('TotalNaoEmitidas').Value, '0');

  finally
    Query.Free;
  end;
end;

procedure TFrmNotasFiscais.CarregarCombos;
var
  qr: TADOQuery;
begin
  qr := TADOQuery.Create(nil);
  try
    qr.Connection := BD.Conexao;

    // Situações
    cbSituação.Items.Clear;
    qr.SQL.Text := 'SELECT situacaoNotaID, situacaoNotaNome FROM SituacoesNotas ORDER BY situacaoNotaNome';
    qr.Open;
    try
      cbSituação.Items.Add('TODOS');
      while not qr.Eof do
      begin
        cbSituação.Items.AddObject(
          qr.FieldByName('situacaoNotaNome').AsString,
          TObject(qr.FieldByName('situacaoNotaID').AsInteger)
        );
        qr.Next;
      end;
    finally
      qr.Close;
    end;
    cbSituação.ItemIndex := 0;

    // Técnicos
    cbTecnico.Items.Clear;
    qr.SQL.Text := 'SELECT colabID, colabNome FROM Colaboradores ORDER BY colabNome';
    qr.Open;
    try
      cbTecnico.Items.Add('TODOS');
      while not qr.Eof do
      begin
        cbTecnico.Items.AddObject(
          qr.FieldByName('colabNome').AsString,
          TObject(qr.FieldByName('colabID').AsInteger)
        );
        qr.Next;
      end;
    finally
      qr.Close;
    end;
    cbTecnico.ItemIndex := 0;

    // Responsáveis
    cbResponsavel.Items.Clear;
    qr.SQL.Text := 'SELECT colabID, colabNome FROM Colaboradores WHERE colabResp = True ORDER BY colabNome';
    qr.Open;
    try
      cbResponsavel.Items.Add('TODOS');
      while not qr.Eof do
      begin
        cbResponsavel.Items.AddObject(
          qr.FieldByName('colabNome').AsString,
          TObject(qr.FieldByName('colabID').AsInteger)
        );
        qr.Next;
      end;
    finally
      qr.Close;
    end;
    cbResponsavel.ItemIndex := 0;

    // Emitida
    cbEmitida.Items.Clear;
    cbEmitida.Items.Add('SELECIONE');
    cbEmitida.Items.Add('NÃO');
    cbEmitida.Items.Add('SIM');
    cbEmitida.ItemIndex := 0;

  finally
    qr.Free;
  end;
end;

end.
