import os
import re

replacements = [
    (r"ServerException\('Gagal memproses pesanan'\)", "ServerException('Pesanan gagal diproses nih, coba cek koneksi ya.')"),
    (r"'Gagal memproses pesanan'", "'Pesanan gagal diproses nih, coba cek koneksi ya.'"),
    (r"ServerException\('Gagal mengecek status pesanan'\)", "ServerException('Cek status pesanan lagi gagal nih, coba bentar lagi ya.')"),
    (r"'Gagal mengecek status pesanan'", "'Cek status pesanan lagi gagal nih, coba bentar lagi ya.'"),
    (r"DatabaseException\('Gagal menyimpan cache pajak'\)", "DatabaseException('Pajaknya gagal disimpan di perangkat.')"),
    (r"DatabaseException\('Gagal memuat cache pajak'\)", "DatabaseException('Pajaknya gagal dimuat nih.')"),
    (r"CacheFailure\('Gagal mengambil data pajak dari penyimpanan lokal\.'\)", "CacheFailure('Data pajak di perangkat belum bisa diambil.')"),
    (r"'Gagal mengambil data kategori: \$\{response.statusMessage\}'", "'Data kategori belum bisa ditarik: ${response.statusMessage}'"),
    (r"'Gagal masuk ke sistem. Silakan coba beberapa saat lagi.'", "'Yah login gagal nih. Silakan coba lagi nanti ya.'"),
    (r"ServerException\('Gagal keluar dari aplikasi.'\)", "ServerException('Belum bisa logout nih, koneksinya aman gak?')"),
    (r"'Gagal memproses keluar sistem.'", "'Logout tertunda nih.'"),
    (r"'Gagal logout karena tidak ada jaringan internet.'", "'Gagal logout, pastikan hp kamu ada internet ya.'"),
    (r"CacheFailure\('Gagal membaca token penyimpanan lokal'\)", "CacheFailure('Sesi bermasalah nih, coba login ulang ya.')"),
    (r"'Gagal mengambil data: \$\{response.statusMessage\}'", "'Wah gagal narik data nih: ${response.statusMessage}'"),
    (r"'Gagal mengambil detail produk'", "'Detail produknya belum mau muncul nih.'"),
    (r"'Gagal memuat data diskon'", "'Data diskon belum bisa dimuat nih.'"),
    (r"'Gagal mengambil data laporan hari ini'", "'Data laporan hari ini belum bisa dimuat nih.'"),
    (r"'Gagal membuka browser di perangkat ini'", "'Browsernya gak mau kebuka nih di perangkat ini.'"),
    (r"'Gagal membuka URL struk'", "'Link struknya gak bisa dibuka nih.'"),
    (r"'Gagal menyimpan struk: \$e'", "'Struk gagal disimpan nih: $e'"),
    (r"title = 'Oops! Gagal Memuat Data'", "title = 'Oops! Data Belum Bisa Tampil'"),
]

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r') as f:
                content = f.read()
            
            orig_content = content
            for p, r in replacements:
                content = re.sub(p, r, content)
            
            if content != orig_content:
                with open(path, 'w') as f:
                    f.write(content)
                print(f"Updated {path}")
