import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'survey_mandiri.dart';

class EditSurveyMandiriPage extends StatefulWidget {
  final SurveyMandiriData data;

  const EditSurveyMandiriPage({super.key, required this.data});

  @override
  State<EditSurveyMandiriPage> createState() => _EditSurveyMandiriPageState();
}

class _EditSurveyMandiriPageState extends State<EditSurveyMandiriPage> {
  final _formKey = GlobalKey<FormState>();

  static const Color primaryColor = Color(0xFF17A2B8);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Colors.grey;

  String? _selectedPemohon;
  DateTime? _selectedDate;
  String? _statusPenilaian;
  String? _hasilPenilaian;
  String? _namaFile;

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

  @override
  void initState() {
    super.initState();
    _selectedPemohon = widget.data.namaPemohon;
    try {
      final parts = widget.data.tanggalPenilaian.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = _getMonthNumber(parts[1]);
        final year = int.parse(parts[2]);
        _selectedDate = DateTime(year, month, day);
      }
    } catch (e) {
      _selectedDate = null;
    }

    _statusPenilaian = widget.data.statusPenilaian;
    _hasilPenilaian = widget.data.hasilPenilaian;
    _namaFile = widget.data.namaFile;
  }

  int _getMonthNumber(String month) {
    switch (month.toLowerCase()) {
      case 'januari':
        return 1;
      case 'februari':
        return 2;
      case 'maret':
        return 3;
      case 'april':
        return 4;
      case 'mei':
        return 5;
      case 'juni':
        return 6;
      case 'juli':
        return 7;
      case 'agustus':
        return 8;
      case 'september':
        return 9;
      case 'oktober':
        return 10;
      case 'november':
        return 11;
      case 'desember':
        return 12;
      default:
        return 1;
    }
  }

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
          content: Text('Data survey berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Expanded(
          child: Text('Edit Survey Mandiri', overflow: TextOverflow.ellipsis),
        ),
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
                  icon: const Icon(Icons.save_as),
                  label: const Text('UPDATE SURVEY'),
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
        // [PERBAIKAN]: Menambahkan properti isExpanded
        isExpanded: true,
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
      label: Text(_namaFile ?? 'Ganti File (Opsional)'),
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
