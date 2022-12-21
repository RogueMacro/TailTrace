# TailTrace

Logging library for [the Beef Programming Language](https://github.com/beefytech/Beef).

Also available for Grill: https://grillpm.vercel.app/package/TailTrace.

## Initialization

You can add loggers by using `AddLogger` on the static `Log` class.

```c#
Log.AddLogger(
    new ConsoleLogger()
        ..SetLevel(.Trace)
        ..SetFormat("%l: %x"),
    new MyFormatter()
);
```

If a custom formatter is not provided the `DefaultFormatter` will be used. See `TailTrace.Formatting.DefaultFormatter` if you want to use a custom format like shown above.

## Logging

```c#
Log.Trace("{}", "Trace");
Log.Debug("Debug");
Log.Info("Info");
Log.Warning("Warning");
Log.Error("Error");
```

## Muting/unmuting modules

Muting is not enabled by default. If you're using Grill you can add `Muting` to the feature list of this dependency:

```toml
[Dependencies]
TailTrace = { ..., Features = ["Muting"] }
```

If you are not using Grill, add `FEATURE_MUTING` as a preprocessor macro to this project.

## Console styling

Styling can be applied to an object with either the `Styled(...)` function, or instantiated directly with `StyledObject<T>(...)`. The `Styled` function is just a convenience function to infer the generic type.

### Example:

```c#
Console.WriteLine("[{}] Oh No!", Styled("Error")..Red()..Bright());
```
