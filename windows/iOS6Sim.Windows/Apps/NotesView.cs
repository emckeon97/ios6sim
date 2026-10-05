using System.Text.Json;
using iOS6Sim.Windows.Simulator;
using iOS6Sim.Windows.Views;
using Microsoft.Maui.Storage;

namespace iOS6Sim.Windows.Apps;

/// <summary>iOS 6 Notes — yellow legal pad, persisted.</summary>
public sealed class NotesView : ContentView
{
    private const string Key = "ios6sim.notes";
    private readonly List<string> _notes = new();
    private readonly VerticalStackLayout _list = new() { Spacing = 0 };
    private readonly SimState _state = SimState.Shared;

    public NotesView()
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
            BackgroundColor = Color.FromRgb(0xF7, 0xF3, 0xD8), // legal pad
        };
        layout.Add(IOS6UI.StatusBar(), 0, 0);
        layout.Add(IOS6UI.NavBar("Notes", onBack: () => _state.GoHome()), 0, 1);

        var scroll = new ScrollView { Content = _list };
        layout.Add(scroll, 0, 2);

        var add = new Button
        {
            Text = "+ New Note", FontSize = 16,
            BackgroundColor = IOS6UI.NavBlue, TextColor = Colors.White,
            CornerRadius = 8, Margin = new Thickness(16, 8),
        };
        add.Clicked += (_, _) => AddNote();
        layout.Add(add, 0, 3);

        RenderList();
        Content = layout;
    }

    private void RenderList()
    {
        _list.Clear();
        if (_notes.Count == 0)
        {
            _list.Add(new Label
            {
                Text = "No Notes", FontSize = 16, TextColor = Colors.Gray,
                HorizontalTextAlignment = TextAlignment.Center,
                Margin = new Thickness(0, 32, 0, 0),
            });
            return;
        }
        for (int i = 0; i < _notes.Count; i++)
        {
            int idx = i;
            var label = new Label
            {
                Text = _notes[i].Split('\n')[0],
                FontSize = 15, MaxLines = 1,
                Padding = new Thickness(16, 12),
            };
            var tap = new TapGestureRecognizer();
            tap.Tapped += (_, _) => EditNote(idx);
            label.GestureRecognizers.Add(tap);
            _list.Add(label);
            _list.Add(new BoxView { HeightRequest = 1, BackgroundColor = Color.FromRgb(0xE0, 0xD8, 0xB8) });
        }
    }

    private async void AddNote() => await EditNoteAsync(-1);

    private async void EditNote(int idx) => await EditNoteAsync(idx);

    private async Task EditNoteAsync(int idx)
    {
        string initial = idx >= 0 ? _notes[idx] : "";
        string? result = await Application.Current!.MainPage!.DisplayPromptAsync(
            idx >= 0 ? "Edit Note" : "New Note", "", initial: initial,
            maxLength: 2000, keyboard: Keyboard.Default);
        if (result == null) return; // cancelled
        if (idx >= 0)
        {
            if (string.IsNullOrWhiteSpace(result)) _notes.RemoveAt(idx);
            else _notes[idx] = result;
        }
        else if (!string.IsNullOrWhiteSpace(result))
        {
            _notes.Insert(0, result);
        }
        Save();
        RenderList();
    }

    private void Load()
    {
        try
        {
            var json = Preferences.Default.Get(Key, "[]");
            _notes.AddRange(JsonSerializer.Deserialize<List<string>>(json) ?? new());
        }
        catch { }
    }

    private void Save()
        => Preferences.Default.Set(Key, JsonSerializer.Serialize(_notes));
}
