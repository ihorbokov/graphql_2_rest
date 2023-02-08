import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graphql_2_rest/graphql_2_rest.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'GraphQL to REST Demo',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _missionName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SpaceX mission name:',
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              _missionName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              onPressed: _getMissionName,
              child: const Text(
                'Get mission',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getMissionName() async {
    const query = '''query {
      launchesPast(limit: %arg) {
        mission_name
        launch_date_local
        launch_site {
          site_name_long
        }
      }
    }''';

    final dio = Dio(BaseOptions(baseUrl: 'https://api.spacex.land/'));
    const queryBuilder = GraphQLQueryBuilder();
    final response = await dio.post<dynamic>(
      'graphql/',
      data: queryBuilder.build(query, LimitQueryModel(5)),
    );

    setState(() {
      final data = response.data['data'];
      _missionName = data['launchesPast'][0]['mission_name'] as String;
    });
  }
}

class LimitQueryModel with GraphQLQueryModel {
  LimitQueryModel(this.limit);

  final int limit;

  @override
  List<String> get arguments => ['$limit'];
}
