import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      body: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
    );
  }

  // ─── Wide layout (tablet / desktop) ───────────────────────────────────────
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildBranding(context),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingXl),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                child: _buildLoginCard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Narrow layout (phone) ─────────────────────────────────────────────────
  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBrandingHeader(context),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            child: _buildLoginCard(context),
          ),
        ],
      ),
    );
  }

  // ─── Left-panel branding (wide) ────────────────────────────────────────────
  Widget _buildBranding(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryNavy, AppTheme.primaryNavyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogo(size: 72),
            const SizedBox(height: AppConstants.paddingLg),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.textOnDark,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingSm),
            Text(
              'Enterprise Internship\n& Skill Tracking',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textOnDarkSecondary,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingXl),
            _buildFeatureList(),
            const SizedBox(height: AppConstants.paddingXl),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    color: AppTheme.accentGold,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.paddingMd),
                  Expanded(
                    child: Text(
                      AppConstants.universityFullName,
                      style: const TextStyle(
                        color: AppTheme.textOnDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppConstants.paddingLg,
        MediaQuery.of(context).padding.top + AppConstants.paddingLg,
        AppConstants.paddingLg,
        AppConstants.paddingXl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryNavy, AppTheme.primaryNavyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          _buildLogo(size: 56),
          const SizedBox(height: AppConstants.paddingMd),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.textOnDark,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppConstants.paddingXs),
          Text(
            'Enterprise Internship & Skill Tracking',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textOnDarkSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.accentGold,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Icon(
        Icons.hub_outlined,
        color: AppTheme.primaryNavy,
        size: size * 0.55,
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      (Icons.people_alt_outlined, 'Manage interns & mentors'),
      (Icons.assessment_outlined, 'Track evaluations & performance'),
      (Icons.badge_outlined, 'Digital internship ID cards'),
      (Icons.cloud_outlined, 'REST API & Firebase ready'),
    ];
    return Column(
      children: features.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(f.$1, color: AppTheme.accentGold, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                f.$2,
                style: const TextStyle(
                  color: AppTheme.textOnDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── Login Card ────────────────────────────────────────────────────────────
  Widget _buildLoginCard(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Card(
          elevation: 4,
          shadowColor: AppTheme.cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXs),
                Text(
                  'Sign in to your Pro-Link account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXl),
                _buildDemoHint(context),
                const SizedBox(height: AppConstants.paddingLg),
                _buildLoginForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoHint(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMd),
      decoration: BoxDecoration(
        color: AppTheme.info.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppTheme.info.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.info, size: 16),
              const SizedBox(width: 6),
              Text(
                'Demo Credentials',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.info,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _demoRow('Admin', 'admin@prolink.dz', 'admin123'),
          _demoRow('Mentor', 'mentor@prolink.dz', 'mentor123'),
          _demoRow('Intern', 'intern@prolink.dz', 'intern123'),
        ],
      ),
    );
  }

  Widget _demoRow(String role, String email, String pass) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: () {
          _emailController.text = email;
          _passwordController.text = pass;
        },
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Text(
              email,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.info,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMd),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleLogin(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingSm),

              // Remember me + Forgot password
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    activeColor: AppTheme.primaryNavy,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text('Remember me', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password flow
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset – coming soon'),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMd),

              // Error message
              if (auth.errorMessage != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMd,
                    vertical: AppConstants.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(20),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSm),
                    border: Border.all(color: AppTheme.error.withAlpha(76)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppTheme.error, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          auth.errorMessage!,
                          style: const TextStyle(
                            color: AppTheme.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (auth.errorMessage != null)
                const SizedBox(height: AppConstants.paddingMd),

              // Login button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleLogin,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign In'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
