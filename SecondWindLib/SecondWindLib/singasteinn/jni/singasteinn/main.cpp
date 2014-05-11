#include "MpegDecoder.h"
#include "platform.h"
#include "TempoScaler.h"
#include <stdio.h>
#include <string>
#include "SingasteinnEngine.h"
#include "Song.h"
#include "DummyUi.h"
#include "ConfigParser.h"
const std::string testFile = "/Users/vvs/Downloads/My_Teenage_Stride_-_Dr_Dayglo.mp3";
int playerMain(int argc, char ** argv){
    
    std::string fn = testFile;
    if (argc > 1)
        fn = argv[1];

    MpegDecoder dec;
    dec.open(fn);
    TempoScaler ts(&dec);
    PlatformStreamPlayer sp;
    //fprintf(stderr, "Source: %x\n", &dec);
    sp.setSource(&ts);
    sp.play();

    
    return 0;

    //MpegDecoder dec;
    //dec.open(testFile);
    //dec.getFormat();
    //SongAnalyzer sa;
    //sa.analyze(fn);
    return 0;
    //SpecStream ss(128, 128, &dec);
//    short buf[1000];
//    FILE * f = fopen("outdata", "w");
//    for (int i=0;i<5000;i++){
////        int ret = dec.read(buf, 1000);
////        fprintf(stderr, "%d samples read\n", ret);
//        ss.computeNextStep();
//        for (int j = 0; j< 64; j++){
//            fprintf(f, "%f ", ss.getPreriodogram()[j]);
//            //int i = (buf[j] % 256) * 256 + buf[j]/256;
////            i = ((short * )buf)[j];
////            fprintf(f, "%d\n", i);
//        }
//        fprintf(f, "\n");
//    }
//    fclose(f);
//    return 0;
}

void testAnalyzer(){
//    MpegDecoder dec;
//    dec.open(testFile);
    //SongAnalyzer sa;
    //sa.analyze(testFile).print();

}

const std::string K_STEPS_INTERVAL = "accel.fake_interval";
const std::string K_INPUT = "files.input";
const std::string K_OUTPUT = "files.output";

void testEngine(std::string cfg){
    singasteinn::SingasteinnEngine eng("tempo");
    //return;

    ConfigParser p(cfg);
    if (p.isSet(K_OUTPUT))
        eng.setWavDumpPath(p.get(K_OUTPUT, "test.wav"));

    float accel_interval = p.get(K_STEPS_INTERVAL, 0.4);
    //Song s(p.get(K_INPUT, ""));
    eng.playDirectory(p.get("files.inputdir", ""));
    eng.getSensorHandler()->setOverrideStepsInterval(accel_interval);
    eng.sendMessage(singasteinn::SingasteinnEngine::MSG_START_PLAYBACK);
    eng.run();
}


int main(int argc, char ** argv){
    singasteinn::SingasteinnEngine::initializeLogging();
    //testAnalyzer();
//    DummyUI ui;
//    ui.main();

    if (argc == 2){
        testEngine(argv[1]);
    }

    return 0;

}
