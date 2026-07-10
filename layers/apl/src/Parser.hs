module MathLib5.Parser where

import Text.Megaparsec
import Text.Megaparsec.Char
import Data.Text (Text)
import qualified Data.Text as T
import Data.Void

type Parser = Parsec Void Text

data Expr
  = IntVal Int
  | FloatVal Double
  | Var String
  | Lambda [String] Expr
  | App Expr [Expr]
  | Prim String [Expr]
  deriving (Show, Eq)

parseAPL :: Text -> Either (ParseErrorBundle Text Void) Expr
parseAPL = parse (space *> pExpr <* eof) ""

pExpr :: Parser Expr
pExpr = pLambda <|> pApp <|> pTerm

pLambda :: Parser Expr
pLambda = do
  _ <- char '{'
  space
  -- Simple APL style: implicit omega or explicit args
  e <- pExpr
  space
  _ <- char '}'
  return $ Lambda ["⍵"] e

pApp :: Parser Expr
pApp = do
  t <- pTerm
  ts <- many pTerm
  if null ts then return t else return (App t ts)

pTerm :: Parser Expr
pTerm = choice
  [ IntVal . read <$> some digitChar
  , Var <$> some letterChar
  , between (char '(') (char ')') pExpr
  ]
