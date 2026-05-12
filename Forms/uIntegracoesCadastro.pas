unit uIntegracoesCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Tabs, Vcl.StdCtrls, Vcl.ComCtrls, uModelo, uGlobal;

type
  TFrmClientesCadastro = class(TModelo)
    Pagina: TPageControl;
    TabSheet1: TTabSheet;
    lbCodigo: TLabel;
    edCodigo: TEdit;
    lbDescricao: TLabel;
    edDescricao: TEdit;
    cbOperadora: TComboBox;
    lbOperadora: TLabel;
    lbDocumentoCPF: TLabel;
    cbTipoCadastro: TComboBox;
    edCPF: TEdit;
    edCNPJ: TEdit;
    lbTipoCadastro: TLabel;
    lbDocumentoCNPJ: TLabel;
    lbSituacao: TLabel;
    cbSituacao: TComboBox;
    lbTarefa: TLabel;
    ma: TEdit;
    btAbrirTarefa: TButton;
    lbObservacao: TLabel;
    btCadastrarC: TButton;
    btAlterarC: TButton;
    btCancelarC: TButton;
    Observacao: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmClientesCadastro: TFrmClientesCadastro;

implementation

uses
  uClientes;

{$R *.dfm}

procedure TFrmClientesCadastro.FormCreate(Sender: TObject);
begin
  inherited;
  SetTitulo('Cadastro de Clientes');


end;

procedure TFrmClientesCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // recria clientes quando cadastro fechar
  Application.CreateForm(TFrmClientes, FrmClientes);
  FrmClientes.Show;

  Action := caFree;
end;


end.
