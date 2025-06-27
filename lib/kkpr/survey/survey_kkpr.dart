import 'package:flutter/material.dart';

import 'tambah_data_survey_kkpr.dart';
import 'edit_survey_kkpr.dart';

class SurveyKkprData {
  final int id;
  final String namaPelakuUsaha;
  final String nomorKkpr;
  final String lokasiUsaha;
  final String tanggalPenilaian;
  final String statusPenilaian;
  final String hasilPenilaian;
  final String? namaFile;

  const SurveyKkprData({
    required this.id,
    required this.namaPelakuUsaha,
    required this.nomorKkpr,
    required this.lokasiUsaha,
    required this.tanggalPenilaian,
    required this.statusPenilaian,
    required this.hasilPenilaian,
    this.namaFile,
  });
}

class SurveyKkprPage extends StatelessWidget {
  const SurveyKkprPage({super.key});

  static const List<SurveyKkprData> dummyDataSurvey = [
    SurveyKkprData(
      id: 1,
      namaPelakuUsaha: 'PT. Maju Bersama',
      nomorKkpr: '101/KKPR/VI/2025',
      lokasiUsaha: 'Jl. Ahmad Yani Km. 6, Banjarmasin',
      tanggalPenilaian: '15 Juni 2025',
      statusPenilaian: 'Sesuai',
      hasilPenilaian: 'Rekomendasi Diterbitkan',
      namaFile: 'survey_maju_bersama.pdf',
    ),
    SurveyKkprData(
      id: 2,
      namaPelakuUsaha: 'CV. Karya Mandiri',
      nomorKkpr: '102/KKPR/VI/2025',
      lokasiUsaha: 'Kawasan Industri, Liang Anggang',
      tanggalPenilaian: '10 Juni 2025',
      statusPenilaian: 'Tidak Sesuai',
      // [PERBAIKAN]: Nilai ini disesuaikan agar cocok dengan pilihan di form edit
      hasilPenilaian: 'Perlu Perbaikan',
      namaFile: null,
    ),
    SurveyKkprData(
      id: 3,
      namaPelakuUsaha: 'Sentosa Propertindo',
      nomorKkpr: '103/KKPR/V/2025',
      lokasiUsaha: 'Jl. Sultan Adam, Banjarmasin',
      tanggalPenilaian: '28 Mei 2025',
      statusPenilaian: 'Sesuai dengan Catatan',
      hasilPenilaian: 'Rekomendasi Diterbitkan', // Contoh lain yang valid
      namaFile: 'survey_sentosa.pdf',
    ),
  ];

  static const Color primaryColor = Color(0xFF6F42C1);
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
            const Text(
              'Survey Penilaian KKPR',
              style: TextStyle(color: Colors.white),
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
              builder: (context) => const TambahSurveyKkprPage(),
            ),
          );
        },
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildSurveyCard(BuildContext context, SurveyKkprData data) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const CircleAvatar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.assignment_outlined),
        ),
        title: Text(
          data.namaPelakuUsaha,
          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(
          'No. KKPR: ${data.nomorKkpr}',
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

  Widget _buildActionButtons(BuildContext context, SurveyKkprData data) {
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
                builder: (context) => EditSurveyKkprPage(data: data),
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
                    'Anda yakin ingin menghapus survey untuk "${data.namaPelakuUsaha}"?',
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
