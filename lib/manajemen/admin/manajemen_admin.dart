import 'package:flutter/material.dart';

// Import halaman tambah dan edit admin
import 'tambah_admin.dart';
import 'edit_admin.dart';

// Model data untuk Admin (tidak berubah)
class AdminData {
  final int id;
  final String namaUser;
  final String role;
  final String kabupatenKota;
  final String username;

  const AdminData({
    required this.id,
    required this.namaUser,
    required this.role,
    required this.kabupatenKota,
    required this.username,
  });
}

// Halaman utama untuk menampilkan daftar Admin
class ManajemenAdminPage extends StatelessWidget {
  const ManajemenAdminPage({super.key});

  // Data dummy (tidak berubah)
  static const List<AdminData> dummyAdminData = [
    AdminData(
      id: 1,
      namaUser: 'Ahmad Subardjo',
      role: 'admin',
      kabupatenKota: 'Kota Banjarmasin',
      username: 'admin_bjm',
    ),
    AdminData(
      id: 2,
      namaUser: 'Bunga Citra',
      role: 'admin',
      kabupatenKota: 'Banjarbaru',
      username: 'admin_bjb',
    ),
    AdminData(
      id: 3,
      namaUser: 'Candra Darusman',
      role: 'admin',
      kabupatenKota: 'Tanah Laut',
      username: 'admin_tala',
    ),
  ];

  // Styling
  static const Color primaryColor = Colors.deepPurple;
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
              'Manajemen Admin',
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
        itemCount: dummyAdminData.length,
        itemBuilder: (context, index) {
          final admin = dummyAdminData[index];
          return _buildAdminCard(context, admin);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahAdminPage()),
          );
        },
        label: const Text(
          'Tambah Admin',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, AdminData admin) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          // [PERBAIKAN]: Mengganti dengan ikon yang benar
          child: const Icon(Icons.admin_panel_settings_outlined),
        ),
        title: Text(
          admin.namaUser,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Wilayah: ${admin.kabupatenKota}",
          style: const TextStyle(color: hintColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(height: 1),
                _buildDataRow(Icons.account_circle, 'Username', admin.username),
                _buildDataRow(Icons.security, 'Role', admin.role),
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
                            builder: (context) => EditAdminPage(admin: admin),
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
                                'Anda yakin ingin menghapus admin "${admin.namaUser}"?',
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
                                          'Admin dihapus (simulasi).',
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

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Icon(icon, color: hintColor, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: hintColor)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
