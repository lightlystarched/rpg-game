extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer = $timers/death_timer
@onready var detection_area = $detection_area
@onready var slime_hitbox = $slime_hitbox
@onready var take_damage_cooldown = $timers/take_damage_cooldown

var health = 100
var player_in_attack_zone = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase and health > 0:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))
		animated_sprite.play("walk")
		
		if (player.position.x - position.x) < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	elif health > 0:
		animated_sprite.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_slime_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_slime_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false
		
func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				#start the death animation and timer to trigger disappearance
				print("Slime should die")
				animated_sprite.play("death")
				death_timer.start()
				detection_area.visible = false
				slime_hitbox.visible = false


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_death_timer_timeout():
	print("remove body?")
	death_timer.stop()
