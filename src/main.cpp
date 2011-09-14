#include "testApp.h"
#include "ofAppGlutWindow.h"


testApp* ofApp;
int main() {
	ofAppGlutWindow window;
	ofSetupOpenGL(&window, 800, 600, OF_WINDOW);
	
	ofApp = new testApp();
	ofRunApp(ofApp);
}
