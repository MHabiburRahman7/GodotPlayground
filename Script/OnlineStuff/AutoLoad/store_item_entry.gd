extends Resource
class_name StoreItemEntry

var id: int = -1
var display_name: String = ""
var price: float = 0.0
var sprite_path: String = ""
var created_at: String = ""
var demand_weight: float = 1.0
var qty: int = 0

func to_dict() -> Dictionary:
	return {
		"id":           id,
		"display_name": display_name,
		"price":        price,
		"sprite_path":  sprite_path,
		"created_at":   created_at,
		"qty":          qty,
		"demand_weight": demand_weight,
	}

# only work once
# For converting uploaded item into pass-able item
func to_item_instance() -> ItemInstance:
	var data = ItemData.new()
	#data.id = -1
	data.base_price = price
	data.name = display_name
	data.stackable = false
	data.category = ""
	
	return ItemInstance.new(data)
