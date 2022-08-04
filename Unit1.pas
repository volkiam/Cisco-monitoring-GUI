unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdSNMP, TeEngine, Series, TeeProcs, Chart, Menus,
  abfComponents;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Button2: TButton;
    Memo2: TMemo;
    Button3: TButton;
    ComboBox1: TComboBox;
    Timer2: TTimer;
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    OIDtest1: TMenuItem;
    Graphicsview1: TMenuItem;
    Exit1: TMenuItem;
    Timer1: TabfThreadTimer;
    Timer3: TabfThreadTimer;
    VLAN1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Graphicsview1Click(Sender: TObject);
    procedure OIDtest1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure Form4_open(Sender: TObject);
    Procedure Form5_open(Sender: TObject);
    procedure VLAN1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dir_app:string;
  sp:TStringList;
  Ports:TStringList;
  NumPorts,PortOn,PortsName: TStringList;
  MasPanel:array[0..1000] of TPanel;
  n_panel,n_group:integer;
  MasGroup:array[1..20] of TGroupBox;
  x,y:integer;
  icount:array[1..5] of real;
  Vlan:TstringList;
  VlanWithPorts,VoiceVlanWithPorts:TStringList;
  ifDescr, ifOperStatus, vtpVlanName, entPhysicalModelName, sysDescr: string;
  sysUpTime, FreeMemory, dot1dTpFdbPort, vmVlan, vmVoiceVlan: string;
  vtpVlanState, cpmCPUTotalMonIntervalValue,ciscoEnvMonTemperatureStatusValue: string;
  cpmCPUMemoryUsed:string;
  port162:boolean;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6;

{$R *.dfm}

Procedure read_setting;
 var
   f:textfile;
   s:string;
Begin
  if fileexists(dir_app+'\oid.txt') then
    begin
      assignfile(f, dir_app+'\oid.txt');
      reset(f);
            readln(f,s);
      ifDescr:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      ifOperStatus:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      vtpVlanName:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      entPhysicalModelName:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      sysDescr:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      sysUpTime:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      FreeMemory:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      vtpVlanState:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      dot1dTpFdbPort:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      vmVlan:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      vmVoiceVlan:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      cpmCPUTotalMonIntervalValue:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      ciscoEnvMonTemperatureStatusValue:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
            readln(f,s);
      cpmCPUMemoryUsed:=copy(s,Pos('=',s)+1,length(s)-Pos('=',s));
      closefile(f);

    end;

End;

Function GetFirstSNMPvalue(host,commun,oid:string):string;
 var
      i:integer;
      SNMP:TidSNMP;
begin
   SNMP:=TIdSNMP.Create(Form1);
   SP.Clear;
   SNMP.Community := commun;
   SNMP.Host := host;
   SNMP.Query.Clear;
   //origOID := oid;
   SNMP.Query.MIBAdd(OID, '');
   SNMP.Query.PDUType := PDUGetRequest;
   While port162 do
    sleep(100);
   port162:=true;
   while SNMP.SendQuery do
     begin
       if (Copy(SNMP.Reply.MIBOID[0], 1, Length(OID)) <> OID)  then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        result:=  SNMP.Reply.Value[0];
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;

    SNMP.Destroy;
    port162:=false;
end;

Procedure GetMySNMPinfo(host,commun,oid:string;var SP:TStringList);
   var
      i:integer;
      SNMP:TidSNMP;
begin
   SNMP:=TIdSNMP.Create(Form1);
   SP.Clear;
   SNMP.Community := commun;
   SNMP.Host := host;
   SNMP.Query.Clear;
   SNMP.Query.MIBAdd(OID, '');
   SNMP.Query.PDUType := PDUGetNextRequest;
   While port162 do
    sleep(100);
   port162:=true;
   while SNMP.SendQuery do
     begin
       if (Copy(SNMP.Reply.MIBOID[0], 1, Length(OID)) <> OID)  then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        SP.Append(SNMP.Reply.ValueOID[i]+' = '+IntToStr(SNMP.Reply.ValueType[i]) +' : '+ SNMP.Reply.Value[I]);
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;
    SNMP.Destroy;
    port162:=false;
end;


// забрать из списка значение с номером по порядку
Function get_value(st:string;i:integer):string;
 var
   j,k:integer;
   temps,temps2:string;
Begin
  j:=0;
  temps:=st;
  if temps='' then
   begin
     result:='no';
     exit;

   end;
  if temps[length(temps)]<>';' then temps:=temps+';';
  Repeat
    k:=Pos(';',temps);
    temps2:=copy(temps,1,k-1);
    temps:=copy(temps,k+1,length(temps)-k+1);
    temps2:=Copy(temps2,Pos(': ',temps2)+2,length(temps2)-Pos(': ',temps2)-1);
    inc(j);
  Until (j>i) or (temps='');
  k:=Pos('"',temps2);
  if k>0 then delete(temps2,k,1);
  k:=Pos('"',temps2);
  if k>0 then delete(temps2,k,1);
  if (i>j) or (Pos('No Such',temps2)>0) then result :='no'
                                        else result:=temps2;
end;

Function get_value_parrent(st:string):string;
 var
   j,k:integer;
   temps,temps2,s:string;
Begin
  j:=0;
  temps:=st;
  if temps='' then
   begin
     result:='no';
     exit;

   end;
  temps:=Copy(temps,1,Pos('=',temps));
  k:=length(temps)-2;
  s:=temps[k];
  temps2:='';
  While (k>0) and (s<>'.') do
   begin
     temps2:=s+temps2;
     k:=k-1;
     s:=temps[k];
   end;
  result:=temps2;
end;

Function getsnmpresult(hostip,hostcom,oid,gettype:string):string;
 var
    stext,temps,res:string;
    i:integer;
    SNMP:TidSNMP;
    te1,te2:string;
begin
   SNMP:=TIdSNMP.Create(Form1);
   SP.Clear;
   SNMP.Community := hostcom;
   SNMP.Host := hostip;
   SNMP.Query.Clear;
   SNMP.Query.MIBAdd(OID, '');
   if gettype='1' then SNMP.Query.PDUType := PDUGetRequest
                  else SNMP.Query.PDUType := PDUGetNextRequest;

   res:='';

    While port162 do
    sleep(100);
   port162:=true;
   try
   while SNMP.SendQuery do
     begin
       SNMP.Query.PDUType := PDUGetNextRequest;
       te1:=Copy(SNMP.Reply.MIBOID[0], 1, Length(OID));
       te2:=oid;
       if (Copy(SNMP.Reply.MIBOID[0], 1, Length(OID)) <> OID)  then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
         res:=res+SNMP.Reply.ValueOID[i]+' = '+IntToStr(SNMP.Reply.ValueType[i]) +' : '+ SNMP.Reply.Value[I]+';';
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;
  except
    Form1.Memo2.Lines.Append(DateToStr(now)+'  '+TimeToStr(now)+ ' Error');
  end;
  result:=res;
  SNMP.Destroy;
  port162:=false;
end;
{
Procedure getsnmpinfo(hostip,hostcom,oid:string; var SP:TStringList);
 var
    stext,temps:string;
    i:integer;
begin
  stext:=GetDosOutput(dir_app+'/snmp/snmpwalk.exe','-v 2c -c '+hostcom+' '+hostip+' '+oid);
  i:=pos('iso.', stext);
  stext:=copy(stext,i,length(stext)-i);
   While pos(#$D#$A,stext)>0 do
   begin
     i:=pos(#$D#$A,stext);
     temps:=copy(stext,1,i-1);
     stext:=copy(stext,i+2,length(stext)-i-1);
     if (Pos('cannot',lowercase(temps))=0) and  (Pos('search',lowercase(temps))=0) then
      begin
        if pos ('iso', temps)> 0 then
          begin
           sp.Append(temps);
          end;
      end;
   end;

end;
 }

Function get_last_dig(st:string):String;
 var
   j:integer;
   temps,temps2:string;
Begin
  if Pos('=',st)>0 then temps:=copy(st,1,Pos('=',st)-1)
                   else temps:=st;
  if temps='' then
   begin
     result:='no';
   end
    else
   begin
     j:=length(temps);   //-1
     temps2:='';
     While (j>=0) and (temps[j]<>'.') do
      begin
        temps2:=temps[j]+temps2;
        j:=j-1
      end;
     if temps2<>'' then  result:=temps2
                   else  result:='no';
   end;
end;

// получение портов с указанным vlan
Procedure getvlaninfo_2(hostip,hostcom,oid,vlan:string; var SP:TStringList);
 var
    stext,temps,s,s2:string;
    i,num:integer;
    type1,type2,res_port:string;
    d1,d2,d3:string;
    SNMP:TidSNMP;

begin
   SNMP:=TIdSNMP.Create(Form1);
   SP.Clear;
   SNMP.Community := hostcom;
   SNMP.Host := hostip;
   SNMP.Query.Clear;
   SNMP.Query.MIBAdd(OID, '');
   SNMP.Query.PDUType := PDUGetNextRequest;
    While port162 do
    sleep(100);
   port162:=true;
   while SNMP.SendQuery do
     begin
       if (Copy(SNMP.Reply.MIBOID[0], 1, Length(OID)) <> OID)  then
         Break;
       for I := 0 to SNMP.Reply.ValueCount - 1 do
        begin
          // SP.Append(SNMP.Reply.ValueOID[i]+' = '+IntToStr(SNMP.Reply.ValueType[i]) +' : '+ SNMP.Reply.Value[I]);
          s:=SNMP.Reply.Value[I];
          s2:=SNMP.Reply.ValueOID[i];
          s2:=get_last_dig(SNMP.Reply.ValueOID[i]);
          res_port:='';
          if length(s2)=5 then
                begin
                    d1:=copy(s2,1,2);
                    d2:=copy(s2,3,1);
                    d3:=copy(s2,4,2);
                    if d3[1]='0' then d3:=d3[2];
                    if type2='' then type2:=d2;
                    if  (d2='0') or (d2='5') then res_port:='FastEthernet';
                    if  (d2='1') or (d2='6') then res_port:='GigabitEthernet';
                    if ((d1=type1) and (StrToInt(d2)-StrToInt(type2)>3))  or (d1<>type1)  then inc(num);
                    res_port:=res_port+IntToStr(num)+'/0/'+d3;

                    type1:=d1;
                    type2:=d2;
                    sp.Append(res_port+'  access vlan: '+s);
                end;
        end;
   //    Form1.memo2.Lines.Add(SNMP.Reply.ValueOID[0]+' = '+IntToStr(SNMP.Reply.ValueType[0]) +' : '+ SNMP.Reply.Value[0]);
       SNMP.Query.Clear;
       SNMP.Query.MIBAdd(SNMP.Reply.ValueOID[0], '');
       SNMP.Query.PDUType := PDUGetNextRequest;
     end;
    SNMP.Destroy;
    port162:=false;
end;

procedure TForm1.FormShow(Sender: TObject);
 var
   ln:integer;
begin
  read_setting;
  sp:=TStringList.Create;
  Numports:=TStringList.Create;
  Ports:=TStringList.Create;
  PortOn:=TStringList.Create;
  PortsName:=TStringList.Create;
  n_panel:=0;
  n_group:=0;
  if paramcount>0 then
        begin
          ln:=pos('/ip:',paramstr(1));
          if ln>0 then
           Form1.ComboBox1.Text:=copy(paramstr(1),ln+4,length(paramstr(1))-ln-3);
           //Form1.Timer2.Enabled:=true;
            Form1.Button2.Click;
        end;
  x:=0;
  y:=0;
  Form2.Chart1.LeftAxis.Minimum:=0;
  Form2.Chart1.LeftAxis.Maximum:=100;
  Form2.Chart1.LeftAxis.Automatic:= false ;

  Form2.Chart2.LeftAxis.Minimum:=0;
  Form2.Chart2.LeftAxis.Maximum:=150;
  Form2.Chart2.LeftAxis.Automatic:= false ;

  Form2.Chart3.LeftAxis.Minimum:=0;
  Form2.Chart3.LeftAxis.Maximum:=100;
  Form2.Chart3.LeftAxis.Automatic:= false ;

end;

Function get_ip(st:string):string;
 var
    s:string;
Begin
  s:=copy(st,1,Pos('-',st)-1);
if Pos('-',st)>0 then result:=copy(st,1,Pos('-',st)-1)
                 else result:=st;
end;



Procedure get_vlan;
 var
  i:integer;
  nom:string;
  
begin
  VLAN.Clear;
  VlanWithPorts.Clear;
  VoiceVlanWithPorts.Clear;
  GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,vtpVlanState,VLAN);
  For i:= 0 to VLAN.Count-1 do
   begin
    nom:=get_last_dig(Vlan[i]);
    getvlaninfo_2(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text+'@'+nom,dot1dTpFdbPort,nom,VlanWithPorts);

   end;
  For i:= 0 to VlanWithPorts.Count-1 do
   begin
    Form1.Memo2.Lines.Append(VlanWithPorts[i]);
   end;
end;

Procedure get_vlan_2;
 var
  i:integer;
  nom:string;
  NewSP:TStringList;
begin
  //NewSP:=TStringList.Create;     влан не получил через муинфо
  VLAN.Clear;
  VlanWithPorts.Clear;
  VoiceVlanWithPorts.Clear;
  GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,vtpVlanState,VLAN);
  getvlaninfo_2(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,vmVlan,nom,VlanWithPorts);
  getvlaninfo_2(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,vmVoiceVlan,nom,VoiceVlanWithPorts);
end;

Function find_port_vlan(s:string;SP:TStringList):String;
 var
   i:integer;
   temps,val:string;
   b:boolean;
Begin
  temps:='';
  b:=false;
  i:=0;
  While (not b) and (i<SP.Count) do
    begin
      val:=SP[i ];
      if Pos(s,SP[i])>0 then
       begin
         temps:=copy(val,Pos('vlan:',val)+5,length(val)- Pos('vlan:',val)-4);
         b:=true;
       end
                                   else
       inc(i);                            
    end;
  result:=temps;
end;

Procedure TForm1.Form4_open(Sender: TObject);
Begin
 Form4.ShowModal;
end;

Procedure TForm1.Form5_open(Sender: TObject);
 var
   s:string;
Begin
  //Form5.nom_port:=Copy(
  s:=TPanel(Sender).Hint;
  Form5.Caption:=Copy(s,1,Pos('Access vlan',s)-1);
  Form5.nom_port:=Copy(s,Pos('№',s)+4,length(s)-Pos('№',s)-1);
  Form5.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
 var
   i,j,k,t1:integer;
   st,en:integer;
   s,port_on,temps,temps2:string;
   Xtpl: TPanel;
   portleft,porttop:integer;
   num_cisco:integer;
   FontPanelColor:TColor;
   vlan_number:string;
begin
  Form6.ComboBox1.Items.Clear;
  if (not Form1.Timer1.Enabled) and (Form1.ComboBox1.Text<>'') then
    begin
            Form1.Button2.Caption:='Stop';
            Form2.Series1.Clear;
            Form2.Series2.Clear;
            Form2.Series3.Clear;
            Form1.Timer1.Enabled:=true;
            Form1.Timer3.Enabled:=true;
            Form1.Memo2.Lines.Clear;
            Form4.Memo1.Lines.Clear;

            For i:=1 to 4 do
              icount[i]:=0;
            Ports.Clear;
            PortOn.Clear;
            if n_panel>0 then
             For i:=0 to n_panel-1 do
              MasPanel[i].Destroy;

            if n_group>0 then
             For i:=1 to n_group do
              MasGroup[i].Destroy;

             GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ifDescr,Ports);
             GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ifOperStatus,PortOn);
             get_vlan_2;      //получить список виланов и портов
             Form4.Memo1.Lines.Append('++++ VLAN ++++');
             For i:=0 to VLAN.Count-1 do
              begin
                 temps:=get_last_dig(Vlan[i]);
                 //vlan_number:=
                 Form6.ComboBox1.Items.Append(temps);
                 Form4.Memo1.Lines.Append(temps+' : '+GetFirstSNMPvalue(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,vtpVlanName+'.'+Trim(temps)));
              end;


             j:=0;
             portleft:=-15;
             porttop:=15;
             k:=1;
             num_cisco:=1;

             MasGroup[num_cisco]:=TGroupBox.Create(Form1);
             MasGroup[num_cisco].Parent:=Form1;
             MasGroup[num_cisco].Width:=820;
             MasGroup[num_cisco].Height:=70;
             MasGroup[num_cisco].Left:=360;
             MasGroup[num_cisco].Top:=porttop;
             s:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,entPhysicalModelName+'.'+IntToStr(num_cisco)+'001','1');
             s:=get_value(s,0);
             MasGroup[num_cisco].Caption:=s;
             MasGroup[num_cisco].ShowHint:=true;
             MasGroup[num_cisco].OnClick:=Form4_open;
             s:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,sysDescr,'1');
             s:=get_value(s,0);
             s:=s+#10#13+'Uptime: '+get_value(getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,sysUpTime,'1'),0);

             temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,sysUpTime,'1');
             temps:=get_value(temps,0);
             try
              temps2:='';
              For t1:=0 to length(temps) do
               if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
               t1:=StrToInt(temps2);
               temps:=IntToStr(round(t1/1024/1024));
             except

             end;
             s:=s+#10#13+'Free memory: '+temps +'Mb';


             MasGroup[num_cisco].Hint:=s;

            For i:=0 to Ports.Count-1 do
             if (Pos('fastethernet',LowerCase(Ports[i]))>0) or (Pos('gigabitethernet',LowerCase(Ports[i]))>0) then
               begin
                 st:=Pos(ifDescr,Ports[i])+18;
                 en:=Pos(' = ',Ports[i])-1;
                 NumPorts.Append(copy(Ports[i],st,en-st+1));

                 port_on:=PortOn[i];
                 port_on:=get_value(PortOn[i],0);

                 s:=Ports[i];
                 if (Pos('gigabitethernet',LowerCase(Ports[i]))>0) then
                  begin
                     FontPanelColor:=ClYellow;
                     if Pos('gigabitethernet'+IntToStr(num_cisco),LowerCase(Ports[i]))=0  then
                      begin
                        inc(num_cisco);
                        k:=1;
                        porttop:=porttop;
                        portleft:=-25;

                        MasGroup[num_cisco]:=TGroupBox.Create(Form1);
                        MasGroup[num_cisco].Parent:=Form1;
                        MasGroup[num_cisco].Width:=820;
                        MasGroup[num_cisco].Height:=70;
                        MasGroup[num_cisco].Left:=360;
                        MasGroup[num_cisco].Top:=MasGroup[num_cisco-1].Top+90;
                        s:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,entPhysicalModelName+'.'+IntToStr(num_cisco)+'001','1');
                        s:=get_value(s,0);
                        MasGroup[num_cisco].Caption:=s;
                        Application.ProcessMessages;
                      end;  
                  end
                                                                                          else
                      begin
                         FontPanelColor:=ClBlack;
                         if Pos('fastethernet'+IntToStr(num_cisco),LowerCase(Ports[i]))=0  then
                          begin
                            inc(num_cisco);
                            k:=1;
                            porttop:=porttop;
                            portleft:=-25;
                            MasGroup[num_cisco]:=TGroupBox.Create(Form1);
                            MasGroup[num_cisco].Parent:=Form1;
                            MasGroup[num_cisco].Width:=820;
                            MasGroup[num_cisco].Height:=70;
                            MasGroup[num_cisco].Left:=360;
                            MasGroup[num_cisco].Top:=MasGroup[num_cisco-1].Top+90;
                            s:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,entPhysicalModelName+'.'+IntToStr(num_cisco)+'001','1');
                            s:=get_value(s,0);
                            MasGroup[num_cisco].Caption:=s;
                            Application.ProcessMessages;
                          end;
                      end;
                 MasPanel[j] :=TPanel.Create(Form1);
                 MasPanel[j] .Parent:=MasGroup[num_cisco];
                 MasPanel[j].Font.Color:=FontPanelColor;
                 
                 if (j) mod 2 = 0 then  portleft:=portleft+30;

                 if (j+1) mod 2 = 0 then  MasPanel[j].Top:=porttop+25
                                    else  MasPanel[j].Top:=porttop;

                 if ((k-1) mod 48 = 0) and (j>0) then portleft:=portleft+10;
                 if ((k) mod 49 = 0) and (j>0) then portleft:=portleft+10;

                 MasPanel[j].Left:=portleft;
                 MasPanel[j].Width:=25;
                 MasPanel[j].Height:=25;
                 
                 MasPanel[j].Caption:=IntToStr(k);
                 MasPanel[j].Hint:=get_value(Ports[i],0)+#10#13+'Access vlan: '+find_port_vlan(get_value(Ports[i],0),VlanWithPorts)+
                                       #10#13+'Voice vlan: '+find_port_vlan(get_value(Ports[i],0),VoiceVlanWithPorts)+
                                       #10#13+'Cisco port № : '+get_value_parrent(Ports[i]);
                 MasPanel[j].ShowHint:=true;
                 MasPanel[j].OnClick :=Form1.Form5_open;

                 if port_on='1' then MasPanel[j].Color:=ClGreen
                                else
                   if port_on='2' then MasPanel[j].Color:=ClRed
                                  else
                     if port_on='3' then MasPanel[j].Color:=ClYellow
                                    else MasPanel[j].Color:=ClGray;

                 inc(j);
                 inc(k);
               end;
               n_panel:=j;
               n_group:=num_cisco;
    end
     else
    begin
            Form1.Button2.Caption:='Start';
            Form1.Timer1.Enabled:=false;
            Form1.Timer3.Enabled:=false;

    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
  var
   i,j,k:integer;
   st,en:integer;
   s,port_on:string;
   Xtpl: TPanel;
   Memo: TMemo;
   portleft,porttop:integer;
   num_cisco:integer;
   newColor,oldColor:TColor;
   s_portOn:string;
begin
   Ports.Clear;
   PortOn.Clear;
   GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ifDescr,Ports);
   GetMySNMPinfo(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ifOperStatus,PortOn);
   j:=0;
   portleft:=360;
   porttop:=10;
   k:=1;
   num_cisco:=1;
  For i:=0 to Ports.Count-1 do
   try
       if (Pos('fastethernet',LowerCase(Ports[i]))>0) or (Pos('gigabitethernet',LowerCase(Ports[i]))>0) then
         begin
           st:=Pos(ifDescr,Ports[i])+18;
           en:=Pos(' = ',Ports[i])-1;
           NumPorts.Append(copy(Ports[i],st,en-st+1));

           port_on:=PortOn[i];
           port_on:=get_value(PortOn[i],0);

           s:=Ports[i];
           if (Pos('gigabitethernet',LowerCase(Ports[i]))>0) then
            begin
               MasPanel[j].Font.Color:=ClYellow;
               s_portOn:='GigabiteEthernet'+IntToStr(num_cisco)+'/0/'+IntToStr(k);
               if Pos('gigabitethernet'+IntToStr(num_cisco),LowerCase(Ports[i]))=0  then
                begin
                  inc(num_cisco);
                  k:=1;
                end;
            end
                                                                                    else
                begin
                   MasPanel[j].Font.Color:=ClBlack;
                   s_portOn:='FastEthernet'+IntToStr(num_cisco)+'/0/'+IntToStr(k);
                   if Pos('fastethernet'+IntToStr(num_cisco),LowerCase(Ports[i]))=0  then
                    begin
                      inc(num_cisco);
                      k:=1;
                    end;
                end;

           oldColor:=MasPanel[j].Color;
           if port_on='1' then newColor:=clGreen
                          else
             if port_on='2' then newColor:=ClRed
                            else
               if port_on='3' then newColor:=ClYellow
                              else newColor:=ClGray;
           MasPanel[j].Color:=newColor;
           if newColor<>oldColor then
            if (oldColor=clRed) then Form1.Memo2.Lines.Append('Port on ('+DateToStr(now)+' '+TimeToStr(now)+'):' + MasPanel[j].hint)
                                else Form1.Memo2.Lines.Append('Port off ('+DateToStr(now)+' '+TimeToStr(now)+'):' + MasPanel[j].hint);


           inc(j);
         end;
   except

   end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  Form1.Memo2.Lines.Append('Start refresh');
  try
    Form1.Timer1Timer(Form1);
  except

  end;
  Form1.Memo2.Lines.Append('End refresh');
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
   Form1.Button2.Click;
   Form1.Timer2.Enabled:=false;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
 var
   temps,temps2:string ;
   t1,mem_y,t1_y,t2_y:integer;
   x1:TDatetime;
   i:integer;
begin

   //cpu utilzation
             //inc(icount[1]);
             temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,cpmCPUTotalMonIntervalValue,'2');
             temps:=get_value(temps,0);
             try
              temps2:='';
              For t1:=0 to length(temps) do
               if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
              if temps2<>'' then  y:=StrToInt(temps2)
                            else y:=0;
             except

             end;
             x1:=now;
             if y<>0 then
               Form2.Series1.AddXY(x1,y);

             icount[1]:=0;
             For i:=0 to Form2.Series1.Count-1 do
              icount[1]:=icount[1]+Form2.Series1.YValues[i];
            
              // ShowMessage(TimeToStr(now- EncodeTime(1,0,0,0))) ;
             Form2.Chart1.Title.Text[0]:='CPU utilization. Среднее значение = '+IntToStr(round(icount[1]/Form2.Series1.YValues.Count+1));
             if Form2.Series1.XValue[0]<now- EncodeTime(1,0,0,0) then Form2.Series1.Delete(0);
            // if Form2.Series1.YValues.Count>720 then Form2.Series1.Delete(0);

   //free memory
             //inc(icount[2]);
             temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,Freememory,'1');
             temps:=get_value(temps,0);
             try
              temps2:='';
              For t1:=0 to length(temps) do
               if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
              if temps2<>'' then
                mem_y:=round(StrToInt(temps2)/1024/1024)
                           else
                mem_y:=0;
             except

             end;
             if mem_y<>0 then  Form2.Series2.AddXY(x1,mem_y);

             icount[2]:=0;
             For i:=0 to Form2.Series2.Count-1 do
              icount[2]:=icount[2]+Form2.Series2.YValues[i];

             if Form2.Series2.YValues.Count>720 then Form2.Series2.Delete(0);

//used memory
             //inc(icount[2]);
             temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,cpmCPUMemoryUsed,'1');
             temps:=get_value(temps,0);
             try
              temps2:='';
              For t1:=0 to length(temps) do
               if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
              if temps2<>'' then
                mem_y:=round(StrToInt(temps2)/1024/1024)
                           else
                mem_y:=0;
             except

             end;
             if mem_y<>0 then  Form2.Series5.AddXY(x1,mem_y);

             icount[5]:=0;
             For i:=0 to Form2.Series5.Count-1 do
              icount[5]:=icount[5]+Form2.Series5.YValues[i];
             Form2.Chart2.Title.Text[0]:='Memory. Среднее значение(free) = '+IntToStr(round(icount[2]/Form2.Series2.YValues.Count+1))+'. Среднее значение(used) = '+IntToStr(round(icount[5]/Form2.Series5.YValues.Count+1));

             if Form2.Series5.YValues.Count>720 then Form2.Series5.Delete(0);

    //temperature  1

             //temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ciscoEnvMonTemperatureStatusValue,'1');
            // temps:=get_value(temps,0);
             temps:=GetFirstSNMPvalue(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ciscoEnvMonTemperatureStatusValue);
             if (temps<>'no') and (temps<>'') then
               begin
                   try
                    temps2:='';
                    For t1:=0 to length(temps) do
                     if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
                   if temps2<>'' then
                    t1_y:=StrToInt(temps2)
                                else
                    t1_y:=0;
                   except

                   end;
                   if t1_y<>0 then Form2.Series3.AddXY(x1,t1_y);
                   if Form2.Series3.YValues.Count>720 then Form2.Series3.Delete(0);

                   icount[3]:=0;
                   For i:=0 to Form2.Series5.Count-1 do
                    icount[3]:=icount[3]+Form2.Series3.YValues[i];
                   
               end;

     //temperature  2
             temps:=getsnmpresult(get_ip(Form1.ComboBox1.Text),Form1.Edit2.Text,ciscoEnvMonTemperatureStatusValue,'2');
             temps:=get_value(temps,1);
             if temps<>'no' then
               begin
                   try
                    //inc(icount[4]);
                    temps2:='';
                    For t1:=0 to length(temps) do
                     if temps[t1] in ['0'..'9'] then temps2:=temps2+temps[t1];
                    if temps2<>'' then t2_y:=StrToInt(temps2)
                                  else t2_y:=0;
                   except

                   end;
                   if t2_y<>0 then Form2.Series4.AddXY(x1,t2_y);
                   if Form2.Series4.YValues.Count>720 then Form2.Series4.Delete(0);
                   icount[4]:=0;
                   For i:=0 to Form2.Series4.Count-1 do
                     icount[4]:=icount[4]+Form2.Series4.YValues[i];
               end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  dir_app:=ExtractFileDir(Application.ExeName);
  if fileexists (dir_app+'\device.txt') then
    Form1.ComboBox1.Items.LoadFromFile(dir_app+'\device.txt');
  Vlan:=TStringList.Create;
  VlanWithPorts:=TStringList.Create;
  VoiceVlanWithPorts:=TStringList.Create;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.Graphicsview1Click(Sender: TObject);
begin
 Form2.ShowModal;
end;

procedure TForm1.OIDtest1Click(Sender: TObject);
begin
Form3.Edit1.Text:=Form1.ComboBox1.Text;
Form3.Showmodal;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
Form3.Edit1.Text:=get_ip(Form1.ComboBox1.Text);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Timer1.Enabled:=false;
Form1.Timer2.Enabled:=false;
Form1.Timer3.Enabled:=false;
end;

procedure TForm1.VLAN1Click(Sender: TObject);
begin
 Form6.Show;
end;

end.


