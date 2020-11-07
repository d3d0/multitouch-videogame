package {
	import flash.display.*;
	import flash.text.*;
	import flash.media.*; 
	import flash.net.*;
	import flash.utils.Timer; // timer
	import flash.events.Event; // ATTENZIONE
	import flash.events.MouseEvent; 
	import flash.events.TimerEvent; // timer
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import id.core.Application;
	import id.core.TouchSprite;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;
	
	import caurina.transitions.*;
		
	public class SestoGioco extends TouchSprite {
		
		/***********************************************************/
		/** variabili **********************************************/
		
		// sfondo
		//private var tile:Background = new Background(new Material05(0,0));
		
		// contatore
		private var count:int;
		
		// coordinate
		var nuovaX:int;
		var nuovaY:int;
		var vecchiaX:int;
		var vecchiaY:int;
		
		// index array
		//private var index:int;
		private var indexDisegni:int = 0;
		
		// array per contenitori e musica
		private var containerArray:Array;
		private var pulsantiArray:Array;
		
		private var disegniArray:Array;
		private var coloriArray:Array;
		
		private var oggettiArray:Array;
		private var shuffledOggetti:Array;
		
		private var oggettoAttualeX:Array;
		private var oggettoAttualeY:Array;
		private var oggettoPosizione:Array;
		
		// SUONI
		private var mp3Array:Array;
		private var mp3EffettiArray:Array;
		private var channelArray:Array;
		
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
		var faccia01 = new Faccia01();
		var faccia02 = new Faccia02();
		var faccia03 = new Faccia03();
		var faccia04 = new Faccia04();
		var faccia05 = new Faccia05();
		var faccia06 = new Faccia06();
		var faccia07 = new Faccia07();
		var faccia08 = new Faccia08();
		var faccia09 = new Faccia09();
		var faccia10 = new Faccia10();
		
		// disegno corrente
		var currentGraphics:MovieClip;
		
		// suoni		
		var channel01:SoundChannel = new SoundChannel();
		var channel02:SoundChannel = new SoundChannel();
		
		var timerScreen:int = 300000;
		var timerGlobale = new Timer(timerScreen, 1);
		
		/*************************************************************/
		/** costruttore **********************************************/
		
		public function SestoGioco() {
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function addedHandler(event:Event):void {
			
			
			// pos oggetto attuale
			oggettoPosizione = [ ];
			
			for(var id:int=0; id<8; id++){
				var aggiornaPosizione:Boolean= new Boolean(false);
				oggettoPosizione.push(aggiornaPosizione);
			}
			
			// x oggetto attuale
			oggettoAttualeX = [ ];
			
			for(var id:int=0; id<8; id++){
				var oggettoX:int = new int(0);
				oggettoAttualeX.push(oggettoX);
			}
			
			// y oggetto attuale
			oggettoAttualeY = [ ];
			
			for(var id:int=0; id<8; id++){
				var oggettoY:int = new int(0);
				oggettoAttualeY.push(oggettoY);
			}
			
			// suoni
			mp3EffettiArray = ["sceltagioco.mp3"];
			mp3Array = ["corretto.mp3", "sbagliato.mp3", "giococompletato.mp3"];
			
			channelArray = [channel01, channel02];
			
			containerArray = [container_01, container_02, container_03, container_04, container_05,
							  container_06, container_07, container_08, container_09, container_10];
			
			disegniArray = [faccia01, faccia02, faccia03, faccia04, faccia05,
							faccia06, faccia07, faccia08, faccia09, faccia10];
			
			// forme scelte a random
			oggettiArray = [];
			
			trace("### Schermata --> Primo Gioco aggiunta");
			//this.x = (stage.stageWidth - this.width) ;
			//this.y = (stage.stageHeight - this.height) ;
			
			// ***********************************
			// pulsanti --> screen
			
				container_screen_saver.addChild(screensaver);
				container_screen_saver.addEventListener(TouchEvent.TOUCH_DOWN,screenSaver);
			addChild(container_screen_saver);
			
			timerGlobale.addEventListener(TimerEvent.TIMER, onTimerFacce );
			
			function onTimerFacce(evt:TimerEvent):void
			{
				var e:Event = new Event('gotoHome');
				dispatchEvent(e);
			}
			timerGlobale.start();
			
			// ***********************************
			// pulsanti --> home
			
			container_button_home.addChild(button_Home);
			container_button_home.addEventListener(TouchEvent.TOUCH_TAP,gotoHome);
			addChild(container_button_home);
			
			// ***********************************
			// pulsante --> facce
			
			// prendo una faccia a RANDOM dall'array disegniArray
			function randomRange(max:Number, min:Number = 0):Number
				{
					 return Math.floor(Math.random() * (max - min) + min);
				}
				
			var risultato:int = randomRange(disegniArray.length);
						
			addChildAt(disegniArray[risultato], 2); // --> INDEX DOPO LO SFONDO (0) e LO SPECCHIO (1)
			currentGraphics = disegniArray[risultato];
			
			// conto i child dentro il clip Faccia e prendo solo i MovieClip
			// poi metto in un array gli oggetti (occhio, bocca, naso)
			// mentre gli oggetti che hanno nome "occhio_pos" non li considero
			for (var j:int = 0; j < currentGraphics.numChildren; j++){
				   if (currentGraphics.getChildAt(j) is MovieClip) {
					  
					  
					  trace("movieclip: "+j);
					  var nome:String = currentGraphics.getChildAt(j).name;
					  trace(nome.split("_"));
					  var contentArray:Array = nome.split("_");
					  if(contentArray.length<2)
					  	oggettiArray.push(currentGraphics.getChildAt(j));
					  
				  }
			}
			
			trace(oggettiArray);
			
			// visualizzo l'array ordinato
			for(var b:int = 0; b < oggettiArray.length; b++) {
				trace("------array ordinato: "+oggettiArray[b].name);
				
			}
			
			// ARRAY DI OGGETTI PER LA FACCIA
			// randomizzo l'array per gli oggetti --> formeArray e creo shuffledOggetti
			shuffledOggetti = new Array(oggettiArray.length);
			var randomPos:Number = 0;
			for (var a:int = 0; a < shuffledOggetti.length; a++)
			{
				
				randomPos = int(Math.random() * oggettiArray.length);
				shuffledOggetti[a] = oggettiArray.splice(randomPos, 1)[0]; 
				trace("array shuffle: "+shuffledOggetti[a].name);
			}
			
			// ***********************************
			// pulsanti --> oggetti facce
			trace("SHUFFLE OGGETTI LENGTH: "+(shuffledOggetti.length-2));
			
			
			// ATTENZIONE AL NUMERO LENGTH
			for(var i:int = 0; i < shuffledOggetti.length-2; i++) {
				this.x = 0;
				containerArray[i].addChild(shuffledOggetti[i]);
				
				shuffledOggetti[i].y = 470;
				shuffledOggetti[i].x = 350;
				if (i>0)
					shuffledOggetti[i].x = 350+(i*120);
				
				oggettoAttualeX[i] = containerArray[i].x;
				oggettoAttualeY[i] = containerArray[i].y;
				
				trace("OGGETTI X: "+ oggettoAttualeX[i]);
				
				//Tweener.addTween(pulsantiArray[i],{x: i*130,time:1.2,transition:"easeoutelastic"});
				//Tweener.addTween(pulsantiArray[i],{y: ((stage.stageHeight-pulsantiArray[i].height)/2),time:1,transition:"easeoutelastic"});
				
				containerArray[i].blobContainerEnabled = true;
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, startDrag_Press1);
				containerArray[i].addEventListener(TouchEvent.TOUCH_DOWN, screenSaver);
				containerArray[i].addEventListener(TouchEvent.TOUCH_UP, stopDrag_Release1);
				addChild(containerArray[i]);
				
				trace("Container x: " + containerArray[i].x);
				trace("Pulsanti Array height: " + shuffledOggetti[i].height);
				
			}
				
			//on every played frame check if there is any collision detected
      		addEventListener(Event.ENTER_FRAME, checkIfHitTest);
			
		}
		
		private function removedHandler(event:Event):void {
			
		}
		
		/********************************************************/
		/** metodi **********************************************/
		
		private function gotoHome(event:TouchEvent):void {
			trace("# Evento --> Attivazione Home");
			
			var e:Event = new Event('gotoHome');
			dispatchEvent(e);
			
			var channel:SoundChannel = new SoundChannel();
			var audioMp3 = mp3EffettiArray[0];
			var mysound:Sound = new Sound(); /* IMPORTANTE */
			mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
			channel = mysound.play(0);
			
			timerGlobale.stop();
		}
		
		private function screenSaver(e:TouchEvent):void {
			timerGlobale.reset();
			timerGlobale.start();
			trace("SCREENSAVER RESET");
		}
		
		private function checkIfHitTest(e:Event):void {
			  //circle_mc.x = mouseX - circle_mc.width / 2;
			  //circle_mc.y = mouseY - circle_mc.height / 2;
			  //var i:int = oggettiArray.length;
			  for each (var movie:MovieClip in faccia01) {
			  
			  }
			  
					
		}
		
		private function suonoAvvertimento(isShow:Boolean):void {
		  if(isShow) {
				trace("FORMA GIUSTA!");
				// SUONO
				var channel001:SoundChannel = new SoundChannel();
				var audioMp3 = mp3Array[0];
				var mysound:Sound = new Sound(); /* IMPORTANTE */
				mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
				channel001 = mysound.play(0);
			}
			else {
				trace("FORMA SBAGLIATA!");
				var channel002:SoundChannel = new SoundChannel();
				var audioMp3 = mp3Array[1];
				var mysound:Sound = new Sound(); /* IMPORTANTE */
				mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
				channel002 = mysound.play(1);
			}
		}
		
		
		private function startDrag_Press1(e:TouchEvent):void {
			/*var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);*/
			
			/*vecchiaX = (e.target.x);
			vecchiaY = (e.target.y);*/
			
			/*oggettoAttualeX[index] = (e.target.x);
			oggettoAttualeY[index] = (e.target.y);*/
			
          	e.target.startTouchDrag(-1);
		}
		private function stopDrag_Release1(e:TouchEvent):void {
			e.target.stopTouchDrag(-1);
			
			
			//myText.text = "NO COLLISION";
			
			nuovaX = (e.target.x);
			nuovaY = (e.target.y);
			
			var index:int = containerArray.indexOf(e.target);
			trace("INDEX ARRAY: " + index);
			
			var forma:Boolean = true;
			var hit:Boolean = false;
			
			for (var i:uint = 0; i < currentGraphics.numChildren; i++){
				
				if (currentGraphics.getChildAt(i) is MovieClip) {
						  if(shuffledOggetti[index].hitTestObject(currentGraphics.getChildAt(i)) ) {
							  
							  	hit=true;
								
								var sposta:Boolean = true;
								
								var posizione:String = shuffledOggetti[index].name + "_pos";
								trace("POSIZIONE: "+posizione);
								if(posizione == currentGraphics.getChildAt(i).name && forma) {
									
										removeChild(containerArray[index])//.removeEventListener(TouchEvent.TOUCH_DOWN, startDrag_Press1);
										if(shuffledOggetti[index].name == "orecchiosx" || shuffledOggetti[index].name == "orecchiodx") {
											
											 // --> INDEX DOPO LO SFONDO (0) e LO SPECCHIO (1) e prende il posto della FACCIA (2)
											addChildAt(shuffledOggetti[index],2); 
										}
										else {
											trace("NUMERO CHILD: "+this.numChildren);
											addChildAt(shuffledOggetti[index], this.numChildren);
										}
											
										
										shuffledOggetti[index].x = currentGraphics.getChildAt(i).x;
										shuffledOggetti[index].y = currentGraphics.getChildAt(i).y;
										
										
										//myText.text ="MATCH";
										
										trace(" *** MATCH OGGETTO *** ");
										
										forma=false;
										sposta=false;
										
										
										count++;
										if(count>(shuffledOggetti.length-3)){
											timerGlobale.stop();
											trace("RICARICA GIOCO");
											count=0;
											
											trace("gioco finito!");
											// SUONO
											channelArray[0].stop();
											var audioMp3 = mp3Array[2];
											var mysound:Sound = new Sound(); /* IMPORTANTE */
											mysound.load(new URLRequest("suoni/effetti/" + audioMp3));
											channelArray[0] = mysound.play(2);
													
											var timerAggiungi:int = 2000;
											var timer = new Timer(timerAggiungi, 1);
											timer.addEventListener(TimerEvent.TIMER, onTimerFacce );
											
											function onTimerFacce(evt:TimerEvent):void
											{
												var eventsesto:Event = new Event('ricaricaSestoGioco');
												dispatchEvent(eventsesto);
											}
											timer.start();
										}
										else
										{
											suonoAvvertimento(true);
										}
								}
								
								if(sposta) {
								
								/*e.target.x = oggettoAttualeX[index];
								e.target.y = oggettoAttualeY[index];*/
								/*Tweener.addTween(e.target,{x:oggettoAttualeX[index],time:0.5,transition:"easeOutQuart"});
								Tweener.addTween(e.target,{y:oggettoAttualeY[index],time:0.5,transition:"easeOutQuart"});*/
								Tweener.addTween(e.target,{x:0,time:0.5,transition:"easeOutQuart"});
								Tweener.addTween(e.target,{y:0,time:0.5,transition:"easeOutQuart"});
								}
						  }
						 
				  }
					
			}
			if (hit && forma)
				suonoAvvertimento(false);
			
		}
	}
}
