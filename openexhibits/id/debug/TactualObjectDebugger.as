////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TactualObjectDebugger.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.debug
{

import id.core.ApplicationGlobals;
import id.core.IDisposable;
import id.managers.IValidationManager;
import id.managers.IValidationManagerHook;
import id.system.SystemHook;
import id.tracker.ITrackerHook;

import flash.display.Sprite;
import flash.utils.Dictionary;

public class TactualObjectDebugger extends SystemHook
	implements ITrackerHook, IValidationManagerHook, IDisposable
{
	
	private var _debugSprite:Sprite;
	private var _debugCallbacks:Array;
	
	private var _responding:Boolean;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function TactualObjectDebugger()
	{
		_debugSprite = new Sprite();
		_debugCallbacks = [];
	}
	
    //--------------------------------------------------------------------------
    //
    //  Destructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Destructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	override public function Dispose():void
	{
		if (_debugSprite.parent)
		{
			_debugSprite.parent.removeChild(_debugSprite);
			_debugSprite = null;
		}
		
		_debugCallbacks = null;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * Get the associated display object used to draw the points contained
     * within the tracker.
     * 
     * @return A <code>Sprite</code> object containing the drawn points.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function get debugSprite():Sprite
    {
        return _debugSprite;
    }
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Registers a method against the validation system's complete cycle.  If
     * the visual debug mode is enabled within GestureWorks, the registerd
     * method will be called after all currently tracked points are drawn into
     * this object's debug layer.
     * 
     * @param f The method registered as a callback.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function registerCallback(f:Function):void
	{
		if(_debugCallbacks.indexOf(f) != -1)
			return;
			
		_debugCallbacks.push(f);
	}
	
    /**
     * Unregisters a method against the validation system's complete cycle.
     * 
     * @param f The method to unregistered as a callback.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public function unregisterCallback(f:Function):void
	{
		var index:int = _debugCallbacks.indexOf(f);
		if (index == -1)
			return;
			
		_debugCallbacks.splice(index, 1);
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Override
	////////////////////////////////////////////////////////////
    
    /**
     * @private
     */
	override public function validationComplete():void
	{
		if(!_responding)
			return;
			
		var tactualObjects:Dictionary = _tracker.tactualObjects;

		_debugSprite.graphics.clear();
		_debugSprite.graphics.beginFill(0x333399);
		
		// tactual objects
		for(var k:String in tactualObjects)
		{
			_debugSprite.graphics.drawCircle(tactualObjects[k].x, tactualObjects[k].y, 5);//drawEllipse(tO.x, tO.y, 8, 8);
		}
		
		_debugSprite.graphics.endFill();
		
		for(var idx:uint=0; idx<_debugCallbacks.length; idx++)
		{
			_debugCallbacks[idx].apply(null, [_debugSprite.graphics]);
		}
	}

    /**
     * Starts the debugging system.  Methods registered against the validation
     * system will now be called.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	override public function start():void
	{
		_responding = true;
		_debugSprite.visible = true;
	}
	
    /**
     * Stops the debugging system.  Methods registered against the validation
     * system will no longer be called until started again.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	override public function stop():void
	{
		_responding = false;
		_debugSprite.visible = false;
	}

	////////////////////////////////////////////////////////////
	// Methods: Event Overrides
	////////////////////////////////////////////////////////////
    /**
     * @private
     */
	override protected function onValidationManagerChanged(validationManager:IValidationManager):void
	{
		ApplicationGlobals.application.stage.addChild(_debugSprite);
	}
	
	
}

}