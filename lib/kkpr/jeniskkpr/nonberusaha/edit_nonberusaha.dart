// lib/kkpr/jeniskkpr/nonberusaha/edit_nonberusaha.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Import yang dibutuhkan untuk koneksi API langsung
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Pastikan import model data sudah benar
import 'data_kkpr_nonberusaha.dart';

class EditDataKkprNonBerusahaPage extends StatefulWidget {
  final int kkprId;
  const EditDataKkprNonBerusahaPage({super.key, required this.kkprId});

  @override
  State<EditDataKkprNonBerusahaPage> createState() =>
      _EditDataKkprNonBerusahaPageState();
}

class _EditDataKkprNonBerusahaPageState
    extends State<EditDataKkprNonBerusahaPage> {
  final _formKey = GlobalKey<FormState>();

  // State untuk loading
  bool _isSaving = false;
  bool _isFetchingData = true;

  // Controllers untuk setiap field teks
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

  // State untuk Dropdown dan File
  String? _selectedSektorId;
  String? _selectedTingkatRisiko;
  String? _selectedJenisDokKkpr;
  File? _selectedCsvFile;
  String? _currentCsvFileName;

  List<Map<String, dynamic>> _sektorOptions = [];
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
    _loadInitialData();
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  // ==========================================================
  // ==      LOGIKA API DITEMPATKAN LANGSUNG DI SINI         ==
  // ==========================================================

  Future<void> _loadInitialData() async {
    const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final headers = {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final responses = await Future.wait([
        http.get(
          Uri.parse('$baseUrl/tampilNonBerusaha/${widget.kkprId}'),
          headers: headers,
        ),
        http.get(Uri.parse('$baseUrl/sektor'), headers: headers),
      ]);

      if (responses[0].statusCode == 200) {
        final detailData = jsonDecode(responses[0].body)['data'];
        final kkprData = KkprNonBerusahaData.fromJson(detailData);

        List<Map<String, dynamic>> sektors = [];
        if (responses[1].statusCode == 200) {
          sektors = List<Map<String, dynamic>>.from(
            jsonDecode(responses[1].body)['data'],
          );
        }

        if (mounted) _populateForm(kkprData, sektors);
      } else {
        throw Exception('Gagal memuat detail data');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isFetchingData = false);
    }
  }

  void _populateForm(
    KkprNonBerusahaData data,
    List<Map<String, dynamic>> sektors,
  ) {
    _controllers['nama_umk']?.text = data.namaPemohon;
    _controllers['npwp']?.text = data.npwp ?? '';
    _controllers['alamat_kantor']?.text = data.alamatPemohon ?? '';
    _controllers['no_telp']?.text = data.telepon ?? '';
    _controllers['email']?.text = data.email ?? '';
    _controllers['judul_kbli']?.text = data.tujuanKegiatan ?? '';
    _controllers['alamat_usaha']?.text = data.alamatLokasi ?? '';
    _controllers['luas_tanah']?.text = data.luasTanah ?? '';

    // Anda bisa mengisi field lain sesuai kebutuhan
    // ...

    setState(() {
      _sektorOptions = sektors;
      // Jika Anda memiliki 'id_sektor' di model KkprNonBerusahaData, aktifkan baris ini
      // _selectedSektorId = data.idSektor?.toString();
      // _currentCsvFileName = data.namaFile;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
      final url = Uri.parse('$baseUrl/updateNonBerusaha/${widget.kkprId}');
      var request = http.MultipartRequest('POST', url);

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        request.headers['Accept'] = 'application/json';
        if (token != null) request.headers['Authorization'] = 'Bearer $token';

        Map<String, String> formData = {};
        _controllers.forEach((key, controller) {
          formData[key] = controller.text;
        });
        formData['id_sektor'] = _selectedSektorId ?? '';
        formData['tingkat_risiko'] = _selectedTingkatRisiko ?? '';
        formData['jenis_dok_kkpr'] = _selectedJenisDokKkpr ?? '';
        formData['_method'] = 'PUT';

        request.fields.addAll(formData);

        if (_selectedCsvFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file_csv',
              _selectedCsvFile!.path,
            ),
          );
        }

        final response = await request.send();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil diupdate'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          final respStr = await response.stream.bytesToString();
          throw Exception(
            jsonDecode(respStr)['message'] ?? 'Gagal mengupdate data',
          );
        }
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengupdate: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
      } finally {
        if (mounted) setState(() => _isSaving = false);
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

  static const Color primaryColor = Color(0xFF28A745);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit KKPR Non Berusaha'),
        backgroundColor: primaryColor,
      ),
      body:
          _isFetchingData
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
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
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      _selectedTingkatRisiko,
                      (val) => setState(() => _selectedTingkatRisiko = val),
                    ),
                    _buildDropdown(
                      'Jenis Dokumen KKPR',
                      _dokKkprOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      _selectedJenisDokKkpr,
                      (val) => setState(() => _selectedJenisDokKkpr = val),
                    ),
                    _buildUploadButton(),
                    const SizedBox(height: 24),
                    _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('UPDATE DATA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                  ],
                ),
              ),
    );
  }

  // --- WIDGET HELPER ---
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

  // PERBAIKAN DI SINI: _isFetchingSektor sudah tidak ada, kita bisa sederhanakan
  Widget _buildSektorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Sektor Usaha',
          prefixIcon: Icon(Icons.category), // Langsung tampilkan ikon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        value: _selectedSektorId,
        hint: const Text('Pilih Sektor'),
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
        // validator: (v) => v == null ? 'Pilih salah satu' : null, // Opsional jika sektor boleh kosong
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
          _selectedCsvFile?.path.split('/').last ??
              _currentCsvFileName ??
              'Upload CSV (kosongkan jika tidak diubah)',
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
