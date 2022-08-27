extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var player = get_parent().get_node("/root/Space/Player")
onready var spacecoin = get_node("VBoxContainer/SpaceCoin")
onready var level = get_node("VBoxContainer/Level")
onready var expNeeded = get_node("VBoxContainer/ExperienceNeeded")
#onready var space = get_parent().get_node("Space")
# Called when the node enters the scene tree for the first time.
func _ready():
	var bosses = get_tree().get_nodes_in_group("bosses")
	for boss in bosses:
		boss.queue_free()
	global.current_hull = global.hull
	save_game()
	spacecoin.set_text("SpaceCoin: $"+String(global.spacecoin))
	level.set_text("Level: "+String(global.level))
	expNeeded.set_text("Experience needed\nfor next level:\n"+String(pow(2, global.level + 1) * 100 - global.experience) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	if get_tree().change_scene("res://Space.tscn") != OK:
		print("There was an error")


func _on_Launch2_button_up():
	if get_tree().change_scene("res://Space.tscn") != OK:
		print("There was an error")


func save_game():
	var save = save()
	var save_file = File.new()
	save_file.open("user://savefile.save", File.WRITE)
	save_file.store_line(to_json(save))
	print("Saved!")
	save_file.close()
	
func save():
	var save_dict = {
		"spacecoin" : global.spacecoin,
		"experience" : global.experience,
		"level" : global.level,
		"weapons" : global.weapons,
		"selected weapon" : global.selectedWeapon,
		"missiles" : global.numOfMissiles,
		"hull" : global.hull,
		"gas port level" : global.gas_port_level,
		"bomb bay" : global.bomb_bay,
		"bombs" : global.bombs,
		"experience points" : global.expPoints
	}
	return save_dict


func _on_Shop_button_up():
	if get_tree().change_scene("res://Shop.tscn") != OK:
		print("There was an error")


func _on_Upgrades_button_up():
	if get_tree().change_scene("res://Upgrades.tscn") != OK:
		print("There was an error")


func _on_TextureButton_button_up():
	if get_tree().change_scene("res://MainMenu.tscn") != OK:
		print("There was an error")
