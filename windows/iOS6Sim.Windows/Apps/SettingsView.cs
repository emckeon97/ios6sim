using iOS6Sim.Windows.Simulator;
using iOS6Sim.Windows.Views;
using Microsoft.Maui.Storage;

namespace iOS6Sim.Windows.Apps;

/// <summary>iOS 6 Settings — the greatest hits, all toggles persisted.</summary>
public sealed class SettingsView : ContentView
{
    private readonly SimState _state = SimState.Shared;

    public SettingsView()
    {
        var list = new VerticalStackLayout { Spacing = 0, Padding = new Thickness(0, 12, 0, 0) };

        list.Add(SectionHeader("Radios"));
        list.Add(ToggleRow("Airplane Mode", "ios6sim.airplane", false));
        list.Add(ToggleRow("Wi-Fi", "ios6sim.wifi", true));
        list.Add(ToggleRow("Bluetooth", "ios6sim.bluetooth", false));
        list.Add(ToggleRow("Cellular Data", "ios6sim.cellular", true));
        list.Add(ToggleRow("Do Not Disturb", "ios6sim.dnd", false));

        list.Add(SectionHeader("Display"));
        list.Add(SliderRow("Brightness", "ios6sim.brightness", 0.7));
        list.Add(ToggleRow("Auto-Brightness", "ios6sim.autobright", true));

        list.Add(SectionHeader("Sounds"));
        list.Add(ToggleRow("Vibrate on Ring", "ios6sim.vibrateRing", true));
        list.Add(ToggleRow("Vibrate on Silent", "ios6sim.vibrateSilent", true));
        list.Add(SliderRow("Ringer Volume", "ios6sim.ringVolume", 0.8));

        list.Add(SectionHeader("General"));
        list.Add(ToggleRow("Siri", "ios6sim.siri", true));
        list.Add(ToggleRow("Location Services", "ios6sim.locationServices", true));

        list.Add(SectionHeader("Jailbreak"));
        var jbRow = ToggleRow("Jailbroken (evasi0n)", "ios6sim.jailbroken", false);
        list.Add(jbRow);

        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = IOS6UI.LinenBrush,
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(IOS6UI.NavBar("Settings", onBack: () => _state.GoHome()), 0, 1);
        layout.Add(new ScrollView { Content = list }, 0, 2);
        Content = layout;
    }

    private static View SectionHeader(string title)
        => new Label
        {
            Text = title.ToUpperInvariant(), FontSize = 12,
            FontAttributes = FontAttributes.Bold, TextColor = Colors.Gray,
            Margin = new Thickness(16, 12, 16, 4),
        };

    private View ToggleRow(string title, string key, bool def)
    {
        var sw = new Switch
        {
            IsToggled = Preferences.Default.Get(key, def),
            HorizontalOptions = LayoutOptions.End,
            VerticalOptions = LayoutOptions.Center,
        };
        sw.Toggled += (_, e) =>
        {
            Preferences.Default.Set(key, e.Value);
            if (key == "ios6sim.jailbroken")
                _state.SetJailbroken(e.Value);
        };
        return SettingRow(title, sw);
    }

    private static View SliderRow(string title, string key, double def)
    {
        var slider = new Slider
        {
            Minimum = 0, Maximum = 1,
            Value = Preferences.Default.Get(key, def),
            HorizontalOptions = LayoutOptions.Fill,
            VerticalOptions = LayoutOptions.Center,
            WidthRequest = 140,
        };
        slider.ValueChanged += (_, e) => Preferences.Default.Set(key, e.NewValue);
        return SettingRow(title, slider);
    }

    private static View SettingRow(string title, View control)
    {
        var grid = new Grid
        {
            BackgroundColor = Colors.White,
            Padding = new Thickness(16, 10),
            ColumnDefinitions =
            {
                new ColumnDefinition { Width = GridLength.Star },
                new ColumnDefinition { Width = GridLength.Auto },
            },
        };
        grid.Add(new Label
        {
            Text = title, FontSize = 15,
            VerticalOptions = LayoutOptions.Center,
        }, 0, 0);
        grid.Add(control, 1, 0);
        var wrap = new VerticalStackLayout { Spacing = 0 };
        wrap.Add(grid);
        wrap.Add(new BoxView { HeightRequest = 1, BackgroundColor = Color.FromRgb(0xDD, 0xDD, 0xDD) });
        return wrap;
    }
}
