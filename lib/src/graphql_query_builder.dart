import 'package:graphql_2_rest/src/graphql_query_payload.dart';

/// A function signature used to transform a GraphQL query string.
///
/// This function takes a `String` parameter representing the GraphQL query
/// and returns a `String` that is the transformed version of the query. This
/// typedef can be used to apply additional transformations or modifications to
/// a query string before it is sent to a server.
typedef GraphQLQueryTransformer = String Function(String query);

/// A function signature used to encode a value into a specific format for
/// GraphQL queries.
///
/// This function takes a `dynamic` value as input and returns an optional
/// `String` that represents the encoded value. This typedef is typically used
/// to handle specific value types (e.g., `Enum`, `DateTime`) that need custom
/// encoding for a GraphQL query.
typedef GraphQLValueEncoder = String? Function(dynamic value);

/// A utility class for building and formatting REST-compatible queries from
/// GraphQL queries with dynamic argument and input replacements.
///
/// The `GraphQLQueryBuilder` class provides an easy way to construct GraphQL
/// queries by replacing placeholders in the query string with actual values
/// from a provided [GraphQLQueryPayload]. The class supports the inclusion of
/// arguments and input objects, making it easier to build complex queries
/// with dynamic values.
///
/// ### Properties:
///
/// - `String inputPrefix`
///   - The prefix used in the query string to denote placeholders
///     for input models.
///   - By default, this is set to `'@'`.
///   - Example: In the query, `@inputUser` will be replaced by the
///     corresponding input fields.
///
/// - `String argumentPrefix`
///   - The prefix used in the query string to denote placeholders
///     for arguments.
///   - By default, this is set to `'%'`.
///   - Example: In the query, `%userName` will be replaced by the
///     corresponding argument value.
///
/// - `GraphQLQueryTransformer? transformer`
///   - An optional function that allows for additional transforming of
///     the final query string.
///   - This can be used to modify the query before it is returned,
///     such as for minifying or applying custom transformations.
///   - Example:
///     ```dart
///     final queryBuilder = GraphQLQueryBuilder(
///       // Minify the query by removing unnecessary whitespace
///       transformer: (query) => query.replaceAll(RegExp(r'\s+'), ' ').trim(),
///     );
///     ```
///
/// ### Methods:
///
/// - `Map<String, String> build(String query, [GraphQLQueryPayload? payload])`
///   - Builds the final GraphQL query string by replacing argument and input
///     placeholders with actual values from the `payload`.
///   - The `query` parameter is the base query string with placeholders.
///   - The optional `payload` parameter contains the arguments and input models
///     that are used to replace the placeholders in the query.
///   - Returns a `Map<String, String>` with the final transformed query.
class GraphQLQueryBuilder {
  /// Creates an instance of `GraphQLQueryBuilder` with optional prefixes
  /// for input and argument placeholders, and an optional query transformer.
  ///
  /// This constructor allows for customization of how input and argument
  /// placeholders are identified and replaced within a GraphQL query. You can
  /// specify different prefixes for inputs and arguments based on your use
  /// case and apply an optional function to transform the final query string
  /// before it is returned.
  const GraphQLQueryBuilder({
    this.inputPrefix = '@',
    this.argumentPrefix = '%',
    this.transformer,
  });

  /// Prefix used to identify input model placeholders in the query string.
  ///
  /// Placeholders in the query that start with `inputPrefix` will be
  /// replaced by the corresponding input fields from the payload.
  ///
  /// Default value: `'@'`.
  final String inputPrefix;

  /// Prefix used to identify argument placeholders in the query string.
  ///
  /// Placeholders in the query that start with `argumentPrefix` will be
  /// replaced by the corresponding argument values from the payload.
  ///
  /// Default value: `'%'`.
  final String argumentPrefix;

  /// An optional function to transform the final query string before
  /// it is returned.
  ///
  /// The `transformer` can be used to apply additional formatting,
  /// minification, or other modifications to the query string after
  /// placeholders have been replaced.
  ///
  /// Default value: `null`.
  final GraphQLQueryTransformer? transformer;

  /// Constructs a REST-compatible query from the provided GraphQL [query] and
  /// an optional [payload].
  ///
  /// This method processes the [query] string by substituting placeholders
  /// that match the `argumentPrefix` and `inputPrefix` with the corresponding
  /// values from the [payload]. If a [transformer] is provided, it applies
  /// the transformation to the final query.
  ///
  /// Returns a `Map<String, String>` with a single entry, where the key
  /// is `'query'` and the value is the formatted query string.
  Map<String, String> build(
    String query, [
    GraphQLQueryPayload? payload,
  ]) {
    var outputQuery = query;
    if (payload != null) {
      final arguments = payload.arguments;
      for (final entry in arguments.entries) {
        outputQuery = outputQuery.replaceAll(
          RegExp('$argumentPrefix${entry.key}', caseSensitive: false),
          _encode(entry.value, payload.encode),
        );
      }

      final inputs = payload.inputs;
      for (final entry in inputs.entries) {
        final input = entry.value.entries.map(
          (entry) => '${entry.key}: ${_encode(entry.value, payload.encode)}',
        );
        outputQuery = outputQuery.replaceAll(
          RegExp('$inputPrefix${entry.key}', caseSensitive: false),
          input.join(', '),
        );
      }
    }
    return {'query': transformer?.call(outputQuery) ?? outputQuery};
  }

  /// Encodes the given [value] into a format compatible with GraphQL syntax.
  ///
  /// This method attempts to convert [value] using the provided [encode]
  /// function. If the custom encoder does not handle the type, it falls back
  /// to built-in encodings for common types like `String`, `Enum`, `DateTime`,
  /// `Iterable`, and `Map`.
  ///
  /// Returns the encoded value as a `String`.
  String _encode(
    dynamic value,
    GraphQLValueEncoder encode,
  ) {
    final encodedValue = encode(value);
    if (encodedValue != null) {
      return encodedValue;
    } else if (value is String) {
      return '"$value"';
    } else if (value is Enum) {
      return value.name;
    } else if (value is DateTime) {
      return value.toIso8601String();
    } else if (value is Iterable) {
      final values = value.map(
        (element) => _encode(element, encode),
      );
      return '[${values.join(', ')}]';
    } else if (value is Map) {
      final values = value.entries.map(
        (entry) => '${entry.key}: ${_encode(entry.value, encode)}',
      );
      return '{${values.join(', ')}}';
    } else {
      return '$value';
    }
  }
}
