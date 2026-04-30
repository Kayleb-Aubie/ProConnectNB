import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/tr_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _version    = '1.0.0';
  static const String _build      = '2026.04';
  static const String _privacyUrl = 'https://proconnectnb.ca/confidentialite';
  static const String _termsUrl   = 'https://proconnectnb.ca/conditions';

  @override
  Widget build(BuildContext context) {
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
          'À propos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),

          // ── Logo & version ────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF405667),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF405667).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  // Remplacez par votre logo : Image.asset('images/logoProConnectNB.png')
                  child: const Icon(Icons.favorite_rounded,
                      color: Colors.white, size: 42),
                ),
                const SizedBox(height: 16),
                const TrText(
                  'ProConnect NB',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D3530)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version $_version (build $_build)',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFFAFAFAF)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF405667).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TrText(
                    'Santé & bien-être · Nouveau-Brunswick',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF405667)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Description ───────────────────────────────────
          _Card(children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'ProConnect NB est une application de santé numérique conçue pour aider les aînés et leurs proches aidants à gérer médicaments, activités physiques et rendez-vous médicaux en toute simplicité.',
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A7A7A),
                    height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          const SizedBox(height: 8),

          // ── Informations ──────────────────────────────────
          _SectionLabel('Informations'),
          _Card(children: [
            _InfoTile(label: 'Version', value: _version),
            _Divider(),
            _InfoTile(label: 'Build', value: _build),
            _Divider(),
            _InfoTile(label: 'Plateforme', value: 'Android & iOS'),
            _Divider(),
            _InfoTile(label: 'Développé par', value: 'Équipe ProConnect NB'),
            _Divider(),
            _InfoTile(label: 'Région', value: 'Nouveau-Brunswick, Canada'),
          ]),
          const SizedBox(height: 8),

          // ── Légal ─────────────────────────────────────────
          _SectionLabel('Légal'),
          _Card(children: [
            _LinkTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: const Color(0xFF5D95D6),
              iconBg: const Color(0xFFE8F1FB),
              label: 'Politique de confidentialité',
              onTap: () => _launch(_privacyUrl),
            ),
            _Divider(),
            _LinkTile(
              icon: Icons.gavel_rounded,
              iconColor: const Color(0xFF6C5DD3),
              iconBg: const Color(0xFFEEEDFE),
              label: 'Conditions d\'utilisation',
              onTap: () => _launch(_termsUrl),
            ),
            _Divider(),
            _LinkTile(
              icon: Icons.history_edu,
              iconColor: const Color(0xFF00B285),
              iconBg: const Color(0xFFE0F7F1),
              label: 'Licences open source',
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'ProConnect NB',
                applicationVersion: _version,
              ),
            ),
          ]),
          const SizedBox(height: 8),

          // ── Équipe ────────────────────────────────────────
          _SectionLabel('Équipe'),
          _Card(children: [
            _TeamTile(initials: 'ML', name: 'Marie-Line', role: 'Conception & UX'),
            _Divider(),
            _TeamTile(initials: 'JB', name: 'Jean-Baptiste', role: 'Développement mobile'),
            _Divider(),
            _TeamTile(initials: 'SA', name: 'Sophie A.', role: 'Architecture & API'),
          ]),

          const SizedBox(height: 28),

          // ── Crédit ────────────────────────────────────────
          Center(
            child: Text(
              '© 2025 ProConnect NB · Tous droits réservés',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

// ── Widgets locaux ───────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
        child: TrText(
          text,
          style: const TextStyle(
            color: Color(0xFF5D95D6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(children: children),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
      height: 0, indent: 16, endIndent: 16, color: Color(0xFFF0EDEA));
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: TrText(label,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF7A7A7A))),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D3530))),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TrText(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3D3530))),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Color(0xFFCBCBCB)),
          ],
        ),
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  const _TeamTile(
      {required this.initials, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF405667).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(initials,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF405667))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrText(name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3D3530))),
                Text(role,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFAFAFAF))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
