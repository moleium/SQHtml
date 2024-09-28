class HTML {
  title = null;
  head = null;
  body = null;
  currentElement = null;
  constructor(title = "Untitled Document") {
    this.title = title;
    this.head = [];
    this.body = [];
    this.currentElement = null;
  }

  function addHead(tag, attributes = {}) {
    this.head.push(HTMLElement(tag, attributes));
    return this;
  }

  function addBody(tag, attributes = {}) {
    local element = HTMLElement(tag, attributes);
    this.body.push(element);
    this.currentElement = element;
    return this;
  }

  function addContent(content) {
    if (this.currentElement != null) {
      if (this.currentElement.content == null) {
        this.currentElement.content = content;
      } else if (typeof this.currentElement.content == "array") {
        this.currentElement.content.push(content);
      } else { // If content is already a string, convert to array
        this.currentElement.content = [this.currentElement.content, content];
      }
    } else {
      throw "Cannot add content before adding a body element.";
    }
    return this;
  }

  function toString() {
    local headContent = "";
    foreach (element in this.head) {
      headContent += element.toString() + "\n";
    }

    local bodyContent = "";
    foreach (element in this.body) {
      bodyContent += element.toString() + "\n";
    }

    return ::format(
      "<!DOCTYPE html>\n<html>\n<head>\n<title>%s</title>\n%s</head>\n<body>\n%s</body>\n</html>",
      this.title, headContent, bodyContent
    );
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


class HTMLElement {
  tag = null;
  attributes = null;
  content = null;
  constructor(tag, attributes = {}, content = null) {
    this.tag = tag;
    this.attributes = attributes;
    this.content = content;
  }

  function addAttribute(name, value) {
    this.attributes[name] = value;
  }

  function addContent(content) {
    if (this.content == null) {
      this.content = content;
    } else if (typeof this.content == "array") {
      this.content.push(content);
    } else {
      this.content = [this.content, content];
    }
    return this;
  }

  function toString() {
    local attrStr = "";
    foreach (name, value in this.attributes) {
      attrStr += ::format(" %s=\"%s\"", name, value);
    }

    if (this.content == null) {
      return ::format("<%s%s/>", this.tag, attrStr);
    } else if (typeof this.content == "string") {
      return ::format("<%s%s>%s</%s>", this.tag, attrStr, this.content, this.tag);
    } else if (typeof this.content == "array" && this.content.len() > 0) {
      local contentStr = "";
      foreach (element in this.content) {
        contentStr += element.toString() + "\n";
      }
      return ::format("<%s%s>\n%s</%s>", this.tag, attrStr, contentStr, this.tag);
    } else {
      return ::format("<%s%s></%s>", this.tag, attrStr, this.tag);
    }
  }
}

function element(tag, attributes = {}, content = null) {
  return HTMLElement(tag, attributes, content);
}

return HTML;