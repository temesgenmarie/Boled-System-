import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/providers/auth_provider.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/providers/messages_provider.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/theme/app_animations.dart';
import 'package:admin_app/widgets/app_drawer.dart';
import 'package:admin_app/widgets/animated_card.dart';
import 'package:admin_app/widgets/gradient_background.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    // Create staggered animations for cards
    _cardAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.4 + (index * 0.1),
            curve: AppAnimations.easeOutCubic,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final membersAsync = ref.watch(membersProvider);
    final messagesAsync = ref.watch(messageHistoryProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(authState),
              const SizedBox(height: 32),
              _buildStatCards(
                context,
                membersAsync,
                messagesAsync,
                isMobile,
              ),
              const SizedBox(height: 32),
              _buildQuickActions(context, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          authState.user?.fullName ?? 'Admin',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (authState.organization != null)
          Text(
            authState.organization!.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    AsyncValue<List<dynamic>> membersAsync,
    AsyncValue<List<dynamic>> messagesAsync,
    bool isMobile,
  ) {
    return Column(
      children: [
        // Members card
        FadeTransition(
          opacity: _cardAnimations[0],
          child: ScaleTransition(
            scale: _cardAnimations[0],
            child: AnimatedCard(
              onTap: () => context.push('/members'),
              child: _StatCard(
                title: 'Total Members',
                value: membersAsync.when(
                  data: (members) => members.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                icon: Icons.people_outline,
                color: AppTheme.primaryColor,
                subtitle: 'Active members in organization',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Messages card
        FadeTransition(
          opacity: _cardAnimations[1],
          child: ScaleTransition(
            scale: _cardAnimations[1],
            child: AnimatedCard(
              onTap: () => context.push('/messages/history'),
              child: _StatCard(
                title: 'Messages Sent',
                value: messagesAsync.when(
                  data: (messages) => messages.length.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                icon: Icons.mail_outline,
                color: AppTheme.secondaryColor,
                subtitle: 'Total messages sent',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isMobile) {
    final actions = [
      (
        label: 'Manage Members',
        icon: Icons.people_outline,
        route: '/members',
        color: AppTheme.primaryColor,
      ),
      (
        label: 'Send Message',
        icon: Icons.mail_outline,
        route: '/messages',
        color: AppTheme.infoColor,
      ),
      (
        label: 'Message History',
        icon: Icons.history,
        route: '/messages/history',
        color: AppTheme.warningColor,
      ),
      (
        label: 'Profile',
        icon: Icons.person_outline,
        route: '/profile',
        color: AppTheme.secondaryColor,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return FadeTransition(
              opacity: _cardAnimations[index],
              child: ScaleTransition(
                scale: _cardAnimations[index],
                child: _QuickActionCard(
                  label: action.label,
                  icon: action.icon,
                  color: action.color,
                  onTap: () => context.push(action.route),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
