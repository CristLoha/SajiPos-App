import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import 'settings_card.dart';
import 'settings_list_tile.dart';
import 'package:saji_pos_app/core/theme/theme_cubit.dart';

class SettingsAppearanceSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;

  const SettingsAppearanceSection({
    super.key,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkValue) {
        final content = SettingsCard(
          children: [
            SettingsListTile(
              icon: Icons.dark_mode_rounded,
              iconColor: Colors.purple,
              title: 'Mode Gelap (Dark Mode)',
              subtitle: 'Hemat baterai dan nyaman di mata',
              trailing: Switch(
                value: isDarkValue,
                activeThumbColor: AppColors.accent,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme(value);
                },
              ),
            ),
          ],
        );

        return content;
      },
    );
  }
}
