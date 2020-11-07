////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	 GestureEvent.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Paul Lacey (paul(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com). 
//				
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.events
{
import id.core.ITactualObject;

import flash.display.InteractiveObject;
import flash.events.Event;

/**
 * The GestureEvent class provides a reference to all available gesture analysis modules
 * via their package path and class name.
 * 
 * <pre>
 * <b>GestureWorks currently supports:</b>
 *  GestureTap
 *  GestureHold
 *  GestureDrag
 *  GestureSwipe
 *  GestureScroll
 *  GestureFlick
 *  GestureScale
 *  GestureRotate
 *  GestureTilt
 *  GestureAnchor
 *  GestureRelease
 * </pre>
 *
 */
public dynamic class GestureEvent extends Event implements IDescriptorEvent
{
		 
	/**
	* The GestureEvent.GESTURE_TAP constant defines the value of the gesture analysis module
	* class for a tap event.
	* 
	* <p>The properties of the event object have the following values:</p>
	* <table class="innertable">
	*   <tr><th>Property</th><th>Value</th></tr>
	*   <tr><td><code>bubbles</code></td><td>false</td></tr>
	*   <tr><td><code>cancelable</code></td><td>false</td></tr>
	*   <tr><td><code>currentTarget</code></td><td>The Object that defines the
	*     event listener that handles the event.</td></tr>
	*   <tr><td><code>target</code></td><td>The Object that dispatched the event;
	*     it is not always the Object listening for the event.
	*     Use the <code>currentTarget</code> property to always access the
	*     Object listening for the event.</td></tr>
	* </table>
	* 
	* @eventType "gestureTap"
	* @see gl.gestures.complex.GestureTap
	*
	*
	* @example This code example adds the simple single tap gesture listener. This accomodates for any number of touch points on the touch object.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_TAP, tapEventHandler);
	*
	* private function tapEventHandler(event:GestureEvent):void
	* {
	*       trace("n point tap",event.stageX, event.stageY);
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point double tap gesture to a touch object.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_DOUBLE_TAP_2, doubleTapEventHandler);
	*
	* private function doubleTapEventHandler(event:GestureEvent):void
	* {
	*       trace("two point double tap",event.localX, event.localY);
	* }
	* 
	* </listing>
	*/
    public static const GESTURE_TAP:String = "gestureTap";
	public static const GESTURE_TAP_1:String = "gestureTap_1";
	public static const GESTURE_TAP_2:String = "gestureTap_2";
	public static const GESTURE_TAP_3:String = "gestureTap_3";
	public static const GESTURE_TAP_4:String = "gestureTap_4";
	public static const GESTURE_TAP_5:String = "gestureTap_5";
	//public static const GESTURE_TAP_N:String = "gestureTap_N";
	
	public static const GESTURE_DOUBLE_TAP:String = "gestureDoubleTap";
	public static const GESTURE_DOUBLE_TAP_1:String = "gestureDoubleTap_1";
	public static const GESTURE_DOUBLE_TAP_2:String = "gestureDoubleTap_2";
	public static const GESTURE_DOUBLE_TAP_3:String = "gestureDoubleTap_3";
	public static const GESTURE_DOUBLE_TAP_4:String = "gestureDoubleTap_4";
	public static const GESTURE_DOUBLE_TAP_5:String = "gestureDoubleTap_5";
	//public static const GESTURE_DOUBLE_TAP_N:String = "gestureDoubleTap_N";
	
	public static const GESTURE_TRIPLE_TAP:String = "gestureTripleTap";
	public static const GESTURE_TRIPLE_TAP_1:String = "gestureTripleTap_1";
	public static const GESTURE_TRIPLE_TAP_2:String = "gestureTripleTap_2";
	public static const GESTURE_TRIPLE_TAP_3:String = "gestureTripleTap_3";
	public static const GESTURE_TRIPLE_TAP_4:String = "gestureTripleTap_4";
	public static const GESTURE_TRIPLE_TAP_5:String = "gestureTripleTap_5";
	//public static const GESTURE_TRIPLE_TAP_N:String = "gestureTripleTap_N";
    
	/**
     * The GestureEvent.GESTURE_HOLD constant defines the value of the gesture analysis module
     * class for a hold event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureHold"
     * @see gl.gestures.complex.GestureHold
     *
	 *
	* @example This code example adds the n point hold gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GWGestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_HOLD, holdEventHandler);
	*
	* private function holdEventHandler(event:GestureEvent):void
	* {
	*       trace("n point hold", event.localX, event.localY);
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point rotate gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_HOLD_2, holdEventHandler);
	*
	* private function holdEventHandler(event:GestureEvent):void
	* {
	*       trace("two point hold",event.stageX,event.stageY);
	* }
	* 
	* </listing>
	*/
	public static const GESTURE_HOLD:String = "gestureHold";
    public static const GESTURE_HOLD_1:String = "gestureHold_1";
    public static const GESTURE_HOLD_2:String = "gestureHold_2";
    public static const GESTURE_HOLD_3:String = "gestureHold_3";
    public static const GESTURE_HOLD_4:String = "gestureHold_4";
    public static const GESTURE_HOLD_5:String = "gestureHold_5";
    public static const GESTURE_HOLD_N:String = "gestureHold_N";
	
	 /**
     * The GestureEvent.GESTURE_DRAG constant defines the value of the gesture analysis module
     * class for a drag event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureDrag"
	 * @see gl.gestures.complex.GestureDrag
     *
	 *
	* @example This code example adds the n point rotate gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_DRAG, dragEventHandler);
	*
	* private function dragEventHandler(event:GestureEvent):void
	* {
	*       trace("n point drag", event.dx,event.dy);
	*		x += event.dx;
	*		y += event.dy
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point rotate gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_DRAG_2, dragEventHandler);
	*
	* private function dragEventHandler(event:GestureEvent):void
	* {
	*       trace("drag",event.dx, event.dy);
	*		x += event.dx;
	*		y += event.dy;
	* }
	* 
	* </listing>
	*/
    public static const GESTURE_DRAG:String = "gestureDrag";
    public static const GESTURE_DRAG_1:String = "gestureDrag_1";
    public static const GESTURE_DRAG_2:String = "gestureDrag_2";
    public static const GESTURE_DRAG_3:String = "gestureDrag_3";
    public static const GESTURE_DRAG_4:String = "gestureDrag_4";
    public static const GESTURE_DRAG_5:String = "gestureDrag_5";
    public static const GESTURE_DRAG_N:String = "gestureDrag_N";
    
	 /**
      * The GestureEvent.GESTURE_FLICK constant defines the value of the gesture analysis module
      * class for a flick event.
      * 
      * <p>The properties of the event object have the following values:</p>
      * <table class="innertable">
      *   <tr><th>Property</th><th>Value</th></tr>
      *   <tr><td><code>bubbles</code></td><td>false</td></tr>
      *   <tr><td><code>cancelable</code></td><td>false</td></tr>
      *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
      *     event listener that handles the event.</td></tr>
      *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
      *     it is not always the Object listening for the event.
      *     Use the <code>currentTarget</code> property to always access the
      *     Object listening for the event.</td></tr>
      * </table>
      * 
      * @eventType "gestureFlick"
      * @see gl.gestures.complex.GestureFlick
      *
	  *
	* @example This code example adds the n point flick gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_FLICK, flickEventHandler);
	*
	* private function flickEventHandler(event:GestureEvent):void
	* {
	*       trace("n point flick", event.velocityY);
	*		velocityY = event.velocityY;
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point flick gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_FLICK_2, flickEventHandler);
	*
	* private function flickEventHandler(event:GestureEvent):void
	* {
	*       trace("two point flick",event.velocityX,event.accelerationX);
	*		velocityX = event.velocityX;
	* }
	* 
	* </listing>
	*/
    public static const GESTURE_FLICK:String = "gestureFlick";
    public static const GESTURE_FLICK_1:String = "gestureFlick_1";
    public static const GESTURE_FLICK_2:String = "gestureFlick_2";
    public static const GESTURE_FLICK_3:String = "gestureFlick_3";
    public static const GESTURE_FLICK_4:String = "gestureFlick_4";
    public static const GESTURE_FLICK_5:String = "gestureFlick_5";
    public static const GESTURE_FLICK_N:String = "gestureFlick_N";
    
	 /**
     * The GestureEvent.GESTURE_SCROLL constant defines the value of the gesture analysis module
     * class for a scroll event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureScroll"
     * @see gl.gestures.complex.GestureScroll
     *
	 *
	* @example This code example adds the n point scroll gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SCROLL, scrollEventHandler);
	*
	* private function scrollEventHandler(event:GestureEvent):void
	* {
	*       trace("n point scroll",event.scrollY);
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point scroll gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SCROLL_2, scrollEventHandler);
	*
	* private function scrollEventHandler(event:GestureEvent):void
	* {
	*       trace("two point scroll",event.scrollX);
	* }
	* 
	* </listing>
	*/
  	public static const GESTURE_SCROLL:String = "gestureScroll";
    public static const GESTURE_SCROLL_1:String = "gestureScroll_1";
    public static const GESTURE_SCROLL_2:String = "gestureScroll_2";
    public static const GESTURE_SCROLL_3:String = "gestureScroll_3";
    public static const GESTURE_SCROLL_4:String = "gestureScroll_4";
    public static const GESTURE_SCROLL_5:String = "gestureScroll_5";
    public static const GESTURE_SCROLL_N:String = "gestureScroll_N";
	
	/**
     * The GestureEvent.GESTURE_SWIPE constant defines the value of the gesture analysis module
     * class for a swipe event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureSwipe"
     * @see gl.gestures.complex.GestureSwipe
     *
	 *
	* @example This code example adds the n point swipe gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SWIPE, swipeEventHandler);
	*
	* private function swipeEventHandler(event:GestureEvent):void
	* {
	*       trace("n point swipe",event.displaceY);
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point sswipe gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SWIPE_2, swipeEventHandler);
	*
	* private function swipeEventHandler(event:GestureEvent):void
	* {
	*       trace("two point swipe",event.displaceX);
	* }
	* 
	* </listing>
	*/
	public static const GESTURE_SWIPE:String = "gestureSwipe";
    public static const GESTURE_SWIPE_1:String = "gestureSwipe_1";
    public static const GESTURE_SWIPE_2:String = "gestureSwipe_2";
    public static const GESTURE_SWIPE_3:String = "gestureSwipe_3";
    public static const GESTURE_SWIPE_4:String = "gestureSwipe_4";
    public static const GESTURE_SWIPE_5:String = "gestureSwipe_5";
    public static const GESTURE_SWIPE_N:String = "gestureSwipe_N";
	
	 /**
     * The GestureEvent.GESTURE_SCALE constant defines the value of the gesture analysis module
     * class for a scale event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureScale"
     * @see gl.gestures.complex.GestureScale
     *
	 *
	* @example This code example adds the n point scale gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SCALE, scaleEventHandler);
	*
	* private function scaleEventHandler(event:GestureEvent):void
	* {
	*       trace("n point scale",event.value);
	*		scaleX = event.value;
	*		scaleY = event.value;
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point scale gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_SCALE_2, scaleEventHandler);
	*
	* private function scaleEventHandler(event:GestureEvent):void
	* {
	*       trace("two point scale",event.value);
	*		scaleX = event.value;
	*		scaleY = event.value;
	* }
	* 
	* </listing>
	*/
    public static const GESTURE_SCALE:String = "gestureScale";
    public static const GESTURE_SCALE_2:String = "gestureScale_2";
    public static const GESTURE_SCALE_3:String = "gestureScale_3";
    public static const GESTURE_SCALE_4:String = "gestureScale_4";
    public static const GESTURE_SCALE_5:String = "gestureScale_5";
    public static const GESTURE_SCALE_N:String = "gestureScale_N";
    
	/**
     * The GestureEvent.GESTURE_ROTATE constant defines the value of the gesture analysis module
     * class for a simple 2d rotation event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureRotate"
     * @see gl.gestures.complex.GestureRotate
     *
	 *
	* @example This code example adds the n point rotate gesture listener. This accomodates for any number of touch points.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_ROTATE, rotateEventHandler);
	*
	* private function rotateEventHandler(event:GestureEvent):void
	* {
	*       trace("n point rotate", event.value);
	*		rotation += event.value;
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the dual touch point rotate gesture to a touch object
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_ROTATE_2, rotateEventHandler);
	*
	* private function rotateEventHandler(event:GestureEvent):void
	* {
	*       trace("two point rotate",event.value);
	*		rotation += event.value;
	* }
	* 
	* </listing>
	*/
   	public static const GESTURE_ROTATE:String = "gestureRotate";
    public static const GESTURE_ROTATE_2:String = "gestureRotate_2";
    public static const GESTURE_ROTATE_3:String = "gestureRotate_3";
    public static const GESTURE_ROTATE_4:String = "gestureRotate_4";
    public static const GESTURE_ROTATE_5:String = "gestureRotate_5";
    public static const GESTURE_ROTATE_N:String = "gestureRotate_N";
   	
	/**
      * The GestureEvent.GESTURE_TILT constant defines the value of the gesture analysis module
      * class for a 3D rotation or tilt event.
      * 
      * <p>The properties of the event object have the following values:</p>
      * <table class="innertable">
      *   <tr><th>Property</th><th>Value</th></tr>
      *   <tr><td><code>bubbles</code></td><td>false</td></tr>
      *   <tr><td><code>cancelable</code></td><td>false</td></tr>
      *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
      *     event listener that handles the event.</td></tr>
      *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
      *     it is not always the Object listening for the event.
      *     Use the <code>currentTarget</code> property to always access the
      *     Object listening for the event.</td></tr>
      * </table>
      * 
      * @eventType "gestureTilt"
      * @see gl.gestures.complex.GestureTilt
      *
	  *
	* @example This code example adds the three point tilt gesture listener. This accomodates for vertical and horizontal 3d tilt actions.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_TILT, 3dTiltEventHandler);
	*
	* private function 3dTiltEventHandler(event:GestureEvent):void
	* {
	*       trace("three point tilt",event.value);
	*		rotationZ = event.tiltX;
			rotationY = event.tiltY;
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds the triple touch point horizontal 3d tilt gesture to a touch object.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_TILT_XZ, yAxisTiltEventHandler);
	*
	* private function yAxisTiltEventHandler(event:GestureEvent):void
	* {
	*       trace("XZ tilt",event.value);
	*		rotationY = event.tiltY;
	* }
	* 
	* </listing>
	*/
    public static const GESTURE_TILT:String = "gestureTilt";
    public static const GESTURE_TILT_XZ:String = "gestureTilt_XZ";
    public static const GESTURE_TILT_YZ:String = "gestureTilt_YZ";
	
	/**
      * The GestureEvent.GESTURE_ANCHOR constant defines the value of the gesture analysis module
      * class for a three point anchor event.
      * 
      * <p>The properties of the event object have the following values:</p>
      * <table class="innertable">
      *   <tr><th>Property</th><th>Value</th></tr>
      *   <tr><td><code>bubbles</code></td><td>false</td></tr>
      *   <tr><td><code>cancelable</code></td><td>false</td></tr>
      *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
      *     event listener that handles the event.</td></tr>
      *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
      *     it is not always the Object listening for the event.
      *     Use the <code>currentTarget</code> property to always access the
      *     Object listening for the event.</td></tr>
      * </table>
      * 
      * @eventType "gestureAnchor"
      * @see gl.gestures.complex.GestureAnchor
      *
	  *
	* @example This code example adds anchor drag gesture listener. 
	* This gesture is triggered when three touch points a held in place on a touch object and another set is dragged over the object.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_ANCHOR_DRAG, anchorDragHandler);
	*
	* private function anchorDragHandler(event:GestureEvent):void
	* {
	*       trace("anchor drag",event.dx, event.dy);
	*		x += event.dx;
	*		y += event.dy;
	* }
	* 
	* </listing>
	*
	*
	* @example This code example adds anchor rotate gesture listener. 
	* This gesture is triggered when three touch points a held in place on a touch object and another set is rotated over the object.
	* 
	* <listing version="3.0">
	*
	* import gl.events.GWGestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_ANCHOR_ROTATE, anchorRotateHandler);
	*
	* private function anchorRotateHandler(event:GestureEvent):void
	* {
	*       trace("anchor rotate",event.value);
	*		rotation += 10*event.value;
	* }
	* 
	* </listing>
	*/
	
	public static const GESTURE_ANCHOR_DRAG:String = "gestureAnchorDrag";
	public static const GESTURE_ANCHOR_DOUBLE_TAP:String = "gestureAnchorDoubleTap";
	public static const GESTURE_ANCHOR_FLICK:String = "gestureAnchorFlick";
	public static const GESTURE_ANCHOR_ROTATE:String = "gestureAnchorRotate";
	public static const GESTURE_ANCHOR_SCALE:String = "gestureAnchorScale";
	public static const GESTURE_ANCHOR_TAP:String = "gestureAnchorTap";
		
	public static const GESTURE_PRECISE_ROTATE:String = "gesturePreciseRotate";
	public static const GESTURE_PRECISE_SCALE:String = "gesturePreciseScale";
	
	 //public static const GESTURE_3DROTATE:String = "gesture3DRotate";
    
	/**
     * The GestureEvent.RELEASE constant defines the value of the gesture analysis module
     * class for a gesture relese event.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *   <tr><th>Property</th><th>Value</th></tr>
     *   <tr><td><code>bubbles</code></td><td>false</td></tr>
     *   <tr><td><code>cancelable</code></td><td>false</td></tr>
     *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *     event listener that handles the event.</td></tr>
     *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *     it is not always the Object listening for the event.
     *     Use the <code>currentTarget</code> property to always access the
     *     Object listening for the event.</td></tr>
     * </table>
     * 
     * @eventType "gestureRelease"
     * @see gl.gestures.complex.Release
     *
	 *
	* @example This code example adds the release gesture to a touch object. This can be used to indicate when all gestures on a touch object have terminated.
	*
	* <listing version="3.0">
	*
	* import gl.events.GestureEvent;
	*
	* touchObject.addEventListener(GestureEvent.GESTURE_RELEASE, releaseEventHandler);
	*
	* private function releaseEventHandler(event:GestureEvent):void
	* {
	*       trace("release");
	* }
	* 
	* </listing>
	*/
    public static const RELEASE:String = "gestureRelease";
    
    
    /**
     * @private
     */
    protected var _localX:Number;
    
    /**
     * @private
     */
    protected var _localY:Number;
    
    /**
     * @private
     */
    protected var _stageX:Number;
    
    /**
     * @private
     */
    protected var _stageY:Number;
    
    /**
     * @private
     */
    protected var _relatedObject:InteractiveObject;
    
    /**
     * @private
     */
    protected var _tactualObjects:Array;
    
    ////////////////////////////////////////////////////////////
    // Constructor: Default
    ////////////////////////////////////////////////////////////
    /**
     * Default constructor.
     */
    public function GestureEvent
    (
        type:String, bubbles:Boolean = false, cancelable:Boolean = false,
        
        /*phase:String = null,*/
        
        localX:Number = NaN,
        localY:Number = NaN,
        stageX:Number = NaN,
        stageY:Number = NaN,
        
        /*ctrlKey:Boolean = false,
        altKey:Boolean = false,
        shiftKey:Boolean = false,
        commandKey:Boolean = false,
        controlKey:Boolean = false,*/
        
        relatedObject:InteractiveObject = undefined,
        tactualObjects:Array = null
    )
    {
        super(type, bubbles, cancelable);
        
        _localX = localX;
        _localY = localY;
        
        _stageX = stageX;
        _stageY = stageY;
        
        _relatedObject = relatedObject;
        _tactualObjects = [];
        
        if(tactualObjects)
        for(var idx:uint=0; idx<tactualObjects.length; idx++)
        {
            _tactualObjects.push(tactualObjects[idx]);
        }
    }
    
    ////////////////////////////////////////////////////////////
    // Properties: Public
    ////////////////////////////////////////////////////////////
    /**
     * Indicates whether the Alt key is active (true) or inactive (false).
     */
    public function get altKey():Boolean { return false; }
    public function set altKey(value:Boolean):void
    {
    }
    
    /**
     * Indicates whether the command key is activated (Mac only).
     */
    public function get commandKey():Boolean { return false; }
    public function set commandKey(value:Boolean):void
    {
    }
    
    /**
     * Indicates whether the Control key is activated on Mac and
     * whether the Ctrl key is activated on Windows or Linux.
     */
    public function get controlKey():Boolean { return false; }
    public function set controlKey(value:Boolean):void
    {
    }
    
    /**
     * On Windows or Linux, indicates whether the Ctrl key is
     * active (true) or inactive (false).
     */
    public function get ctrlKey():Boolean { return false; }
    public function set ctrlKey(value:Boolean):void
    {
    }
    
    /**
     * Indicates whether the Shift key is active (true) or inactive (false).
     */
    public function get shiftKey():Boolean { return false; }
    public function set shiftKey(value:Boolean):void
    {
    }    
    
    /**
     * Returns the horizontal position as a number local to the object
     * the TouchEvent is raised.
     */
    public function get localX():Number { return _localX; }
    public function set localX(value:Number):void
    {
    }
    
    /**
     * Returns the vertical position as a number local to the object
     * the TouchEvent is raised.
     */
    public function get localY():Number { return _localY; }
    public function set localY(value:Number):void
    {
    }
    
    /**
     * Return the horizontal position as a number relative to the 
     * stage.
     */
    public function get stageX():Number { return _stageX; }
    
    /**
     * Returns the vertical position as a number relative to the
     * stage.
     */
    public function get stageY():Number { return _stageY; }

    /**
     * A reference to a display list object that is related to the event.
     */
    public function get relatedObject():InteractiveObject { return _relatedObject; }
    public function set relatedObject(value:InteractiveObject):void
    {
        _relatedObject = value;
    }
    
    /**
     * Returns a collection of <code>ITactualObjects</code> which cased the
     * GestureEvent to be raised at its target.
     */
    public function get tactualObjects():Array { return _tactualObjects; }

    ////////////////////////////////////////////////////////////
    // Methods: Overrides
    ////////////////////////////////////////////////////////////
    override public function clone():Event {
        var event:GestureEvent = new GestureEvent(type, bubbles, cancelable);

        for (var p:String in this)
        {
            event[p] = this[p];
        }

        return event;
    }
    
    
}

}