// lib/kkpr/jeniskkpr/berusaha/data_kkpr_berusaha.dart

import 'package:flutter/material.dart';

// Import yang kita butuhkan: service untuk koneksi API, dan halaman untuk tambah/edit.
import '../../../services/api_service.dart';
import 'tambah_data_kkprberusaha.dart';
import 'edit_berusaha.dart';

// Model Data KkprData tidak diubah
class KkprData {
  final int id;
  final String namaPelakuUsaha;
  final String? npwp;
  final String? alamatKantor;
  final String? telepon;
  final String? email;
  final String? statusPenanamanModal;
  final String? kodeKbli;
  final String? judulKbli;
  final int? idSektor;
  final String? namaSektor;
  final String? skalaUsaha;
  final String? alamatUsaha;
  final String? kelurahan;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final String? luasTanah;
  final String? tingkatRisiko;
  final String? jenisKkprDokumen;
  final String? namaFile;

  KkprData({
    required this.id,
    required this.namaPelakuUsaha,
    this.npwp,
    this.alamatKantor,
    this.telepon,
    this.email,
    this.statusPenanamanModal,
    this.kodeKbli,
    this.judulKbli,
    this.idSektor,
    this.namaSektor,
    this.skalaUsaha,
    this.alamatUsaha,
    this.kelurahan,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.luasTanah,
    this.tingkatRisiko,
    this.jenisKkprDokumen,
    this.namaFile,
  });

  factory KkprData.fromJson(Map<String, dynamic> json) {
    return KkprData(
      id: int.parse(json['id_kkpr'].toString()),
      namaPelakuUsaha: json['nama_umk'] ?? 'Tanpa Nama',
      npwp: json['npwp'],
      alamatKantor: json['alamat_kantor'],
      telepon: json['no_telp'],
      email: json['email'],
      statusPenanamanModal: json['status_pm'],
      kodeKbli: json['kode_kbli'],
      judulKbli: json['judul_kbli'],
      idSektor:
          json['id_sektor'] != null
              ? int.tryParse(json['id_sektor'].toString())
              : null,
      namaSektor: json['nama_sektor'],
      skalaUsaha: json['skala_usaha'],
      alamatUsaha: json['alamat_usaha'],
      kelurahan: json['kelurahan_usaha'],
      kecamatan: json['kecamatan_usaha'],
      kabupaten: json['kabkot_usaha'],
      provinsi: json['provinsi_usaha'],
      luasTanah: json['luas_tanah'],
      tingkatRisiko: json['tingkat_risiko'],
      jenisKkprDokumen: json['jenis_dok_kkpr'],
      namaFile: json['file_csv'],
    );
  }
}

// Struktur utama StatefulWidget tidak diubah
class DataKkprBerusahaPage extends StatefulWidget {
  const DataKkprBerusahaPage({super.key});

  @override
  State<DataKkprBerusahaPage> createState() => _DataKkprBerusahaPageState();
}

class _DataKkprBerusahaPageState extends State<DataKkprBerusahaPage> {
  final ApiService _apiService = ApiService();
  late Future<List<KkprData>> _kkprDataFuture;

  static const Color primaryColor = Color(0xFF007BFF);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  // Semua fungsi seperti initState, _loadData, _deleteData, _showDeleteConfirmation
  // tidak diubah sama sekali.
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _kkprDataFuture = _apiService.getKkprBerusaha();
    });
  }

  void _deleteData(int id) async {
    try {
      await _apiService.deleteKkpr(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, KkprData data) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Anda yakin ingin menghapus data untuk "${data.namaPelakuUsaha}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteData(data.id);
              },
            ),
          ],
        );
      },
    );
  }

  // Build method dan FutureBuilder tidak diubah
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // PERUBAHAN 1: Menambahkan style pada title AppBar
        title: const Text(
          'Data KKPR Berusaha',
          style: TextStyle(color: Colors.white), // Mengubah warna teks judul
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Mengubah warna tombol back (panah)
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: FutureBuilder<List<KkprData>>(
          future: _kkprDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data tersedia.'));
            }

            final dataList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                return _buildKkprCard(context, data);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataKkprBerusahaPage(),
            ),
          );
          if (result == true) {
            _loadData();
          }
        },
        // PERUBAHAN 2: Menambahkan style pada label FloatingActionButton
        label: const Text(
          'Tambah Data',
          style: TextStyle(color: Colors.white), // Mengubah warna teks tombol
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ), // Mengubah warna ikon tombol
        backgroundColor: primaryColor,
      ),
    );
  }

  // ==========================================================
  // ==        PERBAIKAN TAMPILAN KARTU ADA DI SINI          ==
  // ==========================================================

  /// Widget untuk membangun setiap kartu data (card) dengan fungsi minimize/maximize
  Widget _buildKkprCard(BuildContext context, KkprData data) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior:
          Clip.antiAlias, // Penting agar warna ExpansionTile konsisten
      child: ExpansionTile(
        // Bagian yang selalu terlihat (Minimized)
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: const Icon(Icons.business, color: primaryColor),
        ),
        title: Text(
          data.namaPelakuUsaha,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          data.judulKbli ?? 'Klik untuk detail',
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        // Bagian yang muncul saat di-klik (Maximized)
        children: [
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataRow(Icons.badge_outlined, 'NPWP', data.npwp ?? '-'),
                _buildDataRow(
                  Icons.location_city_outlined,
                  'Alamat Kantor',
                  data.alamatKantor ?? '-',
                ),
                _buildDataRow(
                  Icons.phone_outlined,
                  'Telepon',
                  data.telepon ?? '-',
                ),
                _buildDataRow(
                  Icons.store_outlined,
                  'Alamat Usaha',
                  data.alamatUsaha ?? '-',
                ),
                _buildDataRow(
                  Icons.scale_outlined,
                  'Skala Usaha',
                  data.skalaUsaha ?? '-',
                ),

                // Tombol Aksi di bagian bawah
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditDataKkprBerusahaPage(kkprId: data.id),
                            ),
                          );
                          if (result == true) _loadData();
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Hapus'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                        ),
                        onPressed: () => _showDeleteConfirmation(context, data),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk membuat baris data (tidak ada perubahan)
  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 18),
          const SizedBox(width: 12),
          Text('$label: ', style: TextStyle(color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
