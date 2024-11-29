library my_prj.globals;

bool errState = false;

void enterErrorState() {
  errState = true;
}

void exitErrorState() {
  errState = false;
}
