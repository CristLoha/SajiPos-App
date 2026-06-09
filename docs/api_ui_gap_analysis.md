# 📊 Analisis Kesenjangan (Gap Analysis) UI vs API Backend

Dokumentasi ini berisi perbandingan antara desain UI/UX yang telah diimplementasikan di aplikasi Flutter (Front-End) dengan struktur API Backend Laravel yang diberikan. Terdapat beberapa penyesuaian yang mungkin diperlukan oleh tim Backend agar sistem berjalan sinkron 100%.

---

## 1. 🏷️ Modul Diskon (Discounts)
**Kondisi di UI:** 
Pada desain UI, tampilan pop-up Diskon menampilkan teks seperti: `"Diskon Valentine (10%)"` beserta sub-teks `"Kode promo: V12"`.

**Kondisi di API (`GET /discounts`):**
API hanya mengembalikan data `name`, `description`, `type`, dan `value`. Tidak ada kolom khusus untuk kode promo (misal: `promo_code`).

**🛠️ Saran untuk Backend:**
- Mohon konfirmasi apakah `promo_code` akan ditambahkan di dalam skema *database/API*, atau apakah Front-End cukup menampilkan isi dari `description` untuk menggantikan teks "Kode promo".

---

## 2. 🧾 Modul Pajak (Tax) & Layanan (Service Charge)
**Kondisi di UI:**
Sistem Kasir memiliki pop-up terpisah untuk mengatur opsi PPN (misal 10% atau 11%) dan Layanan/Service Charge (misal 5% atau 10%).

**Kondisi di API:**
Saat ini belum ada *endpoint* `GET` untuk mengambil daftar persentase Pajak dan Layanan yang dinamis. Di API `POST /orders`, nilai ini langsung dikirim berupa *integer amount* (`service_charge` dan `tax`).

**🛠️ Saran untuk Backend:**
- Apakah nilai persentase untuk Pajak dan Layanan ini akan di-*hardcode* di dalam aplikasi Flutter? Jika nilai ini bersifat dinamis (bisa berubah dari *dashboard* admin), mohon dibuatkan endpoint `GET /taxes` dan `GET /services` atau jadikan satu di endpoint `GET /settings`.

---

## 3. 🚚 Modul Ongkos Kirim (Shipping/Ongkir)
**Kondisi di UI:**
UI kasir memiliki pop-up opsi pengiriman (misal: "GoFood - Rp 15.000", "GrabFood - Rp 12.000").

**Kondisi di API:**
Sama seperti pajak, hanya ada kolom `shipping_cost` di *payload* `POST /orders`, namun belum ada API untuk mengambil daftar harga Ongkir/Armada.

**🛠️ Saran untuk Backend:**
- Apakah daftar armada & harga ongkir bersifat dinamis? Jika iya, mungkin butuh endpoint tambahan seperti `GET /shipping-methods`. Jika tidak, Front-End akan melakukan *hardcode* pilihan tersebut.

---

## 4. 📝 Catatan Pesanan (Order Item Notes)
**Kondisi di UI:**
Di halaman konfirmasi pemesanan, setiap baris item memiliki *TextField* (kolom input) untuk "Catatan pesanan" (contoh: "Pedas, jangan pakai bawang").

**Kondisi di API (`POST /orders`):**
Pada bagian `order_items`, struktur payload hanya menerima:
```json
{
  "product_id": 1,
  "quantity": 2,
  "price": 20000
}
```
Tidak ada kolom untuk mengirim data catatan/instruksi khusus tersebut ke dapur/database.

**🛠️ Saran untuk Backend:**
- Mohon tambahkan parameter opsional `"note"` (string) di dalam *array* objek `order_items` pada saat `POST /orders`.
