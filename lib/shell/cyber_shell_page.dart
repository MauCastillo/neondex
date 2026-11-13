import 'package:material_ui/material_ui.dart';

import '../core/theme/cyber_colors.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/notifications_settings/presentation/pages/system_settings_page.dart';
import '../features/pokedex/presentation/pages/pokedex_home_page.dart';
import '../features/weather_radar/presentation/pages/weather_radar_page.dart';

class CyberShellPage extends StatefulWidget {
  const CyberShellPage({super.key});

  @override
  State<CyberShellPage> createState() => _CyberShellPageState();
}

class _CyberShellPageState extends State<CyberShellPage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    PokedexHomePage(),
    WeatherRadarPage(),
    FavoritesPage(),
    SystemSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: CyberColors.neonCyan.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'POKÉDEX',
            ),
            NavigationDestination(
              icon: Icon(Icons.radar_outlined),
              selectedIcon: Icon(Icons.radar_rounded),
              label: 'CLIMA',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline_rounded),
              selectedIcon: Icon(Icons.star_rounded),
              label: 'FAVORITOS',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune_rounded),
              label: 'SISTEMA',
            ),
          ],
        ),
      ),
    );
  }
}
