object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 525
  ClientWidth = 1174
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 960
    Height = 540
    FilterGraph = FilterGraph
    VMROptions.Mode = vmrWindowed
    Color = clBlack
  end
  object pnlControl: TPanel
    Left = 960
    Top = 0
    Width = 214
    Height = 525
    Align = alRight
    TabOrder = 1
    object labPan: TLabel
      Left = 162
      Top = 164
      Width = 32
      Height = 13
      Caption = 'labPan'
    end
    object labTilt: TLabel
      Left = 162
      Top = 220
      Width = 28
      Height = 13
      Caption = 'labTilt'
    end
    object labZoom: TLabel
      Left = 162
      Top = 276
      Width = 40
      Height = 13
      Caption = 'labZoom'
    end
    object Label1: TLabel
      Left = 10
      Top = 164
      Width = 6
      Height = 13
      Caption = 'P'
    end
    object Label2: TLabel
      Left = 11
      Top = 220
      Width = 6
      Height = 13
      Caption = 'T'
    end
    object Label3: TLabel
      Left = 13
      Top = 276
      Width = 6
      Height = 13
      Caption = 'Z'
    end
    object cbbDevices: TComboBox
      Left = 8
      Top = 8
      Width = 116
      Height = 21
      TabOrder = 0
      Text = 'Select a device'
      OnChange = cbbDevicesChange
    end
    object btnStop: TButton
      Left = 6
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object sbPan: TScrollBar
      Left = 25
      Top = 160
      Width = 121
      Height = 17
      PageSize = 0
      TabOrder = 2
      OnChange = sbPanChange
    end
    object sbTilt: TScrollBar
      Left = 25
      Top = 216
      Width = 121
      Height = 17
      PageSize = 0
      TabOrder = 3
      OnChange = sbTiltChange
    end
    object sbZoom: TScrollBar
      Left = 25
      Top = 272
      Width = 121
      Height = 17
      PageSize = 0
      TabOrder = 4
      OnChange = sbZoomChange
    end
    object btnStreamFormat: TButton
      Left = 120
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Stream Format'
      TabOrder = 5
      OnClick = btnStreamFormatClick
    end
    object btnPlay: TButton
      Left = 6
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Play'
      TabOrder = 6
      OnClick = btnPlayClick
    end
    object btnSetProperty: TButton
      Left = 120
      Top = 96
      Width = 75
      Height = 25
      Caption = 'SetProperty'
      TabOrder = 7
      OnClick = btnSetPropertyClick
    end
    object Memo1: TMemo
      Left = 6
      Top = 344
      Width = 203
      Height = 181
      Lines.Strings = (
        'Memo1')
      TabOrder = 8
    end
  end
  object Filter: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph
    Left = 400
    Top = 360
  end
  object FilterGraph: TFilterGraph
    GraphEdit = False
    LinearVolume = True
    Left = 392
    Top = 448
  end
  object SampleGrabber: TSampleGrabber
    FilterGraph = FilterGraph
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 512
    Top = 488
  end
end
