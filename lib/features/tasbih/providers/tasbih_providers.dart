import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasbih_providers.g.dart';

@riverpod
class TasbihCount extends _$TasbihCount {
  @override
  int build() => 0;

  void increment() => state++;

  void reset() => state = 0;
}
