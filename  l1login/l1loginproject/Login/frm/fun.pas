unit fun;



interface

uses
  Windows,Forms,SysUtils,TlHelp32,ActiveX,ComObj,ShlObj;

procedure createlink;//������ݷ�ʽ
procedure checkClient;//����Ƿ�Ϊ�ͻ���
procedure  Mutex;//���̻���
implementation
uses main;

procedure createlink;
var 
tmpObject : IUnknown; 
tmpSLink : IShellLink;
tmpPFile : IPersistFile; 
PIDL : PItemIDList; 
StartupDirectory : array[0..MAX_PATH] of Char;
StartupFilename : String; 
LinkFilename : WideString;
begin
//������ݷ�ʽ������ 
StartupFilename :=Application.ExeName;
tmpObject := CreateComObject(CLSID_ShellLink);//����������ݷ�ʽ�������չ 
tmpSLink := tmpObject as IShellLink;//ȡ�ýӿ� 
tmpPFile := tmpObject as IPersistFile;//��������*.lnk�ļ��Ľӿ� 
tmpSLink.SetPath(pChar(StartupFilename));//�趨����·�� 
tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename)));//�趨����Ŀ¼
SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,PIDL);//��������Itemidlist 
tmpSLink.SetDescription('���õ�½��');
tmpSLink.SetIconLocation(Pchar(StartupFilename),0);
SHGetPathFromIDList(PIDL,StartupDirectory);//�������·�� 
LinkFilename := StartupDirectory + string('\')+ cfg.LoginName +'.lnk';
tmpPFile.Save(pWChar(LinkFilename),FALSE);//����*.lnk�ļ� 
end;

procedure checkClient;
begin
  if not FileExists(ExtractFilePath(ParamStr(0))+'npkcrypt.sys') then
  begin
    Application.MessageBox('��ѵ�½���ŵ�������ϷĿ¼��!','��ʾ��Ϣ',MB_ICONINFORMATION+ MB_OK);
    Application.Terminate;
    exit;
  end;
end;

procedure  Mutex;
var
 hMutex:HWND;
begin
///////////////////////////////�����������/////////////////////////////
  hMutex := CreateMutex(nil,True,'johntao');
  if hMutex <> 0 then
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      Application.MessageBox('��ֹ�࿪��½��!','��ʾ��Ϣ',MB_OK);
      Application.Terminate;
    end;
///////////////////////////////end/////////////////////////////////////
end;
end.