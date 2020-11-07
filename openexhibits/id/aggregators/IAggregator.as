////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	IAggregator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.aggregators
{

import id.core.ITactualObject;
import id.managers.IValidationManagerHook;
import id.tracker.ITrackerHook;

/**
 * The IAggregator interface defines the basic set of APIs required for an
 * Aggregator.
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public interface IAggregator extends ITrackerHook, IValidationManagerHook
{

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * This method will return the existing clusters calculated by the
     * Aggregator.  Each invalidated <code>ITouchObject</code> will recalculate
     * its own clusters based on what is passed back from this method call.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	function get tactualClusters():Vector.<ITactualObject>;
	
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Signals the Aggregator that a new tactual object has been created, and
     * that it should be queued for clustering.
     * 
     * <p>This method is called when a new <code>TactualObject</code> has been
     * created.  You will want to override this method and respond to the
     * object's creation.  It is reccomended that the <code>TactualObject</code>
     * is queued for addition to a cluster during the beginning of the validation
     * cycle.</p>
     * 
     * @param tO The <code>TactualObject</code> which was created and added
     * to its respective <code>ITouchObject</code>.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	function addTactualObject(tO:ITactualObject):void;
    
    /**
     * Signals the Aggregator that a tactual object is being destroyed and 
     * should be removed from the system.
     * 
     * <p>This method is called when a <code>TactualObject</code> is being 
     * destroyed.  You will want to override this method and respond to the
     * object's removal.  It is reccomended that the <code>TactualObject</code>
     * is immediatly removed from its respective <code>Cluster</code>.</p>
     * 
     * @param tO The <code>TactualObject</code> which is currently being removed
     * from the system.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	function removeTactualObject(tO:ITactualObject):void;

}
	
}