class_name Order

var id: int
var item_id: String
var state: int
var created_at: float

enum State { CREATED, PACKING, SENT, COMPLETED }

func _init(_id, _item_id):
	id = _id
	item_id = _item_id
	state = State.CREATED
	created_at = Time.get_unix_time_from_system()
