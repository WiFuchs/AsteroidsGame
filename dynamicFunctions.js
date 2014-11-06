var started=false;
var rePlay=false;
var moveUp, moveLeft, moveRight;
var difficulty;
var gameOver;

function passInput(forms){
	var form = document.getElementById(forms);
	for(var i=0; i<form.elements.length; i++){
		switch(i){
			case 0:
				moveUp=form.elements[i].value;
				break;
			case 1:
				moveLeft=form.elements[i].value;
				break;
			case 2:
				moveRight=form.elements[i].value;
				break;
		}
	}
}

var determineDifficulty = function(){
	if(document.getElementById('easy').checked==true){
		difficulty=5;
	}
	else if(document.getElementById('medium').checked==true){
		difficulty=8;
	}
	else if(document.getElementById('hard').checked==true){
		difficulty=11;
	}
	document.getElementById('toChange').innerHTML = difficulty;
	if(gameOver==true){
		rePlay=true;
	}
}