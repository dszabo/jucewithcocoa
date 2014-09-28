//
//  Interop.h
//  MainJuceApp
//
//  Created by Daniel Szabo on 27/09/14.
//
//

#ifndef MainJuceApp_Interop_h
#define MainJuceApp_Interop_h

class NSInterop
{
public:
    NSInterop();
    ~NSInterop();
    void launchHelper();
    static void quitHelper();
private:
    class Private;
    Private *pimpl;
};

#endif
