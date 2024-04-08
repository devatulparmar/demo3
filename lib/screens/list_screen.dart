import 'package:flutter/material.dart';
import 'package:myDemo/screens/const.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List _list = [];

  bool isVisible = false;

  Future fetchData() async {
    try {
      _list = employeeDataList;
      setState(() {});
    } catch (e) {
      debugPrint('error $e');
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    print('$isVisible');
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: Card(
                    child: Center(child: Column(
                      children: [
                        Text(_list[index]['employee_name']),
                        Visibility(
                            visible: isVisible,
                            child: Text(_list[index]['employee_salary'].toString())),
                        Text(_list[index]['employee_age'].toString()),
                      ],
                    )),
                  ),
                );
              },
            );
          } else if (asyncSnapshot.hasError) {
            return const Text('Error');
          } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
    );
  }
}
