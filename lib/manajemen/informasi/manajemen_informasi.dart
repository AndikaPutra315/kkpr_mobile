import 'package:flutter/material.dart';

// Import halaman tambah dan edit
import 'tambah_informasi.dart';
import 'edit_informasi.dart';

// Model data untuk Informasi (tidak berubah)
class InformasiData {
  final int id;
  final String judul;
  final String konten;

  const InformasiData({
    required this.id,
    required this.judul,
    required this.konten,
  });
}

// Halaman utama untuk menampilkan daftar Informasi
class ManajemenInformasiPage extends StatelessWidget {
  const ManajemenInformasiPage({super.key});

  // Data dummy (tidak berubah)
  static const List<InformasiData> dummyInformasiData = [
    InformasiData(
      id: 1,
      judul: 'Pengumuman Libur Nasional Idul Adha 2025',
      konten:
          'Diberitahukan kepada seluruh pegawai bahwa akan ada libur nasional dalam rangka Idul Adha...',
    ),
    InformasiData(
      id: 2,
      judul: 'Jadwal Pemeliharaan Sistem KKPR',
      konten:
          'Akan dilakukan pemeliharaan sistem pada hari Sabtu, 28 Juni 2025. Sistem mungkin tidak dapat diakses sementara.',
    ),
    InformasiData(
      id: 3,
      judul: 'Prosedur Pengajuan Permohonan Baru',
      konten:
          'Berikut adalah alur dan prosedur baru untuk pengajuan permohonan KKPR yang berlaku mulai 1 Juli 2025.',
    ),
  ];

  // Styling
  static Color primaryColor = Colors.teal.shade700;
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
              'Manajemen Informasi',
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
        itemCount: dummyInformasiData.length,
        itemBuilder: (context, index) {
          final info = dummyInformasiData[index];
          return _buildInfoCard(context, info);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahInformasiPage(),
            ),
          );
        },
        label: const Text(
          'Tambah Informasi',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  // [PERUBAHAN]: Widget _buildInfoCard dirombak menggunakan ExpansionTile
  Widget _buildInfoCard(BuildContext context, InformasiData info) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        // Bagian yang selalu terlihat (Header)
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.info_outline),
        ),
        title: Text(
          info.judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Klik untuk lihat detail...',
          style: TextStyle(fontSize: 12, color: hintColor),
        ),

        // Bagian yang muncul saat di-klik (Detail)
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 12),
                // Menampilkan konten informasi
                Text(
                  info.konten,
                  style: const TextStyle(color: textColor, height: 1.5),
                ),
                // Tombol-tombol aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.orange,
                      ),
                      label: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditInformasiPage(informasi: info),
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Hapus'),
                              content: Text(
                                'Anda yakin ingin menghapus informasi "${info.judul}"?',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Batal'),
                                  onPressed:
                                      () => Navigator.of(dialogContext).pop(),
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
                                        content: Text(
                                          'Informasi dihapus (simulasi).',
                                        ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
