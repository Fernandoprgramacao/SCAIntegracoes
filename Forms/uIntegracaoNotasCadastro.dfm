object FrmIntegracaoNotasCadastro: TFrmIntegracaoNotasCadastro
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Notas Cadastro'
  ClientHeight = 493
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Pagina: TPageControl
    Left = 18
    Top = 40
    Width = 906
    Height = 377
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Dados Cadastrais'
      object lbCodigo: TLabel
        Left = 62
        Top = 32
        Width = 43
        Height = 16
        Alignment = taCenter
        Caption = 'C'#243'digo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbNome: TLabel
        Left = 12
        Top = 73
        Width = 93
        Height = 16
        Caption = 'Nome Fantasia'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbDocumento: TLabel
        Left = 80
        Top = 165
        Width = 24
        Height = 16
        Alignment = taRightJustify
        Caption = 'Doc'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTipoCadastro: TLabel
        Left = 79
        Top = 119
        Width = 26
        Height = 16
        Alignment = taCenter
        Caption = 'Tipo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbSituacao: TLabel
        Left = 371
        Top = 32
        Width = 56
        Height = 16
        Alignment = taCenter
        Caption = 'Situa'#231#227'o'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTarefa: TLabel
        Left = 609
        Top = 190
        Width = 42
        Height = 16
        Alignment = taCenter
        Caption = 'Tarefa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbObservacao: TLabel
        Left = 28
        Top = 218
        Width = 77
        Height = 16
        Alignment = taCenter
        Caption = 'Observa'#231#227'o'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbtecnico: TLabel
        Left = 603
        Top = 97
        Width = 48
        Height = 16
        Alignment = taCenter
        Caption = 'T'#233'cnico'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbCodigoCliente: TLabel
        Left = 560
        Top = 143
        Width = 91
        Height = 16
        Alignment = taCenter
        Caption = 'C'#243'digo Cliente'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbResponsavel: TLabel
        Left = 569
        Top = 33
        Width = 82
        Height = 16
        Alignment = taCenter
        Caption = 'Respons'#225'vel'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbEmitida: TLabel
        Left = 373
        Top = 73
        Width = 120
        Height = 16
        Alignment = taCenter
        Caption = 'Nota teste emitida'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbDtCadastro: TLabel
        Left = 298
        Top = 119
        Width = 113
        Height = 16
        Caption = 'Data do cadastro'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbDtAtivacao: TLabel
        Left = 300
        Top = 165
        Width = 111
        Height = 16
        Caption = 'Data da ativa'#231#227'o'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edCodigo: TEdit
        Left = 109
        Top = 30
        Width = 80
        Height = 23
        Enabled = False
        TabOrder = 0
      end
      object edNome: TEdit
        Left = 109
        Top = 71
        Width = 244
        Height = 23
        CharCase = ecUpperCase
        MaxLength = 100
        TabOrder = 1
        OnKeyPress = edNomeKeyPress
      end
      object cbTipoCadastro: TComboBox
        Left = 109
        Top = 117
        Width = 124
        Height = 23
        Cursor = crHandPoint
        BevelInner = bvNone
        BevelOuter = bvNone
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 5
        Text = 'Pessoa Jur'#237'dica'
        OnChange = cbTipoCadastroChange
        Items.Strings = (
          'Pessoa F'#237'sica'
          'Pessoa Jur'#237'dica')
      end
      object edDocumento: TEdit
        Left = 109
        Top = 163
        Width = 140
        Height = 23
        MaxLength = 18
        TabOrder = 6
        OnExit = edDocumentoExit
        OnKeyPress = edDocumentoKeyPress
      end
      object cbSituacao: TComboBox
        Left = 432
        Top = 30
        Width = 124
        Height = 23
        Cursor = crHandPoint
        BevelInner = bvNone
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'PENDENTE'
        Items.Strings = (
          'PENDENTE'
          'EM ANDAMENTO'
          'AGUARDANDO'
          'FINALIZADO')
      end
      object edCodTarefa: TEdit
        Left = 657
        Top = 187
        Width = 124
        Height = 23
        MaxLength = 6
        TabOrder = 9
        OnKeyPress = edCodTarefaKeyPress
      end
      object btAbrirTarefa: TButton
        Left = 790
        Top = 185
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Caption = 'Abrir'
        TabOrder = 11
        OnClick = btAbrirTarefaClick
      end
      object Observacao: TMemo
        Left = 109
        Top = 216
        Width = 756
        Height = 113
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        MaxLength = 1000
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 12
      end
      object cbColaborador: TComboBox
        Left = 657
        Top = 93
        Width = 138
        Height = 23
        Cursor = crHandPoint
        BevelInner = bvNone
        Style = csDropDownList
        TabOrder = 7
      end
      object edCodCliente: TEdit
        Left = 657
        Top = 139
        Width = 124
        Height = 23
        MaxLength = 6
        TabOrder = 8
      end
      object btAbrirCliente: TButton
        Left = 790
        Top = 138
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Caption = 'Abrir'
        TabOrder = 10
        OnClick = btAbrirClienteClick
      end
      object cbResponsavel: TComboBox
        Left = 657
        Top = 30
        Width = 138
        Height = 23
        Cursor = crHandPoint
        BevelInner = bvNone
        Style = csDropDownList
        TabOrder = 3
      end
      object cbEmitida: TComboBox
        Left = 499
        Top = 71
        Width = 68
        Height = 23
        Cursor = crHandPoint
        BevelInner = bvNone
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'N'#194'O'
        Items.Strings = (
          'N'#194'O'
          'SIM')
      end
      object edDtAtivacao: TEdit
        Left = 416
        Top = 163
        Width = 121
        Height = 23
        ReadOnly = True
        TabOrder = 13
      end
      object edDtCadastro: TEdit
        Left = 416
        Top = 117
        Width = 121
        Height = 23
        ReadOnly = True
        TabOrder = 14
      end
    end
  end
  object btCancelarC: TButton
    Left = 154
    Top = 440
    Width = 120
    Height = 32
    Cursor = crHandPoint
    Caption = 'Cancelar'
    DragCursor = crHandPoint
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btCancelarCClick
  end
  object btCadastrarC: TButton
    Left = 18
    Top = 440
    Width = 120
    Height = 32
    Cursor = crHandPoint
    Caption = 'Cadastrar'
    DragCursor = crHandPoint
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btCadastrarCClick
  end
  object btAlterarC: TButton
    Left = 18
    Top = 440
    Width = 120
    Height = 32
    Cursor = crHandPoint
    Caption = 'Alterar'
    DragCursor = crHandPoint
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
    OnClick = btAlterarCClick
  end
  object qrConsulta: TADOQuery
    Connection = BD.Conexao
    Parameters = <>
    Left = 686
    Top = 330
  end
  object cmdComando: TADOCommand
    Connection = BD.Conexao
    Parameters = <>
    Left = 782
    Top = 338
  end
end
