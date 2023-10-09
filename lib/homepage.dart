import 'package:flutter/material.dart';
import 'package:crud_flutter/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _itens = [];

  bool _isLoading = true;
  //Atualizando itens
  void _reloadItens() async {
    final data = await SQLHelper.getItens();
    setState(() {
      _itens = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadItens();
  }

  //Controladores para receber os dados de title e desc
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  //Criando item no banco de dados
  Future<void> _addItem() async {
    await SQLHelper.createDate(_titleController.text, _descController.text);
    _reloadItens();
  }

  //Atualizando item
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _descController.text);
    _reloadItens();
  }

  //Removendo item
  Future<void> _deleteItem(int id) async {
    await SQLHelper.deteleItem(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Item removido")));
    _reloadItens();
  }

  //Verifica se os campos estão preenchidos
  void showButtomSheet(int? id) async {
    if (id != null) {
      final haveData = _itens.firstWhere((element) => element['id'] == id);
      _titleController.text = haveData['title'];
      _descController.text = haveData['desc'];
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
            child: Text(
          "Flutter CRUD",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _itens.length,
              itemBuilder: (context, index) {
                Card(
                  child: ListTile(
                    title: Text(
                      _itens[index]['title'],
                      style: TextStyle(fontSize: 25),
                    ),
                    subtitle: Text(
                      _itens[index]['desc'],
                      style: TextStyle(),
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
