import 'package:firefire/services/firebase_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud Leonardo'),
      ),
      body: FutureBuilder(
        future: getPeople(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index){
                return  Dismissible(
                  onDismissed: (direction)async{
                    await deletePeople(snapshot.data?[index]['uid']);
                    snapshot.data?.removeAt(index);
                  },
                  confirmDismiss: (direction)async{
                    bool result = false;

                    result = await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('¿Estas seguro de que quieres eliminar a ${snapshot.data?[index]['name']}?'),
                        actions: [
                          TextButton(onPressed: (){
                            return Navigator.pop(
                              context,
                              false,
                            );
                          },
                          child: const Text('Cancelar',
                          style:TextStyle(color: Colors.pink))),

                          TextButton(onPressed: (){
                            return Navigator.pop(
                              context,
                              true,
                            );
                          },
                          child: const Text('Aceptar',
                          style:TextStyle(color: Colors.grey)))
                        ],
                      );
                    });
                    return result;
                  },
                  background: Container(
                    color: Colors.pink,
                    child: Icon(Icons.delete),
                  ),
                  direction: DismissDirection.startToEnd,
                  key: Key(snapshot.data?[index]['uid']),
                  child: ListTile(
                    title: Text(snapshot.data?[index]['name']),
                    onTap: (() async{
                      await Navigator.pushNamed(context, '/edit',
                          arguments:{
                            "name": snapshot.data?[index]['name'],
                            "uid": snapshot.data?[index]['uid'],
                          });
                      setState(() {});
                    }),
                  ),
                );
              },
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
        })),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            await Navigator.pushNamed(context, '/add');
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        
    );
  }
}