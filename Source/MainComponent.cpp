/*
  ==============================================================================

    This file was auto-generated!

  ==============================================================================
*/

#include "MainComponent.h"
#include "Interop.h"


//==============================================================================
MainContentComponent::MainContentComponent() : menuBar(this)
{
    setSize (1024, 768);
    button1.setButtonText(L"Click me");
    button1.setBounds(10, 10, 50, 20);
    button1.addListener(this);
    addAndMakeVisible(&button1);
    
#if JUCE_MAC
    // Add the native menu bar on the Mac OS X platform.
    
    // Pass our class (which is a menu bar model) to the setMacMainMenu() function.
    PopupMenu appleMenu;
    appleMenu.addItem(LabelAppleInstallPlugin, "Install plugin");
    MenuBarModel::setMacMainMenu (this, &appleMenu);
#endif

}

MainContentComponent::~MainContentComponent()
{
#if JUCE_MAC
    // We must unset the the native Mac OS X menu bar as this class is destroyed
    //  since it contains the MenuBarModel that is in use.
    MenuBarModel::setMacMainMenu (nullptr);
#endif
}

void MainContentComponent::paint (Graphics& g)
{
    g.fillAll (Colour (0xffffffff));

    g.setFont (Font (16.0f));
    g.setColour (Colours::black);
    g.drawText ("Hello World! Check the Apple menu bar at the top to see the plugin install command. Also, we have help menu.", getLocalBounds(), Justification::centred, true);
}

void MainContentComponent::resized()
{
    // This is called when the MainContentComponent is resized.
    // If you add any child components, this is where you should
    // update their positions.
}

void MainContentComponent::buttonClicked(Button* button)
{
    if (button == &button1)
    {
        
    }
}

StringArray MainContentComponent::getMenuBarNames()
{
    const char* menuNames[] = { "Help", 0 };
    return StringArray (menuNames);
}

PopupMenu MainContentComponent::getMenuForIndex(int index, const String& name)
{
    PopupMenu menu;
    if (name == "Help")
    {
        menu.addItem (LabelUninstall, "Uninstall");
    }
    
    return menu;
}

void MainContentComponent::menuItemSelected (int menuID,
                                             int index)
{
    switch (menuID) {
        case LabelAppleInstallPlugin: {
            NSInterop interop;
            interop.launchHelper();
            break;
        }
        case LabelUninstall: {
            // do something
            break;
        }
    }
}
