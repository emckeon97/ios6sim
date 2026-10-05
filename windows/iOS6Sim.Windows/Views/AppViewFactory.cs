using iOS6Sim.Windows.Apps;
using iOS6Sim.Windows.Simulator;

namespace iOS6Sim.Windows.Views;

/// <summary>Creates the in-simulator view for each app.</summary>
public static class AppViewFactory
{
    public static View Create(AppId app) => app switch
    {
        AppId.Calculator => new CalculatorView(),
        AppId.Notes => new NotesView(),
        AppId.Clock => new ClockView(),
        AppId.Settings => new SettingsView(),
        AppId.Weather => new WeatherView(),
        AppId.Reminders => new RemindersView(),
        AppId.Evasi0n => new Evasi0nView(),
        AppId.Cydia => new CydiaView(),
        _ => new PlaceholderAppView(app),
    };
}

/// <summary>Elegant stand-in for apps not yet ported: iOS 6 chrome + icon.</summary>
public sealed class PlaceholderAppView : ContentView
{
    public PlaceholderAppView(AppId app)
    {
        var state = SimState.Shared;
        var icon = new Image { WidthRequest = 80, HeightRequest = 80, Aspect = Aspect.AspectFit };
        _ = SimulatorPage.IconLoader.LoadAsync(app, icon);

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
        layout.Add(IOS6UI.NavBar(app.Title(), onBack: () => state.GoHome()), 0, 1);
        layout.Add(new VerticalStackLayout
        {
            Spacing = 12,
            VerticalOptions = LayoutOptions.Center,
            HorizontalOptions = LayoutOptions.Center,
            Children =
            {
                icon,
                new Label
                {
                    Text = app.Title(), FontSize = 20,
                    FontAttributes = FontAttributes.Bold,
                    HorizontalTextAlignment = TextAlignment.Center,
                },
                new Label
                {
                    Text = "This app is still being ported.\nThe simulator shell is fully interactive —\ntry Calculator, Notes, Clock, or Settings.",
                    FontSize = 12, TextColor = Colors.Gray,
                    HorizontalTextAlignment = TextAlignment.Center,
                },
            },
        }, 0, 2);
        Content = layout;
    }
}
