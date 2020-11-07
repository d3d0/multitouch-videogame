////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PhysicsSprite.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{

import id.core.ApplicationGlobals;
import id.core.TouchSprite;
import gl.events.TouchEvent;
import gl.events.GestureEvent;

import flash.geom.*;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

use namespace id_internal;

public class PhysicsSprite extends TouchSprite
{
	public static const RESTING:String	= "noMotion";
	public static const MOVING:String = "inMotion";
	
	/* settings */
	private var physicsON:Boolean = false;
	private var clockON:Boolean = false;
	private var accuracy:Number;
	private var environment:Number;
	
	private var library:String;
	private var ease_type:String;
	
	private var velocity:Boolean;
	private var friction:Boolean;
	private var bounds:Rectangle;
	private var boundary:Boolean;
	private var gravity:Boolean;
	private var collision:Boolean;
	private var spin:Boolean;
	
	/* momentum */
	private var px:Number;
	private var py:Number;
	private var prot:Number; 
	
	/* kinetic energy */
	private var kex:Number;
	private var key:Number;
	private var kerot:Number;
	
	/* time */
	private var timer:Timer;
	private var interval:Number = 60;
	private var timerOn:Boolean;
	private var frameON:Boolean = false
	
	/* precision */
	private var prepos:Number = 0.001;
	private var preang:Number = 0.001;
	private var presca:Number = 0.0005;
	
	
	/* dynamic properties */
	public var dvx:Number;
	public var dvy:Number;
	public var dvang:Number;
	public var dvsc:Number;
	
	public var dx:Number;
	public var dy:Number;
	public var dang:Number;
	public var dsc:Number;
	
	/* static properties */
	public var maxVel:Number;
	public var maxAngVel:Number;
	public var maxScVel:Number;
	
	public var surfric:Number;
	public var scafric:Number;
	public var angfric:Number;
	public var airfric:Number;
	
	public var magpos:Number;
	public var magsca:Number;
	public var magang:Number;
	
	public var ebound:Number;
	public var eobj:Number;
	
	public var gmag:Number;
	public var gtheta:Number;
	public var mass:Number;
	public var density:Number;
	public var radius:Number;
	private var w:Number;
	private var h:Number;
	
	//private var minScale:Number;
	//private var maxScale:Number;
	
	private var x1:Number;
	private var y1:Number;
	
	/* xml data */
	private var _xml:XMLList;
	
	/* params */
	private var _defaults:Object = {
		
		accuracy: 1,
		environment: 0,
		
		library: "custom",
		ease_type: "linear",
		
		magpos: 1,
		magsca: 1,
		magang: 1,
		
		velocity: false,
		friction: true,
		bounds: new Rectangle(0,0,1280,720),
		boundary: false,
		gravity: false,
		collision: false,
		spin: false,
		
		dvx: 0,
		dvy: 0,
		dvang: 0,
		dvsc: 0,
		
		dx: 0,
		dy: 0,
		dang: 0,
		dsc: 0,
		
		prepos: 0.001,
		preang: 0.001,
		presca: 0.001,
		
		maxVel: 20,
		maxAngVel: 30,
		maxScVel: 0.2,
		
		surfric: 0.98,
		scafric: 0.97,
		angfric: 0.97,
		airfric: 0.97,
		
		ebound: 1,
		eobj: 1,//0.8,
		
		gmag: 10,//9.812,
		gtheta: 0,
		mass: 1,
		density: NaN,
		radius: 50,
		w: NaN,
		h: NaN,
		
		minScale: 0,
		maxScale: 200,
		
		ix: 0,
		iy: 0,
		iscaleX: 1,
		iscaleY: 1,
		irot: 0
	}
	
	public function PhysicsSprite(initials:Object = null) {
		super();
		
		_xml = ApplicationGlobals.dataManager.touchPhysics;
		
		physicsON = _xml.physicsON == "true" ? true : false ;
		clockON = _xml.clockON == "true" ? true : false ;
		interval = _xml.interval;
		gmag = _xml.gmag;
		library = _xml.library;
		ease_type = _xml.ease_type;
				
		if (!physicsON){ 
			//trace("returned");
		return 
		}

		// set varaibles and parameters //
		setParams(_xml, _defaults, _defaults);
		setParams(initials, _defaults);
		initVars();
		initProps();
 
		// add mouse listeners //
		//this.addEventListener(MouseEvent.MOUSE_DOWN, dragSHandler);
		//this.addEventListener(MouseEvent.MOUSE_UP, dragRHandler);
		
		// add touch and gesture listeners //
		/*var GestureEvent:Class = TouchObjectGlobals.GestureEvent;
		if (GestureEvent && GestureEvent.hasOwnProperty("RELEASE"))
		{*/
		addEventListener(GestureEvent.RELEASE, releaseHandler, false, 0, true);
		//}
		addEventListener("stopTouchDrag", dragReleaseHandler, false, 0, true);
		
		
		//-------------------------------------------------------------------//
		///////////////////////////////////////////////////////////////////////
		
		if(clockON){	
			// create object clock //
			timer = new Timer(1000/interval);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			startTimer();
		}
		//------------------------------------------------------------------//
	}
	
	private var _minScale:Number;
	private var _maxScale:Number;
	
	public function get maxScale():Number { return _maxScale; }
	public function set maxScale(value:Number):void
	{
		_maxScale = value;
	}
	
	public function get minScale():Number { return _minScale; }
	public function set minScale(value:Number):void
	{
		_minScale = value;
	}
	
	
	
	private function initVars(): void {		
		
		accuracy = _params.accuracy
		environment = _params.environment
		
		library = _params.library
		ease_type = _params.ease_type
		
		magpos = _params.magpos
		magsca = _params.magsca 
		magang = _params.magang
		
		velocity = _params.velocity
		friction = _params.friction
		bounds = _params.bounds
		boundary = _params.boundary
		gravity = _params.gravity
		collision = _params.collision
		spin = _params.spin
		
		dvx = _params.dvx
		dvy = _params.dvy
		dvang = _params.dvang
		dvsc = _params.dvsc
		
		dx = _params.dx
		dy =_params.dy
		dang = _params.dang
		dsc = _params.dsc
		
		prepos = _params.prepos
		preang = _params.preang
		presca = _params.presca
		
		maxVel = _params.maxVel
		maxAngVel = _params.maxAngVel
		maxScVel = _params.maxScVel
		
		surfric = _params.surfric
		scafric = _params.scafric
		angfric = _params.angfric
		airfric = _params.airfric
		
		ebound = _params.ebound
		eobj = _params.eobj
		
		gmag = _params.gmag
		gtheta = _params.gtheta
		mass = _params.mass
		density = _params.density
		
		radius = _params.radius
		
		//radius = _params.rad
		w = _params.w
		h = _params.h
		
		minScale = _params.minScale
		maxScale = _params.maxScale
		
		this.x = _params.ix
		this.y = _params.iy
		this.scaleX = _params.iscaleX
		this.scaleY = _params.iscaleY
		this.rotation = _params.irot
	}
	
	private function initProps():void {
		//trace("init props");
		if(!velocity){
			posRandom();
		}
		else if (velocity){
			centerCircRandom();
		}
	}
	
	//----------------- on enter frame --------------------------//
	private function onFrame(e:Event):void {
		//trace("frame");
		motionTest();
	}
	private function startOnFrame():void {
				this.addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
				frameON = true;
				//trace("onEnterframe init");
	}
	private function stopOnFrame():void {
				this.removeEventListener(Event.ENTER_FRAME, onFrame);
				frameON = false;
				//trace("onEnterframe removed");
	}
//---------------- timer event handler ----------------------//
	private function onTimer(et:TimerEvent):void {
		//trace("tick tock", timer.currentCount, x, y);
		motionTest();
		et.updateAfterEvent();
	}
	//--------------- timer controls ----------------------------//
	private function startTimer():void {
		timer.start();
		timerOn = true;
	}
	private function stopTimer():void {
		timer.stop();
		timerOn = false;
	}
	//----------------------------------------------------------//
	
	/**
	 *	This function preforms all necessairy calculations for 
	 *	the physics related to drag releases.
	 *
	 *	params: e as TouchEvent
	 *	returns: void
	 *	references: @TouchObject
	 */
	 
	 // mouse event handlers //
	/* private function dragSHandler(e:Event) {
			x1 = this.x;
			y1 = this.y;
		}
	 
	 private function dragRHandler(e:Event) {
			var k = magpos;
			var x2 = this.x;
			var y2 = this.y;
				dx = k*(x2-x1);
				dy = k*(y2-y1);
			
			if((!timerOn)&&(clockON)){
				startTimer()
			}
		}*/
	
	// touch and gesture event handlers //
	private function dragReleaseHandler(e:TouchEvent):void {
			var k:Number = magpos//0.5;
				dx = k*e.dX;
				dy = k*e.dY;
			
			if((!timerOn)&&(clockON)){
				startTimer()
			}
			if((!clockON)&&(!frameON)){
				startOnFrame();
			}
		}
		
		private function releaseHandler(e:GestureEvent):void {
			//trace("released", e.value);
			var k0:Number = magpos//0.01;
			var k1:Number = magsca//0.01;
			var k2:Number = magang//0.01;
			
			/*if (e.name == GestureEvent.GESTURE_DRAG){
				dx = k0*e.valueX;
				dy = k0*e.valueY;
			}*/
			if (e.name == GestureEvent.GESTURE_SCALE){
				dsc = k1*e.value;
			}
			if (e.name == GestureEvent.GESTURE_ROTATE){
				dang = k2*e.value;
			}
			
			if((!timerOn)&&(clockON)){
				startTimer()
			}
			if((!clockON)&&(!frameON)){
				startOnFrame();
			}
		}
	
	//--------------------------------------------------------//

	
	private function motionTest():void {
		
				if ((!dx)&&(!dy)&&(!dang)&&(!dsc)){
					//trace("stopped")
						if(clockON){
							stopTimer();
						}
						if(frameON){
							stopOnFrame();
						}
					this.dispatchEvent(new Event (PhysicsSprite.RESTING));
				} else{
					motion();
					//trace("moving");
					this.dispatchEvent(new Event (PhysicsSprite.MOVING));
				}
		}
		
		
	private function motion():void {
			
		///////////////////////////////////////////////////////////////////
		// with friction  /////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
				if(friction){ 
					//-------------- clean tween --------------------//
					if ((dx)||(dy)){
						if ((Math.abs(dx)<prepos)&&(Math.abs(dy)<prepos)) {
							dx = 0;
							dy = 0;
						}
					}
					//------------- change of x pos ----------------//
					if (dx){
						if(!gravity){
							//if(ease_type="linear"){
								dx *= Math.pow(surfric,2);
							//}
							//if(ease_type="exp"){
								//dx = (surfic)*Math.exp(-1.1,dx);
							//}
						}
						if(gravity){
							dx *= airfric;
							dx += gmag*Math.sin(gtheta*(Math.PI/180));
						}
					// check max vel
					/*if (Math.abs(dx)>maxVel) {
						dx = (Math.abs(dx)/dx)*maxVel;
					}*/
					x += dx;
					}
					//---------- change of y pos --------------------//	
					if(dy){
						if(!gravity){
							//dy *= surfric;
							dy *= Math.pow(surfric,2);
						}
						if(gravity){
							dy *= airfric;
							dy += gmag*Math.cos(gtheta*(Math.PI/180));
						}
						// check max vel
						/*if (Math.abs(dy)>maxVel) {
							dy = (Math.abs(dy)/dy)*maxVel;
						}*/
						y += dy;
					}
					//-------- change of angle--------------//
					if(dang){
						if (Math.abs(dang)<preang) {
							dang = 0;
						} else {
							dang *= angfric;
							this.rotation += dang;
						}
						// check max vel
						/*if (Math.abs(dang)>maxAngVel) {
							dang = (Math.abs(dang)/dang)*maxAngVel;
						}*/
					}
					//-------- change of scale -------------//
					if(dsc){			
						if (Math.abs(dsc)<presca) {
							dsc = 0;
						} else {
							dsc *= scafric;
							
							if (((scaleX+dsc) < maxScale)&&((scaleX+dsc) > minScale)){
								scaleX += dsc;
								scaleY += dsc;
							}
							if((scaleX+dsc) >= maxScale){
								scaleX = maxScale;
								scaleY = maxScale;
							}
							if ((scaleX+dsc) <= minScale){
								scaleX = minScale;
								scaleY = minScale;
							}
						}
						// check max vel
						/*if (Math.abs(dsc)>maxScVel) {
							dsc = (Math.abs(dsc)/dsc)*maxScVel;
						}*/
					}
				}
		/////////////////////////////////////////////////////////////////////
		// no friction //////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////
		else{
			
			//if ((dx)&&(dy)){
				if ((Math.abs(dx)<prepos)&&(Math.abs(dx)<prepos)){
					dx = 0;
					dy = 0;
				}
			//}
			// change of x pos 
			if (dx){
				if(gravity){
					dx += gmag*Math.cos(gtheta);
				}
				// check max vel
				if (Math.abs(dx)>maxVel) {
					dx = (Math.abs(dx)/dx)*maxVel;
				}
				x += dx;
			}
				
			// change of y pos //	
			if(dy){
				if(!gravity){
					dy *= surfric;
				}
				if(gravity){
					dy += gmag*Math.sin(gtheta);
				}
				// check max vel
				if (Math.abs(dy)>maxVel) {
					dy = (Math.abs(dy)/dy)*maxVel;
				}
				y += dy;
			}
			
			// change of angle //
			if(dang){
				if (Math.abs(dang)<preang) {
					dang = 0;
				} else {
					this.rotation += dang;
				}
				// check max vel
				/*if (Math.abs(dang)>maxAngVel) {
					dang = (Math.abs(dang)/dang)*maxAngVel;
				}*/
			}
			
			// change of scale //
			if(dsc){			
				if (Math.abs(dsc)<presca) {
					dsc = 0;
				} else {
					
					if (((scaleX+dsc) < maxScale)&&((scaleX+dsc) > minScale)){
						scaleX += dsc;
						scaleY += dsc;
					}
					if((scaleX+dsc) >= maxScale){
						scaleX = maxScale;
						scaleY = maxScale;
					}
					if ((scaleX+dsc) <= minScale){
						scaleX = minScale;
						scaleY = minScale;
					}
				}
				// check max vel
				/*if (Math.abs(dsc)>maxScVel) {
					dsc = (Math.abs(dsc)/dsc)*maxScVel;
				}*/
			}

		}
			
			checkBoundCollide();
	}
			
			
			
	private function checkBoundCollide():void {
					
					if((!bounds)||(!boundary))
						return;

					if (x <= bounds.left + radius){
							x = bounds.left + radius;
							dx *= -ebound;
						}
					else if (x >= (bounds.right - radius)){
							x = bounds.right - radius;
							dx *= -ebound;
						}
					else if (y >= (bounds.bottom - radius)){
							y = bounds.bottom - radius;
							dy *= -ebound;
						}
					else if (y <= bounds.top + radius){
							y = bounds.top + radius;
							dy *= -ebound;
					}
	}
	
	// preset test values //
	public function posRandom():void {
		dx = 0;
		dy = 0;
		x = (bounds.left + radius) + (Math.floor(Math.random()*(bounds.right - bounds.left + 1 - 2*radius)));
		y = (bounds.top + radius) + (Math.floor(Math.random()*(bounds.bottom - bounds.top + 1 - 2*radius)));
		//trace("centered circular random", radius);
	}

	public function centerRandom():void {
		dx = Math.random()*5;
		dy = Math.random()*5;
		x = (bounds.left + radius) + (Math.floor(Math.random()*(bounds.right - bounds.left + 1 - 2*radius)));
		y = (bounds.top + radius) + (Math.floor(Math.random()*(bounds.bottom - bounds.top + 1 - 2*radius)));
		//trace("centered circular random", radius);
	}
	
	public function centerCircRandom():void {
		
		var W:Number = bounds.right - bounds.left;
		var H:Number = bounds.bottom - bounds.top;
		var contRad:Number = 100
		var randAng:Number = (Math.PI/180)*360*Math.random();
		
		
		dx = Math.random()*20;
		dy = Math.random()*20;
		x = W/2 + contRad*Math.sin(randAng)*Math.random();
		y = H/2 + contRad*Math.cos(randAng)*Math.random();
		//trace("centered circular random", radius);
	}
	
	public function centerTubeRandom():void {
		
		var W:Number = bounds.right - bounds.left;
		var H:Number = bounds.bottom - bounds.top;
		var contRad:Number = 100
		var randAng:Number = (Math.PI/180)*360*Math.random();
		
		
		dx = Math.random()*5;
		dy = Math.random()*5;
		x = W/2 + contRad*Math.sin(randAng)*Math.random();
		y = H/2 + contRad*Math.cos(randAng)*Math.random();
		//trace("centered circular random", radius);
	}
	
	
		
	/*private function checkObjCollide(){

		}*/
	
	
	
	
	/*public function get acceleration():Number { return _params.acceleration; }
	public function set acceleration(value:Number):void {
		_params.acceleration = value;
	}*/
}
	
}