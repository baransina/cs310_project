import 'package:flutter/material.dart';

import '../models/friend.dart';
import '../theme.dart';

// Small blue chip with the course code, e.g. "CS310".
class CourseChip extends StatelessWidget {
  const CourseChip({super.key, required this.course});
  final String course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        course,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Round avatar with the person's initials.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.name, this.radius = 22});
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        initialsOf(name),
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}

// Outlined colored tag, e.g. "Studying", "Full", "Going".
class StatusTag extends StatelessWidget {
  const StatusTag({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
