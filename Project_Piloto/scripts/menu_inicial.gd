extends Control

@export_file("*.tscn") var cena_do_jogo: String = "res://cenas/casa_0.tscn"

@onready var musica_menu: AudioStreamPlayer = find_child("MusicaMenu", true, false) as AudioStreamPlayer
@onready var botoes_principais: Control = find_child("BotoesPrincipais", true, false)
@onready var janela_config: Control = find_child("JanelaConfig", true, false)
@onready var creditos: RichTextLabel = find_child("Creditos", true, false) as RichTextLabel

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if botoes_principais: botoes_principais.show()
	if janela_config: janela_config.hide()
	if musica_menu and not musica_menu.playing: musica_menu.play()
	
	# Aguarda a árvore carregar totalmente para conectar o grupo 'button'
	await get_tree().process_frame
	_conectar_botoes()
	
	if creditos and not creditos.meta_clicked.is_connected(_on_creditos_meta_clicked):
		creditos.meta_clicked.connect(_on_creditos_meta_clicked)

func _conectar_botoes() -> void:
	# Busca todos os botões do grupo "button"
	var lista_botoes = get_tree().get_nodes_in_group("button")
	
	for no in lista_botoes:
		if no is Button:
			if no.pressed.is_connected(_on_qualquer_botao_pressionado):
				no.pressed.disconnect(_on_qualquer_botao_pressionado)
				
			no.pressed.connect(_on_qualquer_botao_pressionado.bind(no))
			
			if no.name == "BotaoJogar":
				no.grab_focus()

func _on_qualquer_botao_pressionado(botao: Button) -> void:
	match botao.name:
		"BotaoJogar":
			if cena_do_jogo != "":
				get_tree().change_scene_to_file(cena_do_jogo)

		"BotaoConfig":
			if botoes_principais: botoes_principais.hide()
			if janela_config: janela_config.show()

		"BotaoSair":
			get_tree().quit()

		"BotaoVoltar":
			if janela_config: janela_config.hide()
			if botoes_principais: 
				botoes_principais.show()
				var b_config = botoes_principais.find_child("BotaoConfig", true, false) as Button
				if b_config: b_config.grab_focus()

func _on_creditos_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
