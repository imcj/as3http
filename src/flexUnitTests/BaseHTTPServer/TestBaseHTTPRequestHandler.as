package flexUnitTests.BaseHTTPServer
{
	import BaseHTTPServer.BaseHTTPRequestHandler;
	
	import SocketServer.TCPServer;
	
	import flash.events.Event;
	import flash.net.Socket;
	
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.prepare;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class TestBaseHTTPRequestHandler
	{		
		public var request : BaseHTTPRequestHandler;
		public var socket : Socket;
		
		[Before(async, order=1)]
		public function setMock():void
		{
			Async.proceedOnEvent ( this, prepare ( Socket, TCPServer ), Event.COMPLETE );
		}
		
		[Before(async, order=2)]
		public function setUp ( ) : void
		{
			socket = nice ( Socket );
			mock ( socket )
			.method ( "readUTFBytes" )
			.anyArgs ( )
			.returns ( "GET / HTTP/1.1\nHost: localhost\nConnection: keep-alive\nCache-Control: max-age=0\nUser-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\nAccept-Encoding: gzip,deflate,sdch\nAccept-Language: zh-CN,zh;q=0.8\nAccept-Charset: GBK,utf-8;q=0.7,*;q=0.3\n\n" );
			
			mock ( socket )
			.getter ( "bytesAvailable" )
			.returns ( 1 );
			
			mock ( socket )
			.method ( "writeUTFBytes" )
			.args ( String )
			.callsWithArguments ( function ( text : String ) : void
				{
					trace ( text );
				}
			);
			
			var server : TCPServer = nice ( TCPServer );
			mock ( server ).method ( "server_bind" ).anyArgs ( );
			
			request = new BaseHTTPRequestHandler ( socket, [ "127.0.0.1", "8080" ], server )
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test]
		public function testBaseHTTPRequestHandler ( ) : void
		{
			assertEquals ( "GET", request.command );
			assertEquals ( "/", request.path );
			assertEquals ( "HTTP/1.1", request.version );
		}
		
		[Test]
		public function testSendError ( ) : void
		{
			request.send_error ( 404 );
		}
		
		[Test]
		public function testDateTimeString ( ) : void
		{
			assertTrue ( request.date_time_string ( ).length > 1 );
		}
		
		[Test]
		public function testVersionString ( ) : void
		{
			assertEquals ( "BaseHTTP/0.1 ActionScript/3.0", request.version_string ( ) );
		}
	}
}