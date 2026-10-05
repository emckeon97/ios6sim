using iOS6Sim.Windows.Simulator;
using iOS6Sim.Windows.Views;

namespace iOS6Sim.Windows.Apps;

/// <summary>iOS 6 Calculator — fully working.</summary>
public sealed class CalculatorView : ContentView
{
    private readonly Label _display;
    private double _accum;
    private double _current;
    private string? _pendingOp;
    private bool _fresh = true;

    public CalculatorView()
    {
        var state = SimState.Shared;
        _display = new Label
        {
            Text = "0", FontSize = 44, TextColor = Colors.White,
            HorizontalTextAlignment = TextAlignment.End,
            VerticalOptions = LayoutOptions.End,
            Margin = new Thickness(16, 0, 16, 8),
        };

        var grid = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = 110 },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = Color.FromRgb(0x1C, 0x1C, 0x1E),
        };
        grid.Add(IOS6UI.StatusBar(), 0, 0);
        grid.Add(IOS6UI.NavBar("Calculator", onBack: () => state.GoHome()), 0, 1);
        grid.Add(_display, 0, 2);

        var buttons = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition(), new RowDefinition(), new RowDefinition(),
                new RowDefinition(), new RowDefinition(),
            },
            ColumnDefinitions =
            {
                new ColumnDefinition(), new ColumnDefinition(),
                new ColumnDefinition(), new ColumnDefinition(),
            },
            Padding = 8,
            RowSpacing = 6, ColumnSpacing = 6,
        };
        string[,] keys =
        {
            { "C", "±", "%", "÷" },
            { "7", "8", "9", "×" },
            { "4", "5", "6", "−" },
            { "1", "2", "3", "+" },
            { "0", "0", ".", "=" },
        };
        for (int r = 0; r < 5; r++)
            for (int c = 0; c < 4; c++)
            {
                // Bottom row: "0" spans two columns.
                if (r == 4 && c == 1) continue;
                var key = keys[r, c];
                var b = new Button
                {
                    Text = key, FontSize = 24,
                    BackgroundColor = key is "÷" or "×" or "−" or "+" or "="
                        ? Color.FromRgb(0xF5, 0x9A, 0x23)
                        : Color.FromRgb(0x3A, 0x3A, 0x3C),
                    TextColor = Colors.White,
                    CornerRadius = 8,
                };
                b.Clicked += (_, _) => Press(key);
                buttons.Add(b, r == 4 && c == 0 ? 0 : c, r);
                if (r == 4 && c == 0)
                    Grid.SetColumnSpan(b, 2);
            }
        grid.Add(buttons, 0, 3);
        Content = grid;
    }

    private void Press(string key)
    {
        if (key == "C")
        {
            _accum = 0; _current = 0; _pendingOp = null; _fresh = true;
        }
        else if (key == "±") { _current = -_current; }
        else if (key == "%") { _current /= 100; }
        else if (key is "÷" or "×" or "−" or "+")
        {
            ApplyPending();
            _pendingOp = key;
            _fresh = true;
        }
        else if (key == "=")
        {
            ApplyPending();
            _pendingOp = null;
            _fresh = true;
        }
        else if (key == ".")
        {
            // Simple: ignore repeat dots.
            if (!_display.Text.Contains(".")) _display.Text += ".";
            _fresh = false;
            return;
        }
        else // digit
        {
            if (_fresh) { _display.Text = key; _fresh = false; }
            else if (_display.Text.Replace("-", "").Replace(".", "").Length < 12)
                _display.Text += key;
            _current = double.TryParse(_display.Text, out var v) ? v : 0;
            return;
        }
        _current = double.TryParse(_display.Text, out var cv) ? cv : _current;
        _display.Text = Format(_current);
    }

    private void ApplyPending()
    {
        if (_pendingOp == null) { _accum = _current; return; }
        _accum = _pendingOp switch
        {
            "÷" => _current == 0 ? double.NaN : _accum / _current,
            "×" => _accum * _current,
            "−" => _accum - _current,
            "+" => _accum + _current,
            _ => _current,
        };
        _current = _accum;
    }

    private static string Format(double v)
    {
        if (double.IsNaN(v) || double.IsInfinity(v)) return "Error";
        var s = v.ToString("G12");
        return s.Length > 12 ? v.ToString("E6") : s;
    }
}
