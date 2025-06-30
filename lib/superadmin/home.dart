import 'package:flutter/material.dart';

// Import paket-paket eksternal
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Import file-file halaman Anda
import '../navigation/profil_drawer.dart';
import '../kkpr/jeniskkpr/berusaha/data_kkpr_berusaha.dart';
import '../kkpr/jeniskkpr/nonberusaha/data_kkpr_nonberusaha.dart';
import '../kkpr/pernyataan_mandiri/pernyataan_mandiri.dart';
import '../kkpr/survey/surveykkpr/survey_kkpr.dart';
import '../kkpr/survey/mandiri/survey_mandiri.dart';
import '../manajemen/admin/manajemen_admin.dart';
import '../manajemen/informasi/manajemen_informasi.dart';

// =========================================================================
// KELAS UTAMA: HOME PAGE (Cangkang Aplikasi)
// =========================================================================
// HomePage sekarang berfungsi sebagai "cangkang" yang memegang AppBar,
// Drawer, dan BottomNavigationBar yang persisten.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State untuk melacak indeks/tab yang sedang aktif.
  int _selectedIndex = 0;

  // INI ADALAH BAGIAN PALING PENTING.
  // Daftar ini berisi WIDGET KONTEN (BUKAN HALAMAN DENGAN SCAFFOLD)
  // yang akan ditampilkan di body sesuai tab yang dipilih.
  static final List<Widget> _pages = <Widget>[
    // Indeks 0: Halaman utama/dashboard.
    const AdminDashboardBody(),

    // Indeks 1: Kontainer untuk tab Data KKPR.
    const DataKkprPageContainer(),

    // Indeks 2: Halaman Pernyataan Mandiri.
    // PASTIKAN widget `PernyataanMandiri` TIDAK memiliki Scaffold-nya sendiri.
    PernyataanMandiri(),

    // Indeks 3: Kontainer untuk tab Survey.
    const SurveyPageContainer(),

    // Indeks 4: Kontainer untuk tab Manajemen.
    const ManajemenPageContainer(),
  ];

  // Fungsi ini hanya bertugas mengubah state indeks ketika item bar diklik.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dan Drawer ini akan selalu sama untuk semua halaman.
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

      // Body akan berganti-ganti sesuai dengan `_selectedIndex`.
      body: _pages.elementAt(_selectedIndex),

      // BottomNavigationBar ini juga akan selalu ada.
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// =========================================================================
// WIDGET-WIDGET KONTAINER UNTUK SETIAP SEKSI DENGAN SUB-MENU (TAB)
// =========================================================================
// Widget ini hanya untuk seksi "Data KKPR". Ia tidak punya Scaffold.
class DataKkprPageContainer extends StatelessWidget {
  const DataKkprPageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF3A5795),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF3A5795),
              tabs: [
                Tab(text: 'Data Berusaha'),
                Tab(text: 'Data Non Berusaha'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // PASTIKAN `DataKkprBerusahaPage` dan `DataKkprNonBerusahaPage`
                // juga TIDAK memiliki Scaffold.
                DataKkprBerusahaPage(),
                DataKkprNonBerusahaPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ini hanya untuk seksi "Survey". Ia tidak punya Scaffold.
class SurveyPageContainer extends StatelessWidget {
  const SurveyPageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF3A5795),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF3A5795),
              tabs: [Tab(text: 'Survey KKPR'), Tab(text: 'Survey Mandiri')],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [SurveyKkprPage(), SurveyMandiriPage()],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ini hanya untuk seksi "Manajemen". Ia tidak punya Scaffold.
class ManajemenPageContainer extends StatelessWidget {
  const ManajemenPageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF3A5795),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF3A5795),
              tabs: [
                Tab(text: 'Manajemen Admin'),
                Tab(text: 'Manajemen Informasi'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [ManajemenAdminPage(), ManajemenInformasiPage()],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// KELAS DASHBOARD BODY (Tidak ada perubahan, sudah benar)
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
