import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie/Provider/todo_provider.dart';
import 'package:movie/models/todo.dart';

class HomePage extends StatelessWidget {
  final todoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer(builder: (context, ref, child) {
        final todoData = ref.watch(todoProvider);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter a search term',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 186, 65, 65)),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                controller: todoController,
                onFieldSubmitted: (val) {
                  if (val.isEmpty) {
                    Get.defaultDialog(
                        title: 'Hold On',
                        content: Text('field can\'t be empty'));
                  } else {
                    final newTodo = Todo(
                        dateTime: DateTime.now().toString(), todo: val.trim());
                    ref.read(todoProvider.notifier).add(newTodo);
                    todoController.clear();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: todoData.length,
                      itemBuilder: (context, index) {
                        final todo = todoData[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.add_chart),
                          title: Text(todo.todo),
                          subtitle: Text(todo.dateTime),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: 'Customize todo',
                                        content: TextFormField(
                                          initialValue: todo.todo,
                                          onFieldSubmitted: (val) {
                                            final newTodo = Todo(
                                                dateTime: todo.dateTime,
                                                todo: val.trim());
                                            ref
                                                .read(todoProvider.notifier)
                                                .update(newTodo);
                                            Get.back();
                                          },
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blueGrey,
                                    )),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Get.defaultDialog(
                                          title: 'Hold On ',
                                          content: Text('Are you sure'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          todoProvider.notifier)
                                                      .remove(todo);
                                                  Get.back();
                                                },
                                                child: Text('yes')),
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text('no')),
                                          ]);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.pinkAccent,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        );
      }),
    ));
  }
}
