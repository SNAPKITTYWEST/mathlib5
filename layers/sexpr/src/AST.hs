module MathLib5.AST where

data SExpr
  = SInt Int
  | SFloat Double
  | SString String
  | SSymbol String
  | SList [SExpr]
  deriving (Show, Eq)

serialize :: SExpr -> String
serialize (SInt i) = show i
serialize (SFloat f) = show f
serialize (SString s) = show s
serialize (SSymbol s) = s
serialize (SList xs) = "(" ++ unwords (map serialize xs) ++ ")"
