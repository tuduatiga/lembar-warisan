class_name Pocong extends CharacterBody2D

enum {
	MOVE,
	IDLE,
}

const _MOVEMENT_SPEED: float = 30.0
const _PROJECTILE: Resource = preload("res://scenes/projectile.tscn")

@export var _projectile_texture: Texture2D

var dead: bool = false
var _direction: Vector2 = Vector2.ZERO
var _state: int = IDLE
var _is_hostile: bool = false
var _target_position: Vector2 = Vector2.ZERO

var _kill_score: int = 10

@onready var _animated_sprite: AnimatedSprite2D = self.find_child("AnimatedSprite2D")
@onready var _explosion_sprite: AnimatedSprite2D = self.find_child("ExplosionAnimatedSprite2D")
@onready var _health_component: HealthComponent = self.find_child("HealthComponent")
@onready var _hurtbox_component: HurtboxComponent = self.find_child("HurtboxComponent")
@onready var _hitbox_component: HitboxComponent = self.find_child("HitboxComponent")
@onready var _blood: CPUParticles2D = self.find_child("Blood")
@onready var _death_breath_sfx: AudioStreamPlayer2D = self.find_child("DeathBreathSFX")
@onready var _detection_area: Area2D = self.find_child("DetectionArea")
@onready var _direction_timer: Timer = self.find_child("DirectionTimer")
@onready var _attack_timer: Timer = self.find_child("AttackTimer")


func _ready() -> void:
	self._explosion_sprite.visible = false
	self._health_component.damage_taken.connect(_on_damage_taken)

	self._direction_timer.one_shot = false
	self._direction_timer.wait_time = 2.0
	self._direction_timer.timeout.connect(_on_direction_timer_timeout)
	self._direction_timer.start()

	self._attack_timer.one_shot = false
	self._attack_timer.wait_time = 1.0
	self._attack_timer.timeout.connect(_on_attack_timer_timeout)

	self._detection_area.body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if self.dead:
		return

	if self._detection_area.monitoring:
		for body in self._detection_area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				self._is_hostile = true
				self._target_position = body.global_position

	match _state:
		MOVE:
			self._animated_sprite.play()
			self.velocity = self._direction * self._MOVEMENT_SPEED
		IDLE:
			self._animated_sprite.stop()
			self._animated_sprite.frame = 0
			self.velocity = Vector2.ZERO

	if self._is_hostile:
		var dir_to_player: Vector2 = (self._target_position - self.global_position).normalized()
		self._animated_sprite.flip_h = dir_to_player.x < 0

		if self._attack_timer.is_stopped():
			self._attack_timer.start()


	move_and_slide()


func _on_direction_timer_timeout() -> void:
	if self.dead:
		return

	self._state = MOVE if _state == IDLE else IDLE

	match self._state:
		MOVE:
			var angle: float = randf_range(0, TAU)
			self._direction = Vector2(cos(angle), sin(angle))
			self._animated_sprite.flip_h = self._direction.x < 0
			self._direction_timer.wait_time = 3.0 if not self._is_hostile else 1.0
		IDLE:
			self._direction_timer.wait_time = 0.5 if not self._is_hostile else 1.0

func _on_attack_timer_timeout() -> void:
	if self.dead:
		return

	self.attack(self._target_position)
	await get_tree().create_timer(0.2).timeout
	self.attack(self._target_position)
	self._attack_timer.wait_time = randf_range(2.0, 3.0)


func set_movement_target(_movement_target: Vector2) -> void:
	pass


func _on_damage_taken(health: int) -> void:
	self._animated_sprite.modulate = Color.RED
	self._blood.emitting = true
	await get_tree().create_timer(0.2).timeout
	self._animated_sprite.modulate = Color.WHITE
	self._blood.emitting = false

	if health <= 0:
		self.dead = true
		self.get_tree().root.get_node("Game").get_node("GameManager").add_score(self._kill_score)
		self._death_breath_sfx.play()
		self._explosion_sprite.visible = true
		self._explosion_sprite.play()
		self._animated_sprite.visible = false
		self._hitbox_component.queue_free()
		await get_tree().create_timer(0.5).timeout
		self._animated_sprite.queue_free()
		self._explosion_sprite.queue_free()
		await self._death_breath_sfx.finished
		self.queue_free()


func set_invincible(value: bool = true) -> void:
	self._hurtbox_component.monitoring = not value
	self._hurtbox_component.monitorable = not value


func attack(target_position: Vector2) -> void:
	(
		_PROJECTILE
		. instantiate()
		. with_texture(self._projectile_texture)
		. spawn_with_direction(self, (target_position - self.global_position).normalized(), 100)
		. with_modulate(Color.BLACK)
	)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		self._is_hostile = false
		self._state = IDLE
		self._attack_timer.stop()
