bool isHexColor(String value) {
  final hex = value.replaceAll('#', '');
  return RegExp(r'^[0-9a-fA-F]{6}$|^[0-9a-fA-F]{8}$').hasMatch(hex);
}
