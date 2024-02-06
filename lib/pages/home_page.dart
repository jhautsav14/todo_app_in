import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_in/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app_in/component/myTextField.dart';
import 'package:todo_app_in/data/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  addTodo(Todo todo){
    context.read<TodoBloc>().add(
      AddTodo(todo),
    );
  }

  removeTodo(Todo todo){
    context.read<TodoBloc>().add(
      RemoveTodo(todo),
    );
  }

  alterTodo(int index){
    context.read<TodoBloc>().add(
      AlterTodo(index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context){
              TextEditingController controller1 = TextEditingController();
              TextEditingController controller2 = TextEditingController();


              return AlertDialog(
                title: const Text("Add a Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextField(hintText: "Task Title", controller: controller1),
                    const SizedBox(height: 10,),
                    MyTextField(hintText: "Task Description", controller: controller2)

                  ],
                ),
                actions: [
                  Padding(padding: EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: (){
                      addTodo(Todo(
                        title: controller1.text,
                        subtitle: controller2.text
                      ));
                      controller1.text = '';
                      controller2.text = '';
                      Navigator.pop(context);
                    },

                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child:  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Icon(
                        CupertinoIcons.check_mark,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  )
                ],

              );
            },

            
            );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
        ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Center(
          child:  Text(
            "ToDO App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context,state) {
            if(state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i){
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed:(_) {
                              removeTodo(state.todos[i]);
                            } ,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            )
                        ],
                      ),
                      child:  ListTile(
                        title: Text(
                          state.todos[i].title,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          state.todos[i].subtitle,
                          style: TextStyle(color: Colors.white, fontStyle:FontStyle.italic ),
                        ),
                        trailing:  Checkbox(
                          value: state.todos[i].isDone,
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (value){
                            alterTodo(i);
                          },
                        ),
                      ),


                    ),
                  );
                },
              );
            }else if (state.status == TodoStatus.initial){
              return const Center(child: CircularProgressIndicator(),);
            }else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}