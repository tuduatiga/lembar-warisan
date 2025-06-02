class_name HealthBar extends ProgressBar

var health: int:
	set = _on_health_set

@onready var _damage_bar: ProgressBar = self.find_child("DamageBar")
@onready var _timer: Timer = self.find_child("Timer")


func init(p_health: int) -> void:
	self.health = p_health

	self.max_value = self.health
	self.value = self.health

	self._damage_bar.max_value = self.max_value
	self._damage_bar.value = self.value

	self._timer.timeout.connect(self._on_timeout)


func _on_health_set(new_health: int) -> void:
	var prev_health: int = health

	health = min(self.max_value, new_health)
	self.value = health

	if new_health <= 0:
		self.queue_free()

	if self.health < prev_health:
		self._timer.start()
	else:
		self._damage_bar.value = health


func _on_timeout() -> void:
	self._damage_bar.value = self.health
