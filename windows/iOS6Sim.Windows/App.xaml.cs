using iOS6Sim.Windows.Views;

namespace iOS6Sim.Windows;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
        MainPage = new SimulatorPage();
    }
}
