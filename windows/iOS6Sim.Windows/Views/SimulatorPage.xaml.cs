using iOS6Sim.Windows.Simulator;
using Microsoft.Maui.Storage;

namespace iOS6Sim.Windows.Views;

/// <summary>
/// The simulator shell: iPhone 5 frame, screen host, home button,
/// multitasking switcher. Screen content swaps with SimState.
/// </summary>
public partial class SimulatorPage : ContentPage
{
    private readonly SimState _state = SimState.Shared;
    private View? _currentScreen;

    public SimulatorPage()
    {
        InitializeComponent();
        _state.Changed += Render;
        Render();
    }

    private void Render()
    {
        View next = _state.ScreenKind switch
        {
            SimScreenKind.Locked => new LockScreenView(),
            SimScreenKind.Home => new HomeScreenView(),
            SimScreenKind.App => AppViewFactory.Create(_state.CurrentApp),
            _ => new HomeScreenView(),
        };
        _currentScreen = next;
        ScreenHost.Content = next;
        RenderSwitcher();
    }

    private void RenderSwitcher()
    {
        SwitcherTray.IsVisible = _state.ShowingSwitcher;
        if (!_state.ShowingSwitcher) return;
        SwitcherRow.Clear();
        foreach (var app in _state.RecentApps)
        {
            var icon = new Image
            {
                WidthRequest = 57, HeightRequest = 57,
                Aspect = Aspect.AspectFit,
            };
            _ = IconLoader.LoadAsync(app, icon);
            var label = new Label
            {
                Text = app.Title(), FontSize = 9,
                TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center,
                MaxLines = 1,
            };
            var close = new Button
            {
                Text = "✕", FontSize = 10,
                WidthRequest = 24, HeightRequest = 24, CornerRadius = 12,
                BackgroundColor = Colors.DarkGray, TextColor = Colors.White,
                HorizontalOptions = LayoutOptions.Start, VerticalOptions = LayoutOptions.Start,
                Margin = new Thickness(0, -8, -8, 0),
            };
            var captured = app;
            close.Clicked += (_, _) => _state.CloseApp(captured);
            var tap = new TapGestureRecognizer();
            tap.Tapped += (_, _) => _state.Open(captured);

            var cell = new Grid { WidthRequest = 72 };
            cell.Add(icon);
            cell.Add(close);
            var stack = new VerticalStackLayout { Spacing = 4 };
            stack.Add(cell);
            stack.Add(label);
            stack.GestureRecognizers.Add(tap);
            SwitcherRow.Add(stack);
        }
    }

    private void OnHomeClicked(object? sender, EventArgs e)
        => _state.HomeButtonTap();

    /// <summary>Loads icon PNGs from Resources/Raw (icon-&lt;id&gt;.png).</summary>
    public static class IconLoader
    {
        public static async Task LoadAsync(AppId app, Image image)
        {
            try
            {
                var stream = await FileSystem.OpenAppPackageFileAsync(app.IconFile());
                image.Source = ImageSource.FromStream(() => stream);
            }
            catch
            {
                // Fallback: drawn rounded square with the initial.
                image.Source = null;
            }
        }
    }
}
