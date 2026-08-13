extends Control

# Busca os componentes dentro de JanelaConfig independente de pastas/containers
@onready var slider_volume_geral: HSlider = find_child("SliderVolumeGeral", true, false) as HSlider
@onready var slider_musica: HSlider = find_child("SliderMusica", true, false) as HSlider
@onready var check_tela_cheia: CheckBox = find_child("CheckBoxTelaCheia", true, false) as CheckBox
@onready var botao_voltar: Button = find_child("BotaoVoltar", true, false) as Button

func _ready() -> void:
	_carregar_valores_iniciais()
	_conectar_sinais()

func _conectar_sinais() -> void:
	if slider_volume_geral and not slider_volume_geral.value_changed.is_connected(_on_volume_geral_changed):
		slider_volume_geral.value_changed.connect(_on_volume_geral_changed)
		
	if slider_musica and not slider_musica.value_changed.is_connected(_on_volume_musica_changed):
		slider_musica.value_changed.connect(_on_volume_musica_changed)
		
	if check_tela_cheia and not check_tela_cheia.toggled.is_connected(_on_tela_cheia_toggled):
		check_tela_cheia.toggled.connect(_on_tela_cheia_toggled)
		
	if botao_voltar and not botao_voltar.pressed.is_connected(_on_botao_voltar_pressed):
		botao_voltar.pressed.connect(_on_botao_voltar_pressed)

func _carregar_valores_iniciais() -> void:
	var idx_master = AudioServer.get_bus_index("Master")
	var idx_music = AudioServer.get_bus_index("Music")
	
	if slider_volume_geral and idx_master != -1:
		slider_volume_geral.value = db_to_linear(AudioServer.get_bus_volume_db(idx_master))
		
	if slider_musica and idx_music != -1:
		slider_musica.value = db_to_linear(AudioServer.get_bus_volume_db(idx_music))
	
	if check_tela_cheia:
		var modo_janela = DisplayServer.window_get_mode()
		check_tela_cheia.button_pressed = (
			modo_janela == DisplayServer.WINDOW_MODE_FULLSCREEN or 
			modo_janela == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		)

# --- CONTROLE DE ÁUDIO E VÍDEO ---

func _on_volume_geral_changed(val: float) -> void:
	var idx_master = AudioServer.get_bus_index("Master")
	if idx_master != -1:
		AudioServer.set_bus_volume_db(idx_master, linear_to_db(val))
		AudioServer.set_bus_mute(idx_master, val == 0)

func _on_volume_musica_changed(val: float) -> void:
	var idx_music = AudioServer.get_bus_index("Music")
	if idx_music != -1:
		AudioServer.set_bus_volume_db(idx_music, linear_to_db(val))
		AudioServer.set_bus_mute(idx_music, val == 0)

func _on_tela_cheia_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_botao_voltar_pressed() -> void:
	hide()
	var menu_principal = get_parent()
	if menu_principal:
		var botoes_principais = menu_principal.find_child("BotoesPrincipais", true, false)
		if botoes_principais:
			botoes_principais.show()
			var botao_config = botoes_principais.find_child("BotaoConfig", true, false) as Button
			if botao_config:
				botao_config.grab_focus()
