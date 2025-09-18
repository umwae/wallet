/// Common extensions for [String]
extension StringExtension on String {
  /// Returns a new string with the first [length] characters of this string.
  String limit(int length) => length < this.length ? substring(0, length) : this;

  String shortForm({int limit = 8}) {
    if (length <= limit) return this;
    return '${substring(0, (limit / 2).floor())}...${substring(length - (limit / 2).floor())}';
  }
}
