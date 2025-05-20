unit UTaskBarList; 

interface 

uses ComObj, ShlObj; 

type 
  ITaskbarList = interface 
    [SID_ITaskbarList] 
    function HrInit: HResult; stdcall; 
    function AddTab(hwnd: Cardinal): HResult; stdcall; 
    function DeleteTab(hwnd: Cardinal): HResult; stdcall; 
    function ActivateTab(hwnd: Cardinal): HResult; stdcall; 
    function SetActiveAlt(hwnd: Cardinal): HResult; stdcall; 
  end; 

  TTaskbarList = class 
  private 
    xTaskbarList: ITaskbarList; 
  public 
    constructor Create; 
    procedure Activate(hwnd: THandle); 
    procedure Add(hwnd: THandle); 
    procedure Delete(hwnd: THandle); 
    class procedure Insert(hwnd: THandle); 
    class procedure Remove(hwnd: THandle); 
  end; 

implementation 

constructor TTaskbarList.Create; 
begin 
  inherited Create; 
  xTaskbarList := CreateComObject(CLSID_TaskbarList) as ITaskbarList; 
  xTaskbarList.HrInit; 
end; 

procedure TTaskbarList.Activate(hwnd: THandle); 
begin 
  xTaskbarList.ActivateTab(hwnd); 
end; 

procedure TTaskbarList.Add(hwnd: THandle); 
begin 
  xTaskbarList.AddTab(hwnd); 
end; 

procedure TTaskbarList.Delete(hwnd: THandle); 
begin 
  xTaskbarList.DeleteTab(hwnd); 
end; 

class procedure TTaskbarList.Insert(hwnd: THandle); 
begin 
  with TTaskbarList.Create do 
  begin 
    Add(hwnd); 
    Free; 
  end; 
end; 

class procedure TTaskbarList.Remove(hwnd: THandle); 
begin 
  with TTaskbarList.Create do 
  begin 
    Delete(hwnd); 
    Free; 
  end; 
end; 

end. 