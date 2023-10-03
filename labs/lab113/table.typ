#import "../conf.typ": *
#show: conf.with(title: none)

#figure({
  let data = csv("data.csv").flatten().map(float)
  let cols = 9
  let rows = calc.ceil(data.len() / cols)
  table(columns: cols, stroke: none, inset: 4pt,
  // ..($ № $, $ R, "Ом" $) * cols,
  ..for row in range(rows) {
      for col in range(cols){
          let i = col*rows + row
          ($#format(data.at(i), precision: 1)$,)
      }
  })
}, caption: [Измерения сопротивлений $270$ резисторов, Ом]) <table>

// #set page(margin: 1.5cm)

// #let format(number, precision: 2, decimal_delim: ".", thousands_delim: ",") = {
//   let integer = str(calc.floor(number))
//   if precision <= 0 {
//     return integer
//   }

//   let value = str(calc.round(number, digits: precision))
//   let from_dot = decimal_delim + if value == integer {
//     precision * "0"
//   } else {
//     let precision_diff = integer.len() + precision + decimal_delim.len() - value.len()
//     value.slice(integer.len() + 1) + precision_diff * "0"
//   }

//   let cursor = 3
//   while integer.len() > cursor {
//     integer = integer.slice(0, integer.len() - cursor) + thousands_delim + integer.slice(integer.len() - cursor, integer.len())
//     cursor += thousands_delim.len() + 3
//   }
//   integer + from_dot
// }

// #{
//     let data = csv("data.csv").flatten().map(float)
//     let cols = 9
//     let rows = calc.ceil(data.len() / cols)
//     table(columns: (4fr, 6fr) * cols,
//     ..($ N $, $ R, "Ом" $) * cols,
//     ..for row in range(rows) {
//         for col in range(cols){
//             let i = col*rows + row
//             ($ #(i+1) $, $ #format(data.at(i), precision: 1) $)
//         }
//     })
// }