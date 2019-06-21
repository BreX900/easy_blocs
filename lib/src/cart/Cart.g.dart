// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map json) {
  return Cart((json['products'] as List)
      ?.map((e) => e == null ? null : ProductCart.fromJson(e as Map))
      ?.toList());
}

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'products': instance.products?.map((e) => e?.toJson())?.toList()
    };

ProductCart _$ProductCartFromJson(Map json) {
  return ProductCart(
      id: json['id'] as String, countProducts: json['countProducts'] as int);
}

Map<String, dynamic> _$ProductCartToJson(ProductCart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countProducts': instance.countProducts
    };
