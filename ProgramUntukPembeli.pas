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
 // hapus kalimat ini dan masukkan prosedur datalengkappemesanan (1)

 // hapus kalimat ini dan masukkan prosedur cekKamar (2)

 // hapus kalimat ini dan masukkan prosedur cetakStruk (4)

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

 // hapus kalimat ini dan ganti dengan prosedur ulasan (4)

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
