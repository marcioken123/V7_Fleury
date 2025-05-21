unit untAVerCapAPI;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes;

type
    TIntegerDynArray = array of DWORD;

  RESOLUTION_RANGE_INFO =  record
    dwVersion : DWORD;
    bRange : BOOL;
    dwWidthMin : DWORD;
    dwWidthMax : DWORD;
    dwHeightMin : DWORD;
    dwHeightMax : DWORD;
  end;

  VIDEO_RESOLUTION =  record
    dwVersion : DWORD;//must set to 1
    dwVideoResolution : DWORD;
    bCustom : BOOL;
    dwWidth : DWORD;
    dwHeight : DWORD;
  end;
const
  //Error code
  CAP_EC_SUCCESS = 0;
  CAP_EC_INIT_DEVICE_FAILED = -1;
  CAP_EC_DEVICE_IN_USE = -2;
  CAP_EC_NOT_SUPPORTED = -3;
  CAP_EC_INVALID_PARAM = -4;
  CAP_EC_TIMEOUT = -5;
  CAP_EC_NOT_ENOUGH_MEMORY = -6;
  CAP_EC_UNKNOWN_ERROR = -7;
  CAP_EC_ERROR_STATE = -8;
  CAP_EC_HDCP_PROTECTED_CONTENT = -9;

  CAPTURETYPE_HD = 2;

  VIDEORESOLUTION_640X480 = 0;
  VIDEORESOLUTION_704X576 = 1;
  VIDEORESOLUTION_720X480 = 2;
  VIDEORESOLUTION_720X576 = 4;
  VIDEORESOLUTION_1920X1080 = 7;
  VIDEORESOLUTION_160X120 = 20;
  VIDEORESOLUTION_176X144 = 21;
  VIDEORESOLUTION_240X176 = 22;
  VIDEORESOLUTION_240X180 = 23;
  VIDEORESOLUTION_320X240 = 24;
  VIDEORESOLUTION_352X240 = 25;
  VIDEORESOLUTION_352X288 = 26;
  VIDEORESOLUTION_640X240 = 27;
  VIDEORESOLUTION_640X288 = 28;
  VIDEORESOLUTION_720X240 = 29;
  VIDEORESOLUTION_720X288 = 30;
  VIDEORESOLUTION_80X60 = 31;
  VIDEORESOLUTION_88X72 = 32;
  VIDEORESOLUTION_128X96 = 33;
  VIDEORESOLUTION_640X576 = 34;
  VIDEORESOLUTION_180X120 = 37;
  VIDEORESOLUTION_180X144 = 38;
  VIDEORESOLUTION_360X240 = 39;
  VIDEORESOLUTION_360X288 = 40;
  VIDEORESOLUTION_768X576 = 41;
  VIDEORESOLUTION_384x288 = 42;
  VIDEORESOLUTION_192x144 = 43;
  VIDEORESOLUTION_1280X720 = 44;
  VIDEORESOLUTION_1024X768 = 45;
  VIDEORESOLUTION_1280X800 = 46;
  VIDEORESOLUTION_1280X1024 = 47;
  VIDEORESOLUTION_1440X900 = 48;
  VIDEORESOLUTION_1600X1200 = 49;
  VIDEORESOLUTION_1680X1050 = 50;
  VIDEORESOLUTION_800X600 = 51;
  VIDEORESOLUTION_1280X768 = 52;
  VIDEORESOLUTION_1360X768 = 53;
  VIDEORESOLUTION_1152X864 = 54;
  VIDEORESOLUTION_1280X960 = 55;

  VIDEORESOLUTION_702X576 = 56;
  VIDEORESOLUTION_720X400 = 57;
  VIDEORESOLUTION_1152X900 = 58;
  VIDEORESOLUTION_1360X1024 = 59;
  VIDEORESOLUTION_1366X768 = 60;
  VIDEORESOLUTION_1400X1050 = 61;
  VIDEORESOLUTION_1440X480 = 62;
  VIDEORESOLUTION_1440X576 = 63;
  VIDEORESOLUTION_1600X900 = 64;
  VIDEORESOLUTION_1920X1200 = 65;
  VIDEORESOLUTION_1440X1080 = 66;
  VIDEORESOLUTION_1600X1024 = 67;
  VIDEORESOLUTION_3840X2160 = 68;

  VIDEORENDERER_EVR = 3;

 function AVerGetDeviceNum(var pdwDeviceNum : DWORD) : LONG; stdcall; external 'AVerCapAPI.dll';
 function AVerGetDeviceName(dwDeviceIndex : DWORD ;szDeviceName : LPWSTR) :LONG; stdcall; external 'AVerCapAPI.dll';
 function AVerCreateCaptureObjectEx(dwDeviceIndex : DWORD; dwType : DWORD ;  hWnd : HWND; var phCaptureObject : THandle) : LONG  ;stdcall; external 'AVerCapAPI.dll';
 function AVerGetVideoSource (hCaptureObject : THandle ; var pdwVideoSource : DWORD ) : LONG;stdcall; external 'AVerCapAPI.dll';
 function AVerGetVideoFormat (hCaptureObject : THandle ; var pdwVideoFormat : DWORD ) : LONG;stdcall; external 'AVerCapAPI.dll';
 function AVerGetVideoResolutionSupported(hCaptureObject : THandle; dwVideoSource : DWORD; dwVideoFromat : DWORD;  pdwSupported :TIntegerDynArray;  var pdwNum: DWORD): LONG ; stdcall; external 'AVerCapAPI.dll';
 function AVerGetVideoResolutionEx (hCaptureObject : THandle;  var pVideoResolution : VIDEO_RESOLUTION) :LONG;stdcall; external 'AVerCapAPI.dll';
 function AVerStartStreaming (hCaptureObject : THandle) : LONG ; stdcall; external 'AVerCapAPI.dll';
 function AVerStopStreaming (hCaptureObject : THandle) : LONG ; stdcall; external 'AVerCapAPI.dll';
 function AVerDeleteCaptureObject (hCaptureObject : THandle) : LONG ; stdcall; external 'AVerCapAPI.dll';
 function AVerSetVideoRenderer(hCaptureObject : THandle;  pdwVideoRenderer : DWORD) : LONG  ;stdcall; external 'AVerCapAPI.dll';
 function AVerSetVideoWindowPosition(hCaptureObject : THandle;  rectVideoWnd : TRect) : LONG ;stdcall; external 'AVerCapAPI.dll';
 function AVerSetVideoResolutionEx (hCaptureObject : THandle;  var pVideoResolution : VIDEO_RESOLUTION) :LONG;stdcall; external 'AVerCapAPI.dll';
 function AVerSetVideoInputFrameRate (hCaptureObject : THandle; dwFrameRate : DWORD) :LONG  ; stdcall; external 'AVerCapAPI.dll';
implementation


end.
