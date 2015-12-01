package logviewer

import io.vertx.core.AbstractVerticle
import io.vertx.ext.mongo.MongoClient
import io.vertx.core.json.JsonObject

class LogEventProcessor extends AbstractVerticle {
	
	MongoClient client
	
	override start() throws Exception {
		
		val config = new JsonObject().put("db_name", "applicationDb")

		client = MongoClient.createShared(vertx, config);
		
		vertx.eventBus.consumer(LogReader.EVENT_ADDRESS, [
			val id = (body as JsonObject).getJsonObject('_id')
			println (id)
			
			client.update('applicationLog', new JsonObject(#{'_id' -> id}), new JsonObject(#{'$set' -> #{'processed' -> true}}), [ result |
				if (result.succeeded) {
					println('processed')
				} else {
					println(result.cause)
				}
			])
		] )
	}
	
}