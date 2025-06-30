import 'package:flutter/material.dart';

// Import paket-paket eksternal
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Import file-file lokal dengan path yang benar
import '../navigation/profil_drawer.dart';
import '../kkpr/jeniskkpr/berusaha/data_kkpr_berusaha.dart';
import '../kkpr/jeniskkpr/nonberusaha/data_kkpr_nonberusaha.dart';
import '../kkpr/pernyataan_mandiri/pernyataan_mandiri.dart';
import '../kkpr/survey/survey_kkpr.dart';
import '../kkpr/survey/survey_mandiri.dart';

// [PERBAIKAN 1]: Import ke halaman manajemen yang sebenarnya
import '../manajemen/admin/manajemen_admin.dart';
import '../manajemen/informasi/manajemen_informasi.dart';

// =========================================================================
// KELAS UTAMA: HOME PAGE (Cangkang Aplikasi)
// =========================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0: // Home
        break;
      case 1: // Data KKPR
        _showKkprOptions(context);
        break;
      case 2: // Pernyataan Mandiri
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PernyataanMandiri()),
        );
        break;
      case 3: // Survey Penilaian
        _showSurveyOptions(context);
        break;
      case 4: // Manajemen
        _showManajemenOptions(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 8),
            const Text('KKPR Kalsel', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF3A5795),
      ),
      drawer: const ProfilDrawer(),
      body: const AdminDashboardBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: const Color(0xFF3A5795),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Data KKPR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            activeIcon: Icon(Icons.edit_document),
            label: 'Pernyataan Mandiri',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll_outlined),
            activeIcon: Icon(Icons.poll),
            label: 'Survey Penilaian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            activeIcon: Icon(Icons.manage_accounts),
            label: 'Manajemen',
          ),
        ],
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showKkprOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.business_center_outlined),
              title: const Text('Data Berusaha'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataKkprBerusahaPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Data Non Berusaha'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataKkprNonBerusahaPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showSurveyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.file_copy_outlined),
              title: const Text('Survey KKPR'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SurveyKkprPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_edu_outlined),
              title: const Text('Survey Mandiri'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SurveyMandiriPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showManajemenOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Manajemen Admin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // [PERBAIKAN 2]: Navigasi sekarang mengarah ke class yang benar dari file yang di-import
                    builder: (context) => const ManajemenAdminPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Manajemen Informasi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // [PERBAIKAN 2]: Navigasi sekarang mengarah ke class yang benar dari file yang di-import
                    builder: (context) => const ManajemenInformasiPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// =========================================================================
// KELAS DASHBOARD BODY (Tidak ada perubahan di sini)
// =========================================================================
class AdminDashboardBody extends StatefulWidget {
  const AdminDashboardBody({super.key});

  @override
  State<AdminDashboardBody> createState() => _AdminDashboardBodyState();
}

class _AdminDashboardBodyState extends State<AdminDashboardBody> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _mapKey = GlobalKey();

  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardHeaderColor = Color(0xFFFFC107);
  static const Color primaryTextColor = Color(0xFF333333);
  static const Color accentColor = Color(0xFF007BFF);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMap() {
    if (_mapKey.currentContext != null) {
      Scrollable.ensureVisible(
        _mapKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDashboardHeader(),
            const SizedBox(height: 16),
            _buildChartCard(
              title: 'Statistik Data KKPR dan Pernyataan Mandiri',
              chart: _buildBarChart(),
            ),
            const SizedBox(height: 16),
            _buildCalendarCard(),
            const SizedBox(height: 16),
            _buildChartCard(
              title: 'Statistik Survey Penilaian KKPR dan Mandiri',
              chart: _buildLineChart(
                spots1: [
                  const FlSpot(0, 20),
                  const FlSpot(1, 22),
                  const FlSpot(2, 18),
                  const FlSpot(3, 25),
                ],
                spots2: [
                  const FlSpot(0, 10),
                  const FlSpot(1, 12),
                  const FlSpot(2, 9),
                  const FlSpot(3, 15),
                ],
                color1: Colors.red,
                color2: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              title: 'Statistik Tingkat Resiko KKPR',
              chart: _buildLineChart(
                spots1: [
                  const FlSpot(0, 5),
                  const FlSpot(1, 15),
                  const FlSpot(2, 10),
                  const FlSpot(3, 20),
                ],
                spots2: [],
                color1: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            _buildMapCard(key: _mapKey),
            const SizedBox(height: 24),
            const Text(
              'Copyright © SI KKPR KALSEL-SEKSI TATA RUANG | All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.map_outlined, size: 18),
          label: const Text('Lihat Peta'),
          onPressed: _scrollToMap,
          style: OutlinedButton.styleFrom(
            foregroundColor: accentColor,
            side: const BorderSide(color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: cardHeaderColor,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget chart}) {
    return _buildGenericCard(
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(aspectRatio: 1.8, child: chart),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return _buildGenericCard(
      title: 'Pilih Tanggal :',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: accentColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard({Key? key}) {
    return Card(
      key: key,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(-3.3285, 114.5908),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.red, 'Data KKPR'),
                const SizedBox(width: 24),
                _buildLegendItem(Colors.blue, 'Data Pernyataan Mandiri'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  BarChart _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 40,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(fontSize: 12);
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'KKPR';
                    break;
                  case 1:
                    text = 'Pernyataan\nMandiri';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style, textAlign: TextAlign.center),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 35, color: Colors.red, width: 40)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 18, color: Colors.blue, width: 40)],
          ),
        ],
        gridData: const FlGridData(show: false),
      ),
    );
  }

  LineChart _buildLineChart({
    required List<FlSpot> spots1,
    required List<FlSpot> spots2,
    required Color color1,
    Color? color2,
  }) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 30,
        lineBarsData: [
          LineChartBarData(
            spots: spots1,
            isCurved: true,
            color: color1,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          if (spots2.isNotEmpty && color2 != null)
            LineChartBarData(
              spots: spots2,
              isCurved: true,
              color: color2,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
        ],
      ),
    );
  }
}

// [PERBAIKAN 3]: SEMUA KODE PLACEHOLDER DI BAWAH INI TELAH DIHAPUS
