enum SortMode {
  oldest,
  newest,
  byName;

  factory SortMode.fromString(String value) {
    return SortMode.values.firstWhere(
      (type) => type.name == value,
      orElse: () => SortMode.oldest,
    );
  }
}
