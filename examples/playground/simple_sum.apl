⍝ Sum of squares: Σ_{k=1}^n k²
SumSquares ← { (+/ (⍳⍵) * 2) }
⍝ Expected closed form: n(n+1)(2n+1) ÷ 6
