extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 50
var health = 2000

var speed_x = 0
var speed_y = 1

var _timer = null
var _timer2 = null
var timer_started = false
var left = true

onready var player = get_node("../Space/Player")
const EXPLOSION = preload("../Effects/ParticleExplosion.tscn")
const fireball = preload("res://Enemies/Projectiles/EnemyFrbl.tscn")

onready var spacecoinLabel = get_parent().get_node("Space/Canvas/Sidebar/SpaceCoin")
onready var levelLabel = get_parent().get_node("Space/Canvas/Sidebar/Level")
onready var experienceLabel = get_parent().get_node("Space/Canvas/Sidebar/Experience")
onready var completion = get_parent().get_node("Space/Completion/Message")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bosses")
	set_process(true)

var shoot = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var motion = Vector2(speed_x, speed_y) * speed
	set_position(get_position() + motion * delta)
	#print(get_position())
	if position.y > 200:
		speed_y = 0
		speed_x = 1
		if not timer_started:
			timer_started = true
			_timer = Timer.new()
			add_child(_timer)
			_timer.connect("timeout", self, "_on_Timer_timeout")
			_timer.set_wait_time(0.3)
			_timer.set_one_shot(false) # Make sure it loops
			_timer.start()
			
			_timer2 = Timer.new()
			add_child(_timer2)
			_timer2.connect("timeout", self, "_on_Timer2_timeout")
			_timer2.set_wait_time(5)
			_timer2.set_one_shot(false) # Make sure it loops
			_timer2.start()
			
	if position.x > 400 and position.y >= 200:
		speed_x = -1
		speed_y = -1
	if position.y <= 40:
		speed_y = 1
	if position.x <= 40:
		speed_x = 1

func _on_Timer_timeout():
	if shoot == true:
		shoot()

func _on_Timer2_timeout():
	if shoot == true:
		shoot = false
		_timer2.set_wait_time(5)
	else:
		shoot = true
		_timer2.set_wait_time(2)

func shoot():
	
	if is_instance_valid(player):
		var fireball_instance = fireball.instance()
		get_parent().add_child(fireball_instance)
		if left:
			fireball_instance.set_position(get_node("CannonLeft").get_global_position())
			left = false
		else:
			fireball_instance.set_position(get_node("CannonRight").get_global_position())
			left = true
		var angle = fireball_instance.global_position.angle_to_point(player.global_position)
		fireball_instance.rotation = angle

func _on_Boss1_area_entered(area):
	if "Fireball" in area.name or "Laser" in area.name:
		health -= 1
	elif "Flameblast" in area.name:
		health -= 5
	elif "Missile" in area.name:
		health -= 5
	if health <= 0:
		var coords = get_position() 
		queue_free()
		
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.get_child(0).emitting = true
		explosion.set_position(Vector2(coords))
		#explosion.get_child(0).restart()
		global.spacecoin += 2000
		player.roundSpacecoin += 2000
		global.xp_up(1000)
		spacecoinLabel.set_text("$"+String(global.spacecoin))
		experienceLabel.set_text("Experience: "+String(global.experience))
		levelLabel.set_text("Level:" + String(global.level))
		
		global.winner = true
