import 'package:flutter/material.dart';

import 'tambah_data_survey_mandiri.dart';
import 'edit_survey_mandiri.dart';

class SurveyMandiriData {
  final int id;
  final String namaPemohon;
  final String nomorPernyataan;
  final String lokasiUsaha;
  final String tanggalPenilaian;
  final String statusPenilaian;
  final String hasilPenilaian;
  final String? namaFile;

  const SurveyMandiriData({
    required this.id,
    required this.namaPemohon,
    required this.nomorPernyataan,
    required this.lokasiUsaha,
    required this.tanggalPenilaian,
    required this.statusPenilaian,
    required this.hasilPenilaian,
    this.namaFile,
  });
}

class SurveyMandiriPage extends StatelessWidget {
  const SurveyMandiriPage({super.key});

  static const List<SurveyMandiriData> dummyDataSurvey = [
    SurveyMandiriData(
      id: 1,
      namaPemohon: 'Ani Suryani',
      nomorPernyataan: 'PM/2025/001',
      lokasiUsaha: 'Perumahan Harapan Jaya Blok B, Banjarmasin',
      tanggalPenilaian: '01 Maret 2025',
      statusPenilaian: 'Sudah Diproses',
      hasilPenilaian: 'Patuh',
      namaFile: 'survey_ani_suryani.pdf',
    ),
    SurveyMandiriData(
      id: 2,
      namaPemohon: 'Bambang Wijaya',
      nomorPernyataan: 'PM/2025/002',
      lokasiUsaha: 'Jl. Kenanga No. 5, Banjarbaru',
      tanggalPenilaian: '15 Maret 2025',
      statusPenilaian: 'Diproses',
      hasilPenilaian: 'Menunggu Verifikasi',
      namaFile: null,
    ),
    SurveyMandiriData(
      id: 3,
      namaPemohon: 'CV. Terang Benderang',
      nomorPernyataan: 'PM/2025/003',
      lokasiUsaha: 'Jl. Gatot Subroto No. 99, Banjarmasin',
      tanggalPenilaian: '20 April 2025',
      statusPenilaian: 'Sesuai',
      hasilPenilaian: 'Patuh dengan Catatan Minor',
      namaFile: 'survey_cv_terang.pdf',
    ),
  ];

  static const Color primaryColor = Color(0xFF17A2B8);
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
                'Survey Penilaian Mandiri',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
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
        itemCount: dummyDataSurvey.length,
        itemBuilder: (context, index) {
          final data = dummyDataSurvey[index];
          return _buildSurveyCard(context, data);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahSurveyMandiriPage(),
            ),
          );
        },
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildSurveyCard(BuildContext context, SurveyMandiriData data) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const CircleAvatar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.person_pin_circle_outlined),
        ),
        title: Text(
          data.namaPemohon,
          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(
          'No: ${data.nomorPernyataan}',
          style: const TextStyle(color: hintColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16),
                _buildDataRow(
                  Icons.location_on_outlined,
                  'Lokasi Usaha',
                  data.lokasiUsaha,
                ),
                _buildDataRow(
                  Icons.calendar_today_outlined,
                  'Tanggal Penilaian',
                  data.tanggalPenilaian,
                ),
                _buildDataRow(
                  Icons.rule_folder_outlined,
                  'Status Penilaian',
                  data.statusPenilaian,
                ),
                _buildDataRow(
                  Icons.check_circle_outline,
                  'Hasil Penilaian',
                  data.hasilPenilaian,
                ),
                _buildDataRow(
                  Icons.attach_file,
                  'File',
                  data.namaFile ?? 'Tidak Ada File',
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context, data),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, SurveyMandiriData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.orange),
          tooltip: 'Edit',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditSurveyMandiriPage(data: data),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Hapus',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: Text(
                    'Anda yakin ingin menghapus survey untuk "${data.namaPemohon}"?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                    TextButton(
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data dihapus (simulasi).'),
                          ),
                        );
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

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: hintColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$label: ',
                style: const TextStyle(color: hintColor, fontSize: 14),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
