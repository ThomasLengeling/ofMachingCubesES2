#include "ofApp.h"

//--------------------------------------------------------------

 string surfaceTypes[] = { "noise", "spheres", "sine^2"};

void ofApp::setup()
{
    
    glEnable(GL_DEPTH_TEST);
    
    differentSurfaces = 0;
    drawGrid = true;
    mc.setup();
    mc.setResolution(32, 32, 16);
    mc.scale.set( 500, 500, 250 );
    
    mc.setSmoothing( true );
    
    normalShader.load("shaders/normalShader.vert", "shaders/normalShader.frag");
    
}

//--------------------------------------------------------------
void ofApp::update()
{
    if(!bPause) elapsedTime = ofGetElapsedTimef();
    
    if(differentSurfaces == 0){
        //NOISE
        float noiseStep = elapsedTime * .5;
        float noiseScale = .06;
        float noiseScale2 = noiseScale * 2.;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){
                    //noise
                    float nVal = ofNoise(float(i)*noiseScale, float(j)*noiseScale, float(k)*noiseScale + noiseStep);
                    if(nVal > 0.)	nVal *= ofNoise(float(i)*noiseScale2, float(j)*noiseScale2, float(k)*noiseScale2 + noiseStep);
                    mc.setIsoValue( i, j, k, nVal );
                }
            }
        }
    }
    else if(differentSurfaces == 1){
        //SPHERES
        ofVec3f step = ofVec3f(3./mc.resX, 1.5/mc.resY, 3./mc.resZ) * PI;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){;
                    float val = sin(float(i)*step.x) * sin(float(j+elapsedTime)*step.y) * sin(float(k+elapsedTime)*step.z);
                    val *= val;
                    mc.setIsoValue( i, j, k, val );
                }
            }
        }
    }
    else if(differentSurfaces == 2){
        //SIN
        float sinScale = .5;
        for(int i=0; i<mc.resX; i++){
            for(int j=0; j<mc.resY; j++){
                for(int k=0; k<mc.resZ; k++){
                    float val = sin(float(i)*sinScale) + cos(float(j)*sinScale) + sin(float(k)*sinScale + elapsedTime);
                    mc.setIsoValue( i, j, k, val * val );
                }
            }
        }
    }
    
    //update the mesh
    mc.update();
}

//--------------------------------------------------------------
void ofApp::draw()
{
    ofClear(ofColor(0, 0, 0, 1));
    float elapsedTime = ofGetElapsedTimef();
    ofSetWindowTitle( ofToString( ofGetFrameRate() ) );
    
    glEnable(GL_DEPTH_TEST);
    ofEnableAlphaBlending();
    camera.begin();
    
    //draw the mesh
    
    ofPushMatrix();
    ofScale(250, 250, 250);
    
    ofMatrix4x4 matP = ofGetCurrentMatrix(OF_MATRIX_PROJECTION);
    ofMatrix4x4 matMV = ofGetCurrentMatrix(OF_MATRIX_MODELVIEW);
    
    ofMatrix4x4 normalMatrix = ofMatrix4x4::getTransposedOf(matMV.getInverse());
    
    normalShader.begin();
    normalShader.setUniformMatrix4f("mv", matP);
    normalShader.setUniformMatrix4f("mp", matMV);
    normalShader.setUniformMatrix4f("normalMatrix", normalMatrix);
    

    mc.draw();
    ofPopMatrix();
    
    normalShader.end();
    
    camera.end();
    glDisable(GL_DEPTH_TEST);
    ofDisableAlphaBlending();

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch)
{
    

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
