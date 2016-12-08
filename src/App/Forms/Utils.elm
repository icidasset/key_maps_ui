module Forms.Utils exposing (formIsValid, resetForm)

import Form exposing (Form)
import Form.Field
import Form.Init
import Set


formIsValid : Form e o -> Bool
formIsValid form =
    List.isEmpty (Form.getErrors form)


resetForm : Form e o -> Form e o
resetForm form =
    Form.update (Form.Reset []) form
