// lib/kkpr/jeniskkpr/nonberusaha/data_kkpr_nonberusaha.dart

import 'package:flutter/material.dart';
// LANGKAH 1: Tambahkan import yang dibutuhkan untuk koneksi API
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Hapus import ApiService karena tidak digunakan lagi di file ini
// import '../../../services/api_service.dart';
import 'tambah_data_kkprnonberusaha.dart';
import 'edit_nonberusaha.dart';

// Model Data untuk Non Berusaha (Tidak berubah)
class KkprNonBerusahaData {
  final int id;
  final String namaPemohon;
  final String? npwp;
  final String? alamatPemohon;
  final String? telepon;
  final String? email;
  final String? tujuanKegiatan;
  final String? alamatLokasi;
  final String? luasTanah;

  KkprNonBerusahaData({
    required this.id,
    required this.namaPemohon,
    this.npwp,
    this.alamatPemohon,
    this.telepon,
    this.email,
    this.tujuanKegiatan,
    this.alamatLokasi,
    this.luasTanah,
  });

  factory KkprNonBerusahaData.fromJson(Map<String, dynamic> json) {
    return KkprNonBerusahaData(
      id: int.parse(json['id_kkpr'].toString()),
      namaPemohon: json['nama_umk'] ?? 'Tanpa Nama',
      npwp: json['npwp'],
      alamatPemohon: json['alamat_kantor'],
      telepon: json['no_telp'],
      email: json['email'],
      tujuanKegiatan: json['judul_kbli'],
      alamatLokasi: json['alamat_usaha'],
      luasTanah: json['luas_tanah'],
    );
  }
}

class DataKkprNonBerusahaPage extends StatefulWidget {
  const DataKkprNonBerusahaPage({super.key});

  @override
  State<DataKkprNonBerusahaPage> createState() =>
      _DataKkprNonBerusahaPageState();
}

class _DataKkprNonBerusahaPageState extends State<DataKkprNonBerusahaPage> {
  // Variabel untuk menampung proses pengambilan data
  late Future<List<KkprNonBerusahaData>> _dataFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data saat halaman dibuka
    _loadData();
  }

  // Fungsi ini hanya untuk memicu FutureBuilder agar memuat ulang
  void _loadData() {
    setState(() {
      _dataFuture = _fetchAndParseData();
    });
  }

  // ==========================================================
  // ==      LOGIKA API DITEMPATKAN LANGSUNG DI SINI         ==
  // ==========================================================

  /// Fungsi untuk mengambil dan mem-parsing data langsung dari API
  Future<List<KkprNonBerusahaData>> _fetchAndParseData() async {
    const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
    final url = Uri.parse('$baseUrl/getDataKKPRNonBerusaha');

    // 1. Ambil data sesi (idAdmin) dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final idAdmin = prefs.getInt('id_admin');

    // 2. Buat header
    final headers = {
      'Accept': 'application/json',
      // Pastikan idAdmin ada sebelum ditambahkan ke header
      if (idAdmin != null && idAdmin != 0) 'idAdmin': idAdmin.toString(),
    };

    // 3. Lakukan request GET ke server
    final response = await http.get(url, headers: headers);

    // 4. Proses response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> listData = data['data'];
        // 5. Ubah JSON menjadi List objek KkprNonBerusahaData
        return listData
            .map((json) => KkprNonBerusahaData.fromJson(json))
            .toList();
      } else {
        throw Exception('API Error: ${data['message'] ?? 'Gagal memuat data'}');
      }
    } else {
      throw Exception(
        'Gagal terhubung ke server (Error: ${response.statusCode})',
      );
    }
  }

  /// Fungsi untuk menghapus data langsung ke API
  Future<void> _deleteDataDirectly(int id) async {
    const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
    final url = Uri.parse('$baseUrl/hapusKKPR/$id');
    final headers = {'Accept': 'application/json'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Gagal menghapus data.');
    }
  }

  // ==========================================================
  // ==             AKHIR DARI LOGIKA API LANGSUNG           ==
  // ==========================================================

  void _handleDelete(int id, String nama) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        /* ... Dialog Konfirmasi ... */
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus data untuk "$nama"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        // Panggil fungsi hapus yang ada di file ini, bukan dari service
        await _deleteDataDirectly(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Muat ulang data
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna
    const Color primaryColor = Color(0xFF28A745);
    const Color backgroundColor = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Data KKPR Non Berusaha'),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<KkprNonBerusahaData>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data tersedia.'));
          }

          final dataList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                return _buildKkprCard(context, data);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigasi ke halaman tambah tetap sama
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataKkprNonBerusahaPage(),
            ),
          );
          if (result == true) {
            _loadData();
          }
        },
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  // Widget untuk membangun setiap kartu data (tidak ada perubahan)
  Widget _buildKkprCard(BuildContext context, KkprNonBerusahaData data) {
    const Color primaryColor = Color(0xFF28A745);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: primaryColor,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                data.namaPemohon,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(data.tujuanKegiatan ?? 'Tanpa Tujuan'),
            ),
            const Divider(indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildDataRow(Icons.phone, 'Telepon', data.telepon ?? '-'),
                  _buildDataRow(Icons.email, 'Email', data.email ?? '-'),
                  _buildDataRow(
                    Icons.location_on,
                    'Alamat Lokasi',
                    data.alamatLokasi ?? '-',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.orange),
                  tooltip: 'Edit Data',
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataKkprNonBerusahaPage(kkprId: data.id)));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Hapus Data',
                  onPressed: () => _handleDelete(data.id, data.namaPemohon),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris data (tidak ada perubahan)
  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$label: ',
                style: const TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black,
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
