import 'package:flutter/material.dart';

class AppColoredButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;

  const AppColoredButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFF2563EB),
    this.textColor = Colors.white,
    this.height = 48,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity, // ✅ ensures proper layout
      child: Material(
        color: Colors.transparent, // ✅ required for InkWell
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isLoading
                  ? backgroundColor.withOpacity(0.6)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
