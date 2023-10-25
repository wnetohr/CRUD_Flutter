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
    print('to tentando');
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
    print('dentro do initstate');
  }

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
  void showBottomSheet(int? id) async {
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
              padding: EdgeInsets.only(
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Título'),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    maxLines: 4,
                    controller: _descController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Descrição'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addItem();
                        } else {
                          await _updateItem(id);
                        }
                        //Limpando campos
                        _titleController.text = '';
                        _descController.text = '';
                        //Saindo da tela de edição
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Adicionar' : 'Atualizar'),
                    ),
                  )
                ],
              ),
            ));
  }

  //Controladores para receber os dados de title e desc
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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
              itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () => showBottomSheet(_itens[index]['id']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async { await _deleteItem(_itens[index]['id']);},
                      ),
                      title: Text(
                        _itens[index]['title'],
                        style: TextStyle(fontSize: 25),
                      ),
                      subtitle: Text(
                        _itens[index]['desc'],
                        style: TextStyle(),
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
