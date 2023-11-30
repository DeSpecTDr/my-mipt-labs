#import "../conf.typ": *
#import "@preview/physica:0.8.1": *
// #import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx

#let py = loadpy(toml("data.toml"))

#show: conf.with(
  title: "Определение скорости полёта пули при помощи баллистического маятника",
  number: "1.2.1",
  date: "27 октября 2023 г.",
  goal: [
    - определить скорость полёта пули, применяя законы сохранения и используя баллистические маятники
  ],
  tools: [
    - духовое ружьё на штативе
    - осветитель
    - оптическая система для измерения отклонений маятника
    - измерительная линейка
    - пули и весы для их взвешивания
    - баллистические маятники
  ],
  theory: [
    *Поступательный маятник:*

    Скорость пули:
    $ u = M/m sqrt(g/L) x $
    Погрешность:
    $ Delta u = epssum(M, m, #(0.5, $g$), #(0.5, $L$), x) $
    *Крутильный маятник:*

    Отклонение:
    $ phi approx x/d $
    $ sqrt(k I) = (4 pi M R^2 T_1)/(T_1^2 - T_2^2) $
    Скорость пули:
    $ u = phi sqrt(k I)/(m r) $
    Погрешности:
    $ Delta u = epssum(phi, m, r, (sqrt(k I))) $
    $ Delta phi = epssum(x, d) $
    $ Delta (sqrt(k I)) = epssum(M, #(2, $R$), T_1, (T_1^2 - T_2^2)) $
  ]
)

#set heading(numbering: none)

#figure(
  table(
    columns: 2,
    $N "пули"$, $m, "мг"$,
    ..py.table1.flatten().map(m)
  ),
  caption: [Масса пуль]
)

== I. Метод баллистического маятника, совершающего поступательное движение

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left),
    stroke: none,
    [Длина подвеса], $L = #py.L.r$,
    [Масса подвеса], $M = #py.M1.r$,
    [Ускорение свободного падения], $g = #py.g.r$
  ),
)

#grid(
  columns: 2,
  gutter: 10pt,
  figure(
    image("2.svg", height: 20%),
    caption: [Схема установки для измерения скорости пули]
  ),
  figure(
    image("1.svg", height: 20%),
    caption: [Установка после попадания пули]
  )
)


#figure(
  table(
    columns: 3,
    $N "пули"$, $Delta x, "см"$, $u, "м/c"$,
    ..py.table2.map(((nb, x, u)) => (m(nb), f(x,2), u.r)).flatten()
  ),
  caption: [Результаты измерений]
)

$ u = M/m sqrt(g/L) Delta x $
$ u_1 = expval(u) = #py.u1mean.r $


== II. Метод крутильного баллистичего маятника

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left),
    stroke: none,
    [Расстояние от мишени до оси], $r = #py.r.r$,
    [Расстояние от груза до оси], $R = #py.R.r$,
    [Масса груза], $M = #py.M2.r$,
    [Расстояние до шкалы], $d = #py.d.r$
  ),
)

#figure(
  image("3.svg", width: 50%),
  caption: [Схема крутильного баллистического маятника]
)

#figure(
  table(
    columns: 7,
    $N "пули"$, $N$, $t, "с"$, $T, "с"$, $x, "см"$, $phi, "рад"$, $u, "м/c"$,
    ..py.table3.map(((nb, n, t, T, dx, phi, u2)) => (m(nb), m(n), f(t,2), f(T,2), f(dx,2), f(phi,3), if u2 == u2 {
      u2.r
    } else [---])).flatten().map(m)
  ),
  caption: [Результаты измерений]
)

$ phi approx x/d $
$ sqrt(k I) = (4 pi M R^2 T_1)/(T_1^2 - T_2^2) = #py.sqrtkI.r $
$ u = phi sqrt(k I)/(m r) $
$ u_2 = expval(u) = #py.u2mean.r $

#set heading(numbering: "1.")
= Вывод
Мы измерили скорость полёта пуль духового ружья и пистолета с помощью поступательного и крутильного баллистического маятника.
$
u_1 = #py.u1mean.r \
u_2 = #py.u2mean.r \
$


