enum ViewMode {
  compacted,
  extended;

  factory ViewMode.fromString(String value) {
    return ViewMode.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ViewMode.extended,
    );
  }
}
