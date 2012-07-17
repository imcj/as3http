package BaseHTTPServer
{
	import SocketServer.BaseServer;
	import SocketServer.StreamRequestHandler;
	
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import mimetools.Message;
	
	import mx.utils.StringUtil;
	
	public class BaseHTTPRequestHandler extends StreamRequestHandler
	{
		static public const sys_version : String = "ActionScript/3.0";
		static public const __version__ : String = "0.1";
		static public const server_version : String = "BaseHTTP/" + __version__;
		static public const default_request_version : String = "HTTP/0.9";
		static public const protocol_version : String = "HTTP/1.0";
		
		public var request_version : String;
		public var close_connection:Boolean;
		public var command : String;
		public var raw_requestline:String;
		public var requestline:String;
		public var iter : SocketTextIter;
		public var headers : Dictionary;
		public var MessageClass : Class = mimetools.Message;
		
		public function BaseHTTPRequestHandler(request:Socket, client_address:Array, server:BaseServer)
		{
			super(request, client_address, server);
			iter = new SocketTextIter ( request );
		}
		
		override public function handle ( ) : void
		{
			close_connection = true;
			handle_one_request ( );
			while ( ! close_connection )
				handle_one_request ( );
		}
		
		public function handle_one_request():void
		{
			var mname : String;
			var method : Function;
			raw_requestline = iter.readline ( 65537 );
			if ( raw_requestline.length > 65536 ) {
				requestline = '';
				request_version = '';
				command = '';
				send_error ( 414 );
			}
			
			if ( ! raw_requestline ) {
				close_connection = true;
				return;
			}
			
			if ( ! parse_header ( ) )
				return;
			
			mname = "do_" + command;
			if ( ! this.hasOwnProperty ( mname ) ) {
				send_error ( 501, StringUtil.substitute ( "Unsupported method ({0})", command ) );
				return;
			}
			
			method = this[mname];
			method ( );
			request.flush ( );
		}
		
		public function parse_header():Boolean
		{
			var version : String;
			var words : Array;
			var command : String;
			var path : String;
			var version : String;
			var conntype : String;
			
			command = null;
			this.request_version = version = default_request_version;
			close_connection = true;
			requestline = raw_requestline;
//			requestline.rstrip
			words = requestline.split ( " " );
			if ( 3 == words.length )
			{
				command = words[0];
				path = words[1];
				version = words[2];
				if ( "HTTP/" == version.substring ( 0, 5 ) ){
					
				}
			} else if ( ! words )
				return false;
			else {
				send_error ( 501, StringUtil.substitute ( "Bad request syntax ({0})", requestline ) );
				return false;
			}
			headers = new this.MessageClass ( iter, 0 );
			conntype = headers["Connection"];
			if ( "close" == conntype.toLowerCase ( ) )
				close_connection = true;
			else if ( "keep-alive" == conntype.toLowerCase ( ) && protocol_version >= "HTTP/1.1" )
				close_connection = false;
			
			return true;
		}
		
		public function send_error ( code : int, message : String = "" ) : void
		{
			
		}
		
		public function send_response ( code : int, message : int ) : void
		{
			
		}
		
		public function send_header ( keyword : String, value : String ) : void
		{
			if ( 'HTTP/0.9' != request_version )
				request.writeUTFBytes ( StringUtil.substitute ( "{0}: {1}\r\n", keyword, value ) );
			
			if ( keyword.toLowerCase ( ) == 'connection' )
				if ( value.toLowerCase ( ) == 'close' )
					close_connection = true;
				else
					close_connection = false;
		}
		
		public function end_headers ( ) : void
		{
			if ( 'HTTP/0.9' != request_version )
				request.writeUTFBytes ( "\r\n" );
		}
	}
}
import flash.net.Socket;

class SocketTextIter
{
	private var _socket:Socket;
	private var data:String;
	private var offset : int = 0;
	
	public function SocketTextIter ( socket : Socket )
	{
		_socket = socket;
	}
	
	public function readline ( length : int ) : String
	{
		if ( _socket.bytesAvailable > 0 )
			data += _socket.readUTFBytes ( 65537 );
		
		var index : int = data.indexOf ( "\r\n", offset );
		var found : String;
		if ( index > -1 ) {
			found = data.substring ( offset, index );
			offset = index + "\r\n".length;
		} else
			found = null;
		
		return found;
	}
}