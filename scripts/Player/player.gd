extends CharacterBody2D

class_name Player

#status base
var Level = 1
@export var max_health: int = 100
var current_health: int
var Spd = 600
var Xp = 0

#variaveis de movimentação
var dir = Vector2()

@export var health_bar_scene: PackedScene
var health_bar_instance: ProgressBar

func _ready():
	current_health = max_health

	if health_bar_scene:
		health_bar_instance = health_bar_scene.instantiate()
		get_tree().get_root().add_child(health_bar_instance) # Adiciona a barra de vida à raiz da árvore de cena
		health_bar_instance.update_health_bar(current_health, max_health)
		health_bar_instance.position = Vector2(20, 20) # Posição fixa na tela para o jogador

func _process(delta: float) -> void:	
	pass
	
func _physics_process(delta: float) -> void:
	MovePlayer(delta)
	pass

#movimentação
func MovePlayer(delta):
	dir = Vector2()
	
	if Input.is_action_pressed("Up"):
		dir += Vector2.UP
	if Input.is_action_pressed("Down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("Left"):
		dir += Vector2.LEFT
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("Right"):
		dir += Vector2.RIGHT
		$AnimatedSprite2D.flip_h = false
		
	elif dir != Vector2.ZERO:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")
	
	global_position += dir.normalized() * Spd * delta

func take_damage(amount: int):
	current_health -= amount
	if health_bar_instance:
		health_bar_instance.update_health_bar(current_health, max_health)
	if current_health <= 0:
		die()

func die():
	queue_free() # Remove o jogador da cena (ou implementa uma tela de game over)

#calcula xp necessaria para upar de nivel
func CalcExpLevel(Level):
	return 20 * Level * Level

#calcula o xp total para subir de nivel
func CalcExpNextLevel(Xp):
	var required = CalcExpLevel(Level)
	return max(required - Xp, 0)

func LevelUp():
	if Xp >= CalcExpLevel(Level + 1):
		Level += 1
