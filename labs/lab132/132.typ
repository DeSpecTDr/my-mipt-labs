#import "../conf.typ": *
// #import "@preview/physica:0.8.0": *
// #import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx

// #let py = toml("data.toml")
#let py = loadpy(toml("data.toml"))

#show: conf.with(
  title: "Определение модуля кручения",
  number: "1.3.2",
  date: "13 октября 2023 г.",
)


// #let rec_apply(t, f) = {
//     if type(t) == dictionary {
//         let temp = (:)
//         for (k, v) in t.pairs() {
//             temp.insert(k, rec_apply(v, f))
//         }
//         temp
//     } else if type(t) == array {
//         for v in t {
//             rec_apply(v, f)
//         }
//     } else {
//         f(t)
//     }
// }


// #let parse_py(t) = {
//     if type(t) == str and t.starts-with("$") and t.ends-with("$") {
//         return eval(t.slice(1, t.len()-1), mode: "math")
//     }
//     t
// }
// #let py = rec_apply(py, parse_py)
// #py.mmm.n



= Цели и задачи

- измерение углов закручивания в зависимости от приложенного момента сил
- расчет модулей кручения и сдвига при статическом закручивании стержня
- определение тех же модулей для проволоки по измерениям периодов крутильных колебаний подвешенного на ней маятника (динамическим методом)

= Оборудование

*I часть:*
- исследуемый стержень (сталь)
- отсчётная труба со шкалой
- рулетка
- микрометр
- набор грузов
*II часть:*
- проволока из исследуемого материала (сталь)
- грузы
- секундомеры
- микрометр
- рулетка
- линейка

= Теория

Момент силы при деформации стержня:
$ M = (pi R^4 G)/(2l) phi = f phi $
Отсюда, модуль сдвига:
$ G = (2l)/(pi R^4) f $
Погрешности:
$ T = stderr(T) $
$ G = epssum(l, #(4, $R$), f) $

#pagebreak(weak: true)
= Результаты измерений
#set heading(numbering: none)
#set math.equation(numbering: none)

*I часть*:
#grid(columns: (2fr, 1fr), gutter: 10pt,
[Диаметр стержня:], $d_1 = #py.d_1.r $,

[Длина стержня:], $L_1 = #py.L_1.r $,

[Диаметр диска:], $D_1 = #py.D_1.r $,

)
*II часть*:

#grid(columns: (2fr, 1fr), gutter: 10pt,
[Длина груза:], $&l_2^"w" = #py.d_2.r $,

[Расстояние от оси до края центрального груза:], $&l_2^"off" = #py.L_2.r $,

[Диаметр стержня:], $&d_2 = #py.d_2.r $,

[Длина стержня:], $&L_2 = #py.L_2.r $,

[Масса одного груза:], $&m_2 = #py.m_2.r $,
)

== I. Определение модуля кручения стержня статическим методом

#figure(
    image("1.svg", width: 50%),
    caption: [Схема установки I]
)

#figure(table(
    columns: 4,
    $l, "см"$, $T_1, "с"$, $T_2, "с"$, $T_3, "с"$,
    ..py.df1.map(((l, t1, t2, t3)) => (f(l, 1), f(t1, 2), f(t2, 2), f(t3, 2))).flatten()
), caption: [Результаты измерений])

Угол отклонения:
$ phi = arctan(l/(Delta l)) $
Момент силы тяжести:
$ M = m g R $

#figure(
    image("1plot.svg", width: 70%),
    caption: [График зависимости $phi$ от $M$]
)
Методом $chi^2$:
$ k_1 = #py.k1.r $
$ f_1 = 1/k_1 = #py.f1.r $
$ G_1 = (2l)/(pi R^4) f = #py.G1.r $

== II. Определение модуля сдвига при помощи крутильных колебаний


#figure(
    image("2.svg", width: 40%),
    caption: [Схема установки II]
)

#figure(table(
    columns: 4,
    $m, "г"$, $Delta l_1, "см"$, $Delta l_2, "см"$, $Delta l_3, "см"$,
    ..py.df2.map(((m, l1, l2, l3)) => (f(m, 0), f(l1, 1), f(l2, 1), f(l3, 1))).flatten().map(m)
), caption: [Результаты измерений])

#figure(
    image("2plot.svg", width: 70%),
    caption: [График зависимости $T^2$ от $l^2$]
)

$ T^2 = (2 pi)^2/f I_0 + (2 pi)^2/f 2 m dot l^2 $
Методом $chi^2$:
$ k_2 = #py.k2.r = (2 pi)^2/f_2 2 m  $

$ f_2 = (2 pi)^2/k_2 2 m = #py.f2.r $
$ G_2 = (2l)/(pi R^4) f_2 = #py.G2.r $

#set heading(numbering: "1.")
= Выводы
Модули сдвига:
$ G_1 = #py.G1.r $
$ G_2 = #py.G2.r $

Полученные модули сдвига в пределах $2 sigma$ совпадают с настоящим значением модуля сдвига стали $G = 79.3 "ГПа"$.