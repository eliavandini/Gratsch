#let logo_path = "./res/UniBZ-Logo.svg"
// #let logo_str = read(logo_path).replace("920f14", "cccccc")

#let whole-page-title(meta, logo) = {
  set page(margin: 0pt, header: none, footer: none)

  // Logo
  place(
    center + top,
    dx: 40%,
    dy: 10pt,
  )[
    #set image(width: 100%)
    #logo
  ]

  // Info panel
  place(
    bottom + left,
    dx: 0pt,
    dy: -20%,
    rect(fill: rgb("cccccc"), width: 100%, height: 10pt),
  )
  place(
    bottom + left,
    dx: 24pt,
    dy: -20%,
    text(
      meta.course-name,
      size: 36pt,
      font: "Libertinus Serif",
      baseline: -0.6em,
    ),
  )
  place(
    bottom + left,
    dx: 24pt,
    dy: -20%,
    box([
      #set text(
        size: 20pt,
        font: "Libertinus Serif",
        baseline: 1em,
      )
      #set align(horizon)
      #meta.author-info
    ]),
  )
}

#let simple-title(
  meta,
  logo,
  header-image-width: 30%,
  stack-spacing: 8pt,
) = {
  set align(horizon)
  stack(
    dir: ltr,
    spacing: stack-spacing,
    {
      set image(width: header-image-width)
      logo
    },
    context line(
      length: 82pt,
      angle: 90deg,
      stroke: (
        thickness: 0.8pt,
        paint: gray.lighten(60%),
      ),
    ),
    {
      stack(
        spacing: 10pt,

        text(size: 24pt, weight: "bold")[
          #meta.course-name
        ],

        text(size: 18pt)[
          #meta.subtitle
        ],

        text(size: 12pt, font: "New Computer Modern")[
          #meta.author-info
        ],
      )
    },
  )
}

#let header = meta => {
  set text(size: 10.5pt, font: "Libertinus Serif")
  block(
    grid(
      columns: (1fr, 1fr),
      align(left + horizon, meta.course-name), align(right + horizon, meta.date-str),
    ),
  )
  place(line(length: 100%, stroke: 0.5pt), dy: 0.5em)
}

#let footer = meta => {
  let cur = context counter(page).get().at(0)
  let tot = context counter(page).final().at(0)
  return align(center)[
    #set text(size: 10.5pt)
    #cur / #tot
  ]
}



#let theme(meta) = {
  let header-image-width = if "header-image-width" in meta {
    meta.header-image-width
  } else {
    30%
  }
  let stack-spacing = if "stack-spacing" in meta {
    meta.stack-spacing
  } else {
    8pt
  }
  let logo = if "logo" in meta {
    meta.logo
  } else {
    image(logo_path, width: 100pt)
  }

  return (
    title: (
      whole-page: {
        whole-page-title(meta, logo)
        pagebreak(weak: true)
      },
      simple: {
        set align(left)
        block(
          simple-title(
            meta,
            logo,
            header-image-width: header-image-width,
            stack-spacing: stack-spacing,
          ),
        )
      },
    ),

    page-setting: (
      header: header(meta),
      footer: footer(meta),
    ),

    fonts: (
      heading: ("New Computer Modern",),
      text: ("New Computer Modern",),
      equation: ("New Computer Modern Math",),
    ),

    styles: doc => {
      set text(size: 10pt)
      set par(
        leading: 0.65em,
        spacing: 0.5em,
      )
      show par: it => block(
        inset: (left: 22pt),
      )[
        #it
      ]

      show heading.where(level: 1): it => {
        set text(size: 13pt, weight: "bold", style: "italic", fill: rgb("#0c3a6f"))
        block(above: 2em, below: 0.5em)[#it]
      }

      show heading.where(level: 2): it => {
        set text(size: 10pt, weight: "bold", fill: rgb("#3d81e7"))
        block(above: 1em, below: 0.8em)[#it]
      }

      show heading.where(level: 3): set text(size: 10pt, weight: "bold")

      doc
    },
  )
}
