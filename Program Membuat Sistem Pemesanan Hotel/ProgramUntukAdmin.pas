program pesan_kamar_hotel_amansentosa_kel12_ADMIN;
uses crt,sysutils; // deklarasi library yang digunakan
{$GOTO ON} // perubahan pengaturan program
type // deklarasi tipe-tipe data
    informasi_pribadi = record
    nama         : string[27];
    nik          : string[16];
    umur         : string[5];
    nomor_kredit : string[16];
    end;
    informasi_data = record
    tanggal            : string[10];
    waktu              : string[8];
    kamar              : string[5];
    AwalWaktuPesan     : string[11];
    AkhirWaktuPesan    : string[11];
    Biaya, BiayaSpajak : string;
    end;
    informasi_tanggal= record
    AwalPemesanan  : string[11];
    AkhirPemesanan : string[11];
    end;
    informasiTanggal = array [1..40] of informasi_tanggal;
var // deklarasi variabel
  WaktuSekarang       : TDateTime;
  informasi_p         : informasi_pribadi;
  informasi_d         : informasi_data;
  informasi_t         : informasiTanggal;
  pemanduStr,password : string;
  pilihan,posisiSalah,pemanduA : integer;
  keluar              : boolean;
  ulang               : char;
label UlangAwal,Penutup; // deklarasi label

{prosedur dan fungsi: }
{prosedur/fungsi alat: }
function cekPassword(password: string): boolean; // memeriksa kode akses pengguna
begin
cekPassword:= false; {Inisialisasi}
if password = 'KamarGacor69' then // jika password adalah 'KamarGacor69'..
  cekPassword:= true; // maka valid
end;

procedure garis(a:char); // membuat garis\menulis satu karakter sebanyak c yaitu 70 karakter
  const c=70;
  var b:integer;
begin 
  for b:=1 to c do
  write(a);
  writeln;
end;

procedure menghapus(karakter: char;var variabel: string);
begin 
  while pos(karakter,variabel) > 0 do // selama 'karakter' ditemukan pada variabel, lakukan..
    delete(variabel,pos(karakter,variabel),1); // hapus karakter tersebut
end;

function HitungPajak(biaya: double): double;// menghitung pajak yaitu 10% dari biaya
begin
  HitungPajak:= 0; {dasar / base}
  HitungPajak:= biaya / 10;
end;

// fungsi untuk mendeteksi jumlah karakter dan karakter terlarang di variabel nama
function NamaAsing(nama: string): boolean; // jika true maka invalid, sebaliknya maka valid
var 
  a,c: integer;
  b: array [1..40] of string;
label Penutup;
begin
c:= 0; NamaAsing:= false; {inisialisasi}
if (nama = '') or (length(nama) = 1) then // jika karakter nama kurang dari 1..
  begin
  NamaAsing:= true; // maka invalid\nama adalah asing
  goto Penutup; // teleportasi ke label 'Penutup'
  end;
for a:=0 to 9 do
  begin
  c:= c + 1; // pemandu array b
  str(a,b[c]); {inisialisasi array b, yaitu menampung angka}
  end;
b[11]:='/';b[12]:='.';b[13]:=',';b[14]:='"';b[15]:='-';b[16]:='_';b[17]:='&';b[18]:='$';b[19]:='*';
b[20]:=';';b[21]:=':';b[22]:='[';b[23]:=']';b[24]:='{';b[25]:='(';b[26]:=')';b[27]:='#';b[28]:='?';
b[29]:='@';b[30]:='1';b[31]:='`';b[32]:='~';b[33]:='^';b[34]:='+';b[35]:='=';b[36]:='\';b[37]:='|';
b[38]:='<';b[39]:='>';b[40]:='}'; // menginisialisasi karakter yang terlarang
for a:=1 to 40 do
  if pos(b[a],nama) > 0 then // jika array b ditemukan pada variabel..
    begin
    NamaAsing:= true; // maka invalid
    break; // hentikan loop
    end;
Penutup:
end;

function HitungHariRekur(hari,bulan,tahun: integer): double;// (rekursif) mengkonversi tanggal menjadi hari
begin 
if (hari = 0) AND (bulan = 0) AND (tahun = 0) then // jika telah selesai menghitung..
  HitungHariRekur:= 0 // {base/dasar} hentikan rekursif
else if bulan > 0 then // jika bulan belum sepenuhnya dikonversi.. konversi bulan
  begin
  case bulan of
    1,3,5,7,8,10,12: // bulan dengan 31 hari..
      HitungHariRekur:= 31 + HitungHariRekur(hari,bulan - 1,tahun);
    4,6,9,11: // bulan dengan 30 hari..
      HitungHariRekur:= 30 + HitungHariRekur(hari,bulan - 1,tahun);
    2: // jika bulan februari..
      begin
      if tahun mod 4 > 0 then // jika bukan tahun kabisat..
        HitungHariRekur:= 28 + HitungHariRekur(hari,bulan - 1,tahun) // hari = 28
      else // jika tahun kabisat..
        HitungHariRekur:= 29 + HitungHariRekur(hari,bulan - 1,tahun); // hari = 29
      end;
    end; // endcaseof
  end
else if tahun > 0 then // jika tahun belum sepenuhnya dikonversi.. konversi tahun
  begin
  if tahun mod 4 > 0 then // jika bukan tahun kabisat..
    HitungHariRekur:= 365 + HitungHariRekur(hari,bulan,tahun - 1) // hari = 365
  else // jika tahun kabisat..
    HitungHariRekur:= 365 + HitungHariRekur(hari,bulan,tahun - 1); // hari = 366
  end
else if hari > 0 then // konversi hari
  HitungHariRekur:= hari + HitungHariRekur(0,bulan,tahun);
end; // ada cara yang lebih mudah dan simple, tapi rekursif digunakan untuk pelajaran

procedure cekNama(var nama:string;var valid: boolean);// format awal:'saya benar', akhir:'SayaBenar'
var 
    d: array [1..25] of integer;
    e: string;
    a,b,c : integer;
begin
c:=1; a:=0; valid:= true; {inisialisasi}
if length(nama) > 25 then // jika panjang nama lebih dari 25 karakter.. maka invalid
  begin
  valid:= false;
  Textcolor(red);
  write('Nama terlalu panjang!');
  Textcolor(white); 
  writeln(' harus lebih dari 1 karakter dan harus dibawah 25 karakter.');
  end;
if valid then // jika valid..
  if NamaAsing(nama) then // jika prosedur 'NamaAsing' menghasilkan nilai true.. maka invalid
    begin
    valid:= false;
    Textcolor(red);
    write('Nama tidak valid!');
    Textcolor(white);
    writeln(' gunakan huruf saja!'); 
    end;
if valid then // jika valid..
  begin
  nama:= lowercase(nama); // mengubah seluruh karakter menjadi kecil
  e:= copy(nama,1,1); // mensalin angka pertama ke array..
  e:= upcase(e); // lalu menjadikannya huruf kapital
  delete(nama,1,1); // menghapus angka pertama..
  insert(e,nama,1); // menggantinya dengan array huruf kapital
  while pos(' ',nama) > 0 do //--jika terdapat spasi maka..
    begin
    a:=a+1; // hitung jumlah spasi
    d[a]:= pos(' ',nama); // menyimpan lokasi spasi pada array d
    delete(nama,pos(' ',nama),1);//--menghapus spasi tersebut
    end;
  if a > 0 then // jika jumlah spasi > 0 maka..
    for b:=a downto 1 do //--dari lokasi spasi terbelakang ke yang terdepan..
      begin
      c:=c+1; // pedoman untuk upcase atau huruf kapital
      e:= copy(nama,d[b],1); // ambil huruf didepan spasi atau dilokasi spasi..
      e:= upcase(e); // jadikan huruf kapital..
      delete(nama,d[b],1); // hapus huruf tersebut
      insert(e,nama,d[b]); // ganti menjadi huruf kapital pada array
      end; // format akhir 'nama saya':='NamaSaya'
  if (nama = '') or (length(nama) = 1) then // setelah penghapusan spasi.. jika jumlah karakter dibawah 1.. invalid
    begin
    valid:= false;
    Textcolor(red);
    write('Nama tidak valid!');
    Textcolor(white);
    writeln(' harus lebih dari 1 karakter dan gunakan huruf saja!'); 
    end;
  end;
end;

procedure cekUmur(umur: string;var valid: boolean); // mengecek umur
var 
    umurInt, PosisiSalah: integer;
begin
valid:= true; {inisialisasi}
menghapus(' ',umur); // menghapus spasi jika ada
val(umur, umurInt, PosisiSalah); //coba konversi ke angka\integer
if length(umur) > 5 then // jika karakter umur lebih dari 5.. maka invalid
  begin
  valid:= false;
  Textcolor(red);
  write('Umur anda terlalu tinggi! ');
  Textcolor(white);    
  end;
if valid then // jika valid..
  if PosisiSalah > 0 then // jika ada yang gagal dikonversi ke angka.. maka invalid
    begin
    valid:= false;
    Textcolor(red);
    write('Umur harus angka! ');
    Textcolor(white);
    end;
if valid then // jika valid..
  begin
  if umurInt < 18 then // jika dibawah umur legal\dibawah 18.. maka invalid
    begin
    valid:= false;
    Textcolor(red);
    writeln('Anda masih dibawah umur! tidak sesuai dengan syarat dan ketentuan');
    Textcolor(white);
    end
  else if umurInt < 0 then // selain itu, jika umur dibawah 0.. maka invalid
    begin
    valid:= false;
    Textcolor(red);
    write('Umur tidak boleh negatif! ');
    Textcolor(white);
    end
  else if umurInt > 7000 then // selain itu, jika umur diatas 7000.. maka invalid {mohon maaf..}
    begin
    valid:= false;
    Textcolor(red);
    write('Umur anda terlalu tinggi! ');
    Textcolor(white);    
    end;
  end;
end;

//mengecek kredit, dan NIK. pemanggilan menggunakan 'nama', 'variabel', 'jumlah karakter', 'variabel "valid"'
procedure cekInteger(nama: string;variabel: string;jumlah: integer;var valid: boolean);
var 
    b: qword;
    PosisiSalah: integer;
begin
valid:= true; {inisialisasi}
menghapus(' ',variabel); // menghapus spasi jika ada
  if length(variabel) <> jumlah then // jika jumlah karakter 'variabel' berbeda dengan 'jumlah karakter'..
    begin
    valid:= false; // maka invalid
    Textcolor(red);
    writeln(nama,' harus ',jumlah,' angka!');
    Textcolor(white);
    end
  else
    begin
    val(variabel, b, PosisiSalah); // coba konversi ke angka\integer..
    if PosisiSalah > 0 then // jika tidak bisa.. maka invalid
      begin
      valid:= false;
      Textcolor(red);
      writeln(nama, ' harus angka!');
      Textcolor(white);        
      end;
    end;
end;

// khusus melarang pengguna mengecek kredit pemesan yang membayar tunai
procedure cekKredit(kredit: string;var valid: boolean);
begin
if kredit = '0000000000000000' then //0 enam belas angka adalah mereka yang membayar tunai
  begin
  valid:= false;
  Textcolor(red);
  write('Nomor kredit invalid! ');
  Textcolor(white);
  end;
end;

// mengecek tanggal lagi setelah prosedur 'konversiTanggal'. apakah tanggal valid sesuai kalender?
// pengecekan ini menghentikan error dan lebih baik dari cek IOresult, karena tidak menghentikan keseluruhan prosedur
procedure cekTanggal(hari,bulan,tahun: string;var valid: boolean);
var
  hariInt,bulanInt,tahunInt: integer;
begin
valid:= true;
val(hari,hariInt); // mengubah hari menjadi angka\integer
val(bulan,bulanInt); // mengubah bulan menjadi angka\integer
val(tahun,tahunInt); // mengubah tahun menjadi angka\integer
if tahunInt < 10 then // jika tahun kurang dari 10.. maka Invalid
  valid:= false;
if valid then // jika valid..
  if hariInt < 1 then // jika hari kurang dari 1.. maka invalid
    valid:= false;
if valid then //jika valid.. maka jalankan caseof
  case bulanInt of
    1,3,5,7,8,10,12: //--jika bulan memiliki 31 hari..
      if hariInt > 31 then //--jika hari lebih dari itu.. maka invalid
        valid:= false;
    4,6,9,11: //--jika bulan memiliki 30 hari..
      if hariInt > 30 then //--jika hari lebih dari itu.. maka invalid
        valid:= false;
    2: //--jika bulan adalah february..
      begin
      if (tahunInt mod 4 = 0) then // jika tahun adalah kabisat.. (2)
        begin
        if hariInt > 29 then // jika hari lebih dari 29.. maka invalid
          begin
          valid:= false;
          end;
        end
      else // selain itu.. (2)
        if hariInt > 28 then //--jika hari lebih dari 28.. maka invalid
          valid:= false;
      end;
    otherwise //--selain itu..
      valid:= false; //--maka invalid
    end;{endcaseof}
if not valid then // jika valid = false\invalid maka..
  begin
  Textcolor(red);
  write('Tanggal harus valid! '); // cetak kalimat ke program
  Textcolor(white);
  end;
end;

// mengecek tanggal setelah 'konversiTanggal' dan 'cekTanggal'
// jika parameter 'pilihan' adalah 2 maka tanggal awal tidak boleh kurang dari tanggal hari ini
procedure cekTanggalAwalAkhir(hari,bulan,tahun,hari2,bulan2,tahun2: string;var valid: boolean;kata,kata2: string;pilihan: integer);
begin
valid:= true; {inisialisasi}
if pilihan = 2 then //--jika pilihan = 2 maka..
  if StrToDate(hari +'/'+ bulan +'/'+ tahun,'dd/mm/yyyy','/') <
      StrToDate(DateToStr(WaktuSekarang)) then //--jika tanggal awal pemesanan kurang dari tanggal sekarang.. maka invalid
      begin
      valid:= false;
      Textcolor(red);
      writeln(kata);
      Textcolor(white);
      end;
if valid then //--jika valid dan apapun angka 'pilihan'..
  if (StrToDate(hari +'/'+ bulan +'/'+ tahun,'dd/mm/yyyy','/') >=
      StrToDate(hari2 +'/'+ bulan2 +'/'+ tahun2,'dd/mm/yyyy','/')) then // jika tanggal awal kurang atau sama dengan tanggal akhir..
      begin
      valid:= false; //--maka invalid
      Textcolor(red);
      writeln(kata2);
      Textcolor(white);
      end;
end;

//mengkonversi dan mengecek tanggal, apakah seluruh tanggal berupa angka? apakah jumlah tanggal sesuai?
procedure konversiTanggal(var tanggal,hari,bulan,tahun: string;var valid: boolean);
begin
valid:= true; {inisialisasi}
menghapus('/',tanggal);menghapus(' ',tanggal);menghapus('-',tanggal);//Menormalisasi format, menghapus (/, ,-)
// format normal tanggal 'ddmmyyyy' agar bisa disalin
cekInteger('Tanggal',tanggal,8,valid); // jika jumlah karakter tanggal lebih dari 8.. maka invalid
if valid then //--jika valid..
  begin
  hari:=copy(tanggal,1,2); // mengambil jumlah hari dari 2 karakter pertama
  bulan:=copy(tanggal,3,2); // mengambil jumlah bulan dari 2 karater selanjutnya
  tahun:=copy(tanggal,5,4); //--mengambil jumlah tahun dari 4 karakter selanjutnya
  end;
end;

function rekursifBiaya(biaya: string; length,posisi: integer): string; // (rekursif) memasukkan titik ke biaya
begin // awal nilai 'posisi' adalah 0 (cetak/cek karakter 'biaya' dan titik dari kanan ke kiri 'biaya')
if posisi = length then // {base/dasar} jika posisi berada di karakter 0 (sudah mengambil karakter pertama kiri).. maka berhenti
  rekursifBiaya:='' 
else if (posisi in [3,6,9,12]) AND (not(posisi = length)) then
  begin // jika posisi di karakter ke 4,7,10,11 dari paling kanan biaya.. beri titik
  rekursifBiaya:= rekursifBiaya(biaya,length,posisi + 1) + biaya[length - posisi] + '.'; // karakter paling kanan (length - 0)
  end
else // selain itu.. tambah karakter pada biaya
  begin
  rekursifBiaya:= rekursifBiaya(biaya,length,posisi + 1) + biaya[length - posisi];
  end;
end; // jika tidak menggunakan rekursif, akan mudah.. tetapi tetap digunakan untuk tujuan pembelajaran

{mengkonversi biaya hasil hitung menjadi string dan menambahkan titik pembatas angka agar mudah dibaca dan sesuai standar}
procedure konversiBiaya(biaya,biayaSPajak: double;var biayaStr,biayaSPajakStr: string);
begin
str(biaya:0:0,biayaStr); //--mengkonversi biaya dan biaya setelah pajak menjadi str
str(biayaSPajak:0:0,biayaSPajakStr); //--
biayaStr:= biayaStr + '000000';
if length(biayaStr) < 13 then // jika panjang biaya kurang dari 13 karakter.. (tidak diberi titik jika > 12, agar muat pada data)
  biayaStr:= rekursifBiaya(biayaStr,length(biayaStr),0); // tambahkan titik pada biaya
biayaSPajakStr:= biayaSPajakStr + '000000';
if length(biayaSPajakStr) < 13 then // jika panjang biaya kurang dari 13 karakter..
  biayaSPajakStr:= rekursifBiaya(biayaSPajakStr,length(biayaSPajakStr),0); // tambahkan 6 angka nol, yaitu ratusan dan ribuan pada biaya Set pajak
end;// format akhir = 100.300.000.000 atau 1100300000000

{membuka 'Sedia.txt' (kondisi kamar terisi/tidak) dan menghitung jumlah kamar kosong dan kamar berisi, Deluxe dan juga Biasa}
procedure cekKetersediaan(var Sedia: text;var kosongBi,adaBi,kosongDe,adaDe: integer;
          var b: array of integer);
var
  simbol: char;
  a: integer;
begin
assign(Sedia,'Sedia.txt'); // menyatukan variabel dengan file
reset(Sedia); // membuka file untuk dibaca
for a:=1 to 10 do {menginisialisasi array b}
  b[a]:=0;
a:=0; {inisialisasi}
while not eof(Sedia) do // selama belum mencapai end of file pada sedia..
  begin
    readln(Sedia,simbol); // baca simbol (penanda adanya data)
    if simbol in ['$'] then //--jika simbol adalah '$'..
      begin
      a:=a+1; // pemandu array b
      kosongBi:= kosongBi + 1; // jumlah kamar kosong biasa ditambah 1
      b[a]:=a; //--array menampung lokasi kamar yang kosong
      end;
    if simbol in ['*'] then //--jika simbol adalah '*'..
      begin
      a:=a+1;
      adaBi:= adaBi + 1; //--jumlah kamar terisi biasa ditambah 1 (untuk kamar deluxe diulangi perintah ini)
      end;
    if simbol in ['&'] then //--jika simbol adalah '&'..
      begin
      a:=a+1;
      kosongDe:= kosongDe + 1; // jumlah kamar kosong Deluxe ditambah 1
      b[a]:=a; //--array menampung lokasi kamar yang kosong
      end;
    if simbol in ['#'] then //--jika simbol adalah '#'..
      begin
      a:=a+1;
      adaDe:= adaDe + 1; //--jumlah kamar terisi Deluxe ditambah 1
      end;
  end;
close(Sedia); // menutup file 'sedia'
end;

procedure Ulangi(var keluar: boolean); // prosedur mengulangi program dan kembali ke menu utama
var 
  paksakeluar: boolean;
  PilihanKeluar: char;
begin
paksakeluar:= false; {inisialisasi}
write('Anda ingin mengulang lagi? (y/t) : ');read(PilihanKeluar); // input
if PilihanKeluar in ['y','Y'] then // jika input 'Y'\'y'.. maka tidak keluar
  keluar:=false 
else if PilihanKeluar in ['t','T'] then //jika input 'T'\'t'.. maka keluar
  keluar:=true 
else
  paksakeluar:=true; // jika input selain 'Y','y','T','t'.. maka dipaksa keluar

if paksakeluar then
  write('Kami anggap anda tidak ingin, '); // kalimat jika dipaksa keluar
if paksakeluar then 
  keluar:=true; // jika 'paksakeluar'.. maka 'keluar'
if keluar then
  write('Sampai jumpa'); // kalimat jika 'keluar'
end;

procedure cetakInvalid(opsi,opsi2,opsi3: integer;var ulang: char);// jika 'pilihan' invalid
begin
case opsi of // cetak pesan 'invalid'
  1:
    begin
    Textcolor(red); // mengubah warna text selanjutnya menjadi merah
    write('Pilihan Invalid!');
    Textcolor(white); // mengubah warna text selanjutnya menjadi putih kembali
    end;
  2:
    begin
    Textcolor(red);
    write('Pilihan harus angka!');
    Textcolor(white);
    end;
  end;
case opsi2 of // meneruskan pesan 'invalid' atau lainnya
  1: write(' ulangi? (y/t) '); // opsi untuk mengulang
  2: write(' ulangi? (y/t/dari awal=1) ');
  end;
case opsi3 of // ditulis pada baris baru, setelah pesan 'invalid' diluar..
  1:          // ..prosedur ini dicetak
    write('Ulangi? (y/t) '); // opsi untuk mengulang
  2: write('Ulangi? (y/t/dari awal=1) ');
  3: write('Ulangi input? (y/t) ');
  4: write('Ulangi input? (y/t/dari awal=1) ');
  5: write('Ulangi ke input tanggal? (y/t/dari awal=1) ');
  6: write('Lanjutkan? (y/t) ');
  end; //endcaseof
if (opsi2 > 0) or (opsi3 > 0) then
  readln(ulang);
end;

{Prosedur utama: }
procedure DataLengkapPemesanan; //Pesan Kamar  
var 
    kamar,jenis,umur: integer;
    a,b,pemanduB,posisiSalah,pilihan2: integer;
    BacaBaris,awalTanggal,akhirTanggal,pemanduStr: string;
    ulang,struk,pilihan,simbol: char;
    awalTanggalInLint,akhirTanggalInLint: TDateTime;
    awalTanggalLint,akhirTanggalLint,batasWaktuLint: TDateTime;
    biaya,biayaSPajak: double;
    valid: boolean;
    kosongBi,adaBi,kosongDe,adaDe: integer;
    Data: text;
    hari1,hari2,bulan1,bulan2,tahun1,tahun2: string;
    hari1Int,hari2Int,bulan1Int,bulan2Int,tahun1Int,tahun2Int: Integer;
label
  UlangInputKamar, UlangInputJenisKamar,
  UlangInputNama, UlangInputUmur,
  UlangInputNik, UlangInputKredit,
  UlangInputTanggalSatu, UlangInputPilihan2,
  UlangInputTanggalDua,Penutup;
begin
valid:= true; pemanduB:=0;
assign(Data,'Data.txt');
informasi_d.AwalWaktuPesan:= '13:00:00';
informasi_d.AkhirWaktuPesan:= '12:00:00';
batasWaktuLint:= StrToTime('13:00:00',':'); {inisialisasi}

clrscr;
garis('=');
writeln('  PEMESANAN KAMAR OFFLINE');
garis('-');
writeln('Menu kamar: ');
writeln(' 1. Kamar Deluxe, anti bocor suara');
writeln(' 2. Kamar Biasa, suara menggelegar');
garis('-');

{Input Data: }
UlangInputPilihan2: // tunai atau transfer
write('Apakah pembelian tunai/transfer (1/2) : ');readln(pemanduStr); // input pembeli
val(pemanduStr,pilihan2,posisiSalah); // coba konversi ke angka
if posisiSalah > 0 then // jika gagal..
  begin
  Textcolor(red);
  write('Pilihan haruslah angka!'); // invalid
  Textcolor(white);
  cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan2
  else // selain itu..
    begin
    valid:= false; // invalid dan menuju penutup
    goto Penutup;
    end;
  end;
if not (pilihan2 in [1,2]) then // jika pilihan tidak ada..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan2
  else // selain itu..
    begin
    valid:= false; // invalid dan menuju penutup
    goto Penutup;
    end;
  end;

UlangInputKamar:
write('Berapa kamar yang ingin dibeli? : ');readln(pemanduStr); // input pembeli
  {cek kamar: }
val(pemanduStr,kamar,posisiSalah); // mencoba menkonversi ke integer 'kamar'
if posisiSalah > 0 then //--jika gagal konversi..
  begin
  Textcolor(red);
  write('Input kamar haruslah angka!'); // maka invalid
  Textcolor(white);
  cetakInvalid(0,1,0,ulang); // menanyakan pelanggan jika ingin mengulang kembali
  if ulang in ['y','Y'] then // jika pilihan 'ya'..
    goto UlangInputKamar // menuju label 'UlangInputKamar'
  else 
    begin
    valid:= false; // selain itu.. maka invalid..
    goto Penutup; //--dan melompat ke penutup
    end;
  end;
if kamar < 1 then //--jika jumlah kurang daru 1..
  begin
  valid:= false; // maka invalid..
  writeln('Baiklah!');
  goto Penutup; //--dan melompat ke penutup
  end;

UlangInputNama: //NAMA
write('Masukkan nama anda: ');readln(informasi_p.nama); // input Nama pembeli
    {cek nama: }
cekNama(informasi_p.nama,valid); // validasi input 'nama' dengan prosedur
if not valid then //--jika 'nama' invalid 
  begin 
  cetakInvalid(0,0,3,ulang); // (0,0,3) menanyakan pelanggan jika ingin mengulang kembali
  if ulang in ['y','Y'] then // jika input adalah 'y' atau 'Y'..
    goto UlangInputNama // maka menuju label UlangInputNama
  else 
    goto Penutup; //--selain itu.. melompat ke label penutup
  end;
    {-----------}

UlangInputNik: //NIK
write('Masukkan NIK anda: ');readln(informasi_p.nik); // input NIK pembeli
    {cek NIK: }
cekInteger('NIK',informasi_p.nik,16,valid); // memeriksa kevalidan 'NIK'
if not valid then //--jika invalid..
  begin 
  cetakInvalid(0,0,4,ulang); // (0,0,4) menanyakan pelanggan jika ingin mengulang kembali
  if ulang in ['y','Y'] then // jika input adalah 'Y' atau 'y'..
    goto UlangInputNik // maka kembali menginput 'NIK'
  else if ulang in ['1'] then // jika input adalah '1'..
    goto UlangInputNama // maka kembali ke label UlangInputNama atau kembali menginput nama
  else 
    goto Penutup; //--selain itu.. melompat ke label penutup
  end;
    {-----------}

UlangInputUmur: //UMUR
write('Masukkan umur anda: ');readln(informasi_p.umur); // input umur pembeli
    {cek umur: }
cekUmur(informasi_p.umur,valid); // memeriksa kevalidan 'umur'
if not valid then //--jika invalid..
  begin 
  cetakInvalid(0,0,4,ulang); // menanyakan pelanggan jika ingin mengulang kembali
  if ulang in ['y','Y'] then // jika pilihan 'y' atau 'Y' maka kembali menginput 'umur'
    goto UlangInputUmur
  else if ulang in ['1'] then // jika pilihan '1' maka kembali ke menginput 'nama'
    goto UlangInputNama
  else
    goto Penutup; //--selain itu maka menuju Penutup
  end;
    {-----------}

UlangInputKredit: //KREDIT
write('Masukkan nomor kredit anda: ');readln(informasi_p.nomor_kredit); // input 'nomor kredit'
    {cek kredit: }
cekInteger('Nomor Kredit',informasi_p.nomor_kredit,16,valid); // validasi kredit
if valid then
  cekKredit(informasi_p.nomor_kredit,valid); // jika valid, maka memeriksa jika kredit bernomor '0' 16 angka
if not valid then //--jika invalid..
  begin 
    cetakInvalid(0,0,4,ulang); // menanyakan pelanggan jika ingin mengulang kembali
    if ulang in ['y','Y'] then // jika ya.. maka menginput kembali kredit
      goto UlangInputKredit
    else if ulang in ['1'] then // jika pilihan 'dari awal=1' maka kembali ke menginput 'nama'
      goto UlangInputNama
    else
      goto Penutup; // selain itu.. menuju penutup
  end;
    {-----------}
Penutup: // (label penutup) ditempatkan disini karena bug, program tidak bisa melewati 'FOR..TO' dibawah ini
if valid then // jika valid.. (setiap input yang salah menyebabkan valid:=false)
  for b:=1 to kamar do // pembeli tidak lagi menginput data pribadi, sekarang input data pemesanan sampai jumlah kamar..
    begin              // ..yang dibeli
    pemanduB:= pemanduB + 1; // pemandu array 'informasi_tanggal', karena pencacah 'FOR..TO' rentan mengalami bug
    UlangInputJenisKamar:
    write('Pilih kamar jenis Deluxe atau Biasa (1/2) / keluar(3) : ');readln(pemanduStr); // input jenis kamar
    val(pemanduStr,jenis,posisiSalah); // coba konversi ke integer 'jenis'
    if posisiSalah > 0 then // jika ada kesalahan konversi..
      begin
      cetakInvalid(2,2,0,ulang); // (2,2,0) cetak 'pilihan invalid!' dan menanyakan jika ingin mengulang
      if ulang in ['y','Y'] then // jika ya.. menginput jenis kamar kembali
        goto UlangInputJenisKamar
      else if ulang in ['1'] then // jika input '1'.. kembali ke menginput nama
        goto UlangInputNama
      else 
        begin
        valid:= false; // selain itu, maka invalid..
        goto Penutup; // lalu menuju label penutup
        end;
      end;
    if jenis = 3 then // jika input '3', maka keluar dengan menjadikan 'valid' ke false..
      begin
      valid:= false;
      goto Penutup; // dan menuju label penutup
      end;
    if not (jenis in [1,2,3]) then // selain ketiga pilihan itu..
      begin
      Textcolor(red);
      write('Pilihan haruslah 1 atau 2!'); // maka invalid
      Textcolor(white);
      cetakInvalid(0,2,0,ulang); // (0,2,0) menanyakan pembeli jika ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. menginput kembali pilihan kamar
        goto UlangInputJenisKamar
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
        goto UlangInputNama
      else
        begin
        valid:= false; // selain itu.. invalid dan menuju penutup
        goto Penutup;
        end;
      end;
    if jenis = 1 then // menentukan nilai kamar sesuai pilihan
      informasi_d.kamar:='De' // jika pilihan '1'.. maka kamar Deluxe dipilih
    else if jenis = 2 then
      informasi_d.kamar:='Bi'; // jika pilihan '2'.. maka kamar Biasa dipilih

    UlangInputTanggalSatu: //TANGGAL AWAL
    write('Masukkan waktu awal pesanan anda (dd/mm/yyyy) : ');readln(informasi_t[pemanduB].AwalPemesanan);//input tanggal awal
        {cek dan konversi tanggal: }
    konversiTanggal(informasi_t[pemanduB].AwalPemesanan,hari1,bulan1,tahun1,valid); // mengonversi dan cek jumlah karakter tanggal
    if valid then
      cekTanggal(hari1,bulan1,tahun1,valid); // jika valid.. maka prosedur 'cekTanggal' dipanggil
    if not valid then // jika invalid..
      begin 
      cetakInvalid(0,0,4,ulang); // menanyakan jika pembeli ingin mengulangi input
      if ulang in ['y','Y'] then // jika ya.. maka menginput kembali tanggal awal
        goto UlangInputTanggalSatu
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
        goto UlangInputNama
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
        {--------------------------}

    UlangInputTanggalDua: //TANGGAL AKHIR
    write('Masukkan waktu akhir pesanan anda (dd/mm/yyyy): ');readln(informasi_t[pemanduB].AkhirPemesanan);//input tanggal akhir
        {cek dan konversi tanggal: }
    konversiTanggal(informasi_t[pemanduB].AkhirPemesanan,hari2,bulan2,tahun2,valid); // konversi sekaligus cek tanggal
    if valid then
      cekTanggal(hari2,bulan2,tahun2,valid); // mengecek secara detail kevalidan tanggal, menggantikan IOresult
    if not valid then // jika invalid..
      begin 
      cetakInvalid(0,0,4,ulang); // menanyakan pembeli jika ingin mengulang kembali
      if ulang in ['y','Y'] then // jika ya, maka menginput tanggal akhir
        goto UlangInputTanggalDua
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
        goto UlangInputNama
      else 
        goto Penutup; // selain itu.. menuju penutup
      end;
        {--------------------------}

    {Mempersiapkan sistem: }
      //cek kamar pada waktu tersebut
    cekTanggalAwalAkhir(hari1,bulan1,tahun1,hari2,bulan2,tahun2,valid,
        'Tidak boleh memesan ke masa lalu!','Tanggal awal ke akhir tidak boleh mundur atau sama!',2); // memeriksa tanggal..
    if not valid then //jika invalid..     // ..awal dan akhir, (2) artinya tanggal awal tidak boleh kurang dari tanggal sekarang
      begin
      cetakInvalid(0,0,4,ulang); // menanyakan pembeli jika ingin mengulang kembali 
      if ulang in ['y','Y'] then // jika ya.. maka kembali ke menginput tanggal awal pemesanan (2)
        goto UlangInputTanggalSatu
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama (2)
        goto UlangInputNama
      else
        goto Penutup; // selain itu.. invalid dan menuju penutup (2)
      end
    else // selain itu..
      begin
      informasi_t[pemanduB].AwalPemesanan:= hari1 +'/'+ bulan1 +'/'+ tahun1; // tanggal awal disatukan
      informasi_t[pemanduB].AkhirPemesanan:= hari2 +'/'+ bulan2 +'/'+ tahun2; // tanggal akhir disatukan
      end;
    awalTanggalInLint:= StrToDate(informasi_t[b].AwalPemesanan,'dd/mm/yyyy','/'); // konversi tanggal ke real 'Date'..
    akhirTanggalInLint:= StrToDate(informasi_t[b].AkhirPemesanan,'dd/mm/yyyy','/'); // .. dan menyimpannya dalam var
    adaBi:=0; kosongBi:=0; adaDe:=0; kosongDe:=0; {inisialisasi}
    reset(Data); // membuka file untuk dibaca
    while not eof(Data) do // selama file belum berakhir (belum berada di baris terakhir)..
      begin
      readln(Data, simbol); // baca baris (mengecek penanda adanya data)
      if simbol in ['$'] then // jika ditemukan '$'..
        begin
        for a:=1 to 6 do // lewati baris 1 sampai 6 data
          readln(Data);
        readln(Data,BacaBaris); // baca dan salin baris ke 7 data
        for a:=8 to 9 do // lewati sisa baris datanyaKamar
          readln(Data);
        awalTanggal:= copy(BacaBaris,37,10); // salin data 'tanggal awal'nya
        akhirTanggal:= copy(BacaBaris,55,10); // salin data 'tanggal akhir'nya
        awalTanggalLint:= StrToDate(awalTanggal,'dd/mm/yyyy','/');
        akhirTanggalLint:= StrToDate(akhirTanggal,'dd/mm/yyyy','/'); // konversi keduanya ke 'date angka' 
        if ((awalTanggalLint <= awalTanggalInLint) and (akhirTanggalLint > awalTanggalInLint)) OR //jika awal tanggal = atau < dari input awal tanggal..
          ((awalTanggalLint < akhirTanggalInLint ) and (akhirTanggalLint >= akhirTanggalInLint)) OR //..dan akhir tanggal > dari awal tanggal (true)
          ((awalTanggalLint >= awalTanggalInLint) and (akhirTanggalLint <= akhirTanggalInLint)) then //jika awal tanggal < dari input akhir tanggal..
            begin                                                                //..dan akhir tanggal lebih atau sama dengan input tanggal (true)
            if pos('De',BacaBaris) > 0 then // jika keterangan kamar=Deluxe..    // jika awal tanggal lebih atau sama dengan input awal tanggal..
              adaDe:= adaDe + 1; // maka jumlah kamar terisi De ditambah 1       //..dan akhir tanggal kurang atau sama dengan input akhir tanggal (true)
            if pos('Bi',BacaBaris) > 0 then //jika keterangan kamar=Biasa..
              adaBi:= adaBi + 1; // maka jumlah kamar terisi Biasa ditambah 1
            if (pos('De',BacaBaris) = 0) AND (pos('Bi',BacaBaris) = 0) then // jika keterangan adalah angka..
              begin
              pemanduStr:=copy(BacaBaris,33,2);
              val(pemanduStr,kamar,posisiSalah); // angka disalin dan dikonversi ke angka
              if kamar > 5 then // jika nomor kamar lebih dari 5.. maka terisi Delux ditambah 1
                adaDe:= adaDe + 1
              else
                adaBi:= adaBi + 1; // selain itu.. kamar adalah Biasa, dan terisi Biasa ditambah 1
              end;
            end;
        end;
      end;//endwhile
    close(Data); // menutup data
    kosongDe:= 5 - adaDe ; 
    kosongBi:= 5 - adaBi; {inisialisasi}
    if (adaDe > 4) AND (adaBi > 4) then // jika kamar penuh pada tanggal tersebut.. maka invalid
      begin
      write('Dalam jadwal tersebut, ');
      Textcolor(red); // ubah warna teks
      write('seluruh kamar penuh!');
      Textcolor(white); // mengembalikan warna teks
      cetakInvalid(0,2,0,ulang); // menanyakan pembeli jika ingin mengulang kembali
      if ulang in ['y','Y'] then // jika ya, maka kembali ke menginput tanggal awal pemesanan
        goto UlangInputTanggalSatu
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
        goto UlangInputNama
      else
        begin
        valid:= false; // selain itu.. invalid dan menuju label penutup
        goto Penutup;
        end;
      end;
    if informasi_d.kamar = 'De' then // jika seluruh kamar tidak penuh, dan pilihan kamar adalah deluxe.. maka
      if (adaDe > 4) AND (adaBi < 5) then // jika kamar Deluxe penuh tetapi kamar Biasa tersedia.. maka invalid
        begin
        write('Dalam jadwal tersebut, ');
        Textcolor(red); // ubah warna teks
        write('kamar Deluxe penuh');
        Textcolor(white); // mengembalikan warna teks
        write('! tetapi ');
        Textcolor(green); // ubah warna teks
        write('kamar Biasa tersisa');
        Textcolor(white); // mengembalikan warna teks
        write('(');
        Textcolor(green); // ubah warna teks
        write(kosongBi);
        Textcolor(white); // mengembalikan warna teks
        writeln(')'); // 'Dalam jadwal tersebut, kamar Deluxe penuh! tetapi kamar Biasa tersisa (..)'
        cetakInvalid(0,0,5,ulang); // menanyakan pembeli jika ingin mengulang kembali
        if ulang in ['y','Y'] then // jika ya, maka kembali ke menginput tanggal awal
          goto UlangInputTanggalSatu
        else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
          goto UlangInputNama
        else
          begin
          valid:= false; // selain itu.. invalid dan menuju label penutup
          goto Penutup;
          end;
        end;
    if informasi_d.kamar = 'Bi' then // lalu jika jenis kamar adalah Biasa..
      if (adaDe < 5) AND (adaBi > 4) then // dan jika kamar Biasa penuh dan kamar Deluxe tersedia.. maka invalid
        begin
        write('Dalam jadwal tersebut, ');
        Textcolor(red); // ubah warna teks
        write('kamar Biasa penuh');
        Textcolor(white); // mengembalikan warna teks
        write('! tetapi ');
        Textcolor(green); // ubah warna teks
        write('kamar Deluxe tersisa');
        Textcolor(white); // mengembalikan warna teks
        write('(');
        Textcolor(green); // ubah warna teks
        write(kosongDe);
        Textcolor(white); // mengembalikan warna teks
        writeln(')'); // 'Dalam jadwal tersebut, kamar Biasa penuh! tetapi kamar Deluxe tersisa (..)'
        cetakInvalid(0,0,5,ulang); // menanyakan pembeli jika ingin mengulang kembali
        if ulang in ['y','Y'] then // jika ya, maka kembali ke menginput tanggal awal
          goto UlangInputTanggalSatu
        else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
          goto UlangInputNama
        else
          begin
          valid:= false; // selain itu.. invalid dan menuju label penutup
          goto Penutup;
          end;
        end;
      //Mencetak waktu input data
    informasi_d.waktu:= FormatDateTime('hh:nn:ss', WaktuSekarang); // menyimpan waktu sekarang pada variabel
    informasi_d.tanggal:= FormatDateTime('dd/mm/yyyy', WaktuSekarang); // menyimpan tanggal sekarang pada variabel
      //Menghitung biaya
    val(hari1,hari1Int);val(bulan1,bulan1Int);val(tahun1,tahun1Int);
    val(hari2,hari2Int);val(bulan2,bulan2Int);val(tahun2,tahun2Int); // konversi tanggal ke integer
    if informasi_d.kamar = 'Bi' then // jika jenis kamar adalah Biasa..
      biaya:= (HitungHariRekur(hari2Int,bulan2Int - 1,tahun2Int - 1) - HitungHariRekur(hari1Int,bulan1Int - 1,tahun1Int - 1)) * 300 // maka harga adalah 300jt/hari
    else if informasi_d.kamar = 'De' then // jika jenis kamar adalah Deluxe..
      biaya:= (HitungHariRekur(hari2Int,bulan2Int - 1,tahun2Int - 1) - HitungHariRekur(hari1Int,bulan1Int - 1,tahun1Int - 1)) * 500; // maka harga adalah 500jt/hari
    if biaya > 2000000000000000.0 then // jika harga terlalu banyak.. maka invalid
      begin
      write('Pesanan anda ');
      Textcolor(red); // ubah warna teks
      write('terlalu besar!');
      Textcolor(white); // mengembalikan warna teks
      writeln(' kami sarankan melakukan pembelian terpisah');
      cetakInvalid(0,0,5,ulang); // menanyakan pembeli jika ingin mengulang kembali
        if ulang in ['y','Y'] then // jika ya.. maka kembali ke menginput tanggal awal
          goto UlangInputTanggalSatu
        else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
          goto UlangInputNama
        else
          begin
          valid:= false; // selain itu.. invalid dan menuju label penutup
          goto Penutup;
          end;
        end;
    biayaSPajak:= HitungPajak(biaya) + biaya; // menghitung biaya setelah pajak
    konversiBiaya(biaya,biayaSPajak,informasi_d.Biaya,informasi_d.BiayaSpajak); // menkonversi kedua biaya agar mudah dibaca
      //kredit atau tunai
    if pilihan2 = 1 then // jika membayar secara tunai..
      informasi_p.nomor_kredit:= '0000000000000000'; // maka data kredit adalah 0 enam belas digit
    {----------------------}

    clrscr; // membersihkan layar
    val(informasi_p.umur,umur); // mencoba konversi informasi.umur menjadi integer 'umur'
    if umur >= 5000 then // easter egg jika umur lebih dari 4999 tahun.. maka ada salam spesial dari Hotel
      begin
      write('Kami ucapkan salam pada ');
      Textcolor(cyan); // mengubah warna teks selanjutnya menjadi biru muda
      write('Sepuh');
      Textcolor(white); // menyetel ulang warna teks menjadi putih atau mengembalikan warna teks asli
      write(' yang berusia ');
      Textcolor(yellow); // mengubah warna teks selanjutnya menjadi kuning
      write(umur,' tahun');
      Textcolor(white); // mengembalikan warna teks asli
      writeln('!');
      end;
      {cetak pada layar untuk konfirmasi: }   //--mencetak pada program. semua data memiliki 101 karakter
    for a:=1 to 101 do //++baris pertama adalah garis '=' sebanyak 101 karakter
        write('=');
    writeln; //++baris baru

    {1} write(  '| NAMA : ',informasi_p.nama:25); //++mencetak baris ke-dua yaitu judul serta data yang dibuat
    {35} write( '| NIK          : ',informasi_p.nik:49);{47} writeln('|'); //++
    {1} write(  '| UMUR : ',informasi_p.umur:25); //++baris ke-tiga juga sama, judul dan data
    {35} write( '| NOMOR KREDIT : ',informasi_p.nomor_kredit:49);{47} writeln('|'); //++

    for a:=1 to 101 do //++baris ke-empat adalah garis '-'
        write('-');
    writeln; //++baris baru

    write(     '| TANGGAL PESAN '); //++baris ke-lima adalah judul data
    {17} write('|  WAKTU  ');
    {27} write('| KAMAR ');
    {35} write('|           PEMESANAN         ');
    {65} write('|      BIAYA      ');
    {83} write('| BIAYA SET PAJAK ');
    {101} writeln('|'); //++

    for a:=1 to 101 do //++baris ke-enam adalah garis '-'
        write('-');
    writeln; //++baris baru

    write(     '| ', informasi_d.tanggal:14); //++baris ke-tujuh adalah data data yang dibuat
    {17} write('| ', informasi_d.waktu:8);
    {27} write('| ', informasi_d.kamar:6);
    {35} write('| ',informasi_t[pemanduB].AwalPemesanan,' sampai ',informasi_t[pemanduB].AkhirPemesanan);
    {65} write('| ',informasi_d.biaya:16);
    {83} write('| ',informasi_d.biayaSpajak:16); //++
    {101} writeln('|');

    write(       '|               |         |       '); //++baris ke-delapan yaitu baris tambahan untuk data pemesanan
    {35} write(  '| (',informasi_d.AwalWaktuPesan,')        (',informasi_d.AkhirWaktuPesan,')');
    {65} writeln('|                 |                 |'); //++

    for a:=1 to 101 do //++baris terakhir atau ke-sembilan adalah garis '='
        write('=');
    writeln; //++
    writeln;

    {konfirmasi Pembelian: }
    if (awalTanggalInLint = StrToDate(DateToStr(WaktuSekarang))) AND
       (batasWaktuLint < StrToTime(TimeToStr(WaktuSekarang))) then
      begin // jika tanggal awal inputan = tanggal sekarang, dan waktu sekarang melewati waktu check-In..
      write('Jam sudah melewati ');
      Textcolor(red);
      write('13:00');
      Textcolor(white);
      write(', waktu yang terlewat ');
      Textcolor(yellow);
      write('akan tetap dihitung');
      Textcolor(white);
      writeln('!');
      write('Konfirmasi pembelian? (y/t) ');readln(pilihan); // input pilihan pembeli
      if not (pilihan in ['y','Y']) then // jika pilihan adalah tidak..
        begin
        valid:= false; // maka invalid dan menuju penutup
        goto Penutup;
        end;
      end
    else // selain itu..
      begin
      Textcolor(yellow); // text konfirmasi berwarna kuning
      write('Konfirmasi pembelian? (y/t) ');readln(pilihan); // input pilihan pembeli
      Textcolor(white);
      if not (pilihan in ['y','Y']) then // jika pilihan adalah tidak..
        begin
        valid:= false; // maka invalid dan menuju penutup
        goto Penutup;
        end;
      end;
    if pilihan2 = 2 then // jika pembayaran ditransfer..
      begin
      Textcolor(yellow);
      for a:=5 downto 1 do // countdown
        begin
        write('Pembayaran selesai dalam ',a);
        delay(1250);
        gotoxy(1,wherey); // untuk mengupdate kalimat countdown pada baris tersebut
        end;
      Textcolor(green);
      writeln('Pembayaran telah ditransfer!    ');
      Textcolor(white);
      end;

    Append(Data); // membuka file untuk ditulis tanpa membersihkan file
    writeln(Data, '$'); // menulis simbol penanda adanya data untuk dibaca
    for a:=1 to 101 do
        write(Data,'='); //++baris pertama adalah garis '='
    writeln(Data);

    {1} write(Data,  '| NAMA : ',informasi_p.nama:25); //++mencetak baris ke-dua yaitu judul serta data yang dibuat
    {35} write(Data, '| NIK          : ',informasi_p.nik:49);{47} writeln(Data,'|'); //++
    {1} write(Data,  '| UMUR : ',informasi_p.umur:25); //++baris ke-tiga juga sama, judul dan data
    {35} write(Data, '| NOMOR KREDIT : ',informasi_p.nomor_kredit:49);{47} writeln(Data,'|'); //++

    for a:=1 to 101 do
        write(Data,'-'); //++baris ke-empat adalah garis '-'
    writeln(Data); //++

    write(Data,      '| TANGGAL PESAN '); //++baris ke-lima adalah judul data
    {17} write(Data, '|  WAKTU  ');
    {27} write(Data, '| KAMAR ');
    {35} write(Data, '|           PEMESANAN         ');
    {65} write(Data, '|      BIAYA      ');
    {83} write(Data, '| BIAYA SET PAJAK ');
    {101} writeln(Data, '|'); //++

    for a:=1 to 101 do //++baris ke-enam adalah garis '-'
        write(Data,'-'); 
    writeln(Data); //++

    write(Data,     '| ', informasi_d.tanggal:14); //++baris ke-tujuh adalah data data yang dibuat
    {17} write(Data,'| ', informasi_d.waktu:8);
    {27} write(Data,'| ', informasi_d.kamar:6);
    {35} write(Data,'| ',informasi_t[pemanduB].AwalPemesanan,' sampai ',informasi_t[pemanduB].AkhirPemesanan);
    {65} write(Data,'| ',informasi_d.biaya:16);
    {83} write(Data,'| ',informasi_d.biayaSpajak:16);
    {101} writeln(Data, '|'); //++

    write(Data,      '|               |         |       '); //++baris ke-delapan yaitu baris tambahan untuk data pemesanan
    {35} write(Data,'| (',informasi_d.AwalWaktuPesan,')        (',informasi_d.AkhirWaktuPesan,')');
    {65} writeln(Data, '|                 |                 |'); //++

    for a:=1 to 101 do//++baris terakhir atau ke-sembilan adalah garis '='
        write(Data,'='); 
    writeln(Data); //++
    writeln(Data); // memberi jarak untuk data baru nantinya
    close(Data); // menutup file

    writeln;
    Textcolor(green);
    writeln('Data telah disimpan!');
    Textcolor(white);
    write('Cetak struk? (y/t) ');readln(struk); // menanyakan jika pelanggan menginginkan struk
    if struk in ['y','Y'] then // jika ya.. maka cetak struk
      begin
      for a:=1 to 101 do // baris pertama yaitu garis '='
        write('=');
      writeln;
      writeln('Hotel Aman Sentosa Kota Palangkaraya, Keminting, Jl. Kecubung'); // baris ke-dua yaitu nama dan alamat hotel
      for a:=1 to 101 do // baris ke-tiga yaitu garis '='
        write('='); 
      writeln;

      write('| Nama Pembeli: ',informasi_p.nama); // baris ke-empat yaitu nama pembeli
      gotoxy(101,wherey);writeln('|');

      for a:=1 to 101 do // baris ke-lima adalah garis '-'
          write('-');
      writeln;

      write(     '| TANGGAL PESAN '); // baris ke-enam adalah judul data
      {17} write('|  WAKTU  ');
      {27} write('| KAMAR ');
      {35} write('|           PEMESANAN         ');
      {65} write('|      BIAYA      ');
      {83} write('| BIAYA SET PAJAK ');
      {101} writeln('|');

      for a:=1 to 101 do // baris ke-tujuh
          write('-');
      writeln;

      write(     '| ', informasi_d.tanggal:14); // baris ke-delapan
      {17} write('| ', informasi_d.waktu:8);
      {27} write('| ', informasi_d.kamar:6);
      {35} write('| ',informasi_t[pemanduB].AwalPemesanan,' sampai ',informasi_t[pemanduB].AkhirPemesanan);
      {65} write('| ',informasi_d.biaya:16);
      {83} write('| ',informasi_d.biayaSpajak:16);
      {101} writeln('|');

      write(       '|               |         |       '); // baris ke-sembilan
      {35} write(  '| (',informasi_d.AwalWaktuPesan,')        (',informasi_d.AkhirWaktuPesan,')');
      {65} writeln('|                 |                 |');

      for a:=1 to 101 do // baris ke-sepuluh
        write('=');
      writeln;
            
      end;
    if (pemanduB < kamar) AND (struk in ['y','Y']) then // jika masih tersisa kamar yang ingin dibeli dan sudah cetak struk..
      begin
      Textcolor(yellow); // ubah warna teks
      writeln('Tekan "ENTER"'); // maka menunggu tombol enter untuk melanjutkan mengisi data
      Textcolor(white); // mengembalikan warna teks
      readkey;
      end;
    end;
end; // end prosedur

procedure CekKamar; // memeriksa kondisi kamar
var 
  adaBi,kosongBi,adaDe,kosongDe,kamarInt,pilihan: integer;
  ulang: char; 
  a,b,pemanduSed,pemanduA,posisiSalah: integer;
  kosong: array [1..10] of integer;
  awalTanggalIn,akhirTanggalIn,awalTanggal,akhirTanggal,kamar,simbol: string;
  awalTanggalLint,akhirTanggalLint,awalTanggalInLint,akhirTanggalInLint: TDateTime;
  hari1,bulan1,tahun1,hari2,bulan2,tahun2,BacaBaris: string;
  valid, ketemuData10: boolean;
  Sedia,Data: text;
label UlangInputPilihan, UlangInputTanggalSatu, UlangInputTanggalDua, SelesaiCetakTanggal, Penutup;
begin
valid:= true; ketemuData10:= false;
pemanduSed:=0; pemanduA:= 0;
adaBi:=0; kosongBi:=0; adaDe:=0; KosongDe:=0; {inisialisasi}
assign(Data,'Data.txt');
assign(Sedia,'Sedia.txt'); // menghubungkan variabel kepada file
CekKetersediaan(Sedia,kosongBi,adaBi,KosongDe,adaDe,kosong); // mengecek kamar kosong dan terisi
clrscr;
garis('=');
writeln('CEK KETERSEDIAAN KAMAR');
garis('-');
writeln;
writeln('Kamar hari ini (Check-out jam 12:00):');
write(  'Kamar biasa yang tersedia : ',kosongBi);gotoxy(36,wherey);
writeln('Kamar Deluxe yang tersedia : ',kosongDe);
write(  'Kamar biasa yang terisi   : ',adaBi);gotoxy(36,wherey);
writeln('Kamar Deluxe yang terisi   : ',adaDe);
writeln;
writeln('*Note: yang akan diperiksa hanyalah penggunaan berlangsung atau mendatang!');
garis('-');
UlangInputPilihan:
write('Cek kamar pada tanggal tertentu/kamar hari ini (1/2) (Keluar = 3) : ');readln(pemanduStr);
val(pemanduStr,pilihan,posisiSalah);
if posisiSalah > 0 then // jika pilihan bukan angka..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then
    goto UlangInputPilihan
  else
    goto Penutup;
  end;
if (not(pilihan in [1,2])) then // jika pilihan adalah tidak atau selain pilihan
  valid:= false; // maka invalid
if valid then // jika valid.. maka langkah selanjutnya dilakukan
  begin
  case pilihan of // prosedur sesuai pilihan
    1: // jika pilihan adalah memeriksa kamar pada hari tertentu..
      begin
      adaBi:=0; kosongBi:=0; adaDe:=0; KosongDe:=0; {inisialisasi}
      UlangInputTanggalSatu:
      write('Masukkan tanggal pertama {Check-in jam 13:00} : ');readln(awalTanggalIn); // input tanggal awal
      {cek tanggal awal: }
      konversiTanggal(awalTanggalIn,hari1,bulan1,tahun1,valid); // konversi dan cek jumlah karakter tanggal
      if valid then // jika valid..
        cekTanggal(hari1,bulan1,tahun1,valid); // cek tanggal secara mendetail
      if not valid then // jika invalid..
        begin 
        cetakInvalid(0,0,3,ulang); // menanyakan jika penguna ingin mengulangi
        if ulang in ['y','Y'] then // jika ya.. maka kembali menginput tanggal awal
          goto UlangInputTanggalSatu
        else
          goto Penutup; // selain itu menuju penutup
        end;

      UlangInputTanggalDua:
      write('Masukkan tanggal kedua {Check-out jam 12:00} : ');readln(akhirTanggalIn); // input tanggal akhir
        {cek tanggal akhir: }
      konversiTanggal(akhirTanggalIn,hari2,bulan2,tahun2,valid); // konversi dan cek jumlah karakter tanggal
      if valid then // jika valid..
        cekTanggal(hari2,bulan2,tahun2,valid); // cek tanggal secara mendetail
      if valid then // jika valid..
        cekTanggalAwalAkhir(hari1,bulan1,tahun1,hari2,bulan2,tahun2,valid, // cek tanggal awal serta tanggal akhir
            'Tidak perlu cek kamar di masa lalu!','Tanggal awal ke akhir tidak boleh mundur atau sama!',1); // 
      if not valid then // jika invalid..                                        // '1' artinya tanggal awal boleh ke masa lalu
        begin 
        cetakInvalid(0,0,4,ulang); // menanyakan jika penguna ingin mengulangi
        if ulang in ['y','Y'] then // jika ya.. maka kembali menginput tanggal akhir
          goto UlangInputTanggalDua
        else if ulang in ['1'] then // jika pilihan '1'.. maka kembali ke menginput tanggal awal
          goto UlangInputTanggalSatu
        else
          goto Penutup; // selain itu menuju penutup
        end;
      awalTanggalIn:= hari1 +'/'+ bulan1 +'/'+ tahun1;
      akhirTanggalIn:= hari2 +'/'+ bulan2 +'/'+ tahun2; // memasukan keuda inputan tanggal ke variabel yang sebernarnya
      awalTanggalInLint:= StrToDate(awalTanggalIn,'dd/mm/yyyy','/');
      akhirTanggalInLint:= StrToDate(akhirTanggalIn,'dd/mm/yyyy','/'); // menkonversi kedua tanggal ke 'date angka'
      reset(Data); // membuka data untuk dibaca
      while not eof(Data) do // selama file belum berakhir..
        begin
        readln(Data, simbol); // mencari simbol '$'
        if pos('$',simbol) > 0 then // jika simbol ditemukan.. artinya ada data untuk dibaca
          begin
          for a:=1 to 6 do // melompati baris 1 sampai 6 dari data
            readln(Data);
          readln(Data,BacaBaris); // membaca baris ketujuh dan menyalinnya
          for a:=8 to 9 do // melompati sisa baris
            readln(Data);
          awalTanggal:= copy(BacaBaris,37,10); // mengambil data pemesanan tanggal awal
          akhirTanggal:= copy(BacaBaris,55,10); // mengambil data pemesanan tanggal akhir
          awalTanggalLint:= StrToDate(awalTanggal,'dd/mm/yyyy','/');
          akhirTanggalLint:= StrToDate(akhirTanggal,'dd/mm/yyyy','/'); // menkonversi kedua tanggal ke 'date angka'
          if ((awalTanggalLint <= awalTanggalInLint) and (akhirTanggalLint > awalTanggalInLint)) OR
            ((awalTanggalLint < akhirTanggalInLint ) and (akhirTanggalLint >= akhirTanggalInLint)) OR
            ((awalTanggalLint >= awalTanggalInLint) and (akhirTanggalLint <= akhirTanggalInLint)) then
              begin                                   //+jika tanggal awal data < atau = input tanggal awal DAN tanggal akhir data > input tanggal awal..
              ketemuData10:= false; // pemandu baris  //+atau jika tanggal awal data < input tanggal akhir DAN tanggal akhir data > atau = input tanggal akhir..
              pemanduA:= pemanduA + 1;//jumlah data.. //+atau jika tanggal awal data > atau = input tanggal awal DAN tanggal akhir data < atau = input tanggal akhir..
              if pemanduA = 1 then //yang memenuhi    //+maka dihitung
                begin
                write('DAFTAR PESANAN TANGGAL ('); 
                Textcolor(red);
                write(awalTanggalIn); // jika ada data yang memenuhi kriteria, maka pesan ini dicetak
                Textcolor(white);
                write(') - (');
                Textcolor(red);
                write(akhirTanggalIn);
                Textcolor(white);
                writeln(')');
                writeln;
                end;
              write(pemanduA,'. ('); // perintah selanjutnya memberitahu tanggal mana yang bersinggungan dengan tanggal inputan dengan warna kuning
              if ((awalTanggalLint >= awalTanggalInLint) and // jika awal tanggal dan akhir tanggal data bersinggungan..
                  (akhirTanggalLint <= akhirTanggalInLint)) then
                  begin
                  Textcolor(yellow); // awal tanggal dan akhir tanggal data berwarna kuning
                  write(awalTanggal);
                  Textcolor(white);
                  write(') Sampai (');
                  Textcolor(yellow);
                  write(akhirTanggal);
                  Textcolor(white);
                  goto SelesaiCetakTanggal; // melompat ke label SelesaiCetakTanggal
                  end;
              if ((awalTanggalLint <= awalTanggalInLint) and // jika awal tanggal data tidak bersinggungan dan akhir tanggal data bersinggungan..
                  (akhirTanggalLint > awalTanggalInLint)) then 
                  begin
                  Textcolor(green); // awal tanggal data berwarna hijau
                  write(awalTanggal);
                  Textcolor(white);
                  write(') Sampai (');
                  Textcolor(yellow); // akhir tanggal data berwarna kuning
                  write(akhirTanggal);
                  Textcolor(white);
                  goto SelesaiCetakTanggal; // melompat ke label SelesaiCetakTanggal
                  end;
              if ((awalTanggalLint < akhirTanggalInLint ) and 
                  (akhirTanggalLint >= akhirTanggalInLint)) then // jika awal tanggal data bersinggungan dan akhir tanggal data tidak bersinggungan..
                  begin
                  Textcolor(yellow); // awal tanggal data berwarna kuning
                  write(awalTanggal);
                  Textcolor(white);
                  write(') Sampai (');
                  Textcolor(green); // akhir tanggal data berwarna hijau
                  write(akhirTanggal);
                  Textcolor(white);
                  end;
              SelesaiCetakTanggal:
              write(') kamar: '); //--mencetak jenis kamar
              kamar:=copy(BacaBaris,33,2); // menyalin jenis kamar jika berdasarkan keterangan
              val(kamar,kamarInt,posisiSalah);
              if kamar = 'De' then
                begin
                writeln('Deluxe'); // jika Deluxe maka dicetak
                adaDe:= adaDe + 1; // Deluxe dihitung
                end;
              if kamar = 'Bi' then
                begin
                writeln('Biasa'); // jika Biasa maka dicetak
                adaBi:= adaBi + 1; // Biasa dihitung
                end;
              if posisiSalah = 0 then // jika berdasarkan nomor kamar..
                begin
                if kamarInt > 5 then
                  begin
                  writeln('Deluxe'); // jika Deluxe maka dicetak
                  adaDe:= adaDe + 1; // Deluxe dihitung
                  end
                else
                  begin
                  writeln('Biasa'); // jika Biasa maka dicetak
                  adaBi:= adaBi + 1; //--Biasa dihitung
                  end;
                end;
              if (pemanduA mod 10 = 0) AND not ketemuData10 then // jika data yang ditampilkan merupakan kelipatan dari..
                begin                                            // ..sepuluh, maka program berhenti menampilkan dan menunggu..
                ketemuData10:= true; // mencegah error..         // ..perintah ENTER dari pengguna untuk melanjutkan
                readln;              // ..tampilan data ngestuk atau tertahan
                end
              else
                writeln;
              end;
          end;
        end;
      close(Data); // menutup file
      kosongDe:= 5 - adaDe; //--menghitung jumlah kamar kosong
      if adaBi > 4 then // jika kamar Biasa penuh..
        kosongBi:= 0 // kosong Biasa = o
      else // selain itu..
        kosongBi:= 5 - adaBi; // hitung jumlah kamar kosong Biasa
      if adaDe > 4 then // jika kamar Deluxe penuh..
        kosongDe:= 0 // kosong Deluxe = 0
      else // selain itu..
        kosongDe:= 5 - adaDe; //--hitung jumlah kamar kosong Deluxe
      if (kosongBi = 0) AND (kosongDe = 0) then // jika seluruh kamar penuh..
        writeln('Total : Tidak ada kamar kosong!');
      if (kosongBi > 0) OR (kosongDe > 0) then // jika ada kamar yang kosong..
        begin
        if (kosongBi = 5) AND (kosongDe = 5) then // (jika tidak ada tanggal yang bersinggungan.. daftar tidak akan dicetak)
          writeln;
        write('Total :');
        gotoxy(9,wherey);writeln('Kamar kosong (Deluxe) : ',kosongDe); // ke baris tempat krusor berada, ke lokasi x = 9 lalu cetak
        gotoxy(9,wherey);writeln('Kamar kosong (Biasa) : ',kosongBi); // ke baris tempat krusor berada, ke lokasi x = 9 lalu cetak
        end;
      end;
    2: // jika pilihan = memeriksa kamar hari ini..
      begin
      reset(Sedia); // membuka data untuk dibaca
      for a:=1 to 10 do // dari kamar pertama sampai kesepuluh..
        begin
        readln(Sedia,BacaBaris); // baca atau cari simbol
        if (pos('$',BacaBaris) > 0) or (pos('&',BacaBaris) > 0) then
          begin // jika simbol kamar adalah kosong..
          pemanduSed:= pemanduSed + 1; // pemandu nomor kamar (pencacah a rentan error)
          write('Kamar ke-',pemanduSed,' : '); // cetak nomor kamar
          Textcolor(green);
          writeln('Kosong');
          Textcolor(white);
          readln(Sedia); // skip baris kosong (jarak antar data)
          end;
        if (pos('*',BacaBaris) > 0) or (pos('#',BacaBaris) > 0) then
          begin // jika simbol kamar adalah terisi..
          pemanduSed:= pemanduSed + 1; // pemandu kamar + 1
          write('Kamar ke-',pemanduSed,' : '); // cetak nomor kamar
          Textcolor(red);
          writeln('Terisi');
          Textcolor(white);
          for b:=1 to 9 do // baca dan cetak seluruh baris data
            begin
            readln(Sedia,BacaBaris);
            writeln(BacaBaris);
            end;
          readln(Sedia); // skip baris kosong (jarak antar data)
          end;
        if (pemanduSed mod 2 = 0) AND (not((pemanduSed = 10) or (pemanduSed = 0))) then
          readln // jika nomor kamar yang ditampilkan kelipatan 2, maka tunggu perintah pengguna
        else if (pemanduSed mod 2 > 0) then // selain itu beri jarak
          writeln;
        end;
      close(Sedia); // tutup file
      end;
    end; //endcaseof
  end; //endvalid
Penutup:
end; // end prosedur

procedure CekPenggunaHariIni; // memeriksa yang check-in atau check-out hari ini
var
  Data: text;
  BacaBaris: array [1..10] of string;
  AwalTanggal,AkhirTanggal,pemanduStr,simbol: string;
  lagi: char;
  ketemuData4: boolean;
  a,ketemuData,pilihan,hasil: integer;
  awalTanggalLint,akhirTanggalLint,sekarangTanggalLint,waktuAwalLint,waktuAkhirLint,waktuSekarangLint: TDateTime;
label UlangInputPilihan, Penutup;
begin
ketemuData:=0; ketemuData4:= false;
sekarangTanggalLint:= StrToDate(DateToStr(WaktuSekarang)); 
waktuAwalLint:= StrToTime('13:00:00',':');
waktuAkhirLint:= StrToTime('12:00:00',':'); {inisialisasi}
assign(Data, 'Data.txt'); // menghubungkan variabel kepada file

clrscr;
garis('=');
writeln('PENGGUNA KAMAR BELUM CHECK-IN/OUT HARI INI');
writeln;
writeln('Note: Refresh setelah 23:59');
garis('-');
UlangInputPilihan:
write('Tampilkan data check-in/check-out (1/2) : ');readln(pemanduStr); // input pilihan admin
val(pemanduStr,pilihan,posisiSalah); // coba konversi ke angka
if posisiSalah > 0 then // jika gagal konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
if (pilihan > 2) OR (pilihan < 1) then // jika angka diluar pilihan..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
writeln; // beri jarak
reset(Data); // buka data untuk dibaca
while not eof(Data) do // selama data belum berakhir..
  begin
  readln(Data,simbol); // cari simbol '$'
  if pos('$',simbol) > 0 then // jika ditemukan..
    begin
    hasil:=0; {inisialisasi}
    for a:=1 to 9 do // baca keseluruhan data
      readln(Data,BacaBaris[a]);
    awalTanggal:= copy(BacaBaris[7],37,10); // salin awal tanggal
    akhirTanggal:= copy(BacaBaris[7],55,10); // salin akhir tanggal
    awalTanggalLint:= StrToDate(awalTanggal,'dd/mm/yyyy','/');
    akhirTanggalLint:= StrToDate(akhirTanggal,'dd/mm/yyyy','/'); // konversi keduanya ke 'date angka'
    waktuSekarangLint:= StrToTime(TimeToStr(WaktuSekarang)); // ambil dan simpan 'waktu angka' sekarang
    if      (pilihan = 1) AND (pos('ON',simbol) = 0) AND
            ((akhirTanggalLint > sekarangTanggalLint) or
            ((akhirTanggalLint = sekarangTanggalLint) and
            (waktuAkhirLint <= waktuSekarangLint))) AND
            ((awalTanggalLint < sekarangTanggalLint) or
            ((awalTanggalLint = sekarangTanggalLint) and
            (waktuAwalLint <= waktuSekarangLint))) then
                hasil:=3 // jika pilihan 'data check-in' dan belum check-in dan lewat jadwal check-in dan belum jadwal check-out.. hasil = 3
    else if (pos('ON',simbol) > 0) AND (pilihan = 2) AND
            ((akhirTanggalLint > sekarangTanggalLint) or
            ((akhirTanggalLint = sekarangTanggalLint) and
            (waktuAkhirLint >= waktuSekarangLint))) then
                hasil:=4 // jika pilihan 'data check-out' dan sudah check-in dan belum lewat jadwal check-out.. hasil = 4
    else if (pilihan = 1) AND (pos('ON',simbol) = 0) AND
            (awalTanggalLint = sekarangTanggalLint) AND
            (waktuAwalLint > waktuSekarangLint) then
                hasil:=1 // jika pilihan 'data check-in' dan belum check-in dan ini jadwal awal check-in dan belum waktunya.. hasil = 1
    else if (pos('ON',simbol) > 0) AND (pilihan = 2) AND 
            ((akhirTanggalLint < sekarangTanggalLint) or
            ((akhirTanggalLint = sekarangTanggalLint) and
            (waktuAkhirLint <= waktuSekarangLint))) then
                hasil:=2 // jika pilihan 'data check-out' dan sudah check-in dan melewati jadwal check-out.. hasil = 2
    else if (pilihan = 1) AND (pos('ON',simbol) = 0) AND
            ((akhirTanggalLint < sekarangTanggalLint) or
            ((akhirTanggalLint = sekarangTanggalLint) and
            (waktuAkhirLint < waktuSekarangLint))) then
                hasil:=5; // jika pilihan 'data check-in' dan belum check in dan lewat jadwal check-out.. hasil = 5
      if hasil = 3 then // jika boleh check-in..
        begin
        writeln('(',AwalTanggal,') Sampai (',AkhirTanggal,') ');
        Textcolor(green);
        writeln('Dipersilahkan check-in');
        Textcolor(white);
        for a:=1 to 4 do // cetak 4 baris data pertama (data pribadi) ke layar
          writeln(BacaBaris[a]);
        writeln;
        ketemuData:= ketemuData + 1; // jumlah data ditemukan
        ketemuData4:= false; // cegah readln ngestuk saat pencarian data
        end
      else if hasil = 4 then // jika sudah check-in dan belum lewat jadwal check-out..
        begin
        writeln('(',AwalTanggal,') Sampai (',AkhirTanggal,') ');
        Textcolor(green);
        writeln('Dipersilahkan check-out');
        Textcolor(white);
        for a:=1 to 4 do // cetak 4 baris data pertama (data pribadi) ke layar
          writeln(BacaBaris[a]);
        writeln;
        ketemuData:= ketemuData + 1; // jumlah data ditemukan + 1
        ketemuData4:= false;
        end
      else if hasil = 1 then // jika jadwal check-in hari ini dan belum boleh check-in..
        begin
        writeln('(',AwalTanggal,') Sampai (',AkhirTanggal,') ');
        Textcolor(red);
        writeln('Boleh check-in dalam (',(TimeToStr(waktuSekarangLint - waktuAwalLint)),')');
        Textcolor(white);
        for a:=1 to 4 do // cetak 4 baris data pertama (data pribadi) ke layar
          writeln(BacaBaris[a]);
        writeln;
        ketemuData:= ketemuData + 1; // jumlah data ditemukan + 1
        ketemuData4:= false;
        end
      else if hasil = 2 then // jika sudah check-in dan jadwal check-out sudah lewat..
        begin
        writeln('(',AwalTanggal,') Sampai (',AkhirTanggal,') ');
        Textcolor(red);
        writeln('Melebihi batas check out selama (',(TimeToStr(waktuSekarangLint - waktuAkhirLint)),')');
        Textcolor(white);
        for a:=1 to 4 do // cetak 4 baris data pertama (data pribadi) ke layar
          writeln(BacaBaris[a]);
        writeln;
        ketemuData:= ketemuData + 1; // jumlah data ditemukan + 1
        ketemuData4:= false;
        end
      else if hasil = 5 then // jika belum pernah check-in dan jadwal check-out sudah lewat..
        begin
        writeln('(',AwalTanggal,') Sampai (',AkhirTanggal,') ');
        Textcolor(red);
        writeln('Tidak pernah check-in!');
        Textcolor(white);
        for a:=1 to 4 do // cetak 4 baris data pertama (data pribadi) ke layar
          writeln(BacaBaris[a]);
        writeln;
        ketemuData:= ketemuData + 1; // jumlah data ditemukan + 1
        ketemuData4:= false;
        end;
    end;
  if (ketemuData4 = false) AND (not(ketemuData = 0)) AND (ketemuData mod 4 = 0) then
    begin // jika sudah mencetak data setelah kelipatan 4 dan sudah menemukan data dan jumlah cetak data kelipatan 4..
    cetakInvalid(0,0,6,lagi); // menanyakan jika pengguna ingin melanjutkan
    if lagi in ['t','T'] then // jika tidak..
      begin
      close(Data); // tutup data
      goto Penutup; // menuju penutup
      end
    else if not (lagi in ['y','Y']) then // jika selain 't','T','y','Y' maka.. keluar
      begin
      writeln('Kami anggap anda tidak ingin');
      close(Data); // tutup data 
      goto Penutup; // menuju penutup
      end;
    writeln; // beri jarak
    ketemuData4:= true; // agar program tidak macet di readln
    end;
  end; // endwhile 
if eof(Data) then // jika file berakhir..
  begin
  close(Data); // tutup file
  Textcolor(red);
  if ketemuData > 0 then // jika data ditemukan..
    writeln('Daftar sudah habis!')
  else // jika tidak ditemukan..
    writeln('Data tidak ada!');
  Textcolor(white);
  end;
Penutup:
end; // end prosedur

procedure CheckIn; // check-in data pengguna di file 'Sedia.txt'
var
  Data,Sedia: text;
  BacaSedia: array [1..150] of string;
  BacaBaris: array [1..3000] of string;
  Kosong,tampung,dadu,pemanduBerbeda: array [1..11] of integer;
  nama,kredit,nik,simbol,awalTanggal,akhirTanggal,kamarStr,pemanduStr: string;
  awalTanggalLint,akhirTanggalLint,sekarangTanggalLint,waktuAwalLint,waktuAkhirLint,waktuSekarangLint: TDateTime;
  ulang: char;
  valid,errorCetakSedia: boolean;
  a,b,pencacahA,pencacahB,pemanduA,pemanduSed,pemanduDat,pemanduBi,pemanduDe,pemanduDadu,sudahCekIn,ketemuData: integer;
  pilihan,pilihan2,namaData,nikData,kamar,kreditData,kosongBi,adaBi,kosongDe,adaDe,min,pemenang: integer;
label UlangInputPilihan, UlangInputPilihan2, UlangInputNik,
      UlangInputNamaNikKre, Penutup;
begin
kosongBi:=0; adaBi:=0; kosongDe:=0; adaDe:=0;
pencacahA:=9; pencacahB:=0; pemanduA:=0; pemanduSed:=0; pemanduDat:=0; pemanduBi:=0; pemanduDe:=0;
pemanduDadu:=0; ketemuData:=0; sudahCekIn:=0;  valid:=true; errorCetakSedia:= false; 
nama:= ''; kredit:= ''; nik:= ''; {inisialisasi}
waktuAwalLint:= StrToTime('13:00:00',':');
waktuAkhirLint:= StrToTime('12:00:00',':');
sekarangTanggalLint:= StrToDate(DateToStr(WaktuSekarang)); // konversi waktu awal, akhir, dan sekarang ke 'date angka'
assign(Sedia,'Sedia.txt');
assign(Data,'Data.txt'); // hubungkan variabel ke file

clrscr;
garis('=');
writeln('CHECK-IN HOTEL AMAN SENTOSA');
writeln;
writeln('*Note : Harap perhatikan jika kamar masih penuh!');
garis('-');
UlangInputPilihan:
write('Check-in menggunakan nama dan NIK/kredit (1/2) : ');readln(pemanduStr); // input pilihan idenfitikasi
val(pemanduStr,pilihan,posisiSalah); // coba konversi input ke angka
if posisiSalah > 0 then // jika gagal..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
UlangInputNamaNikKre:
if pilihan = 1 then // jika pilihan check-in menggunakan nama dan NIK
  begin
  write('Masukkan nama : ');readln(nama); // input nama idenfitikasi
  cekNama(nama,valid); // validasi dan konversi nama
  if not valid then // jika invalid...
    begin 
    cetakInvalid(0,0,3,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput nama
      goto UlangInputNamaNikKre
    else 
      goto Penutup; // selain itu.. menuju penutup
    end;
  UlangInputNik:
  write('Masukkan NIK : ');readln(nik); // input NIK idenfitikasi
  cekInteger('NIK',nik,16,valid); // validasi NIK
  if not valid then // jika invalid...
    begin 
    cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput NIK
      goto UlangInputNik
    else if ulang in ['1'] then // jika pilihan adalah '1'.. kembali ke menginput nama
      goto UlangInputNamaNikKre
    else 
      goto Penutup; // selain itu.. menuju penutup
    end; 
  end
else if pilihan = 2 then // jika pilihan check-in menggunakan kredit
  begin
  write('Masukkan kredit : ');readln(kredit); // input kredit idenfitikasi
  cekInteger('Kredit',kredit,16,valid); // validasi kredit
  if valid then // jika valid..
    cekKredit(kredit,valid); // validasi kredit lanjutan
  if not valid then // jika invalid...
    begin 
    cetakInvalid(0,0,3,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput kredit
      goto UlangInputNamaNikKre
    else 
      goto Penutup; // selain itu.. menuju penutup
    end;
  end
else // selain itu..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
reset(Data); // buka data untuk dibaca
while not eof(Data) do // selama file belum berakhir..
  begin
  readln(Data,simbol); // baca simbol
  if pos('$',simbol) > 0 then // jika ditemukan..
    begin
    pemanduDat:= pemanduDat + 1; // pemandu nomor data
    for b:=(pencacahA - 8) to pencacahA do // simpan seluruh baris data
      readln(Data,BacaBaris[b]);
    awalTanggal:= copy(BacaBaris[pencacahA - 2],37,10); 
    akhirTanggal:= copy(BacaBaris[pencacahA - 2],55,10); // salin awal tanggal dan akhir tanggal
    awalTanggalLint:= StrToDate(awalTanggal,'dd/mm/yyyy','/');
    akhirTanggalLint:= StrToDate(akhirTanggal,'dd/mm/yyyy','/'); // konversi keduuanya ke 'Date angka'
    waktuSekarangLint:= StrToTime(TimeToStr(WaktuSekarang)); // ambil 'waktu angka' sekarang
    if pilihan = 1 then // jika check-in menggunakan nama dan nik..
      begin
      namaData:= pos(' '+nama+'|',BacaBaris[pencacahA - 7]);
      nikData:= pos(nik,BacaBaris[pencacahA - 7]);
      end;
    if pilihan = 2 then // jika check-in menggunakan kredit
      kreditData:= pos(kredit,BacaBaris[pencacahA - 6]);
    if (((namaData > 0) and (nikData > 0)) or (kreditData > 0)) AND
         (((awalTanggalLint < sekarangTanggalLint) and
          (akhirTanggalLint > sekarangTanggalLint)) or
         ((awalTanggalLint = sekarangTanggalLint) and
          (waktuAwalLint < waktuSekarangLint)) or 
         ((akhirTanggalLint = sekarangTanggalLint) and
          (waktuAkhirLint > waktuSekarangLint))) then
          begin // jika data yang diinput ditemukan, dan jadwal sekarang berada di jadwal data pemesanan..
          if (pos('ON',simbol) = 0) then // jika belum check-in..
            begin
            ketemuData:= ketemuData + 1; // menghitung data yang ditemukan
            pemanduBerbeda[ketemuData]:= pemanduDat; // lokasi nomor data yang ditemukan
            if (pos('De',BacaBaris[pencacahA - 2]) > 0) then
              pemanduDe:= pemanduDe + 1; // jika keterangan kamar = Deluxe.. hitung 
            if (pos('Bi',BacaBaris[pencacahA - 2]) > 0) then
              pemanduBi:= pemanduBi + 1; // jika keterangan kamar = Biasa.. hitung 
            end
          else if (pos('ON',simbol) > 0) then // jika sudah check-in..
            sudahCekIn:= sudahCekIn + 1; // hitung
          end;
    pencacahA:= pencacahA + 9; // pemandu BacaBaris
    end;
  end; //endwhile
if (eof(Data)) AND (ketemuData = 0) then // jika file berakhir dan data tidak ditemukan..
    begin
    close(Data);
    Textcolor(red);
    write('Nama/NIK/Kredit tidak ditemukan ');
    Textcolor(white);
    write('atau');
    Textcolor(red);
    writeln(' belum saatnya Check-In!');
    Textcolor(white);
    goto Penutup // menuju penutup
    end;
close(Data); // tutup file
if (sudahCekIn > 0) AND (pemanduDe = 0) AND (pemanduBi = 0) then
  begin // jika seluruh data yang ditemukan sudah check-in..
  Textcolor(red);
  writeln('Pelanggan sudah check-in!');
  Textcolor(white);
  goto Penutup; // menuju penutup
  end
else if (pemanduDe > 1) OR (pemanduBi > 1) OR ((pemanduDe = 1) and (pemanduBi = 1)) then
  begin // jika data yang belum check-in lebih dari satu..
  Textcolor(yellow);
  write('Beberapa pemesanan dilakukan dengan data tersebut!');
  Textcolor(white);
  writeln(' (De:',pemanduDe,'/Bi:',pemanduBi,')');
  for a:=1 to ketemuData do // cetak data yang ditemukan dan belum check-in ke layar
    begin
    pemanduA:= pemanduA + 1; // pemandu nomor data yang ditemukan
    writeln('Data ke-',pemanduA,' :');
    pencacahB:= pemanduBerbeda[pemanduA] * 9 - 8; // lokasi nomor data yang disimpan
    writeln(BacaBaris[pencacahB]); // baris pertama
    writeln(BacaBaris[pencacahB + 1]); // baris kedua
    writeln(BacaBaris[pencacahB + 3]); // baris keempat
    writeln(BacaBaris[pencacahB + 6]); // baris ketujuh
    writeln(BacaBaris[pencacahB + 8]); // baris kesembilan
    if pemanduA = ketemuData then // jika data terakhir telah dicetak..
        begin
        writeln; // beri jarak
        break; // mencegah bug
        end;
    if (pemanduA mod 4 = 0) then // jika data yang dicetak mencapai kelipatan 4..
      readln //tunggu enter
    else // selain itu..
      writeln; // beri jarak
    end;
  pemanduA:= 0; {inisialisasi baru}
  UlangInputPilihan2:
  write('Pilih Check-in data yang mana : ');readln(pemanduStr); // input pilihan data check-in idenfitikasi
  val(pemanduStr,pilihan2,posisiSalah); // coba dikonversi menjadi integer
  if posisiSalah > 0 then // jika konversi gagal..
    begin
    cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
    if ulang in ['y','Y'] then // jika pilihan ya.. maka kembali menginput pilihan2
      goto UlangInputPilihan2
    else
      goto Penutup; // selain itu.. menuju penutup
    end;
  if (pilihan2 > ketemuData) or (pilihan2 < 1) then // jika pilihan diluar data yang ditampilkan..
    begin
    Textcolor(red);
    write('Nomor invalid!'); // maka invalid
    Textcolor(white);
    cetakInvalid(0,1,0,ulang); // menanyakan jika penguna ingin mengulangi
    if ulang in ['y','Y'] then // jika pilihan ya.. maka kembali menginput pilihan2
      goto UlangInputPilihan2
    else
      goto Penutup; // selain itu.. menuju penutup
    end
  else if (pilihan2 <= ketemuData) or (pilihan2 > 0) then // jika pilihan valid..
    pencacahB:= pemanduBerbeda[pilihan2] * 9; // pencacahB menyimpan kordinat akhir baris berdasarkan nomor kamar
  end
else if ((pemanduDe = 1) and (pemanduBi = 0)) OR ((pemanduDe = 0) and (pemanduBi = 1)) then // jika hanya ada satu  data..
  begin
  pilihan2:= 1;
  pencacahB:= pemanduBerbeda[1] * 9; // pencacahB menyimpan kordinat akhir baris data
  end;
if (pencacahB > 0) AND valid then // jika pencacahB sudah menyimpan lokasi dan valid..
  begin
  CekKetersediaan(Sedia,kosongBi,adaBi,kosongDe,adaDe,kosong); //--cek kamar terisi dan kosong
  if (adaBi = 5) AND (adaDe = 5) then // jika kamar penuh
    begin
    Textcolor(red);
    write('Seluruh kamar penuh!');
    Textcolor(white);
    writeln(' kami sarankan untuk mengecek kamar!');
    goto Penutup; // menuju penutup
    end;
  if (pos('De',BacaBaris[pencacahB - 2]) > 0) AND (adaDe = 5) then
    begin // jika check-in kamar 
    Textcolor(red);
    write('Kamar Deluxe penuh!');
    Textcolor(white);
    writeln(' kami sarankan untuk mengecek kamar!');
    goto Penutup; // menuju penutup
    end;
  if (pos('Bi',BacaBaris[pencacahB - 2]) > 0) AND (adaBi = 5) then
    begin
    Textcolor(red);
    write('Kamar Biasa penuh!');
    Textcolor(white);
    writeln(' kami sarankan untuk mengecek kamar!');
    goto Penutup; // menuju penutup
    end; //--selesai cek kepenuhan kamar
  if pos('De',BacaBaris[pencacahB - 2]) > 0 then
    begin // jika keterangan kamar 'Deluxe'..
    if kosongDe > 1 then // jika kamar kosong lebih dari satu.. jalankan dadu
      begin
      for a:=7 to 11 do // cek (error, jika 6 ke 10 maka jadi 5 ke 9 oleh program)
        if kosong[a] > 0 then  // jika ketemu kamar yang kosong..
          begin
          pemanduDadu:= pemanduDadu + 1; // jumlah kamar kosong + pemandu
          tampung[pemanduDadu]:= kosong[a]; // tampung nomor kamar kosong
          end;
      Randomize; // mengaktifkan perintah mengacak
      for a:=1 to pemanduDadu do // inisialisasi dadu sesuai jumlah kamar
        dadu[a]:= random(1000); // simpan angka acak
      min:= dadu[1]; // inisialisasi minimal atau hubungkan minimal ke array
      for a:=1 to pemanduDadu do // cari minimal dari seluruh dadu
        if min > dadu[a] then // jika minimal lebih dari dadu..
          min:= dadu[a]; // minimal menyimpan nilai dadu
      for a:=1 to pemanduDadu do // cari nomor kamar yg menang
        if min = dadu[a] then // jika minimal ditemukan..
          pemenang:= a; // pemenang menyimpan nomor pemenang (minimal)
        kamar:= tampung[pemenang]; // nilai kamar pemenang masuk ke data
      end
    else if kosongDe = 1 then // jika kamar kosong = 1
      for a:=7 to 11 do // mencegah error
        if kosong[a] > 0 then // jika kamar kosong ditemukan..
          kamar:= kosong[a]; // simpan nomor kamar kosong
    end;
  if pos('Bi',BacaBaris[pencacahB - 2]) > 0 then
    begin // jika keterangan kamar 'Biasa'..
    if kosongBi > 1 then // jika kamar kosong lebih dari satu.. jalankan dadu
      begin 
      for a:=1 to 6 do //cek (error, jika 1 ke 5 maka jadi 1 ke 4 oleh program)
        if kosong[a] > 0 then // jika kamar kosong pada array ditemukan..
          begin
          pemanduDadu:= pemanduDadu + 1; // jumlah kamar kosong + pemandu
          tampung[pemanduDadu]:=kosong[a]; // tampung nomor kamar kosong
          end;
      Randomize; // mengaktifkan perintah mengacak
      for a:=1 to pemanduDadu do // dadu sesuai jumlah kamar
        dadu[a]:= random(1000); // simpan angka acak
      min:= dadu[1]; // inisialisasi minimal atau hubungkan minimal ke array
      for a:=1 to pemanduDadu do // cari minimal dari dadu
        if min > dadu[a] then
          min:= dadu[a];
      for a:=1 to pemanduDadu do // cari nomor kamar yg menang
        if min = dadu[a] then
          pemenang:=a;
      kamar:= tampung[pemenang]; // nilai kamar pemenang masuk ke data
      end
    else if kosongBi = 1 then // jika kamar kosong = 1
      for a:=1 to 6 do // mencegah error
        if kosong[a] > 0 then // jika nomor kamar ditemukan..
          kamar:= kosong[a]; // simpan nomor kamar
    end;
  str(kamar,kamarStr); // ubah nomor kamar menjadi string
  pencacahA:= 1; pemanduSed:= 0; // pencacahA = pemandu BacaBaris, pemanduSed = pemandu nomor kamar
  delete(BacaBaris[pencacahB - 2],33,2); // hapus keterangan kamar pada data..
  if kamar = 10 then // ..gantikan dengan nomor kamar
    insert(kamarStr,BacaBaris[pencacahB - 2],33) // jika nomor adalah 10
  else
    insert('0'+kamarStr,BacaBaris[pencacahB - 2],33); // ditambah 0 didepannya jika nomor 'satuan'
  reset(Sedia); // buka file untuk dibaca
  while not eof(Sedia) do // salin seluruh data pada 'sedia.txt'
    begin
    readln(Sedia,BacaSedia[pencacahA]); // cari simbol
    if (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
      begin // jika kamar kosong..
      pencacahA:= pencacahA + 1; // majukan nomor memori BacaSedia
      readln(Sedia); // baris baru
      end;
    if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
      begin // jika kamar terisi..
      for a:= 1 to 9 do // simpan semua data
        begin
        pencacahA:= pencacahA + 1; // pencacah a rentan error
        readln(Sedia,BacaSedia[pencacahA]); // cetak data
        end;
      pencacahA:= pencacahA + 1; // siapkan slot untuk readln
      readln(Sedia); // beri jarak
      end;
    end;
  pencacahA:= 1; {inisialisasi baru}
  rewrite(Sedia); // hapus isi file dan buka untuk dicetak
  repeat //--{SERING ERROR, JIKA ADA KENDALA, TOLONG HUBUNGI} lakukan sampai pemanduSed = 10
  if (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
    begin // jika kamar kosong..
    pemanduSed:= pemanduSed + 1; // FOR..TO sering error
    if pemanduSed = kamar then // jika nomor kamar mencapai data nomor kamar
      begin
      if kamar <= 5 then // jika kamar kurang dari 6
        writeln(Sedia,'*') // cetak simbol
      else if kamar > 5 then // jika kamar kurang dari 5
        writeln(Sedia,'#'); // cetak simbol
      for b:=1 to 101 do // tidak bisa tulis BacaBaris[..] karena error disini
        write(Sedia,'='); 
      writeln(Sedia);
      for b:=(pencacahB - 7) to pencacahB do // cetak data yang dipilih
        writeln(Sedia,BacaBaris[b]);
      writeln(Sedia);
      pencacahA:= pencacahA + 1; // majukan slot memori
      flush(Sedia); 
      end // simpan perubahan data pada file //t idak bisa dipersingkat seperti rewrite Data karena bug pada kamar Deluxe
    else
      begin
      writeln(Sedia,BacaSedia[pencacahA]); // cetak simbol
      writeln(Sedia); // beri jarak
      pencacahA:= pencacahA + 1;
      flush(Sedia); // simpan perubahan data pada file
      end;
    end;
  if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
    begin // jika kamar terisi..
    pemanduSed:= pemanduSed + 1; // pemandu nomor kamar
    writeln(Sedia,BacaSedia[pencacahA]); // cetak simbol
    pencacahA:= pencacahA + 1; // majukan slot array
    for b:=1 to 8 do // cetak data
      begin
      if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
        begin //--pencegah error
        pencacahA:= pencacahA + 1; // majukan slot array
        errorCetakSedia:= true; // penanda adalah error!
        end; //--
      writeln(Sedia,BacaSedia[pencacahA]); // cetak data
      pencacahA:= pencacahA + 1;
      end;
    for a:=1 to 101 do // harus manual pada garis, karena bisa error!
      write(Sedia,'=');
    writeln(Sedia); // baris baru
    pencacahA:= pencacahA + 1; // majukan slot array
    if errorCetakSedia then //--JIKA ERROR
      begin
      for b:=1 to 4 do // mundurkan slot sampai ketemu simbol
        begin
        if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) or
            (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
          begin // jika simbol ditemukan..
          errorCetakSedia:= false; // sudah tidak ERROR
          writeln(Sedia); // beri jarak
          break; // hentikan
          end;
        pencacahA:= pencacahA - 1; // bila tidak ditemukan.. mundurkan slot
        end;
      if errorCetakSedia then // jika masih ERROR..
        begin
        pencacahA:= pencacahA + 4; // kembalikan posisi pemandu
        for b:=1 to 4 do // majukan slot sampai ketemu simbol
          begin
          if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) or
            (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
            begin // jika simbol ditemukan..
            errorCetakSedia:= false; // sudah tidak ERROR
            writeln(Sedia); // beri jarak
            break; // hentikan
            end
          else if BacaSedia[pencacahA] = '' then
            begin // jika error adalah data corrupted.. beri tahu admin
            Textcolor(red); // (tidak ada solusi karena belum ada kasus)
            writeln('TERJADI KESALAHAN PADA PENCETAKAN DATA KAMAR!');
            Textcolor(white);
            errorCetakSedia:= false; // error telah ditangani sebisa mungkin
            break; // hentikan
            end;
          pencacahA:= pencacahA + 1; // majukan slot array
          end; //--Selesai penanganan error
        end;
      end
    else
      writeln(Sedia); // beri jarak
    flush(Sedia); // simpan perubahan data pada file
    end;
  until pemanduSed = 10; // hentikan jika kamar yang dicetak sampai 10
  close(Sedia); // tutup file
  pencacahA:=0; pemanduA:=0; {inisialisasi baru}
  rewrite(Data); // hapus isi file 'data.txt' dan buka untuk ditulis
  for a:=1 to pemanduDat do // dari nomor data pertama sampai terakhir..
    begin
    pemanduA:= pemanduA + 1; // pemandu nomor kamar (a rentan bug)
    kamarStr:= copy(BacaBaris[pencacahA + 7],33,2); // salin keterangan atau nomor kamar
    if (pemanduA = pemanduBerbeda[pilihan2]) or (not ((kamarStr = 'De') or (kamarStr = 'Bi'))) then
      writeln(Data,'$ON') // bila data adalah data yang dipilih, atau nomor kamar yang disalin bukan keterangan.. tandai 'berlangsung'
    else
      writeln(Data,'$'); // selain itu.. beri simbol biasa
    pencacahA:= pencacahA + 9; // majukan pemandu
    for b:=(pencacahA - 8) to pencacahA do
        writeln(Data,BacaBaris[b]); // cetak data
    writeln(Data); // beri baris
    flush(Data); // simpan perubahan
    end;
  close(Data); // tutup file
  Textcolor(green); // ubah warna text
  if pilihan = 1 then // jika identifikasi = nama dan nik..
    writeln('Check-in dengan kode (',nama,',',nik,') berhasil!');
  if pilihan = 2 then // jika identifikasi = kredit..
    writeln('Check-in dengan kode (',kredit,') berhasil!');
  Textcolor(white); // kembalikan warna
  write('Kamar pengguna berada di '); // cetak nomor kamar yang diisi
  Textcolor(yellow);
  if kamar < 10 then
    write('(kamar 0')
  else
    write('(kamar ');
  writeln(kamar,')');
  Textcolor(white);
  end;
Penutup:
end; // end prosedur

procedure CheckOut; // check-out pengguna kamar
var
  a,b,pencacahA,pemanduSed,pemanduDat,posisiSalah: integer;
  letakKamar,kemiripanData,kemiripanData2,ketemuNama,kamar: integer;
  NamaSpesifik: array [1..14] of integer;
  kamarAtauNama,pemanduStr: string;
  Sedia,Riwayat,Data: text;
  BacaSedia: array [1..3000] of string;
  BacaBaris: array [1..10] of string;
  pilihan: integer;
  valid,cekKamarNama,errorCetakSedia: boolean;
  ulang,lanjut: char;
label UlangInputKamarAtauNama, UlangInputKamarBanyak, Penutup;
begin
pencacahA:=1; pemanduSed:=0; pilihan:=0; pemanduDat:=0; kemiripanData:=0;
kemiripanData2:=9; ketemuNama:=0; kamar:= 0; letakKamar:=0;
valid:=true; cekKamarNama:= false; errorCetakSedia:= false; {inisialisasi}
assign(Data,'Data.txt');
assign(Sedia,'Sedia.txt');
assign(Riwayat,'RiwayatData.txt'); // hubungkan variabel ke file

clrscr;
garis('=');
writeln('CHECK-OUT KAMAR HOTEL AMAN SENTOSA');
writeln;
writeln('*Note : Harap perhatikan daftar check-out hari ini!');
garis('-');
UlangInputKamarAtauNama:
write('Masukkan nomor kamar atau nama : ');readln(kamarAtauNama); // input nama atau nomor kamar
val(kamarAtauNama,kamar,posisiSalah); // coba konversi ke angka 
if posisiSalah > 0 then // jika gagal konversi.. maka pilihan adalah nama
  begin
  pilihan:= 2; // pilihan adalah nama
  cekNama(kamarAtauNama,valid); // validasi serta ubah format nama
  if not valid then // jika invalid..
    begin 
    cetakInvalid(0,0,3,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput nama atau nomor kamar
      goto UlangInputKamarAtauNama
    else
      goto Penutup; // selain itu.. invalid dan menuju penutup
    end;
  end;
if (pilihan = 0) AND ((kamar < 1) or (kamar > 10)) then
  begin // jika pilihan adalah nomor kamar.. dan nomor kamar 
  Textcolor(red);
  write('Pilihan kamar invalid!');
  Textcolor(white);
  cetakInvalid(0,1,0,ulang); // menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput nama atau nomor kamar
    goto UlangInputKamarAtauNama
  else
    goto Penutup; // selain itu.. invalid dan menuju penutup
  end;
reset(Sedia); // buka file untuk dibaca
while not eof(Sedia) do // baca dan salin seluruh data {KEMUNGKINAN ERROR (belum ada kasus)}
  begin
  readln(Sedia,BacaSedia[pencacahA]); // cari dan baca simbol
  if (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
    begin // jika simbol menandakan kamar kosong..
    pemanduSed:= pemanduSed + 1;
    pencacahA:= pencacahA + 1; // pemandu BacaBaris
    readln(Sedia); // lewati jarak
    end;
  if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
    begin // jika simbol menandakan kamar terisi..
    for a:=1 to 9 do // baca data
      begin
      pencacahA:= pencacahA + 1;
      readln(Sedia,BacaSedia[pencacahA]); // baca dan salin data
      end;
    pemanduSed:= pemanduSed + 1;
    pencacahA:= pencacahA + 1; // majukan slot array ke slot kosong
    if pemanduSed = kamar then // jika kamar sama dengan input nomor kamar..
      letakKamar:= kamar; // salin letaknya
    if (pilihan = 2) AND (pos(kamarAtauNama,BacaSedia[pencacahA - 8]) > 0) then
      begin // jika pilihan adalah nama, maka jika nama ditemukan..
      ketemuNama:= ketemuNama + 1; // pemandu jumlah nama yang ditemukan
      NamaSpesifik[ketemuNama]:= pemanduSed; // simpan nomor kamar nama yang ditemukan
      end;
    end;
  end; //endwhile
close(Sedia); // tutup file
pencacahA:=1; pemanduSed:=0; {inisialsiasi baru}
if (ketemuNama = 0) and (pilihan = 2) then
  begin // jika nama tidak ditemukan..
  Textcolor(red);
  writeln('Nama tidak ada/kamar kosong!');
  Textcolor(white);
  end
else if (ketemuNama = 1) and (pilihan = 2) then
  letakKamar:= NamaSpesifik[1] // jika hanya satu nama yang ditemukan.. salin letak kamar
else if (ketemuNama > 1) and (pilihan = 2) then  
  begin // jika banyak nama yang ditemukan.. salin letak kamar pilihan
  Textcolor(yellow);
  writeln('Beberapa kamar dibeli atas nama tersebut!');
  Textcolor(white);
  UlangInputKamarBanyak:
  write('Pilih kamar (');
  for a:=1 to ketemuNama do // cetak nomor kamar yang ditemukan
    begin
    if a < ketemuNama then
      write(NamaSpesifik[a],'/')
    else
      write(NamaSpesifik[a]);
    end; // 'pilih kamar (3/5/7)' contoh
  write(') : ');readln(pemanduStr); // input pilihan pengguna
  val(pemanduStr,kamar,posisiSalah); // coba konversi ke angka
  if posisiSalah > 0 then // jika gagal dikonversi..
    begin
    cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
      goto UlangInputKamarBanyak
    else
      goto Penutup; // selain itu.. invalid dan menuju penutup
    end;
  for a:=1 to ketemuNama do // cek apakah pilihan valid
    begin
    if NamaSpesifik[pencacahA] = kamar then // jika pilihan benar valid..
      cekKamarNama:= true; // true
    pencacahA:= pencacahA + 1; // pemandu NamaSpesifik
    end;
  pencacahA:= 1; {inisialisasi Baru}
  if not cekKamarNama then // jika pilihan invalid..
    begin
    cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
      goto UlangInputKamarBanyak
    else
      goto Penutup; // selain itu.. invalid dan menuju penutup
    end;
  letakKamar:= kamar; // selain itu.. salin nomor kamar yang dipilih
  end;
if (letakKamar = 0) and (pilihan < 2) then
  begin // jika kamar kosong dan pilihan nomor kamar..
  Textcolor(red);
  writeln('Kamar kosong!');
  Textcolor(white);
  end
else if letakKamar > 0 then
  begin // jika kamar terisi dan pilihan nomor kamar
  write('Konfirmasi check-out? '); // konfirmasi?
  Textcolor(yellow);
  if letakKamar = 10 then
    write('{Kamar = ',letakKamar,'} ') // cetak nomor kamar
  else
    write('{Kamar = 0',letakKamar,'} ');
  Textcolor(white);
  write(' (y/t) : ');readln(lanjut); // input pengguna
  if not (lanjut in ['y','Y']) then
    goto Penutup; // jika tidak dikonfirmasi.. menuju penutup
  rewrite(Sedia); // jika dikonfirmasi.. menghapus isi data dan membukanya untuk ditulis
  repeat //--{BELUM ADA KASUS, JIKA ADA KENDALA, TOLONG HUBUNGI} menggunakan bug killer yang sama seperti check-In
  if (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
    begin // jika kamar kosong..
    pemanduSed:= pemanduSed + 1; // pencacah a sangat rentan bug disini, maka diganti pemandu dan repeat
    writeln(Sedia,BacaSedia[pencacahA]); // cetak simbol
    writeln(Sedia); // beri jarak
    pencacahA:= pencacahA + 1;
    flush(Sedia); // simpan perubahan data pada file
    end;
  if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
    begin // jika kamar terisi..
    pemanduSed:= pemanduSed + 1; // pencacah a sangat rentan bug disini, maka diganti pemandu dan repeat
    if pemanduSed = letakKamar then // jika nomor kamar mencapai data nomor kamar..
      begin
      if kamar < 6 then // jika kamar kurang dari 6
        writeln(Sedia,'$') // cetak simbol atau kosongkan kamar
      else if kamar > 5 then // jika kamar kurang dari 5
        writeln(Sedia,'&'); // cetak simbol
      for a:=1 to 9 do // salin data ke array baru
        BacaBaris[a]:= BacaSedia[pencacahA + a];
      pencacahA:= pencacahA + 10; // majukan slot memori
      writeln(Sedia);
      flush(Sedia); // simpan perubahan data pada file
      end 
    else
      begin
      writeln(Sedia,BacaSedia[pencacahA]); // cetak simbol
      pencacahA:= pencacahA + 1; // majukan slot array
      for b:=1 to 8 do // cetak data
        begin
        if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) then
          begin //--pencegah error
          pencacahA:= pencacahA + 1; // majukan slot array
          errorCetakSedia:= true; // penanda adalah error!
          end; //--
        writeln(Sedia,BacaSedia[pencacahA]); // cetak data
        pencacahA:= pencacahA + 1;
        end;
      for a:=1 to 101 do // harus manual pada garis, karena bisa error!
        write(Sedia,'=');
      writeln(Sedia); // baris baru
      pencacahA:= pencacahA + 1; // majukan slot array
      if errorCetakSedia then //--JIKA ERROR
        begin
        for b:=1 to 4 do // mundurkan slot sampai ketemu simbol
          begin
          if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) or
              (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
            begin // jika simbol ditemukan..
            errorCetakSedia:= false; // sudah tidak ERROR
            writeln(Sedia); // beri jarak
            break; // hentikan
            end;
          pencacahA:= pencacahA - 1; // bila tidak ditemukan.. mundurkan slot
          end;
        if errorCetakSedia then // jika masih ERROR..
          begin
          pencacahA:= pencacahA + 4; // kembalikan posisi pemandu
          for b:=1 to 4 do // majukan slot sampai ketemu simbol
            begin
            if (pos('*',BacaSedia[pencacahA]) > 0) or (pos('#',BacaSedia[pencacahA]) > 0) or
              (pos('$',BacaSedia[pencacahA]) > 0) or (pos('&',BacaSedia[pencacahA]) > 0) then
              begin // jika simbol ditemukan..
              errorCetakSedia:= false; // sudah tidak ERROR
              writeln(Sedia); // beri jarak
              break; // hentikan
              end
            else if BacaSedia[pencacahA] = '' then
              begin // jika error adalah data corrupted.. beri tahu admin
              Textcolor(red); // (tidak ada solusi karena belum ada kasus)
              writeln('TERJADI KESALAHAN PADA PENCETAKAN DATA KAMAR!');
              Textcolor(white);
              errorCetakSedia:= false; // error telah ditangani sebisa mungkin
              break; // hentikan
              end;
            pencacahA:= pencacahA + 1; // majukan slot array
            end; //--Selesai penanganan error
          end;
        end
      else
        writeln(Sedia); // beri jarak
      flush(Sedia); // simpan perubahan data pada file
      end;
    end;
  until pemanduSed = 10; // hentikan jika kamar yang dicetak sampai 10
  close(Sedia); // tutup file
  append(Riwayat); // buka file untuk ditulis tanpa menghapus
  writeln(Riwayat,'$'); // cetak simbol
  for a:=1 to 9 do // cetak data
    writeln(Riwayat,BacaBaris[a]);
  pencacahA:= 1; kemiripanData2:=9; pemanduDat:=0; {inisialisasi}
  close(Riwayat); // tutup file
  reset(Data); // buka file untuk dibaca
  while not eof(Data) do // baca semua data
    begin
    readln(Data,BacaSedia[pencacahA]); // cari simbol
    if pos('$',BacaSedia[pencacahA]) > 0 then // jika ditemukan..
      begin
      pencacahA:= pencacahA + 10; // pemandu BacaSedia
      pemanduDat:= pemanduDat + 1; // pemandu nomor data
      for a:=(pencacahA - 9) to (pencacahA - 1) do
        begin // baca data dan bandingkan data
        readln(Data,BacaSedia[a]); // baca data pada baris tersebut
        if BacaBaris[kemiripanData + 1] = BacaSedia[a] then // jika data pada baris tersebut dan data sama..
          kemiripanData:= kemiripanData + 1; // menghitung kemiripan data
        kemiripanData2:= kemiripanData2 - 1; // pemandu BacaBaris (data yang disimpan)
        end;
      if kemiripanData = 9 then // jika data sama persis..
        begin
        pencacahA:= pencacahA - 10; // overwrite slot untuk data tersebut dengan data lain
        pemanduDat:= pemanduDat - 1; // overwrite nomor data
        end;
      kemiripanData2:=9; kemiripanData:= 0; {inisialisasi lagi}
      end;
    end;
  pencacahA:=1; {inisialisasi baru}
  rewrite(Data); // hapus isi data dan buka untuk dibaca
  for a:=1 to pemanduDat do // cetak data sampai data terakhir
    begin 
    pencacahA:= pencacahA + 10; // pemandu BacaBaris
    for b:=(pencacahA - 10) to (pencacahA - 1) do // cetak simbol serta data
        writeln(Data,BacaSedia[b]);
    writeln(Data); // beri jarak
    flush(Data); // simpan perubahan
    end;
  close(Data); // tutup file
  writeln;
  Textcolor(green); // cetak pesan berhasil
  if pilihan = 2 then
    begin
    if letakKamar < 10 then
      writeln('Check-out (',kamarAtauNama,', 0',letakKamar,') berhasil!')
    else
      writeln('Check-out (',kamarAtauNama,', ',letakKamar,') berhasil!');
    end
  else
    writeln('Check-out kamar ke-',letakKamar,' berhasil!');
  Textcolor(white);
  end;
Penutup:
end; // end prosedur

procedure HapusData; // menghapus data atau memindahkan ke riwayat
var
  Data,Riwayat: text;
  BacaBaris: array [1..3000] of string;
  pemanduBerbeda: array [1..70] of integer;
  nama,kredit,nik,pemanduStr: string;
  ulang: char;
  valid: boolean;
  a,b,pencacahA,pencacahB,pemanduA,pemanduDat,ketemuData: integer;
  pilihan,pilihan2,namaData,nikData,kreditData: integer;
label UlangAwal, UlangInputPilihan, UlangInputPilihan2, UlangInputNik, UlangInputKredit,
      UlangInputNamaNikKre, Penutup;
begin
UlangAwal:
pencacahA:=10; pencacahB:=0; pemanduA:=0; pemanduDat:=0;
ketemuData:=0; valid:=true; nama:= ''; kredit:= ''; nik:= ''; {inisialisasi}
assign(Riwayat,'RiwayatData.txt');
assign(Data,'Data.txt'); // hubungkan variabel ke file

clrscr;
garis('=');
writeln('HAPUS DATA HOTEL AMAN SENTOSA');
writeln;
writeln('*Note : Harap perhatikan dengan teliti data yang dihapus!');
garis('-');
UlangInputPilihan:
write('Hapus data/pindahkan data ke riwayat (1/2) : ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,pilihan,posisiSalah); // mencoba dikonversi
if posisiSalah > 0 then // jika gagal konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
if not (pilihan in [1,2]) then // jika pilihan tidak ada..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
UlangInputNamaNikKre:
write('Masukkan nama : ');readln(nama); // input nama idenfitikasi
cekNama(nama,valid);
if not valid then // jika invalid..
  begin
  cetakInvalid(0,0,3,ulang); // menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput nama
    goto UlangInputNamaNikKre
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
UlangInputNik:
write('Masukkan NIK : ');readln(nik); // input nama NIK idenfitikasi
cekInteger('NIK',nik,16,valid);
if not valid then // jika invalid..
  begin 
  cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput nik
    goto UlangInputNik
  else if ulang in ['1'] then // jika pilihan 'dari awal'.. kembali ke menginput nama
    goto UlangInputNamaNikKre
  else
    goto Penutup; // selain itu.. menuju penutup
  end; 
UlangInputKredit:
write('Masukkan kredit : ');readln(kredit); // input nama nomor kredit idenfitikasi
cekInteger('Kredit',kredit,16,valid);
if not valid then // jika invalid..
  begin 
  cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput kredit
    goto UlangInputKredit
  else if ulang in ['1'] then // jika pilihan 'dari awal'.. kembali ke menginput nama
    goto UlangInputNamaNikKre
  else 
    goto Penutup; // selain itu.. menuju penutup
  end;
reset(Data); // buka data untuk dibaca
while not eof(Data) do // membaca seluruh data
  begin
  readln(Data,BacaBaris[pencacahA - 9]); // cari simbol
  if pos('$',BacaBaris[pencacahA - 9]) > 0 then // jika ditemukan..
    begin
    pemanduDat:= pemanduDat + 1; // pemandu nomor data 
    for b:=(pencacahA - 8) to pencacahA do // salin semua baris data
      readln(Data,BacaBaris[b]);
    namaData:= pos(' '+nama+'|',BacaBaris[pencacahA - 7]); // simpan jika nama ditemukan
    nikData:= pos(nik,BacaBaris[pencacahA - 7]);  // simpan jika NIK ditemukan
    kreditData:= pos(kredit,BacaBaris[pencacahA - 6]);  // simpan jika kamar ditemukan
    if (namaData > 0) AND (nikData > 0) AND (kreditData > 0) then // jika data mirip dengan inputan data..
      begin
      ketemuData:= ketemuData + 1; // pemandu 'pemanduBerbeda' dan hitung data yang ditemukan
      pemanduBerbeda[ketemuData]:= pemanduDat; // salin nomor data
      end;
    pencacahA:= pencacahA + 10; // majukan pemandu
    end;
  end;
if (eof(Data)) AND (ketemuData = 0) then
    begin // jika file berakhir dan data tidak ditemukan 
    close(Data); // tutup file
    valid:= false; // valid = false
    Textcolor(red);
    writeln('Nama/NIK/Kredit tidak ditemukan ');
    Textcolor(white);
    goto Penutup // menuju penutup
    end;
close(Data); // tutup file
if valid then // jika valid..
  begin
  if ketemuData = 1 then // jika data yang ditemukan hanya 1..
    pencacahB:= pemanduBerbeda[1] * 10 // simpan kordinat
  else
    begin
    Textcolor(yellow);
    writeln('Beberapa data ditemukan!');
    Textcolor(white);
    for a:=1 to ketemuData do // cetak seluruh data benar yang ditemukan
      begin
      pemanduA:= pemanduA + 1; // pemandu nomor data benar yang ditemukan
      writeln('Data ke-',pemanduA,' :');
      pencacahB:= pemanduBerbeda[pemanduA] * 10 - 8; // pencacahA dipindahkan ke kordinat data
      writeln(BacaBaris[pencacahB]); // cetak baris pertama
      writeln(BacaBaris[pencacahB + 1]); // cetak baris kedua
      writeln(BacaBaris[pencacahB + 3]); // cetak baris keempat
      writeln(BacaBaris[pencacahB + 6]); // cetak baris ketujuh
      writeln(BacaBaris[pencacahB + 8]); // cetak baris kesembilan
      if (pemanduA mod 4 = 0) AND (not(pemanduA = ketemuData)) then // jika data yang telah dicetak, kelipatan 4..
        readln // tunggu perintah enter
      else
        writeln; // selain itu.. beri jarak
      end;
    UlangInputPilihan2:
    if pilihan = 2 then // jika pilihan memindahkan data ke riwayat..
      write('Pilih data yang dipindahkan : ')
    else // selain itu..
      write('Pilih data yang dihapus : ');
    readln(pemanduStr); // input pilihan pengguna
    val(pemanduStr,pilihan2,posisiSalah); // coba konversi input ke integer
    if posisiSalah > 0 then  // jika gagal
      begin
      cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan 2
        goto UlangInputPilihan2
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    if (pilihan2 > ketemuData) or (pilihan2 < 1) then
      begin // jika pilihan tidak ada..
      Textcolor(red);
      write('Nomor invalid!');
      Textcolor(white);
      cetakInvalid(0,1,0,ulang); // menanyakan jika penguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan 2
        goto UlangInputPilihan2
      else
        goto Penutup; // selain itu.. menuju penutup
      end
    else if (pilihan2 <= ketemuData) or (pilihan2 > 0) then
      pencacahB:= pemanduBerbeda[pilihan2] * 10; // pilihan valid.. maka simpan nomor data benar
    end;
  pencacahA:= pencacahB - 8; // pindahkan pencacahA ke kordinat data benar
  clrscr;
  for a:=1 to 9 do // cetak data benar ke layar
    begin
    writeln(BacaBaris[pencacahA]);
    pencacahA:= pencacahA + 1;
    end;
  writeln;
  Textcolor(yellow);
  if pilihan = 2 then // jika pilihan adalah pemindahan data..
    write('Konfirmasi pemindahan? (y/t) : ')
  else // selain itu..
    write('Konfirmasi penghapusan? (y/t) : ');
  readln(ulang); // input pilihan pengguna
  if not (ulang in ['y','Y']) then
    goto UlangAwal; // jika pilihan tidak.. menuju ulangawal
  writeln; // jika ya.. beri jarak
  pencacahA:= 1; {inisialisasi baru}
  rewrite(Data); // hapus isi file dan buka untuk dibaca
  for a:=1 to (pemanduDat - 1) do // cetak seluruh data kecuali data yang dipilih
    begin
    if pencacahA = (pencacahB - 9) then // jika kordinat data adalah yang dipilih..
      pencacahA:= pencacahA + 10; // skip data 
    writeln(Data,BacaBaris[pencacahA]); // cetak simbol
    pencacahA:= pencacahA + 10; // tambahkan pencacah
    for b:=(pencacahA - 9) to (pencacahA - 1) do // cetak data
        writeln(Data,BacaBaris[b]);
    writeln(Data); // beri jarak
    flush(Data); // simpan perubahan
    end;
  if pilihan = 2 then // jika pilihan memindahkan data
    begin
    pencacahA:= pencacahB - 9; {inisialisasi kordinat data benar}
    append(Riwayat); // tumpuk data di baris terakhir file
    for a:=1 to 10 do // cetak data
      begin
      writeln(Riwayat,BacaBaris[pencacahA]);
      pencacahA:= pencacahA + 1;
      end;
    close(Riwayat); // tutup file
    end;
  close(Data); // tutup file
  Textcolor(green);
  if pilihan = 2 then // pesan berhasil jika pilihan kedua
    writeln('Pemindahan data berhasil!')
  else // pesan berhasil jika pilihan pertama
    writeln('Penghapusan data berhasil!');
  Textcolor(white);
  end;
Penutup:
end; // end prosedur

procedure CetakStruk; // mencetak struk
var 
  simbol,nama,nik,kredit,pemanduStr: string;
  ulang: char;
  a,b,pilihan,pilihan2,pilihan3,pemanduA,posisiSalah: integer;
  BacaBaris: array [1..9] of string;
  valid, ketemuData2: boolean;
  fileDataAtauRiwayat: text;
label UlangInputPilihan, UlangInputPilihan2, UlangInputPilihan3,
      UlangInputNama, UlangInputNama2, UlangInputNik, UlangInputKredit, Penutup;
begin
pemanduA:=0; valid:=true; ketemuData2:= false; 
nama:= ''; kredit:= ''; nik:= '';{inisialisasi}
clrscr;
garis('=');
writeln('CETAK STRUK / RIWAYAT PEMBELIAN');
writeln;
writeln('*Note : Pastikan pelanggan bukan penipu!');
garis('-');

UlangInputPilihan:
write('Lihat keseluruhan data/Cetak struk (1/2) : ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,pilihan,posisiSalah); // coba konversi ke integer
if posisiSalah > 0 then // jika terjadi kesalahan pada proses konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
if not (pilihan in [1,2]) then // jika input tidak sesuai pilihan..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;

UlangInputPilihan2:
write('Riwayat pembelian lalu/Pemesanan mendatang (1/2) : ');readln(pemanduStr); // input pilihan ke-2 pengguna
val(pemanduStr,pilihan2,posisiSalah); // mencoba mengkonversi ke integer 'Pilihan2'
if posisiSalah > 0 then // jika terjadi kesalahan pada proses konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan kedua
    goto UlangInputPilihan2
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
if not (pilihan2 in [1,2]) then // jika input tidak sesuai pilihan..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan kedua
    goto UlangInputPilihan2
  else
    goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
  end;

UlangInputPilihan3:
write('Cari menggunakan Nama dan NIK/Nama dan Kredit (1/2) : ');readln(pemanduStr); // input pilihan ke-3 pengguna
val(pemanduStr,pilihan3,posisiSalah); // mencoba mengkonversi ke integer 'Pilihan3'
if posisiSalah > 0 then // jika terjadi kesalahan pada proses konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan ketiga
    goto UlangInputPilihan3
  else
    goto Penutup; // selain itu.. menuju penutup
  end;

case pilihan3 of
  1: // jika pilihan ketiga adalah input dengan nama dan NIK..
    begin
    UlangInputNama:
    write('Masukkan nama (identifikasi) : ');readln(nama); // input nama pengguna
    cekNama(nama,valid); // cek serta penyesuaian format nama
    if not valid then // jika invalid..
      begin
      cetakInvalid(0,0,3,ulang); // menanyakan apakah pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput nama
        goto UlangInputNama
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    UlangInputNik:
    write('Masukkan NIK (identifikasi) : ');readln(nik); // input NIK pengguna
    cekInteger('NIK',nik,16,valid);  // cek NIK apakah bukan angka atau tidak 16 karakter
    if not valid then // jika invalid..
      begin
      cetakInvalid(0,0,4,ulang); // menanyakan apakah pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput NIK
        goto UlangInputNik
      else if ulang in ['1'] then // jika pilihan adalah '1'.. kembali ke menginput nama
        goto UlangInputNama
      else
        goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
      end;
    end;
  2: // jika pilihan ketiga adalah input dengan nomor kredit..
    begin
    UlangInputNama2:
    write('Masukkan nama (identifikasi) : ');readln(nama); // input nama pengguna
    cekNama(nama,valid); // cek serta penyesuaian format nama
    if not valid then // jika invalid..
      begin
      cetakInvalid(0,0,3,ulang); // menanyakan apakah pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput nama
        goto UlangInputNama2
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    UlangInputKredit:
    write('Masukkan nomor kredit (identifikasi) : ');readln(kredit); // input kredit pengguna
    cekInteger('Nomor kredit',kredit,16,valid); // cek nomor kredit apakah bukan angka atau tidak 16 karakter
    if valid then // jika valid..
      cekKredit(kredit,valid); // cek nomor kredit jika adalah angka 0 enam belas digit
    if not valid then // jika invalid..
      begin
      cetakInvalid(0,0,3,ulang); // menanyakan apakah pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput nomor kredit
        goto UlangInputKredit
      else if ulang in ['1'] then // jika pilihan adalah '1'.. kembali ke menginput nama
        goto UlangInputNama2
      else
        goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
      end;
    end;
  otherwise// jika input tidak sesuai pilihan..
    begin
    cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan ketiga
      goto UlangInputPilihan3
    else
      goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
    end;
  end;

{mempersiapkan sistem}
case pilihan2 of // assign file sesuai pilihan pertama pengguna
  1: assign(fileDataAtauRiwayat,'RiwayatData.txt');
  2: assign(fileDataAtauRiwayat,'Data.txt');
  end;
reset(fileDataAtauRiwayat); // membuka untuk membaca file
while not eof(fileDataAtauRiwayat) do // selama file belum berakhir..
  begin
  readln(fileDataAtauRiwayat, simbol); // cari simbol
  if pos('$',simbol) > 0 then // jika ditemukan..
    begin
    for a:=1 to 9 do // salin seluruh baris data
      readln(fileDataAtauRiwayat,BacaBaris[a]);
    if (pos(' '+nama+'|',BacaBaris[2]) > 0) AND (((pilihan3 = 1) and (pos(nik,BacaBaris[2]) > 0)) OR
        ((pilihan3 = 2) and (pos(kredit,BacaBaris[3]) > 0))) then // jika nama dan nik atau kredit ditemukan
        begin
        case pilihan of // perintah sesuai pilihan kedua
          1:
            begin // cetak seluruh data
            if pos('ON',simbol) > 0 then
              begin // jika sedang berlangsung..
              Textcolor(yellow);
              writeln('( Sedang Berlansung )');
              Textcolor(white);
              end;
            for b:=1 to 101 do // data error jika garis diambil dari file dan dicetak ke program..
              write('='); // maka dibentuk manual
            writeln;
            for b:=2 to 9 do // cetak baris baris data ke layar
              writeln(BacaBaris[b]);
            pemanduA:= pemanduA + 1; // penghitung data
            ketemuData2:= false; // pencegah readln
            end;
          2: // cetak struk
            begin
            for b:=1 to 101 do // bentuk garis
              write('=');
            writeln;
            writeln('Hotel Aman Sentosa Kota Palangkaraya, Keminting, Jl. Kecubung');
            for b:=1 to 101 do
              write('=');
            writeln;
            write('| Nama Pembeli: ',nama);
            gotoxy(101,wherey);writeln('|'); // cetak nama pengguna
            for b:=4 to 9 do // cetak data
              writeln(BacaBaris[b]);
            pemanduA:= pemanduA + 1; // penghitung data
            ketemuData2:= false; // pencegah readln
            end;
          end;
        end;
    if (pemanduA mod 2 > 0) then // jika data yang dicetak bukan kelipatan 2.. beri jarak
      writeln // beri jarak
    else if (not ketemuData2) AND (not(pemanduA = 0)) AND (pemanduA mod 2 = 0) then
      begin // jika kelipatan 2.. tunggu ENTER
      ketemuData2:= true; // mencegah readln lagi saat mencari data
      readln; // menunggu perintah ENTER
      end;
    end;
  end; //endwhile
if (eof(fileDataAtauRiwayat)) AND (pemanduA = 0) then 
    begin // jika file berakhir dan data tidak ditemukan..
    Textcolor(red);
    if pilihan3 = 1 then
      writeln('Nama/NIK tidak sesuai atau data tidak ada!')
    else
      writeln('Nomor kredit tidak sesuai atau data tidak ada!');
    Textcolor(white);
    end;
close(fileDataAtauRiwayat); // tutup file
Penutup:
end; // end prosedur

procedure RiwayatPemesananSingkat; // mencetak riwayat pemesanan dari yang terbaru (dari data.txt)
var
  a,b,pencacahA,pemanduA,pemanduDat,tujuan,jumlahIn: integer;
  simbol: char;
  BacaBaris: array [1..7] of string;
  Data: text;
label UlangInputJumlah, Penutup;
begin
UlangInputJumlah:
pencacahA:= 0; pemanduDat:= 0; tujuan:=0; pemanduA:=0; {inisialisasi}
assign(Data,'Data.txt'); // hubungkan variabel ke file

clrscr;
garis('=');
writeln('RIWAYAT PEMESANAN TERBARU HOTEL SENTOSA');
writeln;
writeln('*Note : Riwayat ini hanya menampilkan yang terbaru dan belum check-out!');
garis('-');
write('Masukkan jumlah yang anda ingin tampilkan : ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,jumlahIn,posisiSalah); // coba konversi ke integer 'jumlahIn'
if posisiSalah > 0 then // jika gagal..
  begin
  Textcolor(red);
  write('Jumlah harus angka!');
  Textcolor(white);
  cetakInvalid(0,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput jumlah
    goto UlangInputJumlah
  else
    goto Penutup; // selain itu.. ke penutup
  end;
reset(Data); // buka data untuk dibaca
while not eof(Data) do // hitung jumlah data pada file
  begin
  readln(Data,simbol); // cari simbol
  if simbol in ['$'] then // jika ditemukan..
    pemanduDat:= pemanduDat + 1; // hitung
  end;
close(Data); // tutup file
if (jumlahIn > pemanduDat) OR (jumlahIn > 27) then
  begin // jika jumlah terlalu banyak atau melewati jumlah pesanan kamar..
  Textcolor(red);
  write('Jumlah terlalu banyak!');
  Textcolor(white);
  cetakInvalid(0,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput jumlah
    goto UlangInputJumlah
  else
    goto Penutup; // selain itu.. ke penutup
  end;
tujuan:= pemanduDat - jumlahIn; // tujuan = nomor data yang dicapai
pemanduA:= jumlahIn; // inisialisasi pemanduA (pemandu nomor data yang ditampilkan)
for a:=1 to 97 do // cetak garis
  write('=');
writeln;
writeln('| NO |  TANGGAL   |  WAKTU   |            NAMA           |   NOMOR KREDIT   |  BIAYA SET PAJAK  |');
for a:=1 to 97 do // cetak garis
  write('=');
writeln;
for a:=1 to (jumlahIn - 1) do
  writeln; // berikan ruang untuk perintah 'gotoxy'
reset(Data); // buka data untuk dibaca
while tujuan > 0 do // skip semua data dan menuju kordinat data ke 'jumlahIn' dari yang paling akhir
  begin
  readln(Data, simbol);
  if simbol in ['$'] then 
    begin
    for a:=1 to 9 do
      readln(Data); // skip semua baris data
    tujuan:= tujuan - 1;
    end;
  end;
repeat
  readln(Data,simbol); 
  if simbol in ['$'] then 
    begin
    readln(Data); // skip baris pertama
    for b:=1 to 7 do // baca baris kedua sampai kedelapan
      begin
      pencacahA:= pencacahA + 1;
      readln(Data,BacaBaris[pencacahA]);
      end;
    pencacahA:= 0; {inisialisasi pencacahA kembali} // cetak data ke layar
    writeln('| ',pemanduA:2,' | ',copy(BacaBaris[6],7,10),' | ',copy(BacaBaris[6],19,8),' | ',
            copy(BacaBaris[1],10,25),' | ',copy(BacaBaris[2],85,16),' |  ',copy(BacaBaris[6],85,16),' |');
    pemanduA:= pemanduA - 1; // pemandu nomor data (dari jumlah yang diinginkan)
    gotoxy(1,(wherey - 2));
    readln(Data); // skip baris kesembilan
    end;
until pemanduA = 0; // (data dicetak dari bawah)
gotoxy(1,(wherey + jumlahIn + 1)); // krusor menuju baris selanjutnya dari data tabel pada layar
for a:=1 to 97 do // cetak garis pembatas tabel pada layar
  write('=');
writeln;
close(Data); // tutup file
Penutup:
end; // end prosedur

procedure HapusUlasan; // menghapus ulasan (staff menjaga janjinya untuk tidak menutup suara publik)
var
  pilihan,pilihan2: integer;
  ulang: char;
  password,pemanduStr: string;
  BacaBaris: array [1..4] of string;
  BacaSedia: array [1..700] of string;
  a,b,pencacahA,pemanduA,pemanduB,pemanduC,pemanduUlas,posisiSalah: integer;
  Ulas: text;
label Awal,UlangInputPilihan,UlangInputPilihan2,UlangInputPassword,
      Penutup;
begin
pencacahA:=1; pemanduA:=0; pemanduB:=4; pemanduC:= 0; pemanduUlas:=0; {inisialisasi}
assign(Ulas,'Ulasan.txt'); // menghubungkan variabel ke file

clrscr;
reset(Ulas); // buka file untuk dibaca
for a:=1 to 4 do // baca dan tulis judul file ulasan
  begin
  readln(Ulas, BacaBaris[a]);
  writeln(BacaBaris[a]);
  end;
writeln;
while not eof(Ulas) do // selama file belum berakhir..
  begin
  readln(Ulas, BacaSedia[pencacahA]); // mencari kata kunci 'Pengguna'
  if pos('Pengguna',BacaSedia[pencacahA]) > 0 then // jika ditemukan..
    begin
    pemanduUlas:= pemanduUlas + 1; // hitung nomor ulasan
    for b:=1 to 6 do // baca seluruh baris ulasan
      begin
      pencacahA:= pencacahA + 1; // pemandu BacaSedia
      readln(Ulas, BacaSedia[pencacahA]); // baca baris file
      if pos('Bintang  :',BacaSedia[pencacahA]) > 0 then // jika kata kunci 'Bintang :' ditemukan..
        break; // hentikan
      end; 
    pencacahA:= pencacahA + 1; // majukan slot array
    end;
  end;
close(Ulas); // tutup file
pencacahA:= 0; {inisialisasi baru}
Awal:
for a:=(pemanduB - 3) to pemanduB do // cetak 4 data ulasan
  begin
  pemanduC:= pemanduC + 1; // pemandu nomor ulasan
  Textcolor(yellow);
  write(pemanduC,'.'); // nomor ulasan
  Textcolor(white);
  for b:=1 to 7 do // membaca dan menulis baris sesuai batas maksimal baris data
    begin
    gotoxy(4,wherey); // menuju horizontal nomor empat
    pencacahA:= pencacahA + 1; // pemandu BacaSedia
    writeln(BacaSedia[pencacahA]); // cetak data
    if pos('Bintang  :',BacaSedia[pencacahA]) > 0 then // jika kata kunci 'Bintang :' ditemukan..
      begin
      gotoxy(1,wherey); // menuju horizontal pertama
      break; // hentikan
      end;
    end;
  if (pemanduC < pemanduB) AND (pemanduC < pemanduUlas) then
    writeln // jika ulasan belum berakhir atau belum kelipatan 4.. beri jarak
  else if pemanduC = pemanduUlas then // jika semua ulasan telah dicetak..
    begin
    writeln;
    Textcolor(red); // ubah warna text
    writeln('Ulasan habis!');
    Textcolor(white);
    break; // hentikan
    end;
  end;
pemanduB:= pemanduB + 4; // pemandu nomor ulasan yang ditampilkan
garis('-');

UlangInputPilihan:
write('Selanjutnya / Hapus Ulasan / Keluar (1/2/3) : ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,pilihan,posisiSalah); // mencoba mengkonversi ke integer pilihan
if posisiSalah > 0 then // jika gagal..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan
  else // selain itu..
    goto Penutup; // menuju penutup
  end;
case pilihan of // case sesuai pilihan pertama
  1: // 'selanjutnya'
    begin
    if pemanduC = pemanduUlas then // jika file berakhir..
      begin
      Textcolor(red);
      writeln('Semua ulasan telah ditampilkan!'); // maka invalid..
      Textcolor(white);
      goto UlangInputPilihan; // dan menuju input pilihan
      end
    else // jika file belum berakhir..
      begin
      garis('-'); // beri pembatas yaitu garis
      goto Awal; // menuju 'Awal'
      end;
    end;
  2: // 'Hapus ulasan'
    begin
    UlangInputPassword:
    write('Masukkan password Hotel (konfirmasi) : ');readln(password); // input password admin
    if not cekPassword(password) then // jika password invalid..
      begin
      Textcolor(red);
      write('Password invalid!');
      Textcolor(white);
      cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput password
        goto UlangInputPassword
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    UlangInputPilihan2:
    write('Masukkan nomor komentar : ');readln(pemanduStr); // input pilihan pengguna
    val(pemanduStr,pilihan2,posisiSalah); // coba konversi ke angka
    if posisiSalah > 0 then // jika gagal..
      begin
      cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
        goto UlangInputPilihan
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    if (pilihan2 < 1) OR (pilihan2 > pemanduUlas) then
      begin
      cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika penguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali menginput pilihan
        goto UlangInputPilihan
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    clrscr;
    Textcolor(red);
    garis('-'); // pembatas
    Textcolor(white);
    pencacahA:= 1; pemanduB:=0; {inisialisasi baru}
    for a:=1 to pemanduUlas do // cari kordinat ulasan
      begin
      pemanduB:= pemanduB + 1; // pemandu nomor ulasan {a rentan error}
      if pemanduB = pilihan2 then
        break // jika sudah sampai nomor ulasan yang dipilih.. hentikan
      else // jika belum
        for b:=1 to 6 do // skip ulasan sampai baris terakhir ulasan
          begin
          pencacahA:= pencacahA + 1; // skip ulasan
          if pos('Bintang  :',BacaSedia[pencacahA]) > 0 then
            break; // jika sudah mencapai baris akhir ulasan.. hentikan
          end;
      pencacahA:= pencacahA + 1; // majukan slot array (ulasan selanjutnya)
      end;
    for a:=1 to 7 do // cetak ulasan ke layar untuk konfirmasi
      begin
      pemanduA:= pemanduA + 1; // penghitung baris ulasan yang dipilih
      writeln(BacaSedia[pencacahA]); // cetak ulasan
      if pos('Bintang  :',BacaSedia[pencacahA]) > 0 then
        break; // jika sudah mencapai baris akhir ulasan.. hentikan
      pencacahA:= pencacahA + 1;
      end;
    Textcolor(red);
    garis('-');
    Textcolor(yellow);
    write('Konfirmasi penghapusan? (y/t) : ');readln(ulang); // input pilihan admin
    Textcolor(white);
    if not (ulang in ['y','Y']) then // jika tidak dikonfirmasi..
      goto Penutup; // menuju penutup
    pencacahA:= 0; pemanduB:=0; {inisialisasi baru}
    rewrite(Ulas); // hapus data pada file dan buka file untuk ditulis
    for a:=1 to 4 do
      writeln(Ulas,BacaBaris[a]); // cetak judul ulasan
    writeln(Ulas); // beri jarak
    for a:=1 to (pemanduUlas - 1) do // cetak semua ulasan kecuali yang dipilih
      begin
      pemanduB:= pemanduB + 1; // pemandu nomor ulasan {a rentan error}
      if pemanduB = pilihan2 then // jika sudah sampai nomor ulasan yang dipilih..
        pencacahA:= pencacahA + pemanduA; // skip ulasan tersebut
      for b:=1 to 7 do // cetak seluruh baris ulasan
        begin
        pencacahA:= pencacahA + 1;
        writeln(Ulas,BacaSedia[pencacahA]); // cetak ulasan
        if pos('Bintang  :',BacaSedia[pencacahA]) > 0 then
          break; // jika telah mencapai baris terakhir.. hentikan
        end;
      writeln(Ulas); // beri jarak
      end;
    close(Ulas); // tutup file
    Textcolor(green); 
    writeln('Komentar berhasil dihapus!'); // pesan ulasan telah dihapus
    Textcolor(white);
    end;
  3: goto Penutup; // 'keluar'.. menuju penutup
  otherwise
    begin
    cetakInvalid(1,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
      goto UlangInputPilihan
    else // selain itu..
      goto Penutup; // dan menuju penutup
    end;
  end; //endcaseof
Penutup:
end; // end procedure

  {program utama}
begin
{deklarasi awal: }
WaktuSekarang:= now; pemanduA:=0; keluar:= false; {inisialisasi}

{identifikasi staf: }
clrscr; // membersihkan layar
write('Masukkan password : ');readln(password); // input password dari admin
delay(600); // upaya memperlambat cyberattack 'bruteforce'
if not cekPassword(password) then  // jika password bukan 'KamarGacor69'..
  begin
  Textcolor(red); 
  writeln('Password Invalid!'); // maka invalid.. dan menghentikan program
  Textcolor(white);
  readln; // mencegah program ditutup sebelum key ENTER ditekan
  halt; // menghentikan paksa program
  end;
{cek file: }
if not (FileExists('Data.txt') AND FileExists('RiwayatData.txt') AND FileExists('RiwayatUlasan.txt') AND
    FileExists('Sedia.txt') AND FileExists('Ulasan.txt')) then // jika file tidak lengkap..
    begin
    Textcolor(yellow);
    write('File ');
    Textcolor(white);
    write('yang akan digunakan '); // maka invalid dan menuju penutup
    Textcolor(red);
    write('tidak lengkap'); 
    Textcolor(white);
    writeln('!');
    writeln('Kami sarankan untuk mendownload kembali program dari web resmi hotel!');
    goto Penutup;
    end;

{Menu Utama: }
repeat
UlangAwal: // Label UlangAwal jika pengguna ingin mengulangi setelah invalid
pemanduA:= pemanduA + 1; // pemandu berapakali menu utama dijalankan (cegah bug)
clrscr;
garis('=');
writeln('HOTEL AMAN SENTOSA');
garis('=');
writeln(' Pilihan: ');
writeln(' 1. Pesan kamar offline');
writeln(' 2. Cek Ketersediaan Kamar');
writeln(' 3. Daftar check-in/check-out hari ini');
writeln(' 4. Check-in');
writeln(' 5. Check-out');
writeln(' 6. Hapus Data');
writeln(' 7. Cetak Struk/Riwayat Pemesanan');
writeln(' 8. Riwayat pemesanan singkat');
writeln(' 9. Hapus ulasan');
writeln('10. Keluar');
garis('-');

{sistem: }
write('Masukkan pilihan: ');readln(pemanduStr);
if (pemanduA > 1) AND (not keluar) then // mencegah bug (jika menu utama dijalankan lebih dari sekali, readln tidak dibaca program)..
  readln(pemanduStr); // caranya menerapkan readln sekali lagi (berhasil)
val(pemanduStr,pilihan,posisiSalah); // mencoba mengkonversi input menjadi integer 'pilihan'
if posisiSalah > 0 then // jika ada kesalahan konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ingin mengulangi atau input adalah 'y','Y'.. kembali ke UlangAwal
    begin
    keluar:= true; // mencegah bug readln 2 kali
    goto UlangAwal;
    end
  else
    begin
    garis('='); // selain itu.. menuju penutup
    writeln('Sampai jumpa');
    goto Penutup;
    end;
  end;
keluar:= false;  // mencegah bug readln 2 kali, sekaligus untuk prosedur Ulangi
case pilihan of // case..of sesuai menu utama
    1: DataLengkapPemesanan; // pemesanan kamar offline
    2: CekKamar; // memeriksa ketersediaan kamar (lebih canggih)
    3: CekPenggunaHariIni; // memeriksa pengguna kamar hari ini, dan pelanggaran jika ada
    4: CheckIn; // check-in pengguna kamar
    5: CheckOut; // check-in pengguna hotel
    6: HapusData; // menghapus data mereka yang tidak pernah check-in atau lainnya
    7: CetakStruk; // mencetak struk atau mencari riwayat pembelian
    8: RiwayatPemesananSingkat; // melihat pemesanan terbaru sampai jumlah yang dipilih
    9: HapusUlasan; // menghapus ulasan (yang tidak wajar)
    10: // keluar
      begin
      garis('='); 
      writeln('Sampai jumpa');
      goto Penutup;
      end;
    otherwise // selain itu.. invalid
      begin
      cetakInvalid(1,1,0,ulang); // (1,1,0) mencetak pesan invalid dan menanyakan admin jika ingin mengulang
      if ulang in ['y','Y'] then // jika ya.. maka kembali ke UlangAwal
        begin
        keluar:= true;  // mencegah bug readln 2 kali
        goto UlangAwal;
        end
      else
        begin
        garis('=');
        writeln('Sampai jumpa'); // selain itu.. menuju penutup
        goto Penutup;
        end;
      end;
    end;
garis('='); // mencetak garis
Ulangi(keluar); // prosedur 'Ulangi'
until keluar; // repeat berakhir saat value 'keluar' = true
Penutup: // penutup
readln; // menunggu sebelum menutup program
end.
