unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes,
  System.IOUtils, ComObj, ShlObj, Registry, System.Types,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uModelo, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Imaging.jpeg,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, uBD, uGlobal, uIntegracao, uNotasFiscais, uMensagem;

type
  TFrmPrincipal = class(TModelo)
    MainMenu1: TMainMenu;
    Controle: TMenuItem;
    Clientes1: TMenuItem;
    Fncionarios1: TMenuItem;
    pnCentro: TPanel;
    ToolBar1: TToolBar;
    pnPrincipalCentro: TPanel;
    imgCentro: TImage;
    bntIntegracoesVindi: TSpeedButton;
    ImageList1: TImageList;
    Image1: TImage;
    bntNotasFiscais: TSpeedButton;
    procedure bntIntegracoesVindiClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bntNotasFiscaisClick(Sender: TObject);
    procedure Fncionarios1Click(Sender: TObject);
  private
    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure CriarEstruturaPastas;
    procedure CriarAtalhoDesktop;
    procedure MarcarAtalhoCriado;
    procedure SalvarLogErro(E: Exception);

    procedure SetBackupAutomatico(Value: Boolean);
    function GetBackupAutomatico: Boolean;

    procedure RealizarBackup;
    procedure LimparBackupsAntigos;

    procedure AtivarJanelaExistente;
    function JaEstaExecutando: Boolean;

    function GetUsuarioWindows: string;
    function GetNomeComputador: string;
    function JaCriouAtalho: Boolean;

  public
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

const
  PATH_BASE = 'C:\PROSISTEMAS\SCAINTEGRACOES\';
  PATH_LOG  = 'C:\PROSISTEMAS\SCAINTEGRACOES\Logs\';
  PATH_BACKUP = 'C:\PROSISTEMAS\SCAINTEGRACOES\Backup\';

{ ===================================================== }
{ PASTAS }
{ ===================================================== }
procedure TFrmPrincipal.CriarEstruturaPastas;
begin
  ForceDirectories(PATH_LOG);
  ForceDirectories(PATH_BACKUP);
end;

{ ===================================================== }
{ ATALHO }
{ ===================================================== }
procedure TFrmPrincipal.CriarAtalhoDesktop;
var
  Shell, Atalho: OleVariant;
  CaminhoDesktop, CaminhoAtalho: string;
  Path: array[0..MAX_PATH] of Char;
begin
  if JaCriouAtalho then Exit;

  SHGetFolderPath(0, CSIDL_DESKTOP, 0, 0, Path);
  CaminhoDesktop := Path;

  CaminhoAtalho := IncludeTrailingPathDelimiter(CaminhoDesktop) + 'SCA Integracoes.lnk';

  try
    Shell := CreateOleObject('WScript.Shell');
    Atalho := Shell.CreateShortcut(CaminhoAtalho);

    Atalho.TargetPath := Application.ExeName;
    Atalho.WorkingDirectory := ExtractFilePath(Application.ExeName);
    Atalho.Description := 'Sistema SCA Integrações';
    Atalho.IconLocation := Application.ExeName + ',0';

    Atalho.Save;

    MarcarAtalhoCriado;
  except
  end;
end;

function TFrmPrincipal.JaCriouAtalho: Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SCAIntegracoes', False) then
      Result := Reg.ReadBool('AtalhoCriado')
    else
      Result := False;
  finally
    Reg.Free;
  end;
end;

procedure TFrmPrincipal.MarcarAtalhoCriado;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SCAIntegracoes', True) then
      Reg.WriteBool('AtalhoCriado', True);
  finally
    Reg.Free;
  end;
end;

{ ===================================================== }
{ USUÁRIO / PC }
{ ===================================================== }
function TFrmPrincipal.GetUsuarioWindows: string;
var
  Buffer: array[0..255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetUserName(Buffer, Size) then
    Result := Buffer
  else
    Result := 'Desconhecido';
end;

function TFrmPrincipal.GetNomeComputador: string;
var
  Buffer: array[0..255] of Char;
  Size: DWORD;
begin
  Size := 256;
  if GetComputerName(Buffer, Size) then
    Result := Buffer
  else
    Result := 'Desconhecido';
end;

{ ===================================================== }
{ LOG }
{ ===================================================== }
procedure TFrmPrincipal.SalvarLogErro(E: Exception);
var
  NomeArquivo: string;
  Lista: TStringList;
begin
  NomeArquivo := PATH_LOG + FormatDateTime('yyyymmdd', Now) + '.txt';

  Lista := TStringList.Create;
  try
    if FileExists(NomeArquivo) then
      Lista.LoadFromFile(NomeArquivo);

    Lista.Add('Data: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    if Screen.ActiveForm <> nil then
      Lista.Add('Form: ' + Screen.ActiveForm.Name)
    else
      Lista.Add('Form: N/A');

    Lista.Add('Erro: ' + E.Message);
    Lista.Add('Usuário: ' + GetUsuarioWindows);
    Lista.Add('PC: ' + GetNomeComputador);
    Lista.Add('-------------------------------');

    Lista.SaveToFile(NomeArquivo);
  finally
    Lista.Free;
  end;
end;

procedure TFrmPrincipal.ApplicationException(Sender: TObject; E: Exception);
begin
  SalvarLogErro(E);
  MsgSistema(tmErro, 'Erro no sistema:' + sLineBreak + E.Message);
end;

{ ===================================================== }
{ BOTÕES }
{ ===================================================== }
procedure TFrmPrincipal.bntIntegracoesVindiClick(Sender: TObject);
begin
  inherited;
  ExibeForm(TFrmIntegracao, FrmIntegracao);
end;

procedure TFrmPrincipal.bntNotasFiscaisClick(Sender: TObject);
begin
  inherited;
  ExibeForm(TFrmNotasFiscais, FrmNotasFiscais);
end;

{ ===================================================== }
{ FECHAR }
{ ===================================================== }
procedure TFrmPrincipal.Fncionarios1Click(Sender: TObject);
begin
  inherited;
  ExibeForm(TFrmIntegracao, FrmIntegracao);
end;

procedure TFrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  FrmMsg: TFrmMensagem;
begin
  FrmMsg := TFrmMensagem.Create(Self);
  try
    CanClose := FrmMsg.Confirmar('Confirmação', 'Deseja realmente sair do sistema?');

    if CanClose then
    begin
      if GetBackupAutomatico then
      begin
        RealizarBackup;
        LimparBackupsAntigos;
      end;
    end;
  finally
    FrmMsg.Free;
  end;
end;

{ ===================================================== }
{ FORM CREATE }
{ ===================================================== }
procedure TFrmPrincipal.FormCreate(Sender: TObject);
var
  FrmMsg: TFrmMensagem;
begin
  inherited;

  if JaEstaExecutando then
    Halt;

  // CRIA PASTAS AO INICIAR
  CriarEstruturaPastas;
  CriarAtalhoDesktop;

  FrmMsg := TFrmMensagem.Create(nil);
  try
    FrmMsg.IniciarCarregamento('Sistema', 'Inicializando...');
    Sleep(400);

    Application.OnException := ApplicationException;

    FrmMsg.AtualizarCarregamento('Conectando ao banco...', 30);
    Sleep(500);

    BD.Conexao.Connected := False;
    BD.Conexao.LoginPrompt := False;
    BD.Conexao.Connected := True;

    FrmMsg.AtualizarCarregamento('Carregando módulos...', 70);
    Sleep(500);

    bntIntegracoesVindi.Enabled := True;

    FrmMsg.AtualizarCarregamento('Aguarde...', 100);
    Sleep(500);

    FrmMsg.FinalizarCarregamento;
  except
    on E: Exception do
    begin
      FrmMsg.Free;
      MsgSistema(tmErro,
        'Não foi possível conectar ao banco de dados.' + sLineBreak +
        'Consulte o administrador.');
      Halt;
    end;
  end;

  FrmMsg.Free;
end;

{ ===================================================== }
{ BACKUP }
{ ===================================================== }
procedure TFrmPrincipal.RealizarBackup;
var
  Origem, Destino: string;
begin
  try
    Origem := 'D:\Delphi\Projetos\SCAIntegracoes\Data\dados-integracoes.mdb';

    if not FileExists(Origem) then
    begin
      MsgSistema(tmErro, 'Banco não encontrado: ' + Origem);
      Exit;
    end;

    Destino := PATH_BACKUP + 'backup_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.mdb';

    if not CopyFile(PChar(Origem), PChar(Destino), False) then
      MsgSistema(tmErro, 'Erro ao gerar backup!');
  except
    on E: Exception do
      SalvarLogErro(E);
  end;
end;

procedure TFrmPrincipal.SetBackupAutomatico(Value: Boolean);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SCAIntegracoes', True) then
      Reg.WriteBool('BackupAuto', Value);
  finally
    Reg.Free;
  end;
end;

function TFrmPrincipal.GetBackupAutomatico: Boolean;
var
  Reg: TRegistry;
begin
  Result := True;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SCAIntegracoes', False) then
      if Reg.ValueExists('BackupAuto') then
        Result := Reg.ReadBool('BackupAuto');
  finally
    Reg.Free;
  end;
end;

procedure TFrmPrincipal.LimparBackupsAntigos;
var
  Arquivos: TStringDynArray;
  Lista: TStringList;
  i: Integer;
begin
  Arquivos := TDirectory.GetFiles(PATH_BACKUP, '*.mdb');

  Lista := TStringList.Create;
  try
    for i := 0 to Length(Arquivos) - 1 do
      Lista.Add(Arquivos[i]);

    Lista.Sort;

    while Lista.Count > 10 do
    begin
      DeleteFile(Lista[0]);
      Lista.Delete(0);
    end;
  finally
    Lista.Free;
  end;
end;

{ ===================================================== }
{ INSTÂNCIA ÚNICA }
{ ===================================================== }
procedure TFrmPrincipal.AtivarJanelaExistente;
var
  hWnd: THandle;
begin
  hWnd := FindWindow(nil, PChar(Application.Title));
  if hWnd = 0 then
    Exit;

  // Restaura se estiver minimizado
  if IsIconic(hWnd) then
    ShowWindow(hWnd, SW_RESTORE)
  else
    ShowWindow(hWnd, SW_SHOW);

  // Truque pra forçar foco no Windows
  SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);

  SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);

  SetForegroundWindow(hWnd);
  BringWindowToTop(hWnd);
end;

function TFrmPrincipal.JaEstaExecutando: Boolean;
var
  MutexHandle: THandle;
begin
  MutexHandle := CreateMutex(nil, True, 'SCA_INTEGRACOES_MUTEX');

  Result := (GetLastError = ERROR_ALREADY_EXISTS);

  if Result then
    AtivarJanelaExistente;

  // NÃO fecha o handle se for a primeira instância
  if Result and (MutexHandle <> 0) then
    CloseHandle(MutexHandle);
end;

end.
