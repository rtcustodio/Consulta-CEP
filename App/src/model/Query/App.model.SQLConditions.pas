unit App.model.SQLConditions;

interface

uses
  App.model.DB.Intf,
  System.Classes,
  SysUtils;

type
  TSQLConditionGenerator = class(TInterfacedObject, iSQLConditions)
  private
    FConditions : array of string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iSQLConditions;
    function AddCondition( AField : string; AValue : string; AOperator : string ) : iSQLConditions; overload;
    function AddCondition( AField : string; AValue : integer; AOperator : string ) : iSQLConditions; overload;
    function AddCondition( AField : string; AValue : double; AOperator : string ) : iSQLConditions; overload;
    function AddSpecialCondicion( ACondition : string ) : iSQLConditions;
    function ClearConditions : iSQLConditions;
    function Text : string;
  end;

implementation

{ TSQLConditionGenerator }

function TSQLConditionGenerator.AddCondition(AField,
  AValue: string; AOperator : string ): iSQLConditions;
begin
  SetLength( FConditions, Length(FConditions) + 1 );
  FConditions[Pred(Length(FConditions))] := AField + AOperator + AValue;
end;

function TSQLConditionGenerator.AddCondition(AField: string;
  AValue: integer; AOperator : string ): iSQLConditions;
begin
  SetLength( FConditions, Length(FConditions) + 1 );
  FConditions[Pred(Length(FConditions))] := AField + AOperator +AValue.ToString;
end;

function TSQLConditionGenerator.AddCondition(AField: string;
  AValue: double; AOperator : string ): iSQLConditions;
var
  LFormat : TFormatSettings;
begin
  LFormat.DecimalSeparator := '.';
  LFormat.ThousandSeparator:= #0;

  SetLength( FConditions, Length(FConditions) + 1 );
  FConditions[Pred(Length(FConditions))] := AField + AOperator +  AValue.ToString(LFormat);
end;

function TSQLConditionGenerator.AddSpecialCondicion(
  ACondition: string): iSQLConditions;
begin
  SetLength( FConditions, Length(FConditions) + 1 );
  FConditions[Pred(Length(FConditions))] := ACondition;
end;

function TSQLConditionGenerator.Text: string;
begin
  Result := '';
  if Length(FConditions) > 0 then
    Result := ' WHERE ' + string.Join(' AND ',  FConditions);
end;

function TSQLConditionGenerator.ClearConditions: iSQLConditions;
begin
  SetLength(FConditions, 0);
end;

constructor TSQLConditionGenerator.Create;
begin
  ClearConditions;
end;

destructor TSQLConditionGenerator.Destroy;
begin

  inherited;
end;

class function TSQLConditionGenerator.New: iSQLConditions;
begin
  Result := Self.Create;
end;

end.
