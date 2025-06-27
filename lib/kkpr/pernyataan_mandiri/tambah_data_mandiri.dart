import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'pernyataan_mandiri.dart';

class TambahDataMandiri extends StatefulWidget {
  // Menambahkan constructor const
  const TambahDataMandiri({super.key});

  @override
  _TambahDataMandiriState createState() => _TambahDataMandiriState();
}

class _TambahDataMandiriState extends State<TambahDataMandiri> {
  final _formKey = GlobalKey<FormState>();

  // Definisikan palet warna agar mudah diubah dan konsisten
  static const Color primaryColor = Color(0xFF007BFF); // Biru profesional
  static const Color backgroundColor = Color(0xFFF5F7FA); // Abu-abu terang
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  // Controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _alamatKantorController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kodeKbliController = TextEditingController();
  final TextEditingController _judulKbliController = TextEditingController();
  final TextEditingController _alamatUsahaController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _luasTanahController = TextEditingController();

  // Dropdown values
  String? _statusPenanamanModal;
  String? _sektorUsaha;
  String? _skalaUsaha;
  String? _jenisKkpr;
  String? _jenisKkprDokumen;
  String? _namaFile;

  // Dropdown options
  final List<String> statusPenanamanOptions = ['PMDN', 'PMA'];
  final List<String> sektorUsahaOptions = [
    'Jasa',
    'Perdagangan',
    'Industri',
    'Pertanian',
  ];
  final List<String> skalaUsahaOptions = [
    'Usaha Mikro',
    'Usaha Kecil',
    'Usaha Menengah',
    'Usaha Besar',
  ];
  final List<String> jenisKkprOptions = [
    'Kkpr Terintegrasi',
    'Kkpr Non Terintegrasi',
  ];
  final List<String> jenisKkprDokumenOptions = [
    'RTRW',
    'RDTR',
    'IKN',
    'Peraturan Pemerintah',
  ];

  @override
  void dispose() {
    // Selalu dispose semua controller untuk mencegah memory leak
    _namaController.dispose();
    _npwpController.dispose();
    _alamatKantorController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _kodeKbliController.dispose();
    _judulKbliController.dispose();
    _alamatUsahaController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _luasTanahController.dispose();
    super.dispose();
  }

  Future<void> _pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
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
          content: Text('Data Pernyataan Mandiri berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      // Pindah ke halaman berikutnya setelah sukses
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PernyataanMandiri()),
      );
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
        title: const Text('Pernyataan Mandiri'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  title: 'Informasi Pelaku Usaha',
                  children: [
                    _buildTextField(
                      'Nama Pelaku Usaha',
                      _namaController,
                      icon: Icons.person,
                    ),
                    _buildTextField('NPWP', _npwpController, icon: Icons.badge),
                    _buildTextField(
                      'Alamat Kantor',
                      _alamatKantorController,
                      icon: Icons.location_city,
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
                  title: 'Detail Usaha',
                  children: [
                    _buildDropdown(
                      'Status Penanaman Modal',
                      statusPenanamanOptions,
                      _statusPenanamanModal,
                      (value) => setState(() => _statusPenanamanModal = value),
                      icon: Icons.business_center,
                    ),
                    _buildTextField(
                      'Kode KBLI',
                      _kodeKbliController,
                      icon: Icons.qr_code,
                    ),
                    _buildTextField(
                      'Judul KBLI',
                      _judulKbliController,
                      icon: Icons.title,
                    ),
                    _buildDropdown(
                      'Sektor Usaha',
                      sektorUsahaOptions,
                      _sektorUsaha,
                      (value) => setState(() => _sektorUsaha = value),
                      icon: Icons.category,
                    ),
                    _buildDropdown(
                      'Skala Usaha',
                      skalaUsahaOptions,
                      _skalaUsaha,
                      (value) => setState(() => _skalaUsaha = value),
                      icon: Icons.analytics,
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: 'Lokasi Usaha & Tanah',
                  children: [
                    _buildTextField(
                      'Alamat Usaha',
                      _alamatUsahaController,
                      icon: Icons.store,
                    ),
                    _buildTextField(
                      'Kelurahan/Desa',
                      _kelurahanController,
                      icon: Icons.location_on,
                    ),
                    _buildTextField(
                      'Kecamatan',
                      _kecamatanController,
                      icon: Icons.location_on,
                    ),
                    _buildTextField(
                      'Kabupaten/Kota',
                      _kabupatenController,
                      icon: Icons.location_on,
                    ),
                    _buildTextField(
                      'Provinsi',
                      _provinsiController,
                      icon: Icons.location_on,
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
                // Tombol Simpan utama
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'SIMPAN & LANJUTKAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
      ),
    );
  }

  // "CSS" untuk Kartu Section
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

  // "CSS" untuk Text Field
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

  // "CSS" untuk Dropdown
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

  // Widget untuk tombol Upload
  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(
        _namaFile ?? 'Upload File CSV',
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: _pickCsvFile,
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
