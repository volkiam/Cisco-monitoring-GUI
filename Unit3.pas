unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdSNMP;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    Label3: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}


procedure TForm3.Button1Click(Sender: TObject);
 var
    origOID:string;
    i:integer;
    SNMP:TidSNMP;
begin
   SNMP:=TIdSNMP.Create(Form1);
   Form3.Memo1.Clear;
   SNMP.Community := Form3.Edit2.Text;
   SNMP.Host := Form3.Edit1.Text;
   SNMP.Query.Clear;
   origOID := Form3.Edit3.Text;
   SNMP.Query.MIBAdd(origOID, '');
   if Form3.CheckBox1.Checked then SNMP.Query.PDUType := PDUGetRequest
                              else SNMP.Query.PDUType := PDUGetNextRequest;

   while SNMP.SendQuery do
     begin
       SNMP.Query.PDUType := PDUGetNextRequest;
       if Copy(SNMP.Reply.MIBOID[0], 1, Length(origOID)) <> origOID then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        memo1.Lines.Add(SNMP.Reply.ValueOID[i]+'   '+  SNMP.Reply.Value[I]);
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;

end;

end.
