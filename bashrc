function j {
	cd `jaunte-jump $1`
}
function jd {
	if [ -z "$1" ]; exit 0; fi
	
	cd $1 && jaunte-append
}
alias cd=jd