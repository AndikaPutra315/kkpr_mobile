import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Halaman Form untuk Tambah Data Survey Penilaian Mandiri
class TambahSurveyMandiriPage extends StatefulWidget {
  const TambahSurveyMandiriPage({super.key});

  @override
  State<TambahSurveyMandiriPage> createState() =>
      _TambahSurveyMandiriPageState();
}

class _TambahSurveyMandiriPageState extends State<TambahSurveyMandiriPage> {
  final _formKey = GlobalKey<FormState>();

  // Palet Warna (konsisten dengan halaman daftar survey mandiri)
  static const Color primaryColor = Color(0xFF17A2B8); // Biru kehijauan
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  // Variabel state
  String? _selectedPemohon;
  DateTime? _selectedDate;
  String? _statusPenilaian;
  String? _hasilPenilaian;
  String? _namaFile;

  // Data Dummy untuk dropdown (nantinya ini akan diambil dari API)
  final List<String> pemohonOptions = [
    'Ani Suryani',
    'Bambang Wijaya',
    'CV. Terang Benderang',
  ];
  final List<String> statusPenilaianOptions = [
    'Diproses',
    'Sudah Diproses',
    'Sesuai',
    'Tidak Sesuai',
  ];
  final List<String> hasilPenilaianOptions = [
    'Patuh',
    'Tidak Patuh',
    'Patuh dengan Catatan Minor',
    'Menunggu Verifikasi',
  ];

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi untuk memilih file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _namaFile = result.files.single.name;
      });
    }
  }

  // Fungsi untuk submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data ke API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data survey berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah simpan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tambah Survey Mandiri'),
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
                title: 'Detail Survey',
                children: [
                  _buildDropdown(
                    'Pilih Pemohon',
                    pemohonOptions,
                    _selectedPemohon,
                    (value) => setState(() => _selectedPemohon = value),
                    icon: Icons.person_search,
                  ),
                  _buildDatePickerField(context),
                  _buildDropdown(
                    'Status Penilaian',
                    statusPenilaianOptions,
                    _statusPenilaian,
                    (value) => setState(() => _statusPenilaian = value),
                    icon: Icons.rule_folder_outlined,
                  ),
                  _buildDropdown(
                    'Hasil Penilaian',
                    hasilPenilaianOptions,
                    _hasilPenilaian,
                    (value) => setState(() => _hasilPenilaian = value),
                    icon: Icons.check_circle_outline,
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
                  label: const Text('SIMPAN SURVEY'),
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

  // Widget-widget helper untuk membangun form
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

  // [PERBAIKAN]: Fungsi _buildDropdown diperbarui
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
        isExpanded: true, // Membuat dropdown menjadi fleksibel
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: hintColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
      text:
          _selectedDate == null
              ? ''
              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: 'Tanggal Penilaian',
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: hintColor,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => _selectedDate == null ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.attach_file),
      label: Text(_namaFile ?? 'Upload File Hasil Survey'),
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
