package SimpleHTTPServer
{
	import BaseHTTPServer.BaseHTTPRequestHandler;
	
	import SocketServer.BaseServer;
	
	import flash.net.Socket;
	import flash.net.dns.AAAARecord;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	public class SimpleHTTPRequestHandler extends BaseHTTPRequestHandler
	{
		// TODO mimetypes
		static public var types_map : Object = {
			'.a'      : 'application/octet-stream',
			'.ai'     : 'application/postscript',
			'.aif'    : 'audio/x-aiff',
			'.aifc'   : 'audio/x-aiff',
			'.aiff'   : 'audio/x-aiff',
			'.au'     : 'audio/basic',
			'.avi'    : 'video/x-msvideo',
			'.bat'    : 'text/plain',
			'.bcpio'  : 'application/x-bcpio',
			'.bin'    : 'application/octet-stream',
			'.bmp'    : 'image/x-ms-bmp',
			'.c'      : 'text/plain',
			'.cdf'    : 'application/x-cdf',
			'.cdf'    : 'application/x-netcdf',
			'.cpio'   : 'application/x-cpio',
			'.csh'    : 'application/x-csh',
			'.css'    : 'text/css',
			'.dll'    : 'application/octet-stream',
			'.doc'    : 'application/msword',
			'.dot'    : 'application/msword',
			'.dvi'    : 'application/x-dvi',
			'.eml'    : 'message/rfc822',
			'.eps'    : 'application/postscript',
			'.etx'    : 'text/x-setext',
			'.exe'    : 'application/octet-stream',
			'.gif'    : 'image/gif',
			'.gtar'   : 'application/x-gtar',
			'.h'      : 'text/plain',
			'.hdf'    : 'application/x-hdf',
			'.htm'    : 'text/html',
			'.html'   : 'text/html',
			'.ief'    : 'image/ief',
			'.jpe'    : 'image/jpeg',
			'.jpeg'   : 'image/jpeg',
			'.jpg'    : 'image/jpeg',
			'.js'     : 'application/x-javascript',
			'.ksh'    : 'text/plain',
			'.latex'  : 'application/x-latex',
			'.m1v'    : 'video/mpeg',
			'.man'    : 'application/x-troff-man',
			'.me'     : 'application/x-troff-me',
			'.mht'    : 'message/rfc822',
			'.mhtml'  : 'message/rfc822',
			'.mif'    : 'application/x-mif',
			'.mov'    : 'video/quicktime',
			'.movie'  : 'video/x-sgi-movie',
			'.mp2'    : 'audio/mpeg',
			'.mp3'    : 'audio/mpeg',
			'.mp4'    : 'video/mp4',
			'.mpa'    : 'video/mpeg',
			'.mpe'    : 'video/mpeg',
			'.mpeg'   : 'video/mpeg',
			'.mpg'    : 'video/mpeg',
			'.ms'     : 'application/x-troff-ms',
			'.nc'     : 'application/x-netcdf',
			'.nws'    : 'message/rfc822',
			'.o'      : 'application/octet-stream',
			'.obj'    : 'application/octet-stream',
			'.oda'    : 'application/oda',
			'.p12'    : 'application/x-pkcs12',
			'.p7c'    : 'application/pkcs7-mime',
			'.pbm'    : 'image/x-portable-bitmap',
			'.pdf'    : 'application/pdf',
			'.pfx'    : 'application/x-pkcs12',
			'.pgm'    : 'image/x-portable-graymap',
			'.pl'     : 'text/plain',
			'.png'    : 'image/png',
			'.pnm'    : 'image/x-portable-anymap',
			'.pot'    : 'application/vnd.ms-powerpoint',
			'.ppa'    : 'application/vnd.ms-powerpoint',
			'.ppm'    : 'image/x-portable-pixmap',
			'.pps'    : 'application/vnd.ms-powerpoint',
			'.ppt'    : 'application/vnd.ms-powerpoint',
			'.ps'     : 'application/postscript',
			'.pwz'    : 'application/vnd.ms-powerpoint',
			'.py'     : 'text/x-python',
			'.pyc'    : 'application/x-python-code',
			'.pyo'    : 'application/x-python-code',
			'.qt'     : 'video/quicktime',
			'.ra'     : 'audio/x-pn-realaudio',
			'.ram'    : 'application/x-pn-realaudio',
			'.ras'    : 'image/x-cmu-raster',
			'.rdf'    : 'application/xml',
			'.rgb'    : 'image/x-rgb',
			'.roff'   : 'application/x-troff',
			'.rtx'    : 'text/richtext',
			'.sgm'    : 'text/x-sgml',
			'.sgml'   : 'text/x-sgml',
			'.sh'     : 'application/x-sh',
			'.shar'   : 'application/x-shar',
			'.snd'    : 'audio/basic',
			'.so'     : 'application/octet-stream',
			'.src'    : 'application/x-wais-source',
			'.sv4cpio': 'application/x-sv4cpio',
			'.sv4crc' : 'application/x-sv4crc',
			'.swf'    : 'application/x-shockwave-flash',
			'.t'      : 'application/x-troff',
			'.tar'    : 'application/x-tar',
			'.tcl'    : 'application/x-tcl',
			'.tex'    : 'application/x-tex',
			'.texi'   : 'application/x-texinfo',
			'.texinfo': 'application/x-texinfo',
			'.tif'    : 'image/tiff',
			'.tiff'   : 'image/tiff',
			'.tr'     : 'application/x-troff',
			'.tsv'    : 'text/tab-separated-values',
			'.txt'    : 'text/plain',
			'.ustar'  : 'application/x-ustar',
			'.vcf'    : 'text/x-vcard',
			'.wav'    : 'audio/x-wav',
			'.wiz'    : 'application/msword',
			'.wsdl'   : 'application/xml',
			'.xbm'    : 'image/x-xbitmap',
			'.xlb'    : 'application/vnd.ms-excel',
			'.xls'    : 'application/excel',
			'.xls'    : 'application/vnd.ms-excel',
			'.xml'    : 'text/xml',
			'.xpdl'   : 'application/xml',
			'.xpm'    : 'image/x-xpixmap',
			'.xsl'    : 'application/xml',
			'.xwd'    : 'image/x-xwindowdump',
			'.zip'    : 'application/zip'
		};
		
		public function SimpleHTTPRequestHandler ( request : Socket, client_address : Array, server : BaseServer )
		{
			super ( request, client_address, server );
			
			types_map['']    = 'application/octet-stream';
			types_map['.py'] = 'text/plain';
			types_map['.c']  = 'text/plain';
			types_map['.h']  = 'text/plain';
		}
			
		override public function get server_version ( ) : String
		{
			return "SimpleHTTP/" + __version__;
		}
		
		public function do_GET ( ) : void
		{
			
		}
		
		public function do_HEAD ( ) : void
		{
			
		}
		
		public function send_head ( ) : IDataInput
		{
			return null;
		}
		
		public function list_directory ( path : String ) : ByteArray
		{
			return null;
		}
		
		public function translate_path ( path : String ) : String
		{
			return null;
		}
		
		public function copyfile ( source : IDataInput, outputfile : IDataOutput ) : void
		{
			
		}
		
		public function guess_type ( path : String ) : String
		{
			return null;
		}
	}
}