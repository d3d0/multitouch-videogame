////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	GestureCore.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl
{
	import gl.events.TouchEvent;
	
	import gl.touches.TouchDown;
	import gl.touches.TouchIn;
	import gl.touches.TouchMove;
	import gl.touches.TouchOut;
	import gl.touches.TouchUp;
	import gl.touches.TouchTap;
	import gl.touches.TouchDoubleTap;
	
	import id.core.DescriptorAssembly;
	import id.core.IDescriptor;
	import id.modules.IModuleFactory;
	
	import id.system.Requires;
	import id.system.SystemRegister;
	import id.system.SystemRegisterType;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class GestureCore extends EventDispatcher implements IModuleFactory //IModule
	{
		
		include "../id/core/Version.as";
		
		public static var register:SystemRegister = new SystemRegister
		(
			"GestureCore",
			id_internal::VERSION,
			SystemRegisterType.LIBRARY
		);
		
		protected var activatorEvent:Class;
		protected var activators:Object =
		{
		};
		
		protected var pathEvents:Array;
		protected var paths:Object =
		{
		};
		
		protected var gestureEvent:Class;
		protected var gestures:Object = 
		{
		};
		
		private var touchEvent:Class = TouchEvent;
		private var touches:Object =
		{
			touchDown: TouchDown,
			touchMove: TouchMove,
			touchUp: TouchUp,
			touchTap: TouchTap,
			touchDoubleTap: TouchDoubleTap
		};
		
		private var touchDegradationMap:Object =
		{
			touchDown: MouseEvent.MOUSE_DOWN,
			touchMove: MouseEvent.MOUSE_MOVE,
			touchUp: MouseEvent.MOUSE_UP,
			touchTap: MouseEvent.CLICK,
			touchDoubleTap: MouseEvent.DOUBLE_CLICK
		};
		
		private var _created:Object;
		
		public function GestureCore()
		{
			Requires.establish
			(
				GestureCore, 
				SystemRegisterType.LIBRARY,
				{
					"GestureWorks": "2.0.0.0"
				}
			);
		}
		
		private function createModules(collection:Object):Object
		{
			for(var k:String in collection)
			{
				collection[k] = new collection[k]();
			}
			
			return collection;
		}
		
		public function create(... args):Object
		{
			trace("creating...");
			
			if(!_created)
			{
				trace("Gesture Core Constructor");
				activators = createModules(activators);
				gestures = createModules(gestures);
				touches = createModules(touches);
	
				_created = {};
				
				_created[DescriptorAssembly.ACTIVATOR_EVENT] = activatorEvent;
				_created[DescriptorAssembly.GESTURE_EVENT] = gestureEvent;
				_created[DescriptorAssembly.PATH_EVENTS] = pathEvents;
				
				_created[DescriptorAssembly.ACTIVATORS] = activators;
				_created[DescriptorAssembly.GESTURES] = gestures;
				_created[DescriptorAssembly.TOUCHES] = touches;
				
				_created[DescriptorAssembly.PATHS] = paths;
				
				_created[DescriptorAssembly.TOUCH_DEGRADATION_MAP] = touchDegradationMap;
			}
	
			return _created;
		}
		
		public function info():Object
		{
			return {
				version: id_internal::VERSION
			};
		}
		
		public function addTouchModule(eventName:String, moduleClass:Class):Class
		{
			touches[eventName] = moduleClass;
			
			return moduleClass;
		}
		
		public function removeTouchModule(eventName:String):Class
		{
			var cls:Class = touches[eventName];
			if(!cls)
			{
				return null;
			}
			
			delete touches[eventName];
			
			return cls;
		}
		
	}

}