/// A mixin that provides a structure for defining the payload of a GraphQL
/// query, including arguments and input models.
///
/// The mixin serves as a base for constructing the payload of a GraphQL query.
/// It defines two primary getters: `arguments` and `inputs`, which are used to
/// organize query parameters and input data, respectively. This mixin can be
/// extended or mixed into other classes to standardize the format and
/// structure of a GraphQL query payload.
///
/// ### Properties:
///
/// - `arguments`
///   - A `Map<String, dynamic>` that holds the query arguments.
///   - This map typically contains the argument names as keys and their
///     corresponding values as map entries.
///   - Example:
///     ```dart
///     {
///       'id': '1234',
///       'limit': 10
///     }
///     ```
///
/// - `inputs`
///   - A `Map<String, Map<String, dynamic>>` that holds the query input data.
///   - Each entry in the map corresponds to an input type, represented as
///     a nested map.
///   - Example:
///     ```dart
///     {
///       'userInput': {
///         'name': 'John Doe',
///         'age': 30
///       }
///     }
///     ```
///
/// ### Methods:
///
/// - `String? encode(dynamic value)`
///   - Encodes a value to a specific format, if applicable.
///   - The method is defined as a placeholder and returns `null` by default.
///   - This can be overridden in classes that mix in `GraphQLQueryPayload`
///     to provide specific encoding logic for enums, objects, or other custom
///     types.
///
/// ### Usage Example:
/// ```dart
/// class MyGraphQLQueryPayload with GraphQLQueryPayload {
///   @override
///   Map<String, dynamic> get arguments => {
///     'id': 5678,
///     'filter': 'active'
///   };
///
///   @override
///   Map<String, Map<String, dynamic>> get inputs => {
///     'userInput': {
///       'name': 'Alice',
///       'email': 'alice@example.com'
///     }
///   };
///
///   @override
///   String? encode(dynamic value) {
///     if (value is Enum) {
///       return value.name.toUpperCase();
///     }
///     return null;
///   }
/// }
/// ```
mixin GraphQLQueryPayload {
  /// A getter that returns a map of arguments for the GraphQL query.
  ///
  /// The [arguments] map holds key-value pairs representing the query
  /// parameters. Each key is a string that corresponds to the name of
  /// an argument, and each value is the value of that argument in dynamic
  /// type. By default, this getter returns an empty map. Subclasses or mixins
  /// can override this to provide specific arguments for a particular query.
  Map<String, dynamic> get arguments => const {};

  /// A getter that returns a map of input models for the GraphQL query.
  ///
  /// The [inputs] map holds key-value pairs, where each key is a string
  /// representing the name of an input, and each value is another map that
  /// contains the fields and values of the input model. This nested map
  /// structure is useful for organizing complex input types that are passed
  /// as part of the query payload.
  ///
  /// By default, this getter returns an empty map. This should be overridden
  /// to include specific input models for a given query.
  Map<String, Map<String, dynamic>> get inputs => const {};

  /// Encodes a value to a specific format, if applicable.
  ///
  /// This method is intended to encode specific types, such as enums, objects,
  /// or other custom types into a format that can be used in a GraphQL query.
  /// By default, the method returns `null`, indicating no special encoding
  /// is applied to the [value]. It can be overridden in subclasses or mixins
  /// to handle specific encoding logic.
  String? encode(dynamic value) => null;
}
