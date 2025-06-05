extends StaticBody2D


@onready var _sprite: Sprite2D = self.get_node("Sprite2D")
@onready var _health_component: HealthComponent = self.get_node("HealthComponent")
@onready var _hurtbox_component: HurtboxComponent = self.get_node("HurtboxComponent")
@onready var _break_particle: CPUParticles2D = self.get_node("BreakParticle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._health_component.damage_taken.connect(self._on_damage_taken)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_damage_taken(health: int) -> void:
	if health <= 0:
		self._sprite.queue_free()
		self._break_particle.emitting = true
		await self._break_particle.finished
		self.queue_free()

func set_invincible(value: bool = true) -> void:
	self._hurtbox_component.monitoring = not value
	self._hurtbox_component.monitorable = not value
