#let conf(
  title: "Название лабы",
  number: "0.0.0",
  date: "1 января 1970 г.",
  body
) = {
  set document(title: number + " " + title)
  set text(lang: "ru", size: 12pt)
  set page(margin: 1.5cm, numbering: "1")
  set math.equation(numbering: "(1)")
  // show math.equation: set text(size: 14pt)
  show math.equation: it => {
      show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
          it}
      it
  }
  // set figure.caption(separator: [.])
  set par(leading: 0.55em) //first-line-indent: 1.8em
  set text(font: "New Computer Modern")
  show raw: set text(font: "New Computer Modern Mono")
  // #show par: set block(spacing: 0.55em)
  show heading: set block(above: 1.4em, below: 1em)
  set heading(numbering: "1.")
  // #show figure.where(kind: image): set figure(supplement: [Рис.])

  // #show figure: set block(breakable: true)

  align(center, text(17pt)[
    *Лабораторная работа #number \
    #title \
    #date*
  ])

  set par(justify: true)

  body
}

#let format(number, precision: 2, decimal_delim: ".", thousands_delim: ",") = {
  let integer = str(calc.floor(number))
  if precision <= 0 {
    return integer
  }

  let value = str(calc.round(number, digits: precision))
  let from_dot = decimal_delim + if value == integer {
    precision * "0"
  } else {
    let precision_diff = integer.len() + precision + decimal_delim.len() - value.len()
    value.slice(integer.len() + 1) + precision_diff * "0"
  }

  let cursor = 3
  while integer.len() > cursor {
    integer = integer.slice(0, integer.len() - cursor) + thousands_delim + integer.slice(integer.len() - cursor, integer.len())
    cursor += thousands_delim.len() + 3
  }
  integer + from_dot
}

// #figure({
//     set math.equation(numbering: none)
//     let data = csv("data.csv").flatten().map(float)
//     let cols = 9
//     let rows = calc.ceil(data.len() / cols)
//     table(columns: (4fr, 6fr) * cols,
//     ..($ № $, $ R, "Ом" $) * cols,
//     ..for row in range(rows) {
//         for col in range(cols){
//             let i = col*rows + row
//             ($ #(i+1) $, $ #format(data.at(i), precision: 1) $)
//         }
//     })
// }, caption: [Измерения сопротивлений $270$ резисторов.], caption-pos: top) <table>

// show ref: it => {
//   let eq = math.equation
//   let el = it.element
//   if el != none and el.func() == eq {
//     // Override equation references.
//     numbering(
//       el.numbering,
//       ..counter(eq).at(el.location())
//     )
//   } else {
//     // Other references as usual.
//     it
//   }
// }