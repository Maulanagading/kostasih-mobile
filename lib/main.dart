import 'package:flutter/material.dart';

void main() {
  runApp(const KosAsihApp());
}

class KosAsihApp extends StatelessWidget {
  const KosAsihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosAsih',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const KosAsihHomePage(),
    );
  }
}

class KosAsihHomePage extends StatelessWidget {
  const KosAsihHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KosAsih'),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Selamat datang di KosAsih',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola indekos lebih mudah, rapi, dan terintegrasi.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.home_work_outlined, size: 42),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Kos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Pantau hunian, penghuni, dan keuangan Anda.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Menu utama',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const _FeatureTile(
            icon: Icons.meeting_room_outlined,
            title: 'Data Kamar',
            subtitle: 'Kelola ketersediaan dan detail kamar',
          ),
          const _FeatureTile(
            icon: Icons.people_outline,
            title: 'Data Penghuni',
            subtitle: 'Catat dan pantau informasi penghuni',
          ),
          const _FeatureTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Keuangan',
            subtitle: 'Kelola pembayaran dan laporan keuangan',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
