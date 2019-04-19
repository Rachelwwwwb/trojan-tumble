<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.IOException" import="java.sql.Connection" import="java.sql.DriverManager"
	import="java.sql.PreparedStatement" import="java.sql.ResultSet" import="java.sql.SQLException"%>
<!DOCTYPE html>
<html lang="en"> 
<head> 
    <meta charset="UTF-8" />
    <title>Trojan Tumble</title>
    <script src="//cdn.jsdelivr.net/npm/phaser@3.11.0/dist/phaser.js"></script>
    <style type="text/css">
        body {
            margin: 0;
        }
    </style>
</head>
<%
	int avatar = (int)session.getAttribute("avatar");
	String loggedIn = (String)session.getAttribute("loggedIn");
	String user = "GUEST";
	if(loggedIn.equals("true")){
		user = (String)session.getAttribute("user"); 
		user = user.toUpperCase();
	}
	int currentID = 0;
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	String jdbcUrl = "jdbc:mysql://aagurobfnidxze.cesazkri7ef1.us-east-2.rds.amazonaws.com:3306/game?user=user&password=password";					
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		System.out.println("Driver loaded");
		conn = DriverManager.getConnection(jdbcUrl);

		ps = conn.prepareStatement("INSERT INTO Threads(username) VALUES(?)");
		ps.setString(1, user);
		ps.execute();
		
		ps = conn.prepareStatement("SELECT COUNT(threadID) FROM Threads");
		rs = ps.executeQuery();
		
		while(rs.next()){
			currentID = rs.getInt("COUNT(threadID)");
		}
		
	}catch(SQLException sqle) {
		System.out.println("sqle game: " + sqle.getMessage());
	}catch(ClassNotFoundException cnfe) {
		System.out.println("cnfe game: " + cnfe.getMessage());
	}finally {
		try {
			if(rs != null) rs.close();
			if(ps != null) ps.close();
			if(conn != null) conn.close();
		}catch (SQLException sqle) {
			System.out.println("sqle game finally: " + sqle.getMessage());
		}
	}
%>
<body>

	<script type="text/javascript">
		
		/* ---------- Global Variables ----------*/
		var config = {
		    type: Phaser.AUTO,
		    width: 1440,
		    height: 900,
		    physics: {
		        default: 'arcade',
		        arcade: {
		            gravity: { y: 300 },
		            debug: false
		        }
		    },
		    scene: {
		        preload: preload,
		        create: create,
		        update: update
		    }
		};
		
		var currentID = <%=currentID%>;
		console.log("currentID: " + currentID);
		var lastOne;
		
		var game = new Phaser.Game(config);
		
		var gameOver = false;
		
		var camera;
		
		var start_count_ready = 0;
		var start_count_go = 0;
		var startText;
		
		var avatar  = <%=avatar%>;
		var player;
		var platforms;		
		var cursors;
		var coinCount = 0;		
		var coinText;
		var scoreCount = 0;
		var scoreText;
		var dungeon;
		var coins, diamonds,rubys;
		var lives = 5;
		var heart1;
		var heart2;
		var heart3;
		var heart4;
		var heart5;
		var firstTime = true;
		/* ---------- End Global Variables ----------*/
		
		
		
		
		/* ---------- Load Assets ----------*/
		function preload ()
		{
		    this.load.image('dungeon', 'assets/dungeon.png');
		    this.load.image('ground', 'assets/ground2.png');
		    this.load.image('coin', 'assets/goldcoin.png');
		    this.load.image('purple_diamond', 'assets/purple_diamond.png')
			this.load.image('heart','assets/heart.png');
		    this.load.image('ruby','assets/ruby.png')
			
		    //audio
		    this.load.audio('music', 'assets/fightsong.mp3')
		    
			if(avatar == 1){ //trojan
				this.load.spritesheet('trojan', 'assets/trojan_sheet_idleSmall.png', { frameWidth: 48, frameHeight:  48});
			    this.load.spritesheet('trojanRun', 'assets/trojan_sheet_run_aligned-BASELINESmall.png', { frameWidth: 48, frameHeight:  48});
			}
			else if(avatar == 2){ //sergeant
				this.load.spritesheet('trojan', 'assets/sergeant_sheet_idleSmall.png', { frameWidth: 48, frameHeight:  48});
			    this.load.spritesheet('trojanRun', 'assets/sergeant_sheet_run_aligned-BASELINESmall.png', { frameWidth: 48, frameHeight:  48});
			}
			else if(avatar == 3){ //viking
				this.load.spritesheet('trojan', 'assets/viking_sheet_idleSmall.png', { frameWidth: 48, frameHeight:  48});
			    this.load.spritesheet('trojanRun', 'assets/viking_sheet_run_aligned-BASELINESmall.png', { frameWidth: 48, frameHeight:  48});
			}
			else{ //4 - samurai 
				this.load.spritesheet('trojan', 'assets/samurai_sheet_idleSmall.png', { frameWidth: 48, frameHeight:  48});
			    this.load.spritesheet('trojanRun', 'assets/samurai_sheet_run_aligned-BASELINESmall.png', { frameWidth: 48, frameHeight:  48});
			}
		    
		    //this.trojanRun.anchor.setTo(0.5, 0.5);
		}
		/* ---------- 			----------*/
		
		
		
		/* ---------- Create Main Game Structure----------*/
		function create ()
		{
		    //  Add background
		    dungeon = this.add.tileSprite(720, 450, 1440, 900, 'dungeon');
		    
		    // Set bounds
		    this.physics.world.setBounds(0, 0, 1440, 900);
		    
		    //music
		    music = this.sound.add('music', {
		    	
		    	mute: false,
		    	loop: true,
		    	delay: 0
		    });
		    music.play();
			
			// Add platform group
		    platforms = this.physics.add.group({
		    	key: 'ground',
		    	repeat: 200,
		    	setScale: { x: 0.4, y: 0.3}
		    });
		    platforms.enableBody = true;
			
		    // Initialize platform child
		    platforms.children.iterate(function (child) {
				
		        child.body.immovable = true;
		        child.active = false;
		
		    });
		    
		    //initalize hearts
		    heart1 = this.add.image(40, 120, 'heart').setScale(0.35);
		    heart2 = this.add.image(90, 120, 'heart').setScale(0.35);
		    heart3 = this.add.image(140, 120, 'heart').setScale(0.35);
		    heart4 = this.add.image(190, 120, 'heart').setScale(0.35);
		    heart5 = this.add.image(240, 120, 'heart').setScale(0.35);
		 	   
		    
		    //  Some coins to collect, 12 in total, evenly spaced 70 pixels apart along the x axis
		    coins = this.physics.add.group({
		        key: 'coin',
		        repeat: 10,
		        /* setXY: { x: 12, y: 0, stepX: 140 }, */
		        setScale: { x: 0.01, y: 0.01 }
		    });
		    coins.enableBody = true;
		
		    coins.children.iterate(function (child) {
		
		        //  Give each coin a slightly different bounce
		        //child.setBounceY(Phaser.Math.FloatBetween(0.4, 0.8));
		        child.body.immovable = true;
		        child.active = false;
		
		    });
		    
		    // add diamonds, worth 50 coins
		   	diamonds = this.physics.add.group({
		        key: 'purple_diamond',
		        repeat: 1,
		        /* setXY: { x: 12, y: 0, stepX: 140 }, */
		        setScale: { x: 0.04, y: 0.04 }
		    });
		    diamonds.enableBody = true;
		
		    diamonds.children.iterate(function (child) {
		
		        //  Give each coin a slightly different bounce
		        //child.setBounceY(Phaser.Math.FloatBetween(0.4, 0.8));
		        child.body.immovable = true;
		        child.active = false;
		
		    });
		    
		    //add ruby to get extra lives
		    rubys = this.physics.add.group({
		    	key:'ruby',
		    	repeat:1,
		        setScale: { x: 1, y: 1 }

		    });
		    rubys.enableBody = true;
		    rubys.children.iterate(function (child) {
				child.body.immovable = true;
		        child.active = false;
		    });
		    
		    // The player and its settings
		    player = this.physics.add.sprite(100, 0, 'trojan');
		    player.setBounce(0.2);
		    player.setCollideWorldBounds(true);
		
		    //  Our player animations, turning, walking left and walking right.
		    this.anims.create({
		        key: 'left',
		        frames: this.anims.generateFrameNumbers('trojanRun', { start: 0, end: 3 }),
		        frameRate: 10,
		        repeat: -1
		    });
			
		    this.anims.create({
		        key: 'turn',
		        frames: this.anims.generateFrameNumbers('trojan', { start: 0, end: 3 }),
		        frameRate: 10,
		        repeat: -1
		    });
		    
		    this.anims.create({
		        key: 'right',
		        frames: this.anims.generateFrameNumbers('trojanRun', { start: 0, end: 3 }),
		        frameRate: 10,
		        repeat: -1
		    });
			
		    
		    //  Input Events
		    cursors = this.input.keyboard.createCursorKeys();
		
		    //  The coin
		    coinText = this.add.text(16, 16, 'Coins: 0', { fontSize: '32px', fill: 'rgb(255,255,255)' });
		    
		    // scores
		    scoreText = this.add.text(16, 50, 'Score: 0', { fontSize: '32px', fill: 'rgb(255,255,255)' });
		    
		    // start text
		    startText = this.add.text(500, 300, 'Ready', { fontSize: '150px', fill: 'rgb(255, 255, 255)' });
		
		    //  Collide the player and the coins with the platforms
		    this.physics.add.collider(player, platforms);
		    this.physics.add.collider(coins, platforms);
		    this.physics.add.collider(diamonds, platforms);
		    this.physics.add.collider(rubys, platforms);

		
		    //  Checks to see if the player overlaps with any of the coins, if he does call the collectCoin function
		    this.physics.add.overlap(player, coins, collectCoin, null, this);
		    this.physics.add.overlap(player, diamonds, collectDiamond, null, this);
		    this.physics.add.overlap(player, rubys, collectRuby, null, this);

		    // Loop infinitely and add platforms
		    var timer_plat = this.time.addEvent({ 
		    	delay: 1000, 
		    	callback: addPlatform, 
		    	callbackScope: this, 
		    	loop: true
		    });  
		    
		    
		    //test camera
		    camera = this.cameras;
		    camera.main.setBounds(0, 0, 1440, 900);
		}
		/* ---------- 				 ----------*/
		
		
		/* ---------- Update Game Status Every Frame ----------*/
		function update ()
		{
			var username;
			ajaxGet('multiServlet?currentID='+currentID,function(results){
                if (results != lastOne && results != null && results != "null"){
                	username = results;
                    console.log("results: "+ results);
                    console.log("lastone: "+ lastOne);
                    lastOne = results;
                    currentID++;
					
                }
            })
			//start game
			if(start_count_ready == 120 && start_count_go <= 180){
				startText.setText('Go!');
			}
			else if(start_count_ready > 120 && start_count_go > 180){
				startText.setText('');
			}
			if(start_count_ready < 200 && start_count_go < 200){
				start_count_ready++;
				start_count_go++;
			}
			// end game
			if(gameOver){
				this.physics.pause();
				player.setTint(0xff0000);
				this.add.text(450, 350, 'Game Over', { fontSize: '100px', fill: 'rgb(255,255,255)' });
				var urlParams = new URLSearchParams(window.location.search);
				urlParams.append('coins', coinCount);
				urlParams.append('score', scoreCount);
				var url = "http://trojan-tumble.us-east-2.elasticbeanstalk.com/TrojanTumble?update=results&" + urlParams;
				window.location.replace(url);
				game.destroy();
				return;
			}
			// Move background and platforms up
			dungeon.tilePositionY += 2;
			platforms.setVelocityY(-125);
			coins.setVelocityY(-125);
			diamonds.setVelocityY(-125);
			rubys.setVelocityY(-125);

			
			//  Add and update the scores
		    scoreCount += 2;
		    scoreText.setText('Score: ' + scoreCount);
			
			// kill platforms that are out of bounds
			platforms.children.iterate(function (child) {
		        if (child.y <= 0) {
		            platforms.kill(child);
		        }
		    });
			
			// kill coins out of bound
			coins.children.iterate(function (child) {
		        if (child.y <= 0) {
		            coins.kill(child);
		        }
		        if (child.alive){
		        	child.body.immovable = false;
		        }
		    });
			
			// kill diamonds out of bound
			diamonds.children.iterate(function (child) {
		        if (child.y <= 0) {
		            diamonds.kill(child);
		        }
		        if (child.alive){
		        	child.body.immovable = false;
		        }
		    });
			
			rubys.children.iterate(function (child) {
		        if (child.y <= 0) {
		            rubys.kill(child);
		        }
		        if (child.alive){
		        	child.body.immovable = false;
		        }
		    });
			
		    // Set cursor event
		    if (cursors.left.isDown)
		    {
		        player.setVelocityX(-160);
		
		        player.anims.play('left', true);
            	player.flipX = true;

	        }
	        else if (cursors.right.isDown)
	        {
	            player.setVelocityX(160);
	
	            player.anims.play('right', true);
	            player.flipX = false;
	        }
	        else
	        {
	            player.setVelocityX(0);
	            player.anims.play('turn', true);
	        }
			
		    // Set player jump event
	        if (cursors.up.isDown && player.body.touching.down)
	        {
	            player.setVelocityY(-450);
	        }
	
	        
	        
	        if (player.y <= 10)
	        {
	        	if (firstTime){
	        		firstTime = false;
	        	}
	        	else {
	        		loseLive();
	        		player.y = 200;
	        	}

	
	        }
	        
	        if (player.y >=875) {
	        	loseLive();
            	player.y = 200;
	        }
		}
		
		
		function collectCoin (player, coin)
		{
		    //coin.disableBody(true, true);
			coin.active = false;
			coin.disableBody(true, true);
		    //  Add and update the coins
		    coinCount += 1;
		    coinText.setText('Coins: ' + coinCount);
		}
		
		function ajaxGet(endpointUrl, returnFunction){
            var xhr = new XMLHttpRequest();
            xhr.open('GET', endpointUrl, true);
            xhr.onreadystatechange = function(){
                if (xhr.readyState == XMLHttpRequest.DONE) {
                    if (xhr.status == 200) {
                        returnFunction( this.responseText );

                    } else {
                        alert('AJAX Error.');
                        console.log(xhr.status);
                    }
                }
            }
            xhr.send();
        };
		
		function collectDiamond (player, diamond)
		{
			diamond.active = false;
			diamond.disableBody(true, true);
			
			coinCount += 50;
			coinText.setText('Coins: ' + coinCount);
		}
		
		function collectRuby (player, ruby){
			ruby.active = false;
			ruby.disableBody(true,true);
			
			addLive();
		}
		
 		function loseLive ()
 		{	
 			camera.main.shake(500, 0.01);
 			if (lives <= 1){
 				heart1.alpha = 0;
 				gameOver = true;
 			}
 			else if (lives == 2){
 				heart2.alpha = 0;
 			}
 			else if (lives == 3){
 				heart3.alpha = 0;
 			}
 			else if (lives == 4){
 				heart4.alpha = 0;
 			}
 			else if (lives == 5){
 				heart5.alpha = 0;
 			}
 			lives--;
		} 
 		
 		function addLive(){
 			if (lives == 1){
 				heart2.alpha = 1;
 	 			lives ++;
 			}
 			else if (lives == 2){
 				heart3.alpha = 1;
 	 			lives ++;
 			}
 			else if (lives == 3){
 				heart4.alpha = 1;
 	 			lives ++;
 			}
 			else if (lives == 4){
 				heart5.alpha = 1;
 	 			lives ++;
 			}
 		}
		
		function addTile(x, y){
			//Get a tile that is not currently on screen
			var tile = platforms.getFirstDead();
			
			if(tile != null){
				tile.active = true;
			    //Reset it to the specified coordinates
			    tile.enableBody(true, x, y);
			    tile.body.velocity.y = -125; 
			    tile.body.immovable = true;
			}

		}
		
		function addPlatform(y){
			//Work out how many tiles we need to fit across the whole screen
		    var tilesNeeded = 20;
			
			if(typeof(y) == "undefined"){
				y = 935;
			}
			
			var tilesNeeded = Math.ceil(1440/50);
			
		    //Add a hole randomly somewhere
		    var hole = Math.floor(Math.random() * (tilesNeeded - 3)) + 1;
		
		    //Keep creating tiles next to each other until we have an entire row
		    //Don't add tiles where the random hole is
		    var skipped = false;
		    var curr_len = 0;
		    
		    for (var i = 0; i < tilesNeeded; i++){
		    	//randomly skip first part or last part
		    	var skip_factor = Math.random();
		    	if(skip_factor < 0.1 && !skipped && (curr_len == 0 || curr_len > 5)){
		    		break;
		    	}
		    	else if(skip_factor > 0.9 && !skipped){
		    		i += Math.floor((skip_factor - 0.9) * 3 * tilesNeeded);
		    		skipped = true;
		    	}
		    	
		    	
		    	//randomly add holes
		    	var hole_length = Math.floor(Math.random() * 3 + 1);
		    	var make_hole = Math.ceil(Math.random() * 5);
		    	if(make_hole == 3 && curr_len > 5){
		    		i+= hole_length;
		    		curr_len = 0;
		    		continue;
		    	}
		    	addTile(i*51.2, y);
		    	curr_len++;
		    }
		    
		    //add coin
			var coin_num = Math.ceil(Math.random() * 5);
		    
			for(var i=0; i<coin_num; i++){
				//randomly place these coins
				var tile = coins.getFirstDead();
				if(tile != null){
					tile.active = true;
					tile.body.velocity.y = -125; 
				    tile.body.immovable = true;
					tile.enableBody(true, Math.random() * 1440, 900, true, true);
				}
				
			}
			
			// add diamond
			var diamond_num = Math.floor(Math.random() * 10);
			
			if(diamond_num == 3){
				var tile = diamonds.getFirstDead();
				if(tile != null){
					tile.active = true;
					tile.body.velocity.y = -125; 
				    tile.body.immovable = true;
					tile.enableBody(true, Math.random() * 1440, 900, true, true);
				}
			}
			
			//add ruby
			var ruby_num = Math.floor(Math.random() * 10);
			
			if(ruby_num == 3){
				var tile = rubys.getFirstDead();
				if(tile != null){
					tile.active = true;
					tile.body.velocity.y = -125; 
				    tile.body.immovable = true;
					tile.enableBody(true, Math.random() * 1440, 900, true, true);
				}
			}
		}
	</script>

</body>

</html>