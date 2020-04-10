#!/usr/bin/env bash
# -------------------------------------------------------------------------
# Script		: screentogif.sh
# Descrição		: grava sua tela em formato de GIF.
# Versão		: 1.2-beta
# Autor			: Eppur Si Muove
# Contato		: eppur.si.muove@keemail.me
# Criação		: 20/01/2020
# Modificação	: 09/04/2020
# Licença		: GNU/GPL v3.0
# -------------------------------------------------------------------------
# Exemplo de uso:
#		$ ./screentogif.sh [-s | --slop]
#		$ Pressione CTRL+C para parar a gravação
#		$ Converter a partir de (em segundos) : 1
#		$ Quadro por segundo ( de preferência < 24 ) : 10
#		$ Largura (pixels - altura será definida automaticamente) : 800
#
#		-s | --slop
#			Parâmetro opcional. Permite selecionar uma área específica da
#			tela a ser gravada. Esse recurso depende da ferramenta slop.
#			Para instalar o slop: # apt install slop
# -------------------------------------------------------------------------

# ------------------------| Comando para pegar o CTRL + C |----------------
trap convertToGif INT

# ------------------------| Função de conversão .avi para .gif |-----------
convertToGif(){
	# --------------------| Lê duração do vídeo atual |--------------------
	duracao=$(ffmpeg -i $nvideo 2>&1 | grep Duration | cut -d ' ' -f4 | sed s/,//)

	# --------------------| Calcula a duração do vídeo em segundos | ------
	dHrs=$(cut -d ':' -f1 <<< $duracao)
	dMin=$(cut -d ':' -f2 <<< $duracao)
	dSec=$(cut -d ':' -f3 <<< $duracao)
	dSec=$(cut -d '.' -f1 <<< $dSec)
	duracao=$(( $(( $dHrs * 3600 )) + $(( $dMin * 60 )) + $dSec))

	# --------------------| Usuário personaliza qualidade do gif | --------
	echo "O gif atual tem $duracao segundos..."
	read -p "Cortar ínicio(segs) - padrão = [0]: " corteInicio
	read -p "Cortar final(segs) - padrão = [0]: " corteFim
	read -p "FPS < 24 - padrão = [15]: " fps
	read -p "Largura(px) - padrão = [1280]: " larg

	# --------------------| Calcula a duração final do gif | --------------
	duracao=$(( $duracao - ${corteInicio:-0} - ${corteFim:-0} ))

	# --------------------| Inicia conversão video avi para gif | ---------
	ffmpeg -ss ${corteInicio:-0} -t $duracao -i $nvideo -vf "fps=${fps:-15},scale=${larg:-1280}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $nvideo.gif &> /dev/null
	echo "GIF salvo em $nvideo.gif"
	echo "Obrigado por usar o screentogif!!"
	rm $nvideo
	exit 0
}

# ------------------------| Início do programa | --------------------------

# ------------------------| Define nome dos arquivos .avi e .gif |---------
nvideo=$(date +'%Y%m%d-%H%M%S')
nvideo=$(xdg-user-dir VIDEOS)/$nvideo.avi

# ------------------------| Define área da tela |--------------------------
case $1 in
	"-s"|"--slop" )
		[[ -z $(which slop) ]] && echo "Instale a slop com: # apt instal slop" && exit 1
		echo "Selecione a área da tela a ser gravada..."
		geometria=$(slop -k -f "%w %h %x %y")
		width=$(cut -d' ' -f1 <<< $geometria)
		height=$(cut -d' ' -f2 <<< $geometria)
		xOffset=$(cut -d' ' -f3 <<< $geometria)
		yOffset=$(cut -d' ' -f4 <<< $geometria)
		i=":0.0+$xOffset,$yOffset"
		resolucao="${width}x${height}"
		;;
	* )
		i=":0.0"
		resolucao=$(xrandr | grep '*' | cut -d ' ' -f4)
		;;
esac

# ------------------------| Grava a Tela em .avi | ------------------------
echo "Pressione CTRL+C para parar a gravação"
ffmpeg -f x11grab -y -r 24 -s $resolucao -i $i -vcodec huffyuv $nvideo &> /dev/null

# ------------------------| Gravando até que o usuário tecle CTRL+C |------
