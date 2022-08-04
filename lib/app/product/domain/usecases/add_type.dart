import 'package:either_dart/either.dart';
import 'package:front_end_api/app/product/domain/errors/error_type.dart';
import 'package:front_end_api/app/product/domain/repositories/product_repository.dart';

abstract class AddType {
  Future<Either<ErrorType, void>> call(String typeName);
}

class AddTypeImpl implements AddType {
  ProductRepository repository;
  AddTypeImpl(this.repository);
  @override
  Future<Either<ErrorType, void>> call(String typeName) async {
    return repository.addNewType(typeName: typeName);
  }
}
