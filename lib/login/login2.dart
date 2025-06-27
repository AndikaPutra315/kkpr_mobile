import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil nilai dari text field
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Kunci untuk form validation (opsional, tapi praktik yang baik)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Selalu dispose controller saat widget tidak lagi digunakan
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Contoh logika login sederhana seperti di JavaScript Anda
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Ganti dengan logika otentikasi Anda yang sebenarnya (misalnya, via API)
      if (username == "admin" && password == "password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil! Mengarahkan...")),
        );
        // Navigasi ke halaman dashboard
        // Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username atau Password salah!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menumpuk widget (background di belakang, form di depan)
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Latar Belakang Grid Gambar
          _buildBackgroundGrid(),

          // 2. Konten Login
          Center(
            // SingleChildScrollView agar form bisa di-scroll saat keyboard muncul
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
      // 3. Footer di bagian bawah
      bottomNavigationBar: _buildFooter(),
    );
  }

  /// Widget untuk Latar Belakang Grid
  Widget _buildBackgroundGrid() {
    // Ganti dengan path gambar Anda di folder assets
    final imagePaths = [
      'assets/images/image1.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
      'assets/images/image4.png',
    ];

    return GridView.builder(
      // Menonaktifkan scroll pada grid agar tidak konflik dengan scroll utama
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        childAspectRatio: 0.8, // Rasio aspek gambar
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Image.asset(
          imagePaths[index],
          fit: BoxFit.cover, // Agar gambar memenuhi area grid
        );
      },
    );
  }

  /// Widget untuk Form Login
  Widget _buildLoginForm() {
    return Card(
      // Card memberikan efek shadow (elevasi) dan sudut melengkung
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Untuk menyembunyikan input password
                decoration: InputDecoration(
                  hintText: 'Password...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A5795), // Warna biru tua
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk Footer
  Widget _buildFooter() {
    return Container(
      color: Colors.white, // Latar belakang putih untuk footer
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("KKPR", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("SISTEM INFORMASI KESESUAIAN"),
              Text("KEGIATAN PEMANFAATAN RUANG"),
            ],
          ),
          // Ganti 'assets/images/logo.png' dengan path logo Anda
          Image.asset('assets/images/logo.png', height: 40),
        ],
      ),
    );
  }
}