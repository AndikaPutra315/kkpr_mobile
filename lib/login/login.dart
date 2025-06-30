// lib/login/login.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import service API Anda
import '../services/api_service.dart';

// Import halaman tujuan setelah login
import '../superadmin/home.dart'; // Halaman untuk Superadmin
// import '../admin/home.dart'; // Buat halaman ini untuk Admin

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Buat instance dari ApiService
  final ApiService _apiService = ApiService();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk handle proses login
  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // PANGGIL FUNGSI LOGIN DARI APISERVICE
      final userData = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      // Jika login berhasil, navigasi ke halaman yang sesuai
      if (mounted) {
        _navigateToNextPage(userData['role_name']);
      }
    } catch (e) {
      // Jika terjadi error dari ApiService, tampilkan pesan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToNextPage(String role) {
    if (!mounted) return;

    if (role == 'superadmin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (role == 'admin') {
      // Ganti dengan halaman dashboard Admin Anda
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const AdminHomePage()),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Admin Berhasil! (Halaman belum dibuat)"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Role tidak dikenali!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A5795), Color(0xFF2C3E50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==========================================================
                    // ==                PERUBAHAN DI BAGIAN INI               ==
                    // ==========================================================
                    // Ikon gembok diganti kembali menjadi logo gambar Anda.
                    Image.asset(
                      'assets/images/logo.png', // Pastikan path ini benar
                      height: 100,
                    ),

                    // const Icon(Icons.lock, size: 80, color: Colors.white), // Kode ikon lama
                    // ==========================================================
                    const SizedBox(height: 20),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Login untuk melanjutkan',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed:
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF3A5795),
                                    ),
                                  ),
                                )
                                : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3A5795),
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
