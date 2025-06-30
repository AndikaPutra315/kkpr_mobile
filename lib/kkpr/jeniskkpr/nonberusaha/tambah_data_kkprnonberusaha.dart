// lib/kkpr/jeniskkpr/nonberusaha/tambah_data_kkprnonberusaha.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// LANGKAH 1: Tambahkan import yang dibutuhkan
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TambahDataKkprNonBerusahaPage extends StatefulWidget {
  const TambahDataKkprNonBerusahaPage({super.key});

  @override
  State<TambahDataKkprNonBerusahaPage> createState() =>
      _TambahDataKkprNonBerusahaPageState();
}

class _TambahDataKkprNonBerusahaPageState
    extends State<TambahDataKkprNonBerusahaPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Struktur controllers dan state sama persis dengan form Berusaha
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
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  // ==========================================================
  // ==      LOGIKA API DITEMPATKAN LANGSUNG DI SINI         ==
  // ==========================================================

  /// Mengambil data Sektor langsung dari API
  Future<void> _fetchSektorData() async {
    try {
      final url = Uri.parse('https://ti054b02api.agussbn.my.id/api/sektor');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && mounted) {
          setState(() {
            _sektorOptions = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data sektor: $e')));
    } finally {
      if (mounted) setState(() => _isFetchingSektor = false);
    }
  }

  /// Mengirim data form langsung ke API
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

      const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
      final url = Uri.parse('$baseUrl/storeKKPRNonBerusaha');
      var request = http.MultipartRequest('POST', url);

      try {
        // 1. Ambil data sesi (token & id_user)
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final idUser = prefs.getInt('user_id');

        // 2. Buat header untuk multipart request
        request.headers['Accept'] = 'application/json';
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        // 3. Siapkan semua field dari form
        Map<String, String> formData = {};
        _controllers.forEach((key, controller) {
          formData[key] = controller.text;
        });
        formData['id_sektor'] = _selectedSektorId ?? '';
        formData['tingkat_risiko'] = _selectedTingkatRisiko ?? '';
        formData['jenis_dok_kkpr'] = _selectedJenisDokKkpr ?? '';
        formData['jenis_kkpr'] = 'non berusaha'; // Nilai tetap
        if (idUser != null) {
          formData['id_user'] = idUser.toString(); // Tambahkan id_user
        }

        request.fields.addAll(formData);

        // 4. Tambahkan file ke request
        request.files.add(
          await http.MultipartFile.fromPath('file_csv', _selectedCsvFile!.path),
        );

        // 5. Kirim request
        final response = await request.send();

        // 6. Handle response
        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data Non Berusaha berhasil disimpan'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          final respStr = await response.stream.bytesToString();
          throw Exception(
            jsonDecode(respStr)['message'] ?? 'Gagal menyimpan data',
          );
        }
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // ==========================================================
  // ==          AKHIR DARI LOGIKA API LANGSUNG            ==
  // ==========================================================

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null)
      setState(() => _selectedCsvFile = File(result.files.single.path!));
  }

  // Palet Warna Hijau
  static const Color primaryColor = Color(0xFF28A745);
  static const Color backgroundColor = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah KKPR Non Berusaha'),
        backgroundColor: primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Field form sama dengan Berusaha
            ..._controllers.entries.map(
              (e) => _buildTextField(
                e.key.replaceAll('_', ' ').toUpperCase(),
                e.value,
              ),
            ),
            _buildSektorDropdown(),
            _buildDropdown(
              'Tingkat Risiko',
              _risikoOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              _selectedTingkatRisiko,
              (val) => setState(() => _selectedTingkatRisiko = val),
            ),
            _buildDropdown(
              'Jenis Dokumen KKPR',
              _dokKkprOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              _selectedJenisDokKkpr,
              (val) => setState(() => _selectedJenisDokKkpr = val),
            ),
            _buildUploadButton(),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('SIMPAN DATA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Sama persis dengan form Berusaha) ---
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget _buildSektorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Sektor Usaha',
          prefixIcon:
              _isFetchingSektor
                  ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                  : const Icon(Icons.category),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        value: _selectedSektorId,
        hint: Text(_isFetchingSektor ? 'Memuat...' : 'Pilih Sektor'),
        items:
            _sektorOptions
                .map(
                  (s) => DropdownMenuItem<String>(
                    value: s['id_sektor'].toString(),
                    child: Text(s['nama_sektor']),
                  ),
                )
                .toList(),
        onChanged: (v) => setState(() => _selectedSektorId = v),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<DropdownMenuItem<String>> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: (v) => v == null ? 'Pilih salah satu' : null,
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.upload_file),
        title: Text(
          _selectedCsvFile?.path.split('/').last ?? 'Upload CSV (Wajib)',
          overflow: TextOverflow.ellipsis,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        onTap: _pickFile,
      ),
    );
  }
}
