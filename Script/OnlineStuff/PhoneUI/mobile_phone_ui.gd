extends Control
class_name MobilePhoneUI
@onready var tabs = $Background/Margin/Layout/Tabs

#System's singleton
@export var order_system_path: NodePath = "/root/OrderSystemSingleton"
@onready var _order_system: OrderSystem = get_node(order_system_path) as OrderSystem
@export var inbox_system_path: NodePath = "/root/InboxSystemSingleton"
@onready var _inbox_system: InboxSystem = get_node(inbox_system_path) as InboxSystem
@export var supply_system_path: NodePath = "/root/SupplySystemSingleton"
@onready var _supply_system: SupplySystem = get_node(supply_system_path) as SupplySystem

#UI child node
@onready var _inbox_tab : InboxTab = $Background/Margin/Layout/Tabs/InboxTab
@onready var _accepted_order_tab : AcceptedOrderTab = $Background/Margin/Layout/Tabs/AcceptedOrderTab
@onready var _supply_tab : SupplyTab = $Background/Margin/Layout/Tabs/SupplyTab

func open():
	visible = true
	#get_tree().paused = false

func close():
	visible = false
	#get_tree().paused = true
	
func _ready() -> void:
	call_deferred("_setup_inbox_tab")
	call_deferred("_setup_accepted_order_tab")
	call_deferred("_setup_supply_tab")

func _setup_inbox_tab() -> void:
	#Inbox and order related logic
	if not _inbox_system.message_added.is_connected(_on_message_added):
		_inbox_system.message_added.connect(_on_message_added)
	if not _inbox_system.message_removed.is_connected(_on_message_removed):
		_inbox_system.message_removed.connect(_on_message_removed)
	if not _inbox_tab.message_order_accepted.is_connected(_on_inbox_responded):
		_inbox_tab.message_order_accepted.connect(_on_inbox_responded)

func _setup_accepted_order_tab() -> void:
	if not _accepted_order_tab.message_order_declined.is_connected(_on_message_declined):
		_accepted_order_tab.message_order_declined.connect(_on_message_declined)

func _setup_supply_tab() -> void:
	var items = _supply_system.catalogv2
	_supply_tab.populatev2(items)
	
	if not _supply_tab.order_supply_item.is_connected(_on_supply_ordered):
		_supply_tab.order_supply_item.connect(_on_supply_ordered)

func _on_supply_ordered(item: ItemInstance) -> void:
	_supply_system.orderv2(item)

func _process(delta):
	#detect the input of open_phone_input
	if Input.is_action_just_pressed("open_phone_ui"):
		open() 

func _on_message_added(message: MessageInstance) -> void:
	_inbox_tab.add_message(message)
	
func _on_message_removed(message: MessageInstance) -> void:
	_inbox_tab.remove_message(message)

func _on_inbox_responded(message: MessageInstance, is_accepted: bool) -> void:
	if is_accepted:
		print("MobilePhoneUI: received response for message accepted=%s message-id=%s" %[is_accepted, message.message_title])
		var order = _order_system.get_order_by_id(message.order_id)
		_order_system.start_packing(order)
		_accepted_order_tab.add_new_active_order(message)
		_inbox_tab.remove_message(message)
	
	_inbox_system.remove_message(message)

func _on_message_declined(message: MessageInstance, is_accepted: bool) -> void:
	if !is_accepted:
		_inbox_system.remove_message(message)
		_accepted_order_tab.remove_active_oder(message)

func _on_close_button_button_up() -> void:
	close()
