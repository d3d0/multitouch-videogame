package {
	
	import com.coreyoneil.collision.CollisionList; // COLLISIONI
	
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.TimerEvent; // timer
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	
	import caurina.transitions.*;
		
	public class PrimoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// index array
		private var indexDisegni:int = 0;
		//private var colore:Boolean = false;
		
		// array per contenitori e musica
		private var containerArray:Array;
		private var pulsantiArray:Array;
		
		private var disegniArray:Array;
		private var coloriArray:Array;
		
		private var mp3EffettiArray:Array;
		
		private var oggettoAttualeCount:Array;
		private var oggettoPosizione:Array;
		
		// contenitori --> TouchSprite
		var container_button_home = new TouchSprite();
		var container_screen_saver = new TouchSprite();
		var container_01 = new TouchSprite();
		var container_02 = new TouchSprite();
		var container_03 = new TouchSprite();
		var container_04 = new TouchSprite();
		var container_05 = new TouchSprite();
		var container_06 = new TouchSprite();
		var container_07 = new TouchSprite();
		var container_08 = new TouchSprite();
		var container_09 = new TouchSprite();
		var container_10 = new TouchSprite();
		var container_avanti = new TouchSprite();
		var container_indietro = new TouchSprite();
		
		
		// clip disegni
		var disegno01 = new Disegno01();
		var disegno02 = new Disegno02();
		var disegno03 = new Disegno03();
		var disegno04 = new Disegno04();
		var disegno05 = new Disegno05();
		var disegno06 = new Disegno06();
		var disegno07 = new Disegno07();
		var disegno08 = new Disegno08();
		var disegno09 = new Disegno09();
		var disegno10 = new Disegno10();
		
		// disegno corrente
		var currentGraphics:MovieClip;
		
		// timer
		var timerScreen:int = 300000;
		var timer = new Timer(timerScreen, 1);
		
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function PrimoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			oggettoPosizione = [ ];
			
			for(var id:int=0; id<8; id++){
				var aggiornaPosizione:Boolean= new Boolean(false);
				oggettoPosizione.push(aggiornaPosizione);
			}
			
			// id oggetto attuale
			oggettoAttualeCount = [ ];
			
			for(var id:int=0; id<8; id++){
				var countOggetto:int = new int(0);
				oggettoAttualeCount.push(countOggetto);
			}
			
			mp3EffettiArray = ["sceltagioco.mp3"];
			
			containerArray = [container_01, container_02, container_03, container_04, container_05,
							  container_06, container_07, container_08, container_09, container_10];
			
			pulsantiArray = [colore01, colore02, colore03, colore04, colore05,
							 colore06, colore07, colore08, colore09, colore10];
			
			disegniArray = [disegno01, disegno02, disegno03, disegno04, disegno05,
							disegno06, disegno07, disegno08, disegno09, disegno10];
			
			coloriArray = [0x000000,0x000099,0x00CCFF,0x009933,0x66FF00, 0xff6699,0xff0000,0xFF9900,0xFFFF00,0xFFFFFF];
			
			trace("### Schermata --> Primo Gioco aggiunta");
			//this.x = (stage.stageWidth - this.width) ;
			//this.y = (stage.stageHeight - this.height) ;
			
			// ***********************************
			// pulsanti --> home
			
				container_button_home.addChild(button_Home);
				container_button_home.addEventListener(TouchEvent.TOUCH_DOWN,gotoHome);
			addChild(container_button_home);
			
			// ***********************************
			// pulsanti --> screen
			
				container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_screen_saver);
			
			timer.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				var e:Event = new Event('gotoHome');
				dispatchEvent(e);
			}
			timer.start();
			
			// ***********************************
			// pulsante --> palette
			
			//addChild(palette_colori);
			
			addChild(disegno01);
			currentGraphics = disegno01;
			
					
			for(var i:int = 0; i < containerArray.length; i++) {
				this.x = 0;
				//this.sfondoRiferimento.width = stage.stageWidth;
				
				containerArray[i].addChild(pulsantiArray[i]);
				
				//pulsantiArray[i].y = (this.height-pulsantiArray[i].height)/2;
				
				// x dinamica
				// pulsantiArray[i].x = i*90;
				//Tweener.addTween(pulsantiArray[i],{x: i*130,time:1.2,transition:"easeoutelastic"});
				//Tweener.addTween(pulsantiArray[i],{y: ((stage.stageHeight-pulsantiArray[i].height)/2),time:1,transition:"easeoutelastic"});
				
				containerArray[i].blobContainerEnabled = true;
				//containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, startDrag_Press1);
				containerArray[i].addEventListener(GestureEvent.GESTURE_DRAG_1, startDrag_Gesture);
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, screenSaver);
				containerArray[i].addEventListener(TouchEvent.TOUCH_UP, stopDrag_Release1);
				addChild(containerArray[i]);
				
				trace("Container x: " + containerArray[i].x);
				trace("Pulsanti Array height: " + pulsantiArray[i].height);
				
			}
				
			//on every played frame check if there is any collision detected
      		addEventListener(Event.ENTER_FRAME, checkIfHitTest);
			
			// frecce avanti / indietro
			container_avanti.addChild(btnAvanti);
			container_avanti.addEventListener(TouchEvent.TOUCH_TAP,frecciaAvanti);
			addChild(container_avanti);
			container_indietro.addChild(btnIndietro);
			container_indietro.addEventListener(TouchEvent.TOUCH_TAP,frecciaIndietro);
			addChild(container_indietro);
			

		}
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		private function frecciaAvanti(e:TouchEvent) {
			removeChild(currentGraphics);
			
			trace("CHILD: "+this.numChildren);
			
			if (indexDisegni>=9) {
				addChildAt(disegniArray[0], 3);
				currentGraphics = disegniArray[0];
				indexDisegni=0;
				trace(indexDisegni);
			}
			else {
				addChildAt(disegniArray[indexDisegni+1], 3);
				currentGraphics = disegniArray[indexDisegni+1];
				indexDisegni++;
				trace(indexDisegni);
			}
			
			/** TWEENER *****************************************/
			
			/*
			Tweener.addTween(player,{x:((stage.stageWidth - player.width) / 2),time:1.2,transition:"easeoutelastic"});
			Tweener.addTween(player,{y:((stage.stageHeight - player.height) / 2),time:1,transition:"easeoutelastic"});
			*/
			
			/** NORMALE ****************************************
			/*
			player.x = (stage.stageWidth - player.width) / 2;
			player.y = (stage.stageHeight - player.height) / 2;
			
			addChild(player);
			currentScreen = player;
			*/
			
		}
		private function frecciaIndietro(e:TouchEvent) {
			removeChild(currentGraphics);
			
			if (indexDisegni<=0) {
				addChildAt(disegniArray[9], 3);
				currentGraphics = disegniArray[9];
				indexDisegni=9;
				trace(indexDisegni);
			}
			else {
				addChildAt(disegniArray[indexDisegni-1], 3);
				currentGraphics = disegniArray[indexDisegni-1];
				indexDisegni--;
				trace(indexDisegni);
			}
			
		}
		private function gotoHome(event:TouchEvent):void {
			trace("# Evento --> Attivazione Home");
			
			var e:Event = new Event('gotoHome');
			dispatchEvent(e);
			
			var channel:SoundChannel = new SoundChannel();
			var audioMp3 = mp3EffettiArray[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel = mysound.play(0);
			
			timer.stop();
		}
		
		private function screenSaver(e:TouchEvent):void {
			timer.reset();
			timer.start();
		}
		
		private function checkIfHitTest(e:Event):void {
			  //circle_mc.x = mouseX - circle_mc.width / 2;
			  //circle_mc.y = mouseY - circle_mc.height / 2;
			  //var i:int = oggettiArray.length;
			  for each (var movie:MovieClip in disegno01) {
			  
			  }
			  
					
		}
		
		private function showBoundaries(isShow:Boolean):void {
			  if(isShow)
		  {
			
	 
		  }
		  else
		  {
			
		  }
		}
		
		
		private function startDrag_Press1(e:TouchEvent):void {
			
			/*
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			
			Tweener.addTween(pulsantiArray[index],{scaleX:1.3,time:0.1,transition:"easeOutQuart", onComplete:func});
			Tweener.addTween(pulsantiArray[index],{scaleY:1.3,time:0.1,transition:"easeOutQuart"});
			
			function func() {
				Tweener.addTween(pulsantiArray[index],{scaleX:0.4,time:0.1,transition:"easeInQuart"});
				Tweener.addTween(pulsantiArray[index],{scaleY:0.4,time:0.1,transition:"easeInQuart"});
			}
			
			
			
          	e.target.startTouchDrag(e.tactualObject.target);
			oggettoAttualeCount[index]++;
			trace("COUNT ATTUALE: ***************: "+oggettoAttualeCount[index]);
			if(oggettoAttualeCount[index]==1){
			    // se e solo se ho il primo tocco mi salvo la posizione attuale
				
			   }
			*/
		}
		
		private function startDrag_Gesture(e:GestureEvent):void {
			var index:int = containerArray.indexOf(e.target);
			//trace("INDEX ARRAY: " + index);
			
			e.target.x += e.dx;
        	e.target.y += e.dy;
			
			pulsantiArray[index].scaleX = 0.4;
			pulsantiArray[index].scaleY = 0.4;
		}
		
		private function stopDrag_Release1(e:TouchEvent):void {
			//e.target.addEventListener(TouchEvent.TOUCH_DOWN, startDrag_Press1);
			
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			
			/*
			e.target.stopTouchDrag(e.tactualObject.target);
			
			oggettoAttualeCount[index] = oggettoAttualeCount[index]-1;
			trace("COUNT ATTUALE DOPO: ***************: "+oggettoAttualeCount[index]);
			
			if(oggettoAttualeCount[index]<1){
				
			}
			*/
			
			
			
			
			//myText.text = "NO COLLISION";
			
			var colore:Boolean = true;
			
			var myCollisionList:CollisionList;
			myCollisionList = new CollisionList(pulsantiArray[index]);
			
			for (var i:uint = currentGraphics.numChildren-1; i > 0; i--){
				   if (currentGraphics.getChildAt(i) is MovieClip ) {
					    myCollisionList.addItem(currentGraphics.getChildAt(i));
					  	
						/* vecchio metodo
						if(pulsantiArray[index].hitTestObject(currentGraphics.getChildAt(i)) && colore) {
							colore = false;
							//myText.text ="COLLISION";
							showBoundaries(true);
							trace(" *** COLLISSIONE OGGETTO *** ");
							var myColorTransform = new ColorTransform();
							myColorTransform.color = coloriArray[index];
							currentGraphics.getChildAt(i).transform.colorTransform = myColorTransform;
							e.target.x = 0;
							e.target.y = 0;
						  }
						 */
				  }
			}
			
			var collisions:Array = myCollisionList.checkCollisions();
			if(collisions.length > 0) 
			{
				trace(collisions[i].object1.name);
				showBoundaries(true);
				trace(" *** COLLISSIONE OGGETTO *** ");
				var myColorTransform = new ColorTransform();
				myColorTransform.color = coloriArray[index];
				collisions[i].object2.transform.colorTransform = myColorTransform;
				/*e.target.x = 0;
				e.target.y = 0;*/
			}
			
			/*
			Tweener.addTween(e.target,{x:0,time:0.3,transition:"easeOutQuart"});
			Tweener.addTween(e.target,{y:0,time:0.3,transition:"easeOutQuart"});
			*/
			pulsantiArray[index].scaleX = 1;
			pulsantiArray[index].scaleY = 1;
			e.target.x = 0;
			e.target.y = 0;
		}
	}
}
