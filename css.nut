class CSS {
  rules = "";
  constructor() {
    this.rules = "";
  }

  function rule(selector, declarations) { 
    this.rules += selector + " {\n";
    foreach (property, value in declarations) {
      this.rules += "  " + property + ": " + value + ";\n";
    }
    this.rules += "}\n\n";
    return this;
  }

  function toString() {
    return this.rules;
  }

  function write(filename) {
    local content = this.toString();
    local blob = ::blob(content.len());
    foreach (char in content) {
      blob.writen(char, 'b');
    }
    
    local file = ::file(filename, "wb");
    if (file) {
      file.writeblob(blob);
      file.close();
      return true;
    }
    return false;
  }
}


return CSS;