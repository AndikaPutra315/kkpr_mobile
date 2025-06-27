import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// [PERUBAHAN 1]: Import model data dari halaman daftar
import 'data_kkpr_nonberusaha.dart';

// Halaman Form untuk Edit Data KKPR Non Berusaha
class EditDataKkprNonBerusahaPage extends StatefulWidget {
  // [PERUBAHAN 2]: Menerima data yang akan diedit
  final KkprData data;

  const EditDataKkprNonBerusahaPage({super.key, required this.data});

  @override
  State<EditDataKkprNonBerusahaPage> createState() =>
      _EditDataKkprNonBerusahaPageState();
}

class _EditDataKkprNonBerusahaPageState
    extends State<EditDataKkprNonBerusahaPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna
  static const Color primaryColor = Color(0xFF28A745);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _alamatTinggalController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;
  late TextEditingController _judulKegiatanController;
  late TextEditingController _alamatLokasiController;
  late TextEditingController _kelurahanController;
  late TextEditingController _kecamatanController;
  late TextEditingController _kabupatenController;
  late TextEditingController _provinsiController;
  late TextEditingController _luasTanahController;

  // Dropdown values
  String? _sektorKegiatan;
  String? _jenisKkpr;
  String? _jenisKkprDokumen;
  String? _namaFile;

  // Dropdown options
  final List<String> sektorKegiatanOptions = [
    'Perumahan',
    'Sosial',
    'Pendidikan',
    'Keagamaan',
    'Lainnya',
  ];
  final List<String> jenisKkprOptions = ['Kkpr Non Terintegrasi'];
  final List<String> jenisKkprDokumenOptions = ['RTRW', 'Lainnya'];

  // [PERUBAHAN 3]: Mengisi form dengan data yang ada saat halaman dibuka
  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data.namaPelakuUsaha);
    _alamatTinggalController = TextEditingController(
      text: widget.data.alamatKantor,
    );
    _teleponController = TextEditingController(text: widget.data.telepon);
    _emailController = TextEditingController(text: widget.data.email);
    _judulKegiatanController = TextEditingController(
      text: widget.data.judulKbli,
    );
    _alamatLokasiController = TextEditingController(
      text: widget.data.alamatUsaha,
    );
    _kelurahanController = TextEditingController(text: widget.data.kelurahan);
    _kecamatanController = TextEditingController(text: widget.data.kecamatan);
    _kabupatenController = TextEditingController(text: widget.data.kabupaten);
    _provinsiController = TextEditingController(text: widget.data.provinsi);
    _luasTanahController = TextEditingController(text: widget.data.luasTanah);

    _sektorKegiatan = widget.data.sektorUsaha;
    _jenisKkpr = widget.data.jenisKkpr;
    _jenisKkprDokumen = widget.data.jenisKkprDokumen;
    _namaFile = widget.data.namaFile;
  }

  @override
  void dispose() {
    // Selalu dispose semua controller
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
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
          content: Text('Data berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali setelah update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // [PERUBAHAN 4]: Judul diubah menjadi "Edit"
        title: const Text('Edit KKPR Non Berusaha'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                  // [PERUBAHAN 5]: Teks tombol diubah menjadi "Update"
                  label: const Text(
                    'UPDATE DATA',
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          prefixIcon: Icon(icon, color: hintColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: value,
        items:
            items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Wajib dipilih' : null,
      ),
    );
  }

  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.attach_file),
      label: Text(_namaFile ?? 'Upload Dokumen'),
      onPressed: _pickFile,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
