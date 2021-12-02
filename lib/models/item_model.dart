class ItemModel {
  String name;
  String type;
  int qty;
  String image_path;
  String barcode;
  int price;
  
  ItemModel({required this.name, required this.barcode, required this.image_path, required this.price, required this.qty, required this.type});
  
  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(name: json['name'], barcode: json['barcode'], image_path: json['image_path'], price: json['price'], qty: json['qty'], type: json['type']);
  
  Map<String, dynamic> toJson(){
    return {
      "name" : name,
      "type" : type,
      "qty": qty,
      "image_path": image_path,
      "barcode" : barcode,
      "price" : price
    };
  }
}


List<ItemModel> dummyItemModel = [
  ItemModel(name: "SAMPOERNA KRETEK 12", barcode: "8999909085114", image_path: "https://images.tokopedia.net/img/cache/500-square/product-1/2020/8/21/33032584/33032584_5326023d-5278-4e6d-9026-aba1754535e3_517_517", price: 12800, qty: 100, type: "bungkus"),
  ItemModel(name: "TARO POTATO 40G", barcode: "8999999000066", image_path: "https://images.tokopedia.net/img/cache/500-square/product-1/2019/9/10/71160237/71160237_50b7495a-77e3-4d09-81b3-6ac352752412_1000_1000", price: 4400, qty: 100, type: "bungkus"),
  ItemModel(name: "CHEETOS JAGUNG BAKAR 40G", barcode: "89686600247", image_path: "https://images.tokopedia.net/img/cache/500-square/attachment/2020/4/26/15878542623331/15878542623331_f9a345b9-f15b-4400-9c2d-0887a63fd612.png", price: 4990, qty: 100, type: "bungkus"),
  ItemModel(name: " AXE DARK TEMPT KLG", barcode: "4800888141125", image_path: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/10/26/390abe76-2ebb-4f1c-aff7-2624b8de5e5c.jpg", price: 37000, qty: 100, type: "botol"),
  ItemModel(name: "BIMOLI PCH 2000mL", barcode: "8992628020152", image_path: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/9/17/ba4ae59d-071f-438a-8003-5a9e5286a750.png", price: 37600, qty: 100, type: "pack"),
];