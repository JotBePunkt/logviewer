package logviewer

import io.vertx.core.AbstractVerticle
import io.vertx.ext.mongo.MongoClient
import io.vertx.core.json.JsonObject

class LogReader extends AbstractVerticle {

	val public static EVENT_ADDRESS = 'logEvent'

	MongoClient client
	long timerId;


	override start() throws Exception {
		super.start()
		val config = new JsonObject().put("db_name", "applicationDb")

		client = MongoClient.createShared(vertx, config);

		vertx.setPeriodic(1000, [
			client.find("applicationLog", new JsonObject(#{'processed' -> #{'$exists'->false}}), [ result |
				result.result.forEach[event | vertx.eventBus.send(EVENT_ADDRESS, event)]
			])
		])
	}
	
	override stop() throws Exception {
		vertx.cancelTimer(timerId)
	}

}