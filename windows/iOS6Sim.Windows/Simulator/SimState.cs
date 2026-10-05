namespace iOS6Sim.Windows.Simulator;

/// <summary>Which mini-app is open inside the simulated iPhone.</summary>
public enum AppId
{
    // Dock
    Phone, Mail, Safari, Music,
    // Page 1
    Messages, Calendar, Photos, Camera,
    Weather, Clock, Maps, Notes,
    Reminders, Stocks, Newsstand, Settings,
    // Page 2
    ITunes, AppStore, GameCenter, YouTube,
    Passbook, Compass, Evasi0n, Calculator,
    Cydia, // joins page 2 once jailbroken
}

public static class AppIdExtensions
{
    public static string Title(this AppId id) => id switch
    {
        AppId.Phone => "Phone",
        AppId.Mail => "Mail",
        AppId.Safari => "Safari",
        AppId.Music => "Music",
        AppId.Messages => "Messages",
        AppId.Calendar => "Calendar",
        AppId.Photos => "Photos",
        AppId.Camera => "Camera",
        AppId.Weather => "Weather",
        AppId.Clock => "Clock",
        AppId.Maps => "Maps",
        AppId.Notes => "Notes",
        AppId.Reminders => "Reminders",
        AppId.Stocks => "Stocks",
        AppId.Newsstand => "Newsstand",
        AppId.Settings => "Settings",
        AppId.ITunes => "iTunes",
        AppId.AppStore => "App Store",
        AppId.GameCenter => "Game Center",
        AppId.YouTube => "YouTube",
        AppId.Passbook => "Passbook",
        AppId.Compass => "Compass",
        AppId.Evasi0n => "evasi0n",
        AppId.Calculator => "Calculator",
        AppId.Cydia => "Cydia",
        _ => id.ToString(),
    };

    /// <summary>Asset file name: icon-&lt;id&gt;.png in Resources/Raw.</summary>
    public static string IconFile(this AppId id) => $"icon-{id.ToString().ToLowerInvariant()}.png";

    public static AppId[] DockApps { get; } = { AppId.Phone, AppId.Mail, AppId.Safari, AppId.Music };

    public static AppId[] Page1Apps { get; } =
    {
        AppId.Messages, AppId.Calendar, AppId.Photos, AppId.Camera,
        AppId.Weather, AppId.Clock, AppId.Maps, AppId.Notes,
        AppId.Reminders, AppId.Stocks, AppId.Newsstand, AppId.Settings,
    };

    public static AppId[] Page2Apps { get; } =
    {
        AppId.ITunes, AppId.AppStore, AppId.GameCenter, AppId.YouTube,
        AppId.Passbook, AppId.Compass, AppId.Evasi0n, AppId.Calculator,
    };

    public static AppId[] Page2AppsJailbroken { get; } =
    {
        AppId.ITunes, AppId.AppStore, AppId.GameCenter, AppId.YouTube,
        AppId.Passbook, AppId.Compass, AppId.Evasi0n, AppId.Calculator,
        AppId.Cydia,
    };
}

public enum SimScreenKind { Locked, Home, App }

/// <summary>Shared simulator state: lock/home/app, jailbreak, recents.</summary>
public sealed class SimState
{
    public static SimState Shared { get; } = new();

    public SimScreenKind ScreenKind { get; private set; } = SimScreenKind.Locked;
    public AppId CurrentApp { get; private set; }
    public List<AppId> RecentApps { get; } = new();
    public bool ShowingSwitcher { get; private set; }

    public bool IsJailbroken
    {
        get => Microsoft.Maui.Storage.Preferences.Default.Get("ios6sim.jailbroken", false);
        set => Microsoft.Maui.Storage.Preferences.Default.Set("ios6sim.jailbroken", value);
    }

    public event Action? Changed;
    private void Fire() => Changed?.Invoke();

    private DateTime _lastHomeTap = DateTime.MinValue;

    public void Unlock() { ScreenKind = SimScreenKind.Home; Fire(); }

    public void Open(AppId app)
    {
        RecentApps.Remove(app);
        RecentApps.Insert(0, app);
        if (RecentApps.Count > 12) RecentApps.RemoveRange(12, RecentApps.Count - 12);
        ShowingSwitcher = false;
        ScreenKind = SimScreenKind.App;
        CurrentApp = app;
        Fire();
    }

    public void GoHome()
    {
        ScreenKind = SimScreenKind.Home;
        ShowingSwitcher = false;
        Fire();
    }

    public void Lock()
    {
        ScreenKind = SimScreenKind.Locked;
        ShowingSwitcher = false;
        Fire();
    }

    public void ToggleSwitcher()
    {
        ShowingSwitcher = !ShowingSwitcher;
        Fire();
    }

    /// <summary>Home button: single press goes home, double-click opens the switcher.</summary>
    public void HomeButtonTap()
    {
        if (ScreenKind == SimScreenKind.Locked) return;
        var now = DateTime.UtcNow;
        if ((now - _lastHomeTap).TotalSeconds < 0.4)
        {
            _lastHomeTap = DateTime.MinValue;
            ToggleSwitcher();
        }
        else
        {
            _lastHomeTap = now;
            GoHome();
        }
    }

    public void CloseApp(AppId app)
    {
        RecentApps.Remove(app);
        if (ScreenKind == SimScreenKind.App && CurrentApp == app)
            ScreenKind = SimScreenKind.Home;
        if (RecentApps.Count == 0) ShowingSwitcher = false;
        Fire();
    }

    public void SetJailbroken(bool value)
    {
        IsJailbroken = value;
        if (!value)
        {
            RecentApps.Remove(AppId.Cydia);
            if (ScreenKind == SimScreenKind.App && CurrentApp == AppId.Cydia)
                ScreenKind = SimScreenKind.Home;
        }
        Fire();
    }
}
