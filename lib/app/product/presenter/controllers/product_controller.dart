import 'package:flutter/widgets.dart';
import 'package:front_end_api/app/product/domain/usecases/add_type.dart';
import 'package:front_end_api/app/product/external/datasources/api_datasource_impl.dart';
import 'package:front_end_api/app/product/infra/repositories/product_repository_impl.dart';

abstract class ProductController {
  abstract TextEditingController controllerType;
  Future<void> addType();
}

class ProductControllerImpl implements ProductController {
  late ApiDataSourceImpl datasource;
  late ProductRepositoryImpl productRepository;
  late AddTypeImpl addTypeUseCase;

  ProductControllerImpl() {
    datasource = ApiDataSourceImpl();
    productRepository = ProductRepositoryImpl(datasource);
    addTypeUseCase = AddTypeImpl(productRepository);
  }

  @override
  TextEditingController controllerType = TextEditingController();

  @override
  Future<void> addType() async {
    final result = await addTypeUseCase.call("Teste api");
  }
}
