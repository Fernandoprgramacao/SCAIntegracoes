object BD: TBD
  Height = 480
  Width = 640
  object Conexao: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\Delphi\Projetos\' +
      'SCAIntegracoes\dados-integracoes.mdb;Mode=ReadWrite|Share Deny N' +
      'one;Persist Security Info=False;Jet OLEDB:Database Password=terr' +
      'adados'
    LoginPrompt = False
    Mode = Data.Win.ADODB
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 32
  end
  object Consulta: TADOQuery
    Connection = Conexao
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '    Clientes.id,'
      '    Clientes.clienteDescricao,'
      '    Clientes.clienteDocumento,'
      '    Clientes.clienteOperadora,'
      '    Clientes.clienteSituacao,'
      '    Clientes.clienteExcluido,'
      '    Clientes.clienteObs,'
      '    Clientes.clienteTarefa,'
      '    Clientes.colabID,'
      '    Clientes.clienteDtCadastro,'
      '    Clientes.clienteDtCadastroGeral'
      'FROM'
      '    Clientes;')
    Left = 144
    Top = 40
  end
end
