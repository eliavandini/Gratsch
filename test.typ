#import "src/lib.typ": config, prob

#show: config.with(
  course-name: "Course name",
  subtitle: "Assignment nr x",
  date-str: datetime(year: 2025, month: 10, day: 30).display(),
  author-info: [
    First name last name\
    email
  ],
  author-names: "First name last name",
  title-style: "simple",
  theme-name: "sketch",
  header-image-width: 25%,
  stack-spacing: 12pt,
  heading-numberings: ("{1}.", "{1}.{2:a})", none, none),
  lang: "de",
)

=
=
==
=== eiurfnwiererg
========
==
arjahfaewf
strhsththsrth
th


hs\s
hsrthsrthrshstrh
#prob(title: "Warm-up")[
  =
  Fibonacci
][
  =
  ```typ
  #let fib(n) = {
    if n in (1, 2) {
      return 1
    }
    return fib(n - 1) + fib(n - 2)
  }
  #fib(25)
  ```

  #let fib(n) = {
    if n in (1, 2) {
      return 1
    }
    return fib(n - 1) + fib(n - 2)
  }

  #fib(25)

  $
    f_n = 1 / sqrt(5) (((1 + sqrt(5)) / 2)^n - ((1 - sqrt(5)) / 2)^n)
  $

  ```typ
  #let fib(n) = {
    let lambda-1 = (1 + calc.sqrt(5)) / 2
    let lambda-2 = (1 - calc.sqrt(5)) / 2
    return calc.round((1 / calc.sqrt(5)) * calc.pow(lambda-1, n) - (1 / calc.sqrt(5)) * calc.pow(lambda-2, n))
  }
  #fib(25)
  ```

  #let fib(n) = {
    let lambda-1 = (1 + calc.sqrt(5)) / 2
    let lambda-2 = (1 - calc.sqrt(5)) / 2
    return calc.round((1 / calc.sqrt(5)) * calc.pow(lambda-1, n) - (1 / calc.sqrt(5)) * calc.pow(lambda-2, n))
  }

  #fib(25)

  =

  ```typ
  #set text(size: 8pt)
  #figure(
    table(
      columns: 10,
      $times$, ..range(1, 10).map(x => [#x]),
      ..range(1, 10).map(x => ([#x], ..range(1, 10).map(y => $#y times #x = #(x * y)$))).flatten()
    ),
  )
  ```
  #set text(size: 8pt)
  #figure(
    table(
      columns: 10,
      $times$, ..range(1, 10).map(x => [#x]),
      ..range(1, 10).map(x => ([#x], ..range(1, 10).map(y => $#y times #x = #(x * y)$))).flatten(),
    ),
  )
]
