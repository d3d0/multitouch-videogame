////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	StyleUtil.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.utils
{
	import fl.transitions.easing.Regular;

public class StyleUtil
{
	
	include "../core/Version.as" ;

	private static var expressionsReady:Boolean;
	private static const expressions:Object =
	{
		ident:		"[-]?{nmstart}{nmchar}*",
		name:		"{nmchar}+",
		nmstart:	"[_a-z]|{nonascii}|{escape}",
		nonascii:	"[^\\0-\\177]",
		unicode:	"\\\[0-9a-f]{1,6}(\\r\\n|[ \\n\\r\\t\\f])?",
		escape:		"{unicode}|\\\[^\\n\\r\\f0-9a-f]",
		nmchar:		"[_a-z0-9-]|{nonascii}|{escape}",
		num:		"[0-9]+|[0-9]*\\.[0-9]+",
		string:		"{string1}|{string2}",
		string1:	"\"([^\\n\\r\\f\"]|\\\{nl}|{nonascii}|{escape})*\"",
		string2:	"\'([^\\n\\r\\f\']|\\\{nl}|{nonascii}|{escape})*\'",
		invalid:	"{invalid1}|{invalid2}",
		invalid1:	"\"([^\\n\\r\\f\"]|\\\{nl}|{nonascii}|{escape})*",
		invalid2:	"\'([^\\n\\r\\f\']|\\\{nl}|{nonascii}|{escape})*",
		nl:			"\\n|\\r\\n|\\r|\\f",
		w:			"[ \\t\\r\\n\\f]*",
		
		D:			"d|\\\0{0,4}(44|64)(\\r\\n|[ \\t\\r\\n\\f])?",
		E:			"e|\\\0{0,4}(45|65)(\\r\\n|[ \\t\\r\\n\\f])?",
		N:			"n|\\\0{0,4}(4e|6e)(\\r\\n|[ \\t\\r\\n\\f])?|\\\n",
		O:			"o|\\\0{0,4}(4f|6f)(\\r\\n|[ \\t\\r\\n\\f])?|\\\o",
		T:			"t|\\\0{0,4}(54|74)(\\r\\n|[ \\t\\r\\n\\f])?|\\\t",
		V:			"v|\\\0{0,4}(58|78)(\\r\\n|[ \\t\\r\\n\\f])?|\\\v",

		comments:	"\\/\\*[^*]*\\*+([^\\/*][^*]*\\\*+)*\\/",
		block:		"[^{]*\{([^}]*)*}",
		tidy:		"\\s*([@{}:;,]|\\)\\s|\\s\\()\\s*|\\/\\*([^*\\\\\]|\\*(?!\\/))+\\*\\/|[\\n\\r\\t]"
	};
	
		
	public static function parseCSS(css:String):void
	{
		prepExpressions();
		
		if(!isValid(css))
		{
			throw new Error("CSS is not valid!");
		}

		css = css.replace(expressions.tidy, "$1");

		var idx:uint;
		var matches:Array = css.match(expressions.block);

		for(idx=0; idx<matches.length; idx++)
		{
			trace("matches[" + idx + "]: '" + matches[idx] + "'");
		}
	}
	
	public static function isValid(css:String):Boolean
	{
		prepExpressions();
		
		return !css.match(expressions["invalid"]).length ;
	}
	
	private static function prepExpressions(key:String = null):void
	{
		if(expressionsReady)
		{
			return;
		}
		
		const regEx:RegExp = new RegExp(/{.*?}/g);
		const regEx2:RegExp = new RegExp(/[{}]/g);
		
		var idx:uint;
		var k:String;
		var k2:String;
		
		var match:String;
		var matches:Array;
		
		if(!key)
		{
			for(k in expressions)
			{
				prepExpressions(k);
			}
			
			for(k in expressions)
			{
				expressions[k] = new RegExp(expressions[k], "gi");
			}
			
			expressionsReady = true;
		}
		else
		{
			matches = expressions[key].match(regEx);
			
			for(idx=0; idx<matches.length; idx++)
			{
				match = matches[idx];
				k2 = match.replace(regEx2, "");

				if(!expressions.hasOwnProperty(k2))
				{
					continue;
				}
				
				prepExpressions(k2);


				trace("replacing:", key, k2);
				if(!StringUtil.isNumeric(k2.substr(k2.length -1)))
				{
					expressions[key] = expressions[key].replace(match, expressions[k2]);
				}
				else
				{
					expressions[key] = expressions[key].replace(match, "(" + expressions[k2] + ")");
				}
			}
		}
		
		// whoa
	}
	
}

}