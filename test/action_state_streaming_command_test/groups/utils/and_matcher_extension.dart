import 'package:flutter_test/flutter_test.dart';

extension AndMatcherExtension on Matcher {
  Matcher and(Matcher other) => _AndMatcher(matcher: this, other: other);
}

final class _AndMatcher extends Matcher {
  _AndMatcher({
    required Matcher matcher,
    required Matcher other,
  })  : _other = other,
        _matcher = matcher;

  final Matcher _matcher;
  final Matcher _other;

  @override
  Description describe(Description description) {
    return description.addAll('"', ', and ', '"', [
      _matcher,
      _other,
    ]);
  }

  @override
  bool matches(item, Map matchState) {
    return _matcher.matches(item, matchState) &&
        _other.matches(item, matchState);
  }
}
