extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_pause_state

func _input(event):
	if event.is_action_pressed("pause") and not global.dead:
		new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var player = get_parent().get_node("/root/Space/Player")

func _on_Resume_pressed():
	new_pause_state = false
	get_tree().paused = new_pause_state
	visible = false


func _on_Quit_pressed():
	#save_game()
	get_tree().quit()
	
#func save_game():
#	var save = save()
#	var save_file = File.new()
#	save_file.open("user://savefile.save", File.WRITE)
#	save_file.store_line(to_json(save))
#	print("Saved!")
#	save_file.close()
#
#func save():
#	var save_dict = {
#		"spacecoin" : global.spacecoin,
#		"experience" : global.experience,
#		"level" : global.level,
#		"weapons" : global.weapons,
#		"selected weapon" : global.selectedWeapon,
#		"missiles" : global.numOfMissiles,
#		"hull" : global.hull,
#		"rate of fire" : global.gas_port_level,
#		"bomb bay" : global.bomb_bay,
#		"bombs" : global.bombs,
#		"experience points" : global.expPoints
#	}
#	return save_dict
