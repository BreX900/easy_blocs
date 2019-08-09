import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';
import 'package:rational/rational.dart';


part 'Cart.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Cart {
  final List<ProductCart> products;

  const Cart({this.products: const []}) : assert(products != null);

  ProductCart getProduct(String id) {
    return products.firstWhere((item) => item.id == id, orElse: () => null);
  }

  Rational getPrice(String id, Rational price) => (Rational.fromInt(getProduct(id)?.countProducts??0))*price;

  Rational getTotalPrice(List<ProductCartPriceRule> products) {
    return products.fold(Rational.zero, (price, product) => price + getPrice(product.id, product.price));
  }

  int get countProducts => products.fold(0, (value, product) => value+product.countProducts);

  bool increment(String id) {
    final product = getProduct(id);
    return product == null
        ? onInsert(ProductCart(id: id, countProducts: 1))
        : onIncrement(product.increment());
  }
  @protected
  bool onInsert(ProductCart product) {
    _update(product);
    return true;
  }
  @protected
  bool onIncrement(ProductCart product) {
    _update(product);
    return true;
  }

  bool decrease(String id) {
    var product = getProduct(id);
    if (product == null) return false;
    product = product.decrease();
    return product.countProducts <= 0
        ? onRemove(product)
        : onDecrease(product);
  }
  @protected
  bool onDecrease(ProductCart product) {
    _update(product);
    return true;
  }
  @protected
  bool onRemove(ProductCart product) {
    products.remove(product);
    return true;
  }

  _update(ProductCart product) {
    assert(product != null);
    products.remove(product);
    products.add(product);
  }

  Iterable<String> get idProducts => products.map((prod) => prod.id);
  static Cart fromJson(Map json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}


@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductCart {
  final String id;

  final int countProducts;

  ProductCart({
    @required this.id, this.countProducts: 0,
  }): assert(countProducts != null), assert(id != null);

  ProductCart decrease() {
    return copyWith(countProducts: countProducts-1);
  }

  ProductCart increment() {
    return copyWith(countProducts: countProducts+1);
  }

  @override
  bool operator ==(o) => o is ProductCart && o.id == id;

  @override
  int get hashCode => hash(id);

  String toString() => "ProductCart(id: $id, numItemsOrdered: $countProducts)";

  ProductCart copyWith({int countProducts}) {
    return ProductCart(
      id: id,
      countProducts: countProducts,
    );
  }

  static ProductCart fromJson(Map json) => _$ProductCartFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCartToJson(this);
}


abstract class ProductCartPriceRule {
  String get id;
  Rational get price;
}