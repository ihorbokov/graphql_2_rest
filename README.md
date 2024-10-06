# GraphQL to REST
<p>
<a href="https://pub.dev/packages/graphql_2_rest"><img src="https://img.shields.io/pub/v/graphql_2_rest.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A lightweight library for converting GraphQL queries into REST format, enabling the use of any HTTP client for executing requests.

## Usage
To work effectively with the `graphql_2_rest` library, you primarily need to use two key components: `GraphQLQueryPayload` and `GraphQLQueryBuilder`.

1. `GraphQLQueryPayload` is responsible for providing the arguments and input models to be used in a GraphQL query. For example, if you have queries like:
```dart
const queryA = '''query {
  user(age: %age, firstName: %firstName) {
    first_name
    last_name
    site {
      site_name
    }
  }
}''';

const queryB = '''query {
  user(@userInput) {
    first_name
    last_name
    site {
      site_name
    }
  }
}''';
```
then you need to create the following `GraphQLQueryPayload`s with `arguments` or/and `inputs`:
```dart
class UserQueryPayloadA with GraphQLQueryPayload {
  const UserQueryPayloadA(
    this.age,
    this.firstName,
  );

  final int age;
  final String firstName;

  @override
  Map<String, dynamic> get arguments {
    return {
      'age': age,
      'firstName': firstName,
    };
  }
}

class UserQueryPayloadB with GraphQLQueryPayload {
  const UserQueryPayloadB(
    this.age,
    this.firstName,
  );

  final int age;
  final String firstName;

  @override
  Map<String, Map<String, dynamic>> get inputs {
    return {
      'userInput': {
        'age': age,
        'firstName': firstName,
      },
    };
  }
}
```

2. `GraphQLQueryBuilder` automatically replaces all argument placeholders in the query using values provided by the `GraphQLQueryPayload`. By default, GraphQLQueryBuilder uses the following prefixes:
- `%` for arguments
- `@` for input models

These default prefixes can be customized by specifying different values for `argumentPrefix` and `inputPrefix` when creating an instance of the class.

After building the query, you can use any HTTP client to perform the request, but keep in mind that the request must use the `POST` method:
```dart
final dio = Dio(BaseOptions(baseUrl: 'https://endpoint/'));

final queryBuilder = GraphQLQueryBuilder(
  transformer: (query) => query.replaceAll(RegExp(r'\s+'), ' ').trim(),
);

dio.post<dynamic>(
  'graphql/',
  data: queryBuilder.build(
    queryA, //or queryB
    UserQueryPayloadA(27, 'John'), //or UserQueryPayloadB(27, 'John')
  ),
);
```
