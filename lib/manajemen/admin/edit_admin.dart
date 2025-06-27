import 'package:flutter/material.dart';

// Import model data dari halaman daftar
import 'manajemen_admin.dart';

// Halaman Form untuk Edit Admin
class EditAdminPage extends StatefulWidget {
  // Menerima data admin yang akan diedit
  final AdminData admin;

  const EditAdminPage({super.key, required this.admin});

  @override
  State<EditAdminPage> createState() => _EditAdminPageState();
}

class _EditAdminPageState extends State<EditAdminPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna
  static const Color primaryColor = Colors.deepPurple;
  static const Color backgroundColor = Color(0xFFF5F7FA);

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _usernameController;
  final TextEditingController _passwordController =
      TextEditingController(); // Password bisa dikosongkan

  // Variabel state
  String? _selectedKabupaten;
  bool _isPasswordVisible = false;

  final List<String> kabupatenOptions = [
    'Balangan',
    'Banjar',
    'Barito Kuala',
    'Hulu Sungai Selatan',
    'Hulu Sungai Tengah',
    'Hulu Sungai Utara',
    'Kotabaru',
    'Tabalong',
    'Tanah Bumbu',
    'Tanah Laut',
    'Tapin',
    'Banjarmasin',
    'Banjarbaru',
  ];

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data yang sudah ada
    _namaController = TextEditingController(text: widget.admin.namaUser);
    _usernameController = TextEditingController(text: widget.admin.username);

    // [PERBAIKAN]: Cek apakah nilai dari data ada di dalam list pilihan
    // Ini akan mencegah error jika datanya tidak konsisten
    if (kabupatenOptions.contains(widget.admin.kabupatenKota)) {
      _selectedKabupaten = widget.admin.kabupatenKota;
    } else {
      // Jika tidak ada, biarkan null agar hintText 'Pilih...' yang muncul
      _selectedKabupaten = null;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data admin berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Admin', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    label: 'Nama User',
                    controller: _namaController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildStaticField(
                    label: 'Role',
                    value: 'Admin',
                    icon: Icons.security_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'Kabupaten/Kota',
                    kabupatenOptions,
                    _selectedKabupaten,
                    (value) => setState(() => _selectedKabupaten = value),
                    icon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Username',
                    controller: _usernameController,
                    icon: Icons.account_circle_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_as),
                        label: const Text('Update'),
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk form
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator:
          (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password Baru (Opsional)',
        hintText: 'Kosongkan jika tidak diubah',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed:
              () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      value: value,
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Wajib dipilih' : null,
    );
  }

  Widget _buildStaticField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
