extension DoubleOpacity on double {
  int get alpha => (this * 255).round().clamp(0, 255);
}
