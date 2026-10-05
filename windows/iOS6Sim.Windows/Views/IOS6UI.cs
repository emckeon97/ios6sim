using iOS6Sim.Windows.Simulator;

namespace iOS6Sim.Windows.Views;

/// <summary>iOS 6 shared chrome: linen texture bg, nav bar, tab bar.</summary>
public static class IOS6UI
{
    // iOS 6 palette
    public static Color LinenDark => Color.FromRgb(0x1E, 0x1E, 0x22);
    public static Color NavBlue => Color.FromRgb(0x6E, 0x82, 0x9B);
    public static Color NavBlueDark => Color.FromRgb(0x4A, 0x5A, 0x78);

    /// <summary>iOS 6 glossy blue navigation bar.</summary>
    public static View NavBar(string title, Action? onBack = null)
    {
        var titleLabel = new Label
        {
            Text = title, FontSize = 17, FontAttributes = FontAttributes.Bold,
            TextColor = Colors.White, HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center,
        };
        var grid = new Grid { HeightRequest = 44, BackgroundColor = NavBlue };
        // Gloss: lighter top half.
        var gloss = new BoxView
        {
            BackgroundColor = Colors.White.WithAlpha(0.18f),
            HeightRequest = 22, VerticalOptions = LayoutOptions.Start,
        };
        grid.Add(gloss);
        grid.Add(titleLabel);
        if (onBack != null)
        {
            var back = new Button
            {
                Text = "‹ Back", FontSize = 14, TextColor = Colors.White,
                BackgroundColor = Colors.Transparent,
                HorizontalOptions = LayoutOptions.Start,
                VerticalOptions = LayoutOptions.Center,
                Padding = new Thickness(8, 4),
            };
            back.Clicked += (_, _) => onBack();
            grid.Add(back);
        }
        return grid;
    }

    /// <summary>iOS 6 status bar: carrier, time, battery.</summary>
    public static View StatusBar()
    {
        var state = SimState.Shared;
        var grid = new Grid
        {
            HeightRequest = 20,
            BackgroundColor = Colors.Black,
            ColumnDefinitions =
            {
                new ColumnDefinition { Width = GridLength.Star },
                new ColumnDefinition { Width = GridLength.Auto },
                new ColumnDefinition { Width = GridLength.Star },
            },
        };
        var carrier = new Label
        {
            Text = "  📶 Carrier", FontSize = 10, TextColor = Colors.White,
            VerticalOptions = LayoutOptions.Center,
        };
        var time = new Label
        {
            Text = DateTime.Now.ToString("h:mm"),
            FontSize = 11, FontAttributes = FontAttributes.Bold,
            TextColor = Colors.White,
            HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center,
        };
        var battery = new Label
        {
            Text = "🔋 ", FontSize = 10, TextColor = Colors.White,
            HorizontalOptions = LayoutOptions.End,
            VerticalOptions = LayoutOptions.Center,
        };
        grid.Add(carrier, 0, 0);
        grid.Add(time, 1, 0);
        grid.Add(battery, 2, 0);
        return grid;
    }

    /// <summary>Linen background used across iOS 6 apps.</summary>
    public static Color LinenBrush => Color.FromRgb(0xE8, 0xE8, 0xE8);
}
