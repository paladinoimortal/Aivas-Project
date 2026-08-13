extends CanvasLayer

# Caminho para a cena do Menu Inicial
@export_file("*.tscn") var menu_scene_path: String = "res://cenas/menu_inicial.tscn"

@onready var control: Control = $Control
@onready var botao_continuar: Button = $Control/MarginContainer/VBoxContainer/BotaoContinuar
@onready var botao_config: Button = $Control/MarginContainer/VBoxContainer/BotaoConfig
@onready var botao_menu: Button = $Control/MarginContainer/VBoxContainer/BotaoMenu
@onready var botao_sair: Button = $Control/MarginContainer/VBoxContainer/BotaoSair

func _ready() -> void:
	# Garante que o menu comece escondido
	control.visible = false
	
	# Conecta os botões aos métodos
	if botao_continuar:
		botao_continuar.pressed.connect(_on_continuar_pressed)
	if botao_config:
		botao_config.pressed.connect(_on_config_pressed)
	if botao_menu:
		botao_menu.pressed.connect(_on_menu_pressed)
	if botao_sair:
		botao_sair.pressed.connect(_on_sair_pressed)

func _unhandled_input(event: InputEvent) -> void:
	# Detecta a tecla ESC (ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

# Alterna entre pausar e despausar o jogo
func toggle_pause() -> void:
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	control.visible = is_paused

	if is_paused:
		# Solta o mouse para interagir com os botões da UI
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if botao_continuar:
			botao_continuar.grab_focus()
	else:
		# Prende o mouse de volta para o controle de câmera 3D
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- AÇÕES DOS BOTÕES ---

func _on_continuar_pressed() -> void:
	toggle_pause()

func _on_config_pressed() -> void:
	print("Abrir janela de Configurações")
	# Aqui no futuro você pode abrir um painel de áudio/vídeo!

func _on_menu_pressed() -> void:
	# Descongela o tempo antes de mudar de cena
	get_tree().paused = false
	get_tree().change_scene_to_file(menu_scene_path)

func _on_sair_pressed() -> void:
	get_tree().quit()
