using iOS6Sim.Windows.Simulator;

namespace iOS6Sim.Windows.Views;

/// <summary>iOS 6 lock screen: wallpaper, clock, "slide to unlock".</summary>
public sealed class LockScreenView : ContentView
{
    public LockScreenView()
    {
        var state = SimState.Shared;

        var clock = new Label
        {
            Text = DateTime.Now.ToString("h:mm"),
            FontSize = 72, FontAttributes = FontAttributes.Bold,
            TextColor = Colors.White,
            HorizontalTextAlignment = TextAlignment.Center,
        };
        var date = new Label
        {
            Text = DateTime.Now.ToString("dddd, MMMM d"),
            FontSize = 16, TextColor = Colors.White.WithAlpha(0.9f),
            HorizontalTextAlignment = TextAlignment.Center,
        };

        var slider = new Slider
        {
            Minimum = 0, Maximum = 100, Value = 0,
            HorizontalOptions = LayoutOptions.Fill,
            Margin = new Thickness(32, 0),
        };
        var hint = new Label
        {
            Text = "slide to unlock",
            FontSize = 16, TextColor = Colors.White.WithAlpha(0.85f),
            HorizontalTextAlignment = TextAlignment.Center,
        };
        slider.ValueChanged += (_, e) =>
        {
            if (e.NewValue >= 99)
                state.Unlock();
        };

        var layout = new VerticalStackLayout { Spacing = 0 };
        layout.Add(IOS6UI.StatusBar());
        layout.Add(new VerticalStackLayout
        {
            Spacing = 4,
            VerticalOptions = LayoutOptions.Start,
            Margin = new Thickness(0, 48, 0, 0),
            Children = { clock, date },
        });
        layout.Add(new VerticalStackLayout
        {
            VerticalOptions = LayoutOptions.End,
            Margin = new Thickness(0, 0, 0, 48),
            Spacing = 8,
            Children = { hint, slider },
        });

        Content = new Grid
        {
            BackgroundColor = Color.FromRgb(0x1A, 0x2A, 0x4A), // deep blue wallpaper
            Children = { layout },
        };

        // Live clock.
        var timer = Dispatcher.CreateTimer();
        timer.Interval = TimeSpan.FromSeconds(10);
        timer.Tick += (_, _) =>
        {
            clock.Text = DateTime.Now.ToString("h:mm");
            date.Text = DateTime.Now.ToString("dddd, MMMM d");
        };
        timer.Start();
    }
}
