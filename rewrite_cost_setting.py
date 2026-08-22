import re

with open('lib/features/cost_setting/presentation/pages/cost_setting_page.dart', 'r') as f:
    content = f.read()

# Add isEmbedded parameter
content = content.replace(
    'const CostSettingPage({super.key});',
    'final bool isEmbedded;\n  const CostSettingPage({super.key, this.isEmbedded = false});'
)

# Replace Scaffold return with conditional
scaffold_start = content.find('return Scaffold(')
if scaffold_start != -1:
    before = content[:scaffold_start]
    
    # Extract the BlocConsumer block
    body_start = content.find('body: BlocConsumer<CostSettingBloc, CostSettingState>(', scaffold_start)
    body_content_start = body_start + 6
    # Finding the matching brace for BlocConsumer is tricky. Let's just use string replacement on the Scaffold wrapper.
    pass

