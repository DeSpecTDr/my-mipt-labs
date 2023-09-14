#import "conf.typ": *
// #import "@preview/tablex:0.0.5": tablex, cellx
#import "@preview/physica:0.7.5": *

#set page(margin: 1.5cm, numbering: "1")
#set text(lang: "ru", size: 12pt)
#show math.equation: it => {
    show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
        it}
    it
}
#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    // Override equation references.
    numbering(
      el.numbering,
      ..counter(eq).at(el.location())
    )
  } else {
    // Other references as usual.
    it
  }
}
#set par(leading: 0.55em) //first-line-indent: 1.8em
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
// #show par: set block(spacing: 0.55em)
#show heading: set block(above: 1.4em, below: 1em)

// #show figure: set block(breakable: true)

#align(center)[
    = Лабораторная работа 1.1.3
    = Статистическая обработка результатов многократных измерений
    = 1 сентября 2023 г.
]

// #set heading(numbering: "1.")
#set par(justify: true)

= Цели и задачи
+ Измерение сопротивления
+ Проверка распределения Гаусса
+ Проверка закона $i$-сигм
+ Применение методов обработки экспериментальных данных при измерении сопротивлений.

= Оборудование
- Набор резисторов (270 штук)
- Универсальный цифровой вольтметр (GDM-8245), работающий в режиме "Измерение сопротивлений постоянному току":

#figure(
  table(
    columns: 3,
    [Предел], [Разрешение], [Погрешность #footnote([где $X$ --- измеряемая величина, $k$ --- единица младшего разряда])],
    $5 "кОм"$, $0.1 "Ом"$, $plus.minus (0.001 dot X +2 dot k)$
  ),
  caption: [Погрешность измерения сопротивления]
) <uncert>

= Теория
#set math.equation(numbering: "(1)")
// #show math.equation: set text(size: 14pt)
Для нахождения среднего значения сопротивления:
$ expval(R) = sum_(i=1)^N R_i $ <avg>
Для характеристики разброса случайной величины используется среднеквадратичное отклонение:
$ sigma = sqrt(1/N sum_(i=1)^N (R_i - expval(R))^2) $ <sqrt>
Используя $sigma$, можно построить функцию распределения Гаусса:
$ cal(w) = 1/(sqrt(2 pi) sigma) e^(-(R-expval(R))^2/(2 sigma^2)) $ <gauss>
#set math.equation(numbering: none)

#pagebreak(weak: true)
= Результаты измерений
Измерения сопротивлений $N = 270$ резисторов приведены в @table[таблице].

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

#figure({
    set math.equation(numbering: none)
    let data = csv("data.csv").flatten().map(float)
    let cols = 9
    let rows = calc.ceil(data.len() / cols)
    table(columns: cols, stroke: none, inset: 4pt,
    // ..($ № $, $ R, "Ом" $) * cols,
    ..for row in range(rows) {
        for col in range(cols){
            let i = col*rows + row
            ($ #format(data.at(i), precision: 1) $,)
        }
    })
}, caption: [Измерения сопротивлений $270$ резисторов, Ом], caption-pos: top) <table>

Построим гистограммы с числом столбцов $m = {10,15,20}$, ширина одного столбца $Delta R$:
$ Delta R = (R_"макс" - R_"мин")/m $
Для удобства сравнения с нормальным распределением по оси ординат будем строить плотность вероятности $cal(w)$ равную числу результатов $Delta n$, делённых на $N$ и величину интервала $Delta R$:
$ cal(w)=(Delta n)/(N Delta R) $

Среднее сопротивление по формуле @avg:
$ expval(R) = sum_(i=1)^N R_i approx 499.5 "Ом" $

Стандартное отклонение по формуле @sqrt:
$ sigma = sqrt(1/N sum_(i=1)^N (R_i - expval(R))^2) approx 1.1 "Ом" $

Инструментальная погрешность по формуле из @uncert[таблицы] составляет:
$ Delta R = 0.001 dot X +2 dot k approx 0.7 "Ом" $
Что пренебрежимо мало по сравнению с случайной прогрешностью резисторов (в 2 раза)

\
#let interv(num) = {
  [$(expval(R) plus.minus #num sigma)$]
}
Тогда, в интервал #interv(none) попадает $68.5%$ результатов, в #interv(2) попадает $95.6%$, а в #interv(3) попадает $99.6%$, что близко соответствует теоретическим вероятностям --- $68.27%$, $95.45%$, $99.97%$ соответственно (согласуется с правилом $i$-сигм).

Используя формулу @gauss, построим кривые Гаусса:
$ cal(w) = 1/(sqrt(2 pi) sigma) e^(-(R-expval(R))^2/(2 sigma^2)) $

#for i in (10, 15, 20) {
  figure(
    image("hist" + str(i) + ".svg", width: 60%),
    caption: [Гистограмма для $m = #i$],
    supplement: [Рис.]
  )
}

= Выводы
+ Измеренная величина сопротивления составляет $R = 499.5 plus.minus 1.1 "Ом"$.

+ R подчиняется распределению Гаусса.

+ В интервал #interv(none) попадает $68.5%$ результатов, в #interv(2) попадает $95.6%$, а в #interv(3) попадает $99.6%$, что близко соответствует теоретическим вероятностям --- $68.27%$, $95.45%$, $99.97%$ соответственно. Таким образом, величины всех сопротивлений укладываются в интервал #interv(4).