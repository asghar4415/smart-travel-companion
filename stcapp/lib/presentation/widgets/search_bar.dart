import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onChanged;
  final String? hintText;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onFilterTap,
    required this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText ?? 'Search places...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.tune, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
