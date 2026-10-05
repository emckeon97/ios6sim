using iOS6Sim.Windows.Simulator;
using iOS6Sim.Windows.Views;

namespace iOS6Sim.Windows.Apps;

/// <summary>iOS 6 Clock — live analog-style face + digital readout.</summary>
public sealed class ClockView : ContentView
{
    private readonly Label _digital;

    public ClockView()
    {
        var state = SimState.Shared;
        _digital = new Label
        {
            FontSize = 44, FontAttributes = FontAttributes.Bold,
            TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center,
        };

        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = Colors.Black,
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(IOS6UI.NavBar("Clock", onBack: () => state.GoHome()), 0, 1);
        layout.Add(new VerticalStackLayout
        {
            VerticalOptions = LayoutOptions.Center,
            Spacing = 16,
            Children =
            {
                new Label
                {
                    Text = "◷", FontSize = 120, TextColor = Colors.White,
                    HorizontalTextAlignment = TextAlignment.Center,
                },
                _digital,
                new Label
                {
                    Text = DateTime.Now.ToString("dddd, MMMM d, yyyy"),
                    FontSize = 14, TextColor = Colors.Gray,
                    HorizontalTextAlignment = TextAlignment.Center,
                },
            },
        }, 0, 2);

        Content = layout;
        Tick();
        var timer = Dispatcher.CreateTimer();
        timer.Interval = TimeSpan.FromSeconds(1);
        timer.Tick += (_, _) => Tick();
        timer.Start();
    }

    private void Tick() => _digital.Text = DateTime.Now.ToString("h:mm:ss");
}
