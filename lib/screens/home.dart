import 'dart:async';

import 'package:myDemo/model/employee_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myDemo/screens/const.dart';
import 'package:myDemo/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PageState { stateActive, stateLoading, stateError, stateActiveLoading }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dio = Dio();
  List<Data> listEmployeeData = [];
  bool isLoading = false;
  bool isVisible = false;
  int shoppingCount = 0;
  final StreamController<PageState> _pageStateStreamController =
      StreamController<PageState>();
  int _pageStatusCode = 0;
  int get pageStatusCode => _pageStatusCode;
  setPageStatusCode(int value) => _pageStatusCode = value;
  StreamSink<PageState> get pageStateSink => _pageStateStreamController.sink;
  Stream<PageState> get pageStateStream => _pageStateStreamController.stream;

  Stream<List<Data>> _getEmployee() async* {
    try {
      // final response = await dio.get(
      //   'https://dummy.restapiexample.com/api/v1/employees',
      //   options: Options(
      //     sendTimeout: const Duration(seconds: 1),
      //     receiveTimeout: const Duration(seconds: 1),
      //   ),
      // );

      listEmployeeData = employeeDataList.map((e) => Data.fromJson(e)).toList();
      // if (response.statusCode == 200) {
      //   // List listData = response.data['data'] as List;
      //   // listEmployeeData = listData.map((e) => Data.fromJson(e)).toList();
      //   shoppingCount = listEmployeeData.length;
      //   pageStateSink.add(PageState.stateActive);
      // } else if (response.statusCode == 500) {
      //   debugPrint('Internal Server Error');
      // }
      pageStateSink.add(PageState.stateActive);
      yield listEmployeeData;
    } on DioException catch (e) {
      setState(() => isLoading = false);
      if (e.response != null) {
        debugPrint('----data> ${e.response!.data}');
        debugPrint('----headers> ${e.response!.headers}');
        debugPrint('----requestOptions> ${e.response!.requestOptions}');
      } else {
        debugPrint('----e> $e');
        debugPrint('----requestOptions> ${e.requestOptions}');
        debugPrint('----message> ${e.message}');
      }
      yield listEmployeeData;
    }
  }

  @override
  void initState() {
    _getEmployee();
    super.initState();
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefLoginKey, false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Data>>(
      stream: _getEmployee(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          setPageStatusCode(0);
        } else {
          if (snapshot.hasError) {
          setPageStatusCode(2);
        } else if (snapshot.hasData) {
          setPageStatusCode(1);
        }
        }
        return Scaffold(
          appBar: AppBar(),
          body: snapshot.connectionState == ConnectionState.waiting
              ? _loadingWidgetLinear()
              : ListView.builder(
                  itemCount: listEmployeeData.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.yellow.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "id : ${listEmployeeData[index].id.toString()}"),
                                  Text(
                                      "employee_age : ${listEmployeeData[index].employeeAge.toString()}"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "employee_name : ${listEmployeeData[index].employeeName.toString()}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible:
                                    listEmployeeData[index].employeeSalary! <
                                        100000,
                                child: Text(
                                    "employee_salary : ${listEmployeeData[index].employeeSalary.toString()}"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _loadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _loadingWidgetLinear() {
    return Column(
      children: const [
        Center(
            child: LinearProgressIndicator(
          color: Colors.red,
          minHeight: 35,
        ),
        ),
      ],
    );
  }
}
