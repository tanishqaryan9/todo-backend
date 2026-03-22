// lib/widgets/creator_profile_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CreatorProfileSheet extends StatelessWidget {
  const CreatorProfileSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatorProfileSheet(),
    );
  }

  // ── Update these with your real details ──
  static const String _name = 'Tanishq Aryan';
  static const String _title = 'Full-Stack Developer';
  static const String _university = 'B.Tech @ Graphic Era Hill University';
  static const String _email = 'aryantanishq123@gmail.com';
  static const String _phone = '+91 8901733205';
  static const String _linkedin = 'linkedin.com/in/tanishq-aryan-3a4a22311';
  static const String _leetcode = 'leetcode.com/u/tanishq_aryan22';
  static const String _github = 'github.com/tanishqaryan';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Profile Header ──
          Stack(
            alignment: Alignment.center,
            children: [
              // Gradient background arc
              Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.12),
                      AppTheme.primary.withOpacity(0.03),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Column(
                children: [
                  // Avatar with photo
                  Container(
                    width: 88, height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to initials if image not found
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primary, Color(0xFF5856D6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.info)
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Text(
            _name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            _title,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            _university,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Divider ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Divider(color: AppTheme.separator, height: 1),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Contact & Links ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                _LinkTile(
                  icon: CupertinoIcons.mail_solid,
                  iconColor: const Color(0xFFEA4335),
                  label: 'Email',
                  value: _email,
                  onTap: () => _copyToClipboard(context, _email, 'Email'),
                ),
                _LinkTile(
                  icon: CupertinoIcons.phone_fill,
                  iconColor: AppTheme.success,
                  label: 'Phone',
                  value: _phone,
                  onTap: () => _copyToClipboard(context, _phone, 'Phone number'),
                ),
                _LinkTile(
                  icon: CupertinoIcons.person_crop_square_fill,
                  iconColor: const Color(0xFF0077B5),
                  label: 'LinkedIn',
                  value: _linkedin,
                  onTap: () => _copyToClipboard(context, 'https://$_linkedin', 'LinkedIn URL'),
                ),
                _LinkTile(
                  icon: CupertinoIcons.chevron_left_slash_chevron_right,
                  iconColor: const Color(0xFFFFA116),
                  label: 'LeetCode',
                  value: _leetcode,
                  onTap: () => _copyToClipboard(context, 'https://$_leetcode', 'LeetCode URL'),
                ),
                _LinkTile(
                  icon: CupertinoIcons.ant_fill,
                  iconColor: AppTheme.textPrimary,
                  label: 'GitHub',
                  value: _github,
                  onTap: () => _copyToClipboard(context, 'https://$_github', 'GitHub URL'),
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Built with tag ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.hammer_fill,
                    size: 13, color: AppTheme.textSecondary),
                SizedBox(width: 6),
                Text(
                  'Built with Flutter & Spring Boot',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

  const _LinkTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: AppSpacing.md),
                // Label + value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 2),
                      Text(value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Copy hint
                const Icon(CupertinoIcons.doc_on_doc,
                    size: 14, color: AppTheme.textTertiary),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(color: AppTheme.separator, height: 1, indent: 54),
      ],
    );
  }
}
