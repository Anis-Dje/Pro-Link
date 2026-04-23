import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';

class InternIdCardScreen extends StatefulWidget {
  const InternIdCardScreen({super.key});

  @override
  State<InternIdCardScreen> createState() => _InternIdCardScreenState();
}

class _InternIdCardScreenState extends State<InternIdCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Work ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Implement share / download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            const SizedBox(height: AppConstants.paddingMd),
            Text(
              'Your Professional ID',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXs),
            Text(
              'Tap the card to flip',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXl),
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipController,
                builder: (context, child) {
                  final angle = _flipController.value * math.pi;
                  final isFrontVisible = angle < math.pi / 2;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: isFrontVisible
                        ? _buildFrontCard(context, user)
                        : Transform(
                            transform: Matrix4.identity()..rotateY(math.pi),
                            alignment: Alignment.center,
                            child: _buildBackCard(context, user),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.paddingXl),
            _buildCardInfo(context),
            const SizedBox(height: AppConstants.paddingLg),
            _buildActionsRow(context),
            const SizedBox(height: AppConstants.paddingLg),
          ],
        ),
      ),
    );
  }

  // ─── Front face ────────────────────────────────────────────────────────────
  Widget _buildFrontCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryNavy, AppTheme.primaryNavyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withAlpha(100),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern circles
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(13),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Card content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PRO-LINK',
                          style: TextStyle(
                            color: AppTheme.accentGold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Digital Internship ID',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textOnDarkSecondary,
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.accentGold.withAlpha(128),
                            width: 1),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: AppTheme.accentGold,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Photo + Info row
                Row(
                  children: [
                    // Photo placeholder
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(
                          color: AppTheme.accentGold.withAlpha(128),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outlined,
                        color: AppTheme.accentGold,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Ahmed Intern',
                            style: const TextStyle(
                              color: AppTheme.textOnDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.department ?? 'Software Engineering',
                            style: const TextStyle(
                              color: AppTheme.textOnDarkSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ID: ${user?.id?.substring(0, 12).toUpperCase() ?? 'PL-2025-0001'}',
                            style: const TextStyle(
                              color: AppTheme.accentGold,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Back face ─────────────────────────────────────────────────────────────
  Widget _buildBackCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        color: AppTheme.primaryNavy,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNavy.withAlpha(100),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Magnetic stripe
            Container(
              height: 36,
              color: Colors.black87,
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _backRow('Internship Cycle', '2025 – Spring/Summer'),
            const SizedBox(height: AppConstants.paddingSm),
            _backRow('University', AppConstants.universityFullName),
            const SizedBox(height: AppConstants.paddingSm),
            _backRow('Email', user?.email ?? 'intern@prolink.dz'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Constantine 2 University',
                  style: TextStyle(
                    color: AppTheme.textOnDarkSecondary,
                    fontSize: 10,
                  ),
                ),
                Container(
                  width: 48,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withAlpha(38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.qr_code_outlined,
                    color: AppTheme.accentGold,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textOnDarkSecondary,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textOnDark,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Info section below card ───────────────────────────────────────────────
  Widget _buildCardInfo(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Intern Details',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            _detailRow(context, Icons.person_outlined, 'Full Name',
                user?.fullName ?? '—'),
            _detailRow(context, Icons.email_outlined, 'Email',
                user?.email ?? '—'),
            _detailRow(context, Icons.work_outline, 'Department',
                user?.department ?? '—'),
            _detailRow(context, Icons.school_outlined, 'University',
                AppConstants.universityFullName),
            _detailRow(context, Icons.badge_outlined, 'Intern ID',
                user?.id ?? '—'),
            _detailRow(context, Icons.calendar_today_outlined, 'Status',
                'Active – Spring/Summer 2025'),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Download PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('PDF download coming soon')),
              );
            },
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text('Download PDF'),
          ),
        ),
        const SizedBox(width: AppConstants.paddingMd),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Share card
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
            icon: const Icon(Icons.share_outlined, size: 18),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}
