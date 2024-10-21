unit App.model.DB.Intf;

interface

uses
  Data.DB, System.Classes;

type

  iSQLConditions = interface
    ['{1CD5B0D1-674C-4042-B155-221DA2D8A4F5}']
    function AddCondition( AField : string; AValue : string; AOperator : string ) : iSQLConditions; overload;
    function AddCondition( AField : string; AValue : integer; AOperator : string ) : iSQLConditions; overload;
    function AddCondition( AField : string; AValue : double; AOperator : string ) : iSQLConditions; overload;
    function AddSpecialCondicion( ACondition : string ) : iSQLConditions;
    function ClearConditions : iSQLConditions;
    function Text : string;
  end;

  IQuery = interface
    ['{92E0B75B-4A2F-471A-B930-22B87868E64F}']
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
    function Having( AValue : string ) : IQuery; overload;
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

  IQueryFactory = interface
    ['{11F0286C-FC71-4B49-8295-EB782EADFD54}']
    function Query : iQuery;
  end;

  iSimpleQuery = interface
    ['{6DCCA942-736D-4C66-AC9B-94151F14853A}']
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iSimpleQuery;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iSimpleQuery; overload;
    function Open : iSimpleQuery; overload;
  end;

implementation

end.
