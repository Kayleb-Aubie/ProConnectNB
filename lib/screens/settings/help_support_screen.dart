import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/tr_text.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedFaq;

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'Comment ajouter un médicament ?',
      answer:
          'Rendez-vous dans l\'onglet "Médicaments" depuis le menu ou le tableau de bord, puis appuyez sur le bouton "+" en bas à droite pour ajouter un nouveau médicament avec son nom, dosage et horaire.',
    ),
    _FaqItem(
      question: 'Comment inviter un proche aidant ?',
      answer:
          'Dans l\'onglet "Proche aidant", appuyez sur "Inviter" et saisissez l\'adresse courriel de la personne. Elle recevra un lien pour créer son compte et accéder à votre profil de santé partagé.',
    ),
    _FaqItem(
      question: 'Mes données sont-elles sécurisées ?',
      answer:
          'Oui, toutes vos données sont chiffrées en transit (TLS) et au repos. Nous ne partageons jamais vos informations personnelles avec des tiers sans votre consentement explicite.',
    ),
    _FaqItem(
      question: 'Comment modifier un rendez-vous ?',
      answer:
          'Dans l\'onglet "Rendez-vous", appuyez sur le rendez-vous souhaité pour voir ses détails, puis utilisez l\'icône de crayon pour le modifier ou l\'icône de corbeille pour le supprimer.',
    ),
    _FaqItem(
      question: 'Je ne reçois pas mes rappels de médicaments.',
      answer:
          'Vérifiez que les notifications sont activées dans Paramètres → Notifications. Assurez-vous également que l\'application n\'est pas en mode silencieux ou que la batterie n\'est pas en mode économie extrême qui bloque les notifications en arrière-plan.',
    ),
    _FaqItem(
      question: 'Comment supprimer mon compte ?',
      answer:
          'Pour supprimer votre compte et toutes vos données, contactez notre support à support@proconnectnb.ca avec l\'objet "Suppression de compte". Votre demande sera traitée dans les 72 heures.',
    ),
  ];

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
          'Aide & Support',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 4),

          // ── En-tête ───────────────────────────────────────
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF405667).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent_rounded,
                  color: Color(0xFF405667), size: 34),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: TrText(
              'Comment pouvons-nous vous aider ?',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3530)),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Consultez la FAQ ou contactez-nous directement.',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),

          // ── Contact rapide ────────────────────────────────
          _SectionLabel('Nous contacter'),
          _Card(children: [
            _ContactTile(
              icon: Icons.email_outlined,
              iconColor: const Color(0xFF5D95D6),
              iconBg: const Color(0xFFE8F1FB),
              label: 'Courriel',
              value: 'support@proconnectnb.ca',
              onTap: () => _launch('mailto:support@proconnectnb.ca'),
            ),
            _Divider(),
            _ContactTile(
              icon: Icons.phone_outlined,
              iconColor: const Color(0xFF00B285),
              iconBg: const Color(0xFFE0F7F1),
              label: 'Téléphone',
              value: '+1 (506) 000-0000',
              onTap: () => _launch('tel:+15060000000'),
            ),
            _Divider(),
            _ContactTile(
              icon: Icons.chat_bubble_outline_rounded,
              iconColor: const Color(0xFF6C5DD3),
              iconBg: const Color(0xFFEEEDFE),
              label: 'Chat en ligne',
              value: 'Disponible 9h – 17h (HNA)',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 8),

          // ── FAQ ───────────────────────────────────────────
          _SectionLabel('Questions fréquentes'),
          ..._faqs.asMap().entries.map((entry) {
            final i    = entry.key;
            final item = entry.value;
            final isOpen = _expandedFaq == i;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () =>
                    setState(() => _expandedFaq = isOpen ? null : i),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TrText(
                              item.question,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isOpen
                                    ? const Color(0xFF405667)
                                    : const Color(0xFF3D3530),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFAFAFAF), size: 20),
                          ),
                        ],
                      ),
                      if (isOpen) ...[
                        const SizedBox(height: 10),
                        Text(
                          item.answer,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7A7A7A),
                              height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // ── Signaler un problème ──────────────────────────
          OutlinedButton.icon(
            onPressed: () => _launch('mailto:support@proconnectnb.ca?subject=Signalement%20d%27un%20problème'),
            icon: const Icon(Icons.bug_report_outlined,
                color: Color(0xFF405667), size: 18),
            label: const TrText(
              'Signaler un problème',
              style: TextStyle(color: Color(0xFF405667)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              side: const BorderSide(color: Color(0xFF405667), width: 0.8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

// ── Modèles ──────────────────────────────────────────────────

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
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
      height: 0, indent: 58, endIndent: 16, color: Color(0xFFF0EDEA));
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrText(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3D3530))),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFAFAFAF))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Color(0xFFCBCBCB)),
          ],
        ),
      ),
    );
  }
}
