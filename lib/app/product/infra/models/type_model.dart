class TypeModel {
  late int id;
  late String name;

  TypeModel({required this.id, required this.name});

  factory TypeModel.fromMap(Map<String, dynamic> map) => TypeModel(
        id: map["id"],
        name: map["name"],
      );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }
}

class SizeModel {
  late int? productId;
  late int? id;
  late int quantity;
  late String size;

  SizeModel({
    required this.productId,
    required this.id,
    required this.quantity,
    required this.size,
  });

  factory SizeModel.fromMap(Map<String, dynamic> map) => SizeModel(
        productId: map["productId"],
        id: map["id"],
        quantity: map["quantity"],
        size: map["size"],
      );

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "quantity": quantity,
      "size": size,
    };
  }
}

class ProductModel {
  final int? id;
  late String details;
  late double price;
  late TypeModel? type;
  late List<SizeModel>? sizes;

  ProductModel({
    required this.id,
    required this.details,
    required this.price,
    required this.type,
    required this.sizes,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map["id"],
        details: map["details"],
        price: map["price"],
        type: TypeModel.fromMap(map["productType"]),
        sizes: map["productSizes"] == null
            ? []
            : List.generate(
                map["productSizes"].length,
                (index) => SizeModel.fromMap(
                  map["productSizes"][index],
                ),
              ),
      );

  Map<String, dynamic> toMap() {
    return {
      "details": details,
      "price": price,
      "productTypeId": type!.id,
    };
  }
}
