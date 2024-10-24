unit App.model.Datamodule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  Data.DB, FireDAC.Comp.Client, IniFiles;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  Vcl.Forms, Winapi.Windows;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  arquivo : TIniFile;
begin
  arquivo := TIniFile.Create(ExtractFilePath( Application.ExeName ) +'config.ini');
  if not FileExists( arquivo.ReadString('config','database', '') ) then
  begin
    Application.MessageBox(
      PWideChar('Arquivo de banco de dados n�o localizado: ' +
      sLinebreak + arquivo.ReadString('config','database', '') +
      sLineBreak + ' Verifique o config.ini'),
      'Aten��o', MB_ICONERROR);
    Application.Terminate;
  end;

  try
    DM.FDConnection.Params.Clear;
    DM.FDConnection.Params.Add('database='+  arquivo.ReadString('config','database', ''));
    DM.FDConnection.Params.Add('DriverID='+  arquivo.ReadString('config','DriverID', ''));
    DM.FDConnection.Params.Add('LockingMode=Normal');
    try
      DM.FDConnection.Connected := True;
    except
      on e: exception do
      begin
        Application.MessageBox(PWideChar('N�o foi poss�vel conectar ao banco de logs do sistema.' +
          #13#10#13#10 + e.Message), 'Erro de conex�o', MB_OK + MB_ICONSTOP +
          MB_DEFBUTTON2);
        Application.Terminate;
      end;
    end;
  finally
    FreeAndNil(arquivo);
  end;
end;

end.
