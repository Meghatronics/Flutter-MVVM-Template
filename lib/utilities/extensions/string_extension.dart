extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String truncate(int limit) {
    if (limit < 0) return this;
    return substring(
      0,
      length.clamp(0, limit),
    );
  }
}
