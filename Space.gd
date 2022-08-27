extends Node2D

onready var player = get_node("Player")

const UFO_SCENE = preload("Enemies/UFO.tscn")
const BIG_UFO_SCENE = preload("Enemies/BigUFO.tscn")
const SPACESHIP_SCENE = preload("Enemies/Spaceship.tscn")
const BIG_UFO_LASER = preload("Enemies/Projectiles/BigUfoLazer.tscn")
const BOSS1 = preload("res://Enemies/Boss1.tscn")
const STAR = preload("Star.tscn")
var _timer = null
var starTimer = null
var spaceshipTimer = null
var spaceshipTimer2 = null
var bigUfoTimers = []
onready var spacecoin = get_node("Canvas/Sidebar/SpaceCoin")
onready var experience = get_node("Canvas/Sidebar/Experience")
onready var level = get_node("Canvas/Sidebar/Level")
onready var hull = get_node("Hull/HealthBar")
#var ufoCount = RandomNumberGenerator.new() #how many ufos are spawned at once
var randPos = RandomNumberGenerator.new()
var randPos2 = RandomNumberGenerator.new()
var rng = RandomNumberGenerator.new()
var total_num_of_ufos = 0
var difficulty = 1
var boss1
var number_of_enemies = 35 * global.level

onready var completion = get_node("../Space/Completion/Message")

var spaceshipOnScreen = false
var spaceShipArray = []

var rand_position = null
var rand_position2 = null
var randSet = false
var rand2Set = false

var sh_time_to_end = 0

var random_ship_turning_point = 0
var ship_left_right = 0
var ship_turned = []
var ship_turn_points = []
var ship_count = 5
var ship_count2 = 7
var ship_i = 0
var ship_i2 = 0
var ship_set_count = 0
var ship_sets = 5
var send_ships = true

var array_of_big_ufos = []
var array_of_big_ufo_lazers = []
var array_of_big_ufo_lazer_angles = []
var bigUfoOnScreen = false

var boss = false
var bossStart = false

func _ready():
	boss1 = BOSS1.instance()
	hull._on_max_health_updated(global.hull - 1)
	hull._on_health_updated(global.current_hull - 1)
	#random spaceship turning point
	rng.randomize()
	random_ship_turning_point = rng.randi_range(1, 9)
	rng.randomize()
	ship_left_right = rng.randi_range(0, 1)
	rng.randomize()
	ship_count = rng.randi_range(5, 20)
		
	completion = get_node("../Space/Completion/Message")
	completion.visible = false

	
	spacecoin.set_text("$"+String(global.spacecoin))
	experience.set_text("Experience: "+String(global.experience))
	
	level.set_text("Level:" + String(global.level))
	#ufo timer
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(3)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	#space ship timer
	spaceshipTimer = Timer.new()
	add_child(spaceshipTimer)

	spaceshipTimer.connect("timeout", self, "_on_spaceshipTimer_timeout")
	spaceshipTimer.set_wait_time(3)
	spaceshipTimer.set_one_shot(false) # Make sure it loops
	spaceshipTimer.start()
	
	if global.level >= 4:
		ship_sets = 5
		spaceshipTimer2 = Timer.new()
		add_child(spaceshipTimer2)

		spaceshipTimer2.connect("timeout", self, "_on_spaceshipTimer2_timeout")
		spaceshipTimer2.set_wait_time(3)
		spaceshipTimer2.set_one_shot(false) # Make sure it loops
		spaceshipTimer2.start()
		
	if global.level >= 5:
		boss = true
	
	starTimer = Timer.new()
	add_child(starTimer)

	starTimer.connect("timeout", self, "_on_starTimer_timeout")
	starTimer.set_wait_time(0.1)
	starTimer.set_one_shot(false) # Make sure it loops
	starTimer.start()
	set_process(true)
	
func _on_starTimer_timeout():
	var star = STAR.instance()
	get_parent().add_child(star)
	star.set_position(Vector2(randPos.randi_range(global.left_play_edge+20,global.right_play_edge-20), 0))
	star.set_z_index(-990)
# Called when the node enters the scene tree for the first time.
func _on_Timer_timeout():
	
				
	#---generate ufos---
	if difficulty >= 2:
		if global.level >= 4:
			difficulty = 4
		_timer.set_wait_time(2.0/difficulty)
		if total_num_of_ufos < number_of_enemies:
			#print(get_tree().get_nodes_in_group("mobs").size())
			rng.randomize()
			if rng.randi_range(0,40) < difficulty:
				var ufo = BIG_UFO_SCENE.instance()
				get_parent().add_child(ufo)
				ufo.set_position(Vector2(randPos.randi_range(global.left_play_edge,global.right_play_edge), 0))
				ufo.set_z_index(10)
				#total_num_of_ufos += 1
				array_of_big_ufos.append(ufo)
				var i = len(bigUfoTimers)
				bigUfoTimers.append(Timer.new())
				add_child(bigUfoTimers[i])
				bigUfoTimers[i].set_wait_time(2)
				bigUfoTimers[i].set_one_shot(true) # Make sure it dont loop
				bigUfoTimers[i].start()
				bigUfoOnScreen = true
			else:
				var ufo = UFO_SCENE.instance()
				get_parent().add_child(ufo)
				ufo.set_position(Vector2(randPos.randi_range(global.left_play_edge,global.right_play_edge), 0))
				ufo.set_z_index(-10)
			total_num_of_ufos += 1
			if total_num_of_ufos % 20 == 0:
				if difficulty == 5:
					difficulty = 2
					send_ships = true
					ship_sets = 10
				difficulty += 1
		else:
			send_ships = false #stop sending spaceships
			var t = Timer.new()
			t.set_wait_time(8)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			var mobs = get_tree().get_nodes_in_group("mobs")
			for mob in mobs:
				mob.queue_free()
			
			if boss == false:
				if global.dead == false:
					completion.text = "You Survived!"
				completion.visible = true
				t = Timer.new()
				t.set_wait_time(5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")

				self.call_deferred("free")
				get_tree().change_scene("res://Hangar.tscn")
			else:
				#_timer.stop()
				if not bossStart:
					boss_fight()
				
		
	#check if dead
	if global.dead == true:
		var t = Timer.new()
		t.set_wait_time(3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		#get_tree().call_group("mobs", "destroy")
		var mobs = get_tree().get_nodes_in_group("mobs")
		for mob in mobs:
			mob.queue_free()
		global.dead = false
		self.call_deferred("free")
		get_tree().change_scene("res://Hangar.tscn") 
		
	#check if win
	is_win()
		
												  
func _on_spaceshipTimer_timeout():
	#---generate spaceships---
	#print(ship_count)
	if difficulty == 1 or send_ships:
		spaceshipTimer.set_wait_time(0.5)
		if ship_i < ship_count:
			ship_i += 1
			var spaceship = SPACESHIP_SCENE.instance()
			get_parent().add_child(spaceship)
			if ! randSet:
				randPos.randomize()
				rand_position = Vector2(randPos.randi_range(global.left_play_edge+40,global.right_play_edge-40), 0)
				randSet = true
				
			spaceship.set_position(rand_position)
			spaceship.set_z_index(-10)
			spaceshipOnScreen = true
			spaceShipArray.append(spaceship)
			ship_turned.append(false)
		else:		
			randSet = false
			if global.level >= 5:
				spaceshipTimer.set_wait_time(1)
			else:
				spaceshipTimer.set_wait_time(5)
			ship_i = 0
			rng.randomize()
			var old_random_ship_turning_point = random_ship_turning_point
			random_ship_turning_point = rng.randi_range(1, 9)
			rng.randomize()
			ship_left_right = rng.randi_range(0, 1)
			rng.randomize()
			ship_count = rng.randi_range(5, 20)
			for t in ship_turned:
				t = false
			if old_random_ship_turning_point < random_ship_turning_point:
				for ship in spaceShipArray:
					if is_instance_valid(ship):
						ship.rotation = 0
			#print(String(ship_set_count)+ " " + String(ship_sets))
			if ship_set_count >= ship_sets:
				difficulty += 1
				send_ships = false
			ship_set_count += 1
#duplicate
func _on_spaceshipTimer2_timeout():
	#---generate spaceships---
	#print(ship_count)
	if difficulty == 1 or send_ships:
		spaceshipTimer2.set_wait_time(0.5)
		if ship_i2 < ship_count2:
			ship_i2 += 1
			var spaceship = SPACESHIP_SCENE.instance()
			get_parent().add_child(spaceship)
			if ! rand2Set:
				randPos2.randomize()
				
				rand_position2 = Vector2(global.right_play_edge - rand_position.x, 0)
				if rand_position2.x < rand_position.x + 20 and rand_position2.x > rand_position.x - 20:
					rand_position2.x += 20
				rand2Set = true
				
			spaceship.set_position(rand_position2)
			spaceship.set_z_index(-10)
			spaceshipOnScreen = true
			spaceShipArray.append(spaceship)
			ship_turned.append(false)
		else:		
			rand2Set = false
			if global.level >= 5:
				spaceshipTimer2.set_wait_time(1.3)
			else:
				spaceshipTimer2.set_wait_time(4)
			ship_i2 = 0
			rng.randomize()
			var old_random_ship_turning_point = random_ship_turning_point
			random_ship_turning_point = rng.randi_range(1, 9)
			rng.randomize()
			ship_left_right = rng.randi_range(0, 1)
			rng.randomize()
			ship_count2 = rng.randi_range(5, 20)
			for t in ship_turned:
				t = false
			if old_random_ship_turning_point < random_ship_turning_point:
				for ship in spaceShipArray:
					if is_instance_valid(ship):
						ship.rotation = 0
#			print(String(ship_set_count)+ " " + String(ship_sets))
#			if ship_set_count >= ship_sets:
#				difficulty += 1
#				send_ships = false
#			ship_set_count += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move spaceships in formation
	var turn = random_ship_turning_point * 70
	if spaceshipOnScreen:
		var i = 0
		for ship in spaceShipArray:
			if is_instance_valid(ship) and ship.dead == false:
				if ship.position.y <= turn:
					ship.position += Vector2(0,1) * 300 * delta	
				else:
#					if ship_turned[i] == false:
#						if ship_left_right == 0:
#							ship.rotate(0.7854)
#						else:
#							ship.rotate(-0.7854)
#						ship_turned[i] = true
					if ship_left_right == 0:
						ship.position += Vector2(-1,1) * 300 * delta
						ship.rotation = 0.7854
					else:
						ship.position += Vector2(1,1) * 300 * delta

						ship.rotation = -0.7854
			else:
				if is_instance_valid(ship):
					ship.left_engine.emitting = false
					ship.right_engine.emitting = false
					ship.center_engine.emitting = false
			i+=1
	if bigUfoOnScreen:
		var i = 0
		for t in bigUfoTimers:
			if t.get_time_left() == 0 and is_instance_valid(array_of_big_ufos[i]):
				if is_instance_valid(player):
					var laser = BIG_UFO_LASER.instance()
					get_parent().add_child(laser)
					laser.set_position(array_of_big_ufos[i].position)
					t.start()
					#angle laser toward player
					var angle = laser.global_position.angle_to_point(player.global_position)
					laser.rotation = angle
				#array_of_big_ufo_lazers.append(laser)
				#array_of_big_ufo_lazer_angles.append(angle)
				#set laser to move at certain angle
				
			i+=1
	hull._on_health_updated(global.current_hull - 1)
	
func boss_fight():
	bossStart = true
	
	get_parent().add_child(boss1)
	boss1.set_position(get_node("BossPosition").get_position())
	
func is_win():
	if global.winner == true:
		if global.dead == false:
				completion.text = "You Win!"
				completion.visible = true
				var t = Timer.new()
				t.set_wait_time(5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")

				self.call_deferred("free")
				get_tree().change_scene("res://Hangar.tscn")
