program pesan_kamar_hotel;
uses crt,sysutils;
{$GOTO ON}
type
    waktu= TDateTime;
    informasi_pribadi = record
    nama : string[90];
    nik  : string;
    umur : string;
    nomor_kredit: string;
    end;
    informasi_data = record
    tanggal : string[10];
    waktu : string[8];
    kamar : string;
    AwalWaktuPesan : string[11];
    AkhirWaktuPesan : string[11];
    Biaya, BiayaSpajak: string;
    end;
    informasi_tanggal = record
    AwalPemesanan : string[11];
    AkhirPemesanan : string[11];
    end;
    informasiTanggal   = array [1..40] of informasi_tanggal;
var
  WaktuSekarang       : waktu;
  informasi_p         : informasi_pribadi;
  informasi_d         : informasi_data;
  informasi_t         : informasiTanggal;
  pemanduStr          : string;
  pilihan,posisiSalah,pemanduA : integer;
  keluar              : boolean;
  ulang               :  char;
label UlangAwal,Penutup;

{Prosedur dan fungsi: }
{Prosedur/fungsi Alat: }
procedure garis(a:char);
  const c=70;
  var b:integer;
begin 
  for b:=1 to c do
  write(a);
  writeln;
end;

function NamaAsing(nama: string): boolean;
var 
  a,c: integer;
  b: array [1..40] of string;
label Penutup;
begin
c:= 0;
if (nama = '') or (length(nama) = 1) then
  begin
  NamaAsing:= true;
  goto Penutup;
  end;
for a:=0 to 9 do
  begin
  NamaAsing:= false;
  c:= c + 1;
  str(a,b[c]);
  end;
b[11]:='/';b[12]:='.';b[13]:=',';b[14]:='"';b[15]:='-';b[16]:='_';b[17]:='&';b[18]:='$';b[19]:='*';
b[20]:=';';b[21]:=':';b[22]:='[';b[23]:=']';b[24]:='{';b[25]:='(';b[26]:=')';b[27]:='#';b[28]:='?';
b[29]:='@';b[30]:='1';b[31]:='`';b[32]:='~';b[33]:='^';b[34]:='+';b[35]:='=';b[36]:='\';b[37]:='|';
b[38]:='<';b[39]:='>';b[40]:='}';
for a:=1 to 40 do
  if pos(b[a],nama) > 0 then
    begin
    NamaAsing:= true;
    break;
    end;
Penutup:
end;
