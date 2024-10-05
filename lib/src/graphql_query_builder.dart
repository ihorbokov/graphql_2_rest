import 'package:graphql_2_rest/src/graphql_query_payload.dart';

typedef QueryFormatter = String Function(String query);
typedef ValueEncoder = String? Function(dynamic value);

class GraphQLQueryBuilder {
  const GraphQLQueryBuilder({
    this.inputPrefix = '@',
    this.argumentPrefix = '%',
    this.formatter,
  });

  final String inputPrefix;
  final String argumentPrefix;
  final QueryFormatter? formatter;

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
    return {'query': formatter?.call(outputQuery) ?? outputQuery};
  }

  String _encode(
    dynamic value,
    ValueEncoder encode,
  ) {
    final encodedValue = encode(value);
    if (encodedValue != null) {
      return encodedValue;
    } else if (value is Enum) {
      return value.name;
    } else if (value is String) {
      return '"$value"';
    } else if (value is List) {
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
