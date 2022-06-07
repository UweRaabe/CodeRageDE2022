unit ObservableData;

interface

uses
  System.SysUtils,
  Cmon.Observers,
  DataTypes;

type
  TObservableData = class(TData)
  private
    FObservers: TValueObservers<TData>;
  protected
    procedure MyLinesChanged; override;
    procedure MyListItemChanged; override;
    procedure MyListItemIndexChanged; override;
    procedure MySelectedChanged; override;
    procedure MySelectedIndexChanged; override;
    procedure MyStringChanged; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddObserver<T>(const APropName: string; AOnValueChanged: TProc<T>); overload;
    procedure AddObserver<T>(const APropName: string; AOnValueChanged: TProc<TData,T>); overload;
    property Observers: TValueObservers<TData> read FObservers;
  end;

implementation

constructor TObservableData.Create;
begin
  inherited;
  FObservers := TValueObservers<TData>.Create(Self);
end;

destructor TObservableData.Destroy;
begin
  FObservers.Free;
  inherited Destroy;
end;

procedure TObservableData.AddObserver<T>(const APropName: string; AOnValueChanged: TProc<T>);
begin
  Observers.AddObserver<T>(APropName, AOnValueChanged);
end;

procedure TObservableData.AddObserver<T>(const APropName: string; AOnValueChanged: TProc<TData,T>);
begin
  Observers.AddObserver<T>(APropName, AOnValueChanged);
end;

procedure TObservableData.MyLinesChanged;
begin
  inherited;
  Observers.ValueChanged('MyLines');
end;

procedure TObservableData.MyListItemChanged;
begin
  inherited;
  Observers.ValueChanged('MyListItem');
end;

procedure TObservableData.MyListItemIndexChanged;
begin
  inherited;
  Observers.ValueChanged('MyListItemIndex');
end;

procedure TObservableData.MySelectedChanged;
begin
  inherited;
  Observers.ValueChanged('MySelected');
end;

procedure TObservableData.MySelectedIndexChanged;
begin
  inherited;
  Observers.ValueChanged('MySelectedIndex');
end;

procedure TObservableData.MyStringChanged;
begin
  inherited;
  Observers.ValueChanged('MyString');
end;

end.
