class_name OrderInstance

var id: int
var state: int
var created_at: float
var data: ItemInstance

enum State { CREATED, PACKING, SENT, COMPLETED }

func _init(_id, _data):
	id = _id
	state = State.CREATED
	created_at = Time.get_unix_time_from_system()
	data = _data
