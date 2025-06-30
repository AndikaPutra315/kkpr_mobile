// lib/kkpr/jeniskkpr/berusaha/edit_berusaha.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Import yang dibutuhkan untuk koneksi API langsung
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import model data
import 'data_kkpr_berusaha.dart';

class EditDataKkprBerusahaPage extends StatefulWidget {
  final int kkprId;
  const EditDataKkprBerusahaPage({super.key, required this.kkprId});

  @override
  State<EditDataKkprBerusahaPage> createState() =>
      _EditDataKkprBerusahaPageState();
}

class _EditDataKkprBerusahaPageState extends State<EditDataKkprBerusahaPage> {
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
  // ==      PERBAIKAN LOGIKA ADA DI FUNGSI INI              ==
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
          Uri.parse('$baseUrl/tampilBerusaha/${widget.kkprId}'),
          headers: headers,
        ),
        http.get(Uri.parse('$baseUrl/sektor'), headers: headers),
      ]);

      if (responses[0].statusCode == 200) {
        // PERBAIKAN DI SINI:
        final responseBody = jsonDecode(responses[0].body);
        // Cek jika ada key 'data', gunakan itu. Jika tidak, gunakan seluruh object.
        final detailData = responseBody['data'] ?? responseBody;

        // Pastikan detailData adalah Map sebelum diproses
        if (detailData is Map<String, dynamic>) {
          final kkprData = KkprData.fromJson(detailData);

          List<Map<String, dynamic>> sektors = [];
          if (responses[1].statusCode == 200) {
            sektors = List<Map<String, dynamic>>.from(
              jsonDecode(responses[1].body)['data'],
            );
          }

          if (mounted) _populateForm(kkprData, sektors);
        } else {
          throw Exception('Format data dari API tidak dikenali.');
        }
      } else {
        throw Exception(
          'Gagal memuat detail data (Error: ${responses[0].statusCode})',
        );
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

  // Fungsi _populateForm tidak diubah
  void _populateForm(KkprData data, List<Map<String, dynamic>> sektors) {
    _controllers['nama_umk']?.text = data.namaPelakuUsaha;
    _controllers['npwp']?.text = data.npwp ?? '';
    _controllers['alamat_kantor']?.text = data.alamatKantor ?? '';
    _controllers['no_telp']?.text = data.telepon ?? '';
    _controllers['email']?.text = data.email ?? '';
    _controllers['status_pm']?.text = data.statusPenanamanModal ?? '';
    _controllers['kode_kbli']?.text = data.kodeKbli ?? '';
    _controllers['judul_kbli']?.text = data.judulKbli ?? '';
    _controllers['skala_usaha']?.text = data.skalaUsaha ?? '';
    _controllers['alamat_usaha']?.text = data.alamatUsaha ?? '';
    _controllers['kelurahan_usaha']?.text = data.kelurahan ?? '';
    _controllers['kecamatan_usaha']?.text = data.kecamatan ?? '';
    _controllers['kabkot_usaha']?.text = data.kabupaten ?? '';
    _controllers['provinsi_usaha']?.text = data.provinsi ?? '';
    _controllers['luas_tanah']?.text = data.luasTanah ?? '';

    setState(() {
      _sektorOptions = sektors;
      _selectedSektorId = data.idSektor?.toString();
      _selectedTingkatRisiko = data.tingkatRisiko;
      _selectedJenisDokKkpr = data.jenisKkprDokumen;
      _currentCsvFileName = data.namaFile;
    });
  }

  // Fungsi _submitForm tidak diubah
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      const String baseUrl = 'https://ti054b02api.agussbn.my.id/api';
      final url = Uri.parse('$baseUrl/updateBerusaha/${widget.kkprId}');
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

  static const Color primaryColor = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit KKPR Berusaha'),
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
          prefixIcon: const Icon(Icons.category),
          border: const OutlineInputBorder(
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
