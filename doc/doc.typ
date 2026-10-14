#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.3.0": codly, codly-init

// Scripting

#let param-table(..docs) = {
  let headers = ([Parameter], [Type], [Default], [Description])
  let items = docs
    .pos()
    .flatten()
    .chunks(headers.len())
    .map(((p, t, dv, dscr)) => (
        strong(p),
        t,
        if dv == none [None (positional parameter)] else { dv },
        dscr,
      ))
    .flatten()

  figure({
    set align(left)
    table(
      columns: (25%, 20%, 20%, 35%),
      row-gutter: 0.6em,
      stroke: none,
      table.header(..headers),
      table.hline(),
      ..items
    )
  })
}

#let dict-struct(..docs) = {
  let headers = ([Field], [Type], [Description])
  let items = docs
    .pos()
    .flatten()
    .chunks(headers.len())
    .map(((k, v, d)) => (
        strong(k),
        v,
        d,
      ))
    .flatten()

  figure({
    set align(left)
    table(
      columns: (30%, 30%, 40%),
      row-gutter: 0.6em,
      stroke: none,
      table.header(..headers),
      table.hline(),
      ..items
    )
  })
}

#let ichigo-meta = toml("../typst.toml")

// Layout

#set text(lang: "en")

#set text(font: (
  "New Computer Modern",
  "Libertinus Serif",
))

#show ref: underline
#show link: underline
#show ref: set text(fill: color.eastern)
#show link: set text(fill: color.eastern)

#show: codly-init.with()

#codly(languages: (
  typ: (
    name: "Typst",
    color: rgb("#00beb4"),
  ),
))

#set heading(numbering: numbly("1", "1.1", none, none))

// #set par(first-line-indent: 2em)

// Document

#align(center)[#text(size: 24pt)[Ichigo Homework Template v#ichigo-meta.package.version\ Translated Documentation]]

#outline(depth: 2, indent: 1em)

= Usage Notes

Please refer to the original docs form the original Ichigo repository.
These have been translated from mandarin to english using chatGPT.

Ichigo provides both a **utility library** and a **document template**.  
Users who don’t need heavy customization can simply modify the template directly.

The library exposes two functions — `config` and `prob`.  
- `config`: used to configure the document’s metadata and structure  
- `prob`: used to produce standardized question–answer blocks

= API Documentation

== `config`

=== Parameters

#param-table(
  `doc`, `content`, none, [Document content],
  `subtitle`, `str | none`, `none`, [Assignment subtitle (e.g. "Week 4 Homework"). Must be explicitly provided. Use `""` for empty.],
  `date-str`, `str | none`, `none`, [Date string. Must be explicitly provided. Use `""` for empty.],
  `theme-name`, `str`, `"simple"`, [Theme name. See @available-themes for options.],
  `title-style`, `str | none`, `"whole-page"`, [Title style — `"whole-page"`, `"simple"`, or `none`],
  `author-info`, `content`, `[]`, [Author info block, defaults to empty],
  `course-name`, `str`, `none`, [Course name. Must be explicitly provided. Use `""` for empty.],
  `author-names`, `str | array`, `""`, [Author names (list), used for document metadata. Defaults to `""`],
  `lang`, `str | none`, `"en"`, [`en`, `zh`, or `none`],
  `header-image-width`, `length`, `30%`, [Width of the image in the sketch theme's simple title.],
  `stack-spacing`, `length`, `8pt`, [Spacing between the elements in the sketch theme's simple title.],
)

=== Usage

Used inside a `show` statement to wrap the entire document as the `doc` parameter.  
Combined with Typst’s `.with` syntax, for example:

```typ
#show: config.with(
  course-name: "Advanced Typst",
  subtitle: "Homework 1",
  date-str: datetime.today().display(),
  author-names: "Elia",
  author-info: [Elia — University of Typst],
  lang: "en"
)

Write your assignment content here.
```

== `prob`

=== Parameters

#param-table(
`question`, `content`, none, [Question content],
`solution`, `content`, none, [Solution content],
`title`, `content | auto`, `auto`, [Title; defaults to auto-generated numbering],
)

=== Usage

Example:

```typ
#prob[
  Hello there
][
  Typst-loving student
]

#prob(title: [Warm-up Exercise])[
  Compute the 25th Fibonacci number.
][
  #let f(n) = {
    if n <= 2 { return 1 }
    return f(n - 1) + f(n - 2)
  }
  #f(25)
]
```

= Theme Development <theme-dev>

== Built-in Themes

#import "../src/themes.typ": THEMES
#figure(
table(
columns: (15%, 60%),
table.header([Theme Name], [Preview]),
..THEMES.map(t => (t, [Unavailable])).flatten()
),
caption: [Built-in Themes],
) <available-themes>

== Creating a Custom Theme

To create a new theme, add a file at `/src/themes/{theme_name}/lib.typ`
that defines a function named `theme`.

* `{theme_name}` corresponds to your theme’s directory name.
* You can also pass a custom function via the `custom-theme` parameter instead of using a directory.

Requirements for the `theme` function:

* Must accept one positional argument `meta` (see @struct-meta)
* Must return a dictionary in the format of @struct-theme
* Add the new theme name to the `THEMES` list in `/src/themes.typ`*

== Data Structures

=== `meta` <struct-meta>

A `dictionary` with the following fields:

#dict-struct(
`course-name`, `str`, [Course name],
`date-str`, `str`, [Date string or assignment number],
`author-info`, `content`, [Author information],
`author-names`, `str | array`, [List of author names for document metadata],
`..opt`, `dictionary`, [Other theme-related options],
)

=== `theme` <struct-theme>

A `dictionary` with the following fields:

#dict-struct(
`title`, `dictionary`, [Title configuration],
`page-setting`, `dictionary`, [Page header and footer],
`fonts`, `dictionary`, [Font settings],
`styles`, `(doc) => result`, [Optional style function; if omitted, no extra styles are applied],
)

The `title` dictionary contains:

#dict-struct(
`whole-page`, `content`, [Full-page mode],
`simple`, `content`, [Simple mode],
)

The `page-setting` dictionary contains:

#dict-struct(
`header`, `content`, [Page header],
`footer`, `content`, [Page footer],
)

The `fonts` dictionary contains:

#dict-struct(
`heading`, link(<struct-font-schema>)[`font-schema`], [Heading font],
`text`, link(<struct-font-schema>)[`font-schema`], [Body font],
`equation`, link(<struct-font-schema>)[`font-schema`], [Math font],
)

=== `font-schema` <struct-font-schema>

Can be a `str` or a `tuple`.