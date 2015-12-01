package logviewer

import io.vertx.core.Vertx
import io.vertx.core.VertxOptions
import org.apache.logging.log4j.LogManager

class Starter {
	static val LOG = LogManager.logger
	
	
	def static void main(String[] args) {
		val vertx = Vertx.vertx(new VertxOptions);
		
		LOG.info('im here')
		
		vertx.deployVerticle(LogReader.name)
		vertx.deployVerticle(LogEventProcessor.name)
		
	}	
}