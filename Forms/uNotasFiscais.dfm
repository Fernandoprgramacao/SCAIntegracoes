object FrmNotasFiscais: TFrmNotasFiscais
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Notas Fiscais'
  ClientHeight = 630
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnTopoFiltro: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 30
    Width = 782
    Height = 83
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    TabOrder = 0
    object lbSituacao: TLabel
      Left = 10
      Top = 9
      Width = 56
      Height = 16
      Caption = 'Situa'#231#227'o'
      Color = 15987438
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lbTecnico: TLabel
      Left = 196
      Top = 9
      Width = 48
      Height = 16
      Caption = 'T'#233'cnico'
      Color = 15987694
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lbPesquisar: TLabel
      Left = 384
      Top = 9
      Width = 63
      Height = 16
      Caption = 'Pesquisar'
      Color = 15987694
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object cbSituação: TComboBox
      Left = 10
      Top = 31
      Width = 160
      Height = 23
      Cursor = crHandPoint
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'TODOS'
      OnChange = cbSituaçãoChange
      Items.Strings = (
        'TODOS'
        '')
    end
    object cbTecnico: TComboBox
      Left = 196
      Top = 30
      Width = 160
      Height = 23
      Cursor = crHandPoint
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'TODOS'
      OnChange = cbTecnicoChange
      Items.Strings = (
        'TODOS')
    end
    object edPesquisar: TEdit
      Left = 384
      Top = 30
      Width = 172
      Height = 23
      Cursor = crIBeam
      MaxLength = 100
      TabOrder = 2
      OnChange = edPesquisarChange
    end
  end
  object pnFiltro: TPanel
    Left = 788
    Top = 30
    Width = 228
    Height = 593
    Align = alCustom
    BevelOuter = bvNone
    Color = 15987438
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object lbPeriodo: TLabel
      Left = 18
      Top = 122
      Width = 49
      Height = 16
      Caption = 'Periodo'
      Color = 15987694
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lbResponsavel: TLabel
      Left = 18
      Top = 11
      Width = 82
      Height = 16
      Caption = 'Respons'#225'vel'
      Color = 15987694
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lbEmitida: TLabel
      Left = 18
      Top = 68
      Width = 120
      Height = 16
      Caption = 'Nota Teste Emitida'
      Color = 15987694
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object gbResumo: TGroupBox
      Left = 18
      Top = 271
      Width = 165
      Height = 242
      Caption = 'Resumo'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      Padding.Left = 2
      Padding.Top = 2
      Padding.Right = 2
      Padding.Bottom = 2
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object lbPendente: TLabel
        Left = 11
        Top = 25
        Width = 58
        Height = 14
        Caption = 'Pendente:'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbEmAndamento: TLabel
        Left = 11
        Top = 66
        Width = 87
        Height = 14
        Caption = 'Em andamento:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lbFinalizado: TLabel
        Left = 11
        Top = 88
        Width = 54
        Height = 14
        Caption = 'Finalizado:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lbTotalPendente: TLabel
        Left = 140
        Top = 24
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lbTotalAndamento: TLabel
        Left = 140
        Top = 66
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lbTotalFinalizado: TLabel
        Left = 140
        Top = 88
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lbTotalGeral: TLabel
        Left = 139
        Top = 210
        Width = 8
        Height = 16
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTotal: TLabel
        Left = 11
        Top = 210
        Width = 37
        Height = 16
        Caption = 'Total:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbJaEmitidas: TLabel
        Left = 11
        Top = 120
        Width = 51
        Height = 14
        Caption = 'Emitidas'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lbEmitidas: TLabel
        Left = 11
        Top = 145
        Width = 52
        Height = 14
        Caption = 'Emitidas: '
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbTotalEmitidas: TLabel
        Left = 140
        Top = 138
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbNaoEmitidas: TLabel
        Left = 11
        Top = 168
        Width = 73
        Height = 14
        Caption = 'N'#227'o Emitidas:'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbTotalNaoEmitidas: TLabel
        Left = 140
        Top = 163
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbAguardando: TLabel
        Left = 11
        Top = 44
        Width = 70
        Height = 14
        Caption = 'Aguardando:'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbTotalAguardando: TLabel
        Left = 140
        Top = 44
        Width = 7
        Height = 14
        Alignment = taRightJustify
        Caption = '0'
        Color = 15987694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object pnSeparador: TPanel
        Left = 6
        Top = 106
        Width = 155
        Height = 8
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '- - - - - - - - - - - - - - - - - - - -'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 5
        Top = 188
        Width = 155
        Height = 8
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = '- - - - - - - - - - - - - - - - - - - -'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object cbResponsavel: TComboBox
      Left = 18
      Top = 33
      Width = 165
      Height = 22
      Cursor = crHandPoint
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'TODOS'
      OnChange = cbResponsavelChange
      Items.Strings = (
        'TODOS')
    end
    object cbEmitida: TComboBox
      Left = 18
      Top = 88
      Width = 165
      Height = 22
      Cursor = crHandPoint
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'SELECIONE'
      OnChange = cbEmitidaChange
      Items.Strings = (
        'SELECIONE'
        'N'#194'O'
        'SIM')
    end
    object pcPeriodo: TPageControl
      Left = 16
      Top = 140
      Width = 180
      Height = 125
      ActivePage = TabSheet1
      TabOrder = 3
      OnChange = pcPeriodoChange
      object TabSheet1: TTabSheet
        Caption = 'DtCadastro'
      end
      object TabSheet2: TTabSheet
        Caption = 'DtAtiva'#231#227'o'
        ImageIndex = 1
      end
    end
    object pnFiltroTopo: TPanel
      Left = 20
      Top = 165
      Width = 173
      Height = 96
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 4
      object cbPeriodo: TComboBox
        Left = 2
        Top = 4
        Width = 166
        Height = 22
        Cursor = crHandPoint
        Style = csDropDownList
        ItemIndex = 4
        TabOrder = 0
        Text = 'ESTE M'#202'S'
        OnChange = cbPeriodoChange
        Items.Strings = (
          'HOJE'
          'ONTEM'
          #218'LTIMOS 7 DIAS'
          #218'LTIMOS 15 DIAS'
          'ESTE M'#202'S'
          'M'#202'S PASSADO'
          'PER'#205'ODO')
      end
      object dtDataInicio: TDateTimePicker
        Left = 4
        Top = 36
        Width = 165
        Height = 22
        Cursor = crHandPoint
        Date = 46083.000000000000000000
        Time = 46083.000000000000000000
        MaxDate = 73415.999988425930000000
        MinDate = 36526.000000000000000000
        TabOrder = 1
        OnChange = dtDataInicioChange
      end
      object dtDataFim: TDateTimePicker
        Left = 4
        Top = 69
        Width = 165
        Height = 22
        Cursor = crHandPoint
        Date = 46112.000000000000000000
        Time = 46112.000000000000000000
        MaxDate = 73415.999988425930000000
        MinDate = 36526.000000000000000000
        TabOrder = 2
        OnChange = dtDataFimChange
      end
    end
  end
  object pnRodape: TPanel
    Left = 3
    Top = 544
    Width = 783
    Height = 79
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 15986925
    ParentBackground = False
    TabOrder = 3
    object bntAlterar: TButton
      Left = 160
      Top = 25
      Width = 100
      Height = 32
      Cursor = crHandPoint
      Caption = 'Alterar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = bntAlterarClick
    end
    object bntFechar: TButton
      Left = 282
      Top = 25
      Width = 100
      Height = 32
      Cursor = crHandPoint
      Caption = 'Fechar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = bntFecharClick
    end
    object bntCadastrar: TButton
      Left = 32
      Top = 25
      Width = 100
      Height = 32
      Cursor = crHandPoint
      Caption = 'Cadastrar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = bntCadastrarClick
    end
  end
  object pnSemRegistro: TPanel
    Left = 4
    Top = 112
    Width = 782
    Height = 433
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object imgSemRegistro: TImage
      Left = 353
      Top = 159
      Width = 58
      Height = 44
      Center = True
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000960000
        009608060000003C0171E20000000473424954080808087C0864880000000970
        48597300002E2300002E230178A53F760000001974455874536F667477617265
        007777772E696E6B73636170652E6F72679BEE3C1A000013744944415478DAED
        9D0B7C15D59DC7FF33934B5E37094F79070495874504454044A80BE2AE62C596
        A5DA36E44153573ED46EFB295A8ADB74B7AD0BAB7EDAC50FBA360F8245442A56
        AD8B50442582621179682094474449208040724348EE9D39FB3F9364CB23B973
        E675CFCCBDE7FBF9CC67267066E67F667EF77FFEE7391208042E20F13640109F
        0861095C41084BE00A4258025710C212B8821096C01584B004AE208425700521
        2C812B0861095C41084BE00A712FACBCBCBC81B81B4208C9C47DBA2CCB99F418
        3745922415B77A4DD3EAF1FF1AE931EE0F9795957DC1DB6EBF1337C2CACDCD4D
        C1DD0414CE64DC8F44E15C87FB61B8A55BB85C08B70328B403B8AFC46B6D0906
        831F2E5BB6AC99773EFD82AF85959F9F7F33BEF4197878076E13714B75F1764D
        28B46DE8DD36E33D379497977FCC3BFF5EC677C2CAC9C9E98F5EE95BF892F3F0
        CFD11C4DD98F36ACC1FDCAD2D2D2C3BC9F8BD7F085B08A8A8AE4A3478F7E033D
        C502FC730A6E326F9B2E42C3ED5DB46DD98A152B5EC363C2DB202FE069615141
        555757DF8D9EA108FF1CCBDB1E063E435B97666767BF88B647781BC313AF0A4B
        C260FCBBF8927E81C743791B6381BFA1072B420FB61A12D483794E5818900FC3
        97F20C1E4EE36D8B5D686D525194F92525259FF2B625D6784658858585699148
        6421BE8C9FE19F5D78DBE320B4485C8EDE773106F90DBC8D89159E10564141C1
        2D588DA735ACC1AEDF4C4E0229A90B90401A48E1F340222D187EC7241C3A8CE2
        9A83E2DA118B9BF186B7B0682CF5431AF082935E2A2513A49E189A057B8394D9
        BB759FDE0320908AC252AE4C4F8515BE0070FE3490861340EA4F0084707FEA10
        C0857A27F31B418FBC18632F9ADFB88EBDB8090BBD5477F452657878AFED8B29
        01907A8F04E83D1CE4ABAE03C8E8E39CA10DC781D41DC06D3F90E395006AD889
        ABBE8A02CB47819D75CE506FC1455818A0F7C307FB161E8EB2657CB76C90068D
        07297B1CFA3B2B3D372641AF466A7603F9FC232027AB68746EE76AFB5455BD6B
        E5CA9547DD373CF6C45C58F3E6CD1B810F74031E0EB466B1AC0B491E361D20B3
        6FACCDFF3BF5B5A0EDDF08E40B0C998866F52A35F803BB0B3DD75E7E19718798
        0AAB2D487F130F7B9A3E19632369F0449087DF0990D623966647A7F11490AA8D
        A01DF9C092C030BE3C833FB499E5E5E55B7967C5496226ACBCBCBC5B71F717DC
        D24C1BD9F31A90C6CC0129AB5F2C9F8D3930E8D776BD0CE4C47E2B6737A2E79A
        869EEB43DED9708A98086BEEDCB9D7CBB2BC050FBB9B3A313908F20DB3B0E81B
        4F7FDA3C9E8F3930E62247B783B67B1D404BA3D9B34F2B8A32B9B8B8781FEF6C
        3881EB6F0B63AA01E8EAA99BCF3675227A29797C1E48A95D793D1BEB343780B6
        7D855E9334C931FC014E2A2929F99C7716ECE2AAB0DA9A14A8A886B35B24817C
        CD549046CDEAB8CDC92F60BCA5ED5B0FA4723D986CB2FA0C8BC5DBFCDE14E1A6
        B0A4FCFCFC75F890EE633E41E902D2847C90FADA6A85F014E4D86E201FA1F752
        5BCC9CF6465959D937C0C78DA8AE092B3737F7C758E3798AF984402AC8931ED2
        03F578839C3E02DAD6674DC55DF883FC217AAD65BC6DB78A2BC242518D4351BD
        0FACDD342999204F5EE0ED5A9F4DC8B91AD02A9699E9220AA3B86EF76B4DD171
        6161F197810F640FB076280752409EF2AF20751DE05A0E8349005929320403A8
        744582808CE11BFEBB86054D584347A212088501CE5DD02044FBA35D2A80C8B9
        5A20EF3D0DA4E53CEB2987535353472F5FBE3CE48E45EEE186B09E4261FD98E9
        E634A69A3CDFF1E28F0AA85F860C7DD225E8952643928981CC1114DAC9260D6A
        43046A1B345D704EA2178BD473459827FC2CC578EB5167AD701F4785D5D65EF5
        091E06586E2D4FFA8163813AF540FD514C43BBCA70150ACAA98C9DB940E0D059
        0DAACF69A05AEEB9B91452B307B46DCF03A36B8CA8AA7AD3CA952BF73894A598
        E0A4B0A4BCBCBCCDB89FCA92581EF18F205D7F8FED9B526774753719AEEF2143
        6AC0BD4A6E331697FBBFD2E0C0694D2F42EDA27DFA3A90FD1B589357A0D7A293
        487C534B74EC4D60C0FE3D0CD8573225C6A24F99F288DEA16C87BEE9328CEDAB
        E8455FAC08B500EC3CA1625169D37DD176AE8A6780D455B12527E43B18C8BF18
        BB9CDAC31161CD9E3D5B090683B42BE25AC3C4C94150A62FC29A6096E5FB29A8
        C71B7A29706D7799DB80325A34EE3CAEEAC1BF5548D359D0FEF21BD6668843A1
        5068D8DAB56B554E59368523EF0503F6EFE02FEA0F2C69E57139FA182AAB6424
        03DC3E3060DA4BD132847A9BF361022D5896D1E20C2B88584394200D8BD06017
        F30F8306F65BBE0843838D89F7A4FA03D076303D3AEAB51E40AFF592F5BBC50E
        278445632B1A587ECD3061CFA17AD382D50EE5ABD224B86D800201C5F87C2AA4
        D34D046AB06677A291C0D966123536A2C17FD764097A63E04F6B943D52D92A00
        618CBDDEFF5285BAF316C31F82766DF91D90937F63495D3968D0A0514545450E
        5523DCC3B6B030B6BA1F63AB578CEF248332ED3180ACFE96EE435FF624149551
        54469B0B682DEEF01915EA4DF5A25C4A267AB021DD14BD9669D45C41DFF25614
        1715B125EA6B41DDF4045E88A994BB0F03F9D7ACE72C36D816167AAB7780A126
        280DB90DE4B10F58BA07F5229307264134474547095341559ED2A029E25CE529
        35498291BD64189A254775B4E8B8A0E268044E58F45C64E78BA01D361EEB873F
        E2B74B4B4B3D3FE7D296B0727272B215453902466B29506F35E3DF0082BD4CDF
        A35B8A04770C4A8AEA351AD0337D541B8153568B23067A62313CBE6F921E8B75
        06F5961B8E84F558CE348DA7407DEB972CA3506982C15E5FC3CB96B0D05BFD1C
        77BF32BC0906EB3468B7022DFE066474AEAA2FB1F8D95EA3EA2FD56DA8B8C7F7
        8B6E4FD5571AEC3A61ADE2A6D1511047FF6A980E83F8C730885FE27E8EAD6357
        58B48921FA582B2C3F94E93FB73CF1E1CEC149D02DB56333F79DD6606F9D1ADB
        56433465742F0586F7E8585CC750E83498B702ED4BD436FD9A65F64F257AACEB
        63996D0B8FC91A6D8B9E19FEBCF49AE054A6AEC30EB9B90F06D0DDAE7C895454
        7BEAF835E9E8E2EA79A55DB465FE131B7669EF3C05E4B4F1725BF8ECC7A0D7DA
        C5ED0118605958E8AD16E3EE3F0C6F30F64190874CB26C603246ECD3AE4EBAA4
        DDAAB2CD53F166148A6B44CFBF37D2AA6D3156838DDA2839FC3E683B571BA7F3
        78716847586F43EB128D9DA30440B9E789D6A9ED36A0435D06664A283280BA46
        02A79ABCD365466BAC833315086B048ED46B70C6A66D74488DF6E79F19AE2781
        C2DA88C29AC13BFF9D6149580B162C480E854267C060CD4FA9DF68906F2DE49D
        47DFA16D7D0E48ADE11CD6F3C160B0BB5717DCB5242C8CAFBE8EBF98CD86171F
        3307E4A1B7F3CEA3EF2007DF056DD75AC374B22C4F292929D9C2DBDE8EB02AAC
        C75158FF6E98F1198F83E4E4021D89026D89DF68D88A43598CB5C35FF336B723
        AC0A6B350AEBDB5113A564B6C65702F31002EA9B8B0CC7C7E33B588571D67779
        9BDB1196848581FB4EDC8D897AE10163409E308F77FE7C8BF6C1EF811C336C4D
        D8811E6B1C6F5B3BC28AB0E86806FA530A464BE4D408D14485718469030A8B0E
        6CF34E35B90DD3C26AFB368DE19A4EF22D7341CABE8577FE7C0BF9FC43D0FEFA
        82613A4992FA979696D6F0B6F70ABBCC9E50505070BBA669EF19A593EF580852
        F741BCF3E75BF4D93CEF3C69980E85351985F53E6F7BAFB0CBEC09B9B9B93331
        33AF1BA553EE5D1A9B55F6E21472A101B43F3F66984E96E57B4A4A4ADEE46DEF
        E55811D68328AC5546E994FB7FA7AF502CB0881A06F5D51F1926F3EA70652B31
        D60F70F75CD44428285D58025BA8EB1E61E9DA294461FD9EB7AD97635A58F9F9
        F93FC1CC442FFCB108D48B42812DD4D77F0A60301D1FDFC54F50584FF3B6F572
        AC782CE3510D69DD40F927A696634114D4FFC5477DFE8C51B2C7CBCACA3CF7B0
        85C7F23089E6B1448C1523122AC612B5C2189168B542E676AC994BF4E9F4028B
        343780FA4602B5638996F7D890702DEF6DCB6B1BCE69137D85F660ED2B0C0402
        FD9E7FFEF95ADEF65E8E18DDE051126E7403458CC7729F441C8FC53E82F4EEDF
        F8E353255E23514790B28E7957663CEEEC47291385441DF39E9B9B3B156B23EF
        185E5CCCD2B104EB2C9DB675E02B78DBDB11EECE2BEC3F1AE489625EA159B46D
        CF01A949C07985142C0E37E12FE61FA2267268267422C13A131AD980C5E05DBC
        EDED0C3B53EC999630926F7A10A4ABADAFDD9068904315A07DC2D443F3280ACB
        B33DFD96853577EEDC9B6459DE6178039BABCD241AEAE62701BE3A62980E63DC
        1B4B4B4B77F3B6B753FBEC9C8C5EEB53DC455FA7C9E6FA58898489F5B13E436F
        65B898304F6C090B6B878BF0976358DDB5B3A25F22C1BAA21F3EF385E8ADFE8B
        B7BD516DB473724E4E4E7F4551E86766A37F0A55925BD771085EC53BBFDEC5C4
        1AA4F8CC071517177FC9DBE46838B16AB2F13A59F44618C0D3405ED031DAC7AB
        801CD9C69274131683D379DB6B8413EBBCDF87AEF955E33BD95BE73D9ED13F92
        F9F67F32ADF34E08B977C58A156FF0B6D908A7BE4C416B2786DF87B3FB658AB8
        847E99E2DDA799D61D4576A3B7A29DFF9E1BCD70398EBC611416FD3200D397A9
        E471DFC3607E02EF7C7B0652BD0DB41D8623BD75B064988341FBCBBC6D66B2D5
        898BD0AF7F65646454A29BBECE3071977490A72F0229B52BEFBCF3A7E92CA8EC
        5FFF3A180A858627D4D7BF2866BE00463FD52B3BF0BD425F43BF57F8DE6F819C
        3AC496DCA393263AC3D160A7ED0BAB5F67BAF1F0BB40FEDA4CDEF9E786B6F735
        20551B99D2A2A8B6A0A8A6820F62AB769C16D648DCD1618F6CDF849EF87D7D04
        44A2416A7683B68D4E0564D2498BA22837161717EFE36DB7191CAF9EE5E6E62E
        C520F3A74C3757BA803C79BEFE29DF84E1D441502B9ED1E70D32F204D60417F1
        36DB2C8E0BEBE1871F0E363535D1E687214C27045231DEFA11485D07F07E16EE
        535FDBDAB460306DFE220E4622911B5F78E105A6E8DE4BB8D2A0D4F69D1D3AD7
        2D99E984944CF45C0B40CAEAC7FB79B886DE085AB1CC701CFB45D0017CB7A2B7
        DAC9DB762BB8D6528945E2235824FE96F904EAB9263DA4D718E30D7DF2E9D667
        599B155ACF21643E06ECCB79DB6E15379BC0698BFC1F717F3FF309187349E3F3
        40EA7703EFE7E2187AA0BEBDCC4C4CD5FA2C24E95F4A4B4B9F3375928770B56F
        05BD56577C40F47BB423D92DC2DAE23553411A350B4056984FF31CB49D6ADF7A
        2095EBC1622B01C167F7B05FC5E57AA75DDBD01A2A2E530B3948DD07A3F7CA07
        29BD07B7876399A6B3E8A54A991B3FA3E05B71C5A437183DD7B5F88068306F6E
        4016EDFEB961566BDFA21F3AAE090152FD01687BFF642A9E32BAAA1FC515B3B7
        85E29A800F68131E9A5FA3BB5B3628631FD0F75E859C3D0664D71A27BC548797
        F79BB862EA06505CE3F001D1B59CCC7FCE9E8E42BD7A2248C3EE4469F68CA5D9
        5121A19340F66FD457876118FD69EB567E1257CCCB9779F3E68D5055F52D3CB4
        E67E5060D2C09B75814959FC2668D0890FA46A03902F3E765B5097DCD62FE2E2
        12B8141616F66D6969790B1F92AD7605098B463A51830A2D26AB07869B80D4EC
        41EFF4119093552CB369DCC017E2E21611B7354594E2E12CDB17939340EA3D02
        A0F770907A0D73CE93D160BCFE38008A88D4ED07727C1FCB0C6516A88BB33366
        88842EB414AD5DBDCA7061165E70AF6AE5E7E7171242FE1B58BB7F5848CED087
        414B997D0082BD5A57BC49EB015297D48E17DC55C340C21700CE9F0668380EA4
        A10EF7275A03F1E60627B3DB8C797D545194839AA6BD6235CFC7CE8420D41C86
        BE59C125AFBCF407E3854A39C05D5894B6BEC535C0DA716D0759012929194852
        2A48112CDA22CD4C93181CE0206E73DAFBFE0A0A0AEEB6222E2AAA734D2DFAB1
        224B9E1597278445C1B82B2D12892C4481D187E49CF7E20FEDCB79168BFDC518
        175DE2FECC8AEB6251B5E35571794658EDE4E4E45C8745C53378E8F9B9730CBC
        87C2995F5E5EFE59670958C5D591A8DAF1A2B83C27AC76BB30B87F4096E55F30
        4DD0F01E55687711EB187523714513553B5E13975785A553545424575757DFDD
        26B09B78DBC3C05E2CF29E6C6868586576364D67E26211553B5E1297A78575B1
        9D797979F7E24B5B8002A39335BC34BD87361D6C46DB96610C4567285B6EDCBA
        5C5C6644D58E57C4E51761FD3F74B4047AB06FE18B9C0B064B82BB4C25DAB016
        6D292F2E2E365ED08A917671A1A892CD8AAA1D2AAE3E99E94BD7AD59F528AF87
        E33B615D0CC66137E26E066E77E04BBE0DF7692EDE8E0E57A02334A877DAE0E6
        A26733EEFBE725679B9A17DAB9061557EF8CB425AFBEFC2217CFE56B615DCCEC
        D9B3BB6466664EC05FFB64FC7324BEFC616D817F8685CBD166812ADC0EE03568
        8DAEA2B1B1713BC64DD65C8805A6CEFCE64B4D2D913976AEC1D373C58DB03A83
        169D814060281E66A0E88228B82C144B266E0A1EABB8D5E3F1392CD24298A601
        8F0FA237AAE16D37C5CFE28A7B61F91DBF8A4B08CB07F8515C42583EC16FE212
        C2F2117E12971096CFF08BB884B07C881FC42584E553BC2E2E212C1FE3657109
        61F91CAF8A4B082B0EF0A2B884B0E204AF894B082B8EF092B884B0E20CAF884B
        082B0EF182B884B0E214DEE212C28A63A6DC73FFBA0B61D5D61206ADE24A7D68
        DD9AD5FF63E63C21AC38C7AEE74A4F0ED4258793AF5DBF7E15F372CF1421AC04
        C0AAB8AC8A8A228495209815971D515184B012085671D9151545082BC1301257
        7A72128A2AC596A8284258094867E2724A541421AC04E5727139292A8A105602
        D32E2EA7454511C24A70A6CDFCE6AF029194A54E8A8A2284257005212C812B08
        61095C41084BE00A4258025710C212B8821096C01584B004AE2084257005212C
        812B0861095C41084BE00AFF07348E430F6466246B0000000049454E44AE4260
        82}
      Proportional = True
      Stretch = True
    end
    object lbSemRegistro: TLabel
      Left = 265
      Top = 213
      Width = 233
      Height = 19
      Caption = 'Nenhum registro encontrado'
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object DBGrid1: TDBGrid
    Left = 3
    Top = 110
    Width = 783
    Height = 435
    Cursor = crHandPoint
    Color = 15986925
    DataSource = dsNotasFiscais
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Pitch = fpFixed
    Font.Style = []
    Font.Quality = fqProof
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'notaID'
        Title.Alignment = taCenter
        Title.Caption = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'notaNomeFantasia'
        Title.Caption = 'Nome Fantasia'
        Width = 155
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'notaTipo'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'notaCPF'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'notaCNPJ'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'situacaoNotaNome'
        Title.Caption = 'Situa'#231#227'o'
        Width = 116
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'notaEmitida'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'notaObs'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'notaTarefa'
        Title.Caption = 'Tarefa'
        Width = 73
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'notaCliente'
        Title.Caption = 'C'#243'digo Cliente'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'colabID'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'notaDtCadastro'
        Title.Caption = 'DtCadastro'
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'notaDtAtivacao'
        Title.Caption = 'DtAtivacao'
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'colabNome'
        Title.Caption = 'T'#233'cnico'
        Width = 85
        Visible = True
      end>
  end
  object ADONotasFiscais: TADOCommand
    Connection = BD.Conexao
    Parameters = <>
    Left = 464
    Top = 184
  end
  object dsNotasFiscais: TDataSource
    DataSet = cdsNotasFiscais
    Left = 576
    Top = 192
  end
  object cdsNotasFiscais: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 680
    Top = 192
  end
end
