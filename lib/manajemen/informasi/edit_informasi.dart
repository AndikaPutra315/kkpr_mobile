import 'package:flutter/material.dart';

// Import model data dari halaman daftar
import 'manajemen_informasi.dart';

// Halaman Form untuk Edit Informasi
class EditInformasiPage extends StatefulWidget {
  // Menerima data yang akan diedit
  final InformasiData informasi;
  
  const EditInformasiPage({super.key, required this.informasi});

  @override
  State<EditInformasiPage> createState() => _EditInformasiPageState();
}

class _EditInformasiPageState extends State<EditInformasiPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna
  static Color primaryColor = Colors.teal.shade700;
  static const Color backgroundColor = Color(0xFFF5F7FA);

  // Controllers
  late TextEditingController _judulController;
  late TextEditingController _kontenController;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data yang sudah ada
    _judulController = TextEditingController(text: widget.informasi.judul);
    _kontenController = TextEditingController(text: widget.informasi.konten);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _kontenController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi berhasil diperbarui!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Informasi', style: TextStyle(color: Colors.white)),
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
                  Text('Form Edit Informasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
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
                        icon: const Icon(Icons.save_as),
                        label: const Text('Update'),
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
        alignLabelWithHint: true,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Wajib diisi' : null,
    );
  }
}
