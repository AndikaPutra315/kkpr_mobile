// lib/kkpr/jeniskkpr/berusaha/tambah_data_kkprberusaha.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/api_service.dart';

class TambahDataKkprBerusahaPage extends StatefulWidget {
  const TambahDataKkprBerusahaPage({super.key});

  @override
  State<TambahDataKkprBerusahaPage> createState() =>
      _TambahDataKkprBerusahaPageState();
}

class _TambahDataKkprBerusahaPageState
    extends State<TambahDataKkprBerusahaPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // Variabel dan fungsi debug sudah dihapus

  final Map<String, TextEditingController> _controllers = {
    'nama_umk': TextEditingController(),
    'npwp': TextEditingController(),
    'alamat_kantor': TextEditingController(),
    'no_telp': TextEditingController(),
    'email': TextEditingController(),
    'status_pm': TextEditingController(),
    'kode_kbli': TextEditingController(),
    'judul_kbli': TextEditingController(),
    'skala_usaha': TextEditingController(),
    'alamat_usaha': TextEditingController(),
    'kelurahan_usaha': TextEditingController(),
    'kecamatan_usaha': TextEditingController(),
    'kabkot_usaha': TextEditingController(),
    'provinsi_usaha': TextEditingController(),
    'luas_tanah': TextEditingController(),
  };

  String? _selectedSektorId;
  String? _selectedTingkatRisiko;
  String? _selectedJenisDokKkpr;
  File? _selectedCsvFile;

  List<Map<String, dynamic>> _sektorOptions = [];
  bool _isFetchingSektor = true;

  final List<String> _risikoOptions = [
    'rendah',
    'menengah rendah',
    'menengah tinggi',
    'tinggi',
  ];
  final List<String> _dokKkprOptions = [
    'persetujuan kkpr',
    'persetujuan kkpr otomatis',
    'konfirmasi kkpr',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSektorData();
    // Panggilan ke _loadDebugInfo() sudah dihapus
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchSektorData() async {
    try {
      final sektors = await _apiService.getSektors();
      if (mounted) {
        setState(() {
          _sektorOptions = sektors;
          _isFetchingSektor = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingSektor = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data sektor: $e')));
      }
    }
  }

  Future<void> _pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null)
      setState(() => _selectedCsvFile = File(result.files.single.path!));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCsvFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File CSV wajib diunggah'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      Map<String, String> formData = {};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text;
      });
      formData['id_sektor'] = _selectedSektorId ?? '';
      formData['tingkat_risiko'] = _selectedTingkatRisiko ?? '';
      formData['jenis_dok_kkpr'] = _selectedJenisDokKkpr ?? '';
      formData['jenis_kkpr'] = 'berusaha';
      try {
        await _apiService.addKkprBerusaha(
          formData,
          filePath: _selectedCsvFile!.path,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // Palet Warna
  static const Color primaryColor = Color(0xFF007BFF);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tambah KKPR Berusaha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionCard(
              title: 'Informasi Pelaku Usaha',
              children: [
                _buildTextField(
                  'Nama Pelaku Usaha',
                  _controllers['nama_umk']!,
                  icon: Icons.person,
                ),
                _buildTextField(
                  'NPWP',
                  _controllers['npwp']!,
                  icon: Icons.badge,
                ),
                _buildTextField(
                  'Alamat Kantor',
                  _controllers['alamat_kantor']!,
                  icon: Icons.location_city,
                ),
                _buildTextField(
                  'Telepon',
                  _controllers['no_telp']!,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  'Email',
                  _controllers['email']!,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            _buildSectionCard(
              title: 'Detail Usaha',
              children: [
                _buildTextField(
                  'Status Penanaman Modal',
                  _controllers['status_pm']!,
                  icon: Icons.business_center,
                ),
                _buildTextField(
                  'Kode KBLI',
                  _controllers['kode_kbli']!,
                  icon: Icons.qr_code,
                ),
                _buildTextField(
                  'Judul KBLI',
                  _controllers['judul_kbli']!,
                  icon: Icons.title,
                ),
                _buildTextField(
                  'Skala Usaha',
                  _controllers['skala_usaha']!,
                  icon: Icons.analytics,
                ),
                _buildSektorDropdown(),
                _buildDropdown(
                  'Tingkat Risiko',
                  _risikoOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  _selectedTingkatRisiko,
                  (val) => setState(() => _selectedTingkatRisiko = val),
                  icon: Icons.shield_outlined,
                ),
              ],
            ),
            _buildSectionCard(
              title: 'Lokasi & Informasi Lainnya',
              children: [
                _buildTextField(
                  'Alamat Usaha',
                  _controllers['alamat_usaha']!,
                  icon: Icons.store,
                ),
                _buildTextField(
                  'Kelurahan/Desa',
                  _controllers['kelurahan_usaha']!,
                  icon: Icons.map,
                ),
                _buildTextField(
                  'Kecamatan',
                  _controllers['kecamatan_usaha']!,
                  icon: Icons.map,
                ),
                _buildTextField(
                  'Kabupaten/Kota',
                  _controllers['kabkot_usaha']!,
                  icon: Icons.map,
                ),
                _buildTextField(
                  'Provinsi',
                  _controllers['provinsi_usaha']!,
                  icon: Icons.map,
                ),
                _buildTextField(
                  'Luas Tanah (m²)',
                  _controllers['luas_tanah']!,
                  icon: Icons.square_foot,
                  keyboardType: TextInputType.number,
                ),
                _buildDropdown(
                  'Jenis Dokumen KKPR',
                  _dokKkprOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  _selectedJenisDokKkpr,
                  (val) => setState(() => _selectedJenisDokKkpr = val),
                  icon: Icons.source,
                ),
                const SizedBox(height: 8),
                _buildUploadButton(),
              ],
            ),

            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'SIMPAN DATA',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

            // Panel Debug sudah dihapus dari sini
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
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
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Field ini wajib diisi'
                    : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<DropdownMenuItem<String>> items,
    String? value,
    ValueChanged<String?> onChanged, {
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
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
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Pilih salah satu' : null,
      ),
    );
  }

  Widget _buildSektorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Sektor Usaha',
          prefixIcon:
              _isFetchingSektor
                  ? const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  )
                  : const Icon(Icons.category, color: hintColor),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        value: _selectedSektorId,
        hint: Text(
          _isFetchingSektor ? 'Memuat...' : 'Pilih Sektor',
          style: const TextStyle(color: hintColor),
        ),
        items:
            _sektorOptions.map((sektor) {
              return DropdownMenuItem<String>(
                value: sektor['id_sektor'].toString(),
                child: Text(sektor['nama_sektor']),
              );
            }).toList(),
        onChanged: (value) => setState(() => _selectedSektorId = value),
        validator: (value) => value == null ? 'Pilih salah satu' : null,
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.upload_file, color: primaryColor),
        label: Text(
          _selectedCsvFile?.path.split('/').last ?? 'Pilih File CSV (Wajib)',
          style: TextStyle(
            color: _selectedCsvFile != null ? textColor : hintColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: _pickCsvFile,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
