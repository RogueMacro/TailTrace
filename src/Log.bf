using System;
using System.Collections;
using TailTrace.Formatting;
using TailTrace.Loggers;

namespace TailTrace
{
	static class Log
	{
		private static IFormatter DefaultFormatter = new DefaultFormatter() ~ delete _;

		private static List<(ILogger, IFormatter)> Loggers = new .() ~
			{
				for (let (logger, formatter) in _)
				{
					delete logger;
					if (formatter != null)
						delete formatter;
				}
				delete _;
			};

		private static List<String> SelectedModules = new .() ~ DeleteContainerAndItems!(_);

		/*public static mixin Info(StringView format, ...) => Log(.Info, Compiler.ModuleName, format, VarArgs().ToVAList());*/

		[Inline] public static void Trace(StringView format, params Object[] args) => Log(.Trace, Compiler.ModuleName, format, params args);
		[Inline] public static void Debug(StringView format, params Object[] args) => Log(.Debug, Compiler.ModuleName, format, params args);
		[Inline] public static void Info(StringView format, params Object[] args) => Log(.Info, Compiler.ModuleName, format, params args);
		[Inline] public static void Warning(StringView format, params Object[] args) => Log(.Warning, Compiler.ModuleName, format, params args);
		[Inline] public static void Error(StringView format, params Object[] args) => Log(.Error, Compiler.ModuleName, format, params args);

		public static void AddLogger(ILogger logger, IFormatter formatter = null)
		{
			Loggers.Add((logger, formatter));
		}

		private static void Log(LogLevel level, String _module, StringView format, params Object[] args)
		{
			String module = scope .(_module)..Replace('_', '.');

#if FEATURE_MUTING
			if (IsMuted(module))
				return;
#endif

			let message = scope String()..AppendF(format, params args);

			for (let (logger, formatter) in Loggers)
			{
				if (logger.Level > level)
					continue;

				var formatter;
				if (formatter == null)
					formatter = DefaultFormatter;

				String strBuffer = scope .();
				formatter.Format(level, module, logger.Format, message, strBuffer);
				logger.Log(level, strBuffer);
			}
		}

#if FEATURE_MUTING
		/// Specifies if modules should be muted or not by default.
		/// Changing this will invert muted/unmuted modules.
		public static DefaultMuteMode DefaultMuteMode = .Unmuted;

		public static void MuteModule(StringView module)
		{
			switch (DefaultMuteMode)
			{
			case .Muted: DeselectModule(module);
			case .Unmuted: SelectModule(module);
			}
		}

		public static void UnmuteModule(StringView module)
		{
			switch (DefaultMuteMode)
			{
			case .Muted: SelectModule(module);
			case .Unmuted: DeselectModule(module);
			}
		}

		private static void SelectModule(StringView module)
		{
			SelectedModules.Add(new String(module));
		}

		private static void DeselectModule(StringView module)
		{
			if (SelectedModules.GetAndRemoveAlt(module) case .Ok(let val))
				delete val;
		}

		private static bool IsMuted(String module)
		{
			bool isSelected = false;
			findModuleLoop: for (let selected in SelectedModules)
			{
				var selectedParts = selected.Split('.');
				var moduleParts = module.Split('.');
				for (let part in selectedParts)
				{
					let modPart = moduleParts.GetNext();
					if (modPart case .Err || modPart.Value != part)
						continue findModuleLoop;
				}

				isSelected = true;
				break;
			}

			return (DefaultMuteMode == .Muted && !isSelected) || (DefaultMuteMode == .Unmuted && isSelected);
		}

		public enum DefaultMuteMode
		{
			Muted,
			Unmuted
		}
#endif
	}
}