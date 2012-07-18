package s
{
	public function isin ( match : Object, data : Object ) : Boolean
	{
		var m : String;
		if ( match is String && data is String )
		{
			m = String ( match );
			var d : String = String ( data );
			
			for ( var i : int = 0, size : int = d.length; i < size; i ++ )
				if ( m == d.substr ( i, 1 ) )
					return true
					
			return false;
		}
		
		if ( match is String && data is Array ) {
			m = String ( match );
			var lst : Array = ( data as Array );
			var line : String;
			for each ( line in lst )
				if ( match == line )
					return true;
		}
		
		return false;
	}
}