extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item_pos = 0
var item_list = ["fireball","missiles","bomb"]
var item = item_list[0]
var s = 5
onready var spacecoinLabel = get_node("Spacecoin/Price")
onready var youDontHave = get_node("YouDontHave")

onready var nameLabel = get_node("ItemInfo/Name")
onready var priceLabel = get_node("ItemInfo/Price")
onready var sprite = get_node("sprite")
# Called when the node enters the scene tree for the first time.
func _ready():
	if "fireball" in global.weapons:
		item = item_list[1]
		item_pos = 1
		nameLabel.set_text("Missiles")
		priceLabel.set_text("$5750")
		sprite.texture = preload("res://Assets/Missile.png")
		sprite.scale = Vector2((s), (s))
	spacecoinLabel.set_text("$"+String(global.spacecoin))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_button_up():
	get_tree().change_scene("res://Hangar.tscn")


func _on_PurchaseButton_button_up():
	if item == "fireball":
		if global.spacecoin > 3000:
			if ! "fireball" in global.weapons:
				global.spacecoin -= 3000
				spacecoinLabel.set_text("$"+String(global.spacecoin))
				global.weapons.append("fireball")
			else:
				youDontHave.set_text("You already have that!")
				youDontHave.visible = true
				var t = Timer.new()
				t.set_wait_time(5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				
				youDontHave.visible = false
				youDontHave.set_text("You don't have enough spacecoin!")
				
		else:
			youDontHave.visible = true
			var t = Timer.new()
			t.set_wait_time(5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			youDontHave.visible = false
	if item == "missiles":
		if global.spacecoin > 5750:
			global.spacecoin -= 5750
			spacecoinLabel.set_text("$"+String(global.spacecoin))
			global.numOfMissiles += 50
			if ! "missile" in global.weapons:
				global.weapons.append("missile")
		else:
			youDontHave.visible = true
			var t = Timer.new()
			t.set_wait_time(5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			youDontHave.visible = false
	if item == "bomb":
		if global.spacecoin > 2000:
			if global.bomb_bay >= global.bombs:
				global.spacecoin -= 2000
				spacecoinLabel.set_text("$"+String(global.spacecoin))
				global.bombs += 1
			else:
				youDontHave.set_text("You must upgrade your bomb bay \nto buy that!")
				youDontHave.visible = true
				var t = Timer.new()
				t.set_wait_time(5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				
				youDontHave.visible = false
				youDontHave.set_text("You don't have enough spacecoin!")
		else:
			youDontHave.visible = true
			var t = Timer.new()
			t.set_wait_time(5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			youDontHave.visible = false
		


func _on_RightButton_button_up():
	if item_pos < len(item_list) - 1:
		item_pos += 1
	else:
		item_pos = 0
	item = item_list[item_pos]
	if item == "fireball":
		nameLabel.set_text("Fireball")
		priceLabel.set_text("$3000")
		sprite.texture = preload("res://Assets/fireball.png")
		sprite.scale = Vector2((s), (s))
	if item == "missiles":
		nameLabel.set_text("Missiles")
		priceLabel.set_text("$5750")
		sprite.texture = preload("res://Assets/Missile.png")
		sprite.scale = Vector2((s), (s))
	if item == "bomb":
		nameLabel.set_text("Bomb")
		priceLabel.set_text("$2000")
		sprite.texture = preload("res://Assets/bomb.png")
		sprite.scale = Vector2((s), (s))


func _on_LeftButton_button_up():
	if item_pos <= 0:
		item_pos = len(item_list) - 1
	else:
		item_pos -= 1
	item = item_list[item_pos]
	if item == "fireball":
		nameLabel.set_text("Fireball")
		priceLabel.set_text("$3000")
		sprite.texture = preload("res://Assets/fireball.png")
		sprite.scale = Vector2((s), (s))
	if item == "missiles":
		nameLabel.set_text("Missiles")
		priceLabel.set_text("$5750")
		sprite.texture = preload("res://Assets/Missile.png")
		sprite.scale = Vector2((s), (s))
	if item == "bomb":
		nameLabel.set_text("Bomb")
		priceLabel.set_text("$2000")
		sprite.texture = preload("res://Assets/bomb.png")
		sprite.scale = Vector2((s), (s))
