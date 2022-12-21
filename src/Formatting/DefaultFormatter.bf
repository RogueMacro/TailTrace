using System;
using TailTrace.Console;

namespace TailTrace.Formatting
{
	/*
	- Formatting -
	----------------------------------------
	| Token | Formatted to     | Example   |
	----------------------------------------
	| %t    | Time             | 11:42:34  |
	----------------------------------------
	| %h    | Hours            | 11        |
	----------------------------------------
	| %m    | Minutes          | 42        |
	----------------------------------------
	| %s    | Seconds          | 34        |
	----------------------------------------
	| %e    | Milliseconds     |           |
	----------------------------------------
	| %y    | Year             | 2020      |
	----------------------------------------
	| %o    | Month            | January   |
	----------------------------------------
	| %d    | Day of week      | Monday    |
	----------------------------------------
	| %a    | Day of month     | 21th      |
	----------------------------------------
	| %n    | Logger name      | MyLogger  |
	----------------------------------------
	| %u    | Module name      | TestLib   |
	----------------------------------------
	| %x    | Message          |           |
	----------------------------------------
	| %l    | Log level        | Warning   |
	----------------------------------------
	| %q    | Log level spaced | [ Trace ] |
	----------------------------------------

	-------------------------------------
	| %qX   | X=Extra space (0, 1 or 2) |
	-------------------------------------
	| Example: [%q0]                    |
	-------------------------------------
	|  [ Trace ]                        |
	|  [ Info  ]                        |
	|  [Warning]                        |
	|  [ Error ]                        |
	|  [Success]                        |
	-------------------------------------
	| Example: [%q1]                    |
	-------------------------------------
	|  [  Trace  ]                      |
	|  [  Info   ]                      |
	|  [ Warning ]                      |
	|  [  Error  ]                      |
	|  [ Success ]                      |
	-------------------------------------
	| Example: [%q2]                    |
	-------------------------------------
	|  [   Trace   ]                    |
	|  [   Info    ]                    |
	|  [  Warning  ]                    |
	|  [   Error   ]                    |
	|  [  Success  ]                    |
	-------------------------------------
	*/
	class DefaultFormatter : IFormatter
	{
		public bool UseStyles = true;

		public String TraceStyled   = Styled(LogLevel.Trace)                    .ToString(.. new .()) ~ delete _;
		public String DebugStyled   = Styled(LogLevel.Debug)  ..Cyan()..Bright().ToString(.. new .()) ~ delete _;
		public String InfoStyled    = Styled(LogLevel.Info)   ..Cyan()          .ToString(.. new .()) ~ delete _;
		public String WarningStyled = Styled(LogLevel.Warning)..Yellow()        .ToString(.. new .()) ~ delete _;
		public String ErrorStyled   = Styled(LogLevel.Error)  ..Red()..Bright() .ToString(.. new .()) ~ delete _;

		public void Format(LogLevel level, StringView module, StringView format, StringView message, String strBuffer)
		{
			for (int i = 0; i < format.Length; ++i)
			{
				if (format[i] == '%' && i + 1 < format.Length)
				{
					switch (format[i + 1])
					{
					case 't':
						strBuffer.AppendF("{}:{}:{}", DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
						break;
					case 'h':
						strBuffer.AppendF("{}", DateTime.Now.Hour);
						break;
					case 'm':
						strBuffer.AppendF("{}", DateTime.Now.Minute);
						break;
					case 's':
						strBuffer.AppendF("{}", DateTime.Now.Second);
						break;
					case 'e':
						strBuffer.AppendF("{}", DateTime.Now.Millisecond);
						break;
					case 'y':
						strBuffer.AppendF("{}", DateTime.Now.Year);
						break;
					case 'o':
						strBuffer.AppendF("{}", DateTime.Now.Month);
						break;
					case 'd':
						strBuffer.AppendF("{}", DateTime.Now.DayOfWeek);
						break;
					case 'a':
						strBuffer.AppendF("{}", DateTime.Now.Day);
						break;
					case 'x':
						strBuffer.Append(message);
						break;
					case 'u':
						strBuffer.AppendF("{}", module);
					case 'l':
						if (UseStyles)
						{
							switch (level)
							{
							case .Trace:
								strBuffer.Append(TraceStyled);
							case .Debug:
								strBuffer.Append(DebugStyled);
							case .Info:
								strBuffer.Append(InfoStyled);
							case .Warning:
								strBuffer.Append(WarningStyled);
							case .Error:
								strBuffer.Append(ErrorStyled);
							}
						}
						else
						{
							strBuffer.Append(level);
						}
					case 'q':
						String appendFmt = scope .("{}");
						int space = 1;
						if (i + 2 < format.Length && format[i + 2].IsDigit)
						{
							space = int.Parse(scope String()..Append(format[i + 2]));
							i++;
						}

						switch (level)
						{
						case .Trace,.Debug,.Error:
							if (space == 0)
								appendFmt.Set(" {} ");
							else if (space == 1)
								appendFmt.Set("  {}  ");
							else if (space == 2)
								appendFmt.Set("   {}   ");
							break;
						case .Info:
							if (space == 0)
								appendFmt.Set(" {}  ");
							else if (space == 1)
								appendFmt.Set("  {}   ");
							else if (space == 2)
								appendFmt.Set("   {}    ");
							break;
						case .Warning:
							if (space == 0)
								appendFmt.Set("{}");
							else if (space == 1)
								appendFmt.Set(" {} ");
							else if (space == 2)
								appendFmt.Set("  {}  ");
							break;
						}

						if (UseStyles)
						{
							switch (level)
							{
							case .Trace:
								strBuffer.AppendF(appendFmt, TraceStyled);
							case .Debug:
								strBuffer.AppendF(appendFmt, DebugStyled);
							case .Info:
								strBuffer.AppendF(appendFmt, InfoStyled);
							case .Warning:
								strBuffer.AppendF(appendFmt, WarningStyled);
							case .Error:
								strBuffer.AppendF(appendFmt, ErrorStyled);
							}
						}
						else
						{
							strBuffer.AppendF(appendFmt, level);
						}

					default:
						i--;
					}

					i++;
				}
				else
				{
					strBuffer.Append(format[i]);
				}
			}
		}
	}
}