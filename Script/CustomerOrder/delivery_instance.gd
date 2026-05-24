class_name DeliveryInstance

var id: int
var item : ItemInstance
var arriving_time: float

#just to support if this instnace needs to be pooled before flush
#will be set after the order is delivered
var delivered_id: int = -1

#TODO amount is currently disabled
var amount : int

func _init(in_id :int, in_item: ItemInstance, in_arrival_time_in_minute: int) -> void:
	id = in_id
	item = in_item
	arriving_time = in_arrival_time_in_minute
