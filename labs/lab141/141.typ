#import "../conf.typ": *
#import "@preview/physica:0.8.0": *
#import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx

#let py = toml("data.toml")

#show: conf.with(
  title: "Изучение экспериментальных погрешностей на примере физического маятника",
  number: "1.4.1",
  date: "29 сентября 2023 г.",
)

= Цели и задачи
- на примере измерения периода свободных колебаний физического маятника познакомиться с систематическими и случайными погрешностями, прямыми и косвенными измерениями
- проверить справедливость формулы для периода колебаний физического маятника и определить значение ускорения свободного падения
- убедиться в справедливости теоремы Гюйгенса об обратимости точек опоры и центра качания маятника
- оценить погрешность прямых и косвенных измерений и конечного результата.

= Оборудование
Металлический стержень с опорной призмой; дополнительный груз; закреплённая на стене консоль; подставка с острой гранью для определения цента масс маятника; секундомер; счётчик колебаний (механический или электронный); линейки металлические различной длины; штангенциркуль; электронные весы; математический маятник (небольшой груз, подвешенный на нитях).

/ Секундомер: $Delta T_"сек" = #py.dT" с"$
/ Линейка: $Delta_l = #py.dl "см"$
/ Электронные весы: $Delta_m = #py.dm" г"$

= Теория
#grid(columns: (1fr, 1fr),
figure(
  image("pendulum.png", height: 20%),
  caption: [Схема установки.]
),

figure(
  image("pendulum_weight.png", height: 20%),
  caption: [Схема установки с грузом.]
)
)
Период колебаний
$ T = 2 pi sqrt((l^2/12 + a^2)/(g (1 + m_"пр"/m_"ст") x_"ц")) $
#pagebreak(weak: true)
Ускорение свободного падения:
$ g = 4 pi^2 (J_0 + m_"г" y^2)/(T M x_"ц") $ <g>

#set math.equation(numbering: none)
= Результаты измерений

Измерим все необходимые величины:
$
&"Длина стержня:" l = #py.l pm #py.dl "см" \
&"Центр масс стержня:" l_"ц.м." = #py.x_cm pm #py.dlin "см" \
&"Расстояние от острия призмы до ц.м.:" x_"ц0" = #py.a pm #py.dlin "см" \
&"Центр масс стержня с призмой:" x_"ц.м." = #py.xp_cm pm #py.dlin "см" \

&"Масса призмы:" m_"пр" = #py.m_pr pm #py.dm" г" \
&"Масса стержня:" m_"ст" = #py.m_rod pm #py.dm" г" \
&"Масса груза:" m_"гр" = #f(py.m_wt,1) pm #py.dm" г" \
$

Момент инерции подвеса:
$ J_0 = m_"ст" dot x_"ц0"^2 + m_"ст" dot l^2 = #f(py.J0/1000/10000,3) "кг"dot"см"^2 $

Измерим период колебаний стержня без груза (@t1[таблица]):

#figure(table(columns: 5, $T, "с"$, ..py.t1.map(m)), caption: [Измерения колебаний стержня без груза.]) <t1>

Период одного колебания:

$
sigma_T = #stderr($T$) = #f(py.t1_sigma, 4)" с" \
Delta T = sqrt(sigma_T^2 + Delta_T^2) = #f(py.dt1, 3)" с" \
T = #f(py.t1_mean, 3) pm #f(py.dt1, 3)" с" approx #f(py.t1_mean, 2) pm #f(py.dt1, 2)" с"
$

// #let r = py.df.remove("раздв диск")

// #for (k, v) in py.df {
//   figure(table(
//     columns: 2,
//     align: center + horizon,
//     $N$, $t, "c."$,
//     ..v.map(((n, t)) => (n, f(t, 3))).flatten().map(m)
//   ), caption: k)
// }

Измерим период колебаний стержня с дополнительным грузом в разных положениях, результаты запишем в @Tm[таблицу].

#figure({
  // let data = py.df.map(i=>(mf((0, 1, 2, 2, 2), i))).flatten().map(m)
  let data = py.y.zip(py.df, py.Tm, py.g).map(((y, arr, tm, g)) => {
    let (n, d, t1, t2, t3) = arr
    mf((d, y, n, t1, t2, t3, tm, g), (2, 2, none, 2, 2, 2, 3, 2))
  })
  table(
    columns: 8,
    $x_"ц", "см"$, $y, "см"$, $n$, ..range(1, 4).map(i => $t_#i, "с"$), $T, "с"$, $g, "м/с"^2$,
    ..data.flatten()
)}, caption: [Измерения колебания маятника с разными положениями дополнительного груза]) <Tm>


$
y = ((m_"пр" + m_"ст" + m_"гр") dot x_"ц" - (m_"пр" + m_"ст") dot x_"ц0") / m_"гр" \
M = m_"пр" + m_"ст" + m_"гр" \
Delta y = sqrt((M dot Delta x_"ц")^2 + ((m_"пр" + m_"ст") dot Delta x_"ц0")^2) / m_"гр" \
$

== Минимум $T(y)$

#figure(
  image("p14.svg", width: 70%),
  caption: [Зависимость периода колебаний $T$ от положения груза $y$]
)

Минимум приходится на $y = #f(py.ymin,1) "см"$, что совпадает с теоретическим значением.

== Усреднение $g$
$
T_"ср" = expval(t) / N \
sigma_T = #stderr($t$) \
Delta T_"ср" = sqrt(sigma^2 + Delta_"сек"^2)/N approx #py.dTm.at(0)" с", Delta_"сек" >> sigma \
Delta g = #stderr($g$) = #f(py.gstd, 1)space"м/с"^2 \
g = #f(py.gmean,1) pm #f(py.gstd, 1)space"м/с"^2
$

Вычисление $y$ создаёт большую погрешность, из-за чего значение $g$ существенно отклоняется от его настоящего значения.


#pagebreak(weak: true)
== Метод наименьших квадратов

Из @g[формулы] следует:

$
T^2 x_"ц" = (4 pi^2) / (g M) (J_0 + m_"г" y^2) \
$

#figure(
  image("p15.svg", width: 70%),
  caption: [Зависимость $T^2 x_"цм"$ от $y^2$]
)
Метод наименьших квадратов:
$
k = (expval(x y) - expval(x) expval(y)) / (expval(x^2) - expval(x)^2) = #f(py.k,3) \
b = expval(y) - k expval(x)= #f(py.b,3) \
D_"xx" = expval(x^2) - expval(x)^2 \
sigma_k = sqrt((sum_i E_"yy"/E_"xx" - k^2)/(n-2)) = #f(py.dk,5) \
sigma_b = sigma_k sqrt(expval(x^2)) = #f(py.db,2) \
Delta g = g dot sqrt(((Delta b) / b)^2 + ((Delta M)/M)^2) \
g = (b dot (m_"пр" + m_"ст" + m_"гр")) / (4 J_0 pi^2) = 9.98 pm #f(py.dg1,2)" м/с"^2
$

Таким образом, МНК получился точнее, однако большая погрешность от вычисления $y$ всё ещё присутствует.

== Приведённая длина

$ l_"привед" = x_"ц0" + l^2/(12 x_"ц0") = #f(py.lpriv,1) "см" $

Проверим справедливость теоремы Гюйгенса: снимим призму и поместим её на расстоянии $l_"привед"$ от исходного, измерим время 20 колебаний:

$ t_"привед" = 30.59" с" $
$ T_"привед" = t_"привед" / 20 = #(30.59/20)" с" $

Что в пределах погрешности (человеческой реакции) совпадает с периодом колебаний $T$.

== Добротность

Амплитуда маятника уменьшается в два раза за $n = #py.nQ$ колебаний
$
&"Время затухания:" tau_"зат" = (n T)/(ln 2) = 5833" с" \
&"Декремент затухания:" gamma = 1/tau_"зат" = 0.00017 "Гц" \
&"Добротность:" Q = (pi n)/(ln 2) approx #f(py.Q, 0)
$

= Вывод
В работе была проверена формула периода колебаний физического маятника, опеределено значение ускорение свободного падения и оценены погрешности.

Также была проверена справедливость теоемы Гюйгенса об обратимости точке опоры и центра качания маятника.

