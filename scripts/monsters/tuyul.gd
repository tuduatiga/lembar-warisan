class_name Tuyul extends CharacterBody2D

var _movement_speed: float = 250.0

@onready var _animated_sprite: AnimatedSprite2D = self.find_child("AnimatedSprite2D")
@onready var _explosion_sprite: AnimatedSprite2D = self.find_child("Explosion")
@onready var _navigation_agent: NavigationAgent2D = self.find_child("NavigationAgent2D")
@onready var _health_component: HealthComponent = self.find_child("HealthComponent")
@onready var _blood: CPUParticles2D = self.find_child("Blood")
@onready var _hit_sound: Node2D = self.find_child("HitSound")

func _ready() -> void:
	self._navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	self._health_component.damage_taken.connect(_on_damage_taken)


func set_movement_target(movement_target: Vector2) -> void:
	if not self._navigation_agent:
		return

	if movement_target.distance_to(self.global_position) < 27:
		self._navigation_agent.target_desired_distance = 5
		self._movement_speed = 70
	else:
		self._navigation_agent.target_desired_distance = 30
		self._movement_speed = 150

	self._navigation_agent.set_target_position(movement_target)


func _physics_process(_delta) -> void:
	if not self._navigation_agent:
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
	self.modulate = Color.RED
	self._blood.emitting = true
	await get_tree().create_timer(0.2).timeout
	self.modulate = Color.WHITE
	self._blood.emitting = false

	self._hit_sound.play_hit_sound()

	if health <= 0:
		self._explosion_sprite.visible = true
		self._explosion_sprite.play()
		self._animated_sprite.visible = false
		self._navigation_agent.queue_free()
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
