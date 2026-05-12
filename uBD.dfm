object BD: TBD
  Height = 480
  Width = 640
  object Conexao: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Delphi\Projetos\' +
      'SCAIntegracoes\Data\dados-integracoes.mdb;Persist Security Info=' +
      'False;Jet OLEDB:Database Password=terra'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 56
    Top = 48
  end
end
