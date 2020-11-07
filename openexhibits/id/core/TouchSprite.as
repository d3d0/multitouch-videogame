////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TouchSprite.as
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

import gl.events.TouchEvent;
	
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getTimer;
import id.utils.StringUtil;

//import id.physics.PhysicsEngine;

use namespace id_internal;

/**
 * Dispatched after a Touch_Move has been raised and the TouchSprite
 * position updated.  This only fires if a <code>startTouchDrag()</code>
 * was called to enable the TouchSprite as moveable.
 * 
 * <pre>
 * <b>Event Properties</b>
 *  x="target x"
 *  y="target y"
 * </pre>
 */
[Event(name="dragging", type="flash.events.Event")]

/**
 * The TouchSprite class is representative of total multi touch integration into 
 * the base Flash Sprite object.  It may act as a fundamental building block for
 * other applications and non-timeline based user interfaces.
 * 
 * <p>We will release, in the very near future (at or before the alpha launch), a 
 * TouchMovieClip, that will support timeline based user interface and application
 * design.</p>
 * 
  * <pre>
 * 	<b>Properties</b>
 * 	 blobContainer="undefined"
 * 	 blobContainerEnabled="false"
 * 	 touchChildren="true"
 * 
 *   topLevel="false"
 * </pre>
 */
public class TouchSprite extends TouchObjectContainer implements ITouchSprite
{
	
	/* params */
	private var _defaults:Object =
	{
	};
	
	////////////////////////////////////////////////////////////
	// Constructor: Default
	////////////////////////////////////////////////////////////
	/**
	 * Default constructor.
     */
	public function TouchSprite()
	{
		super();
		
		//physicsEnabled = true;
		//physicsParams = {};
	}
	
	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	
	/*
	private var _physicsEnabled:Boolean;
	
	public function get physicsEnabled():Boolean { return _physicsEnabled; }
	public function set physicsEnabled(value:Boolean):void
	{
		if(value == _physicsEnabled)
		{
			return;
		}
		
		var eventClass:Class = TouchObjectGlobals.gestureEvent;
		var eventString:String = TouchObjectGlobals.affineTransform_release_event;
		
		if(eventClass && !StringUtil.isEmpty(eventString))
		{
			if(value)
			{
				addEventListener(eventString, releaseHandler, false, 0, true);
			}
			else
			{
				removeEventListener(eventString, releaseHandler, false);
			}
		}
		
		if(!value)
		{
			PhysicsEngine.RemoveObject(this);
		}
		
		_physicsEnabled = value;
	}
	
	private var _physicsParams:Object;
	
	public function get physicsParams():Object { return _physicsParams; }
	public function set physicsParams(value:Object):void
	{
		// check for differences by k in value
		// update
		
		if(_physicsEnabled)
		{
			PhysicsEngine.UpdateParams(this, value);
		}
		
		_physicsParams = value;
	}
	*/
	
	////////////////////////////////////////////////////////////
	// Methods: Private
	////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	//-----------------------------------
	// Methods: Dragging
	//-----------------------------------
	id_internal var _dragging:Boolean;
	id_internal var _draggingBounds:Rectangle;
	id_internal var _draggingID:int;
	id_internal var _draggingReference:DisplayObject;
	id_internal var _draggingTime:Number;
	id_internal var _dragging_dX:Number = 0;
	id_internal var _dragging_dY:Number = 0;
	
	/**
	 * Enables a TouchSprite to be dragged.  The TouchSprite remains draggable until explicitly
	 * stopped by calling <code>TouchSprite.stopTouchDrag()</code>.  Multiple TouchSprites are
	 * draggable.
	 * 
	 * @example The following example creates a TouchSprite and enables it to be dragged by
	 * adding event listeners for Touch_Down and Touch_Up.  When the Touch_Down event is raised,
	 * we call <code>TouchSprite.startTouchDrag()</code> to begin dragging, and
	 * <code>TouchSprite.stopTouchDrag()</code> when the Touch_Up event is fired.
	 * 
	 * <listing version="3.0">
	 * import gl.events.TouchEvent;
	 * import id.core.TouchSprite;
	 * 
	 * // Create the element and fill it with a circle
	 * var draggingElement = new TouchSprite();
	 * draggingElement.graphics.beginFill(0x99ff32, 0.75);
	 * draggingElement.graphics.drawCircle(0, 0, 40);
	 * 
	 * // Reposition the element for viewing
	 * draggingElement.x += draggingElement.width / 2;
	 * draggingElement.y += draggingElement.height / 2;
	 * 
	 * // Attach the Touch_Down event listener
	 * draggingElement.addEventListener(TouchEvent.TOUCH_DOWN,
	 *   function(event:TouchEvent):void
	 *     {
	 *       draggingElement.startTouchDrag();
	 *     }
	 * );
	 * 
	 * // Attach the Touch_Up event listener
	 * draggingElement.addEventListener(TouchEvent.TOUCH_UP,
	 *   function(event:TouchEvent):void
	 *   {
	 *     draggingElement.stopTouchDrag();
	 *   }
	 * );
	 *	
	 * // Add the element to our displaylist
	 * addChild(draggingElement);
	 * </listing>
	 * 
	 * @param	lockCenter Specifies whether the draggable TouchSprite is locked to the mouse.
	 * 	pointer<code>(true)</code>, or locked to the point where the user first clicked<code>(false)</code>.
	 * @param	bounds Dragging bounds encapsulated as a rectangle where the TouchSprite's
	 * 	centerpoint must always reside relative to its parent.
	 * @param	reference A <code>DisplayObject</code> which may be used as a point of reference
	 * 	for <code>globalToLocal</code> point translation.
	 */
	/*CONFIG::FLASH_10
	{
	public function startTouchDrag(lockCenter:Boolean = false, bounds:Rectangle = null, reference:DisplayObject = null):void
	{
		if(_dragging)
			return;
		
		var handle:int = registerDragHandler(this, dragHandler);
		if (handle == -1)
		{
			return;
		}

		_dragging = true;
		_draggingBounds = bounds;
		_draggingReference = parent ? parent : null ;
		
		if(lockCenter)
		{
			_draggingBounds.top -= height / 2;
			_draggingBounds.left -= width / 2;
			_draggingBounds.width -= width / 2;
			_draggingBounds.height -= height / 2;
		}
		
		dispatchEvent(new TouchEvent("startTouchDrag"));
	}
	}*/
	
	//CONFIG::FLASH_10_1
	//{
	override public function startTouchDrag(touchPointID:int, lockCenter:Boolean = false, bounds:Rectangle = null):void
	{
		if(_dragging)
			return;
			
		// ritorna un numero diverso da -1
		var handle:int = registerDragHandler(this, dragHandler);
		if (handle == -1)
		{
			//return;
		}

		_dragging = true;
		_draggingBounds = bounds;
		_draggingReference = parent ? parent : null ;
		
		if(lockCenter)
		{
			_draggingBounds.top -= height / 2;
			_draggingBounds.left -= width / 2;
			_draggingBounds.width -= width / 2;
			_draggingBounds.height -= height / 2;
		}
		
		dispatchEvent(new TouchEvent("startTouchDrag"));
	}
	//}
	
	/**
	 * Ends the <code>startTouchDrag()</code> method.  A TouchSprite that was made draggable with
	 * <code>startTouchDrag()</code> will remain draggable until a <code>stopTouchDrag()</code>
	 * is called. Multiple TouchSprites are draggable at any point in time.
	 * 
	 * @example The following example creates a TouchSprite and enables it to be dragged by
	 * adding event listeners for Touch_Down and Touch_Up.  When the Touch_Down event is raised,
	 * we call <code>TouchSprite.startTouchDrag()</code> to begin dragging, and
	 * <code>TouchSprite.stopTouchDrag()</code> when the Touch_Up event is fired.
	 * 
	 * <listing version="3.0">
	 * import gl.events.TouchEvent;
	 * import id.core.TouchSprite;
	 * 
	 * // Create the element and fill it with a circle
	 * var draggingElement = new TouchSprite();
	 * draggingElement.graphics.beginFill(0x99ff32, 0.75);
	 * draggingElement.graphics.drawCircle(0, 0, 40);
	 * 
	 * // Reposition the element for viewing
	 * draggingElement.x += draggingElement.width / 2;
	 * draggingElement.y += draggingElement.height / 2;
	 * 
	 * // Attach the Touch_Down event listener
	 * draggingElement.addEventListener(TouchEvent.TOUCH_DOWN,
	 *   function(event:TouchEvent):void
	 *     {
	 *       draggingElement.startTouchDrag();
	 *     }
	 * );
	 * 
	 * // Attach the Touch_Up event listener
	 * draggingElement.addEventListener(TouchEvent.TOUCH_UP,
	 *   function(event:TouchEvent):void
	 *   {
	 *     draggingElement.stopTouchDrag();
	 *   }
	 * );
	 *	
	 * // Add the element to our displaylist
	 * addChild(draggingElement);
	 * </listing>
	 */
	 
	/*CONFIG::FLASH_10
	{
	public function stopTouchDrag():void
	{
		if(!_dragging)
			return;

		var handle:int = unregisterDragHandler(this, dragHandler);
		if (handle == -1)
		{
			return;
		}

		var event:TouchEvent = new TouchEvent("stopTouchDrag");
		event.dX = _dragging_dX;
		event.dY = _dragging_dY;
		event.timeStamp = _draggingTime;
		
		dispatchEvent(event);
		
		_dragging = false;
		_draggingBounds = null;
		_draggingReference = null;
		
		_dragging_dX = 0;
		_dragging_dY = 0;
	}
	}*/
	
	//CONFIG::FLASH_10_1
	//{
	override public function stopTouchDrag(touchPointID:int):void
	{
		if(!_dragging)
			return;
			
		var handle:int = unregisterDragHandler(this, dragHandler);
		if (handle == -1)
		{
			return;
		}

		var event:TouchEvent = new TouchEvent("stopTouchDrag");
		event.dX = _dragging_dX;
		event.dY = _dragging_dY;
		event.timeStamp = _draggingTime;
		
		dispatchEvent(event);
		
		_dragging = false;
		_draggingBounds = null;
		_draggingReference = null;
		
		_dragging_dX = 0;
		_dragging_dY = 0;
	}
	//}
	
	////////////////////////////////////////////////////////////
	// Methods: Event Handlers
	////////////////////////////////////////////////////////////
	id_internal function dragHandler(tactualObjects:Array):void
	{
		var cpt_x:Number = 0;
		var cpt_y:Number = 0;
		
		var ppt_x:Number = 0;
		var ppt_y:Number = 0;
		
		var n:uint;
		for each(var tO:ITactualObject in tactualObjects)
		{
			n = tO.history.length;
			if(!n)
			{
				continue;
			}
			
			cpt_x += tO.x;
			cpt_y += tO.y;
			
			ppt_x += tO.history[n - 1].x;
			ppt_y += tO.history[n - 1].y;
		}
		
		n = tactualObjects.length;
		
		cpt_x /= n;
		cpt_y /= n;
		
		ppt_x /= n;
		ppt_y /= n;
		
		if(_draggingReference)
		{
			var cpt:Point = _draggingReference.globalToLocal(new Point(cpt_x, cpt_y));
			var ppt:Point = _draggingReference.globalToLocal(new Point(ppt_x, ppt_y));
			
			cpt_x = cpt.x;
			cpt_y = cpt.y;
			
			ppt_x = ppt.x;
			ppt_y = ppt.y;
		}
		
		var dx:Number = cpt_x - ppt_x;
		var dy:Number = cpt_y - ppt_y;
		
		var _x:Number = x + dx;
		var _y:Number = y + dy;
		
		x = 
			_draggingBounds ?
			  _x <= _draggingBounds.right && _x >= _draggingBounds.left ? _x :
			    _x >= _draggingBounds.right ? _draggingBounds.right : _draggingBounds.left 
			: _x
		;
		
		y = 
			_draggingBounds ?
			  _y <= _draggingBounds.bottom && _y >= _draggingBounds.top ? _y :
			    _y >= _draggingBounds.bottom ? _draggingBounds.bottom : _draggingBounds.top 
			: _y
		;

		_draggingTime = getTimer();
		_dragging_dX = dx;
		_dragging_dY = dy;

		var e:TouchEvent = new TouchEvent("dragging");
		e.x = x;
		e.y = y;
		dispatchEvent(e);
	}
	
	/*
	private function touchMoveHandler(event:TouchEvent):void
	{
		//_draggingID = _draggingID == -1 ? event.relatedObject.id : _draggingID ;
		if(_draggingID != event.relatedObject.id)
			return;
			
		var history:Vector.<Object> = event.relatedObject.history;
		var history_count:int = history.length;
		
		var pt1:Point = new Point(
			event.relatedObject.x,
			event.relatedObject.y
		);
												
		var pt2:Point = new Point(
			history[history_count - 1].x,
			history[history_count - 1].y
		);
		
		var history1:Point = _draggingReference ? _draggingReference.globalToLocal(pt1) : pt1 ;
		var history2:Point = _draggingReference ? _draggingReference.globalToLocal(pt2) : pt2 ;

		var dx:Number = history1.x - history2.x ;
		var dy:Number = history1.y - history2.y ;
		
		var _x:Number = x + dx; //event.dx;
		var _y:Number = y + dy; //event.dy;
		
		x = 
			_draggingBounds ?
			  _x <= _draggingBounds.right && _x >= _draggingBounds.left ? _x :
			    _x >= _draggingBounds.right ? _draggingBounds.right : _draggingBounds.left 
			: _x
		;
		
		y = 
			_draggingBounds ?
			  _y <= _draggingBounds.bottom && _y >= _draggingBounds.top ? _y :
			    _y >= _draggingBounds.bottom ? _draggingBounds.bottom : _draggingBounds.top 
			: _y
		;

		_draggingTime = getTimer();
		_dragging_dX = dx; //event.dx;
		_dragging_dY = dy; //event.dy;

		var e:TouchEvent = new TouchEvent("dragging");
		e.x = x;
		e.y = y;
		dispatchEvent(e);
		
		event.stopImmediatePropagation();
	}
	*/
	
	/*
	private function releaseHandler(event:*):void
	{
		if(!event.hasOwnProperty("name"))
		{
			return;
		}
		
		PhysicsEngine.AddObject(this, event.name, _physicsParams);
	}
	*/
}
	
}