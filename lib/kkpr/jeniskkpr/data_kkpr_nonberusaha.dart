import 'package:flutter/material.dart';

import 'tambah_data_kkprnonberusaha.dart';
import 'edit_nonberusaha.dart';

class KkprData {
  final int id;
  final String namaPelakuUsaha;
  final String npwp;
  final String alamatKantor;
  final String telepon;
  final String email;
  final String statusPenanamanModal;
  final String kodeKbli;
  final String judulKbli;
  final String sektorUsaha;
  final String skalaUsaha;
  final String alamatUsaha;
  final String kelurahan;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String luasTanah;
  final String jenisKkpr;
  final String jenisKkprDokumen;
  final String namaFile;

  const KkprData({
    required this.id,
    required this.namaPelakuUsaha,
    required this.npwp,
    required this.alamatKantor,
    required this.telepon,
    required this.email,
    required this.statusPenanamanModal,
    required this.kodeKbli,
    required this.judulKbli,
    required this.sektorUsaha,
    required this.skalaUsaha,
    required this.alamatUsaha,
    required this.kelurahan,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.luasTanah,
    required this.jenisKkpr,
    required this.jenisKkprDokumen,
    required this.namaFile,
  });
}

class DataKkprNonBerusahaPage extends StatelessWidget {
  const DataKkprNonBerusahaPage({super.key});

  static const List<KkprData> dummyDataKkpr = [
    KkprData(
      id: 1,
      namaPelakuUsaha: 'Bapak Sigit Budi Hartono',
      npwp: '-',
      alamatKantor: 'Jl. Merpati No. 10, Banjarmasin',
      telepon: '081211112222',
      email: 'budi.s@email.com',
      statusPenanamanModal: 'Non Usaha',
      kodeKbli: '-',
      judulKbli: 'Pembangunan Rumah Tinggal',
      sektorUsaha: 'Perumahan',
      skalaUsaha: '-',
      alamatUsaha: 'Jl. Cendrawasih Komp. Griya Indah Blok C No. 5',
      kelurahan: 'Belitung Utara',
      kecamatan: 'Banjarmasin Barat',
      kabupaten: 'Kota Banjarmasin',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '150',
      jenisKkpr: 'Kkpr Non Terintegrasi',
      jenisKkprDokumen: 'RTRW',
      namaFile: 'dokumen_rumah_budi.pdf',
    ),
    KkprData(
      id: 2,
      namaPelakuUsaha: 'Ibu Siti Aminah',
      npwp: '-',
      alamatKantor: 'Jl. Dahlia No. 3, Banjarbaru',
      telepon: '081333334444',
      email: 'siti.aminah@email.com',
      statusPenanamanModal: 'Non Usaha',
      kodeKbli: '-',
      judulKbli: 'Pembangunan Tempat Ibadah',
      sektorUsaha: 'Sosial',
      skalaUsaha: '-',
      alamatUsaha: 'Jl. Masjid Jami, Martapura',
      kelurahan: 'Jawa Laut',
      kecamatan: 'Martapura',
      kabupaten: 'Banjar',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '1000',
      jenisKkpr: 'Kkpr Non Terintegrasi',
      jenisKkprDokumen: 'RTRW',
      namaFile: 'berkas_masjid_jami.pdf',
    ),
  ];

  static const Color primaryColor = Color(0xFF28A745);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 35),
            const SizedBox(width: 10),
            // [PERBAIKAN]: Bungkus Text dengan Expanded agar fleksibel
            const Expanded(
              child: Text(
                'Data KKPR Non Berusaha',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, // Jika masih terlalu panjang, akan menjadi "..."
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyDataKkpr.length,
        itemBuilder: (context, index) {
          final data = dummyDataKkpr[index];
          return _buildKkprCard(context, data);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataKkprNonBerusahaPage(),
            ),
          );
        },
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildKkprCard(BuildContext context, KkprData data) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(data.namaPelakuUsaha, style: const TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
        subtitle: Text(data.judulKbli, style: const TextStyle(color: hintColor, fontSize: 14)),
        leading: const CircleAvatar(backgroundColor: primaryColor, child: Icon(Icons.person, color: Colors.white)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSectionTitle('Informasi Pemohon'),
                _buildDataRow(Icons.home, 'Alamat Tinggal', data.alamatKantor),
                _buildDataRow(Icons.phone, 'Telepon', data.telepon),
                _buildDataRow(Icons.email, 'Email', data.email),
                const SizedBox(height: 12),
                _buildSectionTitle('Detail Kegiatan'),
                _buildDataRow(Icons.comment, 'Tujuan Kegiatan', data.judulKbli),
                _buildDataRow(Icons.category, 'Sektor Kegiatan', data.sektorUsaha),
                const SizedBox(height: 12),
                _buildSectionTitle('Lokasi & Informasi KKPR'),
                _buildDataRow(Icons.location_on, 'Alamat Lokasi', '${data.alamatUsaha}, ${data.kelurahan}, ${data.kecamatan}'),
                _buildDataRow(Icons.square_foot, 'Luas Tanah', '${data.luasTanah} m²'),
                _buildDataRow(Icons.file_copy, 'Jenis KKPR', data.jenisKkpr),
                _buildDataRow(Icons.source, 'Dasar Dokumen', data.jenisKkprDokumen),
                _buildDataRow(Icons.upload_file, 'File Terlampir', data.namaFile),
                const SizedBox(height: 10),
                _buildActionButtons(context, data),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, KkprData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.orange),
          tooltip: 'Edit Data',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataKkprNonBerusahaPage(data: data)));
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Hapus Data',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: Text('Anda yakin ingin menghapus data untuk "${data.namaPelakuUsaha}"?'),
                  actions: <Widget>[
                    TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
                    TextButton(
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data dihapus (simulasi).')));
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: hintColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$label: ',
                style: const TextStyle(color: hintColor, fontSize: 14),
                children: [TextSpan(text: value, style: const TextStyle(color: textColor, fontWeight: FontWeight.w500))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
