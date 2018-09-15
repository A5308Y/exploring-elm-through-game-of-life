Install Elm using the guide at https://elm-lang.org/

Enter `elm reactor` in a terminal in the checked out repo.
Then click on  `src` and `Main.elm` to start the
simulation.

You can try different shapes by changing

```
init : () -> ( Model, Cmd Msg )
init flags =
    ( acorn, Cmd.none )
```

to something like

```
init : () -> ( Model, Cmd Msg )
init flags =
    ( c10Orthogonal, Cmd.none )
```
