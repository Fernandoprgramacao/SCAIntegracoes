unit uBD;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TBD = class(TDataModule)
    Conexao: TADOConnection;
    Consulta: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BD: TBD;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
