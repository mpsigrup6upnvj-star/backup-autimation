# Otomasi Backup File Menggunakan Bash

## 1. Gambaran Umum

Proyek ini merupakan modul otomasi administrasi Linux untuk menyalin isi
folder sumber ke folder tujuan menggunakan Bash. Script membantu
pengguna membuat salinan file melalui terminal, memeriksa input dan
path, menampilkan pesan yang jelas, mengembalikan exit status sesuai
kondisi, serta mencatat aktivitas ke file log.

Script dijalankan ketika diperlukan. Penjadwalan otomatis belum
dikonfigurasi.

## 2. Use Case dan Tujuan

**Use case:** pengguna ingin menyalin isi sebuah folder ke folder lain
sebagai salinan cadangan.

Tujuan script ini adalah: - mempermudah penyalinan isi folder sumber ke
folder tujuan; - memeriksa jumlah parameter dan kondisi folder sebelum
menyalin; - menolak path tujuan yang tidak aman atau tidak valid; -
membedakan beberapa kondisi gagal melalui exit status; - mencatat
aktivitas backup yang berhasil maupun gagal ke file log.

## 3. Berkas Proyek

  -----------------------------------------------------------------------
  Berkas                              Kegunaan
  ----------------------------------- -----------------------------------
  `backup_sederhana.sh`               Script utama untuk menjalankan
                                      backup.

  `backup.log`                        Catatan aktivitas yang dihasilkan
                                      saat script dijalankan. File ini
                                      berada di direktori yang sama
                                      dengan script.

  `README.md`                         Dokumentasi penggunaan,
                                      pemeriksaan, pengujian, dan
                                      pembersihan.
  -----------------------------------------------------------------------

File `backup.log` dibuat atau ditambahkan secara otomatis saat script
dijalankan. Log yang disertakan sebagai bukti harus berasal dari
pengujian aktual.

## 4. Alur Kerja Script

1.  Memeriksa apakah pengguna memberikan tepat dua parameter, yaitu
    folder sumber dan folder tujuan.
2.  Memastikan folder sumber ada, berupa direktori, dan memiliki akses
    baca serta akses yang diperlukan untuk menelusuri isinya.
3.  Menentukan path absolut untuk memeriksa hubungan antara sumber dan
    tujuan.
4.  Menolak tujuan yang sama dengan sumber, berada di dalam sumber,
    menjadi induk sumber, atau sudah ada sebagai file biasa.
5.  Membuat folder tujuan jika belum tersedia.
6.  Memeriksa apakah folder tujuan dapat ditulisi dan diakses.
7.  Menyalin isi folder sumber menggunakan `cp -a`.
8.  Mencatat hasil ke `backup.log` dan menampilkan informasi hasil ke
    terminal.

Perintah `cp -a` berupaya mempertahankan atribut file sejauh didukung
sistem dan izin yang tersedia. Penggunaan `"$SUMBER_ABS/."` membuat isi
folder sumber, termasuk item tersembunyi, disalin ke folder tujuan.

## 5. Persyaratan dan Cara Menjalankan

Script dirancang untuk lingkungan Linux yang menyediakan Bash dan
utilitas seperti `cp`, `mkdir`, `realpath`, `dirname`, `basename`, serta
`date`.

Masuk ke direktori tempat script disimpan, kemudian jalankan:

``` bash
chmod +x backup_sederhana.sh
bash -n backup_sederhana.sh
```

`bash -n` hanya memeriksa sintaks Bash. Jika tidak ada keluaran,
biasanya tidak ditemukan kesalahan sintaks; hal ini bukan bukti bahwa
backup fungsional berhasil.

Jalankan script dengan dua path:

``` bash
./backup_sederhana.sh /path/folder_sumber /path/folder_tujuan
```

Ganti path contoh tersebut dengan direktori yang memang disiapkan untuk
pengujian. Jangan gunakan folder penting atau folder yang berisi data
pribadi.

### Contoh menyiapkan data uji

Contoh ini membuat folder pengujian di direktori home. Pastikan nama
direktori belum dipakai untuk data lain sebelum menjalankan perintah.

``` bash
mkdir -p "$HOME/backup-demo/sumber/subfolder"
printf 'Contoh isi untuk pengujian backup\n' > "$HOME/backup-demo/sumber/a.txt"
printf 'Contoh file di subfolder\n' > "$HOME/backup-demo/sumber/subfolder/b.txt"
```

Kemudian jalankan:

``` bash
./backup_sederhana.sh "$HOME/backup-demo/sumber" "$HOME/backup-demo/tujuan"
```

Pastikan folder tujuan berada di luar folder sumber.

## 6. Memeriksa Hasil Backup dan Log

Setelah menjalankan script:

1.  Baca pesan yang tampil di terminal.
2.  Periksa exit status segera setelah script selesai.
3.  Periksa file dan subfolder yang tersalin.
4.  Bandingkan isi sumber dan tujuan.
5.  Periksa log di direktori yang sama dengan script.

Contoh perintah:

``` bash
echo $?
ls -R "$HOME/backup-demo/tujuan"
diff -r "$HOME/backup-demo/sumber" "$HOME/backup-demo/tujuan"
cat ./backup.log
```

Jalankan `echo $?` tepat setelah perintah script yang ingin diperiksa.
Jika menjalankan perintah lain terlebih dahulu, nilai yang ditampilkan
adalah exit status perintah terakhir itu.

Jika `diff -r` tidak menampilkan perbedaan, isi yang dibandingkan
identik untuk pemeriksaan tersebut. Tetap perhatikan pesan dan exit
status dari script.

## 7. Exit Status

  -----------------------------------------------------------------------
                                      Kode Arti
  ---------------------------------------- ------------------------------
                                       `0` Backup berhasil dan log
                                           berhasil dicatat.

                                       `1` Jumlah parameter tidak sesuai.

                                       `2` Folder sumber tidak valid,
                                           tidak tersedia, atau tidak
                                           memiliki akses yang
                                           diperlukan.

                                       `3` Path tujuan tidak valid atau
                                           bertumpang tindih dengan
                                           sumber.

                                       `4` Folder tujuan gagal dibuat
                                           atau tidak dapat diakses untuk
                                           penulisan.

                                       `5` Proses penyalinan gagal.

                                       `7` Backup berhasil, tetapi
                                           pencatatan log gagal.
  -----------------------------------------------------------------------

Kode di atas sesuai dengan versi revisi `backup_sederhana.sh` yang diuji
Anggota 3. Tidak semua kode telah diuji secara aktual; status pengujian
masing-masing kondisi dijelaskan pada bagian hasil pengujian.

## 8. Logging

Aktivitas backup dicatat ke `backup.log` yang berada di direktori
script. Catatan memuat waktu dan keterangan keberhasilan atau kegagalan.
Contoh log aktual dari pengujian Anggota 3 mencatat satu backup berhasil
serta empat kondisi gagal.

Perlu diperhatikan bahwa exit status tidak ditulis sebagai kolom
tersendiri di dalam log. Exit status perlu dicatat dari terminal ketika
pengujian dilakukan.

Sebelum memasukkan log ke repository, periksa apakah terdapat path atau
informasi lokal yang sebaiknya disamarkan. Jangan mengunggah credential,
data pribadi, atau isi backup yang sensitif.

## 9. Hasil Pengujian Aktual

Pengujian berikut mengacu pada laporan `HASIL_PENGUJIAN.md`, screenshot,
dan `backup.log` yang diserahkan Anggota 3.

### Lingkungan pengujian

  Item               Hasil yang dilaporkan
  ------------------ ----------------------------------------------------
  Sistem operasi     Ubuntu 26.04 LTS
  Platform           Oracle VirtualBox
  Shell              GNU Bash 5.3.9
  Akses terminal     Konsol VM dan SSH dari CMD Windows ke VM yang sama
  Direktori proyek   `~/p11`

**Catatan lingkungan:** pengujian ini dilakukan pada Ubuntu di
VirtualBox, bukan Ubuntu WSL. Karena pembagian tugas awal menyebut
Ubuntu WSL, kesesuaian lingkungan ini perlu dikonfirmasi kepada kelompok
atau dosen. Jangan menyebut pengujian ini sebagai pengujian WSL.

### Ringkasan test case

  ----------------------------------------------------------------------------------------------------------------------------
  ID               Skenario dan perintah                                                Exit status aktual Hasil aktual
  ---------------- ----------------------------------------------------------------- --------------------- -------------------
  TC-01            Backup normal:                                                                      `0` Berhasil. File
                   `./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/tujuan`                               `a.txt` dan
                                                                                                           `subfolder/b.txt`
                                                                                                           tersalin. `diff -r`
                                                                                                           tidak menemukan
                                                                                                           perbedaan.

  TC-02            Parameter kurang: `./backup_sederhana.sh ~/p11/uji/sumber`                          `1` Ditolak. Pesan cara
                                                                                                           penggunaan
                                                                                                           ditampilkan.

  TC-03            Sumber tidak ada:                                                                   `2` Ditolak. Folder
                   `./backup_sederhana.sh ~/p11/uji/tidak_ada ~/p11/uji/tujuan2`                           `tujuan2` tidak
                                                                                                           terbentuk.

  TC-04            Tujuan di dalam sumber:                                                             `3` Ditolak karena
                   `./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/sumber/hasil`                         tujuan sama dengan
                                                                                                           atau berada di
                                                                                                           dalam sumber.

  TC-05            Tujuan berupa file:                                                                 `3` Ditolak karena path
                   `./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/file.txt`                             tujuan sudah ada
                                                                                                           tetapi bukan
                                                                                                           direktori.
  ----------------------------------------------------------------------------------------------------------------------------

TC-04 dan TC-05 merupakan pengujian tambahan. Semua hasil di atas
tercatat dalam log yang diserahkan Anggota 3.

### Pesan aktual yang relevan

-   TC-01: `Backup berhasil.`
-   TC-02:
    `Cara pakai: ./backup_sederhana.sh folder_sumber folder_tujuan`
-   TC-03: `Error: Folder sumber tidak ditemukan atau bukan direktori.`
-   TC-04:
    `Error: Folder tujuan tidak boleh sama dengan atau berada di dalam folder sumber.`
-   TC-05: `Error: Path tujuan sudah ada tetapi bukan direktori.`

### Interpretasi hasil

Berdasarkan laporan dan bukti yang diserahkan, kelima skenario yang
dijalankan menghasilkan exit status sesuai dengan yang diharapkan pada
laporan. Pada TC-01, isi folder tujuan dibandingkan dengan sumber
menggunakan `diff -r` dan dilaporkan identik. Pada TC-02 dan TC-03,
script menolak input yang tidak valid dengan exit status berbeda,
sehingga penyebab kegagalan dapat dibedakan. TC-04 dan TC-05 juga
ditolak dengan exit status `3`. Semua lima kejadian tercatat di
`backup.log`.

Kesimpulan ini hanya berlaku untuk skenario yang benar-benar dijalankan.
Ini tidak berarti seluruh kemungkinan kegagalan script sudah diuji.

### Bukti screenshot

Nama screenshot dalam arsip Anggota 3:

  -----------------------------------------------------------------------
  Screenshot                          Isi bukti
  ----------------------------------- -----------------------------------
  `01_lingkungan.png`                 Lingkungan Ubuntu pada konsol VM.

  `02_verifikasi_script.png`          Informasi file script dan
                                      pemeriksaan sintaks.

  `03_data_uji.png`                   Struktur folder sumber untuk
                                      pengujian.

  `04_test1_berhasil.png`             Pengujian backup berhasil.

  `05_test2_gagal_parameter.png`      Pengujian jumlah parameter salah.

  `06_test3_gagal_sumber.png`         Pengujian folder sumber tidak
                                      tersedia.

  `07_test_tambahan.png`              Dua pengujian tambahan untuk path
                                      tujuan.

  `08_log_lengkap.png`                Log aktivitas pengujian.

  `pembersihan.png`                   Bukti langkah pembersihan.
  -----------------------------------------------------------------------

Sertakan screenshot yang relevan di repository apabila diminta, dengan
nama file yang tetap jelas. Pastikan gambar tidak menampilkan informasi
pribadi yang tidak diperlukan.

## 10. Kondisi yang Belum Diuji

Menurut laporan Anggota 3, kondisi berikut belum diuji:

-   Exit status `5`, yaitu penyalinan gagal.
-   Exit status `7`, yaitu backup berhasil tetapi log gagal ditulis.
-   Folder sumber tidak memiliki izin baca.
-   Folder tujuan tidak dapat ditulisi, yang berkaitan dengan exit
    status `4`.

Dengan demikian, dokumentasi tidak menyatakan bahwa semua jalur error
telah dibuktikan. Pengujian lanjutan dapat dilakukan jika waktu dan
lingkungan memungkinkan.

## 11. Membersihkan File Pengujian

Simpan screenshot dan bukti log terlebih dahulu. Setelah itu, periksa
direktori uji sebelum menghapusnya.

``` bash
ls -la "$HOME/backup-demo"
```

Jika sudah dipastikan bahwa folder tersebut hanya berisi data uji yang
dibuat untuk proyek ini, hapus folder uji dengan:

``` bash
rm -r -- "$HOME/backup-demo"
```

Jangan menjalankan perintah penghapusan terhadap folder sumber asli,
direktori home, atau direktori yang belum diperiksa. Sesuaikan path
contoh dengan lokasi yang benar-benar digunakan. Pertahankan
`backup.log` sampai dokumentasi dan pengumpulan selesai jika log
tersebut masih diperlukan sebagai bukti.

## 12. Rollback dan Pemulihan

Script melakukan penyalinan, bukan pemindahan atau sinkronisasi penuh.
Script tidak menyediakan rollback otomatis.

Jika ingin membatalkan hasil pengujian:

1.  pastikan path tujuan adalah folder uji yang dibuat khusus untuk
    proyek;
2.  periksa isi folder tujuan dan pastikan tidak ada file penting;
3.  simpan bukti pengujian terlebih dahulu;
4.  hapus hanya folder tujuan uji yang sudah dipastikan aman untuk
    dihapus.

Jika tujuan sudah berisi file bernama sama, proses penyalinan dapat
menimpa file tersebut. Karena itu, hindari memakai folder tujuan yang
berisi data penting.

## 13. Keamanan dan Keterbatasan

-   Jangan menggunakan atau mengunggah password, token, private key,
    credential, data pribadi, atau file backup sensitif.
-   Script dijalankan secara manual; penjadwalan `cron` belum
    dikonfigurasi.
-   Script belum menyediakan arsip terkompresi, rotasi backup, retensi,
    notifikasi, atau rollback otomatis.
-   Log mencatat waktu dan pesan aktivitas, tetapi tidak menyimpan exit
    status sebagai kolom tersendiri.
-   Perilaku izin file dapat berbeda bergantung pada pengguna,
    filesystem, dan konfigurasi sistem.
-   Pemeriksaan sintaks tidak menggantikan pengujian fungsional.
-   Pengujian yang dilaporkan dilakukan di Ubuntu VirtualBox, bukan WSL;
    kesesuaian dengan ketentuan lingkungan tugas perlu dikonfirmasi.

## 14. Kontribusi Anggota Kelompok

Pastikan nama dan uraian di bawah sesuai dengan pekerjaan yang
benar-benar dilakukan setiap anggota.

  -----------------------------------------------------------------------
  Anggota                             Kontribusi
  ----------------------------------- -----------------------------------
  Anggota 1 --- Pengembangan Script   Membuat rancangan awal script
  Bash                                backup dan alur penyalinan folder
                                      sumber ke folder tujuan.

  Anggota 2 --- Validasi dan          Melengkapi validasi parameter dan
  Penanganan Error                    path, penanganan error, exit
                                      status, dan logging pada script
                                      revisi.

  Anggota 3 --- Pengujian dan Bukti   Menjalankan skenario uji, mencatat
  Hasil                               output dan exit status aktual,
                                      serta menyerahkan screenshot dan
                                      log.

  Anggota 4 --- Dokumentasi dan       Menyusun README, petunjuk
  README                              penggunaan, penjelasan error dan
                                      keterbatasan, serta
                                      mendokumentasikan hasil uji
                                      berdasarkan bukti Anggota 3.

  Anggota 5 --- Integrasi Repository  Mengintegrasikan berkas ke
  dan Pengumpulan                     repository, memeriksa kelengkapan
                                      dan keamanan, serta mengatur commit
                                      ID atau tag.
  -----------------------------------------------------------------------

Tambahkan nama anggota sesuai daftar kelompok. Jangan menyatakan
pekerjaan yang belum dilakukan sebagai pekerjaan yang sudah selesai.

## 15. Informasi Repository dan Rilis

Lengkapi setelah repository kelompok tersedia dan commit final dibuat:

-   **Nama kelompok:** \[isi nama kelompok\]
-   **Nama anggota:** \[isi nama anggota\]
-   **URL repository:** \[isi URL repository\]
-   **Branch:** \[isi nama branch\]
-   **Commit ID atau tag:** \[isi commit ID atau tag aktual\]
-   **Tag yang disarankan:** `P2-CHECKPOINT-P11-v01`

Jangan mengarang URL repository, commit ID, tag yang sudah dibuat, atau
hasil pengujian. Informasi tersebut harus diambil dari repository yang
sebenarnya.
