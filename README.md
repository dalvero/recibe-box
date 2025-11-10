# recipe_box

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# DANIEL'S README
# Recipe Box Database Schema

Dokumentasi struktur database aplikasi **Recipe Box**, sebuah aplikasi pengelolaan resep makanan dengan fitur kategori, bahan, dan langkah memasak.  
Database ini dirancang agar **efisien, relasional, dan mudah diintegrasikan** dengan SQLite, Supabase, maupun API berbasis REST/GraphQL.

---

## Struktur Database

### 1. Tabel `resep`
Menyimpan data utama dari setiap resep makanan.

| Kolom | Tipe Data | Keterangan |
|--------|------------|-------------|
| `resep_id` | INTEGER (PK, AUTOINCREMENT) | ID unik untuk setiap resep |
| `judul_resep` | TEXT | Judul resep makanan |
| `porsi` | INTEGER | Jumlah porsi yang dihasilkan |
| `waktu_memasak` | INTEGER | Lama waktu memasak (dalam menit) |
| `deskripsi` | TEXT | Deskripsi singkat resep |
| `favorite` | INTEGER (0/1) | Menandai resep favorit (1 = true, 0 = false) |
| `image_path` | TEXT | Path/URL gambar resep |

---

### 2. Tabel `kategori`
Menyimpan daftar kategori resep.

| Kolom | Tipe Data | Keterangan |
|--------|------------|-------------|
| `kategori_id` | INTEGER (PK, AUTOINCREMENT) | ID unik kategori |
| `nama_kategori` | TEXT | Nama kategori (contoh: “Cemilan”, “Minuman”, “Makanan Berat”) |

---

### 3. Tabel `kategori_resep`
Tabel relasi **many-to-many** antara `resep` dan `kategori`.

| Kolom | Tipe Data | Keterangan |
|--------|------------|-------------|
| `kategori_resep_id` | INTEGER (PK, AUTOINCREMENT) | ID unik relasi |
| `resep_id` | INTEGER (FK) | ID resep dari tabel `resep` |
| `kategori_id` | INTEGER (FK) | ID kategori dari tabel `kategori` |

**Relasi:**  
- `FOREIGN KEY (resep_id)` → `resep(resep_id)`  
- `FOREIGN KEY (kategori_id)` → `kategori(kategori_id)`

---

### 4. Tabel `bahan`
Menyimpan daftar bahan-bahan untuk setiap resep.

| Kolom | Tipe Data | Keterangan |
|--------|------------|-------------|
| `bahan_id` | INTEGER (PK, AUTOINCREMENT) | ID unik bahan |
| `resep_id` | INTEGER (FK) | ID resep yang memiliki bahan ini |
| `nama_bahan` | TEXT | Nama bahan |
| `kuantitas` | REAL | Jumlah bahan (boleh desimal, misal 1.5) |
| `satuan` | TEXT | Satuan bahan (gram, sendok, ml, dll) |
| `urutan_tampil` | INTEGER | Urutan tampil bahan di daftar |

**Relasi:**  
- `FOREIGN KEY (resep_id)` → `resep(resep_id)`

---

### 5. Tabel `langkah`
Menyimpan langkah-langkah memasak setiap resep.

| Kolom | Tipe Data | Keterangan |
|--------|------------|-------------|
| `langkah_id` | INTEGER (PK, AUTOINCREMENT) | ID unik langkah |
| `resep_id` | INTEGER (FK) | ID resep |
| `deskripsi` | TEXT | Penjelasan langkah memasak |
| `nomor_langkah` | INTEGER | Urutan langkah (1, 2, 3, dst) |

**Relasi:**  
- `FOREIGN KEY (resep_id)` → `resep(resep_id)`

---

## Hubungan Antar Tabel

| Relasi | Jenis Relasi | Keterangan |
|--------|---------------|-------------|
| `resep` ↔ `kategori` | Many-to-Many | Melalui `kategori_resep` |
| `resep` → `bahan` | One-to-Many | Satu resep memiliki banyak bahan |
| `resep` → `langkah` | One-to-Many | Satu resep memiliki banyak langkah |

---

## Catatan Penggunaan
- Gunakan `INTEGER (0/1)` untuk boolean di SQLite.  
- Simpan gambar dalam bentuk **path/URL**, bukan file binary.  
- `waktu_memasak` disarankan dalam satuan **menit**.  
- Pastikan setiap tabel memiliki **PRIMARY KEY AUTOINCREMENT** agar unik.

---

## Contoh Query SQLite

```sql
-- Membuat tabel
CREATE TABLE resep (
  resep_id INTEGER PRIMARY KEY AUTOINCREMENT,
  judul_resep TEXT NOT NULL,
  porsi INTEGER,
  waktu_memasak INTEGER,
  deskripsi TEXT,
  favorite INTEGER DEFAULT 0,
  image_path TEXT
);

CREATE TABLE kategori (
  kategori_id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_kategori TEXT NOT NULL
);

CREATE TABLE kategori_resep (
  kategori_resep_id INTEGER PRIMARY KEY AUTOINCREMENT,
  resep_id INTEGER,
  kategori_id INTEGER,
  FOREIGN KEY (resep_id) REFERENCES resep (resep_id),
  FOREIGN KEY (kategori_id) REFERENCES kategori (kategori_id)
);

CREATE TABLE bahan (
  bahan_id INTEGER PRIMARY KEY AUTOINCREMENT,
  resep_id INTEGER,
  nama_bahan TEXT NOT NULL,
  kuantitas REAL,
  satuan TEXT,
  urutan_tampil INTEGER,
  FOREIGN KEY (resep_id) REFERENCES resep (resep_id)
);

CREATE TABLE langkah (
  langkah_id INTEGER PRIMARY KEY AUTOINCREMENT,
  resep_id INTEGER,
  deskripsi TEXT NOT NULL,
  nomor_langkah INTEGER,
  FOREIGN KEY (resep_id) REFERENCES resep (resep_id)
);
