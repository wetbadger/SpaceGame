extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var expPointsLabel = get_node("Experience/Points")
onready var hullLabel = get_node("ItemInfo/Name")
onready var gasLabel = get_node("ItemInfo2/Name")
onready var bombLabel = get_node("ItemInfo3/Name")
onready var u1 = get_node("UpgradeButton")
onready var u2 = get_node("UpgradeButton2")
onready var u3 = get_node("UpgradeButton3")

# Called when the node enters the scene tree for the first time.
func _ready():
	expPointsLabel.set_text("Upgrade Points: "+String(global.expPoints))
	hullLabel.set_text("Hull: "+String(global.hull))
	gasLabel.set_text("Gas Port: "+String(global.gas_port_level))
	bombLabel.set_text("Bomb Bay: "+String(global.bomb_bay))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func youDontHave():
	pass

func _on_BackButton_button_up():
	queue_free()
	get_tree().change_scene("res://Hangar.tscn")


func _on_UpgradeButton_button_up():
	if global.expPoints > 0:
		global.hull += 1
		global.expPoints -= 1
		expPointsLabel.set_text("Upgrade Points: "+String(global.expPoints))
		hullLabel.set_text("Hull: "+String(global.hull))
	else:
		youDontHave()


func _on_UpgradeButton2_button_up():
	if global.expPoints > 0:
		global.gas_port_level += 1
		global.expPoints -= 1
		expPointsLabel.set_text("Upgrade Points: "+String(global.expPoints))
		gasLabel.set_text("Gas Port: "+String(global.gas_port_level))
	else:
		youDontHave()


func _on_UpgradeButton3_button_up():
	if global.expPoints > 0:
		global.bomb_bay += 1
		global.expPoints -= 1
		expPointsLabel.set_text("Upgrade Points: "+String(global.expPoints))
		bombLabel.set_text("Bomb Bay: "+String(global.bomb_bay))
	else:
		youDontHave()
