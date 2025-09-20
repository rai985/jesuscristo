extends CharacterBody2D
class_name Enemy

enum State { IDLE, CHASE, ATTACK, DEAD }

@export var max_health: int = 100
var current_health: int
var current_state: State = State.IDLE

@export var health_bar_scene: PackedScene
var health_bar_instance: ProgressBar

@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.0
var can_attack: bool = true

func _ready():
	current_health = max_health

	if health_bar_scene:
		health_bar_instance = health_bar_scene.instantiate()
		add_child(health_bar_instance)
		health_bar_instance.update_health_bar(current_health, max_health)
		health_bar_instance.position = Vector2(-health_bar_instance.size.x / 2, -50) # Ajuste a posição conforme necessário

func take_damage(amount: int):
	current_health -= amount
	if health_bar_instance:
		health_bar_instance.update_health_bar(current_health, max_health)
	if current_health <= 0:
		die()

func die():
	queue_free() # Remove o inimigo da cena

func set_state(new_state: State):
	current_state = new_state

func attack(target: Node):
	if can_attack and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(attack_damage)
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
