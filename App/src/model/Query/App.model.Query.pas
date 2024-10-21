unit App.model.Query;

interface

uses
  App.model.DB.Intf,
  Data.DB,
  App.model.SQLConditions,
  System.Classes,
  System.SysUtils,
  System.Rtti,
  TypInfo,
  FireDAC.Comp.Client,
  SimpleQueryFiredac,
  System.RegularExpressions;

type
  TQuery = class(TInterfacedObject, IQuery)
  private
    FQuery : iSimpleQuery;
    FCondicoes : iSQLConditions;
    FLabels : TStrings;
    FJoins : TStrings;
    FFields : TStrings;
    FTable : string;
    FGroupBy : string;
    FHaving : string;
    FOrderBy : string;
    FLimit : integer;
    FOffset : integer;
    function SQL : string;
    function Table : string; overload;
    function Fields : string;
    function Conditions : string;
    function Joins : string;
    function GroupBy : string; overload;
    function Having : string; overload;
    function OrderBy : string; overload;
    function Limit : string; overload;
    function Offset : string; overload;
    procedure AfterOpen(Dataset : TDataset);
  public
    constructor Create( AConnection : TFDConnection );
    destructor Destroy; override;
    class function New( AConnection : TFDConnection ) : IQuery;
    function Table( AValue : string ) : IQuery; overload;
    function AddField( AField : string; ALabel : string = '' ) : IQuery;
    function AddCondition( AField : string; AValue : string; AOperator : string = '=' ) : IQuery; overload;
    function AddCondition( AField : string; AValue : integer; AOperator : string = '=' ) : IQuery; overload;
    function AddCondition( AField : string; AValue : double; AOperator : string = '=' ) : IQuery; overload;
    function AddSpecialCondicion( ACondition : string ) : IQuery;
    function ClearConditions : IQuery;
    function ClearFields : IQuery;
    function Clearjoins : IQuery;
    function AddJoin( AJoin : string ) : IQuery;
    function GroupBy( AValue : string ) : IQuery; overload;
    function Having( AValue : string )  : IQuery; overload;
    function OrderBy( AValue : string ) : IQuery; overload;
    function Limit( AValue : integer ) : IQuery; overload;
    function Offset( AValue : integer ) : IQuery; overload;
    function DataSource( AValue : TDataSource ) : IQuery;
    function Dataset : TDataset;
    function Open : IQuery; overload;
    function Open( aSQL : string ) : IQuery; overload;
    function Close : IQuery;
    function ExecSQL ( ASQL : string ) : IQuery;
  end;

implementation

{ TQuery }

function TQuery.AddCondition(AField: string; AValue: double; AOperator : string = '=' ): IQuery;
begin
  Result := Self;
  FCondicoes.AddCondition(AField, AValue, AOperator);
end;

function TQuery.AddCondition(AField: string; AValue: integer; AOperator : string = '=' ): IQuery;
begin
  Result := Self;
  FCondicoes.AddCondition(AField, AValue, AOperator);
end;

function TQuery.AddCondition(AField, AValue : string; AOperator : string = '=' ): IQuery;
begin
  Result := Self;
  FCondicoes.AddCondition(AField, AValue, AOperator);

end;

function TQuery.AddField( AField : string; ALabel : string = '' ) : IQuery;

  function ExtractFieldName(const AField: string): string;
  var
    FieldName: string;
    RegEx: TRegEx;
    Match: TMatch;
  begin
    // Expressão regular para capturar o nome do campo após "as " ou após o último ponto "."
    RegEx := TRegEx.Create('(?:as\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*$|([a-zA-Z_][a-zA-Z0-9_]*)$');
    Match := RegEx.Match(AField);

    if Match.Success then
    begin
      // Se houver correspondência no grupo 1 (após "as"), usamos esse, caso contrário, usamos o grupo 2 (após o último ponto)
      if Match.Groups[1].Success then
        FieldName := Match.Groups[1].Value
      else if Match.Groups[2].Success then
        FieldName := Match.Groups[2].Value;
    end
    else
      FieldName := AField; // Caso não haja correspondência, retornamos o campo original

    Result := FieldName;
  end;

begin
  Result := Self;
  FFields.Add(AField);

  var RealFieldName := ExtractFieldName(AField);
  FLabels.AddPair(RealFieldName, ALabel);
end;

function TQuery.AddJoin(AJoin: string): IQuery;
begin
  Result := Self;
  FJoins.Add(' ' + AJoin + ' ');
end;

procedure TQuery.AfterOpen(Dataset: TDataset);
var
  I: Integer;
  Field : TField;
  Info     : PTypeInfo;
begin
  inherited;
  for I := 0 to Pred( FLabels.Count ) do
    if Assigned( FQuery.DataSet.FindField(FLabels.Names[I]) ) then
       FQuery.DataSet.FindField(FLabels.Names[I]).DisplayLabel := FLabels.Values[FLabels.Names[I]];

  for I := 0 to Pred( DataSet.FieldList.Count ) do
      if  DataSet.FieldList.Fields[I].DataType in [ftFloat, ftCurrency, ftBCD]  then
        TFloatField( DataSet.FieldList.Fields[I] ).DisplayFormat := '#0,.00';

//  for I := 0 to Pred( FQuery.DataSet.Fields.Count ) do
//  begin
////    Info := System.TypeInfo( FQuery.DataSet.Fields[I].DataType );
//    var ctxRTTI := TRttiContext.Create;
//    try
//      for Field in FQuery.DataSet.Fields do
//      begin
//        var typRtti := ctxRTTI.GetType( Pointer( Field ) );
//        for var prpRtti in typRtti.GetProperties do
//          if prpRtti.PropertyType.TypeKind in [tkFloat] then
//            TFloatField( FQuery.DataSet.Fields[I] ).DisplayFormat := '#0,.00';
//
//      end;
//    finally
//      ctxRTTI.Free;
//    end;
//  end;

end;

function TQuery.AddSpecialCondicion(ACondition: string): IQuery;
begin
  Result := Self;
  FCondicoes.AddSpecialCondicion( ACondition );
end;

function TQuery.ClearConditions: IQuery;
begin
  Result := Self;
  FCondicoes.ClearConditions;
end;

function TQuery.ClearFields: IQuery;
begin
  Result := Self;
  FFields.Clear;
  FLabels.Clear;
end;

function TQuery.Clearjoins: IQuery;
begin
  Result := Self;
  FJoins.Clear;
end;

function TQuery.Close: IQuery;
begin
  Result := Self;
  FQuery.DataSet.Close;
end;

function TQuery.Conditions: string;
begin
  Result := FCondicoes.Text;
end;

constructor TQuery.Create( AConnection : TFDConnection );
begin
  FQuery      := TSimpleQueryFireDAC.New(AConnection);
  FQuery.DataSet.AfterOpen := AfterOpen;
  FCondicoes  := TSQLConditionGenerator.New;
  FLabels     := TStringList.Create;
  FJoins      := TStringList.Create;
  FFields     := TStringList.Create;
  FLimit      := -1;
  FOffset     := 0;
end;

function TQuery.Dataset: TDataset;
begin
  Result := FQuery.DataSet;
end;

function TQuery.DataSource(AValue: TDataSource): IQuery;
begin
  Result := Self;
  AValue.DataSet := FQuery.DataSet;
end;

destructor TQuery.Destroy;
begin
  FreeAndNil( FLabels );
  FreeAndNil( FJoins );
  FreeAndNil( FFields );
  inherited;
end;

function TQuery.ExecSQL(ASQL: string): IQuery;
begin
  Result := Self;
  FQuery.SQL.Text := ASQL;
  FQuery.ExecSQL;
end;

function TQuery.Fields: string;
begin
  FFields.Delimiter := ',';
  FFields.QuoteChar := ' ';

  Result := ' ' + FFields.DelimitedText + ' ';
  if Result.Trim.IsEmpty then Result := ' * ';
end;

function TQuery.GroupBy: string;
begin
  Result := '';
  if not FGroupBy.IsEmpty then
    Result := ' GROUP BY ' + FGroupBy;
end;

function TQuery.GroupBy(AValue: string): IQuery;
begin
  Result := Self;
  FGroupBy := AValue;
end;

function TQuery.Having(AValue: string): IQuery;
begin
  Result := Self;
  FHaving := AValue;
end;

function TQuery.Having: string;
begin
  Result := '';
  if not FHaving.IsEmpty then
    Result := ' HAVING ' + FHaving;
end;

function TQuery.Joins: string;
var
  I : integer;
begin
  for I := 0 to Pred(FJoins.Count) do
    Result := Result + FJoins[I];
end;

function TQuery.Limit(AValue: integer): IQuery;
begin
  Result := Self;
  FLimit := AValue;
end;

function TQuery.Limit: string;
begin
  Result := '';
  if FLimit >= 0 then
    Result := ' LIMIT ' + FLimit.ToString;
end;

class function TQuery.New( AConnection : TFDConnection ): IQuery;
begin
  Result := Self.Create( AConnection );
end;

function TQuery.Offset(AValue: integer): IQuery;
begin
  Result := Self;
  FOffset := AValue;
end;

function TQuery.Open(aSQL: string): IQuery;
begin
  Result := Self;
  FQuery.Open( aSQL );
end;

function TQuery.Offset: string;
begin
  Result := '';
  if FOffset > 0 then
    Result := ' OFFSET ' + FOffset.ToString;
end;

function TQuery.Open: IQuery;
begin
  Result := Self;
  FQuery.Open(SQL);
end;

function TQuery.OrderBy: string;
begin
  Result := '';
  if not FOrderBy.IsEmpty then
    Result := ' ORDER BY ' + FOrderBy;
end;

function TQuery.OrderBy(AValue: string): IQuery;
begin
  Result := Self;
  FOrderBy := AValue;
end;

function TQuery.SQL: string;
begin
  Result :=
    'SELECT ' +
    Fields +
    ' FROM ' +
    Table +
    Joins +
    Conditions +
    GroupBy +
    Having +
    OrderBy +
    Limit +
    Offset;
end;

function TQuery.Table: string;
begin
  Result := ' ' + FTable + ' ';
  if Result.IsEmpty then
    raise Exception.Create('Nenhuma tabela informada para query');
end;

function TQuery.Table(AValue: string): IQuery;
begin
  Result := Self;
  FTable := AValue;
end;

end.
