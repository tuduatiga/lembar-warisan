class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent


func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HURTBOX
	self.collision_mask = Enums.CollisionLayer.HITBOX

	self.area_entered.connect(self._on_area_entered)
	self.area_exited.connect(self._on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if not self.owner == area.proprietor:
			var is_same_group_cb: Callable = func(group: String) -> bool:
				return area["proprietor" if area.proprietor else "owner"].get_groups().has(group)

			if self.owner.get_groups().filter(is_same_group_cb).size():
				return

			health_component.damage(area.attack)


func _on_area_exited(area: Area2D) -> void:
	if area is HitboxComponent and self.owner:
		if self.owner == area.owner:
			return
