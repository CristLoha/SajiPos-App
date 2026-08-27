import os
import re

replacements = [
    (r"ServerFailure\('Sesi telah berakhir(\.)?( Silahkan login kembali\.)?'\)", "ServerFailure('Sesi kamu udah habis nih, login lagi yuk.')"),
    (r"ServerFailure\('Sesi telah berakhir(\.)?( Silakan login kembali\.)?'\)", "ServerFailure('Sesi kamu udah habis nih, login lagi yuk.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal mengecek status pesanan'\)", "ServerFailure(e.message ?? 'Cek status pesanan lagi gagal nih, coba bentar lagi ya.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal sinkronisasi kategori dari server'\)", "ServerFailure(e.message ?? 'Update kategori lagi gangguan, ditunggu ya.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal melakukan login'\)", "ServerFailure(e.message ?? 'Yah login gagal, pastikan datanya bener ya.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal melakukan logout'\)", "ServerFailure(e.message ?? 'Belum bisa logout nih, koneksinya aman gak?')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal mengambil detail produk'\)", "ServerFailure(e.message ?? 'Detail produknya ngumpet nih, coba di-refresh.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal mencari produk'\)", "ServerFailure(e.message ?? 'Produknya nggak ketemu, coba kata kunci lain ya.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal sinkronisasi data dari server'\)", "ServerFailure(e.message ?? 'Lagi susah nyambung ke server nih, sabar ya.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal memvalidasi kode diskon'\)", "ServerFailure(e.message ?? 'Kode diskonnya gagal dicek, jangan-jangan typo?')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal sinkronisasi diskon dari server'\)", "ServerFailure(e.message ?? 'Data diskon terbaru belum bisa ditarik nih.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal mengambil ringkasan laporan dari server'\)", "ServerFailure(e.message ?? 'Laporan belum bisa dimuat, coba tarik layar buat refresh.')"),
    (r"ServerFailure\(e\.message \?\? 'Gagal mengambil profil toko'\)", "ServerFailure(e.message ?? 'Profil toko belum bisa dimuat nih.')"),
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
