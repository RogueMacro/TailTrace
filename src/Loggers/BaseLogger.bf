using System;

namespace TailTrace.Loggers
{
	abstract class BaseLogger : ILogger
	{
		public virtual String Format => CustomFormat.Get("[%q1] %x");
		protected Result<String> CustomFormat = .Err ~ if (_ case .Ok(let val)) delete val;

		public LogLevel Level => MinLevel;
		protected LogLevel MinLevel = .Info;

		public void SetFormat(StringView format)
		{
			CustomFormat = .Ok(new .(format));
		}

		public void SetLevel(LogLevel minimum)
		{
			MinLevel = minimum;
		}

		public abstract void Log(LogLevel level, String message);
	}
}