import 'package:flutter/material.dart';
import '../theme/hazmat_theme.dart';

class HazmatSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const HazmatSearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: HMColors.primaryText, fontSize: 15),
      cursorColor: HMColors.hazardYellow,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                  onChanged('');
                  onClear?.call();
                },
                child: const Icon(Icons.close, size: 18, color: HMColors.dimText),
              )
            : null,
      ),
    );
  }
}
