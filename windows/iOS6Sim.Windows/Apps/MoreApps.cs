using System.Text.Json;
using iOS6Sim.Windows.Simulator;
using iOS6Sim.Windows.Views;
using Microsoft.Maui.Storage;

namespace iOS6Sim.Windows.Apps;

/// <summary>iOS 6 Weather — Charlotte demo with the classic blue gradient.</summary>
public sealed class WeatherView : ContentView
{
    public WeatherView()
    {
        var state = SimState.Shared;
        var back = new Button
        {
            Text = "‹ Back to Home", BackgroundColor = Colors.Transparent,
            TextColor = Colors.White, Margin = new Thickness(0, 24, 0, 0),
            HorizontalOptions = LayoutOptions.Center,
        };
        back.Clicked += (_, _) => state.GoHome();
        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = Color.FromRgb(0x1E, 0x4A, 0x8A),
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(new VerticalStackLayout
        {
            VerticalOptions = LayoutOptions.Center,
            Spacing = 8,
            Children =
            {
                new Label { Text = "☀️", FontSize = 80, HorizontalTextAlignment = TextAlignment.Center },
                new Label { Text = "72°", FontSize = 72, FontAttributes = FontAttributes.Bold,
                            TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center },
                new Label { Text = "Charlotte, NC", FontSize = 20, TextColor = Colors.White,
                            HorizontalTextAlignment = TextAlignment.Center },
                new Label { Text = "Sunny", FontSize = 16, TextColor = Colors.White.WithAlpha(0.85f),
                            HorizontalTextAlignment = TextAlignment.Center },
                back,
            },
        }, 0, 1);
        Content = layout;
    }
}

/// <summary>iOS 6 Reminders — working checklist, persisted.</summary>
public sealed class RemindersView : ContentView
{
    private const string Key = "ios6sim.reminders";
    private readonly List<(string text, bool done)> _items = new();
    private readonly VerticalStackLayout _list = new() { Spacing = 0 };
    private readonly SimState _state = SimState.Shared;

    public RemindersView()
    {
        Load();
        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
                new RowDefinition { Height = GridLength.Auto },
            },
            BackgroundColor = Colors.White,
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(IOS6UI.NavBar("Reminders", onBack: () => _state.GoHome()), 0, 1);
        layout.Add(new ScrollView { Content = _list }, 0, 2);
        var add = new Button
        {
            Text = "+ New Reminder", BackgroundColor = IOS6UI.NavBlue,
            TextColor = Colors.White, CornerRadius = 8,
            Margin = new Thickness(16, 8),
        };
        add.Clicked += async (_, _) =>
        {
            var text = await Application.Current!.MainPage!.DisplayPromptAsync("New Reminder", "");
            if (!string.IsNullOrWhiteSpace(text))
            {
                _items.Add((text.Trim(), false));
                Save(); RenderList();
            }
        };
        layout.Add(add, 0, 3);
        RenderList();
        Content = layout;
    }

    private void RenderList()
    {
        _list.Clear();
        for (int i = 0; i < _items.Count; i++)
        {
            int idx = i;
            var (text, done) = _items[i];
            var cb = new CheckBox { IsChecked = done, VerticalOptions = LayoutOptions.Center };
            cb.CheckedChanged += (_, e) =>
            {
                _items[idx] = (_items[idx].text, e.Value);
                Save();
            };
            var label = new Label
            {
                Text = text, FontSize = 15, MaxLines = 1,
                VerticalOptions = LayoutOptions.Center,
                TextDecorations = done ? TextDecorations.Strikethrough : TextDecorations.None,
                TextColor = done ? Colors.Gray : Colors.Black,
            };
            var row = new Grid
            {
                Padding = new Thickness(16, 8),
                ColumnDefinitions =
                {
                    new ColumnDefinition { Width = GridLength.Auto },
                    new ColumnDefinition { Width = GridLength.Star },
                },
            };
            row.Add(cb, 0, 0);
            row.Add(label, 1, 0);
            _list.Add(row);
            _list.Add(new BoxView { HeightRequest = 1, BackgroundColor = Color.FromRgb(0xEE, 0xEE, 0xEE) });
        }
    }

    private void Load()
    {
        try
        {
            var json = Preferences.Default.Get(Key, "[]");
            foreach (var el in JsonSerializer.Deserialize<List<JsonElement>>(json) ?? new())
                _items.Add((el.GetProperty("t").GetString() ?? "", el.GetProperty("d").GetBoolean()));
        }
        catch { }
    }

    private void Save()
        => Preferences.Default.Set(Key, JsonSerializer.Serialize(
            _items.Select(i => new { t = i.text, d = i.done }).ToList()));
}

/// <summary>evasi0n — runs the jailbreak ritual, then installs Cydia.</summary>
public sealed class Evasi0nView : ContentView
{
    private readonly SimState _state = SimState.Shared;
    private readonly Label _status;
    private readonly ProgressBar _progress;

    public Evasi0nView()
    {
        _status = new Label
        {
            Text = "Ready to jailbreak iOS 6.1.4",
            TextColor = Colors.White, FontSize = 14,
            HorizontalTextAlignment = TextAlignment.Center,
        };
        _progress = new ProgressBar
        {
            Progress = 0, ProgressColor = Color.FromRgb(0x4C, 0xD0, 0x4C),
            Margin = new Thickness(32, 12, 32, 0),
        };
        var go = new Button
        {
            Text = "Jailbreak", FontSize = 18, FontAttributes = FontAttributes.Bold,
            BackgroundColor = Color.FromRgb(0x4C, 0xD0, 0x4C), TextColor = Colors.White,
            CornerRadius = 10, Margin = new Thickness(48, 24, 48, 0),
        };
        go.Clicked += (_, _) => _ = RunAsync(go);

        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = Colors.Black,
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(new VerticalStackLayout
        {
            VerticalOptions = LayoutOptions.Center,
            Children =
            {
                new Label { Text = "evasi0n", FontSize = 42, FontAttributes = FontAttributes.Bold,
                            TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.Center },
                new Label { Text = "iOS 6.0 – 6.1.2", FontSize = 14, TextColor = Colors.Gray,
                            HorizontalTextAlignment = TextAlignment.Center, Margin = new Thickness(0, 4, 0, 24) },
                _status, _progress, go,
            },
        }, 0, 1);
        Content = layout;
    }

    private async Task RunAsync(Button go)
    {
        go.IsEnabled = false;
        string[] steps =
        {
            "Connecting to device…", "Exploiting kernel…",
            "Patching AMFI…", "Installing Cydia…", "Cleaning up…",
        };
        for (int i = 0; i < steps.Length; i++)
        {
            _status.Text = steps[i];
            _progress.Progress = (i + 1) / (double)steps.Length;
            await Task.Delay(900);
        }
        _status.Text = "Done! Cydia is on your home screen.";
        _state.SetJailbroken(true);
        await Task.Delay(1200);
        _state.GoHome();
    }
}

/// <summary>Cydia — the jailbreak app store (browsing demo).</summary>
public sealed class CydiaView : ContentView
{
    private readonly SimState _state = SimState.Shared;

    public CydiaView()
    {
        var packages = new (string name, string desc)[]
        {
            ("WinterBoard", "Theme your icons and UI"),
            ("Barrel", "3D home-screen page effects"),
            ("SBSettings", "Quick toggles in the switcher"),
            ("Activator", "Gestures for everything"),
            ("iFile", "A file manager for iOS"),
            ("DreamBoard", "Total UI replacement themes"),
        };
        var list = new VerticalStackLayout { Spacing = 0 };
        foreach (var (name, desc) in packages)
        {
            list.Add(new Grid
            {
                Padding = new Thickness(16, 12),
                ColumnDefinitions =
                {
                    new ColumnDefinition { Width = GridLength.Star },
                    new ColumnDefinition { Width = GridLength.Auto },
                },
                Children =
                {
                    new VerticalStackLayout
                    {
                        new Label { Text = name, FontSize = 15, FontAttributes = FontAttributes.Bold },
                        new Label { Text = desc, FontSize = 12, TextColor = Colors.Gray },
                    },
                    new Label { Text = "Free", FontSize = 13, TextColor = Color.FromRgb(0x4C, 0xD0, 0x4C),
                                VerticalOptions = LayoutOptions.Center },
                },
            });
            list.Add(new BoxView { HeightRequest = 1, BackgroundColor = Color.FromRgb(0xEE, 0xEE, 0xEE) });
        }

        var layout = new Grid
        {
            RowDefinitions =
            {
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Auto },
                new RowDefinition { Height = GridLength.Star },
            },
            BackgroundColor = Color.FromRgb(0xF0, 0xE8, 0xD8),
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(IOS6UI.NavBar("Cydia", onBack: () => _state.GoHome()), 0, 1);
        layout.Add(new ScrollView { Content = list }, 0, 2);
        Content = layout;
    }
}
