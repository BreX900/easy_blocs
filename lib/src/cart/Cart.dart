import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';


part 'Cart.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Cart {
  final List<ProductCart> products;

  Cart(this.products) : assert(products != null);

  ProductCart getProduct(String id) {
    return products.firstWhere((item) => item.id == id);
  }

  bool increment(String id) {
    _update(getProduct(id), 1);
    return true;
  }

  bool decrease(String id) {
    final product = getProduct(id);
    if (product == null) return false;
    if (product.numItemsOrdered <= 1) {
      products.remove(product);
    } else {
      _update(product, -1);
    }
    return true;
  }

  _update(ProductCart product, int value) {
    products.remove(product);
    products.add(ProductCart(
        numItemsOrdered: product.numItemsOrdered+value, id: product.id));
  }

  Iterable<String> get idProducts => products.map((prod) => prod.id);
  static Cart fromJson(Map json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}


@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductCart {
  final int numItemsOrdered;

  final String id;

  ProductCart({
    this.numItemsOrdered: 0, @required this.id,
  }): assert(numItemsOrdered != null), assert(id != null);

  @override
  bool operator ==(o) => o is ProductCart && o.id == id;

  @override
  int get hashCode => hash(id);

  static ProductCart fromJson(Map json) => _$ProductCartFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCartToJson(this);
}


