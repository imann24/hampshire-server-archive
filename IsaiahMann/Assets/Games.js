function Game (title, summary, mainPic, screenshots, video, link) {
	this.title = title;
	this.summary = summary;
	this.mainPic = mainPic;
	this.screenshots = screenshots;
	this.video = video;
	this.link = link;
};
var games = []; 
games[0] = new Game ("Word Snack", 
		"Play Word Snack, the game where aliens are hungry for words and it's your job to feed them! Word Snack is a single player word game set in a diner in outer space. Feed words to hungry aliens, receive points for every word, and turbocharge your score by catering to their alien tastes. Some aliens love short words, others love long ones. Some crave consonants, others can't get enough of vowels.",
		'WordSnackLogo.png', 
		['Screenshots/Word Snack/WordSnack1.png', 
		'Screenshots/Word Snack/WordSnack2.png',
		'Screenshots/Word Snack/WordSnack3.png',
		'Screenshots/Word Snack/WordSnack4.png'],
		'<h2> Gameplay: </h2><iframe width="560" height="315" src="https://www.youtube.com/embed/DcpZ1Ph1ugo?rel=0" frameborder="0" allowfullscreen></iframe>',
		"http://wordsnack.net/'>Access this Game");

games[1] = new Game ("Hatter",
		'In a distant, dystopian future there is no law. There is only one woman who can keep the piece, a mysterious individual. She is known only as "Hatter," owing to the anachronistic cowboy hat she contantly wears. Peerless warlord Nivara has taken control of the city of Chioban. It is up to Hatter to take her down, and save the innocent civilains from tyranny and persecution...',
		'HatterLogo.png',
		['Screenshots/Hatter/Hatter1.png',
		'Screenshots/Hatter/Hatter2.png',
		'Screenshots/Hatter/Hatter3.png',
		'Screenshots/Hatter/Hatter4.png'],
		'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/lY3Y6aFx-yc?rel=0" frameborder="0" allowfullscreen></iframe>',
		"http://stout.hampshire.edu/~ibm13/Web%20Dev%20Final/Homepage.html'>Access this Game");

games[2] = new Game ("Apartments",
					"Apartments is an experiment in world building, a dynamic camera, and basic Artificial Intelligence. The controls and function of the game are relatively simple. The camera can be controlled either by the WASD keys or the on screen buttons. It can also be zoomed in and out with the plus and minus keys. The elevator can be controlled either by typing in a number or clicking a button.",
					'ApartmentsLogo.png',
					['Screenshots/Apartments/Apartments1.png',
					'Screenshots/Apartments/Apartments2.png',
					'Screenshots/Apartments/Apartments3.png',
					'Screenshots/Apartments/Apartments4.png'],
					'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/jCTQ65lCnI0?rel=0" frameborder="0" allowfullscreen></iframe>',
					"https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/Apartments'>Access this Game");

games[3] = new Game ("Chess",
					"This is the standard game of chess. It's a demonstration of 2d game making with the Unity engine, a basic search algorithm, and the interaction of many hierarchal classes. The controls are all done through clicking. Green squares indicate moves and red squares indicate pieces that can be taken. If the king's square is red, this indicates a check. The program uses a search algorith to detect a check or checkmate",
					'ChessLogo.png',
					['Screenshots/Chess/Chess1.png',
					'Screenshots/Chess/Chess2.png',
					'Screenshots/Chess/Chess3.png',
					'Screenshots/Chess/Chess4.png'],
					'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/QPHWTCFtSQA?rel=0" frameborder="0" allowfullscreen></iframe>',
					"https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/Chess'>Access this Game ");			

games[4] = new Game ("Mining",
					'Mining is inspired by the Flash Game "Motherload." It employs concepts of randomization, collision detection, and basic physics. The game is controlled with the WASD keys. The objective is to mine all the pieces of gold. The mining machine will explode if it runs out of gas. This can be prevented by collecting barrels of fuel.',
					 "MiningLogo.png",
					 ['Screenshots/Mining/Mining1.png',
					 'Screenshots/Mining/Mining2.png',
					 'Screenshots/Mining/Mining3.png',
					 'Screenshots/Mining/Mining4.png'],
					 '<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/xG9dI6BoEMo?rel=0" frameborder="0" allowfullscreen></iframe>',
					 "https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/Mining'>Access this Game ");		

games[5] = new Game ("3D Combat",
					"Employs collision detection, transform rotation, translation, and scaling. Camera tracks player position. Enemy AI has basic functionality and only activate when the player is nearby. Inclusion of GUI elements that interact with other classes. Speed slider is meant for debugging, not final build.",
					"DemoLogo.png",
					['Screenshots/Demo/Demo1.png',
					'Screenshots/Demo/Demo2.png',
					'Screenshots/Demo/Demo3.png',
					'Screenshots/Demo/Demo4.png'],
					'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/xFc3dt4G78w?rel=0" frameborder="0" allowfullscreen></iframe>',
					"https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/3D%20Combat%20Demo'>Access this Game ");

games [6] = new Game ("Puck Wars",
						"All pucks related programs run off Lee Spector's Pucks environment: <a href = 'https://github.com/lspector/pucks'>https://github.com/lspector/pucks</a>. The also use the application Counterclockwise to run a Clojure REPL which launched a Java applet using Quil. The basic concept of pucks is creating intelligent and adaptable agents. The pucks in question are designed to battle.",
						'PuckWarsLogo.png',
						['Screenshots/PuckWars/PuckWars1.png',
						'Screenshots/PuckWars/PuckWars2.png',
						'Screenshots/PuckWars/PuckWars3.png',
						'Screenshots/PuckWars/PuckWars4.png'],
						'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/80x9-HsBGWs?rel=0" frameborder="0" allowfullscreen></iframe>',
						"https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/Puck-Wars '>Access this Project");

games [7] = new Game ("Quoridor",
						'Quoridor is an adaption of the board game of the same name. I co-programmed it in my Intro to Game Programming class using the Unity Engine and C#. My partner and I pitched this game using a design doc, to substitute for the perscripted final game. We finished the programming within the span of a few weeks and presented this as our final for the class.',
						'QuoridorLogo.png',
						['Screenshots/Quoridor/Quoridor1.png',
						'Screenshots/Quoridor/Quoridor2.png',
						'Screenshots/Quoridor/Quoridor3.png',
						'Screenshots/Quoridor/Quoridor4.png'],
						'<h2> Gameplay: </h2><iframe width="420" height="315" src="https://www.youtube.com/embed/CUOTZfT73-o?rel=0" frameborder="0" allowfullscreen></iframe>',
						"https://github.com/imann24/Isaiah_Mann_Coding_Portfolio/tree/master/Intro%20to%20Game%20Programming/Quoridor '>Access this Game");
games [8] = new Game ("Ellen Bernstein",
						'This is a personal website I designed for Ellen Bernstein, Advisor for Identity and Praxis at Hampshire College. It uses the SquareSpace environment, as well as custom HTML and CSS code in order to deliver a rounded and informative personal website. This site contains multimedia elements and varied graphic design',
						'Ellen.png',
						['Screenshots/Ellen/Ellen1.png',
						'Screenshots/Ellen/Ellen2.png',
						'Screenshots/Ellen/Ellen3.png',
						'Screenshots/Ellen/Ellen4.png'],
						'<p></p>',
						"http://www.ellenbernstein.org/'>Access this Site ");

games[9] = new Game ("Critical Connections",
						"I'm currently interning for Critical Connections, a non-profit organization based out of Western Massachusetts. As their web programming intern, I've worked closely with the executive director in redesigning and adding additional content to the site, using WordPress in combination with custom CSS and HTML.",
						"CriticalConnectionsLogo.png",
						['Screenshots/Critical/Critical1.png',
						'Screenshots/Critical/Critical2.png',
						'Screenshots/Critical/Critical3.png',
						'Screenshots/Critical/Critical4.png'],
						'<p></p>',
						"http://www.criticalconnections.org/'>Access this Site ");

function addGame (game) {
	
	var theHTML = 	"<div class = 'GameBox'><div id = 'ExtraPadding'>" + addImage(game.mainPic, true) + 
		"<h1>" + game.title + "</h1>" + addImage(game.screenshots[0], true) +
		"</div><br><br><br><br><br><br><br><br>" +
		"<a href =' " + game.link + "</a>" + 
		"<p>" + game.summary + "</p>" + 
		"<h2> Screenshots: </h2>" + addScreenShots(game) + 
		game.video +
		"<h3>Show More</h3>" + "<br>" +
		"</div>";
	$('body').append(theHTML);
}

function addImage (image, isLogo) {
	var imageSource = "";
	if (isLogo) {
		imageSource = "<img src = 'Assets/" + image + "' id = 'Logo'>";
	} else {
		imageSource = "<img src = 'Assets/" + image + "' id = 'Toggle'>";
	}
	return imageSource;
}

function addScreenShots (game) {
	var imageSource ="";
	for (var i = 0; i < game.screenshots.length; i++) {
		imageSource += addImage(game.screenshots[i], false)
	}
	return imageSource;
}

function showAndHide () {
	$('h2').toggle(300);
	$('.GameBox #Toggle').toggle(300);
	$('iframe').toggle(300);
}

$(function() {
	    $('.GameBox h3').click(function() {
	       $(this).empty();
	      if($(this).siblings('h2').is(":visible")) {
	      	$(this).append("Show More");
	      } else {
	      	$(this).append("Show Less");
	      }
		$(this).siblings('h2').toggle(300);
		$(this).siblings('.GameBox #Toggle').toggle(300);
		$(this).siblings('iframe').toggle(300);
			});
	});