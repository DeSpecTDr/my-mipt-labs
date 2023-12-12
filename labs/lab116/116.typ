#import "../conf.typ": *
#import "@preview/physica:0.8.1": *
#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx

#let py = loadpy(toml("data.toml"))

#show: conf.with(
  title: "Изучение электронного осциллографа",
  number: "1.1.6",
  date: "3 ноября 2023 г.",
  goal: [
    - ознакомление с устройством и работой осциллографа и изучение его основных характеристик
  ],
  tools: [
    - осциллограф
    - генераторы электрических сигналов
    - соединительные кабели
  ],
  theory: [
    #figure(
      image("1.svg", width: 80%),
      caption: [Электронно-лучевая трубка]
    )
  ]
)

#let qimage(path, caption, w: 100%, h: auto) = {
  figure(image(path, width: w, height: h), caption: caption)
}

#let br() = pagebreak(weak: true)

#set heading(numbering: none)

== 2. Измерение частоты сигнала

#pytable(py.df1, [Измерения частот сигнала с помощью осциллографа], (-0.5, 2, -0.5, -2, -2, -1, -2))

Погрешность $delta T = 0.1 "дел."$

#br()

== 3. Измерение амплитуды сигнала
$ delta U = 0.1 "дел" $
$
&"U/Div" = 5" В" #h(100pt) &U_"max" &= 4 "дел" = #py.Umax.r \
&"U/Div" = 0.005" В" &U_"min" &= 2 "дел" = #py.Umin.r
$

$ beta_21 = 20 lg U_"max"/U_"min" approx 66.0 "дБ" $

== 4. Фигуры Лисажу

#qimage("plt1.svg", [Наблюдаемые фигуры для разных отношений $nu_y:nu_x$])

#br()

== 5. Изучение амплитудно-частотной характеристики осциллографа
#grid(columns: (1fr, 1fr),
pytable(py.df2, [АЧХ при высоких \ частотах в режиме DC], (-1, 1, 2)),

pytable(py.df3, [АЧХ при низких \ частотах в режимах DC и AC], (0, 1, none, 2))
)

$
U_0 = 10" В" \
K = U / U_0

$

== 6. Изучение влияния АЧХ на искажение сигнала
Генератор частот в режиме прямоугольных испульсов.

#grid(columns: 2, 
qimage("path1.svg", [При $nu = 10 "Гц"$]),

qimage("path2.svg", [При $nu = 10 "МГц"$])
)

#br()

== 7. Измерение фазо-частотных характеристик каналов осциллографа

#pytable(py.df4, [ФЧХ], (-1, 1, 1, 1, 2, 2))

#qimage("plt2.svg", [График зависимости $phi$ от $lg nu$], w: 60%)

#set heading(numbering: "1.")
= Вывод
В результате работы мы научились работать с осциллографом в разных режимах и диапазонах, а также пронаблюдали фигуры Лисажу.