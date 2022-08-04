import 'package:either_dart/either.dart';
import 'package:front_end_api/app/product/domain/errors/error_type.dart';

abstract class ProductRepository {
  Future<Either<ErrorType, void>> addNewType({required String typeName});
}
