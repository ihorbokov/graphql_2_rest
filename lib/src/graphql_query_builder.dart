import 'package:graphql_2_rest/src/graphql_query_input.dart';

/// A typedef representing a function that converts an `Enum` value to
/// a `String`.
///
/// This function type is used to define how `Enum` values should be serialized
/// when converting them to a GraphQL-compatible format.
typedef EnumEncoder = String Function(Enum value);

/// A utility class that builds REST-compatible queries from a given GraphQL
/// query.
///
/// `GraphQLQueryBuilder` is designed to take a GraphQL query string and
/// replace [inputPattern] with arguments provided by a model implementing
/// the `GraphQLQueryInput` mixin.
class GraphQLQueryBuilder {
  /// Creates an instance of `GraphQLQueryBuilder`.
  ///
  /// The `inputPattern` parameter is used to define the placeholder pattern
  /// within the GraphQL query string that indicates where the model arguments
  /// should be inserted. By default, it is set to `%input`.
  ///
  /// This constructor allows you to customize the placeholder pattern
  /// based on your requirements.
  const GraphQLQueryBuilder({
    this.inputPattern = '%input',
  });

  /// A customizable pattern used to identify placeholder for inserting
  /// arguments.
  ///
  /// By default, this is set to `%input`. It helps in locating where arguments
  /// should be injected into the GraphQL query.
  final String inputPattern;

  /// Builds a REST-compatible query from the provided GraphQL [query] and
  /// an optional [input].
  ///
  /// If a [input] is provided, its `toJson()` method is called to obtain
  /// the arguments. Each argument is then formatted and inserted into
  /// the query at the position marked by the [inputPattern].
  ///
  /// Returns a `Map<String, String>` containing the formatted query.
  Map<String, String> build(
    String query, [
    GraphQLQueryInput? input,
  ]) {
    var outputQuery = query;
    if (input != null) {
      final data = input.toJson();
      final enumEncoder = input.encodeEnum;
      final arguments = data.entries.map(
        (entry) => '${entry.key}: ${_encode(entry.value, enumEncoder)}',
      );
      outputQuery = outputQuery.replaceFirst(
        inputPattern,
        arguments.join(', '),
      );
    }
    return {'query': outputQuery.replaceAll(RegExp(r'\s+'), ' ').trim()};
  }

  /// Serializes the given [value] into a GraphQL-compatible string format.
  ///
  /// The method handles different data types, such as:
  /// - `Enum`: Converts to its name or a custom string using [encodeEnum].
  /// - `String`: Wraps in double quotes.
  /// - `List`: Recursively serializes elements and wraps in square brackets.
  /// - `Map`: Recursively serializes entries and wraps in curly braces.
  ///
  /// Returns a formatted string representation of the value.
  String _encode(
    dynamic value,
    EnumEncoder encodeEnum,
  ) {
    if (value is Enum) {
      return encodeEnum(value);
    } else if (value is String) {
      return '"$value"';
    } else if (value is List) {
      final values = value.map(
        (element) => _encode(element, encodeEnum),
      );
      return '[${values.join(', ')}]';
    } else if (value is Map) {
      final values = value.entries.map(
        (entry) => '${entry.key}: ${_encode(entry.value, encodeEnum)}',
      );
      return '{${values.join(', ')}}';
    } else {
      return '$value';
    }
  }
}
