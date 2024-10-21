unit CConsultaCEP.HTTPIndy;

interface

uses
  IdHTTP, IdSSL, CConsultaCEP.Intf, System.SysUtils, IdSSLOpenSSL;

type
  TIndyHttpClient = class(TInterfacedObject, IHttpClient)
  private
    FHTTP: TIdHTTP;
    FSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  public
    constructor Create;
    destructor Destroy; override;
    function Get(const AURL: string): string;
  end;

implementation

{ TIndyHttpClient }

constructor TIndyHttpClient.Create;
begin
  inherited Create;
  FHTTP := TIdHTTP.Create(nil);
  FSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FSSLHandler.SSLOptions.Method := sslvTLSv1_2;
  FSSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  FHTTP.IOHandler := FSSLHandler;
  FHTTP.Request.CharSet := 'utf-8';
  FHTTP.Request.AcceptCharSet := 'utf-8';
end;

destructor TIndyHttpClient.Destroy;
begin
  FSSLHandler.Free;
  FHTTP.Free;
  inherited Destroy;
end;

function TIndyHttpClient.Get(const AURL: string): string;
begin
  Result := FHTTP.Get(AURL);
end;

end.
