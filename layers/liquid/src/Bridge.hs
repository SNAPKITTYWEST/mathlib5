module MathLib5.Bridge where

import MathLib5.AST
import MathLib5.Parser

-- | Converts APL expressions to Lean 4 proof obligations
generateLeanProof :: Expr -> String
generateLeanProof expr = "theorem proof_obligation : " ++ toLean expr ++ " := by sorry"

toLean :: Expr -> String
toLean (IntVal i) = show i
toLean (Var v)    = v
toLean (App f xs) = "(" ++ toLean f ++ " " ++ unwords (map toLean xs) ++ ")"
toLean _          = "todo"
