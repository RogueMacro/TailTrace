using System;

namespace TailTrace.Loggers
{
	class ConsoleLogger : BaseLogger
	{
		public override void Log(LogLevel level, String message)
		{
			Console.WriteLine(message);
		}
	}
}