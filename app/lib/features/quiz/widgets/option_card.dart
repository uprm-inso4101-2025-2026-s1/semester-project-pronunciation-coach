import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final bool selected;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.option,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      enabled: onTap != null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: !selected ? Colors.white
          : Theme.of(context).primaryColor.withOpacity(.12),
      title: Text(
        option,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded)
          : const Icon(Icons.circle_outlined),
    );
  }
}
