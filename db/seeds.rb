ProductCategory.delete_all
coins = ProductCategory.create! name: "coins"
# ebikes = ProductCategory.create! name: "e-bikes"
# ProductCategory.create! name: "kids bikes & accessories"
# ProductCategory.create! name: "parts"
# ProductCategory.create! name: "bikes accessories"
# ProductCategory.create! name: "clothing & shoes"

Product.delete_all
Product.create! name: "10 coins", price: 1, coin_value: 10, active: true, product_category: coins
Product.create! name: "100 coins", price: 10, coin_value: 100, active: true, product_category: coins
Product.create! name: "200 coins", price: 15, coin_value: 200, active: true, product_category: coins
Product.create! name: "500 coins", price: 20, coin_value: 500, active: true, product_category: coins
