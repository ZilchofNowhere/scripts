#include <string>
using namespace std;

int main(int argc, char* const argv[]){
  if (argc < 2) {
    printf("Enter a file name.\n");
    return 1;
  }

  string file = argv[1];
  string lang = file.substr(file.rfind('.') + 1);
  string cmd;
  file = file.substr(0, file.find('.'));

  if (lang == "cpp") {
    cmd = "clang++ -std=c++2b " + file + ".cpp -o " + file + " && ./" + file;
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
