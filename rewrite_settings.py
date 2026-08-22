import re

with open('lib/features/settings/presentation/pages/settings_page.dart', 'r') as f:
    content = f.read()

# Add ResponsiveLayout import if missing
if 'responsive_layout.dart' not in content:
    content = content.replace("import '../../../../core/constants/app_colors.dart';", "import '../../../../core/constants/app_colors.dart';\nimport '../../../../core/utils/responsive_layout.dart';")

# Add enum
if 'enum SettingsTab' not in content:
    content = content.replace("class _SettingsPageState extends State<SettingsPage> {", "enum SettingsTab { sync, payment, appearance }\n\nclass _SettingsPageState extends State<SettingsPage> {\n  SettingsTab _selectedTab = SettingsTab.payment;")

# Refactor the build method. This is complex, I will write the replacement manually using multi_replace_file_content for specific parts instead of a python script, as the UI code is large.
