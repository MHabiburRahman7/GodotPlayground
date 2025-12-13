extends BoxContainer

@export var dialogue_path: String = "res://Database/Dialogue/chapter1/main/chapter_1.json"

var dialogue: Dictionary
var lines: Array
var index := 0

@onready var player_label: Label = $MainPanel/PlayerNamelPanel/PlayerNameLabel
@onready var npc_label: Label = $MainPanel/NPCNamelPanel/NPCNameLabel
@onready var text_label: Label = $MainPanel/ChatPanel/ChatContentLabel

func _show_player_chat_name_label(player_name):
	player_label.visible = true
	player_label.text = player_name

func _show_npc_chat_name_label(npc_name):
	npc_label.visible = true
	npc_label.text = npc_name

func _show_chat_content(chat_text):
	text_label.visible = true
	text_label.text = chat_text
	
func _hide_chat_content():
	text_label.visible = false
	text_label.text = ""

func _show_player_chat(player_name, chat_text):
	_show_player_chat_name_label(player_name)
	_hide_npc_chat_name_label()
	_show_chat_content(chat_text)

func _show_npc_chat(npc_name, chat_text):
	_show_npc_chat_name_label(npc_name)
	_hide_player_chat_name_label()
	_show_chat_content(chat_text)
	
func _hide_player_chat_name_label():
	player_label.visible = false
	player_label.text = ""

func _hide_npc_chat_name_label():
	npc_label.visible = false
	npc_label.text = ""
	
func _clear_all():
	_hide_player_chat_name_label()
	_hide_npc_chat_name_label()
	_show_chat_content("")

func _ready():
	dialogue = DialogueLoader.load_dialogue(dialogue_path)
	if dialogue.size() == 0:
		push_error("Dialogue not loaded.")
		return
	
	lines = dialogue.get("lines", [])
	index = 0

	if lines.size() > 0:
		_show_current_line()
	else:
		push_error("Dialogue has no lines!")

func _input(event):
	if event.is_action_pressed("use"):
		_next_line()

func _show_current_line():
	var line = lines[index]

	#check who is speaking
	var npc_name = line.get("npc", "")
	var player_name = line.get("player", "")
	var chat_content = line.get("text", "")
	
	# Fill UI
	if(npc_name == "" && player_name == ""):
		print("special event detected")
		_clear_all()
		#special event
		pass
	elif(npc_name == ""):
		print("show player name: ", player_name)
		_show_player_chat(player_name, chat_content)
	else:
		print("show npc name: ", npc_name)
		_show_npc_chat(npc_name, chat_content)
	

func _next_line():
	index += 1

	if index >= lines.size():
		_end_dialogue()
		return

	_show_current_line()

func _end_dialogue():
	npc_label.text = ""
	player_label.text = ""
	text_label.text = "[ End of dialogue ]"
	# You can emit a signal here to notify other nodes
