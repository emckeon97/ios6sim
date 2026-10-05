using iOS6Sim.Windows.Simulator;
using static iOS6Sim.Windows.Views.SimulatorPage;

namespace iOS6Sim.Windows.Views;

/// <summary>iOS 6 home screen: icon grid (2 pages), dock, page dots.</summary>
public sealed class HomeScreenView : ContentView
{
    private readonly SimState _state = SimState.Shared;
    private int _page;

    public HomeScreenView()
    {
        var grid = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
            },
            BackgroundColor = Color.FromRgb(0x2A, 0x3A, 0x5A), // wallpaper blue
        };
        grid.Add(IOS6UI.StatusBar(), 0, 0);

        var pager = new Grid();
        RenderPage(pager);
        grid.Add(pager, 0, 1);

        // Page dots.
        var dots = new HorizontalStackLayout
        {
            Spacing = 8, HorizontalOptions = LayoutOptions.Center,
            Margin = new Thickness(0, 4, 0, 4),
        };
        RenderDots(dots);
        grid.Add(dots, 0, 2);

        // Dock.
        var dock = new Grid
        {
            BackgroundColor = Colors.White.WithAlpha(0.25f),
            Padding = new Thickness(8, 8, 8, 12),
        };
        var dockRow = new HorizontalStackLayout
        {
            Spacing = 12, HorizontalOptions = LayoutOptions.Center,
        };
        foreach (var app in AppIdExtensions.DockApps)
            dockRow.Add(MakeIcon(app, 57));
        dock.Add(dockRow);
        grid.Add(dock, 0, 3);

        // Swipe left/right to change page.
        var swipeLeft = new SwipeGestureRecognizer { Direction = SwipeDirection.Left };
        swipeLeft.Swiped += (_, _) => { if (_page == 0) { _page = 1; RenderPage(pager); RenderDots(dots); } };
        var swipeRight = new SwipeGestureRecognizer { Direction = SwipeDirection.Right };
        swipeRight.Swiped += (_, _) => { if (_page == 1) { _page = 0; RenderPage(pager); RenderDots(dots); } };
        grid.GestureRecognizers.Add(swipeLeft);
        grid.GestureRecognizers.Add(swipeRight);

        Content = grid;
    }

    private void RenderPage(Grid pager)
    {
        pager.Clear();
        var apps = _page == 0
            ? AppIdExtensions.Page1Apps
            : (_state.IsJailbroken ? AppIdExtensions.Page2AppsJailbroken : AppIdExtensions.Page2Apps);

        var flex = new FlexLayout
        {
            Direction = FlexDirection.Row,
            Wrap = FlexWrap.Wrap,
            JustifyContent = FlexJustify.SpaceEvenly,
            AlignItems = FlexAlignItems.Start,
            Padding = new Thickness(8, 12),
        };
        foreach (var app in apps)
            flex.Add(MakeIcon(app, 57));
        pager.Add(flex);
    }

    private void RenderDots(HorizontalStackLayout dots)
    {
        dots.Clear();
        for (int i = 0; i < 2; i++)
        {
            dots.Add(new Label
            {
                Text = i == _page ? "●" : "○",
                FontSize = 10, TextColor = Colors.White,
            });
        }
    }

    private View MakeIcon(AppId app, double size)
    {
        var image = new Image
        {
            WidthRequest = size, HeightRequest = size,
            Aspect = Aspect.AspectFit,
        };
        _ = IconLoader.LoadAsync(app, image);

        var label = new Label
        {
            Text = app.Title(), FontSize = 10,
            TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center,
            MaxLines = 1,
        };
        var stack = new VerticalStackLayout
        {
            Spacing = 3, WidthRequest = size + 14,
            Children = { image, label },
        };
        var tap = new TapGestureRecognizer();
        tap.Tapped += (_, _) => _state.Open(app);
        stack.GestureRecognizers.Add(tap);
        return stack;
    }
}
