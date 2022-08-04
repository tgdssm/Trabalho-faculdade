import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_end_api/app/product/domain/usecases/add_type.dart';
import 'package:front_end_api/app/product/infra/datasources/api_datasource.dart';
import 'package:front_end_api/app/product/infra/repositories/product_repository_impl.dart';
import 'package:mockito/mockito.dart';

class ApiDatasourceMock extends Mock implements ApiDatasource {}

void main() {
  final datasource = ApiDatasourceMock();
  final repository = ProductRepositoryImpl(datasource);
  final usecase = AddTypeImpl(repository);

  test("create type", () async {
    final result = await usecase.call("Nova Camisa");
    expect(result, isA<Right>());
  });
}
