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

function HitungHari(hari,bulan,tahun: string): double;// mengkonversi tanggal menjadi hari
var
  jumlahHariLint: TDateTime;
  jumlahHariStr: string;
begin
HitungHari:= 0; {inisialisasi}
jumlahHariLint:= StrToDate(hari +'/'+ bulan +'/'+ tahun,'dd/mm/yyyy','/'); // konversi tanggal menjadi jumlah hari
str(jumlahHariLint,jumlahHariStr); // menyalin TDateTime ke str
val(jumlahHariStr,HitungHari); // mengubah str menjadi real(double)
end;

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

{mengkonversi biaya hasil hitung menjadi string dan menambahkan titik pembatas angka agar mudah dibaca dan sesuai standar}
procedure konversiBiaya(biaya,biayaSPajak: double;var biayaStr,biayaSPajakStr: string);
begin
str(biaya:0:0,biayaStr); //--mengkonversi biaya dan biaya setelah pajak menjadi str
str(biayaSPajak:0:0,biayaSPajakStr); //--
if length(biayaStr) > 3 then // jika panjang karakter biaya melebihi 3 karakter.. maka tambahkan titik
  insert('.',biayaStr,(length(biayaStr) - 2));
biayaStr:= biayaStr + '.000.000'; // tambahkan 6 angka nol, yaitu ratusan dan ribuan pada biaya
if length(biayaStr) > 15 then // jika panjang biaya melebihi 15 karakter.. maka titik dihilangkan (agar muat pada data)
  menghapus('.',biayaStr);
if length(biayaSPajakStr) > 3 then // jika panjang karakter biaya Set pajak melebihi 3 karakter.. maka tambahkan titik
  insert('.',biayaSPajakStr,(length(biayaSPajakStr) - 2));
biayaSPajakStr:= biayaSPajakStr + '.000.000'; // tambahkan 6 angka nol, yaitu ratusan dan ribuan pada biaya Set pajak
if length(biayaSPajakStr) > 15 then // jika panjang biaya melebihi 15 karakter.. maka titik dihilangkan (agar muat pada data)
  menghapus('.',biayaSPajakStr);
end;// format akhir = 100.300.000.000

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
 // hapus kalimat ini dan masukkan prosedur datalengkappemesanan (1)

 // hapus kalimat ini dan masukkan prosedur cekKamar (2)

 // hapus kalimat ini dan masukkan prosedur cekpenggunahariini (2)

 // hapus kalimat ini dan masukkan prosedur checkin (3)

 // hapus kalimat ini dan masukkan prosedur checkout (3)

 // hapus kalimat ini dan masukkan prosedur hapus data (3)

 // hapus kalimat ini dan masukkan prosedur cetakstruk (4)

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

 // hapus kalimat ini dan masukkan prosedur hapusulasan (1)

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
