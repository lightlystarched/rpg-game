extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health = 100
var player_in_attack_zone = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))
		animated_sprite.play("walk")
		
		if (player.position.x - position.x) < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
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
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
