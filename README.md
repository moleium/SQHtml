# SQHtml

A Squirrel library for generating HTML and CSS.

## Usage

```squirrel
local html = require("html.nut");
local css = require("css.nut");

local doc = html.HTML("My Webpage")
  .addHead("meta", { charset: "UTF-8" })
  .addHead("title", {}, "Generated Page")
  .addBody("div", { id: "main" })
  .addContent(html.element("h1", {}, "Hello"))
  .addContent(html.element("p", {}, "This is a paragraph."))
  .addContent(html.element("a", { href: "https://www.example.com" }, "Visit Example"));

local styles = css.CSS()
  .rule("body", {
    "background-color": "#f0f0f0",
    "font-family": "sans-serif",
    "margin": "0"
  });

doc.write("example/index.html");
styles.write("example/style.css");
```