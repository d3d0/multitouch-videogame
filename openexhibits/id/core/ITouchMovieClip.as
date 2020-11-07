////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	ITouchMovieClip.as
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
	
import flash.display.DisplayObject;
import flash.geom.Rectangle;

public interface ITouchMovieClip extends ITouchObjectContainer
{

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
	function startTouchDrag(lockCenter:Boolean = false, bounds:Rectangle = null, reference:DisplayObject = null):void;
	}*/
	
	//CONFIG::FLASH_10_1
	//{
	function startTouchDrag(touchPointID:int, lockCenter:Boolean = false, bounds:Rectangle = null):void
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
	function stopTouchDrag():void
	}*/
	
	//CONFIG::FLASH_10_1
	//{
	function stopTouchDrag(touchPointID:int):void
	//}
	
}

}