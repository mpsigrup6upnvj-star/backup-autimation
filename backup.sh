#!/bin/bash
# Script Otomasi Backup File
# Revisi Anggota 2: Validasi Input, Error Handling, Exit Status, dan Logging
#
# Penggunaan:
#   ./backup_sederhana.sh FOLDER_SUMBER FOLDER_TUJUAN
#
# Exit status:
#   0 = backup berhasil
#   1 = jumlah parameter salah
#   2 = folder sumber tidak valid/tidak tersedia
#   3 = path tujuan tidak aman atau tidak valid
#   4 = folder tujuan gagal dibuat/tidak dapat diakses
#   5 = proses penyalinan gagal
#   7 = backup berhasil tetapi pencatatan log gagal

set -o pipefail

# Simpan log di folder yang sama dengan script agar lokasinya konsisten.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG="${SCRIPT_DIR}/backup.log"

log_activity() {
    local message="$1"
    if ! printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$message" >> "$LOG"; then
        echo "Error: Gagal menulis ke file log: $LOG" >&2
        return 1
    fi
}

usage() {
    echo "Cara pakai: $0 folder_sumber folder_tujuan"
}

# 1. Validasi jumlah parameter
if [ "$#" -ne 2 ]; then
    usage
    log_activity "Backup gagal: jumlah parameter tidak valid" || true
    exit 1
fi

SUMBER="$1"
TUJUAN="$2"

# 2. Validasi folder sumber
if [ ! -d "$SUMBER" ]; then
    echo "Error: Folder sumber tidak ditemukan atau bukan direktori." >&2
    log_activity "Backup gagal: sumber tidak valid ($SUMBER)" || true
    exit 2
fi

if [ ! -r "$SUMBER" ] || [ ! -x "$SUMBER" ]; then
    echo "Error: Folder sumber tidak memiliki akses baca yang diperlukan." >&2
    log_activity "Backup gagal: sumber tidak dapat dibaca ($SUMBER)" || true
    exit 2
fi

# 3. Normalisasi path untuk memeriksa sumber dan tujuan secara lebih konsisten.
SUMBER_ABS="$(realpath -e -- "$SUMBER")" || {
    echo "Error: Tidak dapat menentukan path folder sumber." >&2
    log_activity "Backup gagal: path sumber tidak valid ($SUMBER)" || true
    exit 2
}

PARENT="$(dirname -- "$TUJUAN")"
BASENAME="$(basename -- "$TUJUAN")"

PARENT_ABS="$(realpath -m -- "$PARENT")" || {
    echo "Error: Tidak dapat menentukan path folder tujuan." >&2
    log_activity "Backup gagal: path tujuan tidak valid ($TUJUAN)" || true
    exit 3
}

TUJUAN_ABS="${PARENT_ABS}/${BASENAME}"

# Tolak jika tujuan sama dengan sumber atau berada di dalam sumber.
case "$TUJUAN_ABS/" in
    "$SUMBER_ABS/"*)
        echo "Error: Folder tujuan tidak boleh sama dengan atau berada di dalam folder sumber." >&2
        log_activity "Backup gagal: tujuan sama dengan/berada di dalam sumber ($TUJUAN_ABS)" || true
        exit 3
        ;;
esac

# Tolak jika tujuan merupakan induk dari sumber.
case "$SUMBER_ABS/" in
    "$TUJUAN_ABS/"*)
        echo "Error: Folder tujuan tidak boleh menjadi folder induk sumber." >&2
        log_activity "Backup gagal: tujuan merupakan induk sumber ($TUJUAN_ABS)" || true
        exit 3
        ;;
esac

# Tolak tujuan yang sudah ada tetapi bukan direktori.
if [ -e "$TUJUAN_ABS" ] && [ ! -d "$TUJUAN_ABS" ]; then
    echo "Error: Path tujuan sudah ada tetapi bukan direktori." >&2
    log_activity "Backup gagal: tujuan bukan direktori ($TUJUAN_ABS)" || true
    exit 3
fi

# 4. Buat folder tujuan jika belum tersedia.
if ! mkdir -p -- "$TUJUAN_ABS"; then
    echo "Error: Gagal membuat folder tujuan." >&2
    log_activity "Backup gagal: tidak bisa membuat tujuan ($TUJUAN_ABS)" || true
    exit 4
fi

if [ ! -w "$TUJUAN_ABS" ] || [ ! -x "$TUJUAN_ABS" ]; then
    echo "Error: Folder tujuan tidak dapat ditulisi atau diakses." >&2
    log_activity "Backup gagal: tujuan tidak dapat ditulisi/diakses ($TUJUAN_ABS)" || true
    exit 4
fi

# 5. Jalankan backup dan catat hasilnya.
if cp -a -- "$SUMBER_ABS/." "$TUJUAN_ABS/"; then
    if ! log_activity "Backup berhasil dari '$SUMBER_ABS' ke '$TUJUAN_ABS'"; then
        echo "Peringatan: Backup berhasil, tetapi pencatatan log gagal." >&2
        exit 7
    fi

    echo "Backup berhasil."
    echo "Sumber : $SUMBER_ABS"
    echo "Tujuan : $TUJUAN_ABS"
    echo "Log    : $LOG"
    exit 0
else
    echo "Error: Backup gagal saat menyalin file." >&2
    log_activity "Backup gagal saat menyalin file dari '$SUMBER_ABS' ke '$TUJUAN_ABS'" || true
    exit 5
fi
