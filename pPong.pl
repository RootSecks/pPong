###Perl Pong (pPong)###
##-RootSecks


##Uses:
use Switch;
use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Color;
use SDL::Event;
use SDL::TTFont;
##Uses
    
    
    ##Var decs
    our $winningscore = 5;
    our $event = new SDL::Event;

    our $playeronescore = 0;
    our $playertwoscore = 0;
        
    our $xspeed = 5;
    our $yspeed = 5;

    our $playeroneup = 0;
    our $playeronedown = 0; 
    
    our $playertwoup = 0;
    our $playertwodown = 0; 
    ##Dec that var
    
    
    
#Define constants for SDL objs
our $app = SDL::App->new(
	-title	=> 'pPOng',
	-width	=> 800,
	-height	=> 420,
	-depth	=> 16,
	-flags	=> SDL_DOUBLEBUFF | SDL_HWSURFACE | SDL_HWACCEL,
); 


our $ballrect = SDL::Rect->new(
	-width	=> 15,
	-height => 15,
	-x => 100,
	-y => 190,
);


our $color = SDL::Color->new(
	-r	=> 0x00,
	-g	=> 0x00,
	-b	=> 0xff,
);

our $bg_color = SDL::Color->new(
	-r	=> 0x00,
	-g	=> 0x00,
	-b	=> 0x00,
);



our $playeronerect = SDL::Rect->new(
	-width	=> 20,
	-height	=> 100,
	-x	=> 50,
	-y	=> 200,
);


our $playertworect = SDL::Rect->new(
    -width  => 20,
    -height => 100,
    -x      => 740,
    -y      => 200,
);

our $scorefont = SDL::TTFont->new(
    -name   => "/usr/share/fonts/truetype/freefont/FreeMono.ttf",
    -size   => 18,
    -bg     => $bg_color,
    -fg     => $color,
);




our $netrect = SDL::Rect->new(
    -width  => 10,
    -height => 10,
    -x      => 10,
    -y      => 10,
);



##SDL Objs




##COllision detection routine
sub collision_detect {
    
    #If the ball hits the right wall
    if ($ballrect->x >= ($app->width - $ballrect->width)) {
        &reset_game(1);
        warn("Point to player 1");
        warn($playeronescore . " | " . $playertwoscore);
    }
    
    
    
    ##If the ball hits the left wall
    if ($ballrect->x <= 0) {
        &reset_game(2);
        warn("point to player 2");
        warn($playeronescore . " | " . $playertwoscore);
    }
    
    #If the ball hits the roof
    if ($ballrect->y <= 5 || $ballrect->y >= ($app->height - $ballrect->height)) {
        $yspeed = ($yspeed * -1);
    }
                

    
    ##If the ball hits playerone paddle
    if ($ballrect->x >= $playeronerect->x && $ballrect->x <= ($playeronerect->x + $playeronerect->width)) {
        if ($ballrect->y >= $playeronerect->y && $ballrect->y <= ($playeronerect->y + $playeronerect->height)) {
        	$xspeed = ($xspeed * -1);
        }
    }
        
    ##if the ball hits player two paddle
    if (($ballrect->x + $ballrect->width) >= $playertworect->x && ($ballrect->x + $ballrect->width) <= ($playertworect->x + $playertworect->width)) {
        if ($ballrect->y >= $playertworect->y && $ballrect->y <= ($playertworect->y + $playertworect->height)) {
        	$xspeed = ($xspeed * -1);
        }
    }
        
    
    ##if playerones paddle hits the roof
    if ($playeronerect->y <= 0) {
        $playeroneup = 0;
    }

    ##If playerones paddle hits the floor
    if ($playeronerect->y >= ($app->height - $playeronerect->height)) {
        $playeronedown = 0;
    }
    
    
        ##if playerones paddle hits the roof
    if ($playertworect->y <= 0) {
        $playertwoup = 0;
    }

    ##If playerones paddle hits the floor
    if ($playertworect->y >= ($app->height - $playertworect->height)) {
        $playertwodown = 0;
    }

}

##COllision detecton reoutine#





sub reset_game
{
	
	
    my $winner = shift;    
    
    switch($winner) {
        case 1  { 
            $playeronescore = $playeronescore + 1;
                }
        case 2  {
            $playertwoscore = $playertwoscore + 1;
                }
    
    }
    
    
 

	$ballrect->x(($app->width / 2) - ($ballrect->width / 2));
	$ballrect->y(($app->height/2) - ($ballrect->height / 2));
    
    $playeronerect->y(($app->height/2) - ($playeronerect->height / 2));
    $playertworect->y(($app->height/2) - ($playertworect->height / 2));
    
    
    if ($playeronescore >= $winningscore || $playertwoscore >= $winningscore) {
    
        warn ("Player " . $winner . " is the winnnarrr!!!");
        
        $playeronescore = 0;
        $playertwoscore = 0;
    
    }
    
}





sub ini_rects
{
    ##Set ball location
    $ballrect->x(($app->width / 2) - ($ballrect->width / 2));
    $ballrect->y(($app->height/2) - ($ballrect->height / 2));
    
    
    ##Set player locations
    $playeronerect->y(($app->height/2) - ($playeronerect->height / 2));
    $playertworect->y(($app->height/2) - ($playertworect->height / 2));
    
    
    ##Set net location
    
    $netrect->height($app->height);
    $netrect->y(0);
    $netrect->x(($app->width / 2) - ($netrect->width / 2));
    
    
}

    


sub draw_frame {
		##Draw BG
		$app->fill(0, $bg_color);
				
		##Draw BALL
		$app->fill($ballrect, $color);
	
		
		##Draw Player one
		$app->fill($playeronerect, $color);

        
        #Draw Player Two
        $app->fill($playertworect, $color);

        
        ##Draw Net
        $app->fill($netrect, $color);

        
        
        ##Display scores
        $scorefont->print($app, 100, 50, $playeronescore);
        $scorefont->print($app, 660, 50, $playertwoscore);
        
        $app->sync();
}






##Check the key push events
sub key_check
{
    
    
            ##IIf the up key is pushed down
		if ($event->type == SDL_KEYDOWN && $event->key_name() eq 'up') {
			$playeroneup = 1; #Change the bool for player one moving up
            warn($event->key_name()); ##Send warn to the term
		}
		##if the up key is pushed down
        
        ##If the down key is pushed down		
		if ($event->type == SDL_KEYDOWN && $event->key_name() eq 'down') {
			$playeronedown = 1; #Change the bool for the player moving down 
			warn($event->key_name()); ##Warn to term
		}
		##If the down key is pushed down
		
        
        ##If the up key is releasd
		if ($event->type == SDL_KEYUP && $event->key_name eq 'up') {
			$playeroneup = 0; ##Change the bool for player one up move
			warn($event->key_name); ##Warn Term
		}
		##IF the up key is released

        ##If the down key is released
		if ($event->type == SDL_KEYUP && $event->key_name eq 'down') {
			$playeronedown = 0; ##Change the bool for the player one move down
			warn($event->key_name); ##Warn term
		}
        ##If the down key is released
        
        
        
        
        
        
        
        
        ##IIf the up key is pushed down
		if ($event->type == SDL_KEYDOWN && $event->key_name() eq 'w') {
			$playertwoup = 1; #Change the bool for player two moving up
            warn($event->key_name()); ##Send warn to the term
		}
		##if the up key is pushed down
        
        ##If the down key is pushed down		
		if ($event->type == SDL_KEYDOWN && $event->key_name() eq 's') {
			$playertwodown = 1; #Change the bool for the player two moving down 
			warn($event->key_name()); ##Warn to term
		}
		##If the down key is pushed down
		
        
        ##If the up key is releasd
		if ($event->type == SDL_KEYUP && $event->key_name eq 'w') {
			$playertwoup = 0; ##Change the bool for player two up move
			warn($event->key_name); ##Warn Term
		}
		##IF the up key is released

        ##If the down key is released
		if ($event->type == SDL_KEYUP && $event->key_name eq 's') {
			$playertwodown = 0; ##Change the bool for the player two move down
			warn($event->key_name); ##Warn term
		}
        ##If the down key is released
	
	
	
	####Speed control
		
		if ($event->type == SDL_KEYDOWN && $event->key_name eq '=') {
			
			$xspeed = $xspeed + 1;
			$yspeed = $yspeed + 1;
		}
		
		if ($event->type == SDL_KEYDOWN && $event->key_name eq '-') {
			
			if ($xspeed >= 2 && $yspeed >= 2) {
			
				$xspeed = $xspeed - 1;
				$yspeed = $yspeed - 1;
				
						
			}
		}
		
      
}
##Check for key push events




&event_loop(); 


sub event_loop {

    
    #Initalize some shit
    &ini_rects();


##Named loops ftw
MAIN_LOOP:
while(1) {
	
	while($event->poll)
	{
		
		my $type = $event->type();
	
		last MAIN_LOOP if ($type == SDL_QUIT);
		last MAIN_LOOP if ($type == SDL_KEYDOWN && $event->key_name eq 'escape');
        
        &key_check();        

		
	}	
	
		&collision_detect();
        
        
		$ballrect->x($ballrect->x + $xspeed);
		$ballrect->y($ballrect->y + $yspeed);
	
	
		&draw_frame();
		
		
		
		if ($playeroneup) {
			
			$playeronerect->y($playeronerect->y - 10);
				
		}
		
		if ($playeronedown) {
			
			$playeronerect->y($playeronerect->y + 10);
			
		}
        
        
        if ($playertwoup) {
			
			$playertworect->y($playertworect->y - 10);
				
		}
		
		if ($playertwodown) {
			
			$playertworect->y($playertworect->y + 10);
			
		}
		
		
		
		$app->delay(5);
		
	}
}
