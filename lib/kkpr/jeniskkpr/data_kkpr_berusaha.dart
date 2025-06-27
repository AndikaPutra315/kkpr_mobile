import 'package:flutter/material.dart';

// Import halaman form tambah dan edit data
import 'tambah_data_kkprberusaha.dart';
import 'edit_berusaha.dart'; // [PERBAIKAN 1]: Import diaktifkan

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

class DataKkprBerusahaPage extends StatelessWidget {
  const DataKkprBerusahaPage({super.key});

  static const List<KkprData> dummyDataKkpr = [
    KkprData(
      id: 1,
      namaPelakuUsaha: 'PT. Jaya Abadi',
      npwp: '01.234.567.8-901.000',
      alamatKantor: 'Jl. Jend. Sudirman No. 1, Jakarta',
      telepon: '081234567890',
      email: 'kontak@jayaabadi.com',
      statusPenanamanModal: 'PMDN',
      kodeKbli: '46311',
      judulKbli: 'Perdagangan Besar Makanan dan Minuman',
      sektorUsaha: 'Perdagangan',
      skalaUsaha: 'Usaha Besar',
      alamatUsaha: 'Jl. Gatot Subroto No. 2, Banjarmasin',
      kelurahan: 'Sungai Baru',
      kecamatan: 'Banjarmasin Tengah',
      kabupaten: 'Kota Banjarmasin',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '5000',
      jenisKkpr: 'Kkpr Terintegrasi',
      jenisKkprDokumen: 'RDTR',
      namaFile: 'dokumen_jaya_abadi.csv',
    ),
    KkprData(
      id: 2,
      namaPelakuUsaha: 'CV. Cipta Karya',
      npwp: '02.345.678.9-012.000',
      alamatKantor: 'Jl. Pahlawan No. 45, Surabaya',
      telepon: '085678901234',
      email: 'info@ciptakarya.id',
      statusPenanamanModal: 'PMDN',
      kodeKbli: '71101',
      judulKbli: 'Aktivitas Arsitektur',
      sektorUsaha: 'Jasa',
      skalaUsaha: 'Usaha Menengah',
      alamatUsaha: 'Jl. A. Yani Km. 5, Banjarmasin',
      kelurahan: 'Pemurus Dalam',
      kecamatan: 'Banjarmasin Selatan',
      kabupaten: 'Kota Banjarmasin',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '1500',
      jenisKkpr: 'Kkpr Non Terintegrasi',
      jenisKkprDokumen: 'RTRW',
      namaFile: 'berkas_cipta_karya.csv',
    ),
  ];

  static const Color primaryColor = Color(0xFF007BFF);
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
            const Text('Data KKPR Berusaha'),
          ],
        ),
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
              builder: (context) => const TambahDataKkprBerusahaPage(),
            ),
          );
        },
        label: const Text('Tambah Data'),
        icon: const Icon(Icons.add),
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
        leading: const CircleAvatar(backgroundColor: primaryColor, child: Icon(Icons.business, color: Colors.white)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSectionTitle('Informasi Pelaku Usaha'),
                _buildDataRow(Icons.badge, 'NPWP', data.npwp),
                _buildDataRow(Icons.location_city, 'Alamat Kantor', data.alamatKantor),
                _buildDataRow(Icons.phone, 'Telepon', data.telepon),
                _buildDataRow(Icons.email, 'Email', data.email),
                const SizedBox(height: 12),
                _buildSectionTitle('Detail Usaha'),
                _buildDataRow(Icons.business_center, 'Status Modal', data.statusPenanamanModal),
                _buildDataRow(Icons.qr_code, 'Kode & Judul KBLI', '${data.kodeKbli} - ${data.judulKbli}'),
                _buildDataRow(Icons.category, 'Sektor Usaha', data.sektorUsaha),
                _buildDataRow(Icons.analytics, 'Skala Usaha', data.skalaUsaha),
                const SizedBox(height: 12),
                _buildSectionTitle('Lokasi & Informasi KKPR'),
                _buildDataRow(Icons.store, 'Alamat Usaha', '${data.alamatUsaha}, ${data.kelurahan}, ${data.kecamatan}'),
                _buildDataRow(Icons.square_foot, 'Luas Tanah', '${data.luasTanah} m²'),
                _buildDataRow(Icons.file_copy, 'Jenis KKPR', data.jenisKkpr),
                _buildDataRow(Icons.source, 'Dasar Dokumen', data.jenisKkprDokumen),
                _buildDataRow(Icons.upload_file, 'File Terlampir', data.namaFile),
                const SizedBox(height: 10),
                _buildActionButtons(context, data),
              ],
            ),
          )
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
            // [PERBAIKAN 2]: Navigasi ke halaman edit diaktifkan
            Navigator.push(
              context,
              MaterialPageRoute(
                // Mengirimkan data yang akan diedit ke halaman Edit
                builder: (context) => EditDataKkprBerusahaPage(data: data),
              ),
            );
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
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
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
