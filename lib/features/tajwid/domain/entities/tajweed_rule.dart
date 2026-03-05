enum TajweedRuleType { ghunna, ikhfaa, idgham, iqlab, qalqala, madd, izhar }

class TajweedRule {
  final String name;
  final String description;
  final List<TajweedSubrule> subrules;
  final int priority;

  const TajweedRule(this.name, this.description, this.subrules, this.priority);
}

class TajweedSubrule {
  final String name;
  final String description;
  final TajweedRuleType type;
  final RegExp regex;

  const TajweedSubrule(this.name, this.description, this.type, this.regex);
}
