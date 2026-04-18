# npc_generator_utils.gd
class_name NPCGeneratorUtils

static func name_generator():
	var vowels = ["a", "e", "i", "o", "u", "ai", "ea", "oo"]
	var consonants = [
		"b","c","d","f","g","h","j","k","l","m",
		"n","p","r","s","t","v","w","z",
		"th","sh","ch","st","gr","tr"
	]
	
	var length = randi_range(3, 6) # shorter feels more like nicknames
	var use_vowel = randi() % 2 == 0
	
	var name = ""
	
	for i in range(length):
		if use_vowel:
			name += vowels.pick_random()
		else:
			name += consonants.pick_random()
		
		use_vowel = !use_vowel
	
	# Clean up overly long results (because of clusters)
	if name.length() > 8:
		name = name.substr(0, 8)
	
	return name.capitalize()

static func order_generator():
	return {"item": "Coffee"}

static func visual_attribute_generator():
	return {"hat": "red"}
