import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:front_end_api/app/product/presenter/widgets/register.dart';
import 'package:front_end_api/app_colors.dart';

import '../infra/models/type_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final baseUrlProducts = "https://localhost:7239/api/products";
  bool loading = true;
  List<ProductModel> products = [];

  Future<List<ProductModel>> getProducts() async {
    loading = true;
    try {
      final dioService = Dio();
      List<ProductModel> list = [];
      final response = await dioService.get(baseUrlProducts);
      response.data.forEach((e) => list.add(ProductModel.fromMap(e)));
      loading = false;
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteProduct({required int id}) async {
    try {
      final dioService = Dio();

      await dioService.delete("$baseUrlProducts/$id");
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    getProducts().then((value) {
      setState(() {
        products.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produtos",
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => _buildProductCard(
                type: products[index].type!.name,
                sizes: products[index].sizes!,
                details: products[index].details,
                price: products[index].price,
                product: products[index],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Register(),
            ),
          ).then((value) {
            getProducts().then((value) {
              setState(() {
                products = value;
              });
            });
          });
        },
        backgroundColor: AppColors.secundaryColor,
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }

  _buildProductCard(
      {required String type,
      required List<SizeModel> sizes,
      required String details,
      required double price,
      required ProductModel product}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Register(product: product),
            ),
          ).then((value) {
            getProducts().then((value) {
              setState(() {
                products = value;
              });
            });
          });
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Deseja excluir esse produto?"),
                          const Spacer(),
                          SizedBox(
                            width: 297,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Descartar",
                                    style: TextStyle(
                                      color: AppColors.greyLight,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                MaterialButton(
                                  onPressed: () async {
                                    await deleteProduct(
                                      id: product.id!,
                                    );
                                    Navigator.pop(context);
                                  },
                                  color: AppColors.secundaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 38,
                                    vertical: 9,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Excluir",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )).then((value) {
            getProducts().then((value) {
              setState(() {
                products = value;
              });
            });
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Tipo: $type",
                style: const TextStyle(fontSize: 20),
              ),
              _verticalSpace(),
              Text(
                "Detalhes: $details",
                style: const TextStyle(fontSize: 20),
              ),
              _verticalSpace(),
              Text(
                "Tamanho e quantidade: ${sizes.map(
                  (e) {
                    if (e.size != sizes.last.size) {
                      return "${e.size} -> ${e.quantity}, ";
                    }
                    return "${e.size} -> ${e.quantity}";
                  },
                ).reduce((value, element) => value + element)}",
                style: const TextStyle(fontSize: 20),
              ),
              _verticalSpace(),
              Text(
                "Preço: ${MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ",", thousandSeparator: ".", initialValue: price).text}",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verticalSpace({double space = 13}) {
    return SizedBox(
      height: space,
    );
  }
}
