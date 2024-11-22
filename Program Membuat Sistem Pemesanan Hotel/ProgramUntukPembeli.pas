program pesan_kamar_hotel_amansentosa_kel12; 
uses crt,sysutils; // deklarasi library
{$GOTO ON} // perubahan pengaturan program
type // deklarasi tipe
    informasi_pribadi = record
    nama         : string[27];
    nik          : string;
    umur         : string;
    nomor_kredit : string;
    end;
    informasi_data = record
    tanggal            : string[10];
    waktu              : string[8];
    kamar              : string;
    AwalWaktuPesan     : string[11];
    AkhirWaktuPesan    : string[11];
    Biaya, BiayaSpajak : string;
    end;
    informasi_tanggal = record
    AwalPemesanan  : string[11];
    AkhirPemesanan : string[11];
    end;
    informasiTanggal = array [1..40] of informasi_tanggal;
var // deklarasi variabel
  WaktuSekarang       : TDateTime;
  informasi_p         : informasi_pribadi;
  informasi_d         : informasi_data;
  informasi_t         : informasiTanggal;
  pemanduStr          : string;
  pilihan,posisiSalah,pemanduA : integer;
  keluar              : boolean;
  ulang               : char;
label UlangAwal,Penutup; // deklarasi label

{Prosedur dan fungsi: }
{Prosedur/fungsi Alat: }
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
procedure DataLengkapPemesanan; //Pesan Kamar secara online
var 
    kamar,jenis,umur: integer;
    a,b,pemanduB,posisiSalah: integer;
    BacaBaris,awalTanggal,akhirTanggal,pemanduStr: string;
    ulang,struk,pilihan,simbol: char;
    awalTanggalInLint,akhirTanggalInLint: TDateTime;
    awalTanggalLint,akhirTanggalLint,batasWaktuLint: TDateTime;
    biaya,biayaSPajak: double;
    valid: boolean;
    adaBi,adaDe,kosongBi,kosongDe: integer;
    Data: text;
    hari1,hari2,bulan1,bulan2,tahun1,tahun2: string;
label
  UlangInputKamar, UlangInputJenisKamar,
  UlangInputNama, UlangInputUmur,
  UlangInputNik, UlangInputKredit,
  UlangInputTanggalSatu,
  UlangInputTanggalDua,Penutup;
begin
pemanduB:=0; valid:= true;
informasi_d.AwalWaktuPesan:= '13:00:00';
informasi_d.AkhirWaktuPesan:= '12:00:00';
batasWaktuLint:= StrToTime('12:30:00',':'); {inisialisasi}
assign(Data,'Data.txt'); // menghubungkan variabel kepada file

clrscr;
garis('=');
writeln('  PEMESANAN KAMAR ONLINE');
garis('-');
writeln('Menu kamar: ');
writeln(' 1. Kamar Deluxe, anti bocor suara');
writeln(' 2. Kamar Biasa, suara menggelegar');
writeln;
writeln('*Note: Jika hari ini melewati jam 12:30 maka hanya boleh memesan');
writeln('       kamar pada besok hari! selain itu hubungi resepsionis');
garis('-');

{Input pengguna: }
UlangInputKamar:
write('Berapa kamar yang ingin dibeli? : ');readln(pemanduStr); // input pelanggan
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
write('Masukkan nama anda: ');readln(informasi_p.nama); // input 'Nama' pengguna
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
write('Masukkan NIK anda: ');readln(informasi_p.nik); // input 'NIK' pengguna
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
write('Masukkan umur anda: ');readln(informasi_p.umur); // input 'umur' pengguna
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
  cekKredit(informasi_p.nomor_kredit,valid); // (rekursif) jika valid, maka memeriksa jika kredit bernomor '0' 16 angka
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
  for b:=1 to kamar do // pengguna tidak lagi menginput data pribadi, sekarang input data pemesanan sampai jumlah kamar..
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
      cetakInvalid(0,2,0,ulang); // (0,2,0) menanyakan pengguna jika ingin mengulangi
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
      cekTanggal(hari1,bulan1,tahun1,valid); // (rekursif) jika valid.. maka prosedur 'cekTanggal' dipanggil
    if not valid then // jika invalid..
      begin 
      cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi input
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
      cekTanggal(hari2,bulan2,tahun2,valid); // (rekursif) mengecek secara detail kevalidan tanggal, menggantikan IOresult
    if not valid then // jika invalid..
      begin 
      cetakInvalid(0,0,4,ulang); // menanyakan pengguna jika ingin mengulang kembali
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
      cetakInvalid(0,0,4,ulang); // menanyakan pengguna jika ingin mengulang kembali 
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
    if (awalTanggalInLint = StrToDate(DateToStr(WaktuSekarang))) AND // jika tanggal awal = tanggal sekarang..
       (batasWaktuLint < StrToTime(TimeToStr(WaktuSekarang))) then // ..dan waktu sekarang sudah melewati batas waktu..
      begin
      Textcolor(red); // ubah warna teks selanjutnya menjadi merah
      write('Jam sudah melewati 12:30'); // maka invalid, dan harus memesan secara offline pada hotel
      Textcolor(white); // mengembalikan warna teks selanjutnya menjadi putih
      writeln(', waktu awal pesanan tidak boleh hari ini!');
      cetakInvalid(0,0,4,ulang); // menanyakan pengguna jika ingin mengulang kembali
      if ulang in ['y','Y'] then // jika ya.. maka menginput kembali tanggal awal pemesanan
        goto UlangInputTanggalSatu
      else if ulang in ['1'] then // jika 'dari awal'.. maka kembali ke menginput nama
        goto UlangInputNama
      else
        begin
        valid:= false; // selain itu.. invalid lalu menuju penutup
        goto Penutup;
        end;
      end;
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
        for a:=8 to 9 do // lewati sisa baris datanya
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
    kosongDe:= 5 - adaDe; 
    kosongBi:= 5 - adaBi; {inisialisasi}
    if (adaDe > 4) AND (adaBi > 4) then // jika kamar penuh pada tanggal tersebut.. maka invalid
      begin
      write('Dalam jadwal tersebut, ');
      Textcolor(red); // ubah warna teks
      write('seluruh kamar penuh!');
      Textcolor(white); // mengembalikan warna teks
      cetakInvalid(0,2,0,ulang); // menanyakan pengguna jika ingin mengulang kembali
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
        cetakInvalid(0,0,5,ulang); // menanyakan pengguna jika ingin mengulang kembali
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
        cetakInvalid(0,0,5,ulang); // menanyakan pengguna jika ingin mengulang kembali
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
    if informasi_d.kamar = 'Bi' then // jika jenis kamar adalah Biasa..
      biaya:= (HitungHari(hari2,bulan2,tahun2) - HitungHari(hari1,bulan1,tahun1)) * 300 // maka harga adalah 300jt/hari
    else if informasi_d.kamar = 'De' then // jika jenis kamar adalah Deluxe..
      biaya:= (HitungHari(hari2,bulan2,tahun2) - HitungHari(hari1,bulan1,tahun1)) * 500; // maka harga adalah 500jt/hari
    if biaya > 2000000000000000.0 then // jika harga terlalu banyak.. maka invalid
      begin
      write('Pesanan anda ');
      Textcolor(red); // ubah warna teks
      write('terlalu besar!');
      Textcolor(white); // mengembalikan warna teks
      writeln(' kami sarankan melakukan pembelian terpisah');
      cetakInvalid(0,0,5,ulang); // menanyakan pengguna jika ingin mengulang kembali
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

    write('Konfirmasi pembelian? (y/t) ');readln(pilihan); // meminta pelanggan mengkonfirmasi pembelian
    if not (pilihan in ['y','Y']) then // jika tidak ingin mengkonfirmasi..
      begin
      clrscr; // bersihkan layar
      goto UlangInputTanggalSatu; // menuju label UlangInputTanggalSatu
      end;
    Textcolor(yellow); // mengubah warna teks selanjutnya menjadi kuning
    for a:=5 downto 1 do // hitungan mundur dari 5 sampai 1
      begin
      write('Pembayaran selesai dalam ',a);
      delay(1250); // memberikan jeda pada pemenuhan perintah
      gotoxy(1,wherey); // kembali ke baris sebelumnya untuk menghapus dan menggantikan text pada baris itu
      end;
    Textcolor(green); // mengubah warna teks selanjutnya menjadi hijau
    writeln('Pembayaran telah ditransfer!    ');
    Textcolor(white); // mengembalikan warna text asli
        {cetak pada file: }
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
      end; // akhir cetak data
    if (pemanduB < kamar) AND (struk in ['y','Y']) then // jika masih tersisa kamar yang ingin dibeli dan sudah cetak struk..
      begin
      Textcolor(yellow); // ubah warna teks
      writeln('Tekan "ENTER"'); // maka menunggu tombol enter untuk melanjutkan mengisi data
      Textcolor(white); // mengembalikan warna teks
      readkey;
      end;
    end;
end;  // end procedure

 procedure CekKamar; // memeriksa ketersediaan kamar
var 
  adaBi,kosongBi,adaDe,kosongDe,kamarInt,posisiSalah,pemanduA,a: integer;
  ulang,simbol,pilihan: char; 
  kosong: array [1..10] of integer;
  awalTanggalIn,akhirTanggalIn,awalTanggal,akhirTanggal,kamar: string;
  awalTanggalLint,akhirTanggalLint,awalTanggalInLint,akhirTanggalInLint: TDateTime;
  hari1,bulan1,tahun1,hari2,bulan2,tahun2,BacaBaris: string;
  valid, ketemuData10: boolean;
  Sedia,Data: text;
label UlangInputTanggalSatu, UlangInputTanggalDua, SelesaiCetakTanggal, Penutup;
begin
valid:= true; ketemuData10:= false; pemanduA:= 0;
adaBi:=0; kosongBi:=0; adaDe:=0; KosongDe:=0; {inisialisasi}
CekKetersediaan(Sedia,kosongBi,adaBi,KosongDe,adaDe,kosong); // mengecek kamar kosong dan terisi
assign(Data,'Data.txt'); // menghubungkan variabel kepada file
clrscr;
garis('=');
writeln('CEK KETERSEDIAAN KAMAR');
garis('-');
writeln;
writeln('Kamar hari ini (Check-out jam 12:00):');
write(  'Kamar biasa yang tersedia : ',kosongBi);gotoxy(36,wherey); // gotoxy = memindahkan krusor ke kordinat..
writeln('Kamar Deluxe yang tersedia : ',kosongDe);                  //..wherey adalah kordinat vertikal krusor berada..
write(  'Kamar biasa yang terisi   : ',adaBi);gotoxy(36,wherey);    // dan x adalah kordinat horizontal
writeln('Kamar Deluxe yang terisi   : ',adaDe);
writeln;
garis('-');
write('Cek kamar pada tanggal tertentu? (y/t) : ');readln(pilihan); // input pilihan
if (not(pilihan in ['y','Y'])) then // jika tidak.. maka invalid dan langsung ke akhir program
  valid:= false;
if valid then // (rekursif) seluruh perintah lanjutan dilakukan jika valid
  begin
  adaBi:=0; kosongBi:=0; adaDe:=0; KosongDe:=0; {inisialisasi}
  UlangInputTanggalSatu:
  write('Masukkan tanggal pertama {Check-in jam 13:00} : ');readln(awalTanggalIn); // input tanggal awal
  {cek tanggal awal: }
  konversiTanggal(awalTanggalIn,hari1,bulan1,tahun1,valid); // mengkonversi tanggal dan mengecek tanggal
  if valid then
    cekTanggal(hari1,bulan1,tahun1,valid); // (rekursif) jika valid.. maka tanggal dicek lagi
  if not valid then
    begin 
    cetakInvalid(0,0,3,ulang); // jika invalid.. maka ditanyakan apakah ingin mengulangi input
    if ulang in ['y','Y'] then // jika ya.. maka kembali menginput tanggal awal
      goto UlangInputTanggalSatu
    else
      goto Penutup; // selain itu invalid dan menuju penutup
    end;

  UlangInputTanggalDua:
  write('Masukkan tanggal kedua {Check-out jam 12:00} : ');readln(akhirTanggalIn); // input tanggal akhir
    {cek tanggal akhir: }
  konversiTanggal(akhirTanggalIn,hari2,bulan2,tahun2,valid); // mengkonversi tanggal dan mengecek tanggal akhir
  if valid then
    cekTanggal(hari2,bulan2,tahun2,valid); // (rekursif) jika valid.. maka tanggal akhir dicek lagi
  if valid then
    cekTanggalAwalAkhir(hari1,bulan1,tahun1,hari2,bulan2,tahun2,valid, // (rekursif) jika valid, maka kedua tanggal dicek
        'Tidak boleh cek kamar di masa lalu!','Tanggal awal ke akhir tidak boleh mundur atau sama!',2);
  if not valid then
    begin 
    cetakInvalid(0,0,4,ulang); // jika invalid.. maka ditanyakan apakah ingin mengulangi input
    if ulang in ['y','Y'] then // jika ya.. maka kembali menginput tanggal akhir
      goto UlangInputTanggalDua
    else if ulang in ['1'] then // jika pilihan '1'.. maka kembali ke menginput tanggal awal
      goto UlangInputTanggalSatu
    else
      goto Penutup; // selain itu invalid dan menuju penutup
    end;
  awalTanggalIn:= hari1 +'/'+ bulan1 +'/'+ tahun1;
  akhirTanggalIn:= hari2 +'/'+ bulan2 +'/'+ tahun2; // memasukan keuda inputan tanggal ke variabel yang sebernarnya
  awalTanggalInLint:= StrToDate(awalTanggalIn,'dd/mm/yyyy','/');
  akhirTanggalInLint:= StrToDate(akhirTanggalIn,'dd/mm/yyyy','/'); // menkonversi kedua tanggal ke 'date angka'
  reset(Data); // membuka data untuk dibaca
  while not eof(Data) do // selama file belum berakhir..
    begin
    readln(Data, simbol); // mencari simbol '$'
    if simbol in ['$'] then // jika simbol ditemukan.. artinya ada data untuk dibaca
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
          begin
          ketemuData10:= false; 
          pemanduA:= pemanduA + 1;//jumlah data.. //+jika tanggal awal data < atau = input tanggal awal DAN tanggal akhir data > input tanggal awal..
          if pemanduA = 1 then //yang memenuhi    //+atau jika tanggal awal data < input tanggal akhir DAN tanggal akhir data > atau = input tanggal akhir..
            begin                                 //+atau jika tanggal awal data > atau = input tanggal awal DAN tanggal akhir data < atau = input tanggal akhir..
            write('DAFTAR PESANAN TANGGAL ('); //+maka dihitung
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
  close(Data);
  kosongDe:= 5 - adaDe; //--menghitung jumlah kamar kosong
  if adaBi > 4 then // jika kamar Biasa penuh..
    kosongBi:= 0 // kosong Biasa = 0
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
Penutup:
end; // end procedure

procedure CetakStruk; // mencetak struk atau mencari riwayat pembelian
var 
  simbol,nama,nik,kredit,pemanduStr: string;
  ulang: char;
  a,b,pencacahA,pilihan,pilihan2,pilihan3,pemanduA,pemanduB,pemanduD,posisiSalah: integer;
  pemanduC: array [1..60] of integer;//pemanduC=lokasiData
  BacaBaris: array [1..3000] of string;
  valid: boolean;
  awalTanggalIn,akhirTanggalIn,awalTanggal,akhirTanggal: string;//tanggal
  hari1,bulan1,tahun1,hari2,bulan2,tahun2: string;
  FileDataRiwayat: text;
label UlangInputPilihan, UlangInputPilihan2, UlangInputPilihan3,
      UlangInputNama, UlangInputNama2, UlangInputNik, UlangInputKredit,
      UlangInputTanggalSatu, UlangInputTanggalDua, Penutup;
//pemanduA=penghitungData/nomorData,pemanduB=pemanduLokasi,pemanduD=readlnCetakData;
//pemanduE=pencegahError
//pencacahA=pemanduBacaBaris
begin
clrscr;
pencacahA:=0; pemanduA:=0; pemanduB:=0; pemanduD:=0; valid:=true;
nama:= ''; kredit:= ''; nik:= ''; {inisialisasi}
garis('='); // mencetak garis
writeln('RIWAYAT PEMBELIAN');
writeln;
writeln('(*Note: Jika melupakan tanggal penggunaan, hubungi resepsionis!*)');
garis('-');
UlangInputPilihan:
write('Lihat keseluruhan data/Cetak struk (1/2) : ');readln(pemanduStr); // input pilihanpengguna
val(pemanduStr,pilihan,posisiSalah); // mencoba mengkonversi ke integer 'Pilihan'
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
if not (pilihan3 in [1,2]) then // jika input tidak sesuai pilihan..
  begin
  cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan ketiga
    goto UlangInputPilihan3
  else
    goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
  end;

if pilihan3 = 1 then // jika pilihan ketiga adalah input dengan nama dan NIK..
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
if pilihan3 = 2 then // jika pilihan ketiga adalah input dengan nomor kredit..
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
  if valid then // (rekursif) jika valid..
    cekKredit(kredit,valid); // cek nomor kredit jika adalah angka 0 enam belas digit
  if not valid then // jika invalid..
    begin
    cetakInvalid(0,0,4,ulang); // menanyakan apakah pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali menginput nomor kredit
      goto UlangInputKredit
    else if ulang in ['1'] then // jika pilihan adalah '1'.. kembali ke menginput nama
      goto UlangInputNama2
    else
      goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
    end;
  end;

UlangInputTanggalSatu:
write('Masukkan tanggal pertama (dd/mm/yyyy) : ');readln(awalTanggalIn); // input tanggal awal pengguna
  {cek tanggal awal: }
konversiTanggal(awalTanggalIn,hari1,bulan1,tahun1,valid); // konversi serta cek tanggal bila 8 angka
if valid then // (rekursif) jika valid..
  cekTanggal(hari1,bulan1,tahun1,valid); // cek tanggal awal secara mendetail
if not valid then // jika invalid..
  begin 
  cetakInvalid(0,0,3,ulang); // menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput tanggal awal
    goto UlangInputTanggalSatu
  else
    goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
  end;
UlangInputTanggalDua:
write('Masukkan tanggal kedua (dd/mm/yyyy) : ');readln(akhirTanggalIn); // input tanggal kedua pengguna
  {cek tanggal akhir: }
konversiTanggal(akhirTanggalIn,hari2,bulan2,tahun2,valid); // konversi serta cek tanggal bila 8 angka
if valid then // (rekursif) jika valid..
  cekTanggal(hari1,bulan1,tahun1,valid); // cek tanggal akhir secara mendetail
if valid then // (rekursif) jika valid..
  cekTanggalAwalAkhir(hari1,bulan1,tahun1,hari2,bulan2,tahun2,valid,
      'ya','Tanggal awal ke akhir tidak boleh mundur atau sama!',1); // cek kedua tanggal
if not valid then // jika invalid..
  begin 
  cetakInvalid(0,0,4,ulang); // menanyakan apakah pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali menginput tanggal akhir
    goto UlangInputTanggalDua
  else if ulang in ['1'] then // jika pilihan adalah '1'.. kembali ke menginput tanggal awal
    goto UlangInputTanggalSatu
  else
    goto Penutup; // selain itu.. dianggap tidak ingin dan menuju penutup
  end;
writeln; // memberi jarak

{mempersiapkan sistem: }
awalTanggalIn:= hari1 +'/'+ bulan1 +'/'+ tahun1;
akhirTanggalIn:= hari2 +'/'+ bulan2 +'/'+ tahun2; // menampung kedua tanggal ke variabel

case pilihan2 of // assign file sesuai pilihan kedua
  1: assign(FileDataRiwayat,'RiwayatData.txt'); // mencari di riwayat
  2: assign(FileDataRiwayat,'Data.txt'); // mencari pembelian mendatang di data.txt
  end;
reset(FileDataRiwayat); // membuka file untuk dibaca

while not eof(FileDataRiwayat) do // selama  belum mencapai baris akhir file..
  begin
  readln(FileDataRiwayat, simbol); // baca apakah ada simbol '$'
  if pos('$',simbol) > 0 then // bila ditemukan..
    begin
    pencacahA:= pencacahA + 9; // pemandu array bacabaris
    pemanduA:= pemanduA + 1; // pemandu nomor keberapa data yang dibaca (untuk disalin oleh pemanduC)
    for a:=(pencacahA - 8) to pencacahA do // dari baris pertama sampai ke-sembilan..
      readln(FileDataRiwayat,BacaBaris[a]); // baca baris file dan salin
    awalTanggal:= copy(BacaBaris[pencacahA - 2],37,10); // salin data awal tanggal
    akhirTanggal:= copy(BacaBaris[pencacahA - 2],55,10); // salin data akhir tanggal
    if (pos(' '+nama+'|',BacaBaris[pencacahA - 7]) > 0) and (((pilihan3 = 1) and (pos(nik,BacaBaris[pencacahA - 7]) > 0)) or
        ((pilihan3 = 2) and (pos(kredit,BacaBaris[pencacahA - 6]) > 0))) AND // bila nama dan nik atau nama dan kredit ditemukan..
        ((awalTanggalIn = awalTanggal) and (akhirTanggalIn = akhirTanggal)) then // ..dan tanggal input sama dengan tanggal data..
        begin
        pemanduB:= pemanduB + 1; // jumlah data yang ditemukan dan pemandu array 'pemanduC'
        pemanduC[pemanduB]:= pemanduA; // menyalin lokasi atau nomor data dan menyimpannya
        end;
    end;
  end;//endwhile
if (eof(FileDataRiwayat)) AND (pemanduB = 0) then // (rekursif) apabila file berakhir dan apabila data tidak ditemukan..
  begin
  Textcolor(red);
  if pilihan3 = 1 then // apabila pilihan 3 adalah 1..
    writeln('Nama/NIK tidak sesuai atau data tidak ada!')
  else // selain itu..
    writeln('Nomor kredit tidak sesuai atau data tidak ada!');
  Textcolor(white);
  end;
close(FileDataRiwayat); // menutup file riwayat

if pemanduB > 0 then // (rekursif) bila ada data yang ditemukan dan sesuai input identifikasi..
  for a:=1 to pemanduB do // Tulis semua data yang sesuai
    begin
    pencacahA:=pemanduC[a] * 9; // menuju lokasi data yang disimpan di array
    for b:=1 to 101 do // baris pertama, mencetak garis '='
      write('=');
    writeln; // baris baru
    if pilihan = 2 then // jika pilihan pertama adalah mencetak struk..
      begin
      writeln('Hotel Aman Sentosa Kota Palangkaraya, Keminting, Jl. Kecubung'); // baris kedua nama dan alamat Hotel
      for b:=1 to 101 do // baris ketiga adalah garis '='
        write('=');
      writeln;
      write('| Nama Pembeli: ',nama); // baris keempat adalah nama pembeli
      gotoxy(101,wherey);writeln('|');
      for b:=(pencacahA - 5) to pencacahA do // baris kelima sampai kesepuluh..
        writeln(BacaBaris[b]); // mencetak data
      end;
    if pilihan = 1 then // jika pilihan pertama adalah mencari riwayat..
      begin
      for b:=(pencacahA - 7) to pencacahA do // maka data dicetak sesuai format pada file
        writeln(BacaBaris[b]);
      end;
    pemanduD:= pemanduD + 1; // penghitung data yang telah dicetak
    if (pemanduD mod 2 = 0) then // bila data yang telah dicetak adalah kelipatan 2..
      readln // maka menunggu perintah ENTER dari pengguna
    else // selain itu..
      writeln; // beri jarak
    end;//endforcetakdata
Penutup:
end; // end procedure

procedure FasilitasAtauInformasi; // mencetak informasi mengenai hotel sesuai pilihan
var 
  pemanduStr: string;
  pilihan,posisiSalah: integer;
  ulang: char;
label UlangAwal, UlangInputPilihan, Penutup;
begin
UlangAwal: // label jika pengguna ingin mengulang
clrscr;
  garis('=');
writeln(' HOTEL AMAN SENTOSA');
writeln(' Kota Palangkaraya, Keminting, JL. Kecubung');
  garis('-');
writeln('PILIH FASILITAS YANG INGIN DILIHAT');
writeln('  1. Informasi Hotel');
writeln('  2. Fasilitas Kamar');
writeln('  3. Fasilitas Hotel');
writeln('  4. Fasilitas Umum Terdekat');
writeln('  5. Informasi Kamar Deluxe');
writeln('  6. Informasi Kamar Biasa');
writeln('  7. Disediakan Sesuai Request');
  garis('-');
UlangInputPilihan:
write('Masukkan nomor pilihan Anda : ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,pilihan,posisiSalah); // mencoba untuk konversi ke integer 'pilihan'
if posisiSalah > 0 then // jika ada kesalahan dalam konversi..
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
    goto UlangInputPilihan
  else
    goto Penutup; // selain itu.. menuju penutup
  end;
if not (pilihan in [1..7]) then
    begin
    cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
      goto UlangInputPilihan
    else
      goto Penutup;
    end;
clrscr;
case pilihan of // pencetakan informasi berdasarkan pilihan
1: begin // informasi umum hotel
    garis('=');
    writeln('INFORMASI HOTEL');
    garis('-');
    writeln('  Nama     : Hotel Aman Sentosa ');
    writeln('  Alamat   : Keminting, Jl. Kecubung');
    writeln('  Kota     : Palangka Raya');
    writeln('  Email    : hotelamansentosa@gmail.com');
    writeln('  No.Telp  : +6282332988876');
    writeln('  Kualitas : *********** (Bintang 11)');
    end;
2: begin // fasilitas yang disediakan pada kamar
    garis('=');
    writeln('FASILITAS UMUM KAMAR');
    garis('-');
    writeln('  1. Tempat tidur berkualitas tinggi, linen premium,');
    writeln('  2. Snack gratis pada kulkas kamar');
    writeln('  3. Kamar mandi marmer');
    writeln('  4. TV layar datar');
    writeln('  5. Sound system');
    writeln('  6. Keperluan mandi');
    writeln('  7. Wifi');
    end;
3: begin // fasilitas layanan pada hotel
    garis('=');
    writeln('FASILITAS LAYANAN HOTEL');
    garis('-');
    writeln('  1. Restoran serba bisa dan bar ');
    writeln('  2. Layanan spa dan kesehatan');
    writeln('  3. Kolam renang');
    writeln('  4. Layanan kamar 24 jam');
    writeln('  5. Layanan resepsionis 24 jam');
    writeln('  6. Layanan keamanan 24 jam');
    writeln('  7. Ruang pertemuan dan fasilitas bisnis');
    writeln('  8. Layanan concierge');
    writeln('  9. Keamanan tingkat tinggi');
    writeln(' 10. Area parkir seluas 4km kuadrat');
    writeln(' 11. Fasilitas olahraga');
    writeln(' 12. Fasilitas hiburan');
    writeln(' 13. Fasilitas keperluan');
    writeln(' 14. Pentitipan anak');
    end;
4: begin // fasilitas publik terdekat
    garis('=');
    writeln('FASILITAS UMUM TERDEKAT');
    garis('-');
    writeln('  1. Kantor polisi');
    writeln('  2. Rumah sakit');
    writeln('  3. Bandara');
    writeln('  4. ATM');
    writeln('  5. Mall');
    writeln('  6. Taman negara');
    writeln('  7. Gedung pencakar langit');
    writeln('  8. Pusat perdagangan dunia');
    writeln('  9. Industri militer negara');
    writeln(' 10. Kantor presiden');
    writeln(' 11. Puskesmas');
    writeln(' 12. Pantai');
    writeln(' 13. Sawah');
    end;
5: begin // informasi kamar Deluxe
    garis('=');
    writeln('KAMAR DELUXE');
    garis('-');
    writeln('  Fasilitas yang diberikan:');
    writeln('    1. Luas kamar Deluxe 52m kuadrat');
    writeln('    2. Super King Size Bed');
    writeln('    3. Pelayanan ekslusif');
    writeln('    4. Penyaring udara segar (Boleh merokok)');
    writeln('    5. Kamar bisa menjadi mode kedap suara/suara ektra');
    writeln('    6. Memiliki balkon dengan pemandangan KOTA');
    writeln('    7. Bodyguard pribadi');
    writeln('    8. Fasilitas brankas pribadi');
    writeln('    9. Layanan pesawat pribadi + bandara');
    writeln('   10. Kamar mandi super lengkap dengan bathhub, shower dengan water heater, dan sauna');
    end;
6: begin // informasi kamar Biasa
    garis('=');
    writeln('KAMAR BIASA');
    garis('-');
    writeln('  Fasilitas yang diberikan:');
    writeln('    1. Luas kamar Biasa 25m kuadrat');
    writeln('    2. Singe Bed');
    writeln('    3. Makanan berbayar');
    writeln('    4. Kamar mandi tradisional');
    writeln('    5. No AC');
    writeln('    6. Tidak boleh merokok di kamar');
    writeln('    7. Tidak memiliki balkon');
    end;
7: begin // fasilitas yang disediakan sesuai request
    garis('=');
    writeln('AKAN DISEDIAKAN SESUAI REQUEST');
    garis('-');
    writeln('  1. Pengantaran makanan');
    writeln('  2. Kursi Roda');
    writeln('  3. Perabotan tambahan');
    writeln('  4. Pembersihan kamar');
    writeln('  5. Laundry');
    end;
  end;//endcaseof
writeln;
cetakInvalid(0,0,1,ulang); // menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. maka kembali ke UlangAwal
    goto UlangAwal;
writeln;
writeln('JIKA INGIN MENGETAHUI LEBIH DETAIL, TANYAKAN PADA RESEPSIONIS!');
Penutup: // penutup
end;

procedure ketentuan; // mencetak ketentuan dan kebijakan hotel
begin
clrscr; // membersihkan layar
garis('='); // mencetak garis '='
writeln('KETENTUAN DAN KEBIJAKAN');
garis('-'); // mencetak garis '-'
  writeln('   1. Check-in mulai dari jam (13.00 siang) sampai (12.00 siang)(23 jam)');
  writeln('   2. Batas check-out jam (12.00 siang)');
  writeln('   3. Check-in dan check-out disesuaikan jam pesanan');
  writeln('   4. Jika check-out melebihi jam (12.00 siang) maka diwajibkan membayar 1 hari lagi');
  writeln('   5. Jika check-in terlambat harus melakukan konfirmasi');
  writeln('   6. Kerusakan pada kamar hotel yang dilakukan oleh pelanggan akan dikenakan denda');
  writeln('   7. Ketidaksanggupan/kegagalan membayar denda akan dikenakan black-list seluruh hotel di indonesia');
  writeln('   8. Pemesanan online harus bayar menggunakan kredit, tidak boleh menunggu saat check-in');
end; // end procedure

procedure FAQ; // memperlihatkan pertanyaan yang sering dipertanyakan
type
  Pertanyaan = record
    judul: string[100];
    jawaban: string[255];
  end;
var
  pemanduStr: string;
  ulang: char;
  daftarPertanyaan: array[1..11] of Pertanyaan;
  a,pilihan,posisiSalah: integer;
label UlangInputPilihan, Penutup;
begin
  daftarPertanyaan[1].judul := 'Apakah hotel menyediakan Wi-Fi gratis?'; {--inisialisasi array}
  daftarPertanyaan[1].jawaban := 'Ya, hotel kami menyediakan Wi-Fi gratis di semua area.';
  
  daftarPertanyaan[2].judul := 'Apakah ada fasilitas parkir di hotel?';
  daftarPertanyaan[2].jawaban := 'Ya, kami menyediakan fasilitas parkir gratis untuk tamu hotel.';
  
  daftarPertanyaan[3].judul := 'Apakah hotel menyediakan sarapan gratis?';
  daftarPertanyaan[3].jawaban := 'Ya, sarapan gratis disediakan setiap pagi dari pukul 06:00 hingga 10:00.';
  
  daftarPertanyaan[4].judul := 'Bagaimana kebijakan pembatalan reservasi?';
  daftarPertanyaan[4].jawaban := 'Pembatalan gratis hingga 24 jam sebelum tanggal check-in.';
  
  daftarPertanyaan[5].judul := 'Apakah ada layanan antar-jemput bandara?';
  daftarPertanyaan[5].jawaban := 'Ya, kami menyediakan layanan antar-jemput bandara dengan biaya tambahan.';
  
  daftarPertanyaan[6].judul := 'Apakah hewan peliharaan diperbolehkan?';
  daftarPertanyaan[6].jawaban := 'Maaf, hewan peliharaan tidak diperbolehkan di hotel kami.';
  
  daftarPertanyaan[7].judul := 'Apakah hotel menyediakan layanan kamar 24 jam?';
  daftarPertanyaan[7].jawaban := 'Ya, layanan kamar tersedia 24 jam untuk kenyamanan tamu.';

  daftarPertanyaan[8].judul := 'Apakah hotel memiliki kolam renang?';
  daftarPertanyaan[8].jawaban := 'Ya, kami memiliki kolam renang outdoor yang dapat digunakan tamu.';
  
  daftarPertanyaan[9].judul := 'Apakah hotel menyediakan layanan laundry?';
  daftarPertanyaan[9].jawaban := 'Ya, layanan laundry tersedia dengan biaya tambahan.';
  
  daftarPertanyaan[10].judul := 'Apa waktu check-in dan check-out?';
  daftarPertanyaan[10].jawaban := 'Waktu check-in dan check-out buka selama 24 jam.';

  daftarPertanyaan[11].judul := 'Apa bolah membawa makanan dari luar?';
  daftarPertanyaan[11].jawaban := 'Tentu saja boleh, selagi tidak mengotori lingkungan hotel'; {--}

  repeat
    clrscr; // membersihkan layar
    garis('=');
    writeln('Daftar Pertanyaan:'); 
    garis('=');
    for a := 1 to 11 do // mencetak seluruh daftar pertanyaan ke layar
      writeln(a, '. ', daftarPertanyaan[a].judul);
    garis('=');
    UlangInputPilihan:
    write('Pilih nomor pertanyaan/Keluar (1..11/0) : ');readln(pemanduStr); // input pilihan pengguna
    val(pemanduStr,pilihan,posisiSalah); // mencoba untuk konversi ke integer 'pilihan'
    if posisiSalah > 0 then // jika ada kesalahan dalam konversi..
      begin
      cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
        goto UlangInputPilihan
      else
        goto Penutup; // selain itu.. menuju penutup
      end;
    if (pilihan < 0) OR (pilihan > 11) then 
      begin
      cetakInvalid(1,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. maka kembali menginput pilihan
        goto UlangInputPilihan
      else
        goto Penutup; // selain itu.. menuju penutup
      end;

    clrscr;
    if pilihan = 0 then
      begin
      writeln('Terima kasih');
      goto Penutup; // jika pilihan adalah '0' atau keluar.. menuju penutup
      end;
    writeln(pilihan,'. ',daftarPertanyaan[pilihan].judul); 
    writeln(daftarPertanyaan[pilihan].jawaban); // mencetak pertanyaan dan jawabannya ke layar
    writeln;
    Textcolor(yellow); // mengubah
    write('tekan "ENTER" {"N" untuk keluar}'); 
    Textcolor(white);
    readkey; // menunggu perintah untuk mengulangi atau keluar
  until (UpCase(ReadKey) = 'N'); // jika readkey = N maka keluar
Penutup:
end; // end procedure

procedure Ulasan; // melihat atau menginput ulasan
var
  pilihan,starInt,ulasInt: integer;
  simbol,ulang: char;
  nama,nik,kredit,star,ulasData,pemanduStr: string;
  BacaUlas: ansistring;
  BacaBaris: array [1..4] of string;
  BacaSedia: array [1..800] of string;
  valid, ketemuUlas4, barisBaru, ulasEof: boolean;
  a,b,pencacahA,pemanduA,pemanduB,pemanduC,pemanduD,pemanduE,posisiSalah: integer;
  Ulas,Riwayat,RiwayatUlas: text;
label Awal,UlangInputPilihan,InputUlasanLagi,UlangInputNama,
      UlangInputNik,UlangInputKredit,UlangInputUlasan,UlangInputStar,Penutup;
begin
pencacahA:=1; pemanduA:=1; pemanduB:=0; pemanduC:=0; pemanduD:=0; pemanduE:=0; ulasInt:=0;
valid:=true; ketemuUlas4:= false; barisBaru:= false; ulasEof:= false; {inisialisasi}
assign(Ulas,'Ulasan.txt');
assign(Riwayat,'RiwayatData.txt');
assign(RiwayatUlas,'RiwayatUlasan.txt'); // menghubungkan variabel kepada file

clrscr;
reset(Ulas); // membuka file untuk dibaca
for a:=1 to 5 do // membaca lalu mencetak judul dari prosedur 'Ulasan'
  begin
  readln(Ulas, BacaUlas);
  writeln(BacaUlas);
  end;
Awal: // label awal
while not eof(Ulas) do // selama file belum berakhir..
  begin
  barisBaru:= false; // mencegah writeln tidak berjalan
  readln(Ulas, BacaUlas); // mencari kata kunci 'Pengguna'
  if pos('Pengguna',BacaUlas) > 0 then // jika ditemukan..
    begin
    writeln(BacaUlas); // menulis baris dengan kata kunci
    for b:=1 to 6 do // membaca dan menulis baris sesuai batas maksimal baris data
      begin
      readln(Ulas, BacaUlas); // membaca data
      writeln(BacaUlas); // mencetak data
      if pos('Bintang  :',BacaUlas) > 0 then // jika kata kunci 'Bintang :' ditemukan..
        break; // hentikan mencetak
      end; 
    pemanduE:= pemanduE + 1; // pemandu jumlah ulasan yang ditampilkan
    ketemuUlas4:=false; // mencegah data tidak dicetak dan skip ke input pilihan
    barisBaru:= true; // mencegah writeln tidak berjalan
    end;
  if (pemanduE mod 4 > 0) AND barisBaru then // jika data yang dicetak belum mencapai kelipatan 4.. 
    writeln // beri jarak
  else if (not ketemuUlas4) AND (pemanduE mod 4 = 0) AND (pemanduE > 0) then // jika data yang dicetak mencapai 4..
    begin 
    ketemuUlas4:= true; // mencegah agar tidak ada kesalahan proses
    break; // hentikan mencetak data
    end;
  end;
if seekEof(Ulas) then // jika end of file atau tidak ada data lain selain baris baru..
    begin
    ulasEof:= true; // pemandu eof
    close(Ulas); // menutup file ulasan.txt
    Textcolor(red); // ubah warna text
    writeln('Ulasan habis!');
    Textcolor(white);
    end;
garis('-');

UlangInputPilihan:
write('Selanjutnya / Input Ulasan / Keluar (1/2/3) ');readln(pemanduStr); // input pilihan pengguna
val(pemanduStr,pilihan,posisiSalah); // mencoba mengkonversi ke integer pilihan
if posisiSalah > 0 then
  begin
  cetakInvalid(2,1,0,ulang); // mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
  if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
    goto UlangInputPilihan
  else // selain itu..
    begin
    if not ulasEof then // jika file belum eof (belum ditutup)..
      close(Ulas); // maka tutup file
    goto Penutup; // menuju penutup
    end;
  end;
case pilihan of
1: 
  begin
  if ulasEof then // jika file berakhir..
    begin
    Textcolor(red);
    writeln('Semua ulasan telah ditampilkan!'); // maka invalid..
    Textcolor(white);
    goto UlangInputPilihan; // dan menuju input pilihan
    end
  else if not ulasEof then // jika file belum berakhir..
    begin
    garis('-'); // beri pembatas yaitu garis
    goto Awal; // menuju 'Awal'
    end;
  end;
2:
  begin
  if not ulasEof then // jika file belum berakhir
    close(Ulas); // tutup file
  pemanduA:=0; {inisialisasi}
  UlangInputNama:
  write('Masukkan nama (identifikasi) : ');readln(nama); // input nik pengguna
  cekNama(nama,valid); // validasi dan transformasi nama
  if not valid then // jika invalid..
    begin 
    cetakInvalid(0,0,3,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali ke menginput nama
      goto UlangInputNama
    else
      goto Penutup; // selain itu.. langsung menuju penutup
    end;
  UlangInputNik:
  write('Masukkan NIK (identifikasi) : ');readln(nik); // input nik pengguna
  cekInteger('NIK',nik,16,valid); // validasi NIK
  if not valid then // jika invalid..
    begin
    cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali ke menginput NIK
      goto UlangInputNik
    else if ulang in ['1'] then // jika pilihan 'dari awal'.. kembali ke menginput nama
      goto UlangInputNama
    else
      goto Penutup; // selain itu.. langsung menuju penutup
    end;
  UlangInputKredit:
  write('Masukkan nomor kredit (identifikasi) : ');readln(kredit); // input kredit pengguna
  cekInteger('Kredit',kredit,16,valid); // validasi kredit
  if not valid then // jika invalid..
    begin 
    cetakInvalid(0,0,4,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali ke menginput nomor kredit
      goto UlangInputKredit
    else if ulang in ['1'] then // jika pilihan 'dari awal'.. kembali ke menginput nama
      goto UlangInputNama
    else
      goto Penutup; // selain itu.. langsung menuju penutup
    end;
  reset(Riwayat); // membuka 'RiwayatData.txt' untuk dibaca
  while not eof(Riwayat) do // selama file belum berakhir..
    begin
    readln(Riwayat, simbol); // membaca simbol yang menandakan adanya data untuk dibaca..
    if simbol in ['$'] then // jika ditemukan..
      begin
      readln(Riwayat); // skip baris pertama data
      for a:=1 to 2 do
        readln(Riwayat,BacaBaris[a]); // salin baris kedua dan ketiga data
      for a:=4 to 9 do // skip sisa barisnya
        readln(Riwayat);
      if (pos(' '+nama+'|',BacaBaris[1]) > 0) AND // jika nama, NIK, dan kredit ditemukan..
          (pos(nik,BacaBaris[1]) > 0) AND (pos(kredit,BacaBaris[2]) > 0) then
        pemanduA:= pemanduA + 1; // jumlah data yang ditemukan bertambah 1
      end;
    end;//endwhile
  if (eof(Riwayat)) AND (pemanduA = 0) then // jika file berakhir tetapi data tidak ditemukan..
    begin
    close(Riwayat); // tutup file
    Textcolor(red);
    writeln('Nama/NIK tidak sesuai atau data tidak ada!');
    Textcolor(white);
    goto Penutup; // menuju penutup
    end;
  close(Riwayat); // tutup file jika data ditemukan
  pencacahA:= 4; {inisialisasi baru}
  reset(RiwayatUlas); // membuka file untuk dibaca
  while not eof(RiwayatUlas) do // selama file belum berakhir..
    begin
    readln(RiwayatUlas, simbol); // membaca simbol yang menandakan adanya data untuk dibaca..
    if simbol in ['$'] then // jika ditemukan..
      begin
      pemanduC:= pemanduC + 1; // pemandu nomor data ulasan
      for a:=(pencacahA - 3) to pencacahA do // cetak semua baris dari data tersebut
        readln(RiwayatUlas,BacaSedia[a]); 
      if (pos(nik,BacaSedia[pencacahA - 2]) > 0) AND (pos(kredit,BacaSedia[pencacahA - 1]) > 0) then
        begin // jika NIK dan kredit ditemukan..
        ulasData:= copy(BacaSedia[pencacahA],10); // salin jumlah inputan ulasan
        val(ulasData,ulasInt); // konversi data ke integer
        pemanduA:= pemanduA - ulasInt; // jumlah data yang ditemukan dikurang ulasan yang telah diinput
        pemanduD:= pemanduC; // mencetak lokasi nomor data
        end;
      pencacahA:= pencacahA + 4; // memajukan pemandu BacaSedia
      end;
    end;
  close(RiwayatUlas); // menutup file
  InputUlasanLagi:
  if pemanduA = 0 then // jika jumlah input ulasan yang tersisa adalah 0..
    begin
    Textcolor(red);
    writeln('Sisa input ulasan anda habis!'); // maka invalid
    Textcolor(white);
    end;
  if pemanduA > 0 then // jika ada sisa ulasan
    begin
    pemanduB:= 0; {inisialisasi baru}
    writeln;
    writeln('Sisa input ulasan anda (',pemanduA,')'); // cetak sisa ulasan
    UlangInputUlasan:
    write('Ulasan anda (Keluar=1): ');readln(BacaUlas); // input ulasan atau pilihan keluar
    if length(BacaUlas) > 455 then // jika ulasan terlalu panjang..
      begin
      Textcolor(red);
      write('Ulasan maksimal 455 karakter!'); // maka invalid
      Textcolor(white);
      cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali ke menginput ulasan
        goto UlangInputUlasan
      else
        goto Penutup; // selain itu.. langsung menuju penutup
      end;
    if pos(':',BacaUlas) > 0 then // jika ditemukan ':' (menganggu pencarian kata kunci)
      begin
      Textcolor(red);
      write('Ulasan tidak boleh memakai tanda ":",'); // maka invalid
      Textcolor(white);
      cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. kembali ke menginput ulasan
        goto UlangInputUlasan
      else
        goto Penutup; // selain itu.. langsung menuju penutup
      end;
    val(BacaUlas,pemanduB,posisiSalah); // mencoba konversi ke integer untuk pilihan keluar
    if pemanduB = 1 then
      goto penutup; // jika pilihan adalah keluar.. menuju penutup
    UlangInputStar:
    write('Berapa bintang anda beri : ');readln(star); // input jumlah bintang yang diberi
    val(star,starInt,posisiSalah); // mencoba konversi bintang ke integer
    if (posisiSalah > 0) OR ((starInt > 5) or (starInt < 1)) then
      begin // jika gagal konversi, atau jumlah bintang kurang dari satu atau lebih dari lima..
      if posisiSalah > 0 then // jika adalah gagal konversi.. maka cetak pesan ini..
        begin
        Textcolor(red);
        write('Bintang harus angka!');
        Textcolor(white);
        cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
        end
      else if (starInt > 5) OR (starInt < 1) then // jika adalah kesalahan input angka.. maka cetak pesan ini..
        begin
        Textcolor(red);
        write('Bintang minimal 1 dan maksimal 5!');
        Textcolor(white);
        cetakInvalid(0,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
        end;
      if ulang in ['y','Y'] then // jika ya.. kembali ke menginput jumlah bintang
        goto UlangInputStar
      else
        goto Penutup; // selain itu.. langsung menuju penutup
      end;
    pemanduB:= 0; {inisialisasi baru}
    if length(BacaUlas) > 91 then // jika panjang ulasan lebih dari 91 karakter..
      begin
      BacaBaris[1]:= copy(BacaUlas,92,91); // salin 91 karakter selanjutnya dari komentar
      pemanduB:= pemanduB + 1; // pemandu BacaBaris atau sambungan ulasan
      end;
    if length(BacaUlas) > 181 then // jika panjang ulasan lebih dari 181 karakter..
      begin
      BacaBaris[2]:= copy(BacaUlas,182,91); // salin 91 karakter selanjutnya dari komentar
      pemanduB:= pemanduB + 1;
      end;
    if length(BacaUlas) > 272 then // jika panjang ulasan lebih dari 272 karakter..
      begin
      BacaBaris[3]:= copy(BacaUlas,273,91); // salin 91 karakter selanjutnya dari komentar
      pemanduB:= pemanduB + 1;
      end;
    if length(BacaUlas) > 363 then // jika panjang ulasan lebih dari 363 karakter..
      begin
      BacaBaris[4]:= copy(BacaUlas,364,91); // salin 91 karakter selanjutnya dari komentar
      pemanduB:= pemanduB + 1;
      end;
    delete(BacaUlas,92,400); // menghapus karakter lain selain 91 karakter pertama ulasan
    append(Ulas); // membuka file untuk ditulis tanpa menghapus seluruh data
    writeln(Ulas,'Pengguna : ',nama); // cetak nama, ulasan, serta bintang yang diberi pada file
    writeln(Ulas,'Ulasan   : ',BacaUlas);
    if pemanduB > 0 then
      for a:=1 to pemanduB do
        writeln(Ulas,'           ',BacaBaris[a]);
    write(Ulas,  'Bintang  : '); 
    for a:=1 to starInt do // cetak bintang
      write(Ulas,'*');
    writeln(Ulas);
    writeln(Ulas); // beri jarak pada ulasan
    flush(Ulas); // menyalurkan langsung buffer pada program ke file
    close(Ulas); // tutup file
    if ulasInt = 0 then // jika belum pernah memberi ulasan sebelumnya..
      begin
      ulasInt:= 1; // jumlah ulasan yang diberi sekarang
      append(RiwayatUlas); // membuka file untuk ditulis tanpa menghapus seluruh data
      writeln(RiwayatUlas,'$');
      writeln(RiwayatUlas,'Nama   : ',nama); // cetak data pada file
      writeln(RiwayatUlas,'NIK    : ',nik);
      writeln(RiwayatUlas,'Kredit : ',kredit);
      writeln(RiwayatUlas,'Ulasan : ',ulasInt);
      writeln(RiwayatUlas); // beri jarak
      pemanduD:= pemanduC + 1; // menampung lokasi nomor data
      close(RiwayatUlas);
      end
    else if ulasInt > 0 then // jika sudah pernah menginput ulasan..
      begin
      ulasInt:= ulasInt + 1; // input ulasan bertambah 1
      pencacahA:= 0; {inisialisasi baru}
      rewrite(RiwayatUlas); // membuka file untuk ditulis dan menghapus keseluruhan data
      for a:=1 to (pemanduD - 1) do // tulis data ulasan sebelum lokasi nomor data yang disimpan
        begin
        pencacahA:= pencacahA + 4; // pemandu BacaSedia
        writeln(RiwayatUlas,'$'); // cetak simbol penanda
        for b:=(pencacahA - 3) to pencacahA do // cetak data
          writeln(RiwayatUlas,BacaSedia[b]);
        writeln(RiwayatUlas); // beri jarak
        flush(RiwayatUlas); // cetak ke dalam file (karena data dicetak saat perintah close, jadi ini dilakukan)
        end;
      writeln(RiwayatUlas,'$'); // cetak simbol penanda
      writeln(RiwayatUlas,'Nama   : ',nama); // cetak data
      writeln(RiwayatUlas,'NIK    : ',nik);
      writeln(RiwayatUlas,'Kredit : ',kredit);
      writeln(RiwayatUlas,'Ulasan : ',ulasInt); // jumlah input ulasan yang diperbarui
      writeln(RiwayatUlas); // beri jarak
      flush(RiwayatUlas);
      pencacahA:= pencacahA + 4;
      for a:=(pemanduD + 1) to pemanduC do //--sama seperti mencetak data sebelum nomor data yang disimpan
        begin // mencetak sisa data
        pencacahA:= pencacahA + 4;
        writeln(RiwayatUlas,'$');
        for b:=(pencacahA - 3) to pencacahA do
          writeln(RiwayatUlas,BacaSedia[b]);
        writeln(RiwayatUlas);
        flush(RiwayatUlas);
        end; //--
      close(RiwayatUlas); // tutup file
      end;
    if pemanduA > 1 then // jika masih ada sisa input ulasan..
      begin
      garis('-'); // beri garis pembatas
      pemanduA:= pemanduA - 1; // sisa input ulasan dikurang 1
      goto InputUlasanLagi; // kembali ke menginput ulasan
      end;
    end;
  end;
3: 
  begin
  if not ulasEof then // tutup data jika belum ditutup..
    close(Ulas);
  goto Penutup; // dan menuju penutup
  end;
  otherwise
    begin
    cetakInvalid(1,1,0,ulang); // menanyakan jika pengguna ingin mengulangi
    if ulang in ['y','Y'] then // jika ya.. kembali ke menginput pilihan
      goto UlangInputPilihan
    else // selain itu..
      begin
      if not ulasEof then // tutup file jika belum ditutup..
        close(Ulas);
      goto Penutup; // dan menuju penutup
      end;
    end;
  end;//endcaseof
Penutup:
end; // end procedure

  {program utama: }  
begin
{deklarasi awal: }
WaktuSekarang:= now; keluar:= false; pemanduA:=0; {inisialisasiE}

{cek file: }
if not (FileExists('Data.txt') AND FileExists('RiwayatData.txt') AND FileExists('RiwayatUlasan.txt') AND
    FileExists('Sedia.txt') AND FileExists('Ulasan.txt')) then // jika file tidak lengkap..
    begin
    Textcolor(yellow); // maka invalid..
    write('File ');
    Textcolor(white);
    write('yang akan digunakan ');
    Textcolor(red);
    write('tidak lengkap');
    Textcolor(white);
    writeln('!');
    writeln('Kami sarankan untuk mendownload kembali program dari web resmi hotel!');
    goto Penutup; // dan menuju penutup
    end;

{Menu Utama: }
repeat
UlangAwal: // Label UlangAwal jika pengguna ingin mengulangi setelah invalid
pemanduA:= pemanduA + 1; // pemandu berapa kali program menu utama telah dijalankan, mencegah error
clrscr; // membersihkan layar
garis('='); // prosedur mencetak garis
writeln('HOTEL AMAN SENTOSA');
garis('=');
writeln('Menu kamar: ');
writeln(' 1. Kamar Deluxe, anti bocor suara (500 jt / hari)');
writeln(' 2. Kamar Biasa, suara menggelegar (300 jt / hari)');
garis('-');
writeln(' Pilihan: ');
writeln('1. Pesan kamar');
writeln('2. Cek Ketersediaan Kamar');
writeln('3. Cetak Struk/Riwayat Pemesanan');
writeln('4. Informasi Hotel/Fasilitas Hotel');
writeln('5. ketentuan');
writeln('6. FAQ');
writeln('7. Ulasan');
writeln('8. Keluar');
garis('-');

{utama: }
write('Masukkan pilihan:');write(' ');readln(pemanduStr);
if (pemanduA > 1) AND (not keluar) then // mencegah bug (saat kedua kalinya program dijalankan, perintah readln anehnya tidak dijalankan)..
  readln(pemanduStr); // ..jadi perintah readln kedua diterapkan, dan itu bekerja
val(pemanduStr,pilihan,posisiSalah); // mencoba mengkonversi ke integer 'pilihan'
if posisiSalah > 0 then // jika ada kesalahan dalam konversi.. maka invalid
  begin
  cetakInvalid(2,1,0,ulang); // (2,1,0) mencetak pesan invalid dan menanyakan jika pengguna ingin menulangi
  if ulang in ['y','Y'] then // jika input adalah 'Y' atau 'y' maka.. kembali ke label UlangAwal
    begin
    keluar:= true;  // mencegah bug readln 2 kali
    goto UlangAwal;
    end
  else
    begin
    garis('=');
    writeln('Sampai jumpa'); // selain itu.. invalid dan menuju ke akhir program
    goto Penutup;
    end;
  end;
keluar:= false;  // mencegah bug readln 2 kali
case pilihan of // saat input valid.. angka yang diinput akan memanggil perintah tertentu sesuai menu
    1: DataLengkapPemesanan; // pemesanan kamar online
    2: CekKamar; // memeriksa ketersediaan kamar
    3: CetakStruk; // mencari riwayat pembelian atau mencetak struk riwayat pembelian
    4: FasilitasAtauInformasi; // melihat informasi mengenai hotel
    5: ketentuan; // melihat ketentuan dan kebijakan hotel
    6: FAQ; // melihat frequently asked question, atau pertanyaan yang sering ditanyakan
    7: Ulasan; // melihat atau menginput ulasan
    8: // keluar
      begin
      garis('=');
      writeln('Sampai jumpa');
      goto Penutup; // menutup penutup program
      end;
    otherwise // jika pilihan yang diinput tidak sesuai menu..
      begin
      cetakInvalid(1,1,0,ulang); // (1,1,0) mencetak pesan invalid dan menanyakan jika pengguna ingin mengulangi
      if ulang in ['y','Y'] then // jika ya.. maka kembali ke label UlangAwal
        begin
        keluar:= true; // mencegah bug readln 2 kali
        goto UlangAwal;
        end
      else
        begin
        garis('='); // selain itu.. maka invalid
        writeln('Sampai jumpa');
        goto Penutup;
        end;
      end;
    end;
garis('='); // mencetak garis
Ulangi(keluar); // panggil prosedur 'Ulangi'
until keluar; // berakhir jika 'Keluar=true' atau menuju label Penutup.
Penutup: // label penutup
readln; // menahan program agar tidak berakhir sebelum enter
end. // akhir program
