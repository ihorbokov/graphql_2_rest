part of graphql_2_rest;

class GraphQLQueryBuilder {
  static const _keyQuery = 'query';
  static const _defaultArgumentMask = '%arg';

  final String argumentMask;

  const GraphQLQueryBuilder([this.argumentMask = _defaultArgumentMask]);

  Map<String, String> build(String query, [GraphQLQueryModel? model]) =>
      {_keyQuery: _interpolate(query, model?.arguments)};

  String _interpolate(String query, List<String>? arguments) {
    if (arguments != null) {
      for (final argument in arguments) {
        query = query.replaceFirst(_defaultArgumentMask, argument);
      }
    }
    return query;
  }
}
