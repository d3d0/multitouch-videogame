////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	PhysicsEngine.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.physics
{

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

import id.core.id_internal;
use namespace id_internal;

public class PhysicsEngine
{
	
	id_internal static var _instance:PhysicsEngine = new PhysicsEngine();
	public static function get instance():PhysicsEngine
	{
		return _instance;
	}
	
	public static function AddObject(obj:DisplayObject, method:String, params:Object):void
	{
		_instance.addObject(obj, method, params);
	}
	
	public static function RemoveObject(obj:DisplayObject):void
	{
		_instance.removeObject(obj);
	}
	
	public static function UpdateParams(obj:DisplayObject, params:Object):void
	{
		_instance.updateParams(obj, params);
	}
	
	public static function UpdateValues(obj:DisplayObject, values:Object):void
	{
		_instance.updateValues(obj, values);
	}
	
	private var objects:Dictionary;
	private var objectCount:int;
	
	private var timer:Sprite;
	private var rewriteRules:Array =
	[
		new RewriteRule(/.*rotate.*/i, "rotate"),
		new RewriteRule(/.*scale.*/i, "scale")
	];
	
	public function PhysicsEngine()
	{
		super();
		
		objects = new Dictionary(true);
		timer = new Sprite();
	}
	
	public function addObject(obj:DisplayObject, method:String, params:Object):void
	{
		var idx:uint;
		
		var matched:Boolean;
		var rule:RewriteRule;
		
		trace("PhysicsEngine::addObject -", obj, method, params);
		
		for(idx=0; idx<rewriteRules.length; idx++)
		{
			rule = rewriteRules[idx];
			
			if (method.match(rule.expression))
			{
				matched = true;
				method = rule.value;
				break;
			}
		}
		
		if(!matched)
		{
			return;
		}
		
		if(!objects[obj])
		{
			objects[obj] = [];
		}
		
		if(objects[obj].indexOf(method) != -1)
		{
			return;
		}
		
		//objects[obj] = 1;
		objects[obj].push(
		{
			method: method,
			params: params
		});
		
		if(!objectCount++)
		{
			timer.addEventListener(Event.ENTER_FRAME, timer_enterFrameHandler);
		}
	}
	
	public function removeObject(obj:DisplayObject):void
	{
		if(!objects[obj])
		{
			return;
		}
		
		objects[obj] = null;
		delete objects[obj];
		
		if(!--objectCount)
		{
			timer.removeEventListener(Event.ENTER_FRAME, timer_enterFrameHandler);
		}
	}
	
	public function updateParams(obj:DisplayObject, params:Object):void
	{
		
	}
	
	public function updateValues(obj:DisplayObject, values:Object):void
	{
		
	}
	
	private function processObjects():void
	{
		var k:Object;
		var j:String;
		
		var result:Object;
		
		trace("PhysicsEngine::processObjects()");
		
		for(k in objects)
		{
			trace("PhysicsEngine::processObjects() -", k);
			
			var dO:DisplayObject = k as DisplayObject;
			if(!dO || !dO.parent)
			{
				removeObject(dO);
				continue;
			}
			
			switch(dO.method)
			{
				
			}
		}
		
		//PhysicsApplicator.apply(dO, result);
	}
	
	private function timer_enterFrameHandler(event:Event):void
	{
		processObjects();
	}
	
	
}

}