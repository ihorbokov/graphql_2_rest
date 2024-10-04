/// A mixin that allows a model to be serialized into a JSON-compatible format.
///
/// This mixin provides the `toJson()` method, which should be implemented
/// to return a `Map<String, dynamic>` representation of the model's fields.
///
/// Typically used in GraphQL queries to convert model data into key-value pairs
/// that can be easily interpolated into query strings.
///
/// Example:
/// ```dart
/// class MyGraphQLQueryInput with GraphQLQueryInput {
///   MyGraphQLQueryInput(
///     this.id,
///     this.name,
///     this.status,
///   );
///
///   final int id;
///   final String name;
///   final Status status;
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'id': id,
///       'name': name,
///       'status': status,
///     };
///   }
///
///   @override
///   String encodeEnum(covariant Status value) {
///     return value.name.toUpperCase();
///   }
/// }
///
/// enum Status { active, inactive }
/// ```
mixin GraphQLQueryInput {
  /// Converts the model into a JSON-compatible `Map`.
  Map<String, dynamic> toJson();

  /// Encodes an `enum` [value] to string representation.
  ///
  /// This method converts the given `enum` [value] to its name by default.
  /// For example, if the `enum` is `Status.active`, it returns `active`.
  ///
  /// This can be used to convert `enum` values when serializing them to JSON.
  String encodeEnum(covariant Enum value) => value.name;
}
