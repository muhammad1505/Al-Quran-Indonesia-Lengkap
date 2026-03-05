import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasbih_providers.g.dart';

/// Selectable tasbih target (33, 99, 100)
final tasbihTargetProvider = StateProvider<int>((ref) => 33);

@riverpod
class TasbihCount extends _$TasbihCount {
  @override
  int build() => 0;

  void increment() => state++;

  void reset() => state = 0;
}
