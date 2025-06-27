import 'package:flutter/material.dart';

// Halaman Form untuk Tambah Informasi Baru
class TambahInformasiPage extends StatefulWidget {
  const TambahInformasiPage({super.key});

  @override
  State<TambahInformasiPage> createState() => _TambahInformasiPageState();
}

class _TambahInformasiPageState extends State<TambahInformasiPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna
  static Color primaryColor = Colors.teal.shade700;
  static const Color backgroundColor = Color(0xFFF5F7FA);

  // Controllers
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _kontenController = TextEditingController();

  @override
  void dispose() {
    _judulController.dispose();
    _kontenController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi baru berhasil disimpan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah Informasi Baru', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Form Tambah Informasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 24),
                  _buildTextField(label: 'Judul Informasi', controller: _judulController, icon: Icons.title),
                  const SizedBox(height: 16),
                  _buildTextField(label: 'Isi Informasi', controller: _kontenController, icon: Icons.article_outlined, maxLines: 5),
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
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk form
  Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true, // Agar label sejajar dengan atas saat multiline
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}
