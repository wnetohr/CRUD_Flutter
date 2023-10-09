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
  void _reloadItens() async{
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
  Future<void> _addItem() async{
    await SQLHelper.createDate(_titleController.text,_descController.text);
    _reloadItens();
  }
  //Atualizando item
  Future<void> _updateItem(int id) async{
    await SQLHelper.updateItem(id,_titleController.text,_descController.text);
    _reloadItens();
  }
  //Removendo item
  Future<void> _deleteItem(int id) async{
    await SQLHelper.deteleItem(id);
    _reloadItens();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}