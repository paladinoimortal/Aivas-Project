extends Area3D

@export_file("*.tscn") var proxima_cena: String

var player_perto: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_perto:
		if Input.is_action_just_pressed("interagir"):
			print(">>> Tecla F apertada! Tentando mudar para: ", proxima_cena)
			mudar_de_cena()

func _on_body_entered(body: Node3D) -> void:
	print("Objeto entrou na porta: ", body.name, " | Grupos: ", body.get_groups())
	player_perto = true

func _on_body_exited(body: Node3D) -> void:
	print("Objeto saiu da porta: ", body.name)
	player_perto = false

func mudar_de_cena() -> void:
	if proxima_cena != "" and proxima_cena != null:
		get_tree().change_scene_to_file(proxima_cena)
	else:
		print("ERRO: Nenhuma cena foi selecionada na propriedade 'Proxima Cena' no Inspetor!")
