import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/tr_text.dart';
import '../../provider/auth_provider.dart';
import '../../provider/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<(MaterialColor, String)> _colorOptions = [
    (Colors.blue, 'Bleu'),
    (Colors.indigo, 'Indigo'),
    (Colors.teal, 'Vert'),
    (Colors.deepOrange, 'Orange'),
    (Colors.pink, 'Rose'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF405667),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TrText(
          'Paramètres',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          // ── COMPTE ────────────────────────────────────────
          _SectionHeader('Compte'),
          _SettingsCard(
            children: [
              _SettingsItem(
                icon: Icons.person_outline_rounded,
                label: 'Éditer le profil',
                onTap: () => Navigator.pushNamed(context, '/editprofil'),
              ),
              _SettingsDivider(),
              _SettingsItem(
                icon: Icons.lock_outline_rounded,
                label: 'Changer le mot de passe',
                onTap: () =>
                    Navigator.pushNamed(context, '/settings/password'), // ✅
              ),
            ],
          ),

          // ── PRÉFÉRENCES ───────────────────────────────────
          _SectionHeader('Préférences'),
          _SettingsCard(
            children: [
              _SettingsItem(
                icon: Icons.language_rounded,
                label: 'Langue',
                trailingText: settings.language == AppLanguage.fr
                    ? 'Français'
                    : 'English',
                onTap: () => _showLanguageDialog(context, settings),
              ),
              _SettingsDivider(),
              _ToggleItem(
                icon: Icons.dark_mode_outlined,
                label: 'Mode sombre',
                subtitle: settings.isDarkMode ? 'Activé' : 'Désactivé',
                value: settings.isDarkMode,
                onChanged: (_) => settings.toggleTheme(),
              ),
              _SettingsDivider(),
              _FontSizeItem(settings: settings),
              _SettingsDivider(),
              _SettingsItem(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                onTap: () => Navigator.pushNamed(
                  context,
                  '/settings/notifications',
                ), // ✅
              ),
            ],
          ),

          // ── SUPPORT ───────────────────────────────────────
          _SectionHeader('Support'),
          _SettingsCard(
            children: [
              _SettingsItem(
                icon: Icons.help_outline_rounded,
                label: 'Aide & Support',
                onTap: () =>
                    Navigator.pushNamed(context, '/settings/help'), // ✅
              ),
              _SettingsDivider(),
              _SettingsItem(
                icon: Icons.info_outline_rounded,
                label: 'À propos',
                onTap: () =>
                    Navigator.pushNamed(context, '/settings/about'), // ✅
              ),
            ],
          ),

          // ── DÉCONNEXION ───────────────────────────────────
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              label: const TrText(
                'Se déconnecter',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.08),
                elevation: 0,
                side: const BorderSide(color: Colors.redAccent, width: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _confirmLogout(context, auth),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const TrText('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangTile(
              flag: '🇫🇷',
              label: 'Français',
              isActive: settings.language == AppLanguage.fr,
              onTap: () {
                settings.setLanguage(AppLanguage.fr);
                Navigator.pop(ctx);
              },
            ),
            _LangTile(
              flag: '🇬🇧',
              label: 'English',
              isActive: settings.language == AppLanguage.en,
              onTap: () {
                settings.setLanguage(AppLanguage.en);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const TrText('Se déconnecter'),
        content: const TrText('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const TrText('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const TrText(
              'Déconnecter',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await auth.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
    child: TrText(
      title,
      style: const TextStyle(
        color: Color(0xFF5D95D6),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
    height: 0,
    indent: 56,
    endIndent: 16,
    color: Color(0xFFF0EDEA),
  );
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailingText;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: TrText(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF3D3530),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(fontSize: 13, color: Color(0xFFAFAFAF)),
            ),
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: Color(0xFFCBCBCB),
          ),
        ],
      ),
    ),
  );
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        _IconBox(icon: icon),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrText(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF3D3530),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFFAFAFAF)),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF405667),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    ),
  );
}

class _FontSizeItem extends StatelessWidget {
  final SettingsProvider settings;
  const _FontSizeItem({required this.settings});

  String get _label {
    final v = settings.fontSize;
    if (v <= 0.85) return 'Très petite';
    if (v <= 0.95) return 'Petite';
    if (v <= 1.05) return 'Normale';
    if (v <= 1.15) return 'Grande';
    if (v <= 1.25) return 'Très grande';
    return 'Maximale';
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconBox(icon: Icons.format_size_rounded),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TrText(
                    'Taille du texte',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3D3530),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAFAFAF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF405667).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${settings.fontSize.toStringAsFixed(1)}×',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF405667),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF405667),
            inactiveTrackColor: const Color(0xFFE8E4DF),
            thumbColor: const Color(0xFF405667),
            overlayColor: const Color(0x1A405667),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            min: 0.8,
            max: 1.5,
            divisions: 7,
            value: settings.fontSize,
            onChanged: (v) => settings.setFontSize(v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'A',
                style: TextStyle(fontSize: 11, color: Color(0xFFCBCBCB)),
              ),
              Text(
                'A',
                style: TextStyle(fontSize: 16, color: Color(0xFFCBCBCB)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LangTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LangTile({
    required this.flag,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Text(flag, style: const TextStyle(fontSize: 24)),
    title: Text(
      label,
      style: TextStyle(
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    trailing: isActive
        ? const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF405667),
            size: 20,
          )
        : null,
  );
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: const Color(0xFF405667).withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: const Color(0xFF405667), size: 18),
  );
}
