module Forms.Utils exposing (canSubmitForm, formIsValid, resetForm, submitForm)

import Form exposing (Form)
import Form.Field
import Form.Init
import Model.Types exposing (Model)
import Set


canSubmitForm : Form.Msg -> Form e o -> Bool
canSubmitForm formMsg form =
    (formMsg == Form.Submit) && (formIsValid form)


formIsValid : Form e o -> Bool
formIsValid form =
    List.isEmpty (Form.getErrors form)


resetForm : Form e o -> Form e o
resetForm form =
    Form.update (Form.Reset []) form


submitForm :
    (Model -> Form e o)
    -> (Model -> Form e o -> Model)
    -> (Model -> Maybe String -> Model)
    -> Model
    -> Form.Msg
    -> ( Model, Bool )
submitForm formAccessor formSetter serverErrorSetter model formMsg =
    let
        newModel =
            model
                |> formAccessor
                |> Form.update formMsg
                |> formSetter model
    in
        if canSubmitForm formMsg (formAccessor newModel) then
            (,)
                { newModel | isLoading = True }
                True
        else
            (,)
                (serverErrorSetter newModel Nothing)
                False
