#!/usr/bin/env bash
# -------------------------------------------------------------------------
# Script		: screentogif.sh
# Descrição		: grava sua tela em formato de GIF.
# Versão		: 1.1-beta
# Autor			: Eppur Si Muove
# Contato		: eppur.si.muove@keemail.me
# Criação		: 20/01/2020
# Modificação	: 21/01/2020
# Licença		: GNU/GPL v3.0
# -------------------------------------------------------------------------
# Exemplo de uso:
#		$ ./screentogif.sh
#		$ Pressione CTRL+C para parar a gravação
#		$ Converter a partir de (em segundos) : 1
#		$ Quadro por segundo ( de preferência < 24 ) : 10
#		$ Largura (pixels - altura será definida automaticamente) : 800
# -------------------------------------------------------------------------

# ------------------| Comando para pegar o CTRL + C |----------------------
trap convertToGif INT

# ------------------------| Converte para GIF |----------------------------
convertToGif(){
	read -p "Converter a partir de (em segundos) : " inicio
	read -p "Quadros por segundo ( de preferência < 24 ) : " fps
	read -p "Largura (pixels - altura será definida automaticamente) : " larg
	duracao=$(ffmpeg -i $nvideo 2>&1 | grep Duration | cut -d ' ' -f4 | sed s/,//)
	dHrs=$(cut -d ':' -f1 <<< $duracao)
	dMin=$(cut -d ':' -f2 <<< $duracao)
	dSec=$(cut -d ':' -f3 <<< $duracao)
	dSec=$(cut -d '.' -f1 <<< $dSec)
	duracao=$(( $(( $dHrs * 3600 )) + $(( $dMin * 60 )) + $dSec - $inicio ))

	ffmpeg -ss $inicio -t $duracao -i $nvideo -vf "fps=$fps,scale=$larg:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $nvideo.gif &> /dev/null
	echo "GIF salvo em $nvideo.gif"
	echo "Obrigado por usar o screentogif!!"
	rm $nvideo
	exit 0
}

# ----------------------------| Variáveis | -------------------------------
nvideo=$(date +'%Y%m%d-%H%M%S')
nvideo=$(xdg-user-dir VIDEOS)/$nvideo.avi
resolucao=$(xrandr | grep '*' | cut -d ' ' -f4)

# ----------------------| Grava a Tela em .avi | --------------------------
echo "Pressione CTRL+C para parar a gravação"
ffmpeg -f x11grab -y -r 24 -s $resolucao -i :0.0 -vcodec huffyuv $nvideo &> /dev/null
# ---------| Aqui ele vai gravar até usuário teclar CTRL+C |---------------
