import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Beranda'),
            _buildNavItem(1, Icons.discount_rounded, 'Promo', badgeCount: 2), // Hardcoded dummy badge count
            _buildNavItem(2, Icons.analytics_rounded, 'Report'),
            _buildNavItem(3, Icons.settings_rounded, 'Settings'),
            _buildNavItem(4, Icons.logout_rounded, 'Keluar'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {int badgeCount = 0}) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
                  size: 22,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
