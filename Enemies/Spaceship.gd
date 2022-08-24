extends Area2D


var rng = RandomNumberGenerator.new()
var spin = RandomNumberGenerator.new()
var x_axis = 0
onready var player = get_parent().get_node("Space/Player")
onready var spacecoinLabel = get_parent().get_node("Space/Canvas/Sidebar/SpaceCoin")
onready var levelLabel = get_parent().get_node("Space/Canvas/Sidebar/Level")
onready var experienceLabel = get_parent().get_node("Space/Canvas/Sidebar/Experience")
onready var completion = get_parent().get_node("Space/Completion/Message")

onready var ship_sprite = get_node("spaceship")
onready var collision_shape = get_node("CollisionPolygon2D")

onready var center_engine = get_node("CenterEngine")
onready var left_engine = get_node("LeftEngine")
onready var right_engine = get_node("RightEngine")

const EXPLOSION = preload("../Effects/ParticleExplosion.tscn")
const EXPLOSION2 = preload("../Effects/ParticleExplosion2.tscn")

var ufo_speed = RandomNumberGenerator.new()
var speed = 40
# Called when the node enters the scene tree for the first time.
var speed_y = 0.5
var health = 1
var dead = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	add_to_group("mobs")
	set_process(true) # Replace with function body.

#func _on_Area2D_body_entered(body):
#	if body.name == "Player":
#		global.current_hull -= 1
#		var coords = get_position() 
#		queue_free() # Replace with function body.
#		var explosion = EXPLOSION.instance()
#		get_parent().add_child(explosion)
#		explosion.get_child(0).emitting = true
#		explosion.set_position(Vector2(coords))
#		if global.current_hull <= 0:
#
#			global.death(player.roundSpacecoin)
#
#			body.queue_free()
#			var explosion2 = EXPLOSION2.instance()
#			get_parent().add_child(explosion2)
#			explosion2.get_child(0).emitting = true
#			explosion2.set_position(Vector2(coords))
#			#get_tree().change_scene("res://Hangar.tscn")
#			completion.text = "Euchred by a UFO\nYou lost " + String(player.roundSpacecoin) + " Spacecoin\nYou lost "+String(global.experienceLost)+" experience"
#			completion.visible = true
#			player.chargeTimer.stop()
#			player.shootTimer.stop()
#			#print(global.dead)
#	if body.name == "LeftWall" or body.name == "RightWall":
#		x_axis = x_axis * -1
#	if body.name == "BottomWall" and not global.dead:
#		global.xp_up(1)
#		experienceLabel.set_text("Experience: "+String(global.experience))
#		levelLabel.set_text("Level:" + String(global.level))
#		remove_from_group("mobs")

func destroy():
	
	queue_free()
	remove_from_group("mobs")

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	call_deferred("free")


func _on_SpaceShip_area_entered(area):
	if "UFO" in area.name:
		health -= 1
		$Hit.play()
	elif "Fireball" in area.name or "Laser" in area.name:
		health -= 1
		$Hit.play()
	elif "Flameblast" in area.name:
		health -= 2
	elif "Missile" in area.name:
		$MissileHit.play()
		health -= 2
	if health <= 0 and player != null:
		var coords = get_position() 
		dead = true
		ship_sprite.queue_free()
		collision_shape.queue_free()
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.get_child(0).emitting = true
		explosion.set_position(Vector2(coords))
		#explosion.get_child(0).restart()
		global.spacecoin += 50
		player.roundSpacecoin += 50
		global.xp_up(2)
		spacecoinLabel.set_text("$"+String(global.spacecoin))
		experienceLabel.set_text("Experience: "+String(global.experience))
		levelLabel.set_text("Level:" + String(global.level))


func _on_SpaceShip_body_entered(body):
	if body.name == "Player":
		global.current_hull -= 1
		#hull._on_health_updated(global.current_hull)
		var coords = get_position() 
		queue_free() # Replace with function body.
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.get_child(0).emitting = true
		explosion.set_position(Vector2(coords))
		if global.current_hull <= 0:
			
			global.death(player.roundSpacecoin)
			
			body.queue_free()
			ship_sprite.queue_free()
			collision_shape.queue_free()
			dead = true
			var explosion2 = EXPLOSION2.instance()
			get_parent().add_child(explosion2)
			explosion2.get_child(0).emitting = true
			explosion2.set_position(Vector2(coords))
			#get_tree().change_scene("res://Hangar.tscn")
			completion.text = "Spanked by a Spaceship\nYou lost " + String(player.roundSpacecoin) + " Spacecoin\nYou lost "+String(global.experienceLost)+" experience"
			completion.visible = true
			player.chargeTimer.stop()
			player.shootTimer.stop()
			#print(global.dead)
