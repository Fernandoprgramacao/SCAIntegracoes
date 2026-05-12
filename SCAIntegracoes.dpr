program SCAIntegracoes;

uses
  Vcl.Forms,
  System.SysUtils,
  uModelo in 'Forms\uModelo.pas' {Modelo},
  uGlobal in 'Forms\uGlobal.pas',
  uBD in 'uBD.pas' {BD: TDataModule},
  uPrincipal in 'Forms\uPrincipal.pas' {FrmPrincipal},
  uIntegracao in 'Forms\uIntegracao.pas' {FrmIntegracao},
  uIntegracaoCadastro in 'Forms\uIntegracaoCadastro.pas' {FrmIntegracaoCadastro},
  uMensagem in 'Forms\uMensagem.pas' {FrmMensagem},
  uNotasFiscais in 'Forms\uNotasFiscais.pas' {FrmNotasFiscais},
  uIntegracaoNotasCadastro in 'Forms\uIntegracaoNotasCadastro.pas' {FrmIntegracaoNotasCadastro};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  FormatSettings := TFormatSettings.Create('pt-BR');

  Application.CreateForm(TBD, BD);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
