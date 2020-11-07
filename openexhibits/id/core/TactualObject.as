////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	TactualObject.as
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

import id.aggregators.IAggregable;
import id.aggregators.IAggregator;
import id.utils.StringUtil;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.utils.Timer;
import flash.utils.getTimer;

use namespace id_internal;

/**
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.0
 */
public dynamic class TactualObject extends HistoryObject implements IHistoryObject, ITactualObject, IAggregable, IDisposable
{
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    protected var _aggregator:IAggregator;
    
    /**
     * @private
     */
    protected var _owner:ITouchObject;
    
    /**
     * @private
     */
    protected var _target:ITouchObject;
    
    /**
     * @private
     */
    protected var _targetRediscovery:Boolean;

    /**
     * @private
     */
    protected var _oldTarget:ITouchObject;
    
    /**
     * @private
     */
    protected var _hasNewTarget:Boolean;
    
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
     * @productversion GestureWorks 1.0
     */ 
    public function TactualObject(type:uint)
    {
        _type = type;
        _creationTime = getTimer();
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
     * @productversion GestureWorks 1.0
     */ 
    public function Dispose():void
    {
        disposeAggregator();
        disposeChild();
        disposeTarget();
        
        for(var idx:uint=0; idx<_historySegments.length; idx++)
        {
            _historySegments[idx] = null;
        }
        
        _history = null;
        _historySegments = null;
    }
    
    /**
     * If an <code>Aggregator</code> is present, this method will remove this
     * object from its internal list.
     * 
     * <p>Calling this method manually will forcefully exclude this
     * <code>TactualObject</code> from the <code>Aggregator</code>.  In theory,
     * this should not be problematic however, manual removal from the
     * clustering system has not been thoroughly tested.</p>
     * 
     * <p>You do not need to call this directly.  The <code>Dispose()</code>
     * method, called from the tracking system, automatically cleans all
     * ligering references and history entries.</p>
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function disposeAggregator():void
    {
        if(!_aggregator)
        {
            return;
        }
        
        _aggregator.removeTactualObject(this);
        _aggregator = null;
    }
    
    /**
     * This method will remove this object from its owner's internal list.
     * 
     * <p>Calling this method manually will forcefully exclide this 
     * <code>TactualObject</code> from the descriptor processing methods.  In
     * theory, this should not be problematic however, manual removal from the
     * owner's internal list has not been thoroughly tested.</p>
     * 
     * <p>You do not need to call this directly.  The <code>Dispose()</code>
     * method, called from the tracking system, automatically cleans all
     * ligering references and history entries.</p>
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function disposeChild():void
    {
        if(!_owner)
        {
            return;
        }
        
        _owner.removeTactualObject(this);
        _owner = null;
    }
    
    /**
     * This method removes the reference to the top most targeted object.
     * 
     * <p>Calling this method manually will have an immediate affect upon the
     * descriptor processing system.  Unless, the <code>descoverTarget()</code>
     * method is not immediatly called upon at the end of, or beginning of the
     * next validation cycle, an error will be thrown as there is no target at
     * which to dispatch touch based events to.</p>
     * 
     * <p>If <code>targetRediscovery</code> is set to <code>true</code>, this
     * method is effectively called at every update provided a new target has
     * been discovered.</p>
     * 
     * <p>You do not need to call this directly.  The <code>Dispose()</code>
     * method, called from the tracking system, automatically cleans all
     * ligering references and history entries.</p>
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function disposeTarget():void
    {
        if(!_target)
        {
            return;
        }
        
        _target = null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  id
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _id:int;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get id():int { return _id; }
    public function set id(value:int):void
    {
        _id = value;
    }
    
    //----------------------------------
    //  x
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _x:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get x():Number { return _x; }
    public function set x(value:Number):void {
        _x = value;
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _y:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get y():Number { return _y; }
    public function set y(value:Number):void {
        _y = value;
    }
    
    //----------------------------------
    //  dx
    //----------------------------------

    /**
     * @private
     */
    id_internal var _dx:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get dx():Number { return _dx; }
    public function set dx(value:Number):void {
        _dx = value;
    }
    
    //----------------------------------
    //  dy
    //----------------------------------

    /**
     * @private
     */
    id_internal var _dy:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get dy():Number { return _dy; }
    public function set dy(value:Number):void {
        _dy = value;
    }

    //----------------------------------
    //  pressure
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _p:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get pressure():Number { return _p; }
    public function set pressure(value:Number):void
    {
        _p = value;
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _width:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get width():Number { return _width; }
    public function set width(value:Number):void {
        _width = value;
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _height:Number;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get height():Number { return _height; }
    public function set height(value:Number):void {
        _height = value;
    }
    
    //----------------------------------
    //  existences
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _existences:uint;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get existences():uint { return _existences; }
    public function set existences(value:uint):void
    {
        _existences = value;
    }
    
    //----------------------------------
    //  state
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _state:uint;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get state():uint { return _state | (_hasNewTarget ? TactualObjectState.TARGET_CHANGED : 0) ; }
    public function set state(value:uint):void
    {
        switch(value)
        {
            case TactualObjectState.ADDED:
                discoverAggregator();
                discoverChild();
                break;
            
            case TactualObjectState.UPDATED:
                if(_targetRediscovery)
                {
                    discoverTarget();
                }
                break;
                
            /*
            case TactualObjectState.REMOVING:
                break;
            */
            //case TactualObjectState.ADDED:
            //case TactualObjectState.REMOVED:
            //case TactualObjectState.UPDATED:
            //default:
        }

        _owner.invalidateTactualObjects();
        _state = value;
    }
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @private
     */
    id_internal var _type:uint;
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get type():uint { return _type; }
    public function set type(value:uint):void
    {
        _type = value;
    }
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get owner():DisplayObject { return _owner as DisplayObject; }

    //----------------------------------
    //  target
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get target():DisplayObject { return _target as DisplayObject; }
    
    //----------------------------------
    //  oldTarget
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get oldTarget():DisplayObject { return _oldTarget as DisplayObject; }

    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get targetRediscovery():Boolean { return _targetRediscovery; }
    public function set targetRediscovery(value:Boolean):void
    {
        if (_targetRediscovery == value)
        {
            return;
        }
        
        if (value && _owner)
        {
            _owner.invalidateTactualObjects();
        }
        
        _targetRediscovery = value;
    }
    
    //----------------------------------
    //  type
    //----------------------------------
    
    /**
     * @inheritDoc
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    public function get hasNewTarget():Boolean { return _hasNewTarget; }
    public function set hasNewTarget(value:Boolean):void
    {
        _hasNewTarget = value;
        _oldTarget = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function discoverAggregator():void
    {
        if(!ApplicationGlobals.aggregator)
            return;
        
        _aggregator = ApplicationGlobals.aggregator;
        _aggregator.addTactualObject(this);
    }
    
    public function discoverChild():void
    {
        if(_owner)
        {
            return;
        }
        
        _target = ApplicationGlobals.application.getTouchObjectUnderPoint(new Point(x, y));

        if(!_target.blobContainer)
        {
       
            _target.discoverTactualObjectContainer();
        }
        
        _owner = _target.blobContainer;
        _owner.addTactualObject(this);
        
        _targetRediscovery = _owner.pointTargetRediscovery;
    }
    
    public function discoverTarget():void
    {
        if(_hasNewTarget)
        {
            return;
        }
        
        var owner:ITouchObjectContainer = _owner as ITouchObjectContainer;
        
        /*
        if(!owner)
        {
            return;
        }
        */
        
        var target:ITouchObject = owner.getTouchObjectUnderPoint(new Point(x, y));
        if(!target || target == _target)
        {
            return;
        }
    
        // prevent oscellations between validations
        if (target == _oldTarget)
        {
            _target = _oldTarget;
            _oldTarget = null;
            _hasNewTarget = false;
            
            return;
        }
    
        _oldTarget = _target;
        _target = target;
        
        _hasNewTarget = true;
    }
    
    ////////////////////////////////////////////////////////////
    // Methods: Public
    ////////////////////////////////////////////////////////////
    /*public function checkValidity(object:ITactualObject):Number
    {
        var temporal:Number = 1 - Math.min( TEMPORAL_MAX, Math.abs(object.creationTime - _creationTime) ) / TEMPORAL_MAX ;
        var spatial:Number = 1 - Math.min( SPATIAL_MAX, Point.distance(new Point(object.x, object.y), new Point(_x, _y)) ) / SPATIAL_MAX ;
        
        return temporal * 0.3 + spatial * 0.7 ;
    }*/

    public function hasParams():Boolean
    {
        return (!isNaN(_x) && !isNaN(_y));
    }

    //--------------------------------------------------------------------------
    //
    //  Methods Overrides
    //
    //--------------------------------------------------------------------------
    
    /**
     * Overrode from the <code>HistoryObject</code>, this method returns a
     * selection of properties for history automation:
     * 
 * <pre>
 *  dx
 *  dy
 *  existences
 *  height
 *  p
 *  state
 *  width
 *  time
 * </pre>
     * 
     * @return Object A representation of the current state encapsulated into 
     * an associative array.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.0
     */
    override public function info():Object
    {
        return {
            time: getTimer(),
            
            existences: _existences,
            state: _state,
            
            x: _x,
            y: _y,
            dx: _dx,
            dy: _dy,
            p: _p,
            
            width: _width,
            height: _height
        }
    }
    
    /**
     * @private
     */
    override public function toString():String
    {
        return "\nTactualObject(" + StringUtil.padCenter(String(id), " ", 5) + ")::x:" + x + "\ty:" + y + "\tdx:" + dx + "\tdy:" + dy + "\towner:" + _owner + "\ttarget:" + _target;
    }


    
}

}