object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'ReverseStringAction'
      PathInfo = '/ReverseString'
      Producer = ReverseString
    end
    item
      Name = 'ServerFunctionInvokerAction'
      PathInfo = '/ServerFunctionInvoker'
      Producer = ServerFunctionInvoker
    end
    item
      Default = True
      Name = 'DefaultAction'
      PathInfo = '/'
      OnAction = WebModuleDefaultAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 359
  Width = 617
  object DSServer1: TDSServer
    Left = 96
    Top = 11
  end
  object scAtendente: TDSServerClass
    OnGetClass = scAtendenteGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 11
  end
  object ServerFunctionInvoker: TPageProducer
    HTMLFile = 'Templates\ServerFunctionInvoker.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 56
    Top = 184
  end
  object ReverseString: TPageProducer
    HTMLFile = 'templates\ReverseString.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 184
    Top = 184
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end
      item
        MimeType = 'text/html'
        Extensions = 'htm;html'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpg;jpeg;jpe'
      end
      item
        MimeType = 'image/gif'
        Extensions = 'gif'
      end>
    BeforeDispatch = WebFileDispatcher1BeforeDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    VirtualPath = '/'
    Left = 56
    Top = 136
  end
  object DSProxyGenerator1: TDSProxyGenerator
    ExcludeClasses = 'DSMetadata'
    MetaDataProvider = DSServerMetaDataProvider1
    Writer = 'Java Script REST'
    Left = 48
    Top = 248
  end
  object DSServerMetaDataProvider1: TDSServerMetaDataProvider
    Server = DSServer1
    Left = 184
    Top = 248
  end
  object scSenha: TDSServerClass
    OnGetClass = scSenhaGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 59
  end
  object scFila: TDSServerClass
    OnGetClass = scFilaGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 107
  end
  object scMotivoPausa: TDSServerClass
    OnGetClass = scMotivoPausaGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 163
  end
  object scPA: TDSServerClass
    OnGetClass = scPAGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 203
  end
  object scOpiniometro: TDSServerClass
    OnGetClass = scOpiniometroGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 11
  end
  object scIndicador: TDSServerClass
    OnGetClass = scIndicadorGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 56
  end
  object scTGSMobile: TDSServerClass
    OnGetClass = scTGSMobileGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 104
  end
  object scConfig: TDSServerClass
    OnGetClass = scConfigGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 152
  end
  object scTotem: TDSServerClass
    OnGetClass = scTotemGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 208
  end
  object scDispositivo: TDSServerClass
    OnGetClass = scDispositivoGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 328
    Top = 256
  end
  object DSRESTWebDispatcher1: TDSRESTWebDispatcher
    DSContext = 'aspect/'
    Server = DSServer1
    SessionLifetime = Request
    OnFormatResult = DSHTTPWebDispatcher1FormatResult
    Left = 200
    Top = 72
  end
  object scModulosSICS: TDSServerClass
    OnGetClass = scModulosSICSGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 440
    Top = 264
  end
  object scUnidade: TDSServerClass
    OnGetClass = scUnidadeGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 520
    Top = 11
  end
  object scAA: TDSServerClass
    OnGetClass = scAAGetClass
    Server = DSServer1
    LifeCycle = 'Invocation'
    Left = 528
    Top = 208
  end
end
