extends Control

class_name MobilePhoneUI

@export var order_system_path: NodePath = "/root/OrderSystemSingleton"
@export var inbox_system_path: NodePath = "/root/InboxSystemSingleton"
@export var supply_system_path: NodePath = "/root/SupplySystemSingleton"

@onready var _order_system: OrderSystem       = get_node(order_system_path) as OrderSystem
@onready var _inbox_system: InboxSystem       = get_node(inbox_system_path) as InboxSystem
@onready var _supply_system: SupplySystem     = get_node(supply_system_path) as SupplySystem

@onready var tabs: TabContainer               = $Background/Margin/Layout/Tabs as TabContainer
@onready var _inbox_tab: InboxTab             = tabs.get_node("InboxTab") as InboxTab
@onready var _accepted_order_tab: AcceptedOrderTab = tabs.get_node("AcceptedOrderTab") as AcceptedOrderTab
@onready var _supply_tab: SupplyTab           = tabs.get_node("SupplyTab") as SupplyTab

var _inbox_messages:  Array[MessageInstance] = []
var _accepted_messages: Array[MessageInstance] = []

func _ready() -> void:
	_setup_inbox_tab()
	_setup_accepted_order_tab()
	_setup_supply_tab()

func _setup_inbox_tab() -> void:
	if not _inbox_system.message_added.is_connected(_on_message_added):
		_inbox_system.message_added.connect(_on_message_added)
	if not _inbox_system.message_removed.is_connected(_on_message_removed):
		_inbox_system.message_removed.connect(_on_message_removed)
	if not _inbox_tab.message_order_accepted.is_connected(_on_inbox_responded):
		_inbox_tab.message_order_accepted.connect(_on_inbox_responded)
	if not _inbox_tab.message_order_declined.is_connected(_on_inbox_responded):
		_inbox_tab.message_order_declined.connect(_on_inbox_responded)
	_inbox_tab.populate(_inbox_messages)

func _setup_accepted_order_tab() -> void:
	if not _accepted_order_tab.message_order_declined.is_connected(_on_accepted_order_declined):
		_accepted_order_tab.message_order_declined.connect(_on_accepted_order_declined)
	_accepted_order_tab.populate(_accepted_messages)

func _setup_supply_tab() -> void:
	var items: Array[ItemInstance] = _supply_system.catalogv2
	_supply_tab.populatev2(items)
	if not _supply_tab.order_supply_item.is_connected(_on_supply_ordered):
		_supply_tab.order_supply_item.connect(_on_supply_ordered)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_phone_ui"):
		visible = not visible

func _on_message_added(message: MessageInstance) -> void:
	_inbox_messages.append(message)
	_inbox_tab.populate(_inbox_messages)

func _on_message_removed(message: MessageInstance) -> void:
	_inbox_messages.erase(message)
	_inbox_tab.populate(_inbox_messages)

func _on_inbox_responded(message: MessageInstance, accepted: bool) -> void:
	if accepted:
		var order: OrderInstance = _order_system.get_order_by_id(message.order_id)
		_order_system.start_packing(order)
		_accepted_messages.append(message)
		_accepted_order_tab.populate(_accepted_messages)
	_inbox_system.remove_message(message)
	_inbox_messages.erase(message)
	_inbox_tab.populate(_inbox_messages)

func _on_accepted_order_declined(message: MessageInstance, accepted: bool) -> void:
	if not accepted:
		_accepted_messages.erase(message)
		_accepted_order_tab.populate(_accepted_messages)
		_inbox_system.remove_message(message)

func _on_supply_ordered(item: ItemInstance) -> void:
	_supply_system.orderv2(item)

func open() -> void:
	visible = true

func close() -> void:
	visible = false
