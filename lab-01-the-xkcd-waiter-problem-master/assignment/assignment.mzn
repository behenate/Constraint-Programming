%Parameters
int: money_limit;
set of int: menu_items = index_set(menu_prices); 
array[int] of int: menu_prices;
array[menu_items] of string: menu_names;
array[menu_items] of int: yumyum_factors; 
array[menu_items] of int: available;

array [menu_items] of var 0..infinity: order;
var int: total_price = sum([order[i] * menu_prices[i] | i in menu_items]);
var int: total_yumyum = sum([yumyum_factors[i] * order[i] | i in menu_items]);

constraint total_price <= money_limit;
constraint total_price >= 0;
constraint forall(i in menu_items) (assert(menu_prices[i] > 0, "Price can't be negative!"));
constraint assert(money_limit > 0, "You have to bring some cash!");
constraint assert(length(menu_prices) == length(menu_names), "Each item should have a price assigned!");

solve maximize total_yumyum;
%Output grade me bobot
output ["\(menu_names[i]): \(order[i])\n" | i in menu_items] ++ 
       ["- total price:\t\(total_price)/\(money_limit)\n"] ++
       ["- total yumyum:\t\(total_yumyum)"];
