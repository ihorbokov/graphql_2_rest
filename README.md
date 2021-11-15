# GraphQL to REST
A simple way to convert GraphQL queries to REST.

## Usage
There are 2 main things for working with `graphql_2_rest` library: `GraphQLQueryModel` and `GraphQLQueryBuilder`.

1. `GraphQLQueryModel` is responsible for putting arguments in GraphQL query. For example, if you have next query:
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
  final String firstName;
  final int age;

  const UserQueryModel(this.firstName, this.age);

  @override
  List<String> get arguments => ['"$firstName"', '$age'];
}
```

2. `GraphQLQueryBuilder` will replace all arguments in the query consistently using `GraphQLQueryModel`. By default, `GraphQLQueryBuilder` has `%arg` mask for arguments, but it can be changed while creating instance of this class.
Finally you can use any http client for performing a request, but the request should be `POST`:
```dart
final dio = Dio(BaseOptions(baseUrl: 'https://any.endpoint/'));
const queryBuilder = GraphQLQueryBuilder();
dio.post<dynamic>(
  'graphql/',
  data: queryBuilder.build(query, UserQueryModel('John', 27)),
);
```
