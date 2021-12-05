/// A mixin that helps to prepare arguments for a GraphQL query.
/// Each argument has to be represented as [String] type.
mixin GraphQLQueryModel {
  /// Ordered arguments of the GraphQL query.
  List<String> get arguments;
}
