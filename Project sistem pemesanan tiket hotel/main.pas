program pesan_kamar_hotel;
uses crt,sysutils;
type
    informasi_pribadi = record
    nama : string[90];
    nik  : string[81];
    umur : shortint;
    nomor_kredit: string;
    end;
    informasi_data = record
    tanggal : string[10];
    waktu : string[8];
    kamar : integer;
    AwalPemesanan : string[8];
    AkhirPemesanan : string[8];
    biaya : longint;
    biayaSpajak : longint;
    end;
    informasiPribadi= array [1..4] of informasi_pribadi;
    informasiData   = array [1..6] of informasi_data;
var
  day1,day2,month1,month2,year1,year2: word;
  WaktuSekarang      : TDateTime;
  WaktuAwal,WaktuAkhir: TDateTime;
  informasi_p        : informasiPribadi;
  informasi_d        : informasiData;
  PilihanKeluar      : char;
  pilihan,a            : integer;
  keluar, paksakeluar: boolean;
  Data : text;

{prosedur dan fungsi: }
function HitungPajak(biaya: longint): longint;
begin
  HitungPajak:= 0; {dasar}
  HitungPajak:= biaya div 10;
end;

procedure garis(a:char);
  const c=50;
  var b:integer;
begin 
  for b:=1 to c do
  write(a);
  writeln;
end;

procedure DataLengkapPemesanan;    
var a: integer;
begin
{Input pengguna: }
write('Masukkan nama anda: ');readln(informasi_p[1].nama);
write('Masukkan NIK anda: ');readln(informasi_p[1].nik);
write('Masukkan umur anda: ');readln(informasi_p[1].umur);
write('Masukkan nomor kredit anda: ');readln(informasi_p[1].nomor_kredit);
write('Masukkan waktu awal pesanan anda: ');readln(informasi_d[1].AwalPemesanan);
write('Masukkan waktu akhir pesanan anda: ');readln(informasi_d[1].AkhirPemesanan);

{Mempersiapkan sistem phase 2: }
Randomize;
informasi_d[1].kamar:= random(10) + 1;
WaktuSekarang:= now;
informasi_d[1].waktu:= FormatDateTime('hh:nn:ss', WaktuSekarang);
informasi_d[1].tanggal:= FormatDateTime('dd/mm/yyyy', WaktuSekarang);
if informasi_d[1].kamar in [1..5] then
  informasi_d[1].biaya:= 300000000
else 
  informasi_d[1].biaya:= 500000000;
informasi_d[1].biayaSpajak:= HitungPajak(informasi_d[1].biaya);
TryStrToDate(informasi_d[1].AwalPemesanan, WaktuAwal);
TryStrToDate(informasi_d[1].AkhirPemesanan, WaktuAkhir);
{valid(boolean):= trystrtodate}
DecodeDate(WaktuAwal, year1, month1, day1);
DecodeDate(WaktuAkhir, year2, month2, day2);
{----------------------}

assign(Data, 'Data.txt');
rewrite(Data);
for a:=1 to 101 do
    write(Data,'=');
writeln(Data);
write(Data, '|     TANGGAL ');
{15} write(Data, '|   WAKTU ');
{25} write(Data, '| KAMAR ');
{34} write(Data, '|                   PEMESANAN ');
{65} write(Data, '|        BIAYA ');
{81} write(Data, '|  BIAYA SETELAH PAJAK ');
{101} writeln(Data, '|');
for a:=1 to 101 do
    write(Data,'-');
writeln(Data);

write(Data, '| ', informasi_d[1].tanggal:12);
{15} write(Data, '| ', informasi_d[1].waktu:8);
{26} write(Data,'| ', informasi_d[1].kamar:6);
{35} write(Data, '| ',day1,'/',month1,'/',year1,' sampai ',day2,'/',month2,'/',year2);
{65} write(Data, '| ');
{79} write(Data, '| 2.000.500');
{101} writeln(Data, '|');
for a:=1 to 101 do
    write(Data,'-');
writeln(Data);

write(Data, '| NAMA : ',informasi_p[1].nama:18);
{27} write(Data, '| UMUR         : ',informasi_p[1].umur:56);{47} writeln(Data,'|');
write(Data, '| NIK  : ',informasi_p[1].nik:18);
{27} write(Data, '| NOMOR KREDIT : ',informasi_p[1].nomor_kredit:56);{47} writeln(Data,'|');
for a:=1 to 101 do
    write(Data,'=');
writeln(Data);
close(Data);
end;

procedure HubungiAdmin;
begin
  writeln('   Nomor telepon: +628563793563');
  writeln('   Email: hotelsentosa@gmail.com');
end;

procedure ketentuan;
begin
  writeln('   1. check-in mulai dari jam (13.00 siang) sampai (12.00 siang)(23 jam)');
  writeln('   2. batas check-out jam (12.00 siang)');
  writeln('   3. check-in dan check-out disesuaikan jam pesanan');
  writeln('   4. jika check-out melebihi jam (12.00 siang) maka diwajibkan membayar 1 hari lagi');
  writeln('   5. jika check-in terlambat harus melakukan konfirmasi');
  writeln('   6. kerusakan pada kamar hotel yang dilakukan oleh pelanggan akan dikenakan denda');
  writeln('   7. ketidaksanggupan/kegagalan membayar denda akan dikenakan black-list seluruh hotel di indonesia');
end;

{tambahan: }
procedure Ulangi(var keluar: boolean;var paksakeluar: boolean;var PilihanKeluar: char);
begin
write('Anda ingin mengulang lagi? (y/t) : ');read(PilihanKeluar);
if PilihanKeluar in ['y','Y'] then keluar:=false
 else if PilihanKeluar in ['t','T'] then keluar:=true
 else paksakeluar:=true;

if PilihanKeluar in ['y','Y'] then clrscr;
  if paksakeluar then write('Kami anggap anda tidak ingin, ');
  if paksakeluar then keluar:=true;
  if keluar then write('Sampai jumpa');
end;

  {program utama: }  
begin
{deklarasi awal: }
keluar:= false;
paksakeluar:= false;

{Menu Utama: }
repeat
clrscr;
garis('=');
writeln('HOTEL AMAN SENTOSA');
writeln('Menu kamar: ');
writeln('1.kamar deluxe, anti bocor suara');
writeln('2.kamar reguler, suara menggelegar');
garis('-');
writeln(' Pilihan: ');
writeln('1. Pesan kamar');
writeln('2. Cek Ketersediaan Kamar');
writeln('3. Cetak Struk/Riwayat Pemesanan');
writeln('4. Informasi Hotel/Fasilitas Hotel');
writeln('5. ketentuan');
writeln('6. FAQ');
writeln('7. Ulasan');
garis('-');

{sistem: }
write('Masukkan pilihan: ');readln(pilihan);
if ((pilihan > 0)and(pilihan < 7)) then
case pilihan of
    1: DataLengkapPemesanan;
    6: HubungiAdmin;
    5: ketentuan;
    end
else writeln('Input tidak valid');

Ulangi(keluar,paksakeluar,PilihanKeluar);
readln;
until keluar
end.
