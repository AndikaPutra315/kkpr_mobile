import 'package:flutter/material.dart';

class ProfilDrawer extends StatelessWidget {
  const ProfilDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text("admin@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Ganti Username'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer dulu
              // TODO: Navigasi ke halaman ganti username
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ganti Password'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigasi ke halaman ganti password
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Logika logout
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
