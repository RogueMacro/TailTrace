using System;

namespace TailTrace.Formatting
{
	interface IFormatter
	{
		public void Format(LogLevel level, StringView module, StringView format, StringView message, String strBuffer);
	}
}