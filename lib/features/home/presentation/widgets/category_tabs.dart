import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saji_pos_app/features/category/domain/entities/category.dart';
import 'package:saji_pos_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int index, int categoryId) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  static final List<Category> _dummyCategories = List.generate(
    5,
    (index) => Category(
      id: index,
      name: 'Kategori $index',
      createdAt: '',
      updatedAt: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Skeletonizer(
            enabled: true,

            child: _buildList(_dummyCategories),
          );
        }

        if (state is CategoryError) {
          return const SizedBox(height: 42);
        }

        if (state is CategoryLoaded) {
          final categories = [
            const Category(id: 0, name: 'Semua', createdAt: '', updatedAt: ''),
            ...state.categories,
          ];
          return _buildList(categories);
        }

        return const SizedBox(height: 42);
      },
    );
  }

  Widget _buildList(List<Category> categories) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final categoryName = categories[index].name;
          final categoryId = categories[index].id;

          return GestureDetector(
            onTap: () => onCategorySelected(index, categoryId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: AppColors.border),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
