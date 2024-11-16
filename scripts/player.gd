extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
@onready var attack_cooldown: Timer = $attack_cooldown
@onready var player_hitbox = $AnimatedSprite2D/player_hitbox

const SPEED = 200.0
const ACCEL = 800
const FRICTION = 1200
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var input = Vector2.ZERO
var direction = "front"
var attacking = false

func _physics_process(delta: float) -> void:
	if player_alive:
		player_movement(delta)
		attack()
		enemy_attack()
		update_health()
	
		if health <= 0:
			player_alive = false #Add end screen or respawn
			health = 0
			animated_sprite.play('death')
			player_hitbox.visible = false
			# self.queue_free()
	
func get_input():
	if (Input.is_action_pressed("ui_move_right")):
		direction = "side"
		if not attacking:
			animated_sprite.play("side_walk")
		animated_sprite.flip_h = false
	if (Input.is_action_pressed("ui_move_left")):
		direction = "side"
		if not attacking:
			animated_sprite.play("side_walk")
		animated_sprite.flip_h = true
	if (Input.is_action_pressed("ui_move_up")):
		direction = "back"
		if not attacking:
			animated_sprite.play("back_walk")
	if (Input.is_action_pressed("ui_move_down")):
		direction = "front"
		if not attacking:
			animated_sprite.play("front_walk")
		
	input.x = int(Input.is_action_pressed("ui_move_right")) - int(Input.is_action_pressed("ui_move_left"))
	input.y = int(Input.is_action_pressed("ui_move_down")) - int(Input.is_action_pressed("ui_move_up"))
	
	return input.normalized()
	
func player_movement(delta: float) -> void:
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
			if not attacking:
				animated_sprite.play(direction + "_idle")
	else:
		velocity += (input * ACCEL * delta)
		velocity = velocity.limit_length(SPEED)
	
	move_and_slide()

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		attack_cooldown.start()


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("ui_attack"):
		global.player_current_attack = true
		attacking = true
		animated_sprite.play(direction + "_attack")
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attacking = false

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health = health +20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
