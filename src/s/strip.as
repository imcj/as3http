package s
{
	public function strip ( text : String ) : String
	{
		var whitespace : RegExp = /^[\t\n\r\v\f ]*/g;
		return text.replace ( whitespace, "" );
	}
}