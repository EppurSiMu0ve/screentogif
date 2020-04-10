# screentogif
Nem sempre é prático utilizar o "ffmpeg" para fazer uma simples animação em GIF da sua área de trabalho.
De fato é um programa complexo, com um manual de uso enorme e depende vários parâmetros passados para funcionar corretamente.
O objetivo dsse é simplesmente facilitar a tarefa de criar um gif da sua área de trabalho

<b>Exemplo de uso:</b>

-------------------------------------------------------------------------
	$ ./screentogif.sh [-s | --slop] 
	$ Pressione CTRL+C para parar a gravação
	$ Cortar ínicio(segs) - padrão = [0]: 1
	$ Cortar final(segs) - padrão = [0]: 2
	$ FPS < 24 - padrão = [15]: 12
	$ Largura(px) - padrão = [1280]: 1100
	
	-s | --slop
		Parâmetro opcional. Permite selecionar uma área específica da
		tela a ser gravada. Esse recurso depende da ferramenta slop.
		Para instalar o slop: # apt install slop
-------------------------------------------------------------------------

# Gif feito com esse script
![screentogif](https://raw.githubusercontent.com/EppurSiMu0ve/screentogif/master/20200409-233354.avi.gif)
