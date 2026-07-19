# Dokumentasi SajiPOS — Platform: Tablet

## Cakupan Dokumen
Dokumen ini khusus mencakup fitur/perbaikan UX untuk **aplikasi di tablet** (layar ±768–1024px, biasanya diletakkan di meja kasir/konter, digunakan dengan sentuhan tapi punya ruang layar jauh lebih luas dibanding mobile). Prinsip dasarnya: gunakan kelebihan ruang layar seperti web admin, tapi tetap touch-friendly seperti mobile.

---

## Prinsip Umum Adaptasi Tablet
1. **Hybrid layout** — bisa pakai grid 2 kolom untuk kartu ringkasan (bukan 1 kolom seperti mobile, bukan 4 kolom sejajar seperti web), memanfaatkan lebar layar tanpa membuat teks/tombol jadi kecil.
2. **Tetap touch-friendly** — target ukuran tombol/tap minimal ±44x44pt meski ruang layar lebih luas; jangan meniru density tabel web admin secara mentah.
3. **Split-view memungkinkan** — karena layar cukup lebar, halaman detail (misal drill-down promo atau tanggal tertentu) bisa ditampilkan sebagai panel di samping, bukan harus pindah halaman penuh seperti di mobile.
4. **Orientasi ganda** — pertimbangkan portrait & landscape; landscape di tablet punya lebar mendekati web sehingga grid 2-3 kolom lebih pas, sementara portrait lebih dekat ke pengalaman mobile (1-2 kolom).

---

## Fitur: Halaman Promo/Diskon (Tablet)

### Perbedaan dari Versi Mobile
- Card promo bisa ditampilkan dalam **grid 2 kolom** (landscape) atau 1 kolom lebar (portrait), bukan strict 1 kolom seperti mobile.
- Karena ruang lebih luas, detail syarat & ketentuan promo bisa ditampilkan langsung di card tanpa perlu disingkat terlalu ketat seperti di mobile.
- Drill-down/detail promo (misal riwayat pemakaian promo tertentu) bisa dibuka sebagai **panel samping (split-view)**, bukan halaman penuh — kasir tetap bisa lihat daftar promo di kiri sambil lihat detail di kanan.

### Struktur Tampilan
- Tab status (Berlaku Sekarang | Akan Datang | Kedaluwarsa) tetap dipakai, ditampilkan sebagai horizontal tab di atas, bukan chip scroll seperti mobile karena ruang cukup untuk menampilkan semua opsi sekaligus.
- Grid kartu promo 2 kolom di landscape, dengan elemen yang sama seperti versi mobile: nama+status, kode, nilai diskon, syarat, masa berlaku, tombol "Gunakan di Transaksi".
- Search bar tetap di atas, bisa disandingkan dengan filter tipe promo di baris yang sama (karena ruang cukup, tidak perlu disembunyikan ke belakang tombol filter).

---

## Fitur: Laporan Penjualan (Tablet)

### Perbedaan dari Versi Mobile
- Kartu ringkasan (Omzet, Transaksi, Pajak, Diskon) ditampilkan grid **2x2 di portrait**, atau **sejajar 4 kolom di landscape** — mendekati layout web saat landscape.
- Grafik performa penjualan dan panel metode pembayaran bisa **berdampingan (side-by-side)** di landscape, seperti di web admin, karena lebar layar mencukupi — tidak perlu full-stack vertikal seperti mobile.
- Heatmap intensitas transaksi bisa menampilkan rentang lebih panjang dibanding versi mobile (misal 30 hari, bukan cuma 7 hari), karena ruang horizontal lebih luas — walau tetap disederhanakan dibanding versi 90 hari di web.
- Tabel "5 Menu Terlaris" bisa tetap berupa tabel ringkas (bukan wajib jadi card seperti mobile) karena kolom seperti Rank/Gambar/Nama/Kategori/Jumlah/Total masih muat tanpa scroll horizontal di lebar layar tablet standar.

### Struktur Tampilan (Landscape, disarankan)
1. Header + filter cepat (chip atau tab, muat semua opsi dalam satu baris tanpa scroll).
2. Kartu ringkasan 4 kolom sejajar.
3. Grafik performa penjualan (kiri) + Metode pembayaran (kanan), berdampingan.
4. Heatmap intensitas transaksi (30 hari) — 1 baris penuh di bawah grafik.
5. Tabel/list 5 menu terlaris.

### Struktur Tampilan (Portrait, disarankan)
- Ikuti pola mobile (1 kolom stack), tapi kartu ringkasan tetap bisa grid 2x2 karena lebar portrait tablet masih lebih besar dari mobile.

---

## Pertimbangan Teknis Khusus Tablet
- Perlu breakpoint terpisah di aplikasi (bukan cuma reuse layout mobile di-scale, atau reuse layout web di-shrink) — idealnya ada 3 breakpoint: mobile, tablet-portrait, tablet-landscape/web.
- Karena tablet sering dipakai dalam posisi tetap di meja kasir (landscape), prioritaskan pengalaman landscape sebagai default, portrait sebagai fallback.
- Reuse endpoint API yang sama dengan mobile & web; perbedaan platform cukup di layer UI, tidak perlu endpoint terpisah.
- Split-view (list + detail berdampingan) butuh state management tambahan di frontend untuk sinkronisasi item yang dipilih di list dengan panel detail — pastikan tim frontend tablet aware akan pattern ini sejak awal desain komponen.

## Prioritas Pengerjaan
1. Fase 1 (MVP): Terapkan breakpoint tablet dengan grid 2 kolom untuk promo & kartu ringkasan laporan (portrait & landscape dasar).
2. Fase 2: Split-view untuk drill-down promo & grafik berdampingan dengan metode pembayaran di landscape.
3. Fase 3: Heatmap 30 hari + penyesuaian tabel menu terlaris agar tetap tabel (bukan card) di tablet.

## Perbaikan Lanjutan: Proporsi Layout Grid Promo — Tampilan Tablet

### Masalah yang Teramati
1. **Card terlalu sempit relatif terhadap lebar layar** — dengan hanya 2 promo yang tampil, grid 2 kolom membuat card jadi kecil dan menempel ke kiri, padahal ruang di kanan cukup luas untuk kolom ke-3 atau card yang lebih lebar.
2. **Ruang kosong tidak tertangani** — ketika jumlah promo sedikit (misal hanya 2 item), sisa area grid dibiarkan kosong polos, bukan diisi dengan elemen lain.
3. **Search bar full-width vs card yang sempit** — ada ketimpangan visual: search bar di atas melebar penuh mengikuti lebar layar, tapi card promo di bawahnya tidak mengikuti proporsi yang sama.

### Referensi Pattern yang Sudah Benar: Halaman Beranda
Gunakan konfigurasi grid (jumlah kolom, maxCrossAxisExtent, padding horizontal, spacing antar-card) yang sama persis dengan yang dipakai di halaman Beranda, lalu terapkan ke halaman Promo. Ini mempercepat proses karena tim tidak perlu bereksperimen dari nol — tinggal reuse widget/konfigurasi grid yang sudah terbukti proporsional di Beranda.

---

## Bahasan Tambahan: Label Tombol Setelah Pembayaran Berhasil
Ubah tombol "Kembali ke Beranda" menjadi "Transaksi Baru" karena lebih actionable dan sejalan dengan mental model kasir yang bekerja cepat dan berulang.
