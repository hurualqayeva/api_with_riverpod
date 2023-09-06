import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/model.dart';
import '../server/server.dart';



class Lists extends ConsumerWidget {
  const Lists({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Employee list'))),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmployeeListPage(),
              ),
            );
          },
          child: const Text('Load Employee List'),
        ),
      ),
    );
  }
}

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: EmployeeList(),
    );
  }
}

class EmployeeList extends ConsumerWidget {
  const EmployeeList({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Riverpod>?> data = ref.watch(userProvider);

    return data.when(
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (data) {
        if (data == null || data.isEmpty) {
          return Center(child: Text('No data available'));
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(data[index].name),
              subtitle: Text(data[index].company.name),
              leading: Text(data[index].id.toString()),
            );
          },
        );
      },
    );
  }
}

final userProvider = FutureProvider<List<Riverpod>?>((ref) async {
  final content = await getUsers();
  return content;
});

class UserNotifier extends StateNotifier<List<Riverpod>?> {
  UserNotifier() : super(null);

  Future<void> fetchUsers() async {
    try {
      final content = await getUsers();
      state = content;
    } catch (error) {
      state = <Riverpod>[]; 
    }
  }
}
