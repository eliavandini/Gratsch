#import "@preview/linguify:0.4.2": linguify, load_ftl_data
#import "@preview/numbly:0.1.0": numbly
#import "@preview/valkyrie:0.2.2" as z

#import "model.typ" as model
#import "title.typ": title-content
#import "globs.typ": languages

#let lgf_db = eval(load_ftl_data("./L10n", languages))
#let linguify = linguify.with(from: lgf_db)

/// Main document processing function
///
/// - doc (content): the whole document
/// - course-name (str): the name of the course, must be provided
/// - subtitle (str): the subtitle of the document, must be provided
/// - date-str (str): the date of the document, must be provided
/// - author-info (content): the author information, default to `[]`
/// - author-names (array | str): the array of author names, default to `""`
/// - heading-numberings (array): the heading numbering format, default to `(none, none, "(1)", "a.")`
/// - title-style (str | none): expected to be `"whole-page"`, `none` or `"simple"`, default to `"simple"`
/// - theme-name (str): the name of the theme, default to `"simple"`
/// - lang (str): the language of the document.
/// - custom-theme (any): the custom theme function, default to `none`
/// - opt (arguments): other options, including theme-specific options
/// -> doc
#let config(
  doc,
  course-name: none,
  subtitle: none,
  date-str: none,
  author-info: [],
  author-names: "",
  heading-numberings: ("{1}.", "{1}.{2:a})", none, none),
  title-style: "simple",
  theme-name: "simple",
  lang: "en",
  custom-theme: none,
  ..opt,
) = {
  let meta = (
    course-name: course-name,
    subtitle: subtitle,
    date-str: date-str,
    author-info: author-info,
    author-names: author-names,
    lang: lang,
    ..opt.named(),
  )

  title-style = z.parse(title-style, model.title-style)
  lang = z.parse(lang, model.lang)
  meta = opt.named() + z.parse(meta, model.meta-schema)
  z.parse(theme-name, model.theme-name)

  let theme = model.get-theme(theme-name)
  theme = z.parse(theme(meta), model.theme-schema, scope: (theme-name,))
  if custom-theme != none {
    theme = z.parse(custom-theme(meta), model.theme-schema, scope: ("custom-theme",))
  }

  let num-func = if type(heading-numberings) == array {
    numbly(..heading-numberings)
  } else if type(heading-numberings) == function {
    heading-numberings
  } else {
    assert(false, "Invalid heading numbering type")
  }

  return {
    // Document metadata
    set document(
      title: meta.course-name + "-" + meta.subtitle,
      author: meta.author-names,
    )

    // Heading numbering
    set heading(numbering: num-func)

    // Document language
    set text(lang: lang)

    // Page header & footer
    set page(
      header: theme.page-setting.header,
      footer: theme.page-setting.footer,
    )

    // Fonts
    set text(font: theme.fonts.text)
    show heading: set text(font: theme.fonts.heading)
    show math.equation: set text(font: theme.fonts.equation)

    // Title
    title-content(meta, theme, title-style)

    if title-style == "whole-page" {
      counter(page).update(x => x - 1)
    }

    (theme.styles)(doc)
  }
}

#let top-prob-counter = state("ichigo.top-prob-counter", 0)

#let prob(
  question,
  solution,
  title: auto,
) = {
  if title == auto {
    title = context [#linguify("problem") #top-prob-counter.get().]
  }
  return [
    #top-prob-counter.update(x => x + 1)
    = #title
    #set heading(offset: 2)
    #question
    #set heading(offset: 1)
    = #linguify("solution")
    #set heading(offset: 2)
    #solution
  ]
}
