import 'package:flutter/material.dart';
import 'data_kkpr_berusaha.dart'; // Import model KkprData

class DetailKkprBerusahaPage extends StatelessWidget {
  final KkprData data;

  const DetailKkprBerusahaPage({super.key, required this.data});

  // Palet Warna
  static const Color primaryColor = Color(0xFF3A5795);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Data KKPR'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Informasi Pelaku Usaha',
              icon: Icons.business,
              children: [
                _buildDetailRow('Nama Pelaku Usaha', data.namaPelakuUsaha),
                _buildDetailRow('NPWP', data.npwp ?? '-'),
                _buildDetailRow('Alamat Kantor', data.alamatKantor ?? '-'),
                _buildDetailRow('Telepon', data.telepon ?? '-'),
                _buildDetailRow('Email', data.email ?? '-'),
              ],
            ),
            _buildSectionCard(
              title: 'Detail Usaha',
              icon: Icons.work,
              children: [
                _buildDetailRow('Status Modal', data.statusPenanamanModal ?? '-'),
                _buildDetailRow('Kode KBLI', data.kodeKbli ?? '-'),
                _buildDetailRow('Judul KBLI', data.judulKbli ?? '-'),
        //        _buildDetailRow('Sektor Usaha', data.sektorUsaha ?? '-'),
                _buildDetailRow('Skala Usaha', data.skalaUsaha ?? '-'),
              ],
            ),
            _buildSectionCard(
              title: 'Lokasi & Informasi KKPR',
              icon: Icons.map,
              children: [
                _buildDetailRow('Alamat Usaha', '${data.alamatUsaha ?? ''}, ${data.kelurahan ?? ''}, ${data.kecamatan ?? ''}'),
                _buildDetailRow('Kabupaten/Kota', data.kabupaten ?? '-'),
                _buildDetailRow('Provinsi', data.provinsi ?? '-'),
                _buildDetailRow('Luas Tanah', '${data.luasTanah ?? '0'} m²'),
         //       _buildDetailRow('Jenis KKPR', data.jenisKkpr ?? '-'),
                _buildDetailRow('Dasar Dokumen', data.jenisKkprDokumen ?? '-'),
                _buildDetailRow('File Terlampir', data.namaFile ?? 'Tidak ada'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat card per seksi
  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat baris detail (Label & Value)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: hintColor, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

