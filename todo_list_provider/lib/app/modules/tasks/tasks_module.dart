import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/models/todo_list_module.dart';
import 'package:todo_list_provider/app/modules/tasks/task_Create_page.dart';
import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(
          bindings: [
            ChangeNotifierProvider(create: (context) => TaskCreateController())
          ],
          routers: {
            '/task/create': (context) => TaskCreatePage(
                  controller: context.read(),
                ),
          },
        );
}
