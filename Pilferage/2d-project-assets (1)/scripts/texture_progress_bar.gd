extends TextureProgressBar

@onready var cat = $"../../cat"

func _ready():
	cat.healthChanged.connect(update)
	update()

func update():
	value = cat.current_health * 100 / cat.max_health
