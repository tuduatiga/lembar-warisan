class_name Leak extends CharacterBody2D

const _MOVEMENT_SPEED: float = 20.0
const _PROJECTILE: Resource = preload("res://scenes/projectile.tscn")

@export var projectile_texture: Texture2D

var dead: bool = false

@onready var _sprite: Sprite2D = self.find_child("Sprite2D")
@onready var _explosion_sprite: AnimatedSprite2D = self.find_child("Explosion")
@onready var _navigation_agent: NavigationAgent2D = self.find_child("NavigationAgent2D")
@onready var _cast_timer: Timer = self.find_child("CastTimer")
@onready var _health_component: HealthComponent = self.find_child("HealthComponent")
@onready var _hurtbox_component: HurtboxComponent = self.find_child("HurtboxComponent")
@onready var _blood: CPUParticles2D = self.find_child("Blood")


func _ready() -> void:
	self._sprite = self.find_child("Sprite2D")
	self._navigation_agent = self.find_child("NavigationAgent2D")

	self._navigation_agent.velocity_computed.connect(_on_velocity_computed)

	self._cast_timer = self.find_child("CastTimer")

	self._health_component = self.find_child("HealthComponent")
	self._health_component.damage_taken.connect(_on_damage_taken)


func set_movement_target(movement_target: Vector2) -> void:
	if self.dead:
		return

	self._navigation_agent.set_target_position(movement_target)
	if self._cast_timer.time_left == 0:
		self._cast_timer.start()
		self.cast(movement_target)
		self._cast_timer.wait_time = randf_range(3.0, 4.0)


func _physics_process(_delta: float) -> void:
	if self.dead:
		return

	if self.velocity.x:
		self._sprite.flip_h = self.velocity.x < 0

	if NavigationServer2D.map_get_iteration_id(self._navigation_agent.get_navigation_map()) == 0:
		return

	if self._navigation_agent.is_navigation_finished():
		return

	var new_velocity: Vector2 = (
		self.global_position.direction_to(self._navigation_agent.get_next_path_position())
		* self._MOVEMENT_SPEED
	)

	if self._navigation_agent.avoidance_enabled:
		self._navigation_agent.set_velocity(new_velocity)
	else:
		self._on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
	self.move_and_slide()


func _on_damage_taken(health: int) -> void:
	self._sprite.modulate = Color.RED
	self._blood.emitting = true
	await get_tree().create_timer(0.2).timeout
	self._sprite.modulate = Color.WHITE
	self._blood.emitting = false

	if health <= 0:
		self.dead = true
		self._explosion_sprite.visible = true
		self._explosion_sprite.play()
		self._navigation_agent.queue_free()
		self._hurtbox_component.queue_free()
		await get_tree().create_timer(0.5).timeout
		self._sprite.queue_free()
		self._explosion_sprite.queue_free()
		self.queue_free()


func cast(target_position: Vector2) -> void:
	(
		_PROJECTILE
		. instantiate()
		. with_texture(self.projectile_texture)
		. spawn_with_direction(self, (target_position - self.global_position).normalized(), 100)
		. with_modulate(Color.BLACK)
	)
	(
		_PROJECTILE
		. instantiate()
		. with_texture(self.projectile_texture)
		. spawn_with_direction(
			self, (target_position - self.global_position).normalized().rotated(PI / 4.0), 100
		)
		. with_modulate(Color.BLACK)
	)
	(
		_PROJECTILE
		. instantiate()
		. with_texture(self.projectile_texture)
		. spawn_with_direction(
			self, (target_position - self.global_position).normalized().rotated(-PI / 4.0), 100
		)
		. with_modulate(Color.BLACK)
	)


func set_invincible(value: bool = true) -> void:
	self._hurtbox_component.monitoring = not value
	self._hurtbox_component.monitorable = not value
