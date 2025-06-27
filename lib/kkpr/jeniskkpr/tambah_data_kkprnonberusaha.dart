import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Halaman Form untuk Tambah Data KKPR Non Berusaha
class TambahDataKkprNonBerusahaPage extends StatefulWidget {
  const TambahDataKkprNonBerusahaPage({super.key});

  @override
  State<TambahDataKkprNonBerusahaPage> createState() =>
      _TambahDataKkprNonBerusahaPageState();
}

class _TambahDataKkprNonBerusahaPageState
    extends State<TambahDataKkprNonBerusahaPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna diubah menjadi hijau untuk membedakan
  static const Color primaryColor = Color(0xFF28A745);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  // Controllers disesuaikan untuk kasus non-usaha
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatTinggalController =
      TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _judulKegiatanController =
      TextEditingController();
  final TextEditingController _alamatLokasiController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _luasTanahController = TextEditingController();

  // Dropdown values disederhanakan
  String? _sektorKegiatan;
  String? _jenisKkpr;
  String? _jenisKkprDokumen;
  String? _namaFile;

  // Dropdown options disederhanakan
  final List<String> sektorKegiatanOptions = [
    'Perumahan',
    'Sosial',
    'Pendidikan',
    'Keagamaan',
    'Lainnya',
  ];
  final List<String> jenisKkprOptions = ['Kkpr Non Terintegrasi'];
  final List<String> jenisKkprDokumenOptions = ['RTRW', 'Lainnya'];

  @override
  void dispose() {
    // Dispose semua controller yang ada
    _namaController.dispose();
    _alamatTinggalController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _judulKegiatanController.dispose();
    _alamatLokasiController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _luasTanahController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _namaFile = result.files.single.name;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi semua data yang wajib diisi'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah KKPR Non Berusaha'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Informasi Pemohon',
                children: [
                  _buildTextField(
                    'Nama Pemohon',
                    _namaController,
                    icon: Icons.person,
                  ),
                  _buildTextField(
                    'Alamat Tinggal',
                    _alamatTinggalController,
                    icon: Icons.home,
                  ),
                  _buildTextField(
                    'Telepon',
                    _teleponController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    'Email',
                    _emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'Detail Kegiatan',
                children: [
                  _buildTextField(
                    'Judul/Tujuan Kegiatan',
                    _judulKegiatanController,
                    icon: Icons.title,
                  ),
                  _buildDropdown(
                    'Sektor Kegiatan',
                    sektorKegiatanOptions,
                    _sektorKegiatan,
                    (value) => setState(() => _sektorKegiatan = value),
                    icon: Icons.category,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'Lokasi Kegiatan & Tanah',
                children: [
                  _buildTextField(
                    'Alamat Lokasi Kegiatan',
                    _alamatLokasiController,
                    icon: Icons.location_on,
                  ),
                  _buildTextField(
                    'Kelurahan/Desa',
                    _kelurahanController,
                    icon: Icons.map,
                  ),
                  _buildTextField(
                    'Kecamatan',
                    _kecamatanController,
                    icon: Icons.map,
                  ),
                  _buildTextField(
                    'Kabupaten/Kota',
                    _kabupatenController,
                    icon: Icons.map,
                  ),
                  _buildTextField(
                    'Provinsi',
                    _provinsiController,
                    icon: Icons.map,
                  ),
                  _buildTextField(
                    'Luas Tanah (m²)',
                    _luasTanahController,
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'Informasi KKPR & Dokumen',
                children: [
                  _buildDropdown(
                    'Jenis KKPR',
                    jenisKkprOptions,
                    _jenisKkpr,
                    (value) => setState(() => _jenisKkpr = value),
                    icon: Icons.file_copy,
                  ),
                  _buildDropdown(
                    'Jenis KKPR berdasarkan Dokumen',
                    jenisKkprDokumenOptions,
                    _jenisKkprDokumen,
                    (value) => setState(() => _jenisKkprDokumen = value),
                    icon: Icons.source,
                  ),
                  const SizedBox(height: 8),
                  _buildUploadButton(),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'SIMPAN DATA',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget-widget helper
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: hintColor),
          prefixIcon: Icon(icon, color: hintColor),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: hintColor),
          prefixIcon: Icon(icon, color: hintColor),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
        value: value,
        items:
            items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(color: textColor)),
                  ),
                )
                .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Pilih salah satu' : null,
      ),
    );
  }

  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(
        _namaFile ?? 'Upload Dokumen',
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: _pickFile,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
