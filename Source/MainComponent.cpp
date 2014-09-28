/*
  ==============================================================================

    This file was auto-generated!

  ==============================================================================
*/

#include "MainComponent.h"
#include "Interop.h"


//==============================================================================
MainContentComponent::MainContentComponent()
{
    setSize (500, 400);
    button1.setButtonText(L"Click me");
    button1.setBounds(10, 10, 50, 20);
    button1.addListener(this);
    addAndMakeVisible(&button1);
}

MainContentComponent::~MainContentComponent()
{
}

void MainContentComponent::paint (Graphics& g)
{
    g.fillAll (Colour (0xffffffff));

    g.setFont (Font (16.0f));
    g.setColour (Colours::black);
    g.drawText ("Hello World!", getLocalBounds(), Justification::centred, true);
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
        NSInterop interop;
        interop.launchHelper();
    }
}
