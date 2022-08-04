import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_end_api/app/product/infra/models/type_model.dart';
import 'package:front_end_api/app_colors.dart';

enum Select {
  selectType,
  selectSize,
  selectGenre,
  addNewType,
  editType,
  editSize,
  addNewSize,
  main,
}

class Register extends StatefulWidget {
  const Register({Key? key, this.product}) : super(key: key);
  final ProductModel? product;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final baseUrlTypes = "https://localhost:7239/api/product_types";
  final baseUrlSizes = "https://localhost:7239/api/product_sizes";
  final baseUrlProducts = "https://localhost:7239/api/products";

  Future<void> addNewType({required String typeName}) async {
    try {
      final dioService = Dio();

      final response =
          await dioService.post(baseUrlTypes, data: {"Name": typeName});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<TypeModel>> getTypes() async {
    try {
      final dioService = Dio();
      List<TypeModel> list = [];

      final response = await dioService.get(baseUrlTypes);
      response.data.forEach((e) => list.add(TypeModel.fromMap(e)));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteType({required int index}) async {
    try {
      final dioService = Dio();

      final response = await dioService.delete("$baseUrlTypes/$index");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> putType({required int index, required String typeName}) async {
    try {
      final dioService = Dio();

      final response = await dioService
          .put("$baseUrlTypes/$index", data: {"Name": typeName});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addNewProduct({required ProductModel product}) async {
    try {
      final dioService = Dio();

      await dioService.post(baseUrlProducts, data: product.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final dioService = Dio();
      List<ProductModel> list = [];

      final response = await dioService.get(baseUrlProducts);
      response.data.forEach((e) => list.add(ProductModel.fromMap(e)));
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

  Future<void> putProduct({
    required int id,
    required ProductModel product,
  }) async {
    try {
      final dioService = Dio();
      await dioService.put("$baseUrlProducts/$id", data: product.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addNewSize({required SizeModel size}) async {
    try {
      final dioService = Dio();

      await dioService.post(baseUrlSizes, data: size.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<SizeModel>> getSizes() async {
    try {
      final dioService = Dio();
      List<SizeModel> list = [];

      final response = await dioService.get(baseUrlSizes);
      response.data.forEach((e) => list.add(SizeModel.fromMap(e)));
      return list;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteSize({required int id}) async {
    try {
      final dioService = Dio();

      await dioService.delete("$baseUrlSizes/$id");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> putSizes({
    required int id,
    required SizeModel size,
  }) async {
    try {
      final dioService = Dio();
      await dioService.put("$baseUrlSizes/$id", data: size.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  final controllerType = TextEditingController();
  final controllerDetails = TextEditingController();
  final controllerPrice = MoneyMaskedTextController(
    leftSymbol: "R\$",
    decimalSeparator: ",",
    thousandSeparator: ".",
    initialValue: 0.0,
    precision: 2,
  );
  final controllerSize = TextEditingController();
  final controllerQuantity = TextEditingController();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();

  List<TypeModel> types = [];
  List<SizeModel> sizes = [];
  bool loading = true;
  TypeModel? editTypeModel;
  SizeModel? editSizeModel;
  ProductModel? editProductModel;
  TypeModel? selectedType;
  String repoSize = "";
  bool selectedSize = false;
  bool selectedTypeValid = false;

  @override
  void initState() {
    if (widget.product != null) {
      editProductModel = widget.product;
      controllerDetails.text = editProductModel!.details;
      controllerPrice.updateValue(editProductModel!.price);
      selectedType = editProductModel!.type;
      sizes.addAll(editProductModel!.sizes!);
    }

    super.initState();
    getTypes().then((value) {
      setState(() {
        types = value;
        loading = false;
      });
    });
  }

  Select currentSelect = Select.main;

  @override
  Widget build(BuildContext context) {
    switch (currentSelect) {
      case Select.main:
        return _buildMainSelect();
      case Select.selectType:
        return _buildTypeSelect();
      case Select.addNewType:
        return _buildAddNewType();
      case Select.editType:
        return _buildAddNewType();
      case Select.selectSize:
        return _buildSizeSelect();
      case Select.addNewSize:
        return _buildAddNewSize();
      case Select.editSize:
        return _buildAddNewSize();
      default:
        return _buildMainSelect();
    }
  }

  _buildMainSelect() {
    return Container(
      height: 600,
      width: 400,
      padding: const EdgeInsets.symmetric(vertical: 38),
      child: Form(
        key: formkey1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: 297,
                child: Text(
                  "Cadastro de Produto",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildFormField(
                title: "Detalhes",
                placeholder: "Informe os detalhes do produto",
                controller: controllerDetails,
                textValidator: "Informe os detalhes do produto",
              ),
              _buildFormField(
                title: "Preço",
                placeholder: "Informe o preço do produto",
                controller: controllerPrice,
                textValidator: "Informe o preço",
                validatorPrice: true,
              ),
              _buildDropdown(
                title: "Tipo",
                placeholder: selectedType != null
                    ? selectedType!.name
                    : "Selecione um tipo",
                select: Select.selectType,
              ),
              if (selectedType == null)
                const SizedBox(
                  height: 10,
                ),
              if (selectedType == null)
                const SizedBox(
                  width: 297,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Adicione os tamanhos",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              _buildDropdown(
                title: "Tamanhos",
                placeholder: sizes.isEmpty
                    ? "Adicionar tamanhos"
                    : sizes.map(
                        (e) {
                          if (e.size != sizes.last.size) {
                            return "${e.size}, ";
                          }
                          return e.size;
                        },
                      ).reduce((value, element) => value + element),
                select: Select.selectSize,
              ),
              if (sizes.isEmpty)
                const SizedBox(
                  height: 10,
                ),
              if (sizes.isEmpty)
                const SizedBox(
                  width: 297,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Adicione os tamanhos",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: 297,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentSelect = Select.main;
                          Navigator.pop(context);
                          controllerType.clear();
                          controllerDetails.clear();
                          controllerPrice.clear();
                          controllerQuantity.clear();
                          controllerSize.clear();
                        });
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
                        if (formkey1.currentState!.validate() &&
                            sizes.isNotEmpty &&
                            selectedType != null) {
                          final product = ProductModel(
                            id: null,
                            details: controllerDetails.text,
                            price: controllerPrice.numberValue,
                            type: selectedType,
                            sizes: null,
                          );

                          if (editProductModel != null) {
                            await putProduct(
                              id: editProductModel!.id!,
                              product: product,
                            );
                            sizes.removeWhere(
                              (element) => editProductModel!.sizes!
                                  .where(
                                      (element2) => element.id == element2.id)
                                  .isNotEmpty,
                            );
                          } else {
                            await addNewProduct(product: product);
                          }
                          final products = await getProducts();

                          products.sort((a, b) => a.id! > b.id! ? 1 : -1);
                          for (var element in sizes) {
                            element.productId = products.last.id;
                            await addNewSize(size: element);
                          }
                          controllerType.clear();
                          controllerDetails.clear();
                          controllerPrice.clear();
                          controllerQuantity.clear();
                          controllerSize.clear();
                          Navigator.pop(context);
                        }
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
                        "Salvar",
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
      ),
    );
  }

  _buildFormField({
    required String title,
    required String placeholder,
    required TextEditingController controller,
    required String textValidator,
    bool validatorPrice = false,
  }) {
    return SizedBox(
      width: 297,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          SizedBox(
            height: 90,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.greyLight,
                  ),
                ),
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: AppColors.greyFirst,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return textValidator;
                }
                if (validatorPrice) {
                  if (value == "R\$0,00") {
                    return textValidator;
                  }
                  return null;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildAddNewType({TypeModel? typeEdit}) {
    return Container(
      height: 300,
      width: 400,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: formkey2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 85,
                width: 297,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tipo",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 49,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.greyLight)),
                      child: TextFormField(
                        controller: controllerType,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Informe o tipo",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: AppColors.greyFirst,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Informe o tipo";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 110,
              ),
              SizedBox(
                width: 297,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentSelect = Select.selectType;
                          controllerType.clear();
                        });
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
                        if (formkey2.currentState!.validate()) {
                          if (currentSelect == Select.addNewType) {
                            await addNewType(typeName: controllerType.text);
                            setState(() {
                              currentSelect = Select.selectType;
                            });
                          } else {
                            await putType(
                              index: editTypeModel!.id,
                              typeName: controllerType.text,
                            );
                          }
                          final newList = await getTypes();
                          setState(() {
                            types = newList;
                            currentSelect = Select.selectType;
                          });
                          controllerType.clear();
                        }
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
                        "Salvar",
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
      ),
    );
  }

  _buildTypeSelect() {
    return Container(
      height: 567,
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 23),
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                setState(() {
                  currentSelect = Select.main;
                });
              },
              icon: const Icon(Icons.close),
              color: AppColors.black,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List.generate(
                      types.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedType = types[index];
                              currentSelect = Select.main;
                              selectedTypeValid = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                types[index].name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    controllerType.text = types[index].name;
                                    editTypeModel = types[index];
                                    currentSelect = Select.editType;
                                  });
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await deleteType(index: types[index].id);
                                  setState(() {
                                    types.removeWhere((element) =>
                                        element.id == types[index].id);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                "Adicionar tipo",
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentSelect = Select.addNewType;
                  });
                },
                height: 38,
                color: AppColors.secundaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildSizeSelect() {
    return Container(
      height: 567,
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 23),
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                setState(() {
                  currentSelect = Select.main;
                });
              },
              icon: const Icon(Icons.close),
              color: AppColors.black,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List.generate(
                      sizes.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              "Tamanho: ${sizes[index].size}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Qtd: ${sizes[index].quantity}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  controllerSize.text = sizes[index].size;
                                  controllerQuantity.text =
                                      sizes[index].quantity.toString();
                                  editSizeModel = sizes[index];
                                  repoSize = editSizeModel!.size;
                                  currentSelect = Select.editSize;
                                });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              onPressed: () async {
                                if (sizes[index].id != null) {
                                  await deleteSize(id: sizes[index].id!);
                                }
                                setState(() {
                                  sizes.removeWhere((element) =>
                                      element.id == sizes[index].id);
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                "Adicionar tamanho",
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentSelect = Select.addNewSize;
                  });
                },
                height: 38,
                color: AppColors.secundaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildAddNewSize({SizeModel? sizeEdit}) {
    return Container(
      height: 450,
      width: 400,
      padding: const EdgeInsets.symmetric(vertical: 38),
      child: Form(
        key: formkey3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 297,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tamanho",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      height: 90,
                      child: TextFormField(
                        controller: controllerSize,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColors.greyLight,
                            ),
                          ),
                          hintText: "Informe o tamanho",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: AppColors.greyFirst,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Informe o tamanho";
                          } else if (value.length > 4) {
                            return "Tamanho deve ter no maximo 4 caracteres";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 297,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quantidade",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      height: 90,
                      child: TextFormField(
                        controller: controllerQuantity,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColors.greyLight,
                            ),
                          ),
                          hintText: "Informe a quantidade",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: AppColors.greyFirst,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Informe a quantidade";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 297,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentSelect = Select.selectSize;
                          controllerType.clear();
                        });
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
                        if (formkey3.currentState!.validate()) {
                          final size = SizeModel(
                            productId: null,
                            id: null,
                            quantity: int.parse(controllerQuantity.text),
                            size: controllerSize.text,
                          );
                          if (editProductModel != null) {
                            size.productId = editProductModel!.id;
                            if (currentSelect == Select.addNewSize) {
                              setState(() {
                                sizes.add(size);
                              });
                            } else if (currentSelect == Select.editSize) {
                              if (editSizeModel!.id != null) {
                                editSizeModel!.quantity =
                                    int.parse(controllerQuantity.text);
                                editSizeModel!.size = controllerSize.text;
                                sizes.removeWhere(
                                  (element) => element.id == editSizeModel!.id,
                                );
                                setState(() {
                                  sizes.add(editSizeModel!);
                                });
                                await putSizes(
                                  id: editSizeModel!.id!,
                                  size: editSizeModel!,
                                );
                              } else {
                                if (editSizeModel != null) {
                                  sizes.removeWhere(
                                    (element) =>
                                        element.size == editSizeModel!.size,
                                  );
                                }
                                sizes.add(size);
                              }
                            }
                          } else {
                            if (editSizeModel != null) {
                              sizes.removeWhere(
                                (element) =>
                                    element.size == editSizeModel!.size,
                              );
                            }
                            sizes.add(size);
                          }
                          setState(() {
                            currentSelect = Select.main;
                          });
                          controllerSize.clear();
                          controllerQuantity.clear();
                        }
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
                        "Salvar",
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
      ),
    );
  }

  _buildDropdown({
    required String title,
    required placeholder,
    required Select select,
  }) {
    return SizedBox(
      height: 85,
      width: 297,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currentSelect = select;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 49,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.greyLight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    placeholder,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.greyFirst,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.greyFirst,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          height: 300,
          child: Column(
            children: const [
              Text("Adicionar tipo"),
            ],
          ),
        );
      },
    );
  }
}
