////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	XmlConfigurator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.configuration
{

import id.utils.Enumerable;
import id.utils.StringUtil;
import flash.xml.XMLNode;

/**
 * The XmlConfigurator class deserializes xml data into an enumerable object
 * and provides rudimentary mechanisms for unmarshalling built in Flash
 * primatives.
 * 
 * <p>At the moment, only the following primatives are supported:</p>
 * 
 * <pre>
 *  boolean
 *  null
 *  number
 *  string
 * </pre>
 * 
 * @langversion 3.0
 * @playerversion AIR 1.5
 * @playerversion Flash 10
 * @playerversion Flash Lite 4
 * @productversion GestureWorks 1.5
 */
public class XmlConfigurator
{
	
    //--------------------------------------------------------------------------
    //
    //  Class Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * This method deserializes and unmarshalls xml into the class specified.
     * There is no type checking, therefore the class must extend or inherit the
     * required definitions provided by the <code>Enumerable</code> object.
     * 
     * @param cls A class definition which inherits the <code>Enumerable</code>
     * object.
     * @param xml The loaded xml which will be deserialized and unmarshalled
     * into the enumerable.
     * @return An instantiated enumerable containing the unmarshalled contents
     * of the xml.
     * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */
	public static function Create(cls:Class, xml:XML):Enumerable
	{
		var ret:Enumerable = new cls();
        
		parseXML(ret, xml);
        
		return ret;
	}
	
    /**
     * @private
     */
	private static function parseXML(enum:Enumerable, xml:XML):Enumerable
	{
		var children:XMLList = xml.children();

		var child:XML;
		var elements:XMLList;
		for(var k:String in children)
		{
			child = children[k];
			elements = child.elements();
			
			/*if(elements.length())
			{
				parseXML(enum, XML(elements.toXMLString()));
			}*/
			
			enum[child.name()] = /*unMarshallData(child); //*/child == "true" ? true : child == "false" ? false : child ;
		}
		
		return enum;
	}
    
    /**
     * @private
     */
	private static function unMarshallData(data:*):*
	{
		if(data == "true")
		{
			return true;
		}
		else
		if(data == "false")
		{
			return false;
		}
		else
		if(StringUtil.isNumeric(data))
		{
			return Number(data);
		}
		else
		if(StringUtil.isEmpty(data))
		{
			return null;
		}

		return data;
	}
	
}

}