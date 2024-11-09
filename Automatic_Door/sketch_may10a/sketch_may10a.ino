#define dir1 8
#define dir2 9
#define ctht1 2         // cong tac duoi
#define ctht2 3         // cong tac tren
#define cambien 4

bool temp1=0;


void UP(){
  digitalWrite(dir1,HIGH);
  digitalWrite(dir2,LOW);  
}

void DOWN(){
  digitalWrite(dir1,LOW);
  digitalWrite(dir2,HIGH);  
}

void STOP(){
  digitalWrite(dir1,LOW);
  digitalWrite(dir2,LOW);  
}

void setup() {
  pinMode(dir1, OUTPUT);
  pinMode(dir2, OUTPUT);
  pinMode(ctht1, INPUT);
  pinMode(ctht2, INPUT);
  pinMode(cambien, INPUT);
}

void loop() {
  if(digitalRead(cambien)==0||temp1==1){         // co nguoi hoac dang di xuong ma co nguoi
    while(digitalRead(ctht2)){       // di len tren
        UP(); 
    }
    if(!digitalRead(ctht2)){        // da len tren 
      STOP();
      temp1=0;
      delay(5000);             // dung va delay 5s
      
    }
  }
  else {                              // khong co nguoi
    
    while(digitalRead(ctht1)){       // di xuong
        DOWN(); 
        if(digitalRead(cambien)==0){  // dang xuong mà co nguoi
          temp1=1;
          break;  
        }
    }  
    if(!digitalRead(ctht1)){        // da xuong duoi 
      STOP();
    }  
  }

}
