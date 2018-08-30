unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  DXSUtil, DSPack, DirectShow9, Vcl.ExtCtrls; // DSpack 相關所需

type
  TForm1 = class(TForm)
    VideoWindow: TVideoWindow;
    Filter: TFilter;
    FilterGraph: TFilterGraph;
    SampleGrabber: TSampleGrabber;
    pnlControl: TPanel;
    cbbDevices: TComboBox;
    btnStop: TButton;
    sbPan: TScrollBar;
    sbTilt: TScrollBar;
    sbZoom: TScrollBar;
    labPan: TLabel;
    labTilt: TLabel;
    labZoom: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnStreamFormat: TButton;
    btnPlay: TButton;
    btnSetProperty: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure cbbDevicesChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sbPanChange(Sender: TObject);
    procedure sbTiltChange(Sender: TObject);
    procedure sbZoomChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnStreamFormatClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnSetPropertyClick(Sender: TObject);
  private
    { Private declarations }
    VideoMediaTypes: TEnumMediaType;
    SysDev: TSysDevEnum;
    camControl: IAMCameraControl;
  public
    { Public declarations }
    procedure GetRangeOfPTZ();
    function SetVideoProperties(filter: IBaseFilter): Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnPlayClick(Sender: TObject);
var
  r: Boolean;
begin
  try
    with FilterGraph as ICaptureGraphBuilder2 do
      RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter as IBaseFilter,
        SampleGrabber as IBaseFilter, VideoWindow as IBaseFilter);

    r := FilterGraph.Play();
  except
    on E: EDirectShowException do
      Memo1.Lines.Add(E.ToString);
  end;
  Memo1.Lines.Add('Play:' + r.ToString());
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  FilterGraph.Stop();
end;

function TForm1.SetVideoProperties(filter: IBaseFilter): Boolean;
var
  hr: HRESULT;
  pCfg: IAMStreamConfig;
  pAM_Media: PAMMediaType;
  pvih: PVIDEOINFOHEADER;
  pICGP2: ICaptureGraphBuilder2;
  iCount, iSize, iFormat: Integer;
  scc: VIDEO_STREAM_CONFIG_CAPS;
  pBih: BITMAPINFOHEADER;
  pmtConfig: PAMMediaType;
  w, h: Integer;
begin

  pICGP2 := FilterGraph as ICaptureGraphBuilder2;
  hr := pICGP2.FindInterface(@PIN_CATEGORY_CAPTURE, @MEDIATYPE_Video, filter,
    IID_IAMStreamConfig, pCfg);

  hr := pCfg.GetNumberOfCapabilities(iCount, iSize);
  if (iSize = sizeof(VIDEO_STREAM_CONFIG_CAPS)) then
  begin
    for iFormat := 0 to iCount do
    begin
      hr := pCfg.GetStreamCaps(iFormat, pmtConfig, scc);
      if Succeeded(hr) then
      begin
        pvih := pmtConfig.pbFormat;
        pBih := pvih.bmiHeader;
        w := pBih.biWidth;
        h := pBih.biHeight;
        if (w = 1920) and (h = 1080) then
        begin
//          pvih.AvgTimePerFrame := 10000000 div 30;
          hr := pCfg.SetFormat(pmtConfig);
          FREEMEDIATYPE(pmtConfig);
          break;
        end;
        FREEMEDIATYPE(pmtConfig);
      end;

    end;

  end;

end;

procedure TForm1.btnStreamFormatClick(Sender: TObject);
var
  PinList: TPinList;
begin
  PinList := TPinList.Create(Filter as IBaseFilter);
  ShowPinPropertyPage(Self.Handle, PinList.Items[0]);
end;

procedure TForm1.btnSetPropertyClick(Sender: TObject);
begin
  SetVideoProperties(Filter as IBaseFilter);
end;

procedure TForm1.cbbDevicesChange(Sender: TObject);
var
  r: Boolean;
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := False;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(cbbDevices.ItemIndex);
  FilterGraph.Active := True;

  Filter.QueryInterface(IID_IAMCameraControl, camControl);
  GetRangeOfPTZ();
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SysDev.Free();
  FilterGraph.ClearGraph;
  FilterGraph.Active := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  SysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if SysDev.CountFilters > 0 then
  begin
    for i := 0 to SysDev.CountFilters - 1 do
    begin
      cbbDevices.Items.Add(SysDev.Filters[i].FriendlyName);
    end;
  end;

  FilterGraph.GraphEdit := True;
  FilterGraph.Mode := gmCapture;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  cbbDevices.ItemIndex := 0;
  cbbDevicesChange(Sender);
end;

procedure TForm1.GetRangeOfPTZ();
var
  pMin, pMax, pSteppingDelta, pDefault, pCapsFlags: Longint;
  v: Integer;
  flag: TCameraControlFlags;
begin
  camControl.GetRange(CameraControl_Pan, pMin, pMax, pSteppingDelta, pDefault,
    pCapsFlags);
  sbPan.Min := pMin;
  sbPan.Max := pMax;
  camControl.Get(CameraControl_Pan, v, flag);
  sbPan.Position := v;
  labPan.Caption := v.ToString();

  camControl.GetRange(CameraControl_Tilt, pMin, pMax, pSteppingDelta, pDefault,
    pCapsFlags);
  sbTilt.Min := pMin;
  sbTilt.Max := pMax;
  camControl.Get(CameraControl_Tilt, v, flag);
  sbTilt.Position := v;
  labTilt.Caption := v.ToString();

  camControl.GetRange(CameraControl_Zoom, pMin, pMax, pSteppingDelta, pDefault,
    pCapsFlags);
  sbZoom.Min := pMin;
  sbZoom.Max := pMax;
  camControl.Get(CameraControl_Zoom, v, flag);
  sbZoom.Position := v;
  labZoom.Caption := v.ToString();

end;

procedure TForm1.sbPanChange(Sender: TObject);
begin
  labPan.Caption := sbPan.Position.ToString();
  camControl.Set_(CameraControl_Pan, sbPan.Position,
    CameraControl_Flags_Manual);
end;

procedure TForm1.sbTiltChange(Sender: TObject);
begin
  labTilt.Caption := sbTilt.Position.ToString();
  camControl.Set_(CameraControl_Tilt, sbTilt.Position,
    CameraControl_Flags_Manual);
end;

procedure TForm1.sbZoomChange(Sender: TObject);
begin
  labZoom.Caption := sbZoom.Position.ToString();
  camControl.Set_(CameraControl_Zoom, sbZoom.Position,
    CameraControl_Flags_Manual);
end;

end.
