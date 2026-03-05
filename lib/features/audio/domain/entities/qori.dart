class Qori {
  final int id;
  final String name;
  final String style; // e.g., Murattal, Mujawwad

  // This identifier is often used in common Quran APIs (like Every Ayah / Verse By Verse / Quran.com)
  // to fetch the specific reciter's audio files from the server.
  final String serverIdentifier; 

  const Qori({
    required this.id,
    required this.name,
    required this.style,
    required this.serverIdentifier,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Qori &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
