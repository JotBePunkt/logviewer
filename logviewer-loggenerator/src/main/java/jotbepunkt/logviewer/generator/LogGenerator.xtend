package jotbepunkt.logviewer.generator

import io.vertx.core.Future
import io.vertx.rxjava.core.AbstractVerticle
import io.vertx.rxjava.core.buffer.Buffer
import java.util.ArrayList
import java.util.List
import java.util.Random
import org.apache.logging.log4j.Level
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.Logger
import rx.Observable

class LogGenerator extends AbstractVerticle
{

	val static RANDOM = new Random
	val static log = LogManager.logger

	val lines = <String>newArrayList
	val words = <String>newArrayList

	val loggers = <Logger>newArrayList

	var int loggerCount
	var int minDelay
	var int maxDelay
	var int maxParams
	var String textPath

	override start(Future<Void> startFuture)
	throws Exception {
		readConfig()

		readTextFilesObserable.subscribe(
		[
			log.info('did something')
			readSingleFile
		], [ cause |
			startFuture.fail(cause)
		], [
			createLoggers
			setNextTimer
			startFuture.complete()
		])
	}

	def createLoggers()
	{
		log.info('creating loggers')

		for (var i = 0; i < loggerCount; i++)
		{
			loggers.add(LogManager.getLogger(words.pickRandom(10).join('.')))
		}
	}

	def void setNextTimer()
	{
		vertx.setTimer(RANDOM.nextInt(maxDelay - minDelay) + minDelay, [
			logSomething
			setNextTimer
		])
	}

	def readConfig()
	{
		minDelay = config.getInteger("minDelay", 100)
		maxDelay = config.getInteger("maxDelay", 10000)
		textPath = config.getString("textPath", './')
		maxParams = config.getInteger("maxParams", 15)
		loggerCount = config.getInteger('loggerCount', 50)
	}

	def readTextFilesObserable()
	{
		log.info('reading texts from {}', textPath)
		vertx.fileSystem.readDirObservable(textPath).flatMap [ result |
			Observable.from(result).concatMap [ fileName |
				vertx.fileSystem.readFileObservable(fileName)
			]
		]
	}

	def readSingleFile(Buffer result)
	{
		val string = result.toString('UTF-8')
		lines += string.split('\n')
		words += string.split('\\s')
	}

	def logSomething()
	{
		// TODO: Markers
		// TODO: Exceptions
		// TODO: ThreadContent
		val logMessage = lines.pickRandom
		val parameters = words.pickRandom(maxParams)
		loggers.pickRandom.log(Level.values.pickRandom, logMessage, parameters)
	}

	def <T> pickRandom(List<T> strings)
	{
		strings.get(RANDOM.nextInt(strings.size))
	}

	def <T> pickRandom(List<T> values, int max)
	{
		val amount = RANDOM.nextInt(max)
		val result = new ArrayList(amount)
		while (result.size < amount)
		{
			result.add(values.pickRandom)
		}
		result
	}
}