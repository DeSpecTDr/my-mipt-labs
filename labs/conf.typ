#import "@preview/physica:0.8.0": expval

#let conf(
  title: "Название лабы",
  number: "0.0.0",
  date: "1 января 1970 г.",
  goal: [],
  tools: [],
  theory: [],
  body
) = {
  set document(title: number + " " + title)
  set text(lang: "ru", size: 12pt)
  set page(margin: 1.5cm, numbering: "1")
  // show math.equation: set text(size: 14pt)
  show math.equation: it => {
      show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
          it}
      it
  }
  // TODO: only number labeled equations
  set math.equation(numbering: "(1)")
  // set math.equation(numbering: (it) => {
  //   str(it)
  // })
  // show math.equation: it => {
  //   if it.at("label", default: none) != none {
  //     let l = it.at("label")
  //     let fields = (:)
  //     for (field, value) in it.fields() {
  //       if field not in ("label", "body") { fields.insert(field, value) }
  //     }
  //     [#math.equation(it.body, ..fields, numbering: "(1)")]
  //   } else {
  //     it
  //   }
  // }
  // show math.equation: it => {
  //   if it.at("label", default: none) != none {
  //     it
  //   } else {
  //     let fields = (:)
  //     for (field, value) in it.fields() {
  //       if field not in ("label", "body") { fields.insert(field, value) }
  //     }
  //     math.equation(it.body, ..fields, numbering: none)
  //   }
  // }
  // let ref_eq = counter("Referenced equations")
  // show math.equation: it => {
  //   let fields = (:)
  //   for (field, value) in it.fields() {
  //     if field not in ("numbering", "body", "label") { 
  //       fields.insert(field, value) 
  //     }
  //   }
  //   if it.at("label", default: none) != none {
  //     ref_eq.step()
  //     fields.numbering = (_) => {ref_eq.display(it.numbering)}
  //   } else {
  //     fields.numbering = none
  //   }
  //   math.equation(it.body, ..fields)
  //   // it
  // }
  
  set par(leading: 0.55em) //first-line-indent: 1.8em
  set text(font: "New Computer Modern")
  show raw: set text(font: "New Computer Modern Mono")
  // #show par: set block(spacing: 0.55em)
  show heading: set block(above: 1.4em, below: 1em)
  set heading(numbering: "1.")

  show figure.where(kind: image): it => {
    show figure.caption: it => {
      show "Рисунок": "Рис."
      it
    }
    it
  }
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  set figure.caption(separator: [. ])

  set terms(separator: [*:* ])

  // #show figure: set block(breakable: true)
  if title != none {
    align(center, text(17pt)[
      *Лабораторная работа #number \
      #title \
      #date*
    ])
  }

  set par(justify: true)

  [= Цели и задачи]
  goal

  [= Оборудование]
  tools

  [= Теория]
  theory

  // set heading(numbering: none)
  set math.equation(numbering: none)

  [= Ход работы]
  body
}

// aliases:
#let pm = math.plus.minus

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


// format
#let f(number, ..digits) = {
  let digits = digits.pos().at(0, default: none)
  if digits == none {
    return $#number$
  }
  $#format(float(number), precision: digits)$
}

// multi format
#let mf(args, digits) = {
  assert.eq(digits.len(), args.len())
  args.zip(digits).map(((v, d)) => f(v, d))
}

// let (args, kwargs) = (sink.pos(), sink.named())

// convert to math
#let m(text) = {
  $#text$
}

#let TODO(c) = {
  text(size: 20pt, "TODO " + c);
}

#let stderr(s) = $sqrt(1/(N-1) sum_i (#s _i - expval(#s))^2)$

#let loadpy(data) = {
  let rec_apply(t, f) = {
      if type(t) == dictionary {
          let temp = (:)
          for (k, v) in t.pairs() {
              temp.insert(k, rec_apply(v, f))
          }
          temp
      } else if type(t) == array {
          for v in t {
              (rec_apply(v, f),)
          }
      } else {
          f(t)
      }
  }


  let parse_py(t) = {
      if type(t) == str and t.starts-with("$") and t.ends-with("$") {
          return eval(t.slice(1, t.len()-1), mode: "math")
      }
      t
  }

  rec_apply(data, parse_py)
}

#let epssum(..sink) = {
  let args = sink.pos()
  let sum = args.map(i => {
    if type(i) == array {
      $#i.at(0) ((Delta #i.at(1))/#i.at(1))^2$
    } else {
      $((Delta #i)/#i)^2$
    }
  }).join($+$)
  $sqrt(#sum)$
}

#conf([])

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