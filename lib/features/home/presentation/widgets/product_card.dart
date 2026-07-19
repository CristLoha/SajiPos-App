import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String? discountPrice;
  final int quantity;
  final int stock;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    this.discountPrice,
    this.quantity = 0,
    this.stock = 0,
    this.imageUrl,
    this.onTap,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: stock > 0 ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: quantity > 0 ? AppColors.accent : AppColors.border,
              width: quantity > 0 ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ColorFiltered(
                            colorFilter: stock > 0
                                ? const ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  )
                                : const ColorFilter.matrix(<double>[
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0.2126,
                                    0.7152,
                                    0.0722,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ]),
                            child: imageUrl != null && imageUrl!.isNotEmpty
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.fastfood_rounded,
                                          color: AppColors.accent.withValues(
                                            alpha: 0.5,
                                          ),
                                          size: 48,
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.fastfood_rounded,
                                      color: AppColors.accent.withValues(
                                        alpha: 0.5,
                                      ),
                                      size: 48,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                category,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Column(
                            children: [
                              if (discountPrice != null)
                                Text(
                                  price,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              Text(
                                discountPrice ?? price,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
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

              if (stock > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: quantity > 0
                          ? AppColors.accent
                          : AppColors.accent.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (quantity > 0)
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Center(
                      child: quantity > 0
                          ? Text(
                              '$quantity',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          : const Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.white,
                              size: 18,
                            ),
                    ),
                  ),
                )
              else
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Habis',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (discountPrice != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PROMO',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
