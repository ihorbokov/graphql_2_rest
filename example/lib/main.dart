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
    required this.title,
    Key? key,
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
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SpaceX mission name:',
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _missionName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 8,
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
      launchesPast(@limitInput) {
        mission_name
        launch_date_local
      }
    }''';

    final dio = Dio(
      BaseOptions(baseUrl: 'https://spacex-production.up.railway.app'),
    );

    final queryBuilder = GraphQLQueryBuilder(
      transformer: (query) => query.replaceAll(RegExp(r'\s+'), ' ').trim(),
    );

    final response = await dio.post<dynamic>(
      '/',
      data: queryBuilder.build(query, LaunchesPastPayload(5)),
    );

    setState(() {
      final data = response.data['data'];
      _missionName = data['launchesPast'][0]['mission_name'] as String;
    });
  }
}

class LaunchesPastPayload with GraphQLQueryPayload {
  LaunchesPastPayload(this.limit);

  final int limit;

  @override
  Map<String, Map<String, dynamic>> get inputs {
    return {
      'limitInput': {
        'limit': limit,
      },
    };
  }
}
