# GraphQL to REST
<p>
<a href="https://pub.dev/packages/graphql_2_rest"><img src="https://img.shields.io/pub/v/graphql_2_rest.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

A simple way to convert GraphQL queries to REST in order to use any HTTP client for performing a request.

## Usage
There are 2 main things for working with `graphql_2_rest` library: `GraphQLQueryModel` and `GraphQLQueryBuilder`.

1. `GraphQLQueryModel` is responsible for putting arguments in GraphQL query. For example, if you have a query:
```dart
const query = '''query {
  user(first_name: %arg, age: %arg) {
    first_name
    last_name
    site {
      site_name
    }
  }
}''';
```
then you need to create next `GraphQLQueryModel`:
```dart
class UserQueryModel with GraphQLQueryModel {
  const UserQueryModel(
    this.age,
    this.firstName,
  );
  
  final int age;
  final String firstName;
  
  @override
  List<String> get arguments => ['"$firstName"', '$age'];
}
```

2. `GraphQLQueryBuilder` will replace all arguments consistently in the query using `GraphQLQueryModel`. By default, `GraphQLQueryBuilder` uses `%arg` mask for arguments, but it can be changed while creating instance of this class.
Finally you can use any HTTP client for performing a request, but the request have to be `POST`:
```dart
final dio = Dio(BaseOptions(baseUrl: 'https://endpoint/'));
const queryBuilder = GraphQLQueryBuilder();
dio.post<dynamic>(
  'graphql/',
  data: queryBuilder.build(
    query, 
    UserQueryModel('John', 27),
  ),
);
```
