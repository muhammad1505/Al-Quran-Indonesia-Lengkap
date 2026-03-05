import 'package:quran_app/features/tajwid/domain/entities/tajweed_rule.dart';

class TajweedToken {
  final int start;
  final int end;
  final TajweedRule rule;
  final TajweedSubrule subrule;

  const TajweedToken(this.start, this.end, this.rule, this.subrule);
}
