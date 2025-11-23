---- MODULE PasswordScreen ----
EXTENDS Naturals, TLC

(***************************************************************************)
(* CONSTANTS                                                              *)
(***************************************************************************)

(*
  StoredPwd   - abstract "correct" password value
  GOOD / BAD  - abstract qualities of typed passwords
  MaxAttempts - lockout threshold for login
*)
CONSTANTS GOOD, BAD, StoredPwd, MaxAttempts

(***************************************************************************)
(* VARIABLES                                                              *)
(***************************************************************************)

(*
  ui is the full state of the password screen (login/signup)

  ui = [
    screen    |-> "login" or "signup",
    pwd       |-> an abstract password value,
    confirm   |-> confirmation password (for signup),
    submitted |-> did the user press submit?,
    attempts  |-> number of failed login attempts,
    locked    |-> is the account locked?,
    success   |-> did the login/signup succeed?,
    error     |-> an error tag
  ]
*)

VARIABLE ui

Errors ==
  {
    "None",
    "InvalidCredentials",
    "PasswordsDoNotMatch",
    "WeakPassword",
    "Locked"
  }

Screens == {"login", "signup"}

(***************************************************************************)
(* INITIAL STATE                                                          *)
(***************************************************************************)

Init ==
  /\ ui \in [
        screen    : Screens,
        pwd       : {GOOD, BAD, StoredPwd},
        confirm   : {GOOD, BAD, StoredPwd},
        submitted : {FALSE},
        attempts  : {0},
        locked    : {FALSE},
        success   : {FALSE},
        error     : {"None"}
     ]

(***************************************************************************)
(* USER INPUT ACTIONS                                                     *)
(***************************************************************************)

TypePwd(p) ==
  /\ p \in {GOOD, BAD, StoredPwd}
  /\ ui' = [ui EXCEPT
              !.pwd       = p,
              !.submitted = FALSE,
              !.success   = FALSE,
              !.error     = "None"
           ]

TypeConfirm(c) ==
  /\ ui.screen = "signup"
  /\ c \in {GOOD, BAD, StoredPwd}
  /\ ui' = [ui EXCEPT
              !.confirm   = c,
              !.submitted = FALSE,
              !.success   = FALSE,
              !.error     = "None"
           ]

ToggleScreen(s) ==
  /\ s \in Screens
  /\ ui' = [ui EXCEPT
              !.screen    = s,
              !.submitted = FALSE,
              !.success   = FALSE,
              !.error     = "None"
           ]

Submit ==
  /\ ui.submitted = FALSE
  /\ ui' = [ui EXCEPT !.submitted = TRUE]

ResetSubmit ==
  /\ ui.submitted = TRUE
  /\ ui' = [ui EXCEPT !.submitted = FALSE]

(***************************************************************************)
(* VALIDATION LOGIC (SYSTEM REACTION AFTER SUBMIT)                        *)
(***************************************************************************)

(* LOGIN ******************************************************************)

Validate_Login_Success ==
  /\ ui.screen = "login"
  /\ ui.submitted = TRUE
  /\ ~ui.locked
  /\ ui.pwd = StoredPwd
  /\ ui' = [ui EXCEPT
              !.success   = TRUE,
              !.attempts  = 0,
              !.error     = "None",
              !.submitted = FALSE
           ]

Validate_Login_Fail ==
  /\ ui.screen = "login"
  /\ ui.submitted = TRUE
  /\ ~ui.locked
  /\ ui.pwd # StoredPwd
  /\ ui.attempts + 1 < MaxAttempts
  /\ ui' = [ui EXCEPT
              !.success   = FALSE,
              !.attempts  = ui.attempts + 1,
              !.error     = "InvalidCredentials",
              !.submitted = FALSE
           ]

Validate_Login_Lock ==
  /\ ui.screen = "login"
  /\ ui.submitted = TRUE
  /\ ~ui.locked
  /\ ui.pwd # StoredPwd
  /\ ui.attempts + 1 >= MaxAttempts
  /\ ui' = [ui EXCEPT
              !.success   = FALSE,
              !.attempts  = ui.attempts + 1,
              !.locked    = TRUE,
              !.error     = "Locked",
              !.submitted = FALSE
           ]

(* SIGNUP *****************************************************************)

Validate_Signup_Success ==
  /\ ui.screen = "signup"
  /\ ui.submitted = TRUE
  /\ ui.pwd = ui.confirm
  /\ ui.pwd \in {GOOD, StoredPwd}
  /\ ui' = [ui EXCEPT
              !.success   = TRUE,
              !.error     = "None",
              !.submitted = FALSE
           ]

Validate_Signup_FailMismatch ==
  /\ ui.screen = "signup"
  /\ ui.submitted = TRUE
  /\ ui.pwd # ui.confirm
  /\ ui' = [ui EXCEPT
              !.success   = FALSE,
              !.error     = "PasswordsDoNotMatch",
              !.submitted = FALSE
           ]

Validate_Signup_Weak ==
  /\ ui.screen = "signup"
  /\ ui.submitted = TRUE
  /\ ui.pwd = BAD
  /\ ui' = [ui EXCEPT
              !.success   = FALSE,
              !.error     = "WeakPassword",
              !.submitted = FALSE
           ]

(***************************************************************************)
(* NEXT-STATE RELATION                                                    *)
(***************************************************************************)

Next ==
  \/ TypePwd(GOOD) \/ TypePwd(BAD) \/ TypePwd(StoredPwd)
  \/ TypeConfirm(GOOD) \/ TypeConfirm(BAD) \/ TypeConfirm(StoredPwd)
  \/ ToggleScreen("login") \/ ToggleScreen("signup")
  \/ Submit
  \/ ResetSubmit
  \/ Validate_Login_Success
  \/ Validate_Login_Fail
  \/ Validate_Login_Lock
  \/ Validate_Signup_Success
  \/ Validate_Signup_FailMismatch
  \/ Validate_Signup_Weak

Spec == Init /\ [][Next]_ui

(***************************************************************************)
(* INVARIANTS (SAFETY PROPERTIES)                                         *)
(***************************************************************************)

No_Contradiction ==
  ui.success = FALSE \/ ui.error = "None"

LockImpliesMaxAttempts ==
  ui.locked => ui.attempts >= MaxAttempts

LoginSuccessImpliesCorrectPwd ==
  ui.success /\ ui.screen = "login" => ui.pwd = StoredPwd

(***************************************************************************)
(* LIVENESS                                                               *)
(***************************************************************************)

Login_Correct_Leads_To_Success ==
  []( (ui.screen = "login" /\ ui.pwd = StoredPwd /\ ui.submitted = TRUE)
      => <> (ui.success = TRUE) )

==== 
