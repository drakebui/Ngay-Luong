enum CrushMood { excited, bored, stressed, happy, tired, neutral, impulsive }

extension CrushMoodLabel on CrushMood {
  String get label {
    switch (this) {
      case CrushMood.excited:
        return 'Hào hứng';
      case CrushMood.bored:
        return 'Chán chán';
      case CrushMood.stressed:
        return 'Căng thẳng';
      case CrushMood.happy:
        return 'Vui';
      case CrushMood.tired:
        return 'Mệt';
      case CrushMood.neutral:
        return 'Bình thường';
      case CrushMood.impulsive:
        return 'Bốc đồng';
    }
  }

  String get icon {
    switch (this) {
      case CrushMood.excited:
        return '✨';
      case CrushMood.bored:
        return '😶';
      case CrushMood.stressed:
        return '😵‍💫';
      case CrushMood.happy:
        return '🙂';
      case CrushMood.tired:
        return '😴';
      case CrushMood.neutral:
        return '🌿';
      case CrushMood.impulsive:
        return '⚡';
    }
  }
}

CrushMood? crushMoodFromName(String? name) {
  if (name == null) return null;
  for (final mood in CrushMood.values) {
    if (mood.name == name) return mood;
  }
  return null;
}
