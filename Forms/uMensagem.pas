unit uMensagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uModelo, Vcl.StdCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  Vcl.ComCtrls;

type
  TTipoMensagem = (tmErro, tmSucesso, tmAtencao);

  TFrmMensagem = class(TForm)
    lbTituloMensagem: TLabel;
    lbMensagem: TLabel;
    btOk: TButton;
    pnMensagemTop: TPanel;
    pnMensagemCentro: TPanel;
    pnMensagemRodape: TPanel;
    pnMensagemRight: TPanel;
    pnMensagemLeft: TPanel;
    pnMensagemTopFechar: TPanel;
    pnMensgemTopBorda: TPanel;
    imgIconeSucesso: TImage;
    imgIconeAtencao: TImage;
    imgIconeErro: TImage;
    btSim: TButton;
    btNao: TButton;
    pbProgresso: TProgressBar;
    procedure btOkClick(Sender: TObject);
    procedure pnMensagemTopFecharClick(Sender: TObject);
    procedure btSimClick(Sender: TObject);
    procedure btNaoClick(Sender: TObject);
  public
    procedure ExibirMensagem(Tipo: TTipoMensagem; Texto: string);
    function Confirmar(const ATitulo, AMensagem: string): Boolean;
    procedure IniciarCarregamento(const ATitulo, AMensagem: string);
    procedure AtualizarCarregamento(const AMensagem: string; Progresso: Integer);
    procedure FinalizarCarregamento;
  end;

var
  FrmMensagem: TFrmMensagem;

implementation

{$R *.dfm}

procedure TFrmMensagem.ExibirMensagem(Tipo: TTipoMensagem; Texto: string);
begin
  lbMensagem.Caption := Texto;

  btOk.Visible := True;
  btSim.Visible := False;
  btNao.Visible := False;

  case Tipo of
    tmSucesso:
      begin
        lbTituloMensagem.Caption := 'Sucesso';
        imgIconeSucesso.Visible := True;
        imgIconeAtencao.Visible := False;
        imgIconeErro.Visible := False;
      end;

    tmAtencao:
      begin
        lbTituloMensagem.Caption := 'Atenção';
        imgIconeSucesso.Visible := False;
        imgIconeAtencao.Visible := True;
        imgIconeErro.Visible := False;
      end;

    tmErro:
      begin
        lbTituloMensagem.Caption := 'Erro';
        imgIconeSucesso.Visible := False;
        imgIconeAtencao.Visible := False;
        imgIconeErro.Visible := True;
      end;
  end;

  ShowModal;
end;

procedure TFrmMensagem.IniciarCarregamento(const ATitulo, AMensagem: string);
begin
  lbTituloMensagem.Caption := ATitulo;
  lbMensagem.Caption := AMensagem;

  // Oculta botões
  btOk.Visible := False;
  btSim.Visible := False;
  btNao.Visible := False;
  pnMensagemTopFechar.Visible := False;

  // Oculta ícones
  imgIconeSucesso.Visible := False;
  imgIconeAtencao.Visible := False;
  imgIconeErro.Visible := False;

  // Mostra progresso
  pbProgresso.Visible := True;
  pbProgresso.Position := 0;

  Show;
  Update;
end;

procedure TFrmMensagem.AtualizarCarregamento(const AMensagem: string; Progresso: Integer);
begin
  lbMensagem.Caption := AMensagem;
  pbProgresso.Position := Progresso;

  Application.ProcessMessages;
end;

procedure TFrmMensagem.FinalizarCarregamento;
begin
  Close;
end;

function TFrmMensagem.Confirmar(const ATitulo, AMensagem: string): Boolean;
begin
  lbTituloMensagem.Caption := ATitulo;
  lbMensagem.Caption := AMensagem;

  imgIconeSucesso.Visible := False;
  imgIconeAtencao.Visible := True;
  imgIconeErro.Visible := False;

  btOk.Visible := False;
  btSim.Visible := True;
  btNao.Visible := True;

  Result := (ShowModal = mrYes);
end;

procedure TFrmMensagem.btOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmMensagem.btSimClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TFrmMensagem.btNaoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TFrmMensagem.pnMensagemTopFecharClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
