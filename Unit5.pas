unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, abfComponents,idSNMP, StdCtrls, TeEngine, Series, ExtCtrls,
  TeeProcs, Chart;

type
  TForm5 = class(TForm)
    abfThreadTimer1: TabfThreadTimer;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    procedure abfThreadTimer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    nom_port:string;
  end;

var
  Form5: TForm5;
  value_1,value_2,value_3,value_4:string;
implementation

uses Unit1;

{$R *.dfm}

Function get_ip(st:string):string;
 var
    s:string;
Begin
  s:=copy(st,1,Pos('-',st)-1);
if Pos('-',st)>0 then result:=copy(st,1,Pos('-',st)-1)
                 else result:=st;
end;


procedure TForm5.abfThreadTimer1Timer(Sender: TObject);
 var
    origOID:string;
    i:integer;
    SNMP:TidSNMP;
    x1:TDatetime;
    icount:real;
    y:real;
begin
   value_1:=value_2;
   value_3:=value_4;
   SNMP:=TIdSNMP.Create(Form5);
   SNMP.Community := Form1.Edit2.Text;
   SNMP.Host := get_ip(Form1.ComboBox1.Text);
   SNMP.Query.Clear;
   origOID := '1.3.6.1.2.1.2.2.1.10.'+Form5.nom_port;
   SNMP.Query.MIBAdd(origOID, '');
   SNMP.Query.PDUType := PDUGetRequest;
   while SNMP.SendQuery do
     begin
       SNMP.Query.PDUType := PDUGetNextRequest;
       if Copy(SNMP.Reply.MIBOID[0], 1, Length(origOID)) <> origOID then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        value_2:=SNMP.Reply.Value[I];
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;

     try
       if value_1<>'' then
           y:=(StrToInt(value_2)-StrToInt(value_1))/5/125000
                       else
           y:=0;


       if value_1='0' then y:=0;
       x1:=now;

       Form5.Series1.AddXY(x1,y);

       icount:=0;
       For i:=0 to Form5.Series1.Count-1 do
        icount:=icount+Form5.Series1.YValues[i];
       if Form5.Series1.XValue[0]<now- EncodeTime(1,0,0,0) then Form5.Series1.Delete(0);
   except
   end;

   SNMP.Query.Clear;
   origOID := '1.3.6.1.2.1.2.2.1.16.'+Form5.nom_port;
   SNMP.Query.MIBAdd(origOID, '');
   SNMP.Query.PDUType := PDUGetRequest;
   while SNMP.SendQuery do
     begin
       SNMP.Query.PDUType := PDUGetNextRequest;
       if Copy(SNMP.Reply.MIBOID[0], 1, Length(origOID)) <> origOID then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        value_4:=SNMP.Reply.Value[I];
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;

     try
       if value_3<>'' then
           y:=(StrToInt(value_4)-StrToInt(value_3))/5/125000
                       else
           y:=0;

       if value_3='0' then y:=0;
       x1:=now;

       Form5.Series2.AddXY(x1,y);

       icount:=0;
       For i:=0 to Form5.Series2.Count-1 do
        icount:=icount+Form5.Series2.YValues[i];
       if Form5.Series2.XValue[0]<now- EncodeTime(1,0,0,0) then Form5.Series2.Delete(0);
   except
   end;   
end;

procedure TForm5.FormShow(Sender: TObject);
begin
    value_1:='0';
    value_2:='0';
    value_3:='0';
    value_4:='0';

    Form5.Series1.Clear;
    Form5.Series2.Clear;
    Form5.abfThreadTimer1.Interval:=5000;
    Form5.abfThreadTimer1.Enabled:=true;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form5.abfThreadTimer1.Enabled:=false;
end;

end.
