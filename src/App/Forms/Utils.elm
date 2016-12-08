module Forms.Utils exposing (canSubmitForm, formIsValid, resetForm)

import Form exposing (Form)
import Form.Field
import Form.Init
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
