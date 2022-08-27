extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_pause_state
onready var areYouSure = get_node("../BlackOverlay2")


func _input(event):
	if event.is_action_pressed("pause"):
		new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savefile.save"):
		print("Save not found")
		return # Error! We don't have a save to load.
	save_game.open("user://savefile.save", File.READ)
	var data = parse_json(save_game.get_line())
	global.spacecoin = data["spacecoin"]
	global.experience = data["experience"]
	global.level = data["level"]
	global.weapons = data["weapons"]
	global.selectedWeapon = data["selected weapon"]
	global.numOfMissiles = data["missiles"]
	global.hull = data["hull"]
	global.gas_port_level = data["gas port level"]
	global.bomb_bay = data["bomb bay"]
	global.bombs = data["bombs"]
	global.expPoints = data["experience points"]


func _on_Yes_button_up():
	var save_file = File.new()
	save_file.open("res://savefile.save", File.WRITE)
	save_file.store_line(str(0))
	save_file.store_line(str(0))
	print("New Game!")
	save_file.close()
	if get_tree().change_scene("res://Hangar.tscn") != OK:
		print("There was an error")


func _on_No_button_up():
	areYouSure.visible = false


func _on_Instructions_button_up():
	if get_tree().change_scene("res://Instructions.tscn") != OK:
		print("There was an error")


func _on_NewGame_button_up():
	var save_game = File.new()
	if save_game.file_exists("user://savefile.save"):
		areYouSure.visible = true
	else:
		var save_file = File.new()
		save_file.open("res://savefile.save", File.WRITE)
		save_file.store_line(str(0))
		save_file.store_line(str(0))
		print("New Game!")
		save_file.close()
		if get_tree().change_scene("res://Hangar.tscn") != OK:
			print("There was an error")


func _on_Resume_button_up():
	load_game()
	if get_tree().change_scene("res://Hangar.tscn") != OK:
		print("There was an error")


func _on_Quit_button_up():
	get_tree().quit()


func _on_About_button_up():
	if get_tree().change_scene("res://About.tscn") != OK:
		print("There was an error")
