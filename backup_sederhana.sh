#!/bin/bash

# Script Otomasi Backup File

# Cek jumlah parameter
if [ "$#" -ne 2 ]; then
    echo "Cara pakai: $0 folder_sumber folder_tujuan"
    exit 1
fi

SUMBER="$1"
TUJUAN="$2"
LOG="backup.log"

# Cek folder sumber
if [ ! -d "$SUMBER" ]; then
    echo "Error: Folder sumber tidak ditemukan."
    echo "$(date): Backup gagal - sumber tidak ditemukan" >> "$LOG"
    exit 2
fi

# Cegah tujuan berada di dalam folder sumber
case "$TUJUAN" in
    "$SUMBER"/*)
        echo "Error: Folder tujuan tidak boleh di dalam folder sumber."
        echo "$(date): Backup gagal - tujuan berada di dalam sumber" >> "$LOG"
        exit 3
        ;;
esac

# Buat folder tujuan jika belum ada
mkdir -p "$TUJUAN" || {
    echo "Error: Gagal membuat folder tujuan."
    echo "$(date): Backup gagal - tidak bisa membuat tujuan" >> "$LOG"
    exit 4
}

# Jalankan backup
if cp -r "$SUMBER"/. "$TUJUAN"/; then
    echo "Backup berhasil."
    echo "$(date): Backup berhasil dari $SUMBER ke $TUJUAN" >> "$LOG"
    exit 0
else
    echo "Error: Backup gagal."
    echo "$(date): Backup gagal saat menyalin file" >> "$LOG"
    exit 5
fi
