import 'package:flutter/material.dart';
import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';

class MonthlyPracticeCalendar extends StatefulWidget {
  final Set<int> practiceDays;
  final bool isLoading;
  final String? error;

  const MonthlyPracticeCalendar({
    super.key,
    required this.practiceDays,
    this.isLoading = false,
    this.error,
  });

  @override
  State<MonthlyPracticeCalendar> createState() =>
      _MonthlyPracticeCalendarState();
}

class _MonthlyPracticeCalendarState extends State<MonthlyPracticeCalendar>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _starController;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();

    // Star sparkle animation
    _starController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _starAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _starController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Recent Practice', style: AppTextStyles.heading2),
            ],
          ),
          const SizedBox(height: 20),
          if (widget.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (widget.error != null)
            Center(
              child: Text(
                'Failed to load calendar',
                style: TextStyle(color: Colors.red[600]),
              ),
            )
          else
            FadeTransition(opacity: _fadeAnimation, child: _buildCalendar()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Calculate weekday of first day (0 = Sunday, 1 = Monday, etc.)
    final firstWeekday = firstDayOfMonth.weekday % 7; // Convert to 0=Sunday

    return Column(
      children: [
        // Month header
        Text(
          '${_getMonthName(now.month)} ${now.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // Day headers
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) {
              // Empty cells before first day
              return const SizedBox.shrink();
            }

            final day = index - firstWeekday + 1;
            final isToday = day == now.day;
            final hasPractice = widget.practiceDays.contains(day);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: hasPractice
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0.1),
                        ],
                      )
                    : isToday
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber.withValues(alpha: 0.15),
                          Colors.orange.withValues(alpha: 0.1),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
                border: hasPractice
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      )
                    : isToday && !hasPractice
                    ? Border.all(
                        color: Colors.amber.withValues(alpha: 0.5),
                        width: 1.5,
                      )
                    : null,
                boxShadow: hasPractice
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: hasPractice
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _starAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _starAnimation.value,
                              child: Icon(
                                Icons.star,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isToday ? Colors.amber[800] : Colors.grey[600],
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
