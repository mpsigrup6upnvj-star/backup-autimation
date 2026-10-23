# Hasil Pengujian — Backup File

**Penguji:** Anggota 3
**Script yang diuji:** `backup_sederhana.sh`
**Sumber data:** seluruh isi dokumen ini disalin dari screenshot dan log hasil eksekusi aktual (`01_lingkungan.png` s.d. `08_log_lengkap.png` dan `backup.log`).

## Lingkungan uji
| Item | Nilai |
|---|---|
| Sistem operasi | Ubuntu 26.04 LTS |
| Platform | Oracle VirtualBox (VM `so26-2510501071-c`) |
| Pengguna | `cahayaay` |
| Bash | GNU bash 5.3.9(1)-release (x86_64-pc-linux-gnu) |
| Kernel | 7.0.0-31-generic |
| Cara mengakses | Screenshot 01 diambil dari layar konsol VM; screenshot 02–08 diambil dari jendela CMD Windows yang tersambung ke VM yang sama lewat SSH (hostname sama: `so26-2510501071-c`) |
| Direktori kerja | `~/p11` (script dan `backup.log` berada di folder ini) |

## Verifikasi script sebelum pengujian
Screenshot: `02_verifikasi_script.png`

| Pemeriksaan | Hasil aktual |
|---|---|
| Baris pertama (`head -1`) | `#!/bin/bash` |
| Dua baris terakhir (`tail -2`) | `    exit 5` dan `fi` |
| Jumlah baris (`wc -l`) | `130` |
| Tipe file (`file`) | `Bourne-Again shell script, ASCII text executable` |
| SHA-256 | `68561b766887aa92840f90e69a1c08d66b11088eb9f311cb2c73c35de3efe0b5` |
| Sintaks (`bash -n`) | Tidak ada output (tidak ada error sintaks) |

Catatan: Seluruh pengujian di bawah dijalankan pada versi `scp` ini.

## Data uji
Screenshot: `03_data_uji.png`

```
/home/cahayaay/p11/uji/sumber/a.txt
/home/cahayaay/p11/uji/sumber/subfolder/b.txt
```

---

## Test case 1 — Berhasil
- **Tujuan pengujian:** Memastikan script menyalin isi folder sumber ke folder tujuan dan mencatat keberhasilan ke log.
- **Perintah yang dijalankan:**
  ```
  ./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/tujuan
  ```
- **Output aktual:**
  ```
  Backup berhasil.
  Sumber : /home/cahayaay/p11/uji/sumber
  Tujuan : /home/cahayaay/p11/uji/tujuan
  Log    : /home/cahayaay/p11/backup.log
  ```
- **Exit status aktual:** `0`
- **Apakah file tersalin dan isinya sesuai?:** Ya. `ls -R ~/p11/uji/tujuan` menampilkan `a.txt`, `subfolder`, dan `subfolder/b.txt`. Perintah `diff -r ~/p11/uji/sumber ~/p11/uji/tujuan` tidak menampilkan perbedaan dan mencetak `ISI IDENTIK`.
- **Baris log aktual:**
  ```
  [2026-10-22 21:20:12] Backup berhasil dari '/home/cahayaay/p11/uji/sumber' ke '/home/cahayaay/p11/uji/tujuan'
  ```
- **Screenshot:** `04_test1_berhasil.png`

## Test case 2 — Gagal: jumlah parameter salah
- **Tujuan pengujian:** Memastikan script menolak jumlah parameter yang tidak sesuai.
- **Perintah yang dijalankan:**
  ```
  ./backup_sederhana.sh ~/p11/uji/sumber
  ```
- **Output aktual:**
  ```
  Cara pakai: ./backup_sederhana.sh folder_sumber folder_tujuan
  ```
- **Exit status aktual:** `1`
- **Baris log aktual:**
  ```
  [2026-10-22 21:25:35] Backup gagal: jumlah parameter tidak valid
  ```
- **Screenshot:** `05_test2_gagal_parameter.png`

## Test case 3 — Gagal: folder sumber tidak tersedia
- **Tujuan pengujian:** Memastikan script menolak sumber yang tidak ada.
- **Perintah yang dijalankan:**
  ```
  ./backup_sederhana.sh ~/p11/uji/tidak_ada ~/p11/uji/tujuan2
  ```
- **Output aktual:**
  ```
  Error: Folder sumber tidak ditemukan atau bukan direktori.
  ```
- **Exit status aktual:** `2`
- **Folder tujuan terbentuk?:** Tidak. `ls ~/p11/uji` hanya menampilkan `sumber` dan `tujuan` (hasil Test 1); folder `tujuan2` tidak ada.
- **Baris log aktual:**
  ```
  [2026-10-22 21:27:34] Backup gagal: sumber tidak valid (/home/cahayaay/p11/uji/tidak_ada)
  ```
- **Screenshot:** `06_test3_gagal_sumber.png`

## Test tambahan — Gagal: tujuan tidak aman/tidak valid
Screenshot: `07_test_tambahan.png`

### 4a. Tujuan berada di dalam folder sumber
- **Perintah yang dijalankan:**
  ```
  ./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/sumber/hasil ; echo $?
  ```
- **Output aktual:**
  ```
  Error: Folder tujuan tidak boleh sama dengan atau berada di dalam folder sumber.
  ```
- **Exit status aktual:** `3`
- **Baris log aktual:**
  ```
  [2026-10-22 21:29:23] Backup gagal: tujuan sama dengan/berada di dalam sumber (/home/cahayaay/p11/uji/sumber/hasil)
  ```

### 4b. Tujuan sudah ada tetapi berupa file, bukan direktori
- **Persiapan:** `echo x > ~/p11/uji/file.txt`
- **Perintah yang dijalankan:**
  ```
  ./backup_sederhana.sh ~/p11/uji/sumber ~/p11/uji/file.txt ; echo $?
  ```
- **Output aktual:**
  ```
  Error: Path tujuan sudah ada tetapi bukan direktori.
  ```
- **Exit status aktual:** `3`
- **Baris log aktual:**
  ```
  [2026-10-22 21:29:25] Backup gagal: tujuan bukan direktori (/home/cahayaay/p11/uji/file.txt)
  ```

## Log lengkap
Screenshot: `08_log_lengkap.png` — berkas: `backup.log`

```
[2026-10-22 21:20:12] Backup berhasil dari '/home/cahayaay/p11/uji/sumber' ke '/home/cahayaay/p11/uji/tujuan'
[2026-10-22 21:25:35] Backup gagal: jumlah parameter tidak valid
[2026-10-22 21:27:34] Backup gagal: sumber tidak valid (/home/cahayaay/p11/uji/tidak_ada)
[2026-10-22 21:29:23] Backup gagal: tujuan sama dengan/berada di dalam sumber (/home/cahayaay/p11/uji/sumber/hasil)
[2026-10-22 21:29:25] Backup gagal: tujuan bukan direktori (/home/cahayaay/p11/uji/file.txt)
```

## Rekap hasil
| No | Skenario | Exit status diharapkan* | Exit status aktual | Tercatat di log |
|---|---|---:|---:|---|
| 1 | Backup normal | 0 | 0 | Ya |
| 2 | Jumlah parameter salah | 1 | 1 | Ya |
| 3 | Sumber tidak ada | 2 | 2 | Ya |
| 4a | Tujuan di dalam sumber | 3 | 3 | Ya |
| 4b | Tujuan berupa file | 3 | 3 | Ya |

\*Berdasarkan tabel exit status pada `README_ANGGOTA_2.md`.


## Interpretasi singkat
Seluruh pengujian yang dijalankan sesuai dengan hasil yang diharapkan. Pada Test 1, script menyelesaikan backup dengan exit status 0, isi folder tujuan identik dengan sumber (`diff` tidak menunjukkan perbedaan), dan keberhasilan tercatat di `backup.log`. Pada Test 2 dan Test 3, script menolak input dengan pesan yang jelas dan exit status berbeda (1 untuk jumlah parameter salah, 2 untuk sumber tidak ada), sehingga jenis kegagalan dapat dibedakan. Pada Test 3, folder tujuan tidak dibuat. Dua test tambahan (tujuan di dalam sumber dan tujuan berupa file) sama-sama ditolak dengan exit status 3 dan tercatat di log. Semua kejadian, baik berhasil maupun gagal, tercatat di `backup.log`.

## Hal yang tidak diuji / keterbatasan
- Exit status `5` (penyalinan gagal) dan `7` (backup berhasil tetapi log gagal ditulis) tidak diuji karena sulit dipancing dengan aman pada lingkungan uji.
- Kondisi folder sumber tidak memiliki izin baca (exit 2 untuk kasus izin) dan folder tujuan tidak dapat ditulis (exit 4) tidak diuji.
- Log hanya mencatat waktu dan pesan; exit status tidak ikut tercatat di log.
- Log berisi path home pengguna (`/home/cahayaay/...`).
- Penjadwalan otomatis dengan `cron`, arsip terkompresi, dan rotasi backup belum ada pada script ini (sesuai `README_ANGGOTA_2.md`).
