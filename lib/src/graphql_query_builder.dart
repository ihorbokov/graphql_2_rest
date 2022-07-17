import 'graphql_query_model.dart';

/// A class that is responsible for building REST queries.
class GraphQLQueryBuilder {
  /// An optional [mask] of query arguments which is %arg by default.
  const GraphQLQueryBuilder({this.mask = _defaultMask});

  static const _keyQuery = 'query';
  static const _defaultMask = '%arg';

  /// Mask of query arguments
  final String mask;

  /// Builds REST query using GraphQL [query] and [model].
  /// Each argument in [model] should be in right position depend on [query].
  Map<String, String> build(String query, [GraphQLQueryModel? model]) =>
      {_keyQuery: _interpolate(query, model?.arguments)};

  String _interpolate(String query, List<String>? arguments) {
    if (arguments != null) {
      for (final argument in arguments) {
        query = query.replaceFirst(mask, argument);
      }
    }
    return query;
  }
}
