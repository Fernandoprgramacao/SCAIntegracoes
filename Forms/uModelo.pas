unit uModelo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, ADODB;

type
  TModelo = class(TForm)
    pnModeloTop: TPanel;
    pnModeloLeft: TPanel;
    pnModeloRight: TPanel;
    pnModeloButtom: TPanel;
    pnModeloCentro: TPanel;
    pnBordaDireita: TPanel;
    pnBordaRodape: TPanel;
    pnBordaTop: TPanel;
    pnModeloFechar: TPanel;
    pnModeloMinimizar: TPanel;
    lbTitulo: TLabel;
    pnBordaLeft: TPanel;
    lbTituloForm: TLabel;
    pnBordaDireita2: TPanel;
    procedure pnModeloFecharClick(Sender: TObject);
    procedure pnModeloMinimizarClick(Sender: TObject);
    procedure pnModeloFecharMouseLeave(Sender: TObject);
    procedure pnModeloFecharMouseEnter(Sender: TObject);
    procedure pnModeloTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FechaQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
   procedure SetTitulo(const ATitulo: string);
  end;

var
  Modelo: TModelo;

implementation
uses
  uBD;
{$R *.dfm}


procedure TModelo.SetTitulo(const ATitulo: string);
begin
  lbTitulo.Caption := ATitulo;
end;


procedure TModelo.FechaQuery;
var
  i: Integer;
  qry: TADOQuery;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if not (Components[i] is TADOQuery) then Continue;
    qry := TADOQuery(Components[i]);
    if qry.Active then
    begin
      qry.Connection := BD.Conexao;
      qry.Close;
    end;
  end;
end;

procedure TModelo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaQuery;
end;

procedure TModelo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then Exit;

  if Key = VK_ESCAPE then
    Close;
end;

procedure TModelo.pnModeloFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TModelo.pnModeloFecharMouseEnter(Sender: TObject);
begin
  pnModeloFechar.Color := $006C6CE3;
end;

procedure TModelo.pnModeloFecharMouseLeave(Sender: TObject);
begin
  pnModeloFechar.Color := $003333D8;
end;

procedure TModelo.pnModeloMinimizarClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TModelo.pnModeloTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const SC_DRAGMOVE = $F012;
begin
  if Button = mbleft then
  begin
    ReleaseCapture;
    Self.Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

end.
