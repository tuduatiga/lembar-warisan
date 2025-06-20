class_name Tuyul extends CharacterBody2D

var dead: bool = false

var _movement_speed: float = 250.0

var _kill_score: int = 5

@onready var _animated_sprite: AnimatedSprite2D = self.find_child("AnimatedSprite2D")
@onready var _explosion_sprite: AnimatedSprite2D = self.find_child("Explosion")
@onready var _navigation_agent: NavigationAgent2D = self.find_child("NavigationAgent2D")
@onready var _health_component: HealthComponent = self.find_child("HealthComponent")
@onready var _hurtbox_component: HurtboxComponent = self.find_child("HurtboxComponent")
@onready var _hitbox_component: HitboxComponent = self.find_child("HitboxComponent")
@onready var _blood: CPUParticles2D = self.find_child("Blood")
@onready var _hit_sound: Node2D = self.find_child("HitSound")
@onready var _kid_crying_sfx: AudioStreamPlayer2D = self.find_child("KidCryingSFX")


func _ready() -> void:
	self._navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	self._health_component.damage_taken.connect(_on_damage_taken)


func set_movement_target(movement_target: Vector2) -> void:
	if self.dead:
		return

	if movement_target.distance_to(self.global_position) < 27:
		self._navigation_agent.target_desired_distance = 5
		self._movement_speed = 70
	else:
		self._navigation_agent.target_desired_distance = 30
		self._movement_speed = 150

	self._navigation_agent.set_target_position(movement_target)


func _physics_process(_delta: float) -> void:
	if self.dead:
		return

	if self.velocity.x:
		self._animated_sprite.flip_h = self.velocity.x < 0

	if self.velocity.length_squared() > 0:
		self._animated_sprite.animation = "walk"
	else:
		self._animated_sprite.animation = "idle"

	if NavigationServer2D.map_get_iteration_id(self._navigation_agent.get_navigation_map()) == 0:
		return

	if self._navigation_agent.is_navigation_finished():
		return

	var new_velocity: Vector2 = (
		self.global_position.direction_to(self._navigation_agent.get_next_path_position())
		* self._movement_speed
	)

	if self._navigation_agent.avoidance_enabled:
		self._navigation_agent.set_velocity(new_velocity)
	else:
		self._on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	self.velocity = safe_velocity
	self.move_and_slide()


func _on_damage_taken(health: int) -> void:
	self._animated_sprite.modulate = Color.RED
	self._blood.emitting = true
	await get_tree().create_timer(0.2).timeout
	self._animated_sprite.modulate = Color.WHITE
	self._blood.emitting = false

	self._hit_sound.play_hit_sound()

	if health <= 0:
		self.dead = true
		$/root/Game/GameManager.add_score(self._kill_score)
		self._kid_crying_sfx.play()
		self._explosion_sprite.visible = true
		self._explosion_sprite.play()
		self._animated_sprite.visible = false
		self._navigation_agent.queue_free()
		self._hurtbox_component.queue_free()
		self._hitbox_component.queue_free()
		await get_tree().create_timer(0.5).timeout
		self._animated_sprite.queue_free()
		self._explosion_sprite.queue_free()
		await self._kid_crying_sfx.finished
		self.queue_free()


func set_invincible(value: bool = true) -> void:
	self._hurtbox_component.monitoring = not value
	self._hurtbox_component.monitorable = not value
