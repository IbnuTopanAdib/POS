import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutline;
  final String text;
  final Size size;
  final Color color;

  const ButtonPrimary({
    super.key,
    required this.onPressed,
    required this.text,
    this.isOutline = false,
    this.icon,
    required this.size,
    this.color =
        Pallete.primary, // Atur warna default jika tidak menggunakan gradient
  });

  @override
  Widget build(BuildContext context) {
    return (isOutline)
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: color),
              minimumSize: size,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon!,
                    color: color,
                  ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Pallete.primary, Pallete.secondary], // Warna gradasi
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: size,
                backgroundColor: Colors.transparent, // Atur menjadi transparan
                shadowColor: Colors.transparent, // Hilangkan bayangan default
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Pallete.primary, Pallete.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon!,
                          color: Pallete.whiteColor,
                        ),
                      if (icon != null) const SizedBox(width: 8),
                      Text(
                        text,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
