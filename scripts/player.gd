class_name Player extends CharacterBody2D

const _SPEED: float = 100.0
const _PROJECTILE: PackedScene = preload("res://scenes/projectile.tscn")

@export var projectile_texture: Texture2D

var dead: bool = false
var health_component: HealthComponent

var _animated_sprite: AnimatedSprite2D
var _collision_shape: CollisionShape2D
var _keris: Node2D
var _enemy_detection_area: Area2D
var _blood: CPUParticles2D
var _dash_timer: Timer
var _can_attack: bool = true

@onready var _slash_sound: Node2D = self.find_child("SlashSound")
@onready var _scream_sfx: AudioStreamPlayer2D = self.find_child("ScreamingSFX")
@onready var _attack_timer: Timer = self.get_node("AttackTimer")


func _ready() -> void:
	self._animated_sprite = self.find_child("AnimatedSprite2D")
	self._collision_shape = self.find_child("CollisionShape2D")
	self._keris = self.find_child("Keris")
	self._enemy_detection_area = self.find_child("EnemyDetectionArea")
	self.health_component = self.find_child("HealthComponent")
	self._blood = self.find_child("Blood")
	self._dash_timer = self.find_child("DashTimer")

	self.health_component.damage_taken.connect(_on_damage_taken)

	self._keris.find_child("Wrapper").find_child("HitboxComponent").proprietor = self

	self._attack_timer.wait_time = 0.2
	self._attack_timer.one_shot = true
	self._attack_timer.timeout.connect(_on_attack_timer_timeout)


func _physics_process(_delta: float) -> void:
	if self.dead:
		return

	if self._enemy_detection_area.monitoring:
		for body in self._enemy_detection_area.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.set_movement_target(self.global_position)

	var dash_mult: int = 1
	if Input.is_key_pressed(KEY_SPACE) and self._dash_timer.time_left == 0:
		self._dash_timer.start()
		dash_mult = 12

	self.velocity = (
		Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * self._SPEED * dash_mult
	)

	var should_flip_x: bool = (get_global_mouse_position() - self.global_position).x < 0
	self._animated_sprite.flip_h = should_flip_x
	self._keris.scale.x = -1 if should_flip_x else 1
	self._keris.position.x = abs(self._keris.position.x) * (-1 if should_flip_x else 1)

	self._animated_sprite.speed_scale = 1 + self.velocity.length() / self._SPEED

	var dir: String = (
		"back" if (get_global_mouse_position() - self.global_position).y < 0 else "front"
	)
	if self.velocity.length_squared() > 0:
		self._animated_sprite.animation = dir + "_walk"
	else:
		self._animated_sprite.animation = dir + "_idle"

	self.move_and_slide()


func _input(event: InputEvent) -> void:
	if self.dead:
		return

	if event.is_action_pressed("melee_attack"):
		self.slash()

	if event.is_action_pressed("ranged_attack"):
		if not self._can_attack:
			return

		self._keris.find_child("AnimationPlayer").stop()
		self._keris.find_child("AnimationPlayer").play("ranged")
		self._slash_sound.play_sound()
		_PROJECTILE.instantiate().with_texture(projectile_texture).spawn(self)
		self._can_attack = false
		self._attack_timer.start()


func _on_damage_taken(health: int) -> void:
	if self.dead:
		return

	self._blood.emitting = true
	self.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	self.modulate = Color.WHITE
	self._blood.emitting = false

	if health <= 0:
		self.dead = true
		self._animated_sprite.animation = "front_idle"
		self._animated_sprite.stop()
		self._scream_sfx.play()
		Engine.time_scale = 0.1
		await self._scream_sfx.finished
		Engine.time_scale = 1
		self.get_tree().reload_current_scene()


func slash() -> void:
	self._keris.find_child("AnimationPlayer").stop()
	self._keris.find_child("AnimationPlayer").play("slash")


func set_enemies_monitoring_status(status: bool) -> void:
	self._enemy_detection_area.monitoring = status

func _on_attack_timer_timeout() -> void:
	self._can_attack = true

