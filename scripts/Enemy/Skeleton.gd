extends Enemy

@export var speed: float = 100.0
@export var attack_range: float = 80.0 # Distância para o inimigo atacar
var player: Node2D = null

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


#encontrar o jogador na cena!!
func _ready():
	super._ready()
	player = get_tree().get_first_node_in_group("Player")
	set_state(State.IDLE)


func _process(delta: float) -> void:
	
	pass


func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	if player and is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			set_state(State.ATTACK)
			velocity = Vector2.ZERO # Para de mover para atacar
			if anim_sprite.animation != "Attack":
				anim_sprite.play("Attack")
			attack(player)
		elif distance_to_player > attack_range and distance_to_player < 300: # Exemplo de range de perseguição
			set_state(State.CHASE)
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			if anim_sprite.animation != "Chase":
				anim_sprite.play("Chase")
		else:
			set_state(State.IDLE)
			velocity = Vector2.ZERO
			if anim_sprite.animation != "Idle":
				anim_sprite.play("Idle")
	else:
		set_state(State.IDLE)
		velocity = Vector2.ZERO
		if anim_sprite.animation != "Idle":
			anim_sprite.play("Idle")
	
	
	pass

func die():
	set_state(State.DEAD)
	anim_sprite.play("Dead")
	# Aguarda a animação de morte terminar antes de liberar o nó
	await anim_sprite.animation_finished
	super.die()
