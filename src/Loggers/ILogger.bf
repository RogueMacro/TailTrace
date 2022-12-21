using System;

namespace TailTrace.Loggers
{
	interface ILogger
	{
		String Format { get; }
		LogLevel Level { get; }

		void Log(LogLevel level, String message);
	}
}