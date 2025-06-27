import 'package:flutter/material.dart';

// Import halaman form tambah dan edit
import 'tambah_data_mandiri.dart';
import 'edit_mandiri.dart'; // [PERBAIKAN 1]: Import halaman edit diaktifkan

// [PERBAIKAN 2]: Tambahkan ID pada model data
class MandiriData {
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

  const MandiriData({
    required this.id, // ID ditambahkan
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

class PernyataanMandiri extends StatelessWidget {
  const PernyataanMandiri({super.key});

  // Data dummy diperbarui dengan ID
  static const List<MandiriData> dummyDataMandiri = [
    MandiriData(
      id: 1,
      namaPelakuUsaha: 'UD. Sumber Rejeki',
      npwp: '04.567.890.1-234.000',
      alamatKantor: 'Jl. Niaga No. 5, Jakarta Pusat',
      telepon: '081122334455',
      email: 'ud.sumberrejeki@email.com',
      statusPenanamanModal: 'PMDN',
      kodeKbli: '47111',
      judulKbli: 'Perdagangan Eceran Berbagai Macam Barang',
      sektorUsaha: 'Perdagangan',
      skalaUsaha: 'Usaha Mikro',
      alamatUsaha: 'Jl. Pasar Baru No. 10, Banjarmasin',
      kelurahan: 'Kertak Baru Ilir',
      kecamatan: 'Banjarmasin Tengah',
      kabupaten: 'Kota Banjarmasin',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '100',
      jenisKkpr: 'Kkpr Non Terintegrasi',
      jenisKkprDokumen: 'RTRW',
      namaFile: 'pernyataan_sumber_rejeki.csv',
    ),
    MandiriData(
      id: 2,
      namaPelakuUsaha: 'Greenfield Agribusiness',
      npwp: '05.678.901.2-345.000',
      alamatKantor: 'Jl. Agro No. 12, Bogor',
      telepon: '082233445566',
      email: 'contact@greenfield.farm',
      statusPenanamanModal: 'PMA',
      kodeKbli: '01271',
      judulKbli: 'Perkebunan Kopi',
      sektorUsaha: 'Pertanian',
      skalaUsaha: 'Usaha Menengah',
      alamatUsaha: 'Desa Pelaihari, Tanah Laut',
      kelurahan: 'Pelaihari',
      kecamatan: 'Pelaihari',
      kabupaten: 'Tanah Laut',
      provinsi: 'Kalimantan Selatan',
      luasTanah: '25000',
      jenisKkpr: 'Kkpr Terintegrasi',
      jenisKkprDokumen: 'Peraturan Pemerintah',
      namaFile: 'mandiri_greenfield.csv',
    ),
  ];

  // Styling
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
        // [PERUBAHAN 3]: Mengganti title dengan Row untuk memasukkan logo
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Pastikan path ini benar
              height: 35,
            ),
            const SizedBox(width: 10),
            // [PERUBAHAN 5]: Mengubah warna teks judul menjadi putih
            const Text(
              'Pernyataan Mandiri',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        // [PERUBAHAN 5]: Mengubah warna ikon panah kembali menjadi putih
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyDataMandiri.length,
        itemBuilder: (context, index) {
          final data = dummyDataMandiri[index];
          return _buildMandiriCard(context, data);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahDataMandiri()),
          );
        },
        // [PERUBAHAN 5]: Mengubah warna teks tombol menjadi putih
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildMandiriCard(BuildContext context, MandiriData data) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          data.namaPelakuUsaha,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Skala: ${data.skalaUsaha}',
          style: const TextStyle(color: hintColor, fontSize: 14),
        ),
        leading: const CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(Icons.person_pin_circle, color: Colors.white),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSectionTitle('Informasi Pelaku Usaha'),
                _buildDataRow(Icons.badge, 'NPWP', data.npwp),
                _buildDataRow(Icons.phone, 'Telepon', data.telepon),
                _buildDataRow(Icons.email, 'Email', data.email),
                const SizedBox(height: 12),
                _buildSectionTitle('Detail Usaha'),
                _buildDataRow(
                  Icons.business_center,
                  'Status Modal',
                  data.statusPenanamanModal,
                ),
                _buildDataRow(
                  Icons.qr_code,
                  'Kode & Judul KBLI',
                  '${data.kodeKbli} - ${data.judulKbli}',
                ),
                const SizedBox(height: 12),
                _buildSectionTitle('Lokasi & Informasi KKPR'),
                _buildDataRow(
                  Icons.store,
                  'Alamat Usaha',
                  '${data.alamatUsaha}, ${data.kecamatan}',
                ),
                _buildDataRow(
                  Icons.square_foot,
                  'Luas Tanah',
                  '${data.luasTanah} m²',
                ),
                _buildDataRow(Icons.file_copy, 'Jenis KKPR', data.jenisKkpr),
                _buildDataRow(
                  Icons.upload_file,
                  'File Terlampir',
                  data.namaFile,
                ),
                const SizedBox(height: 10),
                // [PENAMBAHAN 4]: Menambahkan tombol-tombol aksi
                _buildActionButtons(context, data),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // [PENAMBAHAN 5]: Widget baru untuk tombol Edit dan Hapus
  Widget _buildActionButtons(BuildContext context, MandiriData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.orange),
          tooltip: 'Edit Data',
          onPressed: () {
            // [PERBAIKAN 4]: Navigasi ke halaman edit diaktifkan
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditDataMandiriPage(data: data),
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
                  content: Text(
                    'Anda yakin ingin menghapus data untuk "${data.namaPelakuUsaha}"?',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
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
