unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart,
  abfComponents,idSNMP,StrUtils;

type
  TForm6 = class(TForm)
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    abfThreadTimer1: TabfThreadTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure abfThreadTimer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
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

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Form6.abfThreadTimer1.Enabled:=false;
end;

procedure TForm6.abfThreadTimer1Timer(Sender: TObject);
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
   SNMP:=TIdSNMP.Create(Form6);
   SNMP.Community := Form1.Edit2.Text;
   SNMP.Host :='10.0.29.5'; get_ip(Form1.ComboBox1.Text);
   SNMP.Query.Clear;
   origOID :='1.3.6.1.2.1.2.2.1.10.'+ AnsiReplaceStr(Form6.ComboBox1.Text, ' ', '');
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
           y:=(Abs(StrToInt(value_2))-Abs(StrToInt(value_1)))/5/125000
                       else
           y:=0;

       y:=abs(y);
       if value_1='0' then y:=0;
       x1:=now;

       Form6.Series1.AddXY(x1,y);

       icount:=0;
       For i:=0 to Form6.Series1.Count-1 do
        icount:=icount+Form6.Series1.YValues[i];
       if Form6.Series1.XValue[0]<now- EncodeTime(1,0,0,0) then Form6.Series1.Delete(0);
   except
   end;

   SNMP.Query.Clear;
   origOID :='1.3.6.1.2.1.2.2.1.10.'+AnsiReplaceStr(Form6.ComboBox1.Text, ' ', '');
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
           y:=(Abs(StrToInt(value_4))-Abs(StrToInt(value_3)))/5/125000
                       else
           y:=0;

       y:=abs(y);    
       if value_3='0' then y:=0;
       x1:=now;

       Form6.Series2.AddXY(x1,y);

       icount:=0;
       For i:=0 to Form6.Series2.Count-1 do
        icount:=icount+Form6.Series2.YValues[i];
       if Form6.Series2.XValue[0]<now- EncodeTime(1,0,0,0) then Form6.Series2.Delete(0);
   except
   end;

end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  if Form6.Button1.Caption='Старт' then
    begin
      value_1:='0';
      value_2:='0';
      value_3:='0';
      value_4:='0';

      Form6.Series1.Clear;
      Form6.Series2.Clear;

      Form6.abfThreadTimer1.Enabled:=true;
      Form6.Button1.Caption:='Стоп';
    end
     else
    begin
      Form6.abfThreadTimer1.Enabled:=false;
      Form6.Button1.Caption:='Старт';

    end
end;

end.
