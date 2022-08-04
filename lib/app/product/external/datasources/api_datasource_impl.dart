import 'package:dio/dio.dart';
import 'package:front_end_api/app/product/infra/datasources/api_datasource.dart';

const baseUrlTypes = "https://localhost:7239/api/product_types/";

class ApiDataSourceImpl implements ApiDatasource {
  final dioService = Dio();
  @override
  Future<void> addNewType({required String typeName}) async {
    try {
      final response =
          await dioService.post(baseUrlTypes, data: {"Name": typeName});
    } catch (e) {
      throw Exception(e);
    }
  }
}
