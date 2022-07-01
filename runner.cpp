#include <iostream>
using namespace std;

int main(int argc, char* const argv[]){
  if (argc < 3) {
    printf("Too few arguments.\n");
    return 1;
  }
  
  string lang = argv[1];
  string file = argv[2];
  string cmd;
    
  if (lang == "cpp" || lang == "cp") {
    cmd = "clang++ -std=c++20 " + file + ".cpp -o " + file + " && ./" + file;
  }
  
  if (lang == "c") {
    cmd = "clang " + file + ".c -o " + file + " && ./" + file;
  }
  
  if (lang == "py") {
    cmd = "python3 " + file + ".py";
  }
  
  if (lang == "js") {
    cmd = "node " + file + ".js";
  }

  if (lang == "kt") {
    cmd = "kotlinc " + file + ".kt -include-runtime -d " + file + ".jar && kotlin " + file + ".jar"; 
  }
  
  if (lang == "java") {
    cmd = "java " + file + ".java";
  }
  
  if (lang == "cs") {
    cmd = "msc " + file + ".cs && mono " + file + ".exe";
  }
  
  system(cmd.c_str());
}
