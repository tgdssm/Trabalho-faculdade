import 'package:either_dart/either.dart';
import 'package:flutter/widgets.dart';
import 'package:front_end_api/app/product/domain/errors/error_type.dart';
import 'package:front_end_api/app/product/domain/repositories/product_repository.dart';
import 'package:front_end_api/app/product/infra/datasources/api_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ApiDatasource apiDatasource;
  ProductRepositoryImpl(this.apiDatasource);
  @override
  Future<Either<ErrorType, void>> addNewType({
    required String typeName,
  }) async {
    try {
      await apiDatasource.addNewType(typeName: typeName);
      return Right(DoNothingAction);
    } catch (e) {
      return Left(ErrorType(e.toString()));
    }
  }
}
